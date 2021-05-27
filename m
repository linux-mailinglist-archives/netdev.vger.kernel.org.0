Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212B739374D
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 22:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhE0Urg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 16:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235937AbhE0UrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 16:47:23 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DBBC0613CE
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:49 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id df21so2369205edb.3
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W5rl8REEJ4/iz/FjOyfS4x8Yt6ENcdcnVzy9PwH01O8=;
        b=bF6rSfzUaP0LM3dyWfVz06xS4XmPPomgyK7S+iKClSqb/PuAo5C5T4umQ5b5TuBjt0
         O6oNlw2qyAzgrqRvxqpl3TUHnCGQmsdhixPXPLfd8A8t7j4kaLZoOFLWybBTqkfCcp+0
         vzGiv+fDxxDXOcrfoHlKKki/+xcUyrayZMzvGwSgauOGfw/0yaJbjFmfMNKPt7sW8QkB
         p4mo7vDPEEor+ediT5NKOmOnlExqK/MiyQYWJxiYHt1Mb9417xOizRXOppyoJWmvVD+a
         Ya4EDpnRnXSv046kK0ppOU0CdwmRXX+ggfH3BoEhsebFVyeMkteAbAqbnwX4fKFE6yHq
         wP7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W5rl8REEJ4/iz/FjOyfS4x8Yt6ENcdcnVzy9PwH01O8=;
        b=bGsCH7PCH8l6+03cnFmtaO2E1N/5UOPMYDxpYG1X8etg4VPJB1nlfrwTdFnxntbH5U
         d1c64QyGsdVhQzUAivRh5W2Bnt3P+HSRFiDRWJ/pxCYiOjhG29K2YzXVpu9MEpQ+Onpl
         tVwPYTkzS0FWeu0fJ4H7tCbMNCvjjZE7jM4YCszZLWLAzGa2UYrP3BLbUOsVJfG0BkRl
         3VVRPE73+xw7tyDk/jlJHLY21d/BH0eNcrGs+Avn5PwMi8/DIkKPzDicG65q2oL5FRLR
         4WcZbwfigxyTfG955cIZ7WP11tugAVLEnJ+KdwHj+ff68i4QaoG6FgGjsxnpsrwRLrUq
         uU6Q==
X-Gm-Message-State: AOAM531UTL7pjzZ0bxoRZqKLPs71Q+OppxGDg9vKpcRsC9sbOU9vHU/d
        ffIgWHzW8sfMmtAbTf0uHOQ=
X-Google-Smtp-Source: ABdhPJwQ/agM+3oAJMru/9VU8zpvLbN2fu2OrP6F6ABwqzXakajnKY1DeDi0U0Ehmf2ClAcjj4oK2Q==
X-Received: by 2002:a05:6402:50d2:: with SMTP id h18mr6427480edb.10.1622148347668;
        Thu, 27 May 2021 13:45:47 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g11sm1654145edt.85.2021.05.27.13.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 13:45:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 8/8] net: pcs: xpcs: convert to mdio_device
Date:   Thu, 27 May 2021 23:45:28 +0300
Message-Id: <20210527204528.3490126-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527204528.3490126-1-olteanv@gmail.com>
References: <20210527204528.3490126-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Unify the 2 existing PCS drivers (lynx and xpcs) by doing a similar
thing on probe, which is to have a *_create function that takes a
struct mdio_device * given by the caller, and builds a private PCS
structure around that.

