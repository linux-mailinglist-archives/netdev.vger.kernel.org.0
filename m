Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A10439374B
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 22:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbhE0Ur3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 16:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbhE0UrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 16:47:21 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD1AC0613CE
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:46 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id r23so2390095edw.1
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z/y7jaRU5tyTiLyd9RuocOi5t94X3yF17Me0njiV5Uo=;
        b=Z4CpJ+UCLJ0OlDXhOTqxonafJLpbvs/2mJbHbeb3WpxeRKIYYVSiTf8K8dtSMd8GmM
         XJ3ImdbvoXA4tVkdm2qnBSxIoaQ/jQ04Xhkm3YL9p9gC++xDzhkpoJH1v1m/xCsxLoRI
         amVsnqUFAzp3XNSMn/wbczL75PLOr/IVpmpyVTSC0Nrg2RRoqpYH5TcjR7w6oVYIHO1Z
         6NptroNTqNeH7cVRIHJIucKIhTuypwZUi7L6H/r9mgmk9oyTZv9ppLAZyqwZ3aX2to0E
         aEDMp5wm/pzjkq1+NS6khb0A4LN7pwI6uF7hIDS0WkAF+945m5NxmhnWGQo5ee6CTaYa
         2hTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z/y7jaRU5tyTiLyd9RuocOi5t94X3yF17Me0njiV5Uo=;
        b=k3rm6pk981/VgrV3wLoqzbDk7Bo/+okZy8r95qt1efROMBhEsM4vRm1Lsfq8w7ncu0
         weoQPjI3K8ayXeypU6vWYAaWfKahw0BiXBHSM72ohIBIhnXfWfjc2Jzst608f89o6Ht1
         rJr8BpAb9vSdkpF/iYOglLcY1b5/d1MqiQUu5idXXnKi/16CuaxKNJMsLij6v7Q/miYa
         99Dh/eSBkYgBjErbra+cGzKd9TNd1N73w1MpzxDglyMyIIaHTMZONfRUkSkrAPjtxwwv
         3CxQ5y13bKzEpztpmnZGeYp70CwR6azi0tjn9L/oKX1k0doncSKRltw8TfpGiI2o9NtP
         koCg==
X-Gm-Message-State: AOAM532ZUrc3RGw77mVtWk8Hu3dWevm7wuCrv6wI8Gq7ibzaQUzxG7yt
        Bo0egT6Ty1w9lczbpJuK2D4=
X-Google-Smtp-Source: ABdhPJxErPm6F4+6VeVfQUd4pb0WVJ6+0BLES8al1dXY77AF+vleqZ3MRfXrbYwbPYiD4bU2U0BtHg==
X-Received: by 2002:aa7:c91a:: with SMTP id b26mr6367906edt.350.1622148345194;
        Thu, 27 May 2021 13:45:45 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g11sm1654145edt.85.2021.05.27.13.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 13:45:44 -0700 (PDT)
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
Subject: [RFC PATCH net-next 6/8] net: pcs: xpcs: convert to phylink_pcs_ops
Date:   Thu, 27 May 2021 23:45:26 +0300
Message-Id: <20210527204528.3490126-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527204528.3490126-1-olteanv@gmail.com>
References: <20210527204528.3490126-1-olteanv@gmail.com>
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

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  1 -
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  8 --
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 37 ++------
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 10 +-
 drivers/net/pcs/pcs-xpcs.c                    | 94 +++++++++++--------
 include/linux/pcs/pcs-xpcs.h                  | 11 +--
 6 files changed, 67 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 619e3c0760d6..678f8ce62b8a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -503,7 +503,6 @@ struct mac_device_info {
 	const struct stmmac_hwtimestamp *ptp;
 	const struct stmmac_tc_ops *tc;
 	const struct stmmac_mmc_ops *mmc;
-	const struct mdio_xpcs_ops *xpcs;
 	struct mdio_xpcs_args xpcs_args;
 	struct mii_regs mii;	/* MII register Addresses */
 	struct mac_link link;
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
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d3d85d36e177..3ccf00ea77d5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -999,28 +999,6 @@ static void stmmac_validate(struct phylink_config *config,
 	xpcs_validate(&priv->hw->xpcs_args, supported, state);
 }
 
-static void stmmac_mac_pcs_get_state(struct phylink_config *config,
-				     struct phylink_link_state *state)
-{
-	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
-
-	state->link = 0;
-	stmmac_xpcs_get_state(priv, &priv->hw->xpcs_args, state);
-}
-
-static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
-			      const struct phylink_link_state *state)
-{
-	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
-
-	stmmac_xpcs_config(priv, &priv->hw->xpcs_args, state);
-}
-
-static void stmmac_mac_an_restart(struct phylink_config *config)
-{
-	/* Not Supported */
-}
-
 static void stmmac_fpe_link_state_handle(struct stmmac_priv *priv, bool is_up)
 {
 	struct stmmac_fpe_cfg *fpe_cfg = priv->plat->fpe_cfg;
@@ -1060,8 +1038,6 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 	u32 ctrl;
 
-	stmmac_xpcs_link_up(priv, &priv->hw->xpcs_args, speed, interface);
-
 	ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
 	ctrl &= ~priv->hw->link.speed_mask;
 
@@ -1154,9 +1130,6 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 
 static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
 	.validate = stmmac_validate,
-	.mac_pcs_get_state = stmmac_mac_pcs_get_state,
-	.mac_config = stmmac_mac_config,
-	.mac_an_restart = stmmac_mac_an_restart,
 	.mac_link_down = stmmac_mac_link_down,
 	.mac_link_up = stmmac_mac_link_up,
 };
