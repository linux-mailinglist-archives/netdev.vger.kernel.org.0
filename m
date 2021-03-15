Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263AC33AACD
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 06:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhCOFYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 01:24:02 -0400
Received: from mga07.intel.com ([134.134.136.100]:59451 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhCOFXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 01:23:34 -0400
IronPort-SDR: TX0x6/mK/gnkm3DeWydxwdfCKBTQoyZKdpWjkx7dwRKnOawhJ/aoXaB1ZzfMPcRFaA3Y/dTVGA
 1Q36L+FubMrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="253054419"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="253054419"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 22:23:34 -0700
IronPort-SDR: 3M/ONOx+eo7M9uERHAaFQsNoy3NA9kmiuSCTCnlM6wMwNAN2CGqXuct7ke7DDXHCSk6iC0Ad9I
 ZgjVWVm/DeeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="373313749"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga006.jf.intel.com with ESMTP; 14 Mar 2021 22:23:29 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King i <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: [PATCH net-next 1/6] net: pcs: rearrange C73 functions to prepare for C37 support later
Date:   Mon, 15 Mar 2021 13:27:06 +0800
Message-Id: <20210315052711.16728-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315052711.16728-1-boon.leong.ong@intel.com>
References: <20210315052711.16728-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementation for XPCS is validated for C73, so we rename them
to have _c73 suffix and introduce a set of functions to use an_mode flag
to switch between C73 and C37 AN later.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/pcs/pcs-xpcs.c   | 94 +++++++++++++++++++++++++-----------
 include/linux/pcs/pcs-xpcs.h |  4 ++
 2 files changed, 70 insertions(+), 28 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 1aa9903d602e..10def2d98696 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -125,22 +125,26 @@ static struct xpcs_id {
 	u32 mask;
 	const int *supported;
 	const phy_interface_t *interface;
+	int an_mode;
 } xpcs_id_list[] = {
 	{
 		.id = SYNOPSYS_XPCS_USXGMII_ID,
 		.mask = SYNOPSYS_XPCS_MASK,
 		.supported = xpcs_usxgmii_features,
 		.interface = xpcs_usxgmii_interfaces,
+		.an_mode = DW_AN_C73,
 	}, {
 		.id = SYNOPSYS_XPCS_10GKR_ID,
 		.mask = SYNOPSYS_XPCS_MASK,
 		.supported = xpcs_10gkr_features,
 		.interface = xpcs_10gkr_interfaces,
+		.an_mode = DW_AN_C73,
 	}, {
 		.id = SYNOPSYS_XPCS_XLGMII_ID,
 		.mask = SYNOPSYS_XPCS_MASK,
 		.supported = xpcs_xlgmii_features,
 		.interface = xpcs_xlgmii_interfaces,
+		.an_mode = DW_AN_C73,
 	},
 };
 
@@ -195,9 +199,17 @@ static int xpcs_poll_reset(struct mdio_xpcs_args *xpcs, int dev)
 	return (ret & MDIO_CTRL1_RESET) ? -ETIMEDOUT : 0;
 }
 
-static int xpcs_soft_reset(struct mdio_xpcs_args *xpcs, int dev)
+static int xpcs_soft_reset(struct mdio_xpcs_args *xpcs)
 {
-	int ret;
+	int ret, dev;
+
+	switch (xpcs->an_mode) {
+	case DW_AN_C73:
+		dev = MDIO_MMD_PCS;
+		break;
+	default:
+		return -1;
+	}
 
 	ret = xpcs_write(xpcs, dev, MDIO_CTRL1, MDIO_CTRL1_RESET);
 	if (ret < 0)
@@ -212,8 +224,8 @@ static int xpcs_soft_reset(struct mdio_xpcs_args *xpcs, int dev)
 		dev_warn(&(__xpcs)->bus->dev, ##__args); \
 })
 
-static int xpcs_read_fault(struct mdio_xpcs_args *xpcs,
-			   struct phylink_link_state *state)
+static int xpcs_read_fault_c73(struct mdio_xpcs_args *xpcs,
+			       struct phylink_link_state *state)
 {
 	int ret;
 
@@ -263,7 +275,7 @@ static int xpcs_read_fault(struct mdio_xpcs_args *xpcs,
 	return 0;
 }
 
-static int xpcs_read_link(struct mdio_xpcs_args *xpcs, bool an)
+static int xpcs_read_link_c73(struct mdio_xpcs_args *xpcs, bool an)
 {
 	bool link = true;
 	int ret;
@@ -357,7 +369,7 @@ static int xpcs_config_usxgmii(struct mdio_xpcs_args *xpcs, int speed)
 	return xpcs_write_vpcs(xpcs, MDIO_CTRL1, ret | DW_USXGMII_RST);
 }
 
-static int xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs)
+static int _xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs)
 {
 	int ret, adv;
 
@@ -401,11 +413,11 @@ static int xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs)
 	return xpcs_write(xpcs, MDIO_MMD_AN, DW_SR_AN_ADV1, adv);
 }
 
-static int xpcs_config_aneg(struct mdio_xpcs_args *xpcs)
+static int xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs)
 {
 	int ret;
 
-	ret = xpcs_config_aneg_c73(xpcs);
+	ret = _xpcs_config_aneg_c73(xpcs);
 	if (ret < 0)
 		return ret;
 
@@ -418,8 +430,8 @@ static int xpcs_config_aneg(struct mdio_xpcs_args *xpcs)
 	return xpcs_write(xpcs, MDIO_MMD_AN, MDIO_CTRL1, ret);
 }
 
