Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B6B68BDF2
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjBFNTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:19:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjBFNSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:18:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39AF4ECF
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:49 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1NN-0008Sx-3z
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:41 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C7D03171478
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3016A1712FA;
        Mon,  6 Feb 2023 13:16:24 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ce11d549;
        Mon, 6 Feb 2023 13:16:23 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 31/47] can: bittiming(): replace open coded variants of can_bit_time()
Date:   Mon,  6 Feb 2023 14:16:04 +0100
Message-Id: <20230206131620.2758724-32-mkl@pengutronix.de>
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

Commit 1c47fa6b31c2 ("can: dev: add a helper function to calculate the
duration of one bit") added the helper function can_bit_time().

Replace open coded variants of can_bit_time() by the helper function.

Link: https://lore.kernel.org/all/20230202110854.2318594-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/bittiming.c      | 7 +++----
 drivers/net/can/dev/calc_bittiming.c | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 7ae80763c960..32af609eee50 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -15,7 +15,7 @@ static int can_fixup_bittiming(const struct net_device *dev, struct can_bittimin
 			       const struct can_bittiming_const *btc)
 {
 	const struct can_priv *priv = netdev_priv(dev);
-	unsigned int tseg1, alltseg;
+	unsigned int tseg1;
 	u64 brp64;
 
 	tseg1 = bt->prop_seg + bt->phase_seg1;
@@ -38,9 +38,8 @@ static int can_fixup_bittiming(const struct net_device *dev, struct can_bittimin
 	if (bt->brp < btc->brp_min || bt->brp > btc->brp_max)
 		return -EINVAL;
 
-	alltseg = bt->prop_seg + bt->phase_seg1 + bt->phase_seg2 + 1;
-	bt->bitrate = priv->clock.freq / (bt->brp * alltseg);
-	bt->sample_point = ((tseg1 + 1) * 1000) / alltseg;
+	bt->bitrate = priv->clock.freq / (bt->brp * can_bit_time(bt));
+	bt->sample_point = ((tseg1 + 1) * 1000) / can_bit_time(bt);
 
 	return 0;
 }
diff --git a/drivers/net/can/dev/calc_bittiming.c b/drivers/net/can/dev/calc_bittiming.c
index d3caa040614d..28dbb6cbfd5d 100644
--- a/drivers/net/can/dev/calc_bittiming.c
+++ b/drivers/net/can/dev/calc_bittiming.c
@@ -170,7 +170,7 @@ int can_calc_bittiming(const struct net_device *dev, struct can_bittiming *bt,
 
 	/* real bitrate */
 	bt->bitrate = priv->clock.freq /
-		(bt->brp * (CAN_SYNC_SEG + tseg1 + tseg2));
+		(bt->brp * can_bit_time(bt));
 
 	return 0;
 }
-- 
2.39.1


