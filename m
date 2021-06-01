Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBDD396A4F
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhFAAfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbhFAAfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 20:35:19 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A995C061760
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:36 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b11so8410049edy.4
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DCGSCVeJZbXYsfSNfQ+KUOeNbYoAA8gDorl6/qBGHZ8=;
        b=jGge4l8fr7DEtQiFIJJGaxftNcpaHY+UIo3A//xZBJ3M3w30VjHHZg7gv2Z9LCLMOD
         0x+8wu9e9lTZMc8xyhCuRvycceCfu8Q4nBY+/TuTH4nRgujdmfyINZGpWdGob0ebJzll
         fHCbqD2KR10iiFU8n0oaTQcEJF9tO95j1bX5rjLFoI26RKwOuUmTrkm2hRDV+U6TWvVf
         mCzXFTyifzSGn7zple62Op5StkeYiAFQGs8kxjpRPeWLbyniqa3rcxOOVzsfaCz4groD
         hS9fjKIOGIslbRkJdXr+67oI28/8fIdmJ8moL7EC5jneexUQe31Y0fEJqiZPW/SYh2dh
         E64w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DCGSCVeJZbXYsfSNfQ+KUOeNbYoAA8gDorl6/qBGHZ8=;
        b=QGWrJmU3rX24bOLPX2uMWSqLGDLC8BsH12KwwmUXIt2Fe8TCVGsp1Gt+/UDTTFryBe
         s4z5fAK2AUzs1xeFWBMdUzmPArGQg2K00h7ZfilO9rNhqiRRXnynevQuqs6VjvbP77KL
         HAaR3eMpWAt8KeT0vzkusK8DkWeIzfSZC5djGDsPxcolMUEgQq0sR7Pl6Ngs5nkA5KQ1
         YBK6xZQUO04RemJD1eor/rx+S3kCaSu80iYxL5BUVlzhS6Vok/I9OtrvfFxkROIkG+HO
         BW6znzy8tkPs9wlgWrHYAqEWsl2ZpJgbcnR34IHQgX0Av7Wpen5w3dVBldGEB3XhdiSO
         9eYg==
X-Gm-Message-State: AOAM532T0fOa+UkxDD5KKseEQqyHeoSi53y8q+xzh9CPSUVVUXaw4al4
        ALeasFDWvO1lSFQnV8dGI/w=
X-Google-Smtp-Source: ABdhPJzU982wS58fI/gmw+xsy9WWjwLySnUahATd63lc/VBNs0FTBYpKIAPk2ZvRcp1MtarRBIZ8CA==
X-Received: by 2002:aa7:d5cf:: with SMTP id d15mr2427343eds.342.1622507614934;
        Mon, 31 May 2021 17:33:34 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm6510521ejr.63.2021.05.31.17.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 17:33:34 -0700 (PDT)
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
Subject: [RFC PATCH v2 net-next 3/9] net: pcs: xpcs: make the checks related to the PHY interface mode stateless
Date:   Tue,  1 Jun 2021 03:33:19 +0300
Message-Id: <20210601003325.1631980-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601003325.1631980-1-olteanv@gmail.com>
References: <20210601003325.1631980-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The operating mode of the driver is currently to populate its
struct mdio_xpcs_args::supported and struct mdio_xpcs_args::an_mode
statically in xpcs_probe(), based on the passed phy_interface_t,
and work with those.

However this is not the operation that phylink expects from a PCS
driver, because the port might be attached to an SFP cage that triggers
changes of the phy_interface_t dynamically as one SFP module is
unpluggged and another is plugged.

To migrate towards that model, the struct mdio_xpcs_args should not
cache anything related to the phy_interface_t, but just look up the
statically defined, const struct xpcs_compat structure corresponding to
the detected PCS OUI/model number.

So we delete the "supported" and "an_mode" members of struct
mdio_xpcs_args, and add the "id" structure there (since the ID is not
expected to change at runtime).

Since xpcs->supported is used deep in the code in _xpcs_config_aneg_c73(),
we need to modify some function headers to pass the xpcs_compat from all
callers. In turn, the xpcs_compat is always supplied externally to the
xpcs module:
- Most of the time by phylink
- In xpcs_probe() it is needed because xpcs_soft_reset() writes to
  MDIO_MMD_PCS or to MDIO_MMD_VEND2 depending on whether an_mode is clause
  37 or clause 73. In order to not introduce functional changes related
  to when the soft reset is issued, we continue to require the initial
  phy_interface_t argument to be passed to xpcs_probe() so we can pass
  this on to xpcs_soft_reset().
