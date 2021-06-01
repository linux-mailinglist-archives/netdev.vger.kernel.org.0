Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58DF396A55
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhFAAfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbhFAAfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 20:35:25 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09D2C061574
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:43 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id h24so14993538ejy.2
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TwBnO8Xl/yYB+n3NRD1yv+eTHl2URKnCASp3Ct0lwEE=;
        b=a6t0D1utqCy5l22Pm77lC5gNohXV/w94UYqjIAxZa+ebIVTxM0VsD8qV4p+WH4GcMg
         U9DavZqnmJtxDZyZ32atI0U/ZN9gE1KwZjaBsk0/n8z1BSDcAZEEay/iCGrBxxajNubb
         ivWEVOM27xWVfEIdVd4FH0I1qZEY5KEbt7zTdpeH5ujl0QsEqMlhyHnBpRyHj20Fkdic
         J/K5coPTkG/F9Ff4YzqR6m1z5m9MWwQE++xxgG2WQt97IvYaiitcUHAG6C5sg0Z9F74P
         n/H/rbbOuVFIEf6Qr2+4+xTlFN0I2ubEmwmhA8Mgi6JKS/s0ernprpxdnQLFrr8DRsnw
         axPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TwBnO8Xl/yYB+n3NRD1yv+eTHl2URKnCASp3Ct0lwEE=;
        b=FMPjydhtFsuRULzuUgKJG/CsgyjwOfSO1+ERnQ/91t3/EEBgFHhbSano1RZXF1ryDG
         ip0kvAwzwX7QuDIMak2T/nwWMDcqnDp6ppovtQbhVKiq8OOv/UgL/9H4zmArOBfi0CX8
         Ei5S2FRpZP3LbafqxbY1/82GdMdVrYCPQAxzUfWniDins8na5Xi/6jN97MWGmmxbh/Ec
         6w3lZ7vOgEUXFTgmzHmw73YPu1nMDjZYfE1wPPTH0JiFfmIH67ANZn/O6V/doYE3dXXo
         RaD2TLotac2CTb9sN5vKTubvAi9jPXMmcPxz6kf2rMCwv/GKmjbhjVKosAj8pgmW2LTY
         tTkg==
X-Gm-Message-State: AOAM532JSc04JGdOzKbHVR9AczNRKgMSJliLqsuCrD3TqFkXopeaPdPI
        NA8lx6N03lEhfVUu24JWlu4=
X-Google-Smtp-Source: ABdhPJwpEJZoTIywZCHwhHnYiJvcUFxAtf0ctUkglfKMuEFlCUAMi59TovP31IZ9jd0IaTFBT9oa/Q==
X-Received: by 2002:a17:906:80c8:: with SMTP id a8mr8802189ejx.195.1622507622242;
        Mon, 31 May 2021 17:33:42 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm6510521ejr.63.2021.05.31.17.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 17:33:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 9/9] net: pcs: xpcs: convert to phylink_pcs_ops
Date:   Tue,  1 Jun 2021 03:33:25 +0300
Message-Id: <20210601003325.1631980-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601003325.1631980-1-olteanv@gmail.com>
References: <20210601003325.1631980-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since all the remaining members of struct mdio_xpcs_ops have direct
equivalents in struct phylink_pcs_ops, it is about time we remove it
altogether.

Since the phylink ops return void, we need to remove the error
propagation from the various xpcs methods and simply print an error
message where appropriate.

Since xpcs_get_state_c73() detects link faults and attempts to reset the
link on its own by calling xpcs_config(), but xpcs_config() now has a
lot of phylink arguments which are not needed and cannot be simply
fabricated by anybody else except phylink, the actual implementation has
been moved into a smaller xpcs_do_config().

