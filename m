Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF2468BDDB
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjBFNTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjBFNS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:18:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33E424498
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:37 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1NH-00089q-EV
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:35 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 905A417153A
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D3BE417132B;
        Mon,  6 Feb 2023 13:16:24 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b49eb283;
        Mon, 6 Feb 2023 13:16:23 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <vincent.mailhol@gmail.com>
Subject: [PATCH net-next 41/47] can: bittiming: can_fixup_bittiming(): report error via netlink and harmonize error value
Date:   Mon,  6 Feb 2023 14:16:14 +0100
Message-Id: <20230206131620.2758724-42-mkl@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check each bit timing parameter first individually against their
limits and report a meaningful error message via netlink to the user
space.

In case of an error, return -EINVAL instead of -ERANGE, this
corresponds better to the actual meaning of the error value.

Link: https://lore.kernel.org/all/20230202110854.2318594-12-mkl@pengutronix.de
Suggested-by: Vincent Mailhol <vincent.mailhol@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/bittiming.c | 38 +++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 101de1b3bf30..727dcd52cc2c 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -33,22 +33,38 @@ static int can_fixup_bittiming(const struct net_device *dev, struct can_bittimin
 			       const struct can_bittiming_const *btc,
 			       struct netlink_ext_ack *extack)
 {
+	const unsigned int tseg1 = bt->prop_seg + bt->phase_seg1;
 	const struct can_priv *priv = netdev_priv(dev);
-	unsigned int tseg1;
 	u64 brp64;
 	int err;
 
+	if (tseg1 < btc->tseg1_min) {
+		NL_SET_ERR_MSG_FMT(extack, "prop-seg + phase-seg1: %u less than tseg1-min: %u",
+				   tseg1, btc->tseg1_min);
+		return -EINVAL;
+	}
+	if (tseg1 > btc->tseg1_max) {
+		NL_SET_ERR_MSG_FMT(extack, "prop-seg + phase-seg1: %u greater than tseg1-max: %u",
+				   tseg1, btc->tseg1_max);
+		return -EINVAL;
+	}
+	if (bt->phase_seg2 < btc->tseg2_min) {
+		NL_SET_ERR_MSG_FMT(extack, "phase-seg2: %u less than tseg2-min: %u",
+				   bt->phase_seg2, btc->tseg2_min);
+		return -EINVAL;
+	}
+	if (bt->phase_seg2 > btc->tseg2_max) {
+		NL_SET_ERR_MSG_FMT(extack, "phase-seg2: %u greater than tseg2-max: %u",
+				   bt->phase_seg2, btc->tseg2_max);
+		return -EINVAL;
+	}
+
 	can_sjw_set_default(bt);
 
 	err = can_sjw_check(dev, bt, btc, extack);
 	if (err)
 		return err;
 
-	tseg1 = bt->prop_seg + bt->phase_seg1;
-	if (tseg1 < btc->tseg1_min || tseg1 > btc->tseg1_max ||
-	    bt->phase_seg2 < btc->tseg2_min || bt->phase_seg2 > btc->tseg2_max)
-		return -ERANGE;
-
 	brp64 = (u64)priv->clock.freq * (u64)bt->tq;
 	if (btc->brp_inc > 1)
 		do_div(brp64, btc->brp_inc);
@@ -58,8 +74,16 @@ static int can_fixup_bittiming(const struct net_device *dev, struct can_bittimin
 		brp64 *= btc->brp_inc;
 	bt->brp = (u32)brp64;
 
-	if (bt->brp < btc->brp_min || bt->brp > btc->brp_max)
+	if (bt->brp < btc->brp_min) {
+		NL_SET_ERR_MSG_FMT(extack, "resulting brp: %u less than brp-min: %u",
+				   bt->brp, btc->brp_min);
 		return -EINVAL;
+	}
+	if (bt->brp > btc->brp_max) {
+		NL_SET_ERR_MSG_FMT(extack, "resulting brp: %u greater than brp-max: %u",
+				   bt->brp, btc->brp_max);
+		return -EINVAL;
+	}
 
 	bt->bitrate = priv->clock.freq / (bt->brp * can_bit_time(bt));
 	bt->sample_point = ((CAN_SYNC_SEG + tseg1) * 1000) / can_bit_time(bt);
-- 
2.39.1


