Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CA0317450
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhBJXY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:24:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:20916 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233912AbhBJXYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 18:24:32 -0500
IronPort-SDR: WaCOV/yjP/JdJiyFYR4ZFKokQ1nHJ+trodU8pQrsLmLFBBS4PkXy+OrMiynDwoQsgsC1+xRACq
 XEF+/moApjXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201287986"
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="201287986"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 15:23:44 -0800
IronPort-SDR: X5jq026MzGtdYJ8ILI57TEPkmRtUNS465LiAULPpkK9dMZRr7hAJKntq0c1eX905Xh4to2y5zB
 54/YDJ/nw8cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="361512350"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 10 Feb 2021 15:23:44 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 4/7] i40e: Add EEE status getting & setting implementation
Date:   Wed, 10 Feb 2021 15:24:33 -0800
Message-Id: <20210210232436.4084373-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210232436.4084373-1-anthony.l.nguyen@intel.com>
References: <20210210232436.4084373-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

Implement Energy Efficient Ethernet (EEE) status getting & setting.
The i40e_get_eee() requesting PHY EEE capabilities from firmware.
The i40e_set_eee() function requests PHY EEE capabilities
from firmware and sets PHY EEE advertising to full abilities or 0
depending whether EEE is to be enabled or disabled.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 123 +++++++++++++++++-
 .../net/ethernet/intel/i40e/i40e_register.h   |   2 +
 2 files changed, 123 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 204bd4116aa4..4e57d3f38ce7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -5242,12 +5242,131 @@ static int i40e_get_module_eeprom(struct net_device *netdev,
 
 static int i40e_get_eee(struct net_device *netdev, struct ethtool_eee *edata)
 {
-	return -EOPNOTSUPP;
+	struct i40e_netdev_priv *np = netdev_priv(netdev);
+	struct i40e_aq_get_phy_abilities_resp phy_cfg;
+	enum i40e_status_code status = 0;
+	struct i40e_vsi *vsi = np->vsi;
+	struct i40e_pf *pf = vsi->back;
+	struct i40e_hw *hw = &pf->hw;
+
+	/* Get initial PHY capabilities */
+	status = i40e_aq_get_phy_capabilities(hw, false, true, &phy_cfg, NULL);
+	if (status)
+		return -EAGAIN;
+
+	/* Check whether NIC configuration is compatible with Energy Efficient
+	 * Ethernet (EEE) mode.
+	 */
+	if (phy_cfg.eee_capability == 0)
+		return -EOPNOTSUPP;
+
+	edata->supported = SUPPORTED_Autoneg;
+	edata->lp_advertised = edata->supported;
+
+	/* Get current configuration */
+	status = i40e_aq_get_phy_capabilities(hw, false, false, &phy_cfg, NULL);
+	if (status)
+		return -EAGAIN;
+
+	edata->advertised = phy_cfg.eee_capability ? SUPPORTED_Autoneg : 0U;
+	edata->eee_enabled = !!edata->advertised;
+	edata->tx_lpi_enabled = pf->stats.tx_lpi_status;
+
+	edata->eee_active = pf->stats.tx_lpi_status && pf->stats.rx_lpi_status;
+
+	return 0;
+}
+
+static int i40e_is_eee_param_supported(struct net_device *netdev,
+				       struct ethtool_eee *edata)
+{
+	struct i40e_netdev_priv *np = netdev_priv(netdev);
+	struct i40e_vsi *vsi = np->vsi;
+	struct i40e_pf *pf = vsi->back;
+	struct i40e_ethtool_not_used {
+		u32 value;
+		const char *name;
+	} param[] = {
+		{edata->advertised & ~SUPPORTED_Autoneg, "advertise"},
+		{edata->tx_lpi_timer, "tx-timer"},
+		{edata->tx_lpi_enabled != pf->stats.tx_lpi_status, "tx-lpi"}
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(param); i++) {
+		if (param[i].value) {
+			netdev_info(netdev,
+				    "EEE setting %s not supported\n",
+				    param[i].name);
+			return -EOPNOTSUPP;
+		}
+	}
+
+	return 0;
 }
 
 static int i40e_set_eee(struct net_device *netdev, struct ethtool_eee *edata)
 {
-	return -EOPNOTSUPP;
+	struct i40e_netdev_priv *np = netdev_priv(netdev);
+	struct i40e_aq_get_phy_abilities_resp abilities;
+	enum i40e_status_code status = I40E_SUCCESS;
+	struct i40e_aq_set_phy_config config;
+	struct i40e_vsi *vsi = np->vsi;
+	struct i40e_pf *pf = vsi->back;
+	struct i40e_hw *hw = &pf->hw;
+	__le16 eee_capability;
+
+	/* Deny parameters we don't support */
+	if (i40e_is_eee_param_supported(netdev, edata))
+		return -EOPNOTSUPP;
+
+	/* Get initial PHY capabilities */
+	status = i40e_aq_get_phy_capabilities(hw, false, true, &abilities,
+					      NULL);
+	if (status)
+		return -EAGAIN;
+
+	/* Check whether NIC configuration is compatible with Energy Efficient
+	 * Ethernet (EEE) mode.
+	 */
+	if (abilities.eee_capability == 0)
+		return -EOPNOTSUPP;
+
+	/* Cache initial EEE capability */
+	eee_capability = abilities.eee_capability;
+
+	/* Get current PHY configuration */
+	status = i40e_aq_get_phy_capabilities(hw, false, false, &abilities,
+					      NULL);
+	if (status)
+		return -EAGAIN;
+
+	/* Cache current PHY configuration */
+	config.phy_type = abilities.phy_type;
+	config.phy_type_ext = abilities.phy_type_ext;
+	config.link_speed = abilities.link_speed;
+	config.abilities = abilities.abilities |
+			   I40E_AQ_PHY_ENABLE_ATOMIC_LINK;
+	config.eeer = abilities.eeer_val;
+	config.low_power_ctrl = abilities.d3_lpan;
+	config.fec_config = abilities.fec_cfg_curr_mod_ext_info &
+			    I40E_AQ_PHY_FEC_CONFIG_MASK;
+
+	/* Set desired EEE state */
+	if (edata->eee_enabled) {
+		config.eee_capability = eee_capability;
+		config.eeer |= cpu_to_le32(I40E_PRTPM_EEER_TX_LPI_EN_MASK);
+	} else {
+		config.eee_capability = 0;
+		config.eeer &= cpu_to_le32(~I40E_PRTPM_EEER_TX_LPI_EN_MASK);
+	}
+
+	/* Apply modified PHY configuration */
+	status = i40e_aq_set_phy_config(hw, &config, NULL);
+	if (status)
+		return -EAGAIN;
+
+	return 0;
 }
 
 static const struct ethtool_ops i40e_ethtool_recovery_mode_ops = {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_register.h b/drivers/net/ethernet/intel/i40e/i40e_register.h
index f79355b1dde6..36f7b27a04ae 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_register.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_register.h
@@ -544,6 +544,8 @@
 #define I40E_PRTPM_EEE_STAT_RX_LPI_STATUS_MASK I40E_MASK(0x1, I40E_PRTPM_EEE_STAT_RX_LPI_STATUS_SHIFT)
 #define I40E_PRTPM_EEE_STAT_TX_LPI_STATUS_SHIFT 31
 #define I40E_PRTPM_EEE_STAT_TX_LPI_STATUS_MASK I40E_MASK(0x1, I40E_PRTPM_EEE_STAT_TX_LPI_STATUS_SHIFT)
+#define I40E_PRTPM_EEER_TX_LPI_EN_SHIFT 16
+#define I40E_PRTPM_EEER_TX_LPI_EN_MASK  I40E_MASK(0x1, I40E_PRTPM_EEER_TX_LPI_EN_SHIFT)
 #define I40E_PRTPM_RLPIC 0x001E43A0 /* Reset: GLOBR */
 #define I40E_PRTPM_TLPIC 0x001E43C0 /* Reset: GLOBR */
 #define I40E_PRTRPB_DHW(_i) (0x000AC100 + ((_i) * 32)) /* _i=0...7 */ /* Reset: CORER */
-- 
2.26.2

