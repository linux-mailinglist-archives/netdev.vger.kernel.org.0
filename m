Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1376317216
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhBJVMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:12:08 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:43009 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbhBJVJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:09:04 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 482C523E83;
        Wed, 10 Feb 2021 22:08:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612991301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IPzdzpCv5iJ0JCU3J6OhuVBzTLOea+RnWf/Wijzc2iU=;
        b=tN+tKRV09K9EzhZ/aoDmkOl726UsmTyvFepUCKiBSd6pTwD3YhUvHlyO6ccqhR4focMVZX
        8CfI0AYhrLYxPZ/oQ/L2rnIsOzqRPGaOzkzw3kHV5pvdFtfGQzXI7zqGzQoEaJ28cXLPMA
        2bFL1W7LSs5qFJrnOkymuOWOoOWVTy0=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 9/9] net: phy: icplus: add MDI/MDIX support for IP101A/G
Date:   Wed, 10 Feb 2021 22:08:09 +0100
Message-Id: <20210210210809.30125-10-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210210210809.30125-1-michael@walle.cc>
References: <20210210210809.30125-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the operations to set desired mode and retrieve the current
mode.

This feature was tested with an IP101G.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes since v2:
 - none

Changes since v1:
 - none, except that the callbacks are register for both IP101A and IP101G
   PHY drivers

 drivers/net/phy/icplus.c | 93 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index 96e9d1d12992..cc5b25714002 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -37,12 +37,17 @@ MODULE_LICENSE("GPL");
 #define IP1001_SPEC_CTRL_STATUS_2	20	/* IP1001 Spec. Control Reg 2 */
 #define IP1001_APS_ON			11	/* IP1001 APS Mode  bit */
 #define IP101A_G_APS_ON			BIT(1)	/* IP101A/G APS Mode bit */
+#define IP101A_G_AUTO_MDIX_DIS		BIT(11)
 #define IP101A_G_IRQ_CONF_STATUS	0x11	/* Conf Info IRQ & Status Reg */
 #define	IP101A_G_IRQ_PIN_USED		BIT(15) /* INTR pin used */
 #define IP101A_G_IRQ_ALL_MASK		BIT(11) /* IRQ's inactive */
 #define IP101A_G_IRQ_SPEED_CHANGE	BIT(2)
 #define IP101A_G_IRQ_DUPLEX_CHANGE	BIT(1)
 #define IP101A_G_IRQ_LINK_CHANGE	BIT(0)
+#define IP101A_G_PHY_STATUS		18
+#define IP101A_G_MDIX			BIT(9)
+#define IP101A_G_PHY_SPEC_CTRL		30
+#define IP101A_G_FORCE_MDIX		BIT(3)
 
 #define IP101G_PAGE_CONTROL				0x14
 #define IP101G_PAGE_CONTROL_MASK			GENMASK(4, 0)
@@ -297,6 +302,90 @@ static int ip101g_config_init(struct phy_device *phydev)
 	return ip101a_g_config_intr_pin(phydev);
 }
 
+static int ip101a_g_read_status(struct phy_device *phydev)
+{
+	int oldpage, ret, stat1, stat2;
+
+	ret = genphy_read_status(phydev);
+	if (ret)
+		return ret;
+
+	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
+
+	ret = __phy_read(phydev, IP10XX_SPEC_CTRL_STATUS);
+	if (ret < 0)
+		goto out;
+	stat1 = ret;
+
+	ret = __phy_read(phydev, IP101A_G_PHY_SPEC_CTRL);
+	if (ret < 0)
+		goto out;
+	stat2 = ret;
+
+	if (stat1 & IP101A_G_AUTO_MDIX_DIS) {
+		if (stat2 & IP101A_G_FORCE_MDIX)
+			phydev->mdix_ctrl = ETH_TP_MDI_X;
+		else
+			phydev->mdix_ctrl = ETH_TP_MDI;
+	} else {
+		phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+	}
+
+	if (stat2 & IP101A_G_MDIX)
+		phydev->mdix = ETH_TP_MDI_X;
+	else
+		phydev->mdix = ETH_TP_MDI;
+
+	ret = 0;
+
+out:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
+static int ip101a_g_config_mdix(struct phy_device *phydev)
+{
+	u16 ctrl = 0, ctrl2 = 0;
+	int oldpage, ret;
+
+	switch (phydev->mdix_ctrl) {
+	case ETH_TP_MDI:
+		ctrl = IP101A_G_AUTO_MDIX_DIS;
+		break;
+	case ETH_TP_MDI_X:
+		ctrl = IP101A_G_AUTO_MDIX_DIS;
+		ctrl2 = IP101A_G_FORCE_MDIX;
+		break;
+	case ETH_TP_MDI_AUTO:
+		break;
+	default:
+		return 0;
+	}
+
+	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
+
+	ret = __phy_modify(phydev, IP10XX_SPEC_CTRL_STATUS,
+			   IP101A_G_AUTO_MDIX_DIS, ctrl);
+	if (ret)
+		goto out;
+
+	ret = __phy_modify(phydev, IP101A_G_PHY_SPEC_CTRL,
+			   IP101A_G_FORCE_MDIX, ctrl2);
+
+out:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
+static int ip101a_g_config_aneg(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = ip101a_g_config_mdix(phydev);
+	if (ret)
+		return ret;
+
+	return genphy_config_aneg(phydev);
+}
+
 static int ip101a_g_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -502,6 +591,8 @@ static struct phy_driver icplus_driver[] = {
 	.config_intr	= ip101a_g_config_intr,
 	.handle_interrupt = ip101a_g_handle_interrupt,
 	.config_init	= ip101a_config_init,
+	.config_aneg	= ip101a_g_config_aneg,
+	.read_status	= ip101a_g_read_status,
 	.soft_reset	= genphy_soft_reset,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
@@ -514,6 +605,8 @@ static struct phy_driver icplus_driver[] = {
 	.config_intr	= ip101a_g_config_intr,
 	.handle_interrupt = ip101a_g_handle_interrupt,
 	.config_init	= ip101g_config_init,
+	.config_aneg	= ip101a_g_config_aneg,
+	.read_status	= ip101a_g_read_status,
 	.soft_reset	= genphy_soft_reset,
 	.get_sset_count = ip101g_get_sset_count,
 	.get_strings	= ip101g_get_strings,
-- 
2.20.1

