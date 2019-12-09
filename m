Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A69D116B60
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 11:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfLIKsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 05:48:32 -0500
Received: from ivanoab7.miniserver.com ([37.128.132.42]:48036 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfLIKsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 05:48:32 -0500
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1ieGab-0006Zn-PX; Mon, 09 Dec 2019 10:48:29 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1ieGaY-0004SA-Th; Mon, 09 Dec 2019 10:48:28 +0000
From:   anton.ivanov@cambridgegreys.com
To:     netdev@vger.kernel.org
Cc:     linux-um@lists.infradead.org, jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>
Subject: [PATCH] virtio: Work around frames incorrectly marked as gso
Date:   Mon,  9 Dec 2019 10:48:24 +0000
Message-Id: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anton Ivanov <anton.ivanov@cambridgegreys.com>

Some of the frames marked as GSO which arrive at
virtio_net_hdr_from_skb() have no GSO_TYPE, no
fragments (data_len = 0) and length significantly shorter
than the MTU (752 in my experiments).

This is observed on raw sockets reading off vEth interfaces
in all 4.x and 5.x kernels I tested.

These frames are reported as invalid while they are in fact
gso-less frames.

This patch marks the vnet header as no-GSO for them instead
of reporting it as invalid.

Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
---
 include/linux/virtio_net.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 0d1fe9297ac6..d90d5cff1b9a 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -112,8 +112,12 @@ static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
 			hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
 		else if (sinfo->gso_type & SKB_GSO_TCPV6)
 			hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
-		else
-			return -EINVAL;
+		else {
+			if (skb->data_len == 0)
+				hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
+			else
+				return -EINVAL;
+		}
 		if (sinfo->gso_type & SKB_GSO_TCP_ECN)
 			hdr->gso_type |= VIRTIO_NET_HDR_GSO_ECN;
 	} else
-- 
2.20.1

