Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4115D31720D
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhBJVLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:11:13 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:53755 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbhBJVJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:09:03 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 2360423E7C;
        Wed, 10 Feb 2021 22:08:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612991300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FW4BYWBqW8SNQrgsgk2uiH5A2nrDzGNuf5PphN8DTx8=;
        b=rQtszOHsi4BNUXhpRzj9rbugeIXBp7JATXL3lyZ5/Gb5IxdLzHPf/y89h+hLTd06nGGCgR
        I4Pg4mdGJFj0VUJcVIFthpm7U+BiL4Dejw7PWOxboC6xThN9EkaiEf5syOgAo+qWtLg+7I
        0ZKk9O7z47t+YlIUwuHLA5yAlOZP0Rk=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 7/9] net: phy: icplus: fix paged register access
Date:   Wed, 10 Feb 2021 22:08:07 +0100
Message-Id: <20210210210809.30125-8-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210210210809.30125-1-michael@walle.cc>
References: <20210210210809.30125-1-michael@walle.cc>
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

To ease the function reuse between the non-paged register space of the
IP101A and the IP101G, add noop read_page()/write_page() callbacks so
the IP101G functions can also be used for the IP101A.

Signed-off-by: Michael Walle <michael@walle.cc>
---
Changes since v2:
 - none

Changes since v1:
 - introduce a noop read/write_page() for the IP101A
 - also use phy_*_paged() for the interrupt status register

Andrew, I've dropped your Reviewed-by because of this.

 drivers/net/phy/icplus.c | 65 ++++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index bc2b58061507..7e0ef05b1cae 100644
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
@@ -211,23 +213,25 @@ static int ip101a_g_probe(struct phy_device *phydev)
 static int ip101a_g_config_intr_pin(struct phy_device *phydev)
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
@@ -241,7 +245,8 @@ static int ip101a_g_config_intr_pin(struct phy_device *phydev)
 		break;
 	}
 
-	return 0;
+out:
+	return phy_restore_page(phydev, oldpage, err);
 }
 
 static int ip101a_config_init(struct phy_device *phydev)
@@ -263,8 +268,10 @@ static int ip101g_config_init(struct phy_device *phydev)
 
 static int ip101a_g_ack_interrupt(struct phy_device *phydev)
 {
-	int err = phy_read(phydev, IP101A_G_IRQ_CONF_STATUS);
+	int err;
 
+	err = phy_read_paged(phydev, IP101G_DEFAULT_PAGE,
+			     IP101A_G_IRQ_CONF_STATUS);
 	if (err < 0)
 		return err;
 
@@ -283,10 +290,12 @@ static int ip101a_g_config_intr(struct phy_device *phydev)
 
 		/* INTR pin used: Speed/link/duplex will cause an interrupt */
 		val = IP101A_G_IRQ_PIN_USED;
-		err = phy_write(phydev, IP101A_G_IRQ_CONF_STATUS, val);
+		err = phy_write_paged(phydev, IP101G_DEFAULT_PAGE,
+				      IP101A_G_IRQ_CONF_STATUS, val);
 	} else {
 		val = IP101A_G_IRQ_ALL_MASK;
-		err = phy_write(phydev, IP101A_G_IRQ_CONF_STATUS, val);
+		err = phy_write_paged(phydev, IP101G_DEFAULT_PAGE,
+				      IP101A_G_IRQ_CONF_STATUS, val);
 		if (err)
 			return err;
 
@@ -300,7 +309,8 @@ static irqreturn_t ip101a_g_handle_interrupt(struct phy_device *phydev)
 {
 	int irq_status;
 
-	irq_status = phy_read(phydev, IP101A_G_IRQ_CONF_STATUS);
+	irq_status = phy_read_paged(phydev, IP101G_DEFAULT_PAGE,
+				    IP101A_G_IRQ_CONF_STATUS);
 	if (irq_status < 0) {
 		phy_error(phydev);
 		return IRQ_NONE;
@@ -316,6 +326,31 @@ static irqreturn_t ip101a_g_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
+/* The IP101A doesn't really have a page register. We just pretend to have one
+ * so we can use the paged versions of the callbacks of the IP101G.
+ */
+static int ip101a_read_page(struct phy_device *phydev)
+{
+	return IP101G_DEFAULT_PAGE;
+}
+
+static int ip101a_write_page(struct phy_device *phydev, int page)
+{
+	WARN_ONCE(page != IP101G_DEFAULT_PAGE, "wrong page selected\n");
+
+	return 0;
+}
+
+static int ip101g_read_page(struct phy_device *phydev)
+{
+	return __phy_read(phydev, IP101G_PAGE_CONTROL);
+}
+
+static int ip101g_write_page(struct phy_device *phydev, int page)
+{
+	return __phy_write(phydev, IP101G_PAGE_CONTROL, page);
+}
+
 static int ip101a_g_has_page_register(struct phy_device *phydev)
 {
 	int oldval, val, ret;
@@ -390,6 +425,8 @@ static struct phy_driver icplus_driver[] = {
 	.name		= "ICPlus IP101A",
 	.match_phy_device = ip101a_match_phy_device,
 	.probe		= ip101a_g_probe,
+	.read_page	= ip101a_read_page,
+	.write_page	= ip101a_write_page,
 	.config_intr	= ip101a_g_config_intr,
 	.handle_interrupt = ip101a_g_handle_interrupt,
 	.config_init	= ip101a_config_init,
@@ -400,6 +437,8 @@ static struct phy_driver icplus_driver[] = {
 	.name		= "ICPlus IP101G",
 	.match_phy_device = ip101g_match_phy_device,
 	.probe		= ip101a_g_probe,
+	.read_page	= ip101g_read_page,
+	.write_page	= ip101g_write_page,
 	.config_intr	= ip101a_g_config_intr,
 	.handle_interrupt = ip101a_g_handle_interrupt,
 	.config_init	= ip101g_config_init,
-- 
2.20.1

