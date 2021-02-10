Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3984C316BBE
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhBJQvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:51:52 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:60933 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbhBJQtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:49:51 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E8D5623E78;
        Wed, 10 Feb 2021 17:47:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612975679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aXY5b6Prd44tFP8lI/+FnuB8xC60RQtUTOPUWerwRN0=;
        b=hHxX8fmMOpjMxRSNwLPfEKyKE5aVPLxPQ4RqE5m9+DnpMun4YeFXF3m1WxcudpVqtQDfme
        Aphk4F6L+HkCWROW/Y6z2RpCc0rhkhcPacW6xuU0A7ZR7q14eiGWmZ+7t+HpMqlf6xC5Ly
        MbB9as3fCo6ZZiTzdrLwzcVtkzQH818=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 5/9] net: phy: icplus: split IP101A/G driver
Date:   Wed, 10 Feb 2021 17:47:42 +0100
Message-Id: <20210210164746.26336-6-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210210164746.26336-1-michael@walle.cc>
References: <20210210164746.26336-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately, the IP101A and IP101G share the same PHY identifier.
While most of the functions are somewhat backwards compatible, there is
for example the APS_EN bit on the IP101A but on the IP101G this bit
reserved. Also, the IP101G has many more functionalities.

Deduce the model by accessing the page select register which - according
to the datasheet - is not available on the IP101A. If this register is
writable, assume we have an IP101G.

Split the combined IP101A/G driver into two separate drivers.

Signed-off-by: Michael Walle <michael@walle.cc>
---
Changes since v1:
 - use match_phy_device() as suggested by Heiner

Andrew, I've dropped your Reviewed-by because of this.

 drivers/net/phy/icplus.c | 69 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index 036bac628b11..1bc9baa9048f 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -44,6 +44,8 @@ MODULE_LICENSE("GPL");
 #define IP101A_G_IRQ_DUPLEX_CHANGE	BIT(1)
 #define IP101A_G_IRQ_LINK_CHANGE	BIT(0)
 
+#define IP101G_PAGE_CONTROL				0x14
+#define IP101G_PAGE_CONTROL_MASK			GENMASK(4, 0)
 #define IP101G_DIGITAL_IO_SPEC_CTRL			0x1d
 #define IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32		BIT(2)
 
@@ -301,6 +303,58 @@ static irqreturn_t ip101a_g_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
+static int ip101a_g_has_page_register(struct phy_device *phydev)
+{
+	int oldval, val, ret;
+
+	oldval = phy_read(phydev, IP101G_PAGE_CONTROL);
+	if (oldval < 0)
+		return oldval;
+
+	ret = phy_write(phydev, IP101G_PAGE_CONTROL, 0xffff);
+	if (ret)
+		return ret;
+
+	val = phy_read(phydev, IP101G_PAGE_CONTROL);
+	if (val < 0)
+		return val;
+
+	ret = phy_write(phydev, IP101G_PAGE_CONTROL, oldval);
+	if (ret)
+		return ret;
+
+	return val == IP101G_PAGE_CONTROL_MASK;
+}
+
+static int ip101a_g_match_phy_device(struct phy_device *phydev, bool ip101a)
+{
+	int ret;
+
+	if (phydev->phy_id != IP101A_PHY_ID)
+		return 0;
+
+	/* The IP101A and the IP101G share the same PHY identifier.The IP101G
+	 * seems to be a successor of the IP101A and implements more functions.
+	 * Amongst other things there is a page select register, which is not
+	 * available on the IP101A. Use this to distinguish these two.
+	 */
+	ret = ip101a_g_has_page_register(phydev);
+	if (ret < 0)
+		return ret;
+
+	return (ip101a) ? !ret : ret;
+}
+
+static int ip101a_match_phy_device(struct phy_device *phydev)
+{
+	return ip101a_g_match_phy_device(phydev, true);
+}
+
+static int ip101g_match_phy_device(struct phy_device *phydev)
+{
+	return ip101a_g_match_phy_device(phydev, false);
+}
+
 static struct phy_driver icplus_driver[] = {
 {
 	PHY_ID_MATCH_MODEL(IP175C_PHY_ID),
@@ -320,8 +374,19 @@ static struct phy_driver icplus_driver[] = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	PHY_ID_MATCH_EXACT(IP101A_PHY_ID),
-	.name		= "ICPlus IP101A/G",
+	.name		= "ICPlus IP101A",
+	.match_phy_device = ip101a_match_phy_device,
+	/* PHY_BASIC_FEATURES */
+	.probe		= ip101a_g_probe,
+	.config_intr	= ip101a_g_config_intr,
+	.handle_interrupt = ip101a_g_handle_interrupt,
+	.config_init	= ip101a_g_config_init,
+	.soft_reset	= genphy_soft_reset,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
+}, {
+	.name		= "ICPlus IP101G",
+	.match_phy_device = ip101g_match_phy_device,
 	/* PHY_BASIC_FEATURES */
 	.probe		= ip101a_g_probe,
 	.config_intr	= ip101a_g_config_intr,
-- 
2.20.1

