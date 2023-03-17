Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF8A6BEFFE
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjCQRmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjCQRmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:42:53 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C32233D9;
        Fri, 17 Mar 2023 10:42:50 -0700 (PDT)
Received: from jupiter.universe (dyndsl-091-248-191-142.ewe-ip-backbone.de [91.248.191.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id D5D6766030C5;
        Fri, 17 Mar 2023 17:42:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1679074968;
        bh=dejqDCxy9oTKhCu7sjRqtctWqfmWffdDuvJGn6Vor1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvCQ8TZsAKkqSjLe/XWC1qhupMDIoouF1mxcb36nhi59Qr3KwMZsZESAaxz5JtoNa
         0gEMJgkg8B2l4ed0aDIZqBljsV5wEvlRIWMpOZtvWR0NvlGFv3Ero7IIKbM0Ja9bkv
         LVvNrQSOSCCYuK+LG+3TxPoYxT5NexsXM3TRXdIJYpPZUFCrkYLSKI6/yZRwlmLRRM
         oNLzmlb32HYEZtKI24vvRZw48AUrTwuN/jmSI1++Rfb5OcqF4nI8rOXP43Gc7dcR2Q
         4jXDyBS0/TACabC0ZAmWS6aMzUK9Eyu9u7fNuo7QGYs91uzyNQGT9R/MZfL6SQHTz+
         qD5lakMT4IRlQ==
Received: by jupiter.universe (Postfix, from userid 1000)
        id 40F234807E2; Fri, 17 Mar 2023 18:42:46 +0100 (CET)
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
Subject: [PATCHv1 1/2] net: ethernet: stmmac: dwmac-rk: fix optional clock handling
Date:   Fri, 17 Mar 2023 18:42:42 +0100
Message-Id: <20230317174243.61500-2-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230317174243.61500-1-sebastian.reichel@collabora.com>
References: <20230317174243.61500-1-sebastian.reichel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now any clock errors are printed and otherwise ignored.
This has multiple disadvantages:

1. it prints errors for clocks that do not exist (e.g. rk3588
   reports errors for "mac_clk_rx", "mac_clk_tx" and "clk_mac_speed")

2. it does not handle errors like -EPROBE_DEFER correctly

This series fixes it by switching to devm_clk_get_optional(),
so that missing clocks are not considered an error and then
passing on any other errors using dev_err_probe().

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 47 ++++++++++---------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 4b8fd11563e4..126812cd17e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1479,49 +1479,50 @@ static int rk_gmac_clk_init(struct plat_stmmacenet_data *plat)
 
 	bsp_priv->clk_enabled = false;
 
-	bsp_priv->mac_clk_rx = devm_clk_get(dev, "mac_clk_rx");
+	bsp_priv->mac_clk_rx = devm_clk_get_optional(dev, "mac_clk_rx");
 	if (IS_ERR(bsp_priv->mac_clk_rx))
-		dev_err(dev, "cannot get clock %s\n",
-			"mac_clk_rx");
+		return dev_err_probe(dev, PTR_ERR(bsp_priv->mac_clk_rx),
+				"cannot get clock %s\n", "mac_clk_rx");
 
-	bsp_priv->mac_clk_tx = devm_clk_get(dev, "mac_clk_tx");
+	bsp_priv->mac_clk_tx = devm_clk_get_optional(dev, "mac_clk_tx");
 	if (IS_ERR(bsp_priv->mac_clk_tx))
-		dev_err(dev, "cannot get clock %s\n",
-			"mac_clk_tx");
+		return dev_err_probe(dev, PTR_ERR(bsp_priv->mac_clk_tx),
+				"cannot get clock %s\n", "mac_clk_tx");
 
-	bsp_priv->aclk_mac = devm_clk_get(dev, "aclk_mac");
+	bsp_priv->aclk_mac = devm_clk_get_optional(dev, "aclk_mac");
 	if (IS_ERR(bsp_priv->aclk_mac))
-		dev_err(dev, "cannot get clock %s\n",
-			"aclk_mac");
+		return dev_err_probe(dev, PTR_ERR(bsp_priv->aclk_mac),
+				"cannot get clock %s\n", "aclk_mac");
 
-	bsp_priv->pclk_mac = devm_clk_get(dev, "pclk_mac");
+	bsp_priv->pclk_mac = devm_clk_get_optional(dev, "pclk_mac");
 	if (IS_ERR(bsp_priv->pclk_mac))
-		dev_err(dev, "cannot get clock %s\n",
-			"pclk_mac");
+		return dev_err_probe(dev, PTR_ERR(bsp_priv->pclk_mac),
+				"cannot get clock %s\n", "pclk_mac");
 
-	bsp_priv->clk_mac = devm_clk_get(dev, "stmmaceth");
+	bsp_priv->clk_mac = devm_clk_get_optional(dev, "stmmaceth");
 	if (IS_ERR(bsp_priv->clk_mac))
-		dev_err(dev, "cannot get clock %s\n",
-			"stmmaceth");
+		return dev_err_probe(dev, PTR_ERR(bsp_priv->clk_mac),
+				"cannot get clock %s\n", "stmmaceth");
 
 	if (bsp_priv->phy_iface == PHY_INTERFACE_MODE_RMII) {
-		bsp_priv->clk_mac_ref = devm_clk_get(dev, "clk_mac_ref");
+		bsp_priv->clk_mac_ref = devm_clk_get_optional(dev, "clk_mac_ref");
 		if (IS_ERR(bsp_priv->clk_mac_ref))
-			dev_err(dev, "cannot get clock %s\n",
-				"clk_mac_ref");
+			return dev_err_probe(dev, PTR_ERR(bsp_priv->clk_mac_ref),
+					"cannot get clock %s\n", "clk_mac_ref");
 
 		if (!bsp_priv->clock_input) {
 			bsp_priv->clk_mac_refout =
-				devm_clk_get(dev, "clk_mac_refout");
+				devm_clk_get_optional(dev, "clk_mac_refout");
 			if (IS_ERR(bsp_priv->clk_mac_refout))
-				dev_err(dev, "cannot get clock %s\n",
-					"clk_mac_refout");
+				return dev_err_probe(dev, PTR_ERR(bsp_priv->clk_mac_refout),
+						"cannot get clock %s\n", "clk_mac_refout");
 		}
 	}
 
-	bsp_priv->clk_mac_speed = devm_clk_get(dev, "clk_mac_speed");
+	bsp_priv->clk_mac_speed = devm_clk_get_optional(dev, "clk_mac_speed");
 	if (IS_ERR(bsp_priv->clk_mac_speed))
-		dev_err(dev, "cannot get clock %s\n", "clk_mac_speed");
+		return dev_err_probe(dev, PTR_ERR(bsp_priv->clk_mac_speed),
+				"cannot get clock %s\n", "clk_mac_speed");
 
 	if (bsp_priv->clock_input) {
 		dev_info(dev, "clock input from PHY\n");
-- 
2.39.2

