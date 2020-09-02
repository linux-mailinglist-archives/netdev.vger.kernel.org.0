Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA68825B5F4
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 23:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgIBVd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 17:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgIBVd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 17:33:56 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6F8C061244;
        Wed,  2 Sep 2020 14:33:54 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q1so421887pjd.1;
        Wed, 02 Sep 2020 14:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wwQhJe7BDA+dRYlJMAhU5uCJHGzMktdgwAh4UTxU0ws=;
        b=ZapqO12JE0nUAL7Qj2oLr8F0E8wRGvQPV/ui8MVv+MVfeR0bso2HmD96rFGPSKguGo
         j44NJh3YO8oSwK16gDwH/KjsLhLzHS/Br+TqN8Ti+RtPUIqFrmQ8qTxz2AqueWMUib/b
         EjHwLrGBFzqAV3dQ1KtJbMiJmSOFmL1sQKxO93FzwGmPe8bcgbU8yrnQJGt7tvs8UpZT
         3WZ18PovXAtS4kci9PEeiWpJz9K0lzYYFsMyNGD+yIX7qJLCjfrBtHeukQII9QMi7lzI
         oY7W9DIxZVaE5XwjWjkpJb48vIrOcxHBuWJinhqhU98+c7juS5c17PEpxEnkTWxywuwt
         +kQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wwQhJe7BDA+dRYlJMAhU5uCJHGzMktdgwAh4UTxU0ws=;
        b=fmn2R5RXLrJIG5Og1j6Kep/+6M4tpogMsmcORW5s08l1PXnZGD0/pqWcx0l9m8eVJS
         v5uQjHL65Tn5eHuYvPrVDESya35rb2SKHGiiZolgflUO8RyoQBaTPu/ba2Cv+JYjjjaM
         ZdoYhmRKXeV+NEMXiB4wamjfpJWgptNJ7Sp+tugNxoYuDWd3LvNAjltQTttNnT4YdbAg
         w4RPBl+rL9jRYxWaeoYYaLc17WMwTd9UBFhGpVRoBtNL0UBdYd064+LZJfVPvgnJ9sa+
         r0jiaWM6y7khUdiegSuxn3i4G9SpSWey+vvoN+vYc+6Em82mva1H25aNCDxVsqyEARt4
         svAg==
X-Gm-Message-State: AOAM530Na5qSsNm0bTHU2EzY60qN+13dmzss04I6YAsp78K/CVk3+AtU
        95Mwx5mMWrbQGGq+alrBVvcdonFitl0=
X-Google-Smtp-Source: ABdhPJwJ/ehhOSV6rdxq2tVHNLMu/p1PP1BVtHiGl1xVev+AIDxP5WcK76VjbcFy3qCJFNenVAxoZA==
X-Received: by 2002:a17:90a:8b17:: with SMTP id y23mr3787136pjn.42.1599082433467;
        Wed, 02 Sep 2020 14:33:53 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g5sm466881pfh.168.2020.09.02.14.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 14:33:52 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        adam.rudzinski@arf.net.pl, m.felsch@pengutronix.de,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
Subject: [RFC net-next 1/2] net: phy: Support enabling clocks prior to bus probe
Date:   Wed,  2 Sep 2020 14:33:46 -0700
Message-Id: <20200902213347.3177881-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200902213347.3177881-1-f.fainelli@gmail.com>
References: <20200902213347.3177881-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some Ethernet PHYs may require that their clock, which typically drives
their logic to respond to reads on the MDIO bus be enabled before
issusing a MDIO bus scan.

We have a chicken and egg problem though which is that we cannot enable
a given Ethernet PHY's device clock until we have a phy_device instance
create and called the driver's probe function. This will not happen
unless we are successful in probing the PHY device, which requires its
clock(s) to be turned on.

For DT based systems we can solve this by using of_clk_get() which
operates on a device_node reference, and make sure that all clocks
associaed with the node are enabled prior to doing any reads towards the
device. In order to avoid drivers having to know the a priori reference
count of the resources, we drop them back to 0 right before calling
->probe() which is then supposed to manage the resources normally.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c |  6 ++-
 drivers/of/of_mdio.c         | 84 ++++++++++++++++++++++++++++++++++++
 include/linux/of_mdio.h      |  7 +++
 include/linux/phy.h          | 12 ++++++
 4 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 57d44648c8dd..f3f67dee0309 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
 #include <linux/property.h>
@@ -2914,8 +2915,11 @@ static int phy_probe(struct device *dev)
 
 out:
 	/* Assert the reset signal */
-	if (err)
+	if (err) {
 		phy_device_reset(phydev, 1);
+		of_mdiobus_device_disable_resources(phydev->mdio.bus,
+						    phydev->mdio.addr);
+	}
 
 	mutex_unlock(&phydev->lock);
 
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index cb32d7ef4938..de5e3388b581 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -19,6 +19,7 @@
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/module.h>
+#include <linux/clk.h>
 
 #define DEFAULT_GPIO_RESET_DELAY	10	/* in microseconds */
 
@@ -60,6 +61,81 @@ static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
 	return register_mii_timestamper(arg.np, arg.args[0]);
 }
 