-static int xpcs_aneg_done(struct mdio_xpcs_args *xpcs,
-			  struct phylink_link_state *state)
+static int xpcs_aneg_done_c73(struct mdio_xpcs_args *xpcs,
+			      struct phylink_link_state *state)
 {
 	int ret;
 
@@ -434,7 +446,7 @@ static int xpcs_aneg_done(struct mdio_xpcs_args *xpcs,
 
 		/* Check if Aneg outcome is valid */
 		if (!(ret & DW_C73_AN_ADV_SF)) {
-			xpcs_config_aneg(xpcs);
+			xpcs_config_aneg_c73(xpcs);
 			return 0;
 		}
 
@@ -444,8 +456,8 @@ static int xpcs_aneg_done(struct mdio_xpcs_args *xpcs,
 	return 0;
 }
 
-static int xpcs_read_lpa(struct mdio_xpcs_args *xpcs,
-			 struct phylink_link_state *state)
+static int xpcs_read_lpa_c73(struct mdio_xpcs_args *xpcs,
+			     struct phylink_link_state *state)
 {
 	int ret;
 
@@ -493,8 +505,8 @@ static int xpcs_read_lpa(struct mdio_xpcs_args *xpcs,
 	return 0;
 }
 
-static void xpcs_resolve_lpa(struct mdio_xpcs_args *xpcs,
-			     struct phylink_link_state *state)
+static void xpcs_resolve_lpa_c73(struct mdio_xpcs_args *xpcs,
+				 struct phylink_link_state *state)
 {
 	int max_speed = xpcs_get_max_usxgmii_speed(state->lp_advertising);
 
@@ -590,27 +602,33 @@ static int xpcs_config(struct mdio_xpcs_args *xpcs,
 {
 	int ret;
 
-	if (state->an_enabled) {
-		ret = xpcs_config_aneg(xpcs);
-		if (ret)
-			return ret;
+	switch (xpcs->an_mode) {
+	case DW_AN_C73:
+		if (state->an_enabled) {
+			ret = xpcs_config_aneg_c73(xpcs);
+			if (ret)
+				return ret;
+		}
+		break;
+	default:
+		return -1;
 	}
 
 	return 0;
 }
 
-static int xpcs_get_state(struct mdio_xpcs_args *xpcs,
-			  struct phylink_link_state *state)
+static int xpcs_get_state_c73(struct mdio_xpcs_args *xpcs,
+			      struct phylink_link_state *state)
 {
 	int ret;
 
 	/* Link needs to be read first ... */
-	state->link = xpcs_read_link(xpcs, state->an_enabled) > 0 ? 1 : 0;
+	state->link = xpcs_read_link_c73(xpcs, state->an_enabled) > 0 ? 1 : 0;
 
 	/* ... and then we check the faults. */
-	ret = xpcs_read_fault(xpcs, state);
+	ret = xpcs_read_fault_c73(xpcs, state);
 	if (ret) {
-		ret = xpcs_soft_reset(xpcs, MDIO_MMD_PCS);
+		ret = xpcs_soft_reset(xpcs);
 		if (ret)
 			return ret;
 
@@ -619,10 +637,10 @@ static int xpcs_get_state(struct mdio_xpcs_args *xpcs,
 		return xpcs_config(xpcs, state);
 	}
 
-	if (state->an_enabled && xpcs_aneg_done(xpcs, state)) {
+	if (state->an_enabled && xpcs_aneg_done_c73(xpcs, state)) {
 		state->an_complete = true;
-		xpcs_read_lpa(xpcs, state);
-		xpcs_resolve_lpa(xpcs, state);
+		xpcs_read_lpa_c73(xpcs, state);
+		xpcs_resolve_lpa_c73(xpcs, state);
 	} else if (state->an_enabled) {
 		state->link = 0;
 	} else if (state->link) {
@@ -632,6 +650,24 @@ static int xpcs_get_state(struct mdio_xpcs_args *xpcs,
 	return 0;
 }
 
+static int xpcs_get_state(struct mdio_xpcs_args *xpcs,
+			  struct phylink_link_state *state)
+{
+	int ret;
+
+	switch (xpcs->an_mode) {
+	case DW_AN_C73:
+		ret = xpcs_get_state_c73(xpcs, state);
+		if (ret)
+			return ret;
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
 static int xpcs_link_up(struct mdio_xpcs_args *xpcs, int speed,
 			phy_interface_t interface)
 {
@@ -676,6 +712,8 @@ static bool xpcs_check_features(struct mdio_xpcs_args *xpcs,
 	for (i = 0; match->supported[i] != __ETHTOOL_LINK_MODE_MASK_NBITS; i++)
 		set_bit(match->supported[i], xpcs->supported);
 
+	xpcs->an_mode = match->an_mode;
+
 	return true;
 }
 
@@ -692,7 +730,7 @@ static int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
 			match = entry;
 
 			if (xpcs_check_features(xpcs, match, interface))
-				return xpcs_soft_reset(xpcs, MDIO_MMD_PCS);
+				return xpcs_soft_reset(xpcs);
 		}
 	}
 
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 351c1c9aedc5..a04e57c25fea 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -10,10 +10,14 @@
 #include <linux/phy.h>
 #include <linux/phylink.h>
 
+/* AN mode */
+#define DW_AN_C73			1
+
 struct mdio_xpcs_args {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
 	struct mii_bus *bus;
 	int addr;
+	int an_mode;
 };
 
 struct mdio_xpcs_ops {
-- 
2.25.1