This changes stmmac to hold only a pointer to the xpcs, as opposed to
the full structure.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  2 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  6 +--
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 32 +++++++--------
 drivers/net/pcs/pcs-xpcs.c                    | 40 ++++++++++++++-----
 include/linux/pcs/pcs-xpcs.h                  |  5 +--
 6 files changed, 54 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 678f8ce62b8a..8a83f9e1e95b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -503,7 +503,7 @@ struct mac_device_info {
 	const struct stmmac_hwtimestamp *ptp;
 	const struct stmmac_tc_ops *tc;
 	const struct stmmac_mmc_ops *mmc;
-	struct mdio_xpcs_args xpcs_args;
+	struct mdio_xpcs_args *xpcs;
 	struct mii_regs mii;	/* MII register Addresses */
 	struct mac_link link;
 	void __iomem *pcsr;     /* vpointer to device CSRs */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 72d2d575bbfe..bd5de43cf925 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -720,8 +720,7 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 		netdev_warn(priv->dev,
 			    "Setting EEE tx-lpi is not supported\n");
 
-	ret = xpcs_config_eee(&priv->hw->xpcs_args,
-			      priv->plat->mult_fact_100ns,
+	ret = xpcs_config_eee(priv->hw->xpcs, priv->plat->mult_fact_100ns,
 			      edata->eee_enabled);
 	if (ret)
 		return ret;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3ccf00ea77d5..f46f6524aa18 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -996,7 +996,7 @@ static void stmmac_validate(struct phylink_config *config,
 	linkmode_andnot(state->advertising, state->advertising, mask);
 
 	/* If PCS is supported, check which modes it supports. */
-	xpcs_validate(&priv->hw->xpcs_args, supported, state);
+	xpcs_validate(priv->hw->xpcs, supported, state);
 }
 
 static void stmmac_fpe_link_state_handle(struct stmmac_priv *priv, bool is_up)
@@ -1222,7 +1222,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 		return PTR_ERR(phylink);
 
 	if (mdio_bus_data->has_xpcs) {
-		struct mdio_xpcs_args *xpcs = &priv->hw->xpcs_args;
+		struct mdio_xpcs_args *xpcs = priv->hw->xpcs;
 
 		phylink_set_pcs(phylink, &xpcs->pcs);
 	}
@@ -3625,7 +3625,7 @@ int stmmac_open(struct net_device *dev)
 
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI &&
-	    priv->hw->xpcs_args.an_mode != DW_AN_C73) {
+	    priv->hw->xpcs->an_mode != DW_AN_C73) {
 		ret = stmmac_init_phy(dev);
 		if (ret) {
 			netdev_err(priv->dev,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 4a197b2fe26b..c632d3f10102 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -503,25 +503,25 @@ int stmmac_mdio_register(struct net_device *ndev)
 
 	/* Try to probe the XPCS by scanning all addresses. */
 	if (mdio_bus_data->has_xpcs) {
-		struct mdio_xpcs_args *xpcs = &priv->hw->xpcs_args;
-		int ret;
-
-		max_addr = PHY_MAX_ADDR;
-
-		xpcs->bus = new_bus;
-
-		found = 0;
-		for (addr = 0; addr < max_addr; addr++) {
-			xpcs->addr = addr;
-
-			ret = xpcs_probe(xpcs);
-			if (!ret) {
-				found = 1;
-				break;
+		struct mdio_device *mdiodev;
+		struct mdio_xpcs_args *xpcs;
+
+		for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
+			mdiodev = mdio_device_create(new_bus, addr);
+			if (IS_ERR(mdiodev))
+				continue;
+
+			xpcs = xpcs_create(mdiodev);
+			if (IS_ERR_OR_NULL(xpcs)) {
+				mdio_device_free(mdiodev);
+				continue;
 			}
+
+			priv->hw->xpcs = xpcs;
+			break;
 		}
 
-		if (!found && !mdio_node) {
+		if (!priv->hw->xpcs) {
 			dev_warn(dev, "No XPCS found\n");
 			err = -ENODEV;
 			goto no_xpcs_found;
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index e0a7e546f32b..194b79da547b 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -221,15 +221,19 @@ static struct xpcs_id {
 static int xpcs_read(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
 {
 	u32 reg_addr = mdiobus_c45_addr(dev, reg);
+	struct mii_bus *bus = xpcs->mdiodev->bus;
+	int addr = xpcs->mdiodev->addr;
 
-	return mdiobus_read(xpcs->bus, xpcs->addr, reg_addr);
+	return mdiobus_read(bus, addr, reg_addr);
 }
 
 static int xpcs_write(struct mdio_xpcs_args *xpcs, int dev, u32 reg, u16 val)
 {
 	u32 reg_addr = mdiobus_c45_addr(dev, reg);
+	struct mii_bus *bus = xpcs->mdiodev->bus;
+	int addr = xpcs->mdiodev->addr;
 
-	return mdiobus_write(xpcs->bus, xpcs->addr, reg_addr, val);
+	return mdiobus_write(bus, addr, reg_addr, val);
 }
 
 static int xpcs_read_vendor(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
@@ -294,7 +298,7 @@ static int xpcs_soft_reset(struct mdio_xpcs_args *xpcs)
 #define xpcs_warn(__xpcs, __state, __args...) \
 ({ \
 	if ((__state)->link) \
-		dev_warn(&(__xpcs)->bus->dev, ##__args); \
+		dev_warn(&(__xpcs)->mdiodev->dev, ##__args); \
 })
 
 static int xpcs_read_fault_c73(struct mdio_xpcs_args *xpcs,
@@ -963,10 +967,19 @@ static const struct phylink_pcs_ops xpcs_phylink_ops = {
 	.pcs_link_up = xpcs_link_up,
 };
 
-int xpcs_probe(struct mdio_xpcs_args *xpcs)
+struct mdio_xpcs_args *xpcs_create(struct mdio_device *mdiodev)
 {
-	u32 xpcs_id = xpcs_get_id(xpcs);
-	int i;
+	struct mdio_xpcs_args *xpcs;
+	u32 xpcs_id;
+	int i, ret;
+
+	xpcs = kzalloc(sizeof(*xpcs), GFP_KERNEL);
+	if (!xpcs)
+		return NULL;
+
+	xpcs->mdiodev = mdiodev;
+
+	xpcs_id = xpcs_get_id(xpcs);
 
 	for (i = 0; i < ARRAY_SIZE(xpcs_id_list); i++) {
 		struct xpcs_id *entry = &xpcs_id_list[i];
@@ -983,11 +996,20 @@ int xpcs_probe(struct mdio_xpcs_args *xpcs)
 		xpcs->pcs.ops = &xpcs_phylink_ops;
 		xpcs->pcs.poll = true;
 
-		return xpcs_soft_reset(xpcs);
+		ret = xpcs_soft_reset(xpcs);
+		if (ret)
+			goto out;
+
+		return xpcs;
 	}
 
-	return -ENODEV;
+	ret = -ENODEV;
+
+out:
+	kfree(xpcs);
+
+	return ERR_PTR(ret);
 }
-EXPORT_SYMBOL_GPL(xpcs_probe);
+EXPORT_SYMBOL_GPL(xpcs_create);
 
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index eb74ab5b8138..237f2198f709 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -18,10 +18,9 @@ struct xpcs_id;
 
 struct mdio_xpcs_args {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
+	struct mdio_device *mdiodev;
 	struct phylink_pcs pcs;
-	struct mii_bus *bus;
 	struct xpcs_id *id;
-	int addr;
 	int an_mode;
 };
 
@@ -29,6 +28,6 @@ void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
 int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
 		    int enable);
-int xpcs_probe(struct mdio_xpcs_args *xpcs);
+struct mdio_xpcs_args *xpcs_create(struct mdio_device *mdiodev);
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

