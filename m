Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA50C3DA4
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbfJARBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729864AbfJAQkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:40:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A5E421D7B;
        Tue,  1 Oct 2019 16:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948022;
        bh=Yxl65tRtauaDS2ACA8wLQ/MJvNUzQFwwxmwfmyU6yTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WxSgBK8cHhX/JWMydQyZshLeRPckglYpUHcpab5rl9dK3PU8QNcyq5QTFbw4QvCr9
         uxEPyK1HF2pwakikqpE+0SFuFchqJUEZKWD0B9lvSQ3r+a3NWzWuUW00PnZ6uhjQjb
         nZpO17XPgj2qu+dKF7inHPUIAvzkb8Fhf1XMi8+g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 42/71] arcnet: provide a buffer big enough to actually receive packets
Date:   Tue,  1 Oct 2019 12:38:52 -0400
Message-Id: <20191001163922.14735-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 02a07046834e64970f3bcd87a422ac2b0adb80de ]

struct archdr is only big enough to hold the header of various types of
arcnet packets. So to provide enough space to hold the data read from
hardware provide a buffer large enough to hold a packet with maximal
size.

The problem was noticed by the stack protector which makes the kernel
oops.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/arcnet/arcnet.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index 8459115d9d4e5..553776cc1d29d 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -1063,31 +1063,34 @@ EXPORT_SYMBOL(arcnet_interrupt);
 static void arcnet_rx(struct net_device *dev, int bufnum)
 {
 	struct arcnet_local *lp = netdev_priv(dev);
-	struct archdr pkt;
+	union {
+		struct archdr pkt;
+		char buf[512];
+	} rxdata;
 	struct arc_rfc1201 *soft;
 	int length, ofs;
 
-	soft = &pkt.soft.rfc1201;
+	soft = &rxdata.pkt.soft.rfc1201;
 
-	lp->hw.copy_from_card(dev, bufnum, 0, &pkt, ARC_HDR_SIZE);
-	if (pkt.hard.offset[0]) {
-		ofs = pkt.hard.offset[0];
+	lp->hw.copy_from_card(dev, bufnum, 0, &rxdata.pkt, ARC_HDR_SIZE);
+	if (rxdata.pkt.hard.offset[0]) {
+		ofs = rxdata.pkt.hard.offset[0];
 		length = 256 - ofs;
 	} else {
-		ofs = pkt.hard.offset[1];
+		ofs = rxdata.pkt.hard.offset[1];
 		length = 512 - ofs;
 	}
 
 	/* get the full header, if possible */
-	if (sizeof(pkt.soft) <= length) {
-		lp->hw.copy_from_card(dev, bufnum, ofs, soft, sizeof(pkt.soft));
+	if (sizeof(rxdata.pkt.soft) <= length) {
+		lp->hw.copy_from_card(dev, bufnum, ofs, soft, sizeof(rxdata.pkt.soft));
 	} else {
-		memset(&pkt.soft, 0, sizeof(pkt.soft));
+		memset(&rxdata.pkt.soft, 0, sizeof(rxdata.pkt.soft));
 		lp->hw.copy_from_card(dev, bufnum, ofs, soft, length);
 	}
 
 	arc_printk(D_DURING, dev, "Buffer #%d: received packet from %02Xh to %02Xh (%d+4 bytes)\n",
-		   bufnum, pkt.hard.source, pkt.hard.dest, length);
+		   bufnum, rxdata.pkt.hard.source, rxdata.pkt.hard.dest, length);
 
 	dev->stats.rx_packets++;
 	dev->stats.rx_bytes += length + ARC_HDR_SIZE;
@@ -1096,13 +1099,13 @@ static void arcnet_rx(struct net_device *dev, int bufnum)
 	if (arc_proto_map[soft->proto]->is_ip) {
 		if (BUGLVL(D_PROTO)) {
 			struct ArcProto
-			*oldp = arc_proto_map[lp->default_proto[pkt.hard.source]],
+			*oldp = arc_proto_map[lp->default_proto[rxdata.pkt.hard.source]],
 			*newp = arc_proto_map[soft->proto];
 
 			if (oldp != newp) {
 				arc_printk(D_PROTO, dev,
 					   "got protocol %02Xh; encap for host %02Xh is now '%c' (was '%c')\n",
-					   soft->proto, pkt.hard.source,
+					   soft->proto, rxdata.pkt.hard.source,
 					   newp->suffix, oldp->suffix);
 			}
 		}
@@ -1111,10 +1114,10 @@ static void arcnet_rx(struct net_device *dev, int bufnum)
 		lp->default_proto[0] = soft->proto;
 
 		/* in striking contrast, the following isn't a hack. */
-		lp->default_proto[pkt.hard.source] = soft->proto;
+		lp->default_proto[rxdata.pkt.hard.source] = soft->proto;
 	}
 	/* call the protocol-specific receiver. */
-	arc_proto_map[soft->proto]->rx(dev, bufnum, &pkt, length);
+	arc_proto_map[soft->proto]->rx(dev, bufnum, &rxdata.pkt, length);
 }
 
 static void null_rx(struct net_device *dev, int bufnum,
-- 
2.20.1

