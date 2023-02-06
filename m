Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2183B68BDAD
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjBFNRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjBFNRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:17:38 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD62323870
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:21 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N1-0007Ty-QT
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:19 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 21D09171514
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B13C417131D;
        Mon,  6 Feb 2023 13:16:24 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8af2555a;
        Mon, 6 Feb 2023 13:16:23 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 39/47] can: bittiming: can_changelink() pass extack down callstack
Date:   Mon,  6 Feb 2023 14:16:12 +0100
Message-Id: <20230206131620.2758724-40-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparation patch.

In order to pass warning/error messages during netlink calls back to
user space, pass the extack struct down the callstack of
can_changelink(), the actual error messages will be added in the
following ptaches.

Link: https://lore.kernel.org/all/20230202110854.2318594-10-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/bittiming.c      | 15 +++++++++------
 drivers/net/can/dev/calc_bittiming.c |  2 +-
 drivers/net/can/dev/netlink.c        |  6 ++++--
 include/linux/can/bittiming.h        |  5 +++--
 4 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 263e46a1f648..0b0b8c767c5b 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -12,7 +12,8 @@
  * file linux/can/netlink.h.
  */
 static int can_fixup_bittiming(const struct net_device *dev, struct can_bittiming *bt,
-			       const struct can_bittiming_const *btc)
+			       const struct can_bittiming_const *btc,
+			       struct netlink_ext_ack *extack)
 {
 	const struct can_priv *priv = netdev_priv(dev);
 	unsigned int tseg1;
@@ -50,7 +51,8 @@ static int can_fixup_bittiming(const struct net_device *dev, struct can_bittimin
 static int
 can_validate_bitrate(const struct net_device *dev, const struct can_bittiming *bt,
 		     const u32 *bitrate_const,
-		     const unsigned int bitrate_const_cnt)
+		     const unsigned int bitrate_const_cnt,
+		     struct netlink_ext_ack *extack)
 {
 	unsigned int i;
 
@@ -65,7 +67,8 @@ can_validate_bitrate(const struct net_device *dev, const struct can_bittiming *b
 int can_get_bittiming(const struct net_device *dev, struct can_bittiming *bt,
 		      const struct can_bittiming_const *btc,
 		      const u32 *bitrate_const,
-		      const unsigned int bitrate_const_cnt)
+		      const unsigned int bitrate_const_cnt,
+		      struct netlink_ext_ack *extack)
 {
 	/* Depending on the given can_bittiming parameter structure the CAN
 	 * timing parameters are calculated based on the provided bitrate OR
@@ -73,12 +76,12 @@ int can_get_bittiming(const struct net_device *dev, struct can_bittiming *bt,
 	 * provided directly which are then checked and fixed up.
 	 */
 	if (!bt->tq && bt->bitrate && btc)
-		return can_calc_bittiming(dev, bt, btc);
+		return can_calc_bittiming(dev, bt, btc, extack);
 	if (bt->tq && !bt->bitrate && btc)
-		return can_fixup_bittiming(dev, bt, btc);
+		return can_fixup_bittiming(dev, bt, btc, extack);
 	if (!bt->tq && bt->bitrate && bitrate_const)
 		return can_validate_bitrate(dev, bt, bitrate_const,
-					    bitrate_const_cnt);
+					    bitrate_const_cnt, extack);
 
 	return -EINVAL;
 }
diff --git a/drivers/net/can/dev/calc_bittiming.c b/drivers/net/can/dev/calc_bittiming.c
index 28dbb6cbfd5d..46d28f377186 100644
--- a/drivers/net/can/dev/calc_bittiming.c
+++ b/drivers/net/can/dev/calc_bittiming.c
@@ -63,7 +63,7 @@ can_update_sample_point(const struct can_bittiming_const *btc,
 }
 
 int can_calc_bittiming(const struct net_device *dev, struct can_bittiming *bt,
-		       const struct can_bittiming_const *btc)
+		       const struct can_bittiming_const *btc, struct netlink_ext_ack *extack)
 {
 	struct can_priv *priv = netdev_priv(dev);
 	unsigned int bitrate;			/* current bitrate */
diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index a03b45a020b9..036d85ef07f5 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -215,7 +215,8 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		err = can_get_bittiming(dev, &bt,
 					priv->bittiming_const,
 					priv->bitrate_const,
-					priv->bitrate_const_cnt);
+					priv->bitrate_const_cnt,
+					extack);
 		if (err)
 			return err;
 
@@ -320,7 +321,8 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		err = can_get_bittiming(dev, &dbt,
 					priv->data_bittiming_const,
 					priv->data_bitrate_const,
-					priv->data_bitrate_const_cnt);
+					priv->data_bitrate_const_cnt,
+					extack);
 		if (err)
 			return err;
 
diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index ef0a77173e3c..53d693ae5397 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -116,7 +116,7 @@ struct can_tdc_const {
 
 #ifdef CONFIG_CAN_CALC_BITTIMING
 int can_calc_bittiming(const struct net_device *dev, struct can_bittiming *bt,
-		       const struct can_bittiming_const *btc);
+		       const struct can_bittiming_const *btc, struct netlink_ext_ack *extack);
 
 void can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
 		   const struct can_bittiming *dbt,
@@ -141,7 +141,8 @@ can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
 int can_get_bittiming(const struct net_device *dev, struct can_bittiming *bt,
 		      const struct can_bittiming_const *btc,
 		      const u32 *bitrate_const,
-		      const unsigned int bitrate_const_cnt);
+		      const unsigned int bitrate_const_cnt,
+		      struct netlink_ext_ack *extack);
 
 /*
  * can_bit_time() - Duration of one bit
-- 
2.39.1


