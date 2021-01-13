Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E652F584C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbhANCRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbhAMVPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:15:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205CFC061383
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 13:14:35 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kznTN-0001vj-IK
        for netdev@vger.kernel.org; Wed, 13 Jan 2021 22:14:33 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1C5695C3079
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 21:14:25 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 649785C3012;
        Wed, 13 Jan 2021 21:14:13 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 441fa3fc;
        Wed, 13 Jan 2021 21:14:11 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [net-next 12/17] can: dev: extend struct can_skb_priv to hold CAN frame length
Date:   Wed, 13 Jan 2021 22:14:05 +0100
Message-Id: <20210113211410.917108-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113211410.917108-1-mkl@pengutronix.de>
References: <20210113211410.917108-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to implement byte queue limits (bql) in CAN drivers, the length of the
CAN frame needs to be passed into the networking stack after queueing and after
transmission completion.

To avoid to calculate this length twice, extend the struct can_skb_priv to hold
the length of the CAN frame and extend __can_get_echo_skb() to return that
value.

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20210111141930.693847-12-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/rx-offload.c | 2 +-
 drivers/net/can/dev/skb.c        | 9 +++++++--
 include/linux/can/skb.h          | 4 +++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/dev/rx-offload.c b/drivers/net/can/dev/rx-offload.c
index 3c1912c0430b..6a26b5282df1 100644
--- a/drivers/net/can/dev/rx-offload.c
+++ b/drivers/net/can/dev/rx-offload.c
@@ -271,7 +271,7 @@ unsigned int can_rx_offload_get_echo_skb(struct can_rx_offload *offload,
 	u8 len;
 	int err;
 
-	skb = __can_get_echo_skb(dev, idx, &len);
+	skb = __can_get_echo_skb(dev, idx, &len, NULL);
 	if (!skb)
 		return 0;
 
diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 26cd597ff771..24f782a23409 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -76,7 +76,8 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 EXPORT_SYMBOL_GPL(can_put_echo_skb);
 
 struct sk_buff *
-__can_get_echo_skb(struct net_device *dev, unsigned int idx, u8 *len_ptr)
+__can_get_echo_skb(struct net_device *dev, unsigned int idx, u8 *len_ptr,
+		   unsigned int *frame_len_ptr)
 {
 	struct can_priv *priv = netdev_priv(dev);
 
@@ -91,6 +92,7 @@ __can_get_echo_skb(struct net_device *dev, unsigned int idx, u8 *len_ptr)
 		 * length is supported on both CAN and CANFD frames.
 		 */
 		struct sk_buff *skb = priv->echo_skb[idx];
+		struct can_skb_priv *can_skb_priv = can_skb_prv(skb);
 		struct canfd_frame *cf = (struct canfd_frame *)skb->data;
 
 		/* get the real payload length for netdev statistics */
@@ -99,6 +101,9 @@ __can_get_echo_skb(struct net_device *dev, unsigned int idx, u8 *len_ptr)
 		else
 			*len_ptr = cf->len;
 
+		if (frame_len_ptr)
+			*frame_len_ptr = can_skb_priv->frame_len;
+
 		priv->echo_skb[idx] = NULL;
 
 		return skb;
@@ -118,7 +123,7 @@ unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx)
 	struct sk_buff *skb;
 	u8 len;
 
-	skb = __can_get_echo_skb(dev, idx, &len);
+	skb = __can_get_echo_skb(dev, idx, &len, NULL);
 	if (!skb)
 		return 0;
 
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index c90ebbd3008c..5db9da30843c 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -20,7 +20,7 @@ void can_flush_echo_skb(struct net_device *dev);
 int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 		     unsigned int idx);
 struct sk_buff *__can_get_echo_skb(struct net_device *dev, unsigned int idx,
-				   u8 *len_ptr);
+				   u8 *len_ptr, unsigned int *frame_len_ptr);
 unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx);
 void can_free_echo_skb(struct net_device *dev, unsigned int idx);
 struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf);
@@ -42,11 +42,13 @@ struct sk_buff *alloc_can_err_skb(struct net_device *dev,
  * struct can_skb_priv - private additional data inside CAN sk_buffs
  * @ifindex:	ifindex of the first interface the CAN frame appeared on
  * @skbcnt:	atomic counter to have an unique id together with skb pointer
+ * @frame_len:	length of CAN frame in data link layer
  * @cf:		align to the following CAN frame at skb->data
  */
 struct can_skb_priv {
 	int ifindex;
 	int skbcnt;
+	unsigned int frame_len;
 	struct can_frame cf[];
 };
 
-- 
2.29.2


