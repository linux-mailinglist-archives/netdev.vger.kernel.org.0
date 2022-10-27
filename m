Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584D060F670
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbiJ0LoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbiJ0LoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:44:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C6911E446
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:44:03 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oo1In-0000dx-PC
        for netdev@vger.kernel.org; Thu, 27 Oct 2022 13:44:01 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 31AE110B237
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:44:01 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E33DC10B21B;
        Thu, 27 Oct 2022 11:43:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 439743df;
        Thu, 27 Oct 2022 11:43:57 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Anssi Hannula <anssi.hannula@bitwise.fi>,
        Jimmy Assarsson <extja@kvaser.com>, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 1/4] can: kvaser_usb: Fix possible completions during init_completion
Date:   Thu, 27 Oct 2022 13:43:53 +0200
Message-Id: <20221027114356.1939821-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221027114356.1939821-1-mkl@pengutronix.de>
References: <20221027114356.1939821-1-mkl@pengutronix.de>
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

kvaser_usb uses completions to signal when a response event is received
for outgoing commands.

However, it uses init_completion() to reinitialize the start_comp and
stop_comp completions before sending the start/stop commands.

In case the device sends the corresponding response just before the
actual command is sent, complete() may be called concurrently with
init_completion() which is not safe.

This might be triggerable even with a properly functioning device by
stopping the interface (CMD_STOP_CHIP) just after it goes bus-off (which
also causes the driver to send CMD_STOP_CHIP when restart-ms is off),
but that was not tested.

Fix the issue by using reinit_completion() instead.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010185237.319219-2-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 4 ++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 7b52fda73d82..66f672ea631b 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1875,7 +1875,7 @@ static int kvaser_usb_hydra_start_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->start_comp);
+	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_hydra_send_simple_cmd(priv->dev, CMD_START_CHIP_REQ,
 					       priv->channel);
@@ -1893,7 +1893,7 @@ static int kvaser_usb_hydra_stop_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->stop_comp);
+	reinit_completion(&priv->stop_comp);
 
 	/* Make sure we do not report invalid BUS_OFF from CMD_CHIP_STATE_EVENT
 	 * see comment in kvaser_usb_hydra_update_state()
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 50f2ac8319ff..19958037720f 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1320,7 +1320,7 @@ static int kvaser_usb_leaf_start_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->start_comp);
+	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_START_CHIP,
 					      priv->channel);
@@ -1338,7 +1338,7 @@ static int kvaser_usb_leaf_stop_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->stop_comp);
+	reinit_completion(&priv->stop_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_STOP_CHIP,
 					      priv->channel);

base-commit: e2badb4bd33abe13ddc35975bd7f7f8693955a4b
-- 
2.35.1


