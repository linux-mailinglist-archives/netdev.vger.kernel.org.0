Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B607F3D30B3
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 02:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhGVXf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 19:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbhGVXf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 19:35:28 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11414C061575;
        Thu, 22 Jul 2021 17:16:03 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t21so1065847plr.13;
        Thu, 22 Jul 2021 17:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6C8t0KuiTGD3399lPLvWX5wehcoUeIALWQ0saCvNA34=;
        b=ntDOrn2q2OpiUMmwoEIHR3q++9zBsf5OhwZX/Yq6TnusSvTiRkSFE32VCjrMGbBeaR
         rLhcSIVOeBsbIew8Mo3wn/iEYg2/1Z3kCPsZotWJwBErgOZueQWLZQO6hUvwc4fj1yB6
         yIewZNXBMgCUq9TpHZw4MHPWIDYKUp1h4hrVo4dLR8rVfQj7GcD1f/g5SkjU+WA+COTc
         fHFD4LHDWF98EAVY82RK6wHlojZfVPeSCP6Nyc2BibtK8CI3hWChp1yd6DxFHLFLJB8T
         cpE2AcGRiXsVaFOaIXCtcZNYGPV5y38rAlRfDB3aj8AMdB4jdJiQoCcDvINcpxwQIdRi
         iN1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6C8t0KuiTGD3399lPLvWX5wehcoUeIALWQ0saCvNA34=;
        b=Q0YQSNV+bzaUdbWqDlBk/anx6E/+zNBAMfKHzQITCo3QOnsZSM1Hy1ItqRuEGxDfDR
         2rxm8qftbsUNocgHxbO6fshurye/o6rdxxY8vwI2e3D4KgIV7Fx4CcYr5wUAd4F5pc0R
         9QGLBnVwCr9i9CFmhe9rIFD+bTYJMfwBtIQ1DFC+EP4AP7kI7oQSCAzjZvE5Zhp4LKQn
         niC3CEfymhyWUNALuhmb+Tfzx248H+JqbfdtxPA+7OQ/pfa1kmEignbMYK6Df+VvCBuY
         tBBDNhRr9O2bIcpWWhPYlOWxHKPXv7WG5BnqPIN+XQWD5694YvHIaOjT/jUF6y77D1wr
         6s/A==
X-Gm-Message-State: AOAM531heyTag1X0RD+Gx9sjKPwp2qf21Q3TYCjbm++ET0pvmCzJv7oY
        EjHFAkM10p98X16d/8CERq7FbsC3cuI=
X-Google-Smtp-Source: ABdhPJyX8rQSMnhrd3oS6/ojohGbmwCk4b+4mQUnxrCMkIaI1Hr3RcxG2Lj49+EfKfnizE1TA07Geg==
X-Received: by 2002:aa7:8154:0:b029:310:70d:a516 with SMTP id d20-20020aa781540000b0290310070da516mr2165860pfn.63.1626999362298;
        Thu, 22 Jul 2021 17:16:02 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h25sm28370000pfo.190.2021.07.22.17.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 17:16:01 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net backport to 4.4,4.9] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear
Date:   Thu, 22 Jul 2021 17:15:52 -0700
Message-Id: <20210723001552.3274565-1-opendmb@gmail.com>
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
 drivers/net/ethernet/broadcom/genet/bcmgenet.c    | 15 +--------------
 .../net/ethernet/broadcom/genet/bcmgenet_wol.c    |  6 ------
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 2921ae13db28..5637adff1888 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1094,7 +1094,7 @@ static void bcmgenet_power_up(struct bcmgenet_priv *priv,
 	switch (mode) {
 	case GENET_POWER_PASSIVE:
 		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_PHY |
-				EXT_PWR_DOWN_BIAS);
+			 EXT_PWR_DOWN_BIAS | EXT_ENERGY_DET_MASK);
 		/* fallthrough */
 	case GENET_POWER_CABLE_SENSE:
 		/* enable APD */
@@ -2815,12 +2815,6 @@ static int bcmgenet_open(struct net_device *dev)
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	/* Disable RX/TX DMA and flush TX queues */
 	dma_ctrl = bcmgenet_dma_disable(priv);
 
@@ -3510,7 +3504,6 @@ static int bcmgenet_resume(struct device *d)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	unsigned long dma_ctrl;
 	int ret;
-	u32 reg;
 
 	if (!netif_running(dev))
 		return 0;
@@ -3545,12 +3538,6 @@ static int bcmgenet_resume(struct device *d)
 
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
index b97122926d3a..df107ed67220 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -167,12 +167,6 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 	reg |= CMD_RX_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 
-	if (priv->hw_params->flags & GENET_HAS_EXT) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg &= ~EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	/* Enable the MPD interrupt */
 	cpu_mask_clear = UMAC_IRQ_MPD_R;
 
-- 
2.25.1

