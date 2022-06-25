Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63ED255A9C0
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbiFYMGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbiFYMG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3DA1707D
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YN-0002Xi-5b
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:19 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7A24E9F1E9
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:04:41 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 54FF99F19D;
        Sat, 25 Jun 2022 12:04:02 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id fc963770;
        Sat, 25 Jun 2022 12:03:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        kernel test robot <lkp@intel.com>,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 10/22] can: skb: move can_dropped_invalid_skb() and can_skb_headroom_valid() to skb.c
Date:   Sat, 25 Jun 2022 14:03:23 +0200
Message-Id: <20220625120335.324697-11-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220625120335.324697-1-mkl@pengutronix.de>
References: <20220625120335.324697-1-mkl@pengutronix.de>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The functions can_dropped_invalid_skb() and can_skb_headroom_valid()
grew a lot over the years to a point which it does not make much sense
to have them defined as static inline in header files. Move those two
functions to the .c counterpart of skb.h.

can_skb_headroom_valid()'s only caller being
can_dropped_invalid_skb(), the declaration is removed from the
header. Only can_dropped_invalid_skb() gets its symbol exported.

While doing so, do a small cleanup: add brackets around the else block
in can_dropped_invalid_skb().

Link: https://lore.kernel.org/all/20220610143009.323579-7-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Max Staudt <max@enpas.org>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/skb.c | 58 ++++++++++++++++++++++++++++++++++++++
 include/linux/can/skb.h   | 59 +--------------------------------------
 2 files changed, 59 insertions(+), 58 deletions(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index a4208f125b76..dc9da76c0470 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -259,3 +259,61 @@ struct sk_buff *alloc_can_err_skb(struct net_device *dev, struct can_frame **cf)
 	return skb;
 }
 EXPORT_SYMBOL_GPL(alloc_can_err_skb);
+
+/* Check for outgoing skbs that have not been created by the CAN subsystem */
+static bool can_skb_headroom_valid(struct net_device *dev, struct sk_buff *skb)
+{
+	/* af_packet creates a headroom of HH_DATA_MOD bytes which is fine */
+	if (WARN_ON_ONCE(skb_headroom(skb) < sizeof(struct can_skb_priv)))
+		return false;
+
+	/* af_packet does not apply CAN skb specific settings */
+	if (skb->ip_summed == CHECKSUM_NONE) {
+		/* init headroom */
+		can_skb_prv(skb)->ifindex = dev->ifindex;
+		can_skb_prv(skb)->skbcnt = 0;
+
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+		/* perform proper loopback on capable devices */
+		if (dev->flags & IFF_ECHO)
+			skb->pkt_type = PACKET_LOOPBACK;
+		else
+			skb->pkt_type = PACKET_HOST;
+
+		skb_reset_mac_header(skb);
+		skb_reset_network_header(skb);
+		skb_reset_transport_header(skb);
+	}
+
+	return true;
+}
+
+/* Drop a given socketbuffer if it does not contain a valid CAN frame. */
+bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
+{
+	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
+
+	if (skb->protocol == htons(ETH_P_CAN)) {
+		if (unlikely(skb->len != CAN_MTU ||
+			     cfd->len > CAN_MAX_DLEN))
+			goto inval_skb;
+	} else if (skb->protocol == htons(ETH_P_CANFD)) {
+		if (unlikely(skb->len != CANFD_MTU ||
+			     cfd->len > CANFD_MAX_DLEN))
+			goto inval_skb;
+	} else {
+		goto inval_skb;
+	}
+
+	if (!can_skb_headroom_valid(dev, skb))
+		goto inval_skb;
+
+	return false;
+
+inval_skb:
+	kfree_skb(skb);
+	dev->stats.tx_dropped++;
+	return true;
+}
+EXPORT_SYMBOL_GPL(can_dropped_invalid_skb);
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index fdb22b00674a..182749e858b3 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -31,6 +31,7 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
 				struct canfd_frame **cfd);
 struct sk_buff *alloc_can_err_skb(struct net_device *dev,
 				  struct can_frame **cf);
+bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb);
 
 /*
  * The struct can_skb_priv is used to transport additional information along
@@ -96,64 +97,6 @@ static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb)
 	return nskb;
 }
 
-/* Check for outgoing skbs that have not been created by the CAN subsystem */
-static inline bool can_skb_headroom_valid(struct net_device *dev,
-					  struct sk_buff *skb)
-{
-	/* af_packet creates a headroom of HH_DATA_MOD bytes which is fine */
-	if (WARN_ON_ONCE(skb_headroom(skb) < sizeof(struct can_skb_priv)))
-		return false;
-
-	/* af_packet does not apply CAN skb specific settings */
-	if (skb->ip_summed == CHECKSUM_NONE) {
-		/* init headroom */
-		can_skb_prv(skb)->ifindex = dev->ifindex;
-		can_skb_prv(skb)->skbcnt = 0;
-
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-
-		/* perform proper loopback on capable devices */
-		if (dev->flags & IFF_ECHO)
-			skb->pkt_type = PACKET_LOOPBACK;
-		else
-			skb->pkt_type = PACKET_HOST;
-
-		skb_reset_mac_header(skb);
-		skb_reset_network_header(skb);
-		skb_reset_transport_header(skb);
-	}
-
-	return true;
-}
-
-/* Drop a given socketbuffer if it does not contain a valid CAN frame. */
-static inline bool can_dropped_invalid_skb(struct net_device *dev,
-					  struct sk_buff *skb)
-{
-	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
-
-	if (skb->protocol == htons(ETH_P_CAN)) {
-		if (unlikely(skb->len != CAN_MTU ||
-			     cfd->len > CAN_MAX_DLEN))
-			goto inval_skb;
-	} else if (skb->protocol == htons(ETH_P_CANFD)) {
-		if (unlikely(skb->len != CANFD_MTU ||
-			     cfd->len > CANFD_MAX_DLEN))
-			goto inval_skb;
-	} else
-		goto inval_skb;
-
-	if (!can_skb_headroom_valid(dev, skb))
-		goto inval_skb;
-
-	return false;
-
-inval_skb:
-	kfree_skb(skb);
-	dev->stats.tx_dropped++;
-	return true;
-}
-
 static inline bool can_is_canfd_skb(const struct sk_buff *skb)
 {
 	/* the CAN specific type of skb is identified by its data length */
-- 
2.35.1


