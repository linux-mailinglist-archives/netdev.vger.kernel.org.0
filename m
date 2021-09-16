Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BFF40ECAA
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 23:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240521AbhIPV3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 17:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbhIPV3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 17:29:06 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9DAC061574;
        Thu, 16 Sep 2021 14:27:45 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so5764055pjb.5;
        Thu, 16 Sep 2021 14:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OYuEFVk3aDUKrCKS6CHyVrrbpl3gbWP0phHTPvsSdm8=;
        b=e2O1Dqt3lbj2k4QhDjRyMkWQJOyU3dM+ebyvQCkJeZwcyWwnUlegmgqiAZN4og34GD
         vezcukP7m8rccR8sIhOyD7m3+uA4I62IEYU1+i4SxhAYmfLaCnq3zZSLCQpRBaNcz8KQ
         IY84yIqcEgxMcuAgSCFnBaRHUZo2lWLqiUpFG56LTjUXuQftkf6Ur0IZ9tCS/8E91auV
         F4Rn0BwfaS5Za5Kg5It3CIq31H3oZ/EcQhHW3U1PIere0EuIj9FcfIE5rAARySXqizn2
         7Ady6mEA9yz7/fcze7YkmBeLJJsFkA1KqaSUTT7nlS2AlZfcc0CEYm/z/Zui2/p3lO2k
         IVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OYuEFVk3aDUKrCKS6CHyVrrbpl3gbWP0phHTPvsSdm8=;
        b=5lrVkMebTo1ykvHZIYf0tCi+OfgdOqL54sL5ey1aWQrcyR8BqxC7xD7ZsEZphTiMMe
         zXWYCZ9yTS1Fi+OYNN+0Y4P7lLZBfrpnntYDw0Imtyfx1DLV6J8ErQF+MAI2PFe07TYt
         qXYko6JPUfisQOH479QcLE8/LWVcQpgedgCohf44t14HWQtKj0HH7mLqO4Lxo7kc8sVa
         4cUV+jT7KFsHT/y8teNSpNDrrCecb1NeCN4eVSUY/BZ9IKuVIPELXt5frB4zrC4N/xUi
         hUHQ/W4qHclCxh8I7JW/pNMarM1e27JAB6+VdE7sHsOE/BSrhUECRZTdi6BxyLcnWiPD
         Yrlg==
X-Gm-Message-State: AOAM533P2VF4mLle3JWRA5NFL1/VWd0Z+JDPTcYN0qeZZ3n/b1iYlvNi
        XZEB5n5+NJX+wgLWRG3Gc9kGGmjzxUk=
X-Google-Smtp-Source: ABdhPJygu8QlN9cLofY91/nDDBnkP0X6ySAtEgv2fblpJ07D+YDbaO8kot5lPry4mPUdQhvwHmsOnw==
X-Received: by 2002:a17:90b:4a44:: with SMTP id lb4mr17171888pjb.140.1631827664714;
        Thu, 16 Sep 2021 14:27:44 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q22sm4207987pgn.67.2021.09.16.14.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 14:27:44 -0700 (PDT)
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
Subject: [PATCH net-next v2] net: phy: broadcom: Enable 10BaseT DAC early wake
Date:   Thu, 16 Sep 2021 14:27:41 -0700
Message-Id: <20210916212742.1653088-1-f.fainelli@gmail.com>
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
Changes in v2:

- fixed checkpath warning on the return statuement in the
  link_change_notify callback

 drivers/net/phy/broadcom.c | 47 ++++++++++++++++++++++++++++++++++++++
 include/linux/brcmphy.h    |  1 +
 2 files changed, 48 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 83aea5c5cd03..add0c4e33425 100644
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
+		return;
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

