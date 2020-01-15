Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A6713C86D
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgAOPx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:53:57 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36223 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbgAOPx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 10:53:57 -0500
Received: by mail-pf1-f195.google.com with SMTP id x184so8721956pfb.3;
        Wed, 15 Jan 2020 07:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=c/GWPQtRfN7j/bEfY+uIGMfC4b83t2OdSqf9AvElNRM=;
        b=EwuEbm4VZGa5Yrj1M1k5z/SPIhI/TyArbfnbVrC91uJvgqCXjVIYHF5u+M5/X1rdJT
         70gnHeB+JCcWu5W4tgZ1AO7gppBRrmPJhPzaC6T7a/sQlFkxe/ild7vt8rZ9zah7jWtE
         Z4I7BJFOJ5+XZh33RgFyQjHfnKNYYhB++PdcLYi7aYsJK1WIJ14lZtuiYXMErVz4EPyx
         FBnF+th9KbYbdtNpiaWd7qI+ImCzrn0S2An3ip7vWxySJWmnkbLp+PgK4KcjGJTzLKfP
         GnRrnYuLBNwEaidccyXlPF952M7ocLNt8U1ydpR/UJMCeb1xs020494ha66/l6yU+5jS
         K+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=c/GWPQtRfN7j/bEfY+uIGMfC4b83t2OdSqf9AvElNRM=;
        b=UWrGkG8Sp4FK/H64YWzWeXGaTWphFo1Va1yrdwuzC8Ux4w4hrVHrm25L7HWa3Aaynw
         pura02OBQIzOSUFIayNO9GHhaLdgVjCVP6bGiXHZqCczurhPjVijNwC4GC8wvhiklPnX
         BkMSOTq2V88A1brrEM8qnWDW9wVr6dPTSodemgyjuXvkxLf6+nORAAot4GrB5KYnhVXs
         kEd66vm2JmxMjNjQHUg3epOr0/U0ho6y6wLyYOz+dxVV2A79MqibBUDwaSKB/ysxHvLu
         TnNPtC6/jVWW1YtIc/s6QGQgZcxVIS19wP+Z7n2Je3q772cqCTS2oZSbZ8DwOuc9aXXd
         tFBw==
X-Gm-Message-State: APjAAAUlxARnCxjhLFD/t0zw1Vcrm22pZHtPuqbkDVP0blobqvsEtpLe
        2Y/RCUcJXfRcFbJZGPhf7UTAjvmS
X-Google-Smtp-Source: APXvYqyKceOTx9ZjZoes/c2uX1iezUq1hng9gL92ptSPdkUO9WPHZB3PUuC6MsV6ZBJ7g6f6sPoZEQ==
X-Received: by 2002:aa7:8088:: with SMTP id v8mr32789472pff.142.1579103636329;
        Wed, 15 Jan 2020 07:53:56 -0800 (PST)
Received: from localhost (64.64.229.47.16clouds.com. [64.64.229.47])
        by smtp.gmail.com with ESMTPSA id i66sm22664925pfg.85.2020.01.15.07.53.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Jan 2020 07:53:55 -0800 (PST)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH] net: stmmac: modified pcs mode support for RGMII
Date:   Wed, 15 Jan 2020 23:53:23 +0800
Message-Id: <20200115155323.15543-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

snps databook noted that physical coding sublayer (PCS) interface
that can be used when the MAC is configured for the TBI, RTBI, or
SGMII PHY interface. we have RGMII and SGMII in a SoC and it also
has the PCS block. it needs stmmac_init_phy and stmmac_mdio_register
function for initializing phy when it used RGMII interface.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c   | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6f51a265459d..9778e7e0c005 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -387,9 +387,8 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 	/* Using PCS we cannot dial with the phy registers at this stage
 	 * so we do not support extra feature like EEE.
 	 */
-	if ((priv->hw->pcs == STMMAC_PCS_RGMII) ||
-	    (priv->hw->pcs == STMMAC_PCS_TBI) ||
-	    (priv->hw->pcs == STMMAC_PCS_RTBI))
+	if (priv->hw->pcs == STMMAC_PCS_TBI ||
+	    priv->hw->pcs == STMMAC_PCS_RTBI)
 		return false;
 
 	/* Check if MAC core supports the EEE feature. */
@@ -2652,8 +2651,7 @@ static int stmmac_open(struct net_device *dev)
 	u32 chan;
 	int ret;
 
-	if (priv->hw->pcs != STMMAC_PCS_RGMII &&
-	    priv->hw->pcs != STMMAC_PCS_TBI &&
+	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI) {
 		ret = stmmac_init_phy(dev);
 		if (ret) {
@@ -4725,8 +4723,7 @@ int stmmac_dvr_probe(struct device *device,
 
 	stmmac_check_pcs_mode(priv);
 
-	if (priv->hw->pcs != STMMAC_PCS_RGMII  &&
-	    priv->hw->pcs != STMMAC_PCS_TBI &&
+	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI) {
 		/* MDIO bus Registration */
 		ret = stmmac_mdio_register(ndev);
@@ -4760,8 +4757,7 @@ int stmmac_dvr_probe(struct device *device,
 error_netdev_register:
 	phylink_destroy(priv->phylink);
 error_phy_setup:
-	if (priv->hw->pcs != STMMAC_PCS_RGMII &&
-	    priv->hw->pcs != STMMAC_PCS_TBI &&
+	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
 error_mdio_register:
@@ -4806,8 +4802,7 @@ int stmmac_dvr_remove(struct device *dev)
 		reset_control_assert(priv->plat->stmmac_rst);
 	clk_disable_unprepare(priv->plat->pclk);
 	clk_disable_unprepare(priv->plat->stmmac_clk);
-	if (priv->hw->pcs != STMMAC_PCS_RGMII &&
-	    priv->hw->pcs != STMMAC_PCS_TBI &&
+	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
 	destroy_workqueue(priv->wq);
-- 
2.17.1

