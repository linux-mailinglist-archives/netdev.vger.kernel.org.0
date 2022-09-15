Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330FA5B9636
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiIOIVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiIOIVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:21:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5843F89CF5
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 01:20:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oYk6w-0004cG-1S
        for netdev@vger.kernel.org; Thu, 15 Sep 2022 10:20:38 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 56CDEE39EF
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:20:22 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 67600E394D;
        Thu, 15 Sep 2022 08:20:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id df128df3;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 19/23] can: set CANFD_FDF flag in all CAN FD frame structures
Date:   Thu, 15 Sep 2022 10:20:09 +0200
Message-Id: <20220915082013.369072-20-mkl@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

To simplify the testing in user space all struct canfd_frame's provided by
the CAN subsystem of the Linux kernel now have the CANFD_FDF flag set in
canfd_frame::flags.

NB: Handcrafted ETH_P_CANFD frames introduced via PF_PACKET socket might
not set this bit correctly. During the check for sufficient headroom in
PF_PACKET sk_buffs the uninitialized CAN sk_buff data structures are filled.
In the case of a CAN FD frame the CANFD_FDF flag is set accordingly.

As the CAN frame content is already zero initialized in alloc_canfd_skb()
the obsolete initialization of cf->flags in the CTU CAN FD driver has been
removed as it would overwrite the already set CANFD_FDF flag.

Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20220912170725.120748-4-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c |  1 -
 drivers/net/can/dev/skb.c                | 11 +++++++++++
 include/uapi/linux/can.h                 |  4 ++--
 net/can/af_can.c                         |  5 +++++
 4 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
index 3c18d028bd8c..c4026712ab7d 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -657,7 +657,6 @@ static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_frame *c
 		cf->can_id = (idw >> 18) & CAN_SFF_MASK;
 
 	/* BRS, ESI, RTR Flags */
-	cf->flags = 0;
 	if (FIELD_GET(REG_FRAME_FORMAT_W_FDF, ffw)) {
 		if (FIELD_GET(REG_FRAME_FORMAT_W_BRS, ffw))
 			cf->flags |= CANFD_BRS;
diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index b896e1ce3b47..adb413bdd734 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -244,6 +244,9 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
 
 	*cfd = skb_put_zero(skb, sizeof(struct canfd_frame));
 
+	/* set CAN FD flag by default */
+	(*cfd)->flags = CANFD_FDF;
+
 	return skb;
 }
 EXPORT_SYMBOL_GPL(alloc_canfd_skb);
@@ -287,6 +290,14 @@ static bool can_skb_headroom_valid(struct net_device *dev, struct sk_buff *skb)
 		skb_reset_mac_header(skb);
 		skb_reset_network_header(skb);
 		skb_reset_transport_header(skb);
+
+		/* set CANFD_FDF flag for CAN FD frames */
+		if (can_is_canfd_skb(skb)) {
+			struct canfd_frame *cfd;
+
+			cfd = (struct canfd_frame *)skb->data;
+			cfd->flags |= CANFD_FDF;
+		}
 	}
 
 	return true;
diff --git a/include/uapi/linux/can.h b/include/uapi/linux/can.h
index 90801ada2bbe..7b23eeeb3273 100644
--- a/include/uapi/linux/can.h
+++ b/include/uapi/linux/can.h
@@ -141,8 +141,8 @@ struct can_frame {
  * When this is done the former differentiation via CAN_MTU / CANFD_MTU gets
  * lost. CANFD_FDF allows programmers to mark CAN FD frames in the case of
  * using struct canfd_frame for mixed CAN / CAN FD content (dual use).
- * N.B. the Kernel APIs do NOT provide mixed CAN / CAN FD content inside of
- * struct canfd_frame therefore the CANFD_FDF flag is disregarded by Linux.
+ * Since the introduction of CAN XL the CANFD_FDF flag is set in all CAN FD
+ * frame structures provided by the CAN subsystem of the Linux kernel.
  */
 #define CANFD_BRS 0x01 /* bit rate switch (second bitrate for payload data) */
 #define CANFD_ESI 0x02 /* error state indicator of the transmitting node */
diff --git a/net/can/af_can.c b/net/can/af_can.c
index afa6c2151bc4..072a6a5c9dd1 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -205,7 +205,12 @@ int can_send(struct sk_buff *skb, int loop)
 	if (can_is_can_skb(skb)) {
 		skb->protocol = htons(ETH_P_CAN);
 	} else if (can_is_canfd_skb(skb)) {
+		struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
+
 		skb->protocol = htons(ETH_P_CANFD);
+
+		/* set CAN FD flag for CAN FD frames by default */
+		cfd->flags |= CANFD_FDF;
 	} else {
 		goto inval_skb;
 	}
-- 
2.35.1


