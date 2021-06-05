Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423E539C9B5
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 18:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhFEQEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 12:04:00 -0400
Received: from m15113.mail.126.com ([220.181.15.113]:43423 "EHLO
        m15113.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhFEQEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 12:04:00 -0400
X-Greylist: delayed 1817 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jun 2021 12:03:59 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=P3aIecmfoywK4mYusA
        PSwpZJz/rMOG9160tktUCGrgI=; b=Qyn4F8UskAm4T1MMsebRgU8jr+6qGrh31r
        v8E78W2sstGTMbaKW86irQMEoPnFKOWOayGbSrE4tA9dZxXlbCTEm2aHui9KBgso
        vJzG5uzFW/b15jZWeU+pxkhPPc1ez4QBgO/hQ+hkeA2P+H7zYzgOiAsWth5qWux7
        inkF7YMug=
Received: from 192.168.137.133 (unknown [112.10.85.142])
        by smtp3 (Coremail) with SMTP id DcmowABHl__CmLtghDc3SA--.48781S3;
        Sat, 05 Jun 2021 23:31:15 +0800 (CST)
From:   Xianting Tian <xianting_tian@126.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: [PATCH] [v2] virtio_net: Remove BUG() to avoid machine dead
Date:   Sat,  5 Jun 2021 11:31:00 -0400
Message-Id: <1622907060-8417-1-git-send-email-xianting_tian@126.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: DcmowABHl__CmLtghDc3SA--.48781S3
X-Coremail-Antispam: 1Uf129KBjvdXoWruF18Kr4rJFyfXF1UuF4xXrb_yoW3Krc_Cr
        yxtF4fGrW5KF12k3yxCa1rZr9xt3WFvF18WwnIq3s3ua1jyFy5Xr92vrnrJry7G340yF98
        GFZxJr1v93saqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8dOz3UUUUU==
X-Originating-IP: [112.10.85.142]
X-CM-SenderInfo: h0ld03plqjs3xldqqiyswou0bp/1tbi5gSopFpEBDQX7wAAs4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xianting Tian <xianting.tian@linux.alibaba.com>

We should not directly BUG() when there is hdr error, it is
better to output a print when such error happens. Currently,
the caller of xmit_skb() already did it.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9b6a4a8..7f11ea4 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1623,7 +1623,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
 				    virtio_is_little_endian(vi->vdev), false,
 				    0))
-		BUG();
+		return -EPROTO;
 
 	if (vi->mergeable_rx_bufs)
 		hdr->num_buffers = 0;
-- 
1.8.3.1