- stmmac_open() wants to know whether to call stmmac_init_phy() or not,
  and for that it looks inside xpcs->an_mode, because the clause 73
  (backplane) AN modes supposedly do not have a PHY. Because we moved
  an_mode outside of struct mdio_xpcs_args, this is now no longer
  directly possible, so we introduce a helper function xpcs_get_an_mode()
  which protects the data encapsulation of the xpcs module and requires
  a phy_interface_t to be passed as argument. This function can look up
  the appropriate compat based on the phy_interface_t.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   4 +-
 drivers/net/pcs/pcs-xpcs.c                    | 175 +++++++++++-------
 include/linux/pcs/pcs-xpcs.h                  |   6 +-
 3 files changed, 120 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9962a1041d35..129b103cd2b5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3637,6 +3637,7 @@ static int stmmac_request_irq(struct net_device *dev)
 int stmmac_open(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
+	int mode = priv->plat->phy_interface;
 	int bfsize = 0;
 	u32 chan;
 	int ret;
@@ -3649,7 +3650,8 @@ int stmmac_open(struct net_device *dev)
 
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI &&
-	    priv->hw->xpcs_args.an_mode != DW_AN_C73) {
+	    (!priv->hw->xpcs ||
+	     xpcs_get_an_mode(&priv->hw->xpcs_args, mode) != DW_AN_C73)) {
 		ret = stmmac_init_phy(dev);
 		if (ret) {
 			netdev_err(priv->dev,
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 8491cfe1c11d..4bc63d7e3bda 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -230,6 +230,49 @@ static const struct xpcs_id xpcs_id_list[] = {
 	},
 };
 
+static const struct xpcs_compat *xpcs_find_compat(const struct xpcs_id *id,
+						  phy_interface_t interface)
+{
+	int i, j;
+
+	for (i = 0; i < DW_XPCS_INTERFACE_MAX; i++) {
+		const struct xpcs_compat *compat = &id->compat[i];
+
+		for (j = 0; j < compat->num_interfaces; j++)
+			if (compat->interface[j] == interface)
+				return compat;
+	}
+
+	return NULL;
+}
+
+int xpcs_get_an_mode(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
+{
+	const struct xpcs_compat *compat;
+
+	compat = xpcs_find_compat(xpcs->id, interface);
+	if (!compat)
+		return -ENODEV;
+
+	return compat->an_mode;
+}
+EXPORT_SYMBOL_GPL(xpcs_get_an_mode);
+
+static bool __xpcs_linkmode_supported(const struct xpcs_compat *compat,
+				      enum ethtool_link_mode_bit_indices linkmode)
+{
+	int i;
+
+	for (i = 0; compat->supported[i] != __ETHTOOL_LINK_MODE_MASK_NBITS; i++)
+		if (compat->supported[i] == linkmode)
+			return true;
+
+	return false;
+}
+
+#define xpcs_linkmode_supported(compat, mode) \
+	__xpcs_linkmode_supported(compat, ETHTOOL_LINK_MODE_ ## mode ## _BIT)
+
 static int xpcs_read(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
 {
 	u32 reg_addr = MII_ADDR_C45 | dev << 16 | reg;
@@ -281,11 +324,12 @@ static int xpcs_poll_reset(struct mdio_xpcs_args *xpcs, int dev)
 	return (ret & MDIO_CTRL1_RESET) ? -ETIMEDOUT : 0;
 }
 
-static int xpcs_soft_reset(struct mdio_xpcs_args *xpcs)
+static int xpcs_soft_reset(struct mdio_xpcs_args *xpcs,
+			   const struct xpcs_compat *compat)
 {
 	int ret, dev;
 
-	switch (xpcs->an_mode) {
+	switch (compat->an_mode) {
 	case DW_AN_C73:
 		dev = MDIO_MMD_PCS;
 		break;
@@ -454,7 +498,8 @@ static int xpcs_config_usxgmii(struct mdio_xpcs_args *xpcs, int speed)
 	return xpcs_write_vpcs(xpcs, MDIO_CTRL1, ret | DW_USXGMII_RST);
 }
 
-static int _xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs)
+static int _xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs,
+				 const struct xpcs_compat *compat)
 {
 	int ret, adv;
 
@@ -466,7 +511,7 @@ static int _xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs)
 
 	/* SR_AN_ADV3 */
 	adv = 0;
-	if (phylink_test(xpcs->supported, 2500baseX_Full))
+	if (xpcs_linkmode_supported(compat, 2500baseX_Full))
 		adv |= DW_C73_2500KX;
 
 	/* TODO: 5000baseKR */
@@ -477,11 +522,11 @@ static int _xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs)
 
 	/* SR_AN_ADV2 */
 	adv = 0;
-	if (phylink_test(xpcs->supported, 1000baseKX_Full))
+	if (xpcs_linkmode_supported(compat, 1000baseKX_Full))
 		adv |= DW_C73_1000KX;
-	if (phylink_test(xpcs->supported, 10000baseKX4_Full))
+	if (xpcs_linkmode_supported(compat, 10000baseKX4_Full))
 		adv |= DW_C73_10000KX4;
-	if (phylink_test(xpcs->supported, 10000baseKR_Full))
+	if (xpcs_linkmode_supported(compat, 10000baseKR_Full))
 		adv |= DW_C73_10000KR;
 
 	ret = xpcs_write(xpcs, MDIO_MMD_AN, DW_SR_AN_ADV2, adv);
@@ -490,19 +535,20 @@ static int _xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs)
 
 	/* SR_AN_ADV1 */
 	adv = DW_C73_AN_ADV_SF;
-	if (phylink_test(xpcs->supported, Pause))
+	if (xpcs_linkmode_supported(compat, Pause))
 		adv |= DW_C73_PAUSE;
-	if (phylink_test(xpcs->supported, Asym_Pause))
+	if (xpcs_linkmode_supported(compat, Asym_Pause))
 		adv |= DW_C73_ASYM_PAUSE;
 
 	return xpcs_write(xpcs, MDIO_MMD_AN, DW_SR_AN_ADV1, adv);
 }
 
-static int xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs)
+static int xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs,
+				const struct xpcs_compat *compat)
 {
 	int ret;
 
-	ret = _xpcs_config_aneg_c73(xpcs);
+	ret = _xpcs_config_aneg_c73(xpcs, compat);
 	if (ret < 0)
 		return ret;
 
@@ -516,7 +562,8 @@ static int xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs)
 }
 
 static int xpcs_aneg_done_c73(struct mdio_xpcs_args *xpcs,
-			      struct phylink_link_state *state)
+			      struct phylink_link_state *state,
+			      const struct xpcs_compat *compat)
 {
 	int ret;
 
@@ -531,7 +578,7 @@ static int xpcs_aneg_done_c73(struct mdio_xpcs_args *xpcs,
 
 		/* Check if Aneg outcome is valid */
 		if (!(ret & DW_C73_AN_ADV_SF)) {
-			xpcs_config_aneg_c73(xpcs);
+			xpcs_config_aneg_c73(xpcs, compat);
 			return 0;
 		}
 
@@ -677,8 +724,31 @@ static int xpcs_validate(struct mdio_xpcs_args *xpcs,
 			 unsigned long *supported,
 			 struct phylink_link_state *state)
 {
-	linkmode_and(supported, supported, xpcs->supported);
-	linkmode_and(state->advertising, state->advertising, xpcs->supported);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(xpcs_supported);
+	const struct xpcs_compat *compat;
+	int i;
+
+	/* phylink expects us to report all supported modes with
+	 * PHY_INTERFACE_MODE_NA, just don't limit the supported and
+	 * advertising masks and exit.
+	 */
+	if (state->interface == PHY_INTERFACE_MODE_NA)
+		return 0;
+
+	bitmap_zero(xpcs_supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+
+	compat = xpcs_find_compat(xpcs->id, state->interface);
+
+	/* Populate the supported link modes for this
+	 * PHY interface type
+	 */
+	if (compat)
+		for (i = 0; compat->supported[i] != __ETHTOOL_LINK_MODE_MASK_NBITS; i++)
+			set_bit(compat->supported[i], xpcs_supported);
+
+	linkmode_and(supported, supported, xpcs_supported);
+	linkmode_and(state->advertising, state->advertising, xpcs_supported);
+
 	return 0;
 }
 
@@ -759,12 +829,17 @@ static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
 static int xpcs_config(struct mdio_xpcs_args *xpcs,
 		       const struct phylink_link_state *state)
 {
+	const struct xpcs_compat *compat;
 	int ret;
 
-	switch (xpcs->an_mode) {
+	compat = xpcs_find_compat(xpcs->id, state->interface);
+	if (!compat)
+		return -ENODEV;
+
+	switch (compat->an_mode) {
 	case DW_AN_C73:
 		if (state->an_enabled) {
-			ret = xpcs_config_aneg_c73(xpcs);
+			ret = xpcs_config_aneg_c73(xpcs, compat);
 			if (ret)
 				return ret;
 		}
@@ -782,7 +857,8 @@ static int xpcs_config(struct mdio_xpcs_args *xpcs,
 }
 
 static int xpcs_get_state_c73(struct mdio_xpcs_args *xpcs,
-			      struct phylink_link_state *state)
+			      struct phylink_link_state *state,
+			      const struct xpcs_compat *compat)
 {
 	int ret;
 
@@ -792,7 +868,7 @@ static int xpcs_get_state_c73(struct mdio_xpcs_args *xpcs,
 	/* ... and then we check the faults. */
 	ret = xpcs_read_fault_c73(xpcs, state);
 	if (ret) {
-		ret = xpcs_soft_reset(xpcs);
+		ret = xpcs_soft_reset(xpcs, compat);
 		if (ret)
 			return ret;
 
@@ -801,7 +877,7 @@ static int xpcs_get_state_c73(struct mdio_xpcs_args *xpcs,
 		return xpcs_config(xpcs, state);
 	}
 
-	if (state->an_enabled && xpcs_aneg_done_c73(xpcs, state)) {
+	if (state->an_enabled && xpcs_aneg_done_c73(xpcs, state, compat)) {
 		state->an_complete = true;
 		xpcs_read_lpa_c73(xpcs, state);
 		xpcs_resolve_lpa_c73(xpcs, state);
@@ -858,11 +934,16 @@ static int xpcs_get_state_c37_sgmii(struct mdio_xpcs_args *xpcs,
 static int xpcs_get_state(struct mdio_xpcs_args *xpcs,
 			  struct phylink_link_state *state)
 {
+	const struct xpcs_compat *compat;
 	int ret;
 
-	switch (xpcs->an_mode) {
+	compat = xpcs_find_compat(xpcs->id, state->interface);
+	if (!compat)
+		return -ENODEV;
+
+	switch (compat->an_mode) {
 	case DW_AN_C73:
-		ret = xpcs_get_state_c73(xpcs, state);
+		ret = xpcs_get_state_c73(xpcs, state, compat);
 		if (ret)
 			return ret;
 		break;
@@ -925,55 +1006,25 @@ static u32 xpcs_get_id(struct mdio_xpcs_args *xpcs)
 	return 0xffffffff;
 }
 
-static bool xpcs_check_features(struct mdio_xpcs_args *xpcs,
-				const struct xpcs_id *match,
-				phy_interface_t interface)
-{
-	int i, j;
-
-	for (i = 0; i < DW_XPCS_INTERFACE_MAX; i++) {
-		const struct xpcs_compat *compat = &match->compat[i];
-		bool supports_interface = false;
-
-		for (j = 0; j < compat->num_interfaces; j++) {
-			if (compat->interface[j] == interface) {
-				supports_interface = true;
-				break;
-			}
-		}
-
-		if (!supports_interface)
-			continue;
-
-		/* Populate the supported link modes for this
-		 * PHY interface type
-		 */
-		for (j = 0; compat->supported[j] != __ETHTOOL_LINK_MODE_MASK_NBITS; j++)
-			set_bit(compat->supported[j], xpcs->supported);
-
-		xpcs->an_mode = compat->an_mode;
-
-		return true;
-	}
-
-	return false;
-}
-
 static int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
 {
-	const struct xpcs_id *match = NULL;
 	u32 xpcs_id = xpcs_get_id(xpcs);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(xpcs_id_list); i++) {
 		const struct xpcs_id *entry = &xpcs_id_list[i];
+		const struct xpcs_compat *compat;
 
-		if ((xpcs_id & entry->mask) == entry->id) {
-			match = entry;
+		if ((xpcs_id & entry->mask) != entry->id)
+			continue;
 
-			if (xpcs_check_features(xpcs, match, interface))
-				return xpcs_soft_reset(xpcs);
-		}
+		xpcs->id = entry;
+
+		compat = xpcs_find_compat(entry, interface);
+		if (!compat)
+			return -ENODEV;
+
+		return xpcs_soft_reset(xpcs, compat);
 	}
 
 	return -ENODEV;
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index c4d0a2c469c7..c2ec440d2c5d 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -14,11 +14,12 @@
 #define DW_AN_C73			1
 #define DW_AN_C37_SGMII			2
 
+struct xpcs_id;
+
 struct mdio_xpcs_args {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
 	struct mii_bus *bus;
+	const struct xpcs_id *id;
 	int addr;
-	int an_mode;
 };
 
 struct mdio_xpcs_ops {
@@ -36,6 +37,7 @@ struct mdio_xpcs_ops {
 			  int enable);
 };
 
+int xpcs_get_an_mode(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

