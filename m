Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5B95646B7
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiGCK0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbiGCK0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:26:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3457A631A
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 03:26:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7wnv-0006Ks-Cr
        for netdev@vger.kernel.org; Sun, 03 Jul 2022 12:26:15 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D1042A698B
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 10:14:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E91B0A6972;
        Sun,  3 Jul 2022 10:14:34 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b70888b9;
        Sun, 3 Jul 2022 10:14:31 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 06/15] can: slcan: use the alloc_can_skb() helper
Date:   Sun,  3 Jul 2022 12:14:20 +0200
Message-Id: <20220703101430.1306048-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220703101430.1306048-1-mkl@pengutronix.de>
References: <20220703101430.1306048-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

It is used successfully by most (if not all) CAN device drivers. It
allows to remove replicated code.

Link: https://lore.kernel.org/all/20220628163137.413025-4-dario.binacchi@amarulasolutions.com
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Tested-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan.c | 70 +++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 6162a9c21672..c39580b142e0 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -54,6 +54,7 @@
 #include <linux/kernel.h>
 #include <linux/workqueue.h>
 #include <linux/can.h>
+#include <linux/can/dev.h>
 #include <linux/can/skb.h>
 #include <linux/can/can-ml.h>
 
@@ -143,85 +144,80 @@ static struct net_device **slcan_devs;
 static void slc_bump(struct slcan *sl)
 {
 	struct sk_buff *skb;
-	struct can_frame cf;
+	struct can_frame *cf;
 	int i, tmp;
 	u32 tmpid;
 	char *cmd = sl->rbuff;
 
-	memset(&cf, 0, sizeof(cf));
+	skb = alloc_can_skb(sl->dev, &cf);
+	if (unlikely(!skb)) {
+		sl->dev->stats.rx_dropped++;
+		return;
+	}
 
 	switch (*cmd) {
 	case 'r':
-		cf.can_id = CAN_RTR_FLAG;
+		cf->can_id = CAN_RTR_FLAG;
 		fallthrough;
 	case 't':
 		/* store dlc ASCII value and terminate SFF CAN ID string */
-		cf.len = sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN];
+		cf->len = sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN];
 		sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN] = 0;
 		/* point to payload data behind the dlc */
 		cmd += SLC_CMD_LEN + SLC_SFF_ID_LEN + 1;
 		break;
 	case 'R':
-		cf.can_id = CAN_RTR_FLAG;
+		cf->can_id = CAN_RTR_FLAG;
 		fallthrough;
 	case 'T':
-		cf.can_id |= CAN_EFF_FLAG;
+		cf->can_id |= CAN_EFF_FLAG;
 		/* store dlc ASCII value and terminate EFF CAN ID string */
-		cf.len = sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN];
+		cf->len = sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN];
 		sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN] = 0;
 		/* point to payload data behind the dlc */
 		cmd += SLC_CMD_LEN + SLC_EFF_ID_LEN + 1;
 		break;
 	default:
-		return;
+		goto decode_failed;
 	}
 
 	if (kstrtou32(sl->rbuff + SLC_CMD_LEN, 16, &tmpid))
-		return;
+		goto decode_failed;
 
-	cf.can_id |= tmpid;
+	cf->can_id |= tmpid;
 
 	/* get len from sanitized ASCII value */
-	if (cf.len >= '0' && cf.len < '9')
-		cf.len -= '0';
+	if (cf->len >= '0' && cf->len < '9')
+		cf->len -= '0';
 	else
-		return;
+		goto decode_failed;
 
 	/* RTR frames may have a dlc > 0 but they never have any data bytes */
-	if (!(cf.can_id & CAN_RTR_FLAG)) {
-		for (i = 0; i < cf.len; i++) {
+	if (!(cf->can_id & CAN_RTR_FLAG)) {
+		for (i = 0; i < cf->len; i++) {
 			tmp = hex_to_bin(*cmd++);
 			if (tmp < 0)
-				return;
-			cf.data[i] = (tmp << 4);
+				goto decode_failed;
+
+			cf->data[i] = (tmp << 4);
 			tmp = hex_to_bin(*cmd++);
 			if (tmp < 0)
-				return;
-			cf.data[i] |= tmp;
+				goto decode_failed;
+
+			cf->data[i] |= tmp;
 		}
 	}
 
-	skb = dev_alloc_skb(sizeof(struct can_frame) +
-			    sizeof(struct can_skb_priv));
-	if (!skb)
-		return;
-
-	skb->dev = sl->dev;
-	skb->protocol = htons(ETH_P_CAN);
-	skb->pkt_type = PACKET_BROADCAST;
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
-
-	can_skb_reserve(skb);
-	can_skb_prv(skb)->ifindex = sl->dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
-
-	skb_put_data(skb, &cf, sizeof(struct can_frame));
-
 	sl->dev->stats.rx_packets++;
-	if (!(cf.can_id & CAN_RTR_FLAG))
-		sl->dev->stats.rx_bytes += cf.len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		sl->dev->stats.rx_bytes += cf->len;
 
 	netif_rx(skb);
+	return;
+
+decode_failed:
+	sl->dev->stats.rx_errors++;
+	dev_kfree_skb(skb);
 }
 
 /* parse tty input stream */
-- 
2.35.1


