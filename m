Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806BB3D30AF
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 02:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbhGVXfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 19:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbhGVXfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 19:35:01 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7860AC061575;
        Thu, 22 Jul 2021 17:15:35 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so1518225pjh.3;
        Thu, 22 Jul 2021 17:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=69hq61oIDGpZ3gk5Ncqu518QZ2L1yjLt5sjR865WQUM=;
        b=pnyHDdk4mjK7XJbZIh6Zd2sRy3cy/KkH4efdWP2h2a4FwtTGFb78WiPJ+7uwugCh3k
         Q129KOSXe1q/wdSDfX1LDk04cJgvsuRJ1SUr2Z+zhVDS6VcRuodpqLPH5axLQDPQwf/V
         lzPz9fcCLkAg+xqC5omnmHBmwCprBndctOLnRn0H2xPialtlo/EIV7Oash0O8R5z4XTU
         xTGuXAfN/q2dt6pHYVZeu6Q1QQJ8YJ/uilNPsPMLha2NHmnz5l8W4SIUqlYdwWfNllOl
         uCfrujTrAf7qC7GDbkcV3UoXEpGHWmKNfRfxVHkc7XYIchek7o6xlToS6b0xT6grBWig
         pq1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=69hq61oIDGpZ3gk5Ncqu518QZ2L1yjLt5sjR865WQUM=;
        b=jfSRVwzuJrEFSmCeeXJwnKWeBVAtrGWMl8RDh3rLQeKERyPXQJE6cyXGTBHmEimuk8
         NjugKq0fbLMnPl7ULvN5OIh0dZTPxN25zns0U0imayFJsoBZyrrdYg70maoIRw3zI25N
         G1katTvB5t5QmDPIvQLdgHGRieakaU5jNrTfeC2OpbMB9qPsJxuGQY+82lhXQFJkjHuy
         0EB3mujTRIGTivEPqHWrejnTQY0q6Bzs9wdg+czUKy02rbQzySEZn83zsigwFlIb+wi6
         iB20p5mPrAWCkFHoB2CJ3dkO9ZnjrXofzVQCTD6RHk/ty7Dzuk9xIykXho94H9OCEQTI
         Tq7w==
X-Gm-Message-State: AOAM531HDqi37lfzMFLS0LMunM0OutlRTB7W7bv56PyO/LVtgnZSRQXB
        e4qUvS5+j/wdw8SnrXzQqlSt08/xXlc=
X-Google-Smtp-Source: ABdhPJyQy6KtO8Ub8D7cMHUg0VAAKqrcXE76mP/syW7zaGAlsCozVWmFsqEhW6qKem5r8ZpRAkBVaA==
X-Received: by 2002:a17:90a:fb51:: with SMTP id iq17mr11442245pjb.36.1626999334250;
        Thu, 22 Jul 2021 17:15:34 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j2sm33096134pfb.53.2021.07.22.17.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 17:15:33 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net backport to 4.14,4.19,5.4] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear
Date:   Thu, 22 Jul 2021 17:15:09 -0700
Message-Id: <20210723001509.3274508-1-opendmb@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Upstream commit 5a3c680aa2c12c90c44af383fe6882a39875ab81 ]

Setting the EXT_ENERGY_DET_MASK bit allows the port energy detection
logic of the internal PHY to prevent the system from sleeping. Some
internal PHYs will report that energy is detected when the network
interface is closed which can prevent the system from going to sleep
if WoL is enabled when the interface is brought down.

Since the driver does not support waking the system on this logic,
this commit clears the bit whenever the internal PHY is powered up
and the other logic for manipulating the bit is removed since it
serves no useful function.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c   | 16 ++--------------
 .../net/ethernet/broadcom/genet/bcmgenet_wol.c   |  6 ------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 21669a42718c..c4c5ca02a26c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1187,7 +1187,8 @@ static void bcmgenet_power_up(struct bcmgenet_priv *priv,
 
 	switch (mode) {
 	case GENET_POWER_PASSIVE:
-		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS);
+		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS |
+			 EXT_ENERGY_DET_MASK);
 		if (GENET_IS_V5(priv)) {
 			reg &= ~(EXT_PWR_DOWN_PHY_EN |
 				 EXT_PWR_DOWN_PHY_RD |
@@ -2895,12 +2896,6 @@ static int bcmgenet_open(struct net_device *dev)
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	/* Disable RX/TX DMA and flush TX queues */
 	dma_ctrl = bcmgenet_dma_disable(priv);
 
@@ -3617,7 +3612,6 @@ static int bcmgenet_resume(struct device *d)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	unsigned long dma_ctrl;
 	int ret;
-	u32 reg;
 
 	if (!netif_running(dev))
 		return 0;
@@ -3649,12 +3643,6 @@ static int bcmgenet_resume(struct device *d)
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	if (priv->wolopts)
 		bcmgenet_power_up(priv, GENET_POWER_WOL_MAGIC);
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index a41f82379369..164988f3b4fa 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -160,12 +160,6 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 	reg |= CMD_RX_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 
-	if (priv->hw_params->flags & GENET_HAS_EXT) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg &= ~EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	return 0;
 }
 
-- 
2.25.1

