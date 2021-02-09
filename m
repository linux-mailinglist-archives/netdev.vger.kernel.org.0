Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A407131542B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhBIQnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:43:21 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:52765 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbhBIQlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 11:41:53 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BFA2923E78;
        Tue,  9 Feb 2021 17:41:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612888861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ImknOazSzQpowSEnHU6+SAQTIffxqAYlXcATmTGskyU=;
        b=spSjFO3KtBK2zuGwJmoCCeHO2/6rWY93O/54ERqX/fNXQQGuNSmJewjilyMPywTy+uxa44
        p0hKIhehyJwOAdJgxzZn0I4fQCQbsIjPDQyOhzuDYeKOiWJsLpr7eU/GakvkG9BezcLFvJ
        udBgpiTatY2qG/fH/L9h2WXBdoA5Z4A=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 7/9] net: phy: icplus: select page before writing control register
Date:   Tue,  9 Feb 2021 17:40:49 +0100
Message-Id: <20210209164051.18156-8-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210209164051.18156-1-michael@walle.cc>
References: <20210209164051.18156-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Registers >= 16 are paged. Be sure to set the page. It seems this was
working for now, because the default is correct for the registers used
in the driver at the moment. But this will also assume, nobody will
change the page select register before linux is started. The page select
register is _not_ reset with a soft reset of the PHY.

Add read_page()/write_page() support for the IP101G and use it
accordingly.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/icplus.c | 50 +++++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index a6e1c7611f15..858b9326a72d 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -49,6 +49,8 @@ MODULE_LICENSE("GPL");
 #define IP101G_DIGITAL_IO_SPEC_CTRL			0x1d
 #define IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32		BIT(2)
 
+#define IP101G_DEFAULT_PAGE			16
+
 #define IP175C_PHY_ID 0x02430d80
 #define IP1001_PHY_ID 0x02430d90
 #define IP101A_PHY_ID 0x02430c54
@@ -250,23 +252,25 @@ static int ip101a_g_probe(struct phy_device *phydev)
 static int ip101a_g_config_init(struct phy_device *phydev)
 {
 	struct ip101a_g_phy_priv *priv = phydev->priv;
-	int err;
+	int oldpage, err;
+
+	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
 
 	/* configure the RXER/INTR_32 pin of the 32-pin IP101GR if needed: */
 	switch (priv->sel_intr32) {
 	case IP101GR_SEL_INTR32_RXER:
-		err = phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
-				 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32, 0);
+		err = __phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
+				   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32, 0);
 		if (err < 0)
-			return err;
+			goto out;
 		break;
 
 	case IP101GR_SEL_INTR32_INTR:
-		err = phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
-				 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32,
-				 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32);
+		err = __phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
+				   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32,
+				   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32);
 		if (err < 0)
-			return err;
+			goto out;
 		break;
 
 	default:
@@ -284,12 +288,14 @@ static int ip101a_g_config_init(struct phy_device *phydev)
 	 * reserved as 'write-one'.
 	 */
 	if (priv->model == IP101A) {
-		err = phy_set_bits(phydev, IP10XX_SPEC_CTRL_STATUS, IP101A_G_APS_ON);
+		err = __phy_set_bits(phydev, IP10XX_SPEC_CTRL_STATUS,
+				     IP101A_G_APS_ON);
 		if (err)
-			return err;
+			goto out;
 	}
 
-	return 0;
+out:
+	return phy_restore_page(phydev, oldpage, err);
 }
 
 static int ip101a_g_ack_interrupt(struct phy_device *phydev)
@@ -347,6 +353,26 @@ static irqreturn_t ip101a_g_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
+static int ip101a_g_read_page(struct phy_device *phydev)
+{
+	struct ip101a_g_phy_priv *priv = phydev->priv;
+
+	if (priv->model == IP101A)
+		return 0;
+
+	return __phy_read(phydev, IP101G_PAGE_CONTROL);
+}
+
+static int ip101a_g_write_page(struct phy_device *phydev, int page)
+{
+	struct ip101a_g_phy_priv *priv = phydev->priv;
+
+	if (priv->model == IP101A)
+		return 0;
+
+	return __phy_write(phydev, IP101G_PAGE_CONTROL, page);
+}
+
 static struct phy_driver icplus_driver[] = {
 {
 	PHY_ID_MATCH_MODEL(IP175C_PHY_ID),
@@ -373,6 +399,8 @@ static struct phy_driver icplus_driver[] = {
 	.config_intr	= ip101a_g_config_intr,
 	.handle_interrupt = ip101a_g_handle_interrupt,
 	.config_init	= ip101a_g_config_init,
+	.read_page	= ip101a_g_read_page,
+	.write_page	= ip101a_g_write_page,
 	.soft_reset	= genphy_soft_reset,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
-- 
2.20.1