@@ -1230,6 +1203,7 @@ static int stmmac_init_phy(struct net_device *dev)
 
 static int stmmac_phy_setup(struct stmmac_priv *priv)
 {
+	struct stmmac_mdio_bus_data *mdio_bus_data = priv->plat->mdio_bus_data;
 	struct fwnode_handle *fwnode = of_fwnode_handle(priv->plat->phylink_node);
 	int mode = priv->plat->phy_interface;
 	struct phylink *phylink;
@@ -1237,8 +1211,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	priv->phylink_config.dev = &priv->dev->dev;
 	priv->phylink_config.type = PHYLINK_NETDEV;
 	priv->phylink_config.pcs_poll = true;
-	priv->phylink_config.ovr_an_inband =
-		priv->plat->mdio_bus_data->xpcs_an_inband;
+	priv->phylink_config.ovr_an_inband = mdio_bus_data->xpcs_an_inband;
 
 	if (!fwnode)
 		fwnode = dev_fwnode(priv->device);
@@ -1248,6 +1221,12 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	if (IS_ERR(phylink))
 		return PTR_ERR(phylink);
 
+	if (mdio_bus_data->has_xpcs) {
+		struct mdio_xpcs_args *xpcs = &priv->hw->xpcs_args;
+
+		phylink_set_pcs(phylink, &xpcs->pcs);
+	}
+
 	priv->phylink = phylink;
 	return 0;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 2af83d902ea1..4a197b2fe26b 100644
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
 
@@ -510,7 +502,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 	}
 
 	/* Try to probe the XPCS by scanning all addresses. */
-	if (priv->hw->xpcs) {
+	if (mdio_bus_data->has_xpcs) {
 		struct mdio_xpcs_args *xpcs = &priv->hw->xpcs_args;
 		int ret;
 
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 4063dcc0f767..288abe8ddaf3 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -103,6 +103,9 @@
 /* VR MII EEE Control 1 defines */
 #define DW_VR_MII_EEE_TRN_LPI		BIT(0)	/* Transparent Mode Enable */
 
+#define phylink_pcs_to_xpcs(pl_pcs) \
+	container_of((pl_pcs), struct mdio_xpcs_args, pcs)
+
 static const int xpcs_usxgmii_features[] = {
 	ETHTOOL_LINK_MODE_Pause_BIT,
 	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
@@ -385,7 +388,7 @@ static int xpcs_get_max_usxgmii_speed(const unsigned long *supported)
 	return max;
 }
 
-static int xpcs_config_usxgmii(struct mdio_xpcs_args *xpcs, int speed)
+static void xpcs_config_usxgmii(struct mdio_xpcs_args *xpcs, int speed)
 {
 	int ret, speed_sel;
 
@@ -410,33 +413,40 @@ static int xpcs_config_usxgmii(struct mdio_xpcs_args *xpcs, int speed)
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
 
-	return xpcs_write_vpcs(xpcs, MDIO_CTRL1, ret | DW_USXGMII_RST);
+	return;
+
+out:
+	pr_err("%s: XPCS access returned %pe\n", __func__, ERR_PTR(ret));
 }
 
 static int _xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs)
@@ -765,14 +775,13 @@ static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
 }
 
