Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35FB58B9B9
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 07:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiHGFnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 01:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiHGFnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 01:43:22 -0400
X-Greylist: delayed 1501 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 06 Aug 2022 22:43:21 PDT
Received: from mx5.cs.washington.edu (mx5.cs.washington.edu [IPv6:2607:4000:200:11::6a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BEEB1FF;
        Sat,  6 Aug 2022 22:43:21 -0700 (PDT)
Received: from mx5.cs.washington.edu (localhost [IPv6:0:0:0:0:0:0:0:1])
        by mx5.cs.washington.edu (8.17.1/8.17.1/1.26) with ESMTP id 2775I1ed909678;
        Sat, 6 Aug 2022 22:18:01 -0700
Received: from attu1.cs.washington.edu (attu1.cs.washington.edu [IPv6:2607:4000:200:10:0:0:0:89])
        (authenticated bits=128)
        by mx5.cs.washington.edu (8.17.1/8.17.1/1.26) with ESMTPSA id 2775Hxg6909674
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Sat, 6 Aug 2022 22:18:01 -0700
Received: from attu1.cs.washington.edu (localhost [127.0.0.1])
        by attu1.cs.washington.edu (8.15.2/8.15.2/1.23) with ESMTP id 2775HwLD1991828;
        Sat, 6 Aug 2022 22:17:59 -0700
Received: (from klee33@localhost)
        by attu1.cs.washington.edu (8.15.2/8.15.2/Submit/1.2) id 2775HudJ1991801;
        Sat, 6 Aug 2022 22:17:56 -0700
From:   Kenneth Lee <klee33@uw.edu>
To:     mkl@pengutronix.de, wg@grandegger.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Kenneth Lee <klee33@uw.edu>
Subject: [PATCH] can: kvaser_usb: kvaser_usb_hydra: Use kzalloc for allocating only one element
Date:   Sat,  6 Aug 2022 22:16:56 -0700
Message-Id: <20220807051656.1991446-1-klee33@uw.edu>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kzalloc(...) rather than kcalloc(1, ...) since because the number of
elements we are specifying in this case is 1, kzalloc would accomplish the
same thing and we can simplify. Also refactor how we calculate the sizeof()
as checkstyle for kzalloc() prefers using the variable we are assigning
to versus the type of that variable for calculating the size to allocate.

Signed-off-by: Kenneth Lee <klee33@uw.edu>
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
2.31.1

