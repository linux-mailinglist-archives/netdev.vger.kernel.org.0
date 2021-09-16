Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B048940D0A4
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 02:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhIPAKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 20:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbhIPAKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 20:10:36 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA811C061574;
        Wed, 15 Sep 2021 17:09:16 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id c13-20020a17090a558d00b00198e6497a4fso6210443pji.4;
        Wed, 15 Sep 2021 17:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=POz7B/cNCWIJvz8pVnhM5ZDIV6/Scz9emQ4JSgg4ILI=;
        b=fTdc1tNHYuqoyOyLsrut+wrdO/M+1BBDNn97zAt21oLznqomAgqniyXRwpHNaG+H/h
         BX8yoGBBn2ngujdkL/G0PkabMfUoHlLhr3OE2VjfygPvaTXvMnBFnqyivIeIt+pwIK6m
         I5OH4rHD5hFt4em2BlawW6yj+oXkbLSefK0YD3xuFk+kt1IUrtQahxSUmQ3Pr87t5pGb
         97q7yLBDAFPNexhxZAHj7SH1953Neit3GQ/g+KJS2daeGwJrgSqJvIfIErVz1OOeCRp4
         rFOAl7b90UgUyeEcaiDI4hZy4X/Gi4VUl2EqBaH+IlBc6Dosca9X5Hg7wN4yrh014fJx
         iJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=POz7B/cNCWIJvz8pVnhM5ZDIV6/Scz9emQ4JSgg4ILI=;
        b=Iu5zek2zhyuI7i5WP/17vtDlgNWAaW41KpDBLoW9PvJ/1GhxIB5M565cZcNN/Ec7bn
         w99hSYK1iXR8D9ovDAdWNY8+pm5HtyaBCi6Zhb9jJbV5MYwYWhdKYmj/BZoxjIIGKDJ1
         7c6PFZV2ZDFPYviTsngJR3DK/nL8Gb84QtQgFfwbDDpcPR4+owfRhmVWF7F4GkUGU2qV
         WVIFdJ+tkkc/ui9CP+PWLqS11baW1olpmk/IzqU1/KEJ+LjeOl8d2jXBj5KxqChnkCnz
         YqL9awS9cimpfHU/QH+2l4PySkOl0Jb1gmqPHH/CsJus3gAAav3DlQdwP+TMnVUhXMkr
         281A==
X-Gm-Message-State: AOAM533j8jHJNdKIkSIqUfu92pVYD/NVs58ZKDKUOGGkfUqzEYfzTYkV
        1yu+GPWgJwdRMZa6EOX4x4QAVJ1WBpE=
X-Google-Smtp-Source: ABdhPJxor5xhIiir+rlfX4NN3Tltf+5WOYXkICH5V/MRfR2mEDMyoGuvsepaqlCaCVE4zQo+b6cTwA==
X-Received: by 2002:a17:90a:b78d:: with SMTP id m13mr11362403pjr.17.1631750956120;
        Wed, 15 Sep 2021 17:09:16 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v3sm860833pfc.193.2021.09.15.17.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 17:09:15 -0700 (PDT)
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
Subject: [PATCH net-next] net: phy: broadcom: Enable 10BaseT DAC early wake
Date:   Wed, 15 Sep 2021 17:09:03 -0700
Message-Id: <20210916000904.193343-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the DAC early wake when then link operates at 10BaseT allows
power savings in the hundreds of milli Watts by shutting down the
transmitter. A number of errata have been issued for various Gigabit
PHYs and the recommendation is to enable both the early and forced DAC
wake to be on the safe side. This needs to be done dynamically based
upon the link state, which is why a link_change_notify callback is
utilized.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 47 ++++++++++++++++++++++++++++++++++++++
 include/linux/brcmphy.h    |  1 +
 2 files changed, 48 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 83aea5c5cd03..f8df692fc3ee 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -702,6 +702,36 @@ static void bcm54xx_get_stats(struct phy_device *phydev,
 	bcm_phy_get_stats(phydev, priv->stats, stats, data);
 }
 
