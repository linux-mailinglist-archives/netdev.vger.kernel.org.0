Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9E3351951
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbhDARwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236758AbhDARrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:47:20 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495F5C031144;
        Thu,  1 Apr 2021 09:42:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so3384916pjc.2;
        Thu, 01 Apr 2021 09:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CBxiLvF46TPZlE6Qw/eVy6TdCEn6Q47xt13cSpMuxWU=;
        b=gnAm/YLUUccn5VmMyaxYkvzmsF0N5PUbVBNYzucjasn0o7zSAp+L7GX6FO81hP+pEy
         zcn40cvOHe7B1jdt6lbsfDeY7Iw+o0T9fUPE7q63Kik1DSkDgoM7xSlhPlxnTMob+CMM
         2eaK7tN5j4VdCuXRqxQ+0E8FbQ4aJ7gK+76IYLpjF3xKxGWxZa0FgdngQ/F9Kqa/sCDM
         xVVyn2hh59tgDncmmVqFmjwWGi7/k9X0cg5PzQ0hj6NGsNfLtg60vSy2ZSi6/ZR+J8iE
         H0QFEUwxyHjFcm2k6AvyZ499IEctf76f7GTXIInMnxV8yLi1GvZbuFd6MRczFxNMiJc2
         pBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CBxiLvF46TPZlE6Qw/eVy6TdCEn6Q47xt13cSpMuxWU=;
        b=kzI6o4BYBTNgXWaGG1MtRPNTTp6DeflWKM+c/xVEJqk1x+KZAMsSKLbCE0A/JZ/LkZ
         aVdujCVC9GW1rdrMzdesv6UGjB3n5c+8CS4/I6sJ4YM/5OXvl1B1vQHxSBVjE9n2FA/L
         cBZ3q3smbKrnsRshCIkTUebInACItgCSvmLVsWeuByHvTp/ID/bwHxWYA2Rb44HIoyBU
         uih/N+pk4XbbaZTGAszSgzEQ3MOEjDCFeX8NZZSm1UMsEJTq8tsPvd9CBfJ9EQ4vN+ve
         GpzuN/QsisYdWL+VUbzxEUg+AsOd77NXt+kH0gGPbym8IcEG9vJfc4hyEkl4j0SV2wW/
         bdxA==
X-Gm-Message-State: AOAM530YfFz2Lm+aZXWGKrMEZ/Ba1uWrv4oURCN7GS5/MxEAh0LE+jbR
        u8VbmkhGSdplfXohNqGUj4JuQ6ki/tg=
X-Google-Smtp-Source: ABdhPJwcGOnOfp6OiP2KnaMIqhtAM/V+ohB4JjVNoWv0YIj6iX1/yGhDUeh3pfNc+508Bpj+ZHpH1w==
X-Received: by 2002:a17:902:442:b029:e7:1dfd:421a with SMTP id 60-20020a1709020442b02900e71dfd421amr8814360ple.7.1617295359315;
        Thu, 01 Apr 2021 09:42:39 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm5757920pju.44.2021.04.01.09.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 09:42:38 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: broadcom: Add statistics for all Gigabit PHYs
Date:   Thu,  1 Apr 2021 09:42:33 -0700
Message-Id: <20210401164233.1672002-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All Gigabit PHYs use the same register layout as far as fetching
statistics goes. Fast Ethernet PHYs do not all support statistics, and
the BCM54616S would require some switching between the coper and fiber
modes to fetch the appropriate statistics which is not supported yet.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 76 +++++++++++++++++++++++++++++++++-----
 1 file changed, 66 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 82fe5f43f0e9..7bf3011b8e77 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -671,13 +671,13 @@ static irqreturn_t brcm_fet_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
-struct bcm53xx_phy_priv {
+struct bcm54xx_phy_priv {
 	u64	*stats;
 };
 
-static int bcm53xx_phy_probe(struct phy_device *phydev)
+static int bcm54xx_phy_probe(struct phy_device *phydev)
 {
-	struct bcm53xx_phy_priv *priv;
+	struct bcm54xx_phy_priv *priv;
 
 	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -694,10 +694,10 @@ static int bcm53xx_phy_probe(struct phy_device *phydev)
 	return 0;
 }
 
-static void bcm53xx_phy_get_stats(struct phy_device *phydev,
-				  struct ethtool_stats *stats, u64 *data)
+static void bcm54xx_get_stats(struct phy_device *phydev,
+			      struct ethtool_stats *stats, u64 *data)
 {
-	struct bcm53xx_phy_priv *priv = phydev->priv;
+	struct bcm54xx_phy_priv *priv = phydev->priv;
 
 	bcm_phy_get_stats(phydev, priv->stats, stats, data);
 }
@@ -708,6 +708,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM5411",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
@@ -716,6 +720,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM5421",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
@@ -724,6 +732,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM54210E",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
@@ -732,6 +744,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM5461",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
@@ -740,6 +756,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM54612E",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
@@ -759,6 +779,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM5464",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
@@ -769,6 +793,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM5481",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init	= bcm54xx_config_init,
 	.config_aneg	= bcm5481_config_aneg,
 	.config_intr	= bcm_phy_config_intr,
@@ -778,6 +806,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask    = 0xfffffff0,
 	.name           = "Broadcom BCM54810",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init    = bcm54xx_config_init,
 	.config_aneg    = bcm5481_config_aneg,
 	.config_intr    = bcm_phy_config_intr,
@@ -789,6 +821,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask    = 0xfffffff0,
 	.name           = "Broadcom BCM54811",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init    = bcm54811_config_init,
 	.config_aneg    = bcm5481_config_aneg,
 	.config_intr    = bcm_phy_config_intr,
@@ -800,6 +836,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM5482",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
@@ -808,6 +848,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM50610",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
@@ -816,6 +860,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM50610M",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
@@ -824,6 +872,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM57780",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
@@ -851,8 +903,8 @@ static struct phy_driver broadcom_drivers[] = {
 	/* PHY_GBIT_FEATURES */
 	.get_sset_count	= bcm_phy_get_sset_count,
 	.get_strings	= bcm_phy_get_strings,
-	.get_stats	= bcm53xx_phy_get_stats,
-	.probe		= bcm53xx_phy_probe,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 }, {
 	.phy_id		= PHY_ID_BCM53125,
 	.phy_id_mask	= 0xfffffff0,
@@ -861,8 +913,8 @@ static struct phy_driver broadcom_drivers[] = {
 	/* PHY_GBIT_FEATURES */
 	.get_sset_count	= bcm_phy_get_sset_count,
 	.get_strings	= bcm_phy_get_strings,
-	.get_stats	= bcm53xx_phy_get_stats,
-	.probe		= bcm53xx_phy_probe,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
@@ -871,6 +923,10 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask    = 0xfffffff0,
 	.name           = "Broadcom BCM89610",
 	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm54xx_get_stats,
+	.probe		= bcm54xx_phy_probe,
 	.config_init    = bcm54xx_config_init,
 	.config_intr    = bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
-- 
2.25.1

