Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C4344AAEA
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 10:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245049AbhKIJxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 04:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245074AbhKIJxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 04:53:37 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7B9C061764;
        Tue,  9 Nov 2021 01:50:51 -0800 (PST)
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636451450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7YbG2hfMz6xW/PCCxdMREuP3ECE7JRXSaX6c5e8BiT4=;
        b=VQAKOd3FX8ayXWNWBddYNpGSWuEsHVO4+pJfdRXsv2nYwmgu8LiTmGLMjslL2E7BUTbJNh
        dUcbW88NEmkxLLzUkEuOaJSq14zz2PDxzx03f737prjsXQnESEc8dwM3eP1aX6TyO9stmx
        szdKtDMQJH6/NEr40C+wlCPjQCbDSk/iJsvu9mrDBHUh4kI5f8WC3N7mDq6a7GSJyBSWcG
        TEZjnSEH6VVhKaJoTE/pAKp1gh0Rqe5HPeOnxwf0ngWyywSc2u30R+LZCXCWGZrnpU3SaO
        cKnVtRMWp7jbVV2dSaOXX7GE5Q1cuYzhQvR9OGwgZb3e/4096aCKupWU5d7k1w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636451450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7YbG2hfMz6xW/PCCxdMREuP3ECE7JRXSaX6c5e8BiT4=;
        b=U7NWNeeJLgWaTYKHm46ULD0N/00omlOgkZpUPCpdXqAort78/KTRotlpt3pPZAYV1rJvXl
        o6lNPCgiRMVOulAg==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     martin.kaistra@linutronix.de,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 2/7] net: dsa: b53: Move struct b53_device to include/linux/dsa/b53.h
Date:   Tue,  9 Nov 2021 10:50:04 +0100
Message-Id: <20211109095013.27829-3-martin.kaistra@linutronix.de>
In-Reply-To: <20211109095013.27829-1-martin.kaistra@linutronix.de>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to access the b53 structs from net/dsa/tag_brcm.c move the
definitions from drivers/net/dsa/b53/b53_priv.h to the new file
include/linux/dsa/b53.h.

Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
---
 drivers/net/dsa/b53/b53_priv.h |  90 +----------------------------
 include/linux/dsa/b53.h        | 100 +++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+), 89 deletions(-)
 create mode 100644 include/linux/dsa/b53.h

diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 579da74ada64..1652e489b737 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -23,44 +23,13 @@
 #include <linux/mutex.h>
 #include <linux/phy.h>
 #include <linux/etherdevice.h>
-#include <net/dsa.h>
+#include <linux/dsa/b53.h>
 
 #include "b53_regs.h"
 
-struct b53_device;
 struct net_device;
 struct phylink_link_state;
 
