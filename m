Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE44B9166
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 16:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387562AbfITOIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 10:08:34 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54559 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfITOId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 10:08:33 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1iBJaI-0005V1-Fd; Fri, 20 Sep 2019 16:08:30 +0200
Received: from ukl by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1iBJaG-00036I-EW; Fri, 20 Sep 2019 16:08:28 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] arcnet: provide a buffer big enough to actually receive packets
Date:   Fri, 20 Sep 2019 16:08:21 +0200
Message-Id: <20190920140821.11876-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct archdr is only big enough to hold the header of various types of
arcnet packets. So to provide enough space to hold the data read from
hardware provide a buffer large enough to hold a packet with maximal
size.

The problem was noticed by the stack protector which makes the kernel
oops.

Cc: stable@vger.kernel.org # v2.4.0+
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

the problem exists in v2.4.0 already, I didn't look further to identify
the offending commit.

Best regards
Uwe
---
 drivers/net/arcnet/arcnet.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index 0efef7aa5b89..2b8cf58e4de0 100644
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
2.23.0