The const struct mdio_xpcs_ops *priv->hw->xpcs has been removed, so we
need to look at the struct mdio_xpcs_args pointer now as an indication
whether the port has an XPCS or not.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  3 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  8 --
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 41 ++------
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 16 +--
 drivers/net/pcs/pcs-xpcs.c                    | 99 +++++++++++--------
 include/linux/pcs/pcs-xpcs.h                  | 11 +--
 7 files changed, 77 insertions(+), 103 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 4bcd1d340766..8a83f9e1e95b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -503,8 +503,7 @@ struct mac_device_info {
 	const struct stmmac_hwtimestamp *ptp;
 	const struct stmmac_tc_ops *tc;
 	const struct stmmac_mmc_ops *mmc;
-	const struct mdio_xpcs_ops *xpcs;
-	struct mdio_xpcs_args *xpcs_args;
+	struct mdio_xpcs_args *xpcs;
 	struct mii_regs mii;	/* MII register Addresses */
 	struct mac_link link;
 	void __iomem *pcsr;     /* vpointer to device CSRs */
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 5014b260844b..91f7592a0189 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -612,14 +612,6 @@ struct stmmac_mmc_ops {
 #define stmmac_mmc_read(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mmc, read, __args)
 
-/* XPCS callbacks */
-#define stmmac_xpcs_config(__priv, __args...) \
-	stmmac_do_callback(__priv, xpcs, config, __args)
-#define stmmac_xpcs_get_state(__priv, __args...) \
-	stmmac_do_callback(__priv, xpcs, get_state, __args)
-#define stmmac_xpcs_link_up(__priv, __args...) \
-	stmmac_do_callback(__priv, xpcs, link_up, __args)
-
 struct stmmac_regs_off {
 	u32 ptp_off;
 	u32 mmc_off;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 050576ee704d..d0ce608b81c3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -721,7 +721,7 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 			    "Setting EEE tx-lpi is not supported\n");
 
 	if (priv->hw->xpcs) {
-		ret = xpcs_config_eee(priv->hw->xpcs_args,
+		ret = xpcs_config_eee(priv->hw->xpcs,
 				      priv->plat->mult_fact_100ns,
 				      edata->eee_enabled);
 		if (ret)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 426c8f891f5a..d5685a74f3b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -997,29 +997,7 @@ static void stmmac_validate(struct phylink_config *config,
 
 	/* If PCS is supported, check which modes it supports. */
 	if (priv->hw->xpcs)
-		xpcs_validate(priv->hw->xpcs_args, supported, state);
-}
-
-static void stmmac_mac_pcs_get_state(struct phylink_config *config,
-				     struct phylink_link_state *state)
-{
-	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
-
-	state->link = 0;
-	stmmac_xpcs_get_state(priv, priv->hw->xpcs_args, state);
-}
-
-static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
-			      const struct phylink_link_state *state)
-{
-	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
-
-	stmmac_xpcs_config(priv, priv->hw->xpcs_args, state);
-}
-
-static void stmmac_mac_an_restart(struct phylink_config *config)
-{
-	/* Not Supported */
+		xpcs_validate(priv->hw->xpcs, supported, state);
 }
 
 static void stmmac_fpe_link_state_handle(struct stmmac_priv *priv, bool is_up)
@@ -1061,8 +1039,6 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 	u32 ctrl;
 
-	stmmac_xpcs_link_up(priv, priv->hw->xpcs_args, speed, interface);
-
 	ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
 	ctrl &= ~priv->hw->link.speed_mask;
 
@@ -1155,9 +1131,6 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 
 static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
 	.validate = stmmac_validate,
-	.mac_pcs_get_state = stmmac_mac_pcs_get_state,
-	.mac_config = stmmac_mac_config,
-	.mac_an_restart = stmmac_mac_an_restart,
 	.mac_link_down = stmmac_mac_link_down,
 	.mac_link_up = stmmac_mac_link_up,
 };
@@ -1234,6 +1207,7 @@ static int stmmac_init_phy(struct net_device *dev)
 
 static int stmmac_phy_setup(struct stmmac_priv *priv)
 {
+	struct stmmac_mdio_bus_data *mdio_bus_data = priv->plat->mdio_bus_data;
 	struct fwnode_handle *fwnode = of_fwnode_handle(priv->plat->phylink_node);
 	int mode = priv->plat->phy_interface;
 	struct phylink *phylink;
@@ -1241,8 +1215,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	priv->phylink_config.dev = &priv->dev->dev;
 	priv->phylink_config.type = PHYLINK_NETDEV;
 	priv->phylink_config.pcs_poll = true;
-	priv->phylink_config.ovr_an_inband =
-		priv->plat->mdio_bus_data->xpcs_an_inband;
+	priv->phylink_config.ovr_an_inband = mdio_bus_data->xpcs_an_inband;
 
 	if (!fwnode)
 		fwnode = dev_fwnode(priv->device);
@@ -1252,6 +1225,12 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	if (IS_ERR(phylink))
 		return PTR_ERR(phylink);
 
+	if (mdio_bus_data->has_xpcs) {
+		struct mdio_xpcs_args *xpcs = priv->hw->xpcs;
+
+		phylink_set_pcs(phylink, &xpcs->pcs);
+	}
+
 	priv->phylink = phylink;
 	return 0;
 }
@@ -3652,7 +3631,7 @@ int stmmac_open(struct net_device *dev)
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI &&
 	    (!priv->hw->xpcs ||
-	     xpcs_get_an_mode(priv->hw->xpcs_args, mode) != DW_AN_C73)) {
+	     xpcs_get_an_mode(priv->hw->xpcs, mode) != DW_AN_C73)) {
 		ret = stmmac_init_phy(dev);
 		if (ret) {
 			netdev_err(priv->dev,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 9b4bf78d2eaa..6312a152c8ad 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -444,14 +444,6 @@ int stmmac_mdio_register(struct net_device *ndev)
 		max_addr = PHY_MAX_ADDR;
 	}
 
-	if (mdio_bus_data->has_xpcs) {
-		priv->hw->xpcs = mdio_xpcs_get_ops();
-		if (!priv->hw->xpcs) {
-			err = -ENODEV;
-			goto bus_register_fail;
-		}
-	}
-
 	if (mdio_bus_data->needs_reset)
 		new_bus->reset = &stmmac_mdio_reset;
 
@@ -526,11 +518,11 @@ int stmmac_mdio_register(struct net_device *ndev)
 				continue;
 			}
 
-			priv->hw->xpcs_args = xpcs;
+			priv->hw->xpcs = xpcs;
 			break;
 		}
 