-struct b53_io_ops {
-	int (*read8)(struct b53_device *dev, u8 page, u8 reg, u8 *value);
-	int (*read16)(struct b53_device *dev, u8 page, u8 reg, u16 *value);
-	int (*read32)(struct b53_device *dev, u8 page, u8 reg, u32 *value);
-	int (*read48)(struct b53_device *dev, u8 page, u8 reg, u64 *value);
-	int (*read64)(struct b53_device *dev, u8 page, u8 reg, u64 *value);
-	int (*write8)(struct b53_device *dev, u8 page, u8 reg, u8 value);
-	int (*write16)(struct b53_device *dev, u8 page, u8 reg, u16 value);
-	int (*write32)(struct b53_device *dev, u8 page, u8 reg, u32 value);
-	int (*write48)(struct b53_device *dev, u8 page, u8 reg, u64 value);
-	int (*write64)(struct b53_device *dev, u8 page, u8 reg, u64 value);
-	int (*phy_read16)(struct b53_device *dev, int addr, int reg, u16 *value);
-	int (*phy_write16)(struct b53_device *dev, int addr, int reg, u16 value);
-	int (*irq_enable)(struct b53_device *dev, int port);
-	void (*irq_disable)(struct b53_device *dev, int port);
-	u8 (*serdes_map_lane)(struct b53_device *dev, int port);
-	int (*serdes_link_state)(struct b53_device *dev, int port,
-				 struct phylink_link_state *state);
-	void (*serdes_config)(struct b53_device *dev, int port,
-			      unsigned int mode,
-			      const struct phylink_link_state *state);
-	void (*serdes_an_restart)(struct b53_device *dev, int port);
-	void (*serdes_link_set)(struct b53_device *dev, int port,
-				unsigned int mode, phy_interface_t interface,
-				bool link_up);
-	void (*serdes_phylink_validate)(struct b53_device *dev, int port,
-					unsigned long *supported,
-					struct phylink_link_state *state);
-};
-
 #define B53_INVALID_LANE	0xff
 
 enum {
@@ -89,63 +58,6 @@ enum {
 #define B53_N_PORTS	9
 #define B53_N_PORTS_25	6
 
-struct b53_port {
-	u16		vlan_ctl_mask;
-	struct ethtool_eee eee;
-};
-
-struct b53_vlan {
-	u16 members;
-	u16 untag;
-	bool valid;
-};
-
-struct b53_device {
-	struct dsa_switch *ds;
-	struct b53_platform_data *pdata;
-	const char *name;
-
-	struct mutex reg_mutex;
-	struct mutex stats_mutex;
-	struct mutex arl_mutex;
-	const struct b53_io_ops *ops;
-
-	/* chip specific data */
-	u32 chip_id;
-	u8 core_rev;
-	u8 vta_regs[3];
-	u8 duplex_reg;
-	u8 jumbo_pm_reg;
-	u8 jumbo_size_reg;
-	int reset_gpio;
-	u8 num_arl_bins;
-	u16 num_arl_buckets;
-	enum dsa_tag_protocol tag_protocol;
-
-	/* used ports mask */
-	u16 enabled_ports;
-	unsigned int imp_port;
-
-	/* connect specific data */
-	u8 current_page;
-	struct device *dev;
-	u8 serdes_lane;
-
-	/* Master MDIO bus we got probed from */
-	struct mii_bus *bus;
-
-	void *priv;
-
-	/* run time configuration */
-	bool enable_jumbo;
-
-	unsigned int num_vlans;
-	struct b53_vlan *vlans;
-	bool vlan_enabled;
-	unsigned int num_ports;
-	struct b53_port *ports;
-};
-
 #define b53_for_each_port(dev, i) \
 	for (i = 0; i < B53_N_PORTS; i++) \
 		if (dev->enabled_ports & BIT(i))
diff --git a/include/linux/dsa/b53.h b/include/linux/dsa/b53.h
new file mode 100644
index 000000000000..af782a1da362
--- /dev/null
+++ b/include/linux/dsa/b53.h
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2011-2013 Jonas Gorski <jogo@openwrt.org>
+ *
+ * Included by drivers/net/dsa/b53/b53_priv.h and net/dsa/tag_brcm.c
+ */
+
+#include <net/dsa.h>
+
+struct b53_device;
+struct phylink_link_state;
+
+struct b53_io_ops {
+	int (*read8)(struct b53_device *dev, u8 page, u8 reg, u8 *value);
+	int (*read16)(struct b53_device *dev, u8 page, u8 reg, u16 *value);
+	int (*read32)(struct b53_device *dev, u8 page, u8 reg, u32 *value);
+	int (*read48)(struct b53_device *dev, u8 page, u8 reg, u64 *value);
+	int (*read64)(struct b53_device *dev, u8 page, u8 reg, u64 *value);
+	int (*write8)(struct b53_device *dev, u8 page, u8 reg, u8 value);
+	int (*write16)(struct b53_device *dev, u8 page, u8 reg, u16 value);
+	int (*write32)(struct b53_device *dev, u8 page, u8 reg, u32 value);
+	int (*write48)(struct b53_device *dev, u8 page, u8 reg, u64 value);
+	int (*write64)(struct b53_device *dev, u8 page, u8 reg, u64 value);
+	int (*phy_read16)(struct b53_device *dev, int addr, int reg,
+			  u16 *value);
+	int (*phy_write16)(struct b53_device *dev, int addr, int reg,
+			   u16 value);
+	int (*irq_enable)(struct b53_device *dev, int port);
+	void (*irq_disable)(struct b53_device *dev, int port);
+	u8 (*serdes_map_lane)(struct b53_device *dev, int port);
+	int (*serdes_link_state)(struct b53_device *dev, int port,
+				 struct phylink_link_state *state);
+	void (*serdes_config)(struct b53_device *dev, int port,
+			      unsigned int mode,
+			      const struct phylink_link_state *state);
+	void (*serdes_an_restart)(struct b53_device *dev, int port);
+	void (*serdes_link_set)(struct b53_device *dev, int port,
+				unsigned int mode, phy_interface_t interface,
+				bool link_up);
+	void (*serdes_phylink_validate)(struct b53_device *dev, int port,
+					unsigned long *supported,
+					struct phylink_link_state *state);
+};
+
+struct b53_port {
+	u16 vlan_ctl_mask;
+	struct ethtool_eee eee;
+};
+
+struct b53_vlan {
+	u16 members;
+	u16 untag;
+	bool valid;
+};
+
+struct b53_device {
+	struct dsa_switch *ds;
+	struct b53_platform_data *pdata;
+	const char *name;
+
+	struct mutex reg_mutex;
+	struct mutex stats_mutex;
+	struct mutex arl_mutex;
+	const struct b53_io_ops *ops;
+
+	/* chip specific data */
+	u32 chip_id;
+	u8 core_rev;
+	u8 vta_regs[3];
+	u8 duplex_reg;
+	u8 jumbo_pm_reg;
+	u8 jumbo_size_reg;
+	int reset_gpio;
+	u8 num_arl_bins;
+	u16 num_arl_buckets;
+	enum dsa_tag_protocol tag_protocol;
+
+	/* used ports mask */
+	u16 enabled_ports;
+	unsigned int imp_port;
+
+	/* connect specific data */
+	u8 current_page;
+	struct device *dev;
+	u8 serdes_lane;
+
+	/* Master MDIO bus we got probed from */
+	struct mii_bus *bus;
+
+	void *priv;
+
+	/* run time configuration */
+	bool enable_jumbo;
+
+	unsigned int num_vlans;
+	struct b53_vlan *vlans;
+	bool vlan_enabled;
+	unsigned int num_ports;
+	struct b53_port *ports;
+};
-- 
2.20.1