-static int xpcs_config(struct mdio_xpcs_args *xpcs,
-		       const struct phylink_link_state *state)
+static int xpcs_do_config(struct mdio_xpcs_args *xpcs, unsigned int mode)
 {
 	int ret;
 
 	switch (xpcs->an_mode) {
 	case DW_AN_C73:
-		if (state->an_enabled) {
+		if (phylink_autoneg_inband(mode)) {
 			ret = xpcs_config_aneg_c73(xpcs);
 			if (ret)
 				return ret;
@@ -790,6 +799,16 @@ static int xpcs_config(struct mdio_xpcs_args *xpcs,
 	return 0;
 }
 
+static int xpcs_config(struct phylink_pcs *pcs, unsigned int mode,
+		       phy_interface_t interface,
+		       const unsigned long *advertising,
+		       bool permit_pause_to_mac)
+{
+	struct mdio_xpcs_args *xpcs = phylink_pcs_to_xpcs(pcs);
+
+	return xpcs_do_config(xpcs, mode);
+}
+
 static int xpcs_get_state_c73(struct mdio_xpcs_args *xpcs,
 			      struct phylink_link_state *state)
 {
@@ -807,7 +826,7 @@ static int xpcs_get_state_c73(struct mdio_xpcs_args *xpcs,
 
 		state->link = 0;
 
-		return xpcs_config(xpcs, state);
+		return xpcs_do_config(xpcs, MLO_AN_INBAND);
 	}
 
 	if (state->an_enabled && xpcs_aneg_done_c73(xpcs, state)) {
@@ -864,36 +883,40 @@ static int xpcs_get_state_c37_sgmii(struct mdio_xpcs_args *xpcs,
 	return 0;
 }
 
-static int xpcs_get_state(struct mdio_xpcs_args *xpcs,
-			  struct phylink_link_state *state)
+static void xpcs_get_state(struct phylink_pcs *pcs,
+			   struct phylink_link_state *state)
 {
+	struct mdio_xpcs_args *xpcs = phylink_pcs_to_xpcs(pcs);
 	int ret;
 
 	switch (xpcs->an_mode) {
 	case DW_AN_C73:
 		ret = xpcs_get_state_c73(xpcs, state);
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
@@ -934,6 +957,12 @@ static u32 xpcs_get_id(struct mdio_xpcs_args *xpcs)
 	return 0xffffffff;
 }
 
+static const struct phylink_pcs_ops xpcs_phylink_ops = {
+	.pcs_config = xpcs_config,
+	.pcs_get_state = xpcs_get_state,
+	.pcs_link_up = xpcs_link_up,
+};
+
 int xpcs_probe(struct mdio_xpcs_args *xpcs)
 {
 	u32 xpcs_id = xpcs_get_id(xpcs);
@@ -951,6 +980,9 @@ int xpcs_probe(struct mdio_xpcs_args *xpcs)
 		xpcs->id = entry;
 		xpcs->an_mode = entry->an_mode;
 
+		xpcs->pcs.ops = &xpcs_phylink_ops;
+		xpcs->pcs.poll = true;
+
 		return xpcs_soft_reset(xpcs);
 	}
 
@@ -958,16 +990,4 @@ int xpcs_probe(struct mdio_xpcs_args *xpcs)
 }
 EXPORT_SYMBOL_GPL(xpcs_probe);
 
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
index 11585fa093cd..eb74ab5b8138 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -18,22 +18,13 @@ struct xpcs_id;
 
 struct mdio_xpcs_args {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
+	struct phylink_pcs pcs;
 	struct mii_bus *bus;
 	struct xpcs_id *id;
 	int addr;
 	int an_mode;
 };
 
-struct mdio_xpcs_ops {
-	int (*config)(struct mdio_xpcs_args *xpcs,
-		      const struct phylink_link_state *state);
-	int (*get_state)(struct mdio_xpcs_args *xpcs,
-			 struct phylink_link_state *state);
-	int (*link_up)(struct mdio_xpcs_args *xpcs, int speed,
-		       phy_interface_t interface);
-};
-
-struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
 void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
 int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
-- 
2.25.1