-		if (!priv->hw->xpcs_args) {
+		if (!priv->hw->xpcs) {
 			dev_warn(dev, "No XPCS found\n");
 			err = -ENODEV;
 			goto no_xpcs_found;
@@ -563,8 +555,8 @@ int stmmac_mdio_unregister(struct net_device *ndev)
 		return 0;
 
 	if (priv->hw->xpcs) {
-		mdio_device_free(priv->hw->xpcs_args->mdiodev);
-		xpcs_destroy(priv->hw->xpcs_args);
+		mdio_device_free(priv->hw->xpcs->mdiodev);
+		xpcs_destroy(priv->hw->xpcs);
 	}
 
 	mdiobus_unregister(priv->mii);
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 3e09850b8318..f1092771ab70 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -100,6 +100,9 @@
 /* VR MII EEE Control 1 defines */
 #define DW_VR_MII_EEE_TRN_LPI		BIT(0)	/* Transparent Mode Enable */
 
+#define phylink_pcs_to_xpcs(pl_pcs) \
+	container_of((pl_pcs), struct mdio_xpcs_args, pcs)
+
 static const int xpcs_usxgmii_features[] = {
 	ETHTOOL_LINK_MODE_Pause_BIT,
 	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
@@ -448,7 +451,7 @@ static int xpcs_get_max_usxgmii_speed(const unsigned long *supported)
 	return max;
 }
 
-static int xpcs_config_usxgmii(struct mdio_xpcs_args *xpcs, int speed)
+static void xpcs_config_usxgmii(struct mdio_xpcs_args *xpcs, int speed)
 {
 	int ret, speed_sel;
 
@@ -473,33 +476,40 @@ static int xpcs_config_usxgmii(struct mdio_xpcs_args *xpcs, int speed)
 		break;
 	default:
 		/* Nothing to do here */
-		return -EINVAL;
+		return;
 	}
 
 	ret = xpcs_read_vpcs(xpcs, MDIO_CTRL1);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	ret = xpcs_write_vpcs(xpcs, MDIO_CTRL1, ret | DW_USXGMII_EN);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	ret &= ~DW_USXGMII_SS_MASK;
 	ret |= speed_sel | DW_USXGMII_FULL;
 
 	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1, ret);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	ret = xpcs_read_vpcs(xpcs, MDIO_CTRL1);
 	if (ret < 0)
-		return ret;
+		goto out;
+
+	ret = xpcs_write_vpcs(xpcs, MDIO_CTRL1, ret | DW_USXGMII_RST);
+	if (ret < 0)
+		goto out;
+
+	return;
 
-	return xpcs_write_vpcs(xpcs, MDIO_CTRL1, ret | DW_USXGMII_RST);
+out:
+	pr_err("%s: XPCS access returned %pe\n", __func__, ERR_PTR(ret));
 }
 
 static int _xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs,
