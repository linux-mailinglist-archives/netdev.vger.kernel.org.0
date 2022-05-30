Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB2F537EE5
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238765AbiE3Nxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238424AbiE3NwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:52:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A56512772;
        Mon, 30 May 2022 06:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4D11B80AE8;
        Mon, 30 May 2022 13:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5649FC3411A;
        Mon, 30 May 2022 13:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917840;
        bh=OgUDXA45bwkJ5vJysgvw42AgkjEwX/rQiiRRrhcxWUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdRT7ZkwY4RaVxLhkDy1VH33PFQjdGSp1wANjSvPHwfmz1OImS6KBoug3UFHRnlnq
         F3IwEknTt6vaJ/b0LormgOEKOyvpRxEImyKIwyqmn5TuArm+93wKTqrCemABQO5Od2
         detGoNgSDRmfDb/dY9pDL+Kv9JsjpQNkve0vJd7fQSJbdPGSV7R/cnYbfrOiP0AhWl
         nZRUOOiFf0pYF+/eaaSrxeq75Esb2h0sb/uILYuFE3bHl+ixyjL9qc/YSF/YYjR228
         ET2ZiuiFr7LxZ2h8qFjZqeImaUgfz4eJgeV8bKKQXdbSgAneozvai6rayVsdrCDDot
         iEDU+HQIYOrNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 112/135] net: phy: micrel: Allow probing without .driver_data
Date:   Mon, 30 May 2022 09:31:10 -0400
Message-Id: <20220530133133.1931716-112-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit f2ef6f7539c68c6bd6c32323d8845ee102b7c450 ]

Currently, if the .probe element is present in the phy_driver structure
and the .driver_data is not, a NULL pointer dereference happens.

Allow passing .probe without .driver_data by inserting NULL checks
for priv->type.

Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220513114613.762810-1-festevam@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index cfb5378bbb39..f20d8c3e91bf 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -348,7 +348,7 @@ static int kszphy_config_reset(struct phy_device *phydev)
 		}
 	}
 
-	if (priv->led_mode >= 0)
+	if (priv->type && priv->led_mode >= 0)
 		kszphy_setup_led(phydev, priv->type->led_mode_reg, priv->led_mode);
 
 	return 0;
@@ -364,10 +364,10 @@ static int kszphy_config_init(struct phy_device *phydev)
 
 	type = priv->type;
 
-	if (type->has_broadcast_disable)
+	if (type && type->has_broadcast_disable)
 		kszphy_broadcast_disable(phydev);
 
-	if (type->has_nand_tree_disable)
+	if (type && type->has_nand_tree_disable)
 		kszphy_nand_tree_disable(phydev);
 
 	return kszphy_config_reset(phydev);
@@ -1365,7 +1365,7 @@ static int kszphy_probe(struct phy_device *phydev)
 
 	priv->type = type;
 
-	if (type->led_mode_reg) {
+	if (type && type->led_mode_reg) {
 		ret = of_property_read_u32(np, "micrel,led-mode",
 				&priv->led_mode);
 		if (ret)
@@ -1386,7 +1386,8 @@ static int kszphy_probe(struct phy_device *phydev)
 		unsigned long rate = clk_get_rate(clk);
 		bool rmii_ref_clk_sel_25_mhz;
 
-		priv->rmii_ref_clk_sel = type->has_rmii_ref_clk_sel;
+		if (type)
+			priv->rmii_ref_clk_sel = type->has_rmii_ref_clk_sel;
 		rmii_ref_clk_sel_25_mhz = of_property_read_bool(np,
 				"micrel,rmii-reference-clock-select-25-mhz");
 
-- 
2.35.1

