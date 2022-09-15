Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2B55B9644
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiIOIWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiIOIVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:21:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAB498342
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 01:20:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oYk6u-0004Zb-Ak
        for netdev@vger.kernel.org; Thu, 15 Sep 2022 10:20:36 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 56CB5E39DC
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:20:20 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 42818E3949;
        Thu, 15 Sep 2022 08:20:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id aab32050;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 17/23] can: skb: unify skb CAN frame identification helpers
Date:   Thu, 15 Sep 2022 10:20:07 +0200
Message-Id: <20220915082013.369072-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220915082013.369072-1-mkl@pengutronix.de>
References: <20220915082013.369072-1-mkl@pengutronix.de>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

Replace open coded checks for sk_buffs containing Classical CAN and
CAN FD frame structures as a preparation for CAN XL support.

With the added length check the unintended processing of CAN XL frames
having the CANXL_XLF bit set can be suppressed even when the skb->len
fits to non CAN XL frames.

The CAN_RAW socket needs a rework to use these helpers. Therefore the
use of these helpers is postponed to the CAN_RAW CAN XL integration.

The J1939 protocol gets a check for Classical CAN frames too.

Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20220912170725.120748-2-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/skb.c | 18 +++++++-------
 include/linux/can/skb.h   | 12 +++++++++-
 net/can/af_can.c          | 50 ++++++++-------------------------------
 net/can/bcm.c             |  9 +++++--
 net/can/gw.c              |  4 ++--
 net/can/isotp.c           |  2 +-
 net/can/j1939/main.c      |  4 ++++
 7 files changed, 45 insertions(+), 54 deletions(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 07e0feac8629..f457c94ba82f 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -299,18 +299,20 @@ static bool can_skb_headroom_valid(struct net_device *dev, struct sk_buff *skb)
 /* Drop a given socketbuffer if it does not contain a valid CAN frame. */
 bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 {
-	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 	struct can_priv *priv = netdev_priv(dev);
 
-	if (skb->protocol == htons(ETH_P_CAN)) {
-		if (unlikely(skb->len != CAN_MTU ||
-			     cfd->len > CAN_MAX_DLEN))
+	switch (ntohs(skb->protocol)) {
+	case ETH_P_CAN:
+		if (!can_is_can_skb(skb))
 			goto inval_skb;
-	} else if (skb->protocol == htons(ETH_P_CANFD)) {
-		if (unlikely(skb->len != CANFD_MTU ||
-			     cfd->len > CANFD_MAX_DLEN))
+		break;
+
+	case ETH_P_CANFD:
+		if (!can_is_canfd_skb(skb))
 			goto inval_skb;
-	} else {
+		break;
+
+	default:
 		goto inval_skb;
 	}
 
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index 182749e858b3..27ebfc28510f 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -97,10 +97,20 @@ static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb)
 	return nskb;
 }
 
+static inline bool can_is_can_skb(const struct sk_buff *skb)
+{
+	struct can_frame *cf = (struct can_frame *)skb->data;
+
+	/* the CAN specific type of skb is identified by its data length */
+	return (skb->len == CAN_MTU && cf->len <= CAN_MAX_DLEN);
+}
+
 static inline bool can_is_canfd_skb(const struct sk_buff *skb)
 {
+	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
+
 	/* the CAN specific type of skb is identified by its data length */
-	return skb->len == CANFD_MTU;
+	return (skb->len == CANFD_MTU && cfd->len <= CANFD_MAX_DLEN);
 }
 
 #endif /* !_CAN_SKB_H */
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 1fb49d51b25d..afa6c2151bc4 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -199,27 +199,19 @@ static int can_create(struct net *net, struct socket *sock, int protocol,
 int can_send(struct sk_buff *skb, int loop)
 {
 	struct sk_buff *newskb = NULL;
-	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 	struct can_pkg_stats *pkg_stats = dev_net(skb->dev)->can.pkg_stats;
 	int err = -EINVAL;
 
-	if (skb->len == CAN_MTU) {
+	if (can_is_can_skb(skb)) {
 		skb->protocol = htons(ETH_P_CAN);
-		if (unlikely(cfd->len > CAN_MAX_DLEN))
-			goto inval_skb;
-	} else if (skb->len == CANFD_MTU) {
+	} else if (can_is_canfd_skb(skb)) {
 		skb->protocol = htons(ETH_P_CANFD);
-		if (unlikely(cfd->len > CANFD_MAX_DLEN))
-			goto inval_skb;
 	} else {
 		goto inval_skb;
 	}
 
-	/* Make sure the CAN frame can pass the selected CAN netdevice.
-	 * As structs can_frame and canfd_frame are similar, we can provide
-	 * CAN FD frames to legacy CAN drivers as long as the length is <= 8
-	 */
-	if (unlikely(skb->len > skb->dev->mtu && cfd->len > CAN_MAX_DLEN)) {
+	/* Make sure the CAN frame can pass the selected CAN netdevice. */
+	if (unlikely(skb->len > skb->dev->mtu)) {
 		err = -EMSGSIZE;
 		goto inval_skb;
 	}
@@ -678,53 +670,31 @@ static void can_receive(struct sk_buff *skb, struct net_device *dev)
 static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 		   struct packet_type *pt, struct net_device *orig_dev)
 {
-	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
-
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || (!can_is_can_skb(skb)))) {
 		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
-		goto free_skb;
-	}
 
-	/* This check is made separately since cfd->len would be uninitialized if skb->len = 0. */
-	if (unlikely(cfd->len > CAN_MAX_DLEN)) {
-		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d, datalen %d\n",
-			     dev->type, skb->len, cfd->len);
-		goto free_skb;
+		kfree_skb(skb);
+		return NET_RX_DROP;
 	}
 
 	can_receive(skb, dev);
 	return NET_RX_SUCCESS;
-
-free_skb:
-	kfree_skb(skb);
-	return NET_RX_DROP;
 }
 
 static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
 		     struct packet_type *pt, struct net_device *orig_dev)
 {
-	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
-
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || (!can_is_canfd_skb(skb)))) {
 		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
-		goto free_skb;
-	}
 
