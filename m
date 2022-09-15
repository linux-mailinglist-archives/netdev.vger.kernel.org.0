Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215425B961F
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiIOIUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiIOIUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:20:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EC689CF5
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 01:20:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oYk6f-0004BU-2i
        for netdev@vger.kernel.org; Thu, 15 Sep 2022 10:20:21 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3995CE3965
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:20:17 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 88897E392E;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 97fd6411;
        Thu, 15 Sep 2022 08:20:14 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Kenneth Lee <klee33@uw.edu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 04/23] can: kvaser_usb: kvaser_usb_hydra: Use kzalloc for allocating only one element
Date:   Thu, 15 Sep 2022 10:19:54 +0200
Message-Id: <20220915082013.369072-5-mkl@pengutronix.de>
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

From: Kenneth Lee <klee33@uw.edu>

Use kzalloc(...) rather than kcalloc(1, ...) since because the number of
elements we are specifying in this case is 1, kzalloc would accomplish the
same thing and we can simplify. Also refactor how we calculate the sizeof()
as checkstyle for kzalloc() prefers using the variable we are assigning
to versus the type of that variable for calculating the size to allocate.

Signed-off-by: Kenneth Lee <klee33@uw.edu>
Link: https://lore.kernel.org/all/20220807051656.1991446-1-klee33@uw.edu
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index dd65c101bfb8..6871d474dabf 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -534,7 +534,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 	struct kvaser_cmd *cmd;
 	int err;
 
-	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -573,7 +573,7 @@ kvaser_usb_hydra_send_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 	struct kvaser_usb *dev = priv->dev;
 	int err;
 
-	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_ATOMIC);
+	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -694,7 +694,7 @@ static int kvaser_usb_hydra_map_channel(struct kvaser_usb *dev, u16 transid,
 	struct kvaser_cmd *cmd;
 	int err;
 
-	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -735,7 +735,7 @@ static int kvaser_usb_hydra_get_single_capability(struct kvaser_usb *dev,
 	int err;
 	int i;
 
-	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -1394,7 +1394,7 @@ kvaser_usb_hydra_frame_to_cmd_ext(const struct kvaser_usb_net_priv *priv,
 	u32 kcan_id;
 	u32 kcan_header;
 
-	cmd = kcalloc(1, sizeof(struct kvaser_cmd_ext), GFP_ATOMIC);
+	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
 	if (!cmd)
 		return NULL;
 
@@ -1468,7 +1468,7 @@ kvaser_usb_hydra_frame_to_cmd_std(const struct kvaser_usb_net_priv *priv,
 	u32 flags;
 	u32 id;
 
-	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_ATOMIC);
+	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
 	if (!cmd)
 		return NULL;
 
@@ -1533,7 +1533,7 @@ static int kvaser_usb_hydra_set_bittiming(struct net_device *netdev)
 	int sjw = bt->sjw;
 	int err;
 
-	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -1567,7 +1567,7 @@ static int kvaser_usb_hydra_set_data_bittiming(struct net_device *netdev)
 	int sjw = dbt->sjw;
 	int err;
 
-	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -1711,7 +1711,7 @@ static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 	u32 flags;
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
 
-	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -1851,7 +1851,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 		return -EINVAL;
 	}
 
-	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
-- 
2.35.1


