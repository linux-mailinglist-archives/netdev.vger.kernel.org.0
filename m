Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DCA537D69
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbiE3Niv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237654AbiE3Ngy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:36:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0198B6CF42;
        Mon, 30 May 2022 06:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9231CB80DAF;
        Mon, 30 May 2022 13:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE8CC3411E;
        Mon, 30 May 2022 13:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917435;
        bh=Z9yF7wXK7FyIDA4sdjwhkOzBIa9BHIXOUCAnORgpRiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fM9Z23YSlFfAHqoGTwa12GDaQjRibhcrbyc3iZanICNuzCj8cokrUmPbRj0GvCK8p
         LIDZDfyQNJhPpYNdmp/iHbRHJE2DQOgr3B6e9icLBz+hJbPOyAoPgKBKeYVdT+Cp28
         FT1cglNbXuZJFnPQxcMKVzcV5P//KBbfL6IlB6X5kvkXJjh3Gc1F7oeLHnCuwp9mvI
         fPCHWAR96xTLtvR5M0t8XGQvoUnU6SZps04zGeBKp6OrV7orSx4DDT58kiSfp/IDtQ
         Omb2XlcwQIS1O/DxeYhAcMM8i9hNHpQpJFroWAbXOV4LlNDKvy35J2U5a7pxxlR3EL
         7pNdM7l3kmcUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 134/159] net: phy: micrel: Allow probing without .driver_data
Date:   Mon, 30 May 2022 09:23:59 -0400
Message-Id: <20220530132425.1929512-134-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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
index cd9aa353b653..48c7d715a9e3 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -497,7 +497,7 @@ static int kszphy_config_reset(struct phy_device *phydev)
 		}
 	}
 
-	if (priv->led_mode >= 0)
+	if (priv->type && priv->led_mode >= 0)
 		kszphy_setup_led(phydev, priv->type->led_mode_reg, priv->led_mode);
 
 	return 0;
@@ -513,10 +513,10 @@ static int kszphy_config_init(struct phy_device *phydev)
 
 	type = priv->type;
 
-	if (type->has_broadcast_disable)
+	if (type && type->has_broadcast_disable)
 		kszphy_broadcast_disable(phydev);
 
-	if (type->has_nand_tree_disable)
+	if (type && type->has_nand_tree_disable)
 		kszphy_nand_tree_disable(phydev);
 
 	return kszphy_config_reset(phydev);
@@ -1514,7 +1514,7 @@ static int kszphy_probe(struct phy_device *phydev)
 
 	priv->type = type;
 
-	if (type->led_mode_reg) {
+	if (type && type->led_mode_reg) {
 		ret = of_property_read_u32(np, "micrel,led-mode",
 				&priv->led_mode);
 		if (ret)
@@ -1535,7 +1535,8 @@ static int kszphy_probe(struct phy_device *phydev)
 		unsigned long rate = clk_get_rate(clk);
 		bool rmii_ref_clk_sel_25_mhz;
 
-		priv->rmii_ref_clk_sel = type->has_rmii_ref_clk_sel;
+		if (type)
+			priv->rmii_ref_clk_sel = type->has_rmii_ref_clk_sel;
 		rmii_ref_clk_sel_25_mhz = of_property_read_bool(np,
 				"micrel,rmii-reference-clock-select-25-mhz");
 
-- 
2.35.1

