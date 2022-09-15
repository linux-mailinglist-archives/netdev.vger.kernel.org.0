Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C965B9642
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiIOIWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiIOIVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:21:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD4C97B30
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 01:20:39 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oYk6u-0004aD-Oh
        for netdev@vger.kernel.org; Thu, 15 Sep 2022 10:20:36 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 79F32E39E0
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:20:20 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8BE34E3953;
        Thu, 15 Sep 2022 08:20:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ac4e09a8;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 21/23] can: canxl: update CAN infrastructure for CAN XL frames
Date:   Thu, 15 Sep 2022 10:20:11 +0200
Message-Id: <20220915082013.369072-22-mkl@pengutronix.de>
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

- add new ETH_P_CANXL ethernet protocol type
- update skb checks for CAN XL
- add alloc_canxl_skb() which now needs a data length parameter
- introduce init_can_skb_reserve() to reduce code duplication

Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20220912170725.120748-6-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/skb.c     | 72 ++++++++++++++++++++++++++---------
 include/linux/can/skb.h       | 23 ++++++++++-
 include/uapi/linux/if_ether.h |  1 +
 net/can/af_can.c              | 25 +++++++++++-
 4 files changed, 101 insertions(+), 20 deletions(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index adb413bdd734..791a51e2f5d6 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -187,6 +187,20 @@ void can_free_echo_skb(struct net_device *dev, unsigned int idx,
 }
 EXPORT_SYMBOL_GPL(can_free_echo_skb);
 
+/* fill common values for CAN sk_buffs */
+static void init_can_skb_reserve(struct sk_buff *skb)
+{
+	skb->pkt_type = PACKET_BROADCAST;
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+	skb_reset_transport_header(skb);
+
+	can_skb_reserve(skb);
+	can_skb_prv(skb)->skbcnt = 0;
+}
+
 struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf)
 {
 	struct sk_buff *skb;
@@ -200,16 +214,8 @@ struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf)
 	}
 
 	skb->protocol = htons(ETH_P_CAN);
-	skb->pkt_type = PACKET_BROADCAST;
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
-
-	skb_reset_mac_header(skb);
-	skb_reset_network_header(skb);
-	skb_reset_transport_header(skb);
-
-	can_skb_reserve(skb);
+	init_can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	*cf = skb_put_zero(skb, sizeof(struct can_frame));
 
@@ -231,16 +237,8 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
 	}
 
 	skb->protocol = htons(ETH_P_CANFD);
-	skb->pkt_type = PACKET_BROADCAST;
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
-
-	skb_reset_mac_header(skb);
-	skb_reset_network_header(skb);
-	skb_reset_transport_header(skb);
-
-	can_skb_reserve(skb);
+	init_can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	*cfd = skb_put_zero(skb, sizeof(struct canfd_frame));
 
@@ -251,6 +249,39 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(alloc_canfd_skb);
 
+struct sk_buff *alloc_canxl_skb(struct net_device *dev,
+				struct canxl_frame **cxl,
+				unsigned int data_len)
+{
+	struct sk_buff *skb;
+
+	if (data_len < CANXL_MIN_DLEN || data_len > CANXL_MAX_DLEN)
+		goto out_error;
+
+	skb = netdev_alloc_skb(dev, sizeof(struct can_skb_priv) +
+			       CANXL_HDR_SIZE + data_len);
+	if (unlikely(!skb))
+		goto out_error;
+
+	skb->protocol = htons(ETH_P_CANXL);
+	init_can_skb_reserve(skb);
+	can_skb_prv(skb)->ifindex = dev->ifindex;
+
+	*cxl = skb_put_zero(skb, CANXL_HDR_SIZE + data_len);
+
+	/* set CAN XL flag and length information by default */
+	(*cxl)->flags = CANXL_XLF;
+	(*cxl)->len = data_len;
+
+	return skb;
+
+out_error:
+	*cxl = NULL;
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(alloc_canxl_skb);
+
 struct sk_buff *alloc_can_err_skb(struct net_device *dev, struct can_frame **cf)
 {
 	struct sk_buff *skb;
@@ -319,6 +350,11 @@ bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 			goto inval_skb;
 		break;
 
+	case ETH_P_CANXL:
+		if (!can_is_canxl_skb(skb))
+			goto inval_skb;
+		break;
+
 	default:
 		goto inval_skb;
 	}
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index ddffc2fc008c..1abc25a8d144 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -30,6 +30,9 @@ void can_free_echo_skb(struct net_device *dev, unsigned int idx,
 struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf);
 struct sk_buff *alloc_canfd_skb(struct net_device *dev,
 				struct canfd_frame **cfd);
+struct sk_buff *alloc_canxl_skb(struct net_device *dev,
+				struct canxl_frame **cxl,
+				unsigned int data_len);
 struct sk_buff *alloc_can_err_skb(struct net_device *dev,
 				  struct can_frame **cf);
 bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb);
