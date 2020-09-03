Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EE425B9D3
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 06:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgICEj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 00:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgICEj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 00:39:56 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AFCC061244;
        Wed,  2 Sep 2020 21:39:55 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k15so1208092pfc.12;
        Wed, 02 Sep 2020 21:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bJfek8aeEFYuux0PmNYcQKoOxU0snqU5ziyHqUdHSPQ=;
        b=c/XG1KqHCkGvWpBq6tjP4iOl3Um9xh/Jx2HNNZDgcP3QVoQ2i12b5RuRCJHe/E4vOP
         27zSqJ0MDjy71xu5BZQMV8k4cq1/VfrSK72V+q9iHEEV29sVidr8zNjlx5ZY9YPIHRFn
         B4qaINEcecYsNy7pyvX/HTR52nqs1ZMFarkfUWCrMt1uFjA94fdlz4dWi7EpyY2tRRNO
         MbL6MgcTRwSB2EvIHYKcAMvwflU38uxI8tlt49i3BoSkLqpNLpTYc8ZUaPxl4iJkuwFj
         eIc/ZF+mxpO1zq3XTHPbjWpcuuJMMX8btReFPp0e21SzIvZHZkd1Tsu2D6fJIiSLRN0i
         dgMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bJfek8aeEFYuux0PmNYcQKoOxU0snqU5ziyHqUdHSPQ=;
        b=np/qTjGzqe9SRkyQeMSLo7UfV2YCwo1AO4JbSXPl2UuwGzMHWFMqLUIq2hb1Zh6wTV
         5dF7dNmEz/t0RRVhHDGyc6NluyPUv31JxlECqE4nciiIcsuaYiUZ6PPN4IwZo/jR2HwU
         53P76XqUOGvbUQFFL8SiEXRqmym25P4KE4RCZEevvGIm89BCg/bwzmRYd1TDc95dIiLL
         /q/lNEQbFbjaO25ww1auaULmyw4+5qt/TMFPjwaum4hN2Rpw+CKn4FdfqAbO4rQVVheM
         3vZXGJTzKnG6u1E6PsYNj7nSI0g5fHsh26bGVzAMZ7i7PpWuuBOM5PylyZy8RHSAae2m
         aSbQ==
X-Gm-Message-State: AOAM530f1pnFaIYCv6AncuPEGuLm6e5/hYz0OmVjlS27MNAepmLflm4j
        vL2C1dg06zw5H7ki4EgJcYxyzmbe2Pc=
X-Google-Smtp-Source: ABdhPJzE0D1ypvC4MxyrRyqlJoNVxCgPfQDffUeFYVCYUwl8Wc6QNvgK9hHQA96xPzVlEt64Vz2iGQ==
X-Received: by 2002:aa7:870f:: with SMTP id b15mr1981750pfo.113.1599107994940;
        Wed, 02 Sep 2020 21:39:54 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u63sm1251805pfu.34.2020.09.02.21.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 21:39:52 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        adam.rudzinski@arf.net.pl, m.felsch@pengutronix.de,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
Subject: [PATCH net-next 1/3] net: phy: Support enabling clocks prior to bus probe
Date:   Wed,  2 Sep 2020 21:39:45 -0700
Message-Id: <20200903043947.3272453-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200903043947.3272453-1-f.fainelli@gmail.com>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
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
 drivers/net/phy/phy_device.c | 15 +++++-
 drivers/of/of_mdio.c         | 95 ++++++++++++++++++++++++++++++++++++
 include/linux/of_mdio.h      | 16 ++++++
 include/linux/phy.h          | 13 +++++
 4 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 57d44648c8dd..bf2824ba056e 100644
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
@@ -2845,6 +2846,15 @@ static int phy_probe(struct device *dev)
 
 	mutex_lock(&phydev->lock);
 
+	/* To allow PHY drivers to manage device resources such as
+	 * clocks, regulators or others, disable the resources that
+	 * were enabled during the bus->reset or the PHY registration
+	 * routine such that they work with a natural resource reference
+	 * count.
+	 */
+	of_mdiobus_device_disable_resources(phydev->mdio.bus,
+					    phydev->mdio.addr);
+
 	/* Deassert the reset signal */
 	phy_device_reset(phydev, 0);
 