-	/* This check is made separately since cfd->len would be uninitialized if skb->len = 0. */
-	if (unlikely(cfd->len > CANFD_MAX_DLEN)) {
-		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d, datalen %d\n",
-			     dev->type, skb->len, cfd->len);
-		goto free_skb;
+		kfree_skb(skb);
+		return NET_RX_DROP;
 	}
 
 	can_receive(skb, dev);
 	return NET_RX_SUCCESS;
-
-free_skb:
-	kfree_skb(skb);
-	return NET_RX_DROP;
 }
 
 /* af_can protocol functions */
diff --git a/net/can/bcm.c b/net/can/bcm.c
index e60161bec850..e5d179ba6f7d 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -648,8 +648,13 @@ static void bcm_rx_handler(struct sk_buff *skb, void *data)
 		return;
 
 	/* make sure to handle the correct frame type (CAN / CAN FD) */
-	if (skb->len != op->cfsiz)
-		return;
+	if (op->flags & CAN_FD_FRAME) {
+		if (!can_is_canfd_skb(skb))
+			return;
+	} else {
+		if (!can_is_can_skb(skb))
+			return;
+	}
 
 	/* disable timeout */
 	hrtimer_cancel(&op->timer);
diff --git a/net/can/gw.c b/net/can/gw.c
index 1ea4cc527db3..23a3d89cad81 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -463,10 +463,10 @@ static void can_can_gw_rcv(struct sk_buff *skb, void *data)
 
 	/* process strictly Classic CAN or CAN FD frames */
 	if (gwj->flags & CGW_FLAGS_CAN_FD) {
-		if (skb->len != CANFD_MTU)
+		if (!can_is_canfd_skb(skb))
 			return;
 	} else {
-		if (skb->len != CAN_MTU)
+		if (!can_is_can_skb(skb))
 			return;
 	}
 
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 43a27d19cdac..a9d1357f8489 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -669,7 +669,7 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
 		if (cf->len <= CAN_MAX_DLEN) {
 			isotp_rcv_sf(sk, cf, SF_PCI_SZ4 + ae, skb, sf_dl);
 		} else {
-			if (skb->len == CANFD_MTU) {
+			if (can_is_canfd_skb(skb)) {
 				/* We have a CAN FD frame and CAN_DL is greater than 8:
 				 * Only frames with the SF_DL == 0 ESC value are valid.
 				 *
diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index 8452b0fbb78c..144c86b0e3ff 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -42,6 +42,10 @@ static void j1939_can_recv(struct sk_buff *iskb, void *data)
 	struct j1939_sk_buff_cb *skcb, *iskcb;
 	struct can_frame *cf;
 
+	/* make sure we only get Classical CAN frames */
+	if (!can_is_can_skb(iskb))
+		return;
+
 	/* create a copy of the skb
 	 * j1939 only delivers the real data bytes,
 	 * the header goes into sockaddr.
-- 
2.35.1


