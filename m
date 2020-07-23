Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82EF22BA60
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgGWXry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:33991 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728210AbgGWXr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:28 -0400
IronPort-SDR: E54QLEZmBInEi5+NMdJLgLz4RLHTVJo73yUawaydeAFivlQfcTjKmJf6H2gAp+nVFANBKGH822
 jHDy9Ldpi3nw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="130200245"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="130200245"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:26 -0700
IronPort-SDR: qTPS4KVZgYwl183LAb7cQ2WdYG4fOi2EbcUf5R5zfKULP0ZNWufGaTRlmS1/OTjaIOOBcVwDU3
 mdhPzwGzBXTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742312"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 11/15] ice: update reporting of autoneg capabilities
Date:   Thu, 23 Jul 2020 16:47:16 -0700
Message-Id: <20200723234720.1547308-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
References: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Firmware now reports AN28, AN32, and AN73. Add a helper and check these new
values and report PHY autoneg capability.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h |  3 +++
 drivers/net/ethernet/intel/ice/ice_common.c     | 15 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c    |  8 ++++----
 drivers/net/ethernet/intel/ice/ice_main.c       |  8 ++++++--
 5 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 02a8d46540dc..800364be3bc8 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -963,6 +963,9 @@ struct ice_aqc_get_phy_caps_data {
 #define ICE_AQC_PHY_CAPS_MASK				ICE_M(0xff, 0)
 	u8 low_power_ctrl;
 #define ICE_AQC_PHY_EN_D3COLD_LOW_POWER_AUTONEG		BIT(0)
+#define ICE_AQC_PHY_AN_EN_CLAUSE28			BIT(1)
+#define ICE_AQC_PHY_AN_EN_CLAUSE73			BIT(2)
+#define ICE_AQC_PHY_AN_EN_CLAUSE37			BIT(3)
 	__le16 eee_cap;
 #define ICE_AQC_PHY_EEE_EN_100BASE_TX			BIT(0)
 #define ICE_AQC_PHY_EEE_EN_1000BASE_T			BIT(1)
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 4c6a8e6bdd40..ea8f09497d44 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4237,3 +4237,18 @@ ice_get_link_default_override(struct ice_link_default_override_tlv *ldo,
 
 	return status;
 }
+
+/**
+ * ice_is_phy_caps_an_enabled - check if PHY capabilities autoneg is enabled
+ * @caps: get PHY capability data
+ */
+bool ice_is_phy_caps_an_enabled(struct ice_aqc_get_phy_caps_data *caps)
+{
+	if (caps->caps & ICE_AQC_PHY_AN_MODE ||
+	    caps->low_power_ctrl & (ICE_AQC_PHY_AN_EN_CLAUSE28 |
+				    ICE_AQC_PHY_AN_EN_CLAUSE73 |
+				    ICE_AQC_PHY_AN_EN_CLAUSE37))
+		return true;
+
+	return false;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 1b8b02bb4399..33a681a75439 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -104,6 +104,7 @@ bool ice_fw_supports_link_override(struct ice_hw *hw);
 enum ice_status
 ice_get_link_default_override(struct ice_link_default_override_tlv *ldo,
 			      struct ice_port_info *pi);
+bool ice_is_phy_caps_an_enabled(struct ice_aqc_get_phy_caps_data *caps);
 
 enum ice_fc_mode ice_caps_to_fc_mode(u8 caps);
 enum ice_fec_mode ice_caps_to_fec_mode(u8 caps, u8 fec_options);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 60abd261b8bf..06b93e97892d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2987,8 +2987,8 @@ ice_get_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 	if (status)
 		goto out;
 
-	pause->autoneg = ((pcaps->caps & ICE_AQC_PHY_AN_MODE) ?
-			AUTONEG_ENABLE : AUTONEG_DISABLE);
+	pause->autoneg = ice_is_phy_caps_an_enabled(pcaps) ? AUTONEG_ENABLE :
+							     AUTONEG_DISABLE;
 
 	if (dcbx_cfg->pfc.pfcena)
 		/* PFC enabled so report LFC as off */
@@ -3056,8 +3056,8 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 		return -EIO;
 	}
 
-	is_an = ((pcaps->caps & ICE_AQC_PHY_AN_MODE) ?
-			AUTONEG_ENABLE : AUTONEG_DISABLE);
+	is_an = ice_is_phy_caps_an_enabled(pcaps) ? AUTONEG_ENABLE :
+						    AUTONEG_DISABLE;
 
 	kfree(pcaps);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c8c570f95b92..16a4096bb780 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -612,6 +612,7 @@ static void ice_print_topo_conflict(struct ice_vsi *vsi)
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 {
 	struct ice_aqc_get_phy_caps_data *caps;
+	const char *an_advertised;
 	enum ice_status status;
 	const char *fec_req;
 	const char *speed;
@@ -710,6 +711,7 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 	caps = kzalloc(sizeof(*caps), GFP_KERNEL);
 	if (!caps) {
 		fec_req = "Unknown";
+		an_advertised = "Unknown";
 		goto done;
 	}
 
@@ -718,6 +720,8 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 	if (status)
 		netdev_info(vsi->netdev, "Get phy capability failed.\n");
 
+	an_advertised = ice_is_phy_caps_an_enabled(caps) ? "On" : "Off";
+
 	if (caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_528_REQ ||
 	    caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_544_REQ)
 		fec_req = "RS-FEC";
@@ -730,8 +734,8 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 	kfree(caps);
 
 done:
-	netdev_info(vsi->netdev, "NIC Link is up %sbps Full Duplex, Requested FEC: %s, Negotiated FEC: %s, Autoneg: %s, Flow Control: %s\n",
-		    speed, fec_req, fec, an, fc);
+	netdev_info(vsi->netdev, "NIC Link is up %sbps Full Duplex, Requested FEC: %s, Negotiated FEC: %s, Autoneg Advertised: %s, Autoneg Negotiated: %s, Flow Control: %s\n",
+		    speed, fec_req, fec, an_advertised, an, fc);
 	ice_print_topo_conflict(vsi);
 }
 
-- 
2.26.2

