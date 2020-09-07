Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB28625FF8C
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgIGQe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:34:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730706AbgIGQdq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F324D21973;
        Mon,  7 Sep 2020 16:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496425;
        bh=DQStx84wRCR858eSj4SlXl+1fOQIorfqYYtci96Ys4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2JdCyT/lpL/UC4Xk5M4bjFfgBkEiVg4P87V7F5krfJNfBsdPNr0wasLrw55BXGfH
         65d6k6SJfZmvNwcH7wHCQCQf2TMwwAoxi9BcF2aNVjGYBYQrsgqfm4EeyRGybHyl10
         fLGFNzQrwOdHvJev8l3Uh6gjadDPn1HZAoYqM4BM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yi Li <yili@winhong.com>, Li Bing <libing@winhong.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/43] net: hns3: Fix for geneve tx checksum bug
Date:   Mon,  7 Sep 2020 12:32:58 -0400
Message-Id: <20200907163329.1280888-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163329.1280888-1-sashal@kernel.org>
References: <20200907163329.1280888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yi Li <yili@winhong.com>

[ Upstream commit a156998fc92d3859c8e820f1583f6d0541d643c3 ]

when skb->encapsulation is 0, skb->ip_summed is CHECKSUM_PARTIAL
and it is udp packet, which has a dest port as the IANA assigned.
the hardware is expected to do the checksum offload, but the
hardware will not do the checksum offload when udp dest port is
6081.

This patch fixes it by doing the checksum in software.

Reported-by: Li Bing <libing@winhong.com>
Signed-off-by: Yi Li <yili@winhong.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a8ce6ca0f5081..92af7204711c8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -21,6 +21,7 @@
 #include <net/pkt_cls.h>
 #include <net/tcp.h>
 #include <net/vxlan.h>
+#include <net/geneve.h>
 
 #include "hnae3.h"
 #include "hns3_enet.h"
@@ -795,7 +796,7 @@ static int hns3_get_l4_protocol(struct sk_buff *skb, u8 *ol4_proto,
  * and it is udp packet, which has a dest port as the IANA assigned.
  * the hardware is expected to do the checksum offload, but the
  * hardware will not do the checksum offload when udp dest port is
- * 4789.
+ * 4789 or 6081.
  */
 static bool hns3_tunnel_csum_bug(struct sk_buff *skb)
 {
@@ -804,7 +805,8 @@ static bool hns3_tunnel_csum_bug(struct sk_buff *skb)
 	l4.hdr = skb_transport_header(skb);
 
 	if (!(!skb->encapsulation &&
-	      l4.udp->dest == htons(IANA_VXLAN_UDP_PORT)))
+	      (l4.udp->dest == htons(IANA_VXLAN_UDP_PORT) ||
+	      l4.udp->dest == htons(GENEVE_UDP_PORT))))
 		return false;
 
 	skb_checksum_help(skb);
-- 
2.25.1