@@ -829,19 +839,19 @@ static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
 }
 
-static int xpcs_config(struct mdio_xpcs_args *xpcs,
-		       const struct phylink_link_state *state)
+static int xpcs_do_config(struct mdio_xpcs_args *xpcs,
+			  phy_interface_t interface, unsigned int mode)
 {
 	const struct xpcs_compat *compat;
 	int ret;
 
-	compat = xpcs_find_compat(xpcs->id, state->interface);
+	compat = xpcs_find_compat(xpcs->id, interface);
 	if (!compat)
 		return -ENODEV;
 
 	switch (compat->an_mode) {
 	case DW_AN_C73:
-		if (state->an_enabled) {
+		if (phylink_autoneg_inband(mode)) {
 			ret = xpcs_config_aneg_c73(xpcs, compat);
 			if (ret)
 				return ret;
@@ -859,6 +869,16 @@ static int xpcs_config(struct mdio_xpcs_args *xpcs,
 	return 0;
 }
 
+static int xpcs_config(struct phylink_pcs *pcs, unsigned int mode,
+		       phy_interface_t interface,
+		       const unsigned long *advertising,
+		       bool permit_pause_to_mac)
+{
+	struct mdio_xpcs_args *xpcs = phylink_pcs_to_xpcs(pcs);
+
+	return xpcs_do_config(xpcs, interface, mode);
+}
+
 static int xpcs_get_state_c73(struct mdio_xpcs_args *xpcs,
 			      struct phylink_link_state *state,
 			      const struct xpcs_compat *compat)
@@ -877,7 +897,7 @@ static int xpcs_get_state_c73(struct mdio_xpcs_args *xpcs,
 
 		state->link = 0;
 
-		return xpcs_config(xpcs, state);
+		return xpcs_do_config(xpcs, state->interface, MLO_AN_INBAND);
 	}
 
 	if (state->an_enabled && xpcs_aneg_done_c73(xpcs, state, compat)) {
@@ -934,41 +954,45 @@ static int xpcs_get_state_c37_sgmii(struct mdio_xpcs_args *xpcs,
 	return 0;
 }
 
-static int xpcs_get_state(struct mdio_xpcs_args *xpcs,
-			  struct phylink_link_state *state)
+static void xpcs_get_state(struct phylink_pcs *pcs,
+			   struct phylink_link_state *state)
 {
+	struct mdio_xpcs_args *xpcs = phylink_pcs_to_xpcs(pcs);
 	const struct xpcs_compat *compat;
 	int ret;
 
 	compat = xpcs_find_compat(xpcs->id, state->interface);
 	if (!compat)
-		return -ENODEV;
+		return;
 
 	switch (compat->an_mode) {
 	case DW_AN_C73:
 		ret = xpcs_get_state_c73(xpcs, state, compat);
-		if (ret)
-			return ret;
+		if (ret) {
+			pr_err("xpcs_get_state_c73 returned %pe\n",
+			       ERR_PTR(ret));
+			return;
+		}
 		break;
 	case DW_AN_C37_SGMII:
 		ret = xpcs_get_state_c37_sgmii(xpcs, state);
-		if (ret)
-			return ret;
+		if (ret) {
+			pr_err("xpcs_get_state_c37_sgmii returned %pe\n",
+			       ERR_PTR(ret));
+		}
 		break;
 	default:
-		return -1;
+		return;
 	}
-
-	return 0;
 }
 
-static int xpcs_link_up(struct mdio_xpcs_args *xpcs, int speed,
-			phy_interface_t interface)
+static void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+			 phy_interface_t interface, int speed, int duplex)
 {
+	struct mdio_xpcs_args *xpcs = phylink_pcs_to_xpcs(pcs);
+
 	if (interface == PHY_INTERFACE_MODE_USXGMII)
 		return xpcs_config_usxgmii(xpcs, speed);
-
-	return 0;
 }
 
 static u32 xpcs_get_id(struct mdio_xpcs_args *xpcs)
@@ -1009,6 +1033,12 @@ static u32 xpcs_get_id(struct mdio_xpcs_args *xpcs)
 	return 0xffffffff;
 }
 
+static const struct phylink_pcs_ops xpcs_phylink_ops = {
+	.pcs_config = xpcs_config,
+	.pcs_get_state = xpcs_get_state,
+	.pcs_link_up = xpcs_link_up,
+};
+
 struct mdio_xpcs_args *xpcs_create(struct mdio_device *mdiodev,
 				   phy_interface_t interface)
 {
@@ -1039,6 +1069,9 @@ struct mdio_xpcs_args *xpcs_create(struct mdio_device *mdiodev,
 			goto out;
 		}
 
+		xpcs->pcs.ops = &xpcs_phylink_ops;
+		xpcs->pcs.poll = true;
+
 		ret = xpcs_soft_reset(xpcs, compat);
 		if (ret)
 			goto out;
@@ -1061,16 +1094,4 @@ void xpcs_destroy(struct mdio_xpcs_args *xpcs)
 }
 EXPORT_SYMBOL_GPL(xpcs_destroy);
 
-static struct mdio_xpcs_ops xpcs_ops = {
-	.config = xpcs_config,
-	.get_state = xpcs_get_state,
-	.link_up = xpcs_link_up,
-};
-
-struct mdio_xpcs_ops *mdio_xpcs_get_ops(void)
-{
-	return &xpcs_ops;
-}
-EXPORT_SYMBOL_GPL(mdio_xpcs_get_ops);
-
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 57a199393d63..0860a5b59f10 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -19,19 +19,10 @@ struct xpcs_id;
 struct mdio_xpcs_args {
 	struct mdio_device *mdiodev;
 	const struct xpcs_id *id;
-};
-
-struct mdio_xpcs_ops {
-	int (*config)(struct mdio_xpcs_args *xpcs,
-		      const struct phylink_link_state *state);
-	int (*get_state)(struct mdio_xpcs_args *xpcs,
-			 struct phylink_link_state *state);
-	int (*link_up)(struct mdio_xpcs_args *xpcs, int speed,
-		       phy_interface_t interface);
+	struct phylink_pcs pcs;
 };
 
 int xpcs_get_an_mode(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
-struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
 void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
 int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
-- 
2.25.1

