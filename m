Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E99E8EC7
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfJ2R5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:57:10 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:37493 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfJ2R5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:57:07 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7B83422EE9;
        Tue, 29 Oct 2019 18:48:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572371333;
        bh=lNMSL0kfIVGkynQCj6WK3Ply+NekAQJSK8m2Xt6TTEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBjNk3HPwEXhCqQElLjAIzGLECRccCBdIJwL+4YMhG3y29LQvXkxR17ymzdDJ2blT
         c+n1B5+eo7+Vvrt8rrnSWqkCVsm0nBX5UbkK2pSjZQcZ+NpocJ3VO9yVgc6WH47g8F
         bImRkrpqx/1rr0woWFZqA5k7wjXt2AAdJDmoHdVE=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>
Subject: [PATCH 3/3] net: phy: Use device tree properties to initialize any PHYs
Date:   Tue, 29 Oct 2019 18:48:19 +0100
Message-Id: <20191029174819.3502-4-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191029174819.3502-1-michael@walle.cc>
References: <20191029174819.3502-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some PHYs drivers, like the marvell and the broadcom one, are able to
initialize PHY registers via device tree properties. This patch adds a
more generic property which applies to any PHY. It supports clause-22,
clause-45 and paged PHY writes.

Hopefully, some board maintainers will pick this up and switch to this
instead of adding more phy_fixups in architecture specific code,
although it is board specific. For example have a look at
arch/arm/mach-imx/ for phy_register_fixup.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/phy_device.c | 97 +++++++++++++++++++++++++++++++++++-
 1 file changed, 96 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9d2bbb13293e..3c4cbaf72c27 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -30,6 +30,9 @@
 #include <linux/mdio.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/of.h>
+
+#include <dt-bindings/net/phy.h>
 
 MODULE_DESCRIPTION("PHY library");
 MODULE_AUTHOR("Andy Fleming");
@@ -1064,6 +1067,95 @@ static int phy_poll_reset(struct phy_device *phydev)
 	return 0;
 }
 
+/**
+ * phy_of_reg_init - Set and/or override configuration registers.
+ * @phydev: target phy_device struct
+ *
+ * Description: Set and/or override some configuration registers based
+ *   on the reg-init property stored in the of_node for the phydev.
+ *
+ *   reg-init = <dev reg mask value>,...;
+ *   There may be one or more sets of <dev reg mask value>:
+ */
+static int phy_of_reg_init(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	int oldpage = -1, savedpage = -1;
+	const __be32 *paddr;
+	int len, i;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_OF_MDIO))
+		return 0;
+
+	if (!node)
+		return 0;
+
+	paddr = of_get_property(node, "reg-init", &len);
+	if (!paddr || len < (4 * sizeof(*paddr)))
+		return 0;
+
+	mutex_lock(&phydev->mdio.bus->mdio_lock);
+
+	savedpage = -1;
+	len /= sizeof(*paddr);
+	for (i = 0; i < len - 3; i += 4) {
+		u32 dev = be32_to_cpup(paddr + i);
+		u16 reg = be32_to_cpup(paddr + i + 1);
+		u16 mask = be32_to_cpup(paddr + i + 2);
+		u16 val_bits = be32_to_cpup(paddr + i + 3);
+		int page = dev & 0xffff;
+		int devad = dev & 0x1f;
+		int val;
+
+		if (dev & PHY_REG_PAGE) {
+			if (savedpage < 0) {
+				savedpage = __phy_read_page(phydev);
+				if (savedpage < 0) {
+					ret = savedpage;
+					goto err;
+				}
+				oldpage = savedpage;
+			}
+			if (oldpage != page) {
+				ret = __phy_write_page(phydev, page);
+				if (ret < 0)
+					goto err;
+				oldpage = page;
+			}
+		}
+
+		val = 0;
+		if (mask) {
+			if (dev & PHY_REG_C45)
+				val = __phy_read_mmd(phydev, devad, reg);
+			else
+				val = __phy_read(phydev, reg);
+			if (val < 0) {
+				ret = val;
+				goto err;
+			}
+			val &= mask;
+		}
+		val |= val_bits;
+
+		if (dev & PHY_REG_C45)
+			ret = __phy_write_mmd(phydev, devad, reg, val);
+		else
+			ret = __phy_write(phydev, reg, val);
+		if (ret < 0)
+			goto err;
+	}
+
+err:
+	if (savedpage >= 0)
+		__phy_write_page(phydev, savedpage);
+
+	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+
+	return ret;
+}
+
 int phy_init_hw(struct phy_device *phydev)
 {
 	int ret = 0;
@@ -1087,7 +1179,10 @@ int phy_init_hw(struct phy_device *phydev)
 	if (phydev->drv->config_init)
 		ret = phydev->drv->config_init(phydev);
 
-	return ret;
+	if (ret < 0)
+		return ret;
+
+	return phy_of_reg_init(phydev);
 }
 EXPORT_SYMBOL(phy_init_hw);
 
-- 
2.20.1

