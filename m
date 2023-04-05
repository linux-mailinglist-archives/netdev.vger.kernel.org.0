Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24036D831F
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbjDEQK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbjDEQKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:10:54 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60296591;
        Wed,  5 Apr 2023 09:10:49 -0700 (PDT)
Received: from jupiter.universe (dyndsl-091-248-212-122.ewe-ip-backbone.de [91.248.212.122])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id A49476603050;
        Wed,  5 Apr 2023 17:10:47 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680711047;
        bh=pH06ncEy562f9n+iewFlXxRQME64qy/bVTx4Y1ixGtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oneGGk8xcXoWVLep21/VHMQDqfYRYGypWEaXiJ8yrXYtKvUyDVRIs9REsqODis+1u
         wIYTNgUkdcPdmZslNXJoYJp7QTbGV7PoocqHln78WXY1Nm2SnLZKvMQtYVEFw4YOuu
         bwMXAeUd3okPgddbDUICzlEUHw2qfMk+VDJtS92ZnQ8XEJB+sUw4qrc00PJRzLNa1A
         9ImviMLKuHZ6XePKiSdoNlVanj1CgHxoWNS1LtQoUJfnkP0gm4xGFPDDAU6S99x523
         AZ2QIMg3SxTC5zfX/T4a9yFYZBYAQH6EnwqVt4gKBGRw+w3PXyiVrKQfIJuABZofl3
         STrlVcQ9UnxIw==
Received: by jupiter.universe (Postfix, from userid 1000)
        id 424484807E0; Wed,  5 Apr 2023 18:10:45 +0200 (CEST)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        kernel@collabora.com
Subject: [PATCHv2 1/2] net: ethernet: stmmac: dwmac-rk: rework optional clock handling
Date:   Wed,  5 Apr 2023 18:10:42 +0200
Message-Id: <20230405161043.46190-2-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405161043.46190-1-sebastian.reichel@collabora.com>
References: <20230405161043.46190-1-sebastian.reichel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The clock requesting code is quite repetitive. Fix this by requesting
the clocks in a loop. Also use devm_clk_get_optional instead of
devm_clk_get, since the old code effectively handles them as optional
clocks. This removes error messages about missing clocks for platforms
not using them and correct -EPROBE_DEFER handling.

The new code also tries to get "clk_mac_ref" and "clk_mac_refout" when
the PHY is not configured as PHY_INTERFACE_MODE_RMII to keep the code
simple. This is possible since we use devm_clk_get_optional() for the
clock lookup anyways.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 7ad269ea1a2b7 ("GMAC: add driver for Rockchip RK3288 SoCs integrated GMAC")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 63 ++++++-------------
 1 file changed, 20 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 4b8fd11563e4..6fdad0f10d6f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1475,54 +1475,31 @@ static int rk_gmac_clk_init(struct plat_stmmacenet_data *plat)
 {
 	struct rk_priv_data *bsp_priv = plat->bsp_priv;
 	struct device *dev = &bsp_priv->pdev->dev;
-	int ret;
+	int i, ret;
+	struct {
+		struct clk **ptr;
+		const char *name;
+	} clocks[] = {
+		{ &bsp_priv->mac_clk_rx, "mac_clk_rx" },
+		{ &bsp_priv->mac_clk_tx, "mac_clk_tx" },
+		{ &bsp_priv->aclk_mac, "aclk_mac" },
+		{ &bsp_priv->pclk_mac, "pclk_mac" },
+		{ &bsp_priv->clk_mac, "stmmaceth" },
+		{ &bsp_priv->clk_mac_ref, "clk_mac_ref" },
+		{ &bsp_priv->clk_mac_refout, "clk_mac_refout" },
+		{ &bsp_priv->clk_mac_speed, "clk_mac_speed" },
+	};
 
 	bsp_priv->clk_enabled = false;
 
-	bsp_priv->mac_clk_rx = devm_clk_get(dev, "mac_clk_rx");
-	if (IS_ERR(bsp_priv->mac_clk_rx))
-		dev_err(dev, "cannot get clock %s\n",
-			"mac_clk_rx");
-
-	bsp_priv->mac_clk_tx = devm_clk_get(dev, "mac_clk_tx");
-	if (IS_ERR(bsp_priv->mac_clk_tx))
-		dev_err(dev, "cannot get clock %s\n",
-			"mac_clk_tx");
-
-	bsp_priv->aclk_mac = devm_clk_get(dev, "aclk_mac");
-	if (IS_ERR(bsp_priv->aclk_mac))
-		dev_err(dev, "cannot get clock %s\n",
-			"aclk_mac");
-
-	bsp_priv->pclk_mac = devm_clk_get(dev, "pclk_mac");
-	if (IS_ERR(bsp_priv->pclk_mac))
-		dev_err(dev, "cannot get clock %s\n",
-			"pclk_mac");
-
-	bsp_priv->clk_mac = devm_clk_get(dev, "stmmaceth");
-	if (IS_ERR(bsp_priv->clk_mac))
-		dev_err(dev, "cannot get clock %s\n",
-			"stmmaceth");
-
-	if (bsp_priv->phy_iface == PHY_INTERFACE_MODE_RMII) {
-		bsp_priv->clk_mac_ref = devm_clk_get(dev, "clk_mac_ref");
-		if (IS_ERR(bsp_priv->clk_mac_ref))
-			dev_err(dev, "cannot get clock %s\n",
-				"clk_mac_ref");
-
-		if (!bsp_priv->clock_input) {
-			bsp_priv->clk_mac_refout =
-				devm_clk_get(dev, "clk_mac_refout");
-			if (IS_ERR(bsp_priv->clk_mac_refout))
-				dev_err(dev, "cannot get clock %s\n",
-					"clk_mac_refout");
-		}
+	for (i=0; i < ARRAY_SIZE(clocks); i++) {
+		*clocks[i].ptr = devm_clk_get_optional(dev, clocks[i].name);
+		if (IS_ERR(*clocks[i].ptr))
+			return dev_err_probe(dev, PTR_ERR(*clocks[i].ptr),
+					     "cannot get clock %s\n",
+					     clocks[i].name);
 	}
 
-	bsp_priv->clk_mac_speed = devm_clk_get(dev, "clk_mac_speed");
-	if (IS_ERR(bsp_priv->clk_mac_speed))
-		dev_err(dev, "cannot get clock %s\n", "clk_mac_speed");
-
 	if (bsp_priv->clock_input) {
 		dev_info(dev, "clock input from PHY\n");
 	} else {
-- 
2.39.2

