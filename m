Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5717C318608
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 09:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhBKIBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 03:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhBKIBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 03:01:34 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D1AC0613D6;
        Wed, 10 Feb 2021 23:48:38 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 2BD2F23E85;
        Thu, 11 Feb 2021 08:48:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613029680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wiZYNhQ2x4onZqV5fgj1g6hkLOHLENNpi7EjoGGlLok=;
        b=rXi1/nsdDL1gRusrH8EUrjnm2W8m94Ie3aMJL5FI9goEufj6+DjrBsZQqsaH9SyUGzo7wF
        +6hg/ltJyQglmrtsaVWbHmFtc5vmGfm0pIuaVXCbPbgVHWzurXZk23lcM4xhk/o7+LpStJ
        nucM/3q9m4rbfmEtS4LNkyU18J6j0aM=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v4 5/9] net: phy: icplus: split IP101A/G driver
Date:   Thu, 11 Feb 2021 08:47:46 +0100
Message-Id: <20210211074750.28674-6-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210211074750.28674-1-michael@walle.cc>
References: <20210211074750.28674-1-michael@walle.cc>
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
Changes since v3:
 - none

Changes since v2:
 - dropped the PHY_BASIC_FEATURES comments as suggested by Heiner
 - converted the ternary operator to a simple comparison as suggested by
   Heiner

Changes since v1:
 - use match_phy_device() as suggested by Heiner

Andrew, I've dropped your Reviewed-by because of this.

 drivers/net/phy/icplus.c | 69 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index 036bac628b11..dee4f4d988a2 100644
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
+	return ip101a == !ret;
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
@@ -320,9 +374,18 @@ static struct phy_driver icplus_driver[] = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	PHY_ID_MATCH_EXACT(IP101A_PHY_ID),
-	.name		= "ICPlus IP101A/G",
-	/* PHY_BASIC_FEATURES */
+	.name		= "ICPlus IP101A",
+	.match_phy_device = ip101a_match_phy_device,
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
 	.probe		= ip101a_g_probe,
 	.config_intr	= ip101a_g_config_intr,
 	.handle_interrupt = ip101a_g_handle_interrupt,
-- 
2.20.1

