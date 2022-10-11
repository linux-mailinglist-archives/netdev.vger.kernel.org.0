Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006905FADBE
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 09:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJKHs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 03:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiJKHsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 03:48:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193A35A83D
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 00:48:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oi9zy-0007fk-II
        for netdev@vger.kernel.org; Tue, 11 Oct 2022 09:48:22 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E4879F9CAD
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 07:48:21 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 87289F9C91;
        Tue, 11 Oct 2022 07:48:19 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1797e3e2;
        Tue, 11 Oct 2022 07:48:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Anssi Hannula <anssi.hannula@bitwise.fi>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/4] can: kvaser_usb: Fix use of uninitialized completion
Date:   Tue, 11 Oct 2022 09:48:13 +0200
Message-Id: <20221011074815.397301-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011074815.397301-1-mkl@pengutronix.de>
References: <20221011074815.397301-1-mkl@pengutronix.de>
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

From: Anssi Hannula <anssi.hannula@bitwise.fi>

flush_comp is initialized when CMD_FLUSH_QUEUE is sent to the device and
completed when the device sends CMD_FLUSH_QUEUE_RESP.

This causes completion of uninitialized completion if the device sends
CMD_FLUSH_QUEUE_RESP before CMD_FLUSH_QUEUE is ever sent (e.g. as a
response to a flush by a previously bound driver, or a misbehaving
device).

Fix that by initializing flush_comp in kvaser_usb_init_one() like the
other completions.

This issue is only triggerable after RX URBs have been set up, i.e. the
interface has been opened at least once.

Cc: stable@vger.kernel.org
Fixes: aec5fb2268b7 ("can: kvaser_usb: Add support for Kvaser USB hydra family")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010150829.199676-3-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  | 1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 824cab80aa02..c2bce6773adc 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -729,6 +729,7 @@ static int kvaser_usb_init_one(struct kvaser_usb *dev, int channel)
 	init_usb_anchor(&priv->tx_submitted);
 	init_completion(&priv->start_comp);
 	init_completion(&priv->stop_comp);
+	init_completion(&priv->flush_comp);
 	priv->can.ctrlmode_supported = 0;
 
 	priv->dev = dev;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 6871d474dabf..7b52fda73d82 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1916,7 +1916,7 @@ static int kvaser_usb_hydra_flush_queue(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->flush_comp);
+	reinit_completion(&priv->flush_comp);
 
 	err = kvaser_usb_hydra_send_simple_cmd(priv->dev, CMD_FLUSH_QUEUE,
 					       priv->channel);
-- 
2.35.1