@@ -114,11 +117,29 @@ static inline bool can_is_canfd_skb(const struct sk_buff *skb)
 	return (skb->len == CANFD_MTU && cfd->len <= CANFD_MAX_DLEN);
 }
 
-/* get length element value from can[fd]_frame structure */
+static inline bool can_is_canxl_skb(const struct sk_buff *skb)
+{
+	const struct canxl_frame *cxl = (struct canxl_frame *)skb->data;
+
+	if (skb->len < CANXL_HDR_SIZE + CANXL_MIN_DLEN || skb->len > CANXL_MTU)
+		return false;
+
+	/* this also checks valid CAN XL data length boundaries */
+	if (skb->len != CANXL_HDR_SIZE + cxl->len)
+		return false;
+
+	return cxl->flags & CANXL_XLF;
+}
+
+/* get length element value from can[|fd|xl]_frame structure */
 static inline unsigned int can_skb_get_len_val(struct sk_buff *skb)
 {
+	const struct canxl_frame *cxl = (struct canxl_frame *)skb->data;
 	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
+	if (can_is_canxl_skb(skb))
+		return cxl->len;
+
 	return cfd->len;
 }
 
diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index d370165bc621..69e0457eb200 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -138,6 +138,7 @@
 #define ETH_P_LOCALTALK 0x0009		/* Localtalk pseudo type 	*/
 #define ETH_P_CAN	0x000C		/* CAN: Controller Area Network */
 #define ETH_P_CANFD	0x000D		/* CANFD: CAN flexible data rate*/
+#define ETH_P_CANXL	0x000E		/* CANXL: eXtended frame Length */
 #define ETH_P_PPPTALK	0x0010		/* Dummy type for Atalk over PPP*/
 #define ETH_P_TR_802_2	0x0011		/* 802.2 frames 		*/
 #define ETH_P_MOBITEX	0x0015		/* Mobitex (kaz@cafe.net)	*/
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 072a6a5c9dd1..9503ab10f9b8 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -202,7 +202,9 @@ int can_send(struct sk_buff *skb, int loop)
 	struct can_pkg_stats *pkg_stats = dev_net(skb->dev)->can.pkg_stats;
 	int err = -EINVAL;
 
-	if (can_is_can_skb(skb)) {
+	if (can_is_canxl_skb(skb)) {
+		skb->protocol = htons(ETH_P_CANXL);
+	} else if (can_is_can_skb(skb)) {
 		skb->protocol = htons(ETH_P_CAN);
 	} else if (can_is_canfd_skb(skb)) {
 		struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
@@ -702,6 +704,21 @@ static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
 	return NET_RX_SUCCESS;
 }
 
+static int canxl_rcv(struct sk_buff *skb, struct net_device *dev,
+		     struct packet_type *pt, struct net_device *orig_dev)
+{
+	if (unlikely(dev->type != ARPHRD_CAN || (!can_is_canxl_skb(skb)))) {
+		pr_warn_once("PF_CAN: dropped non conform CAN XL skbuff: dev type %d, len %d\n",
+			     dev->type, skb->len);
+
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
+
+	can_receive(skb, dev);
+	return NET_RX_SUCCESS;
+}
+
 /* af_can protocol functions */
 
 /**
@@ -826,6 +843,11 @@ static struct packet_type canfd_packet __read_mostly = {
 	.func = canfd_rcv,
 };
 
+static struct packet_type canxl_packet __read_mostly = {
+	.type = cpu_to_be16(ETH_P_CANXL),
+	.func = canxl_rcv,
+};
+
 static const struct net_proto_family can_family_ops = {
 	.family = PF_CAN,
 	.create = can_create,
@@ -865,6 +887,7 @@ static __init int can_init(void)
 
 	dev_add_pack(&can_packet);
 	dev_add_pack(&canfd_packet);
+	dev_add_pack(&canxl_packet);
 
 	return 0;
 
-- 
2.35.1