@@ -2914,8 +2924,11 @@ static int phy_probe(struct device *dev)
 
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
index cb32d7ef4938..bbce4a70312c 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -19,6 +19,7 @@
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/module.h>
+#include <linux/clk.h>
 
 #define DEFAULT_GPIO_RESET_DELAY	10	/* in microseconds */
 
@@ -60,6 +61,92 @@ static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
 	return register_mii_timestamper(arg.np, arg.args[0]);
 }
 
+int of_mdiobus_device_enable_resources(struct mii_bus *bus,
+				       struct device_node *child,
+				       u32 addr)
+{
+	struct mdio_device_resource *res = &bus->mdio_resources[addr];
+	unsigned int i;
+	int rc;
+
+	if (res->enabled_resources) {
+		dev_dbg(&bus->dev,
+			"MDIO resources for %d already enabled\n", addr);
+		return 0;
+	}
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
+	res->enabled_resources = true;
+
+	return 0;
+
+out_clk_disable:
+	while (i-- > 0) {
+		clk_disable_unprepare(res->clks[i]);
+		clk_put(res->clks[i]);
+	}
+	res->enabled_resources = false;
+	return rc;
+}
+EXPORT_SYMBOL(of_mdiobus_device_enable_resources);
+
+void of_mdiobus_device_disable_resources(struct mii_bus *bus, u32 addr)
+{
+	struct mdio_device_resource *res = &bus->mdio_resources[addr];
+	unsigned int i;
+
+	if (!res->enabled_resources || res->num_clks == 0)
+		return;
+
+	for (i = 0; i < res->num_clks; i++) {
+		clk_disable_unprepare(res->clks[i]);
+		clk_put(res->clks[i]);
+		dev_dbg(&bus->dev, "Disabled clk %d for %d\n", i, addr);
+	}
+	res->enabled_resources = false;
+}
+EXPORT_SYMBOL(of_mdiobus_device_disable_resources);
+
 int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
 			      struct device_node *child, u32 addr)
 {
@@ -117,6 +204,12 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
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
 
@@ -125,6 +218,7 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	else
 		phy = get_phy_device(mdio, addr, is_c45);
 	if (IS_ERR(phy)) {
+		of_mdiobus_device_disable_resources(mdio, addr);
 		if (mii_ts)
 			unregister_mii_timestamper(mii_ts);
 		return PTR_ERR(phy);
@@ -132,6 +226,7 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 
 	rc = of_mdiobus_phy_device_register(mdio, phy, child, addr);
 	if (rc) {
+		of_mdiobus_device_disable_resources(mdio, addr);
 		if (mii_ts)
 			unregister_mii_timestamper(mii_ts);
 		phy_device_free(phy);
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 1efb88d9f892..f43f4bcb3f22 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -58,6 +58,10 @@ static inline int of_mdio_parse_addr(struct device *dev,
 	return addr;
 }
 
+int of_mdiobus_device_enable_resources(struct mii_bus *mdio,
+				       struct device_node *child, u32 addr);
+void of_mdiobus_device_disable_resources(struct mii_bus *mdio, u32 addr);
+
 #else /* CONFIG_OF_MDIO */
 static inline bool of_mdiobus_child_is_phy(struct device_node *child)
 {
@@ -129,6 +133,18 @@ static inline int of_mdiobus_phy_device_register(struct mii_bus *mdio,
 {
 	return -ENOSYS;
 }
+
+static inline int of_mdiobus_device_enable_resources(struct mii_bus *mdio,
+						     struct device_node *child,
+						     u32 addr)
+{
+	return 0;
+}
+
+static inline void of_mdiobus_device_disable_resources(struct mii_bus *mdio,
+						       u32 addr)
+{
+}
 #endif
 
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3a09d2bf69ea..a01953daea45 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -247,6 +247,14 @@ struct phy_package_shared {
 #define PHY_SHARED_F_INIT_DONE  0
 #define PHY_SHARED_F_PROBE_DONE 1
 
+struct clk;
+
+struct mdio_device_resource {
+	bool enabled_resources;
+	unsigned int num_clks;
+	struct clk **clks;
+};
+
 /*
  * The Bus class for PHYs.  Devices which provide access to
  * PHYs should register using this structure
@@ -291,6 +299,11 @@ struct mii_bus {
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