+static void bcm54xx_link_change_notify(struct phy_device *phydev)
+{
+	u16 mask = MII_BCM54XX_EXP_EXP08_EARLY_DAC_WAKE |
+		   MII_BCM54XX_EXP_EXP08_FORCE_DAC_WAKE;
+	int ret;
+
+	if (phydev->state != PHY_RUNNING)
+	       return;
+
+	/* Don't change the DAC wake settings if auto power down
+	 * is not requested.
+	 */
+	if (!(phydev->dev_flags & PHY_BRCM_AUTO_PWRDWN_ENABLE))
+		return;
+
+	ret = bcm_phy_read_exp(phydev, MII_BCM54XX_EXP_EXP08);
+	if (ret < 0)
+		return;
+
+	/* Enable/disable 10BaseT auto and forced early DAC wake depending
+	 * on the negotiated speed, those settings should only be done
+	 * for 10Mbits/sec.
+	 */
+	if (phydev->speed == SPEED_10)
+		ret |= mask;
+	else
+		ret &= ~mask;
+	bcm_phy_write_exp(phydev, MII_BCM54XX_EXP_EXP08, ret);
+}
+
 static struct phy_driver broadcom_drivers[] = {
 {
 	.phy_id		= PHY_ID_BCM5411,
@@ -715,6 +745,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_BCM5421,
 	.phy_id_mask	= 0xfffffff0,
@@ -727,6 +758,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_BCM54210E,
 	.phy_id_mask	= 0xfffffff0,
@@ -739,6 +771,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_BCM5461,
 	.phy_id_mask	= 0xfffffff0,
@@ -751,6 +784,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_BCM54612E,
 	.phy_id_mask	= 0xfffffff0,
@@ -763,6 +797,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_BCM54616S,
 	.phy_id_mask	= 0xfffffff0,
@@ -774,6 +809,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.read_status	= bcm54616s_read_status,
 	.probe		= bcm54616s_probe,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_BCM5464,
 	.phy_id_mask	= 0xfffffff0,
@@ -788,6 +824,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_BCM5481,
 	.phy_id_mask	= 0xfffffff0,
@@ -801,6 +838,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_aneg	= bcm5481_config_aneg,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id         = PHY_ID_BCM54810,
 	.phy_id_mask    = 0xfffffff0,
@@ -816,6 +854,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.suspend	= genphy_suspend,
 	.resume		= bcm54xx_resume,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id         = PHY_ID_BCM54811,
 	.phy_id_mask    = 0xfffffff0,
@@ -831,6 +870,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.suspend	= genphy_suspend,
 	.resume		= bcm54xx_resume,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_BCM5482,
 	.phy_id_mask	= 0xfffffff0,
@@ -843,6 +883,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_BCM50610,
 	.phy_id_mask	= 0xfffffff0,
@@ -855,6 +896,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_BCM50610M,
 	.phy_id_mask	= 0xfffffff0,
@@ -867,6 +909,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_BCM57780,
 	.phy_id_mask	= 0xfffffff0,
@@ -879,6 +922,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_BCMAC131,
 	.phy_id_mask	= 0xfffffff0,
@@ -905,6 +949,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.get_strings	= bcm_phy_get_strings,
 	.get_stats	= bcm54xx_get_stats,
 	.probe		= bcm54xx_phy_probe,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_BCM53125,
 	.phy_id_mask	= 0xfffffff0,
@@ -918,6 +963,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
+	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
 	.phy_id         = PHY_ID_BCM89610,
 	.phy_id_mask    = 0xfffffff0,
@@ -930,6 +976,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init    = bcm54xx_config_init,
 	.config_intr    = bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
+	.link_change_notify	= bcm54xx_link_change_notify,
 } };
 
 module_phy_driver(broadcom_drivers);
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index c2c2147dfeb8..3308cebe1c19 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -233,6 +233,7 @@
 #define MII_BCM54XX_EXP_EXP08			0x0F08
 #define  MII_BCM54XX_EXP_EXP08_RJCT_2MHZ	0x0001
 #define  MII_BCM54XX_EXP_EXP08_EARLY_DAC_WAKE	0x0200
+#define  MII_BCM54XX_EXP_EXP08_FORCE_DAC_WAKE	0x0100
 #define MII_BCM54XX_EXP_EXP75			0x0f75
 #define  MII_BCM54XX_EXP_EXP75_VDACCTRL		0x003c
 #define  MII_BCM54XX_EXP_EXP75_CM_OSC		0x0001
-- 
2.25.1

