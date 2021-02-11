Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1113185E2
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 08:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhBKHwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 02:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhBKHvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 02:51:47 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE644C061788;
        Wed, 10 Feb 2021 23:51:48 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id B22A823E87;
        Thu, 11 Feb 2021 08:48:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613029681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oyfqCI632+mvcyehpJ9shc2ihi7ISSd+yQD5qpx00eU=;
        b=uUGd29/euwafDHJxphledWYl1OUpILh4g7hgyrmt7tJi5g0vsPqCqlIPtbNbsQvohLVwU5
        g2i+B7xGeUAV/5aKbKa35GNLk+TMj5Uk/dNzVMhWxtLVoIf6YaOGioK8YaJ3yt0QoeKJQb
        LP9F1LrfEWG2cihbVyuYcoDk26wTWTE=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v4 7/9] net: phy: icplus: fix paged register access
Date:   Thu, 11 Feb 2021 08:47:48 +0100
Message-Id: <20210211074750.28674-8-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210211074750.28674-1-michael@walle.cc>
References: <20210211074750.28674-1-michael@walle.cc>
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
Changes since v3:
 - added return code check on phy_select_page()
 - initialize err, found by kernel test robot

Changes since v2:
 - none

Changes since v1:
 - introduce a noop read/write_page() for the IP101A
 - also use phy_*_paged() for the interrupt status register

Andrew, I've dropped your Reviewed-by because of this.

 drivers/net/phy/icplus.c | 67 ++++++++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index bc2b58061507..f98edd66cdd2 100644
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
@@ -211,23 +213,27 @@ static int ip101a_g_probe(struct phy_device *phydev)
 static int ip101a_g_config_intr_pin(struct phy_device *phydev)
 {
 	struct ip101a_g_phy_priv *priv = phydev->priv;
-	int err;
+	int oldpage, err = 0;
+
+	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
+	if (oldpage < 0)
+		return oldpage;
 
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
@@ -241,7 +247,8 @@ static int ip101a_g_config_intr_pin(struct phy_device *phydev)
 		break;
 	}
 
-	return 0;
+out:
+	return phy_restore_page(phydev, oldpage, err);
 }
 
 static int ip101a_config_init(struct phy_device *phydev)
@@ -263,8 +270,10 @@ static int ip101g_config_init(struct phy_device *phydev)
 
 static int ip101a_g_ack_interrupt(struct phy_device *phydev)
 {
-	int err = phy_read(phydev, IP101A_G_IRQ_CONF_STATUS);
+	int err;
 
+	err = phy_read_paged(phydev, IP101G_DEFAULT_PAGE,
+			     IP101A_G_IRQ_CONF_STATUS);
 	if (err < 0)
 		return err;
 
@@ -283,10 +292,12 @@ static int ip101a_g_config_intr(struct phy_device *phydev)
 
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
 
@@ -300,7 +311,8 @@ static irqreturn_t ip101a_g_handle_interrupt(struct phy_device *phydev)
 {
 	int irq_status;
 
-	irq_status = phy_read(phydev, IP101A_G_IRQ_CONF_STATUS);
+	irq_status = phy_read_paged(phydev, IP101G_DEFAULT_PAGE,
+				    IP101A_G_IRQ_CONF_STATUS);
 	if (irq_status < 0) {
 		phy_error(phydev);
 		return IRQ_NONE;
@@ -316,6 +328,31 @@ static irqreturn_t ip101a_g_handle_interrupt(struct phy_device *phydev)
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
@@ -390,6 +427,8 @@ static struct phy_driver icplus_driver[] = {
 	.name		= "ICPlus IP101A",
 	.match_phy_device = ip101a_match_phy_device,
 	.probe		= ip101a_g_probe,
+	.read_page	= ip101a_read_page,
+	.write_page	= ip101a_write_page,
 	.config_intr	= ip101a_g_config_intr,
 	.handle_interrupt = ip101a_g_handle_interrupt,
 	.config_init	= ip101a_config_init,
@@ -400,6 +439,8 @@ static struct phy_driver icplus_driver[] = {
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