+static int of_mdiobus_device_enable_resources(struct mii_bus *bus,
+					      struct device_node *child,
+					      u32 addr)
+{
+	struct mdio_device_resource *res = &bus->mdio_resources[addr];
+	unsigned int i;
+	int rc;
+
+	rc = of_count_phandle_with_args(child, "clocks", "#clock-cells");
+	if (rc < 0) {
+		if (rc == -ENOENT)
+			rc = 0;
+		else
+			return rc;
+	}
+
+	res->num_clks = rc;
+	if (rc == 0)
+		return rc;
+
+	dev_dbg(&bus->dev, "Found %d clocks for child at %d\n", rc, addr);
+
+	res->clks = devm_kcalloc(&bus->dev, res->num_clks,
+				 sizeof(struct clk *), GFP_KERNEL);
+	if (!res->clks)
+		return -ENOMEM;
+
+	for (i = 0; i < res->num_clks; i++) {
+		res->clks[i] = of_clk_get(child, i);
+		if (IS_ERR(res->clks[i])) {
+			if (PTR_ERR(res->clks[i]) == -ENOENT)
+				continue;
+
+			return PTR_ERR(res->clks[i]);
+		}
+
+		rc = clk_prepare_enable(res->clks[i]);
+		if (rc) {
+			dev_err(&bus->dev,
+				"Failed to enabled clock for %d (rc: %d)\n",
+				addr, rc);
+			goto out_clk_disable;
+		}
+
+		dev_dbg(&bus->dev,
+			"Enable clock %d for child at %d\n",
+			i, addr);
+	}
+
+	return 0;
+
+out_clk_disable:
+	while (i-- > 0) {
+		clk_disable_unprepare(res->clks[i]);
+		clk_put(res->clks[i]);
+	}
+	return rc;
+}
+
+void of_mdiobus_device_disable_resources(struct mii_bus *bus, u32 addr)
+{
+	struct mdio_device_resource *res = &bus->mdio_resources[addr];
+	unsigned int i;
+
+	if (res->num_clks == 0)
+		return;
+
+	for (i = 0; i < res->num_clks; i++) {
+		clk_disable_unprepare(res->clks[i]);
+		clk_put(res->clks[i]);
+		dev_dbg(&bus->dev, "Disabled clk %d for %d\n", i, addr);
+	}
+}
+EXPORT_SYMBOL(of_mdiobus_device_disable_resources);
+
 int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
 			      struct device_node *child, u32 addr)
 {
@@ -117,6 +193,12 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	if (IS_ERR(mii_ts))
 		return PTR_ERR(mii_ts);
 
+	rc = of_mdiobus_device_enable_resources(mdio, child, addr);
+	if (rc) {
+		dev_err(&mdio->dev, "enable resources: %d\n", rc);
+		return rc;
+	}
+
 	is_c45 = of_device_is_compatible(child,
 					 "ethernet-phy-ieee802.3-c45");
 
@@ -125,6 +207,7 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	else
 		phy = get_phy_device(mdio, addr, is_c45);
 	if (IS_ERR(phy)) {
+		of_mdiobus_device_disable_resources(mdio, addr);
 		if (mii_ts)
 			unregister_mii_timestamper(mii_ts);
 		return PTR_ERR(phy);
@@ -132,6 +215,7 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 
 	rc = of_mdiobus_phy_device_register(mdio, phy, child, addr);
 	if (rc) {
+		of_mdiobus_device_disable_resources(mdio, addr);
 		if (mii_ts)
 			unregister_mii_timestamper(mii_ts);
 		phy_device_free(phy);
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 1efb88d9f892..c0041d2afb0e 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -58,6 +58,8 @@ static inline int of_mdio_parse_addr(struct device *dev,
 	return addr;
 }
 
+void of_mdiobus_device_disable_resources(struct mii_bus *mdio, u32 addr);
+
 #else /* CONFIG_OF_MDIO */
 static inline bool of_mdiobus_child_is_phy(struct device_node *child)
 {
@@ -129,6 +131,11 @@ static inline int of_mdiobus_phy_device_register(struct mii_bus *mdio,
 {
 	return -ENOSYS;
 }
+
+static inline void of_mdiobus_device_disable_resources(struct mii_bus *mdio,
+						       u32 addr)
+{
+}
 #endif
 
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3a09d2bf69ea..78e64acfc42e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -247,6 +247,13 @@ struct phy_package_shared {
 #define PHY_SHARED_F_INIT_DONE  0
 #define PHY_SHARED_F_PROBE_DONE 1
 
+struct clk;
+
+struct mdio_device_resource {
+	unsigned int num_clks;
+	struct clk **clks;
+};
+
 /*
  * The Bus class for PHYs.  Devices which provide access to
  * PHYs should register using this structure
@@ -291,6 +298,11 @@ struct mii_bus {
 	 */
 	int irq[PHY_MAX_ADDR];
 
+	/* An array of MDIO device resources that must be enabled
+	 * during probe for identification to succeed.
+	 */
+	struct mdio_device_resource mdio_resources[PHY_MAX_ADDR];
+
 	/* GPIO reset pulse width in microseconds */
 	int reset_delay_us;
 	/* GPIO reset deassert delay in microseconds */
-- 
2.25.1

