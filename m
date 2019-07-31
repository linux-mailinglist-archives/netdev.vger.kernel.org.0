Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD4E7CEE0
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbfGaUlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:41:51 -0400
Received: from mga17.intel.com ([192.55.52.151]:16005 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfGaUlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 16:41:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 13:41:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="323901006"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2019 13:41:48 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/16] ice: add lp_advertising flow control support
Date:   Wed, 31 Jul 2019 13:41:32 -0700
Message-Id: <20190731204147.8582-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
References: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Add support for reporting link partner advertising when
ETHTOOL_GLINKSETTINGS defined. Get pause param reports the Tx/Rx
pause configured, and then ethtool issues ETHTOOL_GSET ioctl and
ice_get_settings_link_up reports the negotiated Tx/Rx pause. Negotiated
pause frame report per IEEE 802.3-2005 table 288-3.

$ ethtool --show-pause ens6f0
Pause parameters for ens6f0:
Autonegotiate:  on
RX:             on
TX:             on
RX negotiated:  on
TX negotiated:  on

$ ethtool ens6f0
Settings for ens6f0:
        Supported ports: [ FIBRE ]
        Supported link modes:   25000baseCR/Full
        Supported pause frame use: Symmetric
        Supports auto-negotiation: Yes
        Supported FEC modes: None BaseR RS
        Advertised link modes:  25000baseCR/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: None BaseR RS
        Link partner advertised link modes:  Not reported
        Link partner advertised pause frame use: Symmetric
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 25000Mb/s
        Duplex: Full
        Port: Direct Attach Copper
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        Supports Wake-on: g
        Wake-on: g
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes

When ETHTOOL_GLINKSETTINGS is not defined, get pause param reports the
negotiated Tx/Rx pause.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 104 +++++++++++++------
 1 file changed, 72 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 52083a63dee6..d3ba535bd65a 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1716,6 +1716,7 @@ ice_get_settings_link_up(struct ethtool_link_ksettings *ks,
 			 struct net_device *netdev)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_port_info *pi = np->vsi->port_info;
 	struct ethtool_link_ksettings cap_ksettings;
 	struct ice_link_status *link_info;
 	struct ice_vsi *vsi = np->vsi;
@@ -2040,6 +2041,33 @@ ice_get_settings_link_up(struct ethtool_link_ksettings *ks,
 		break;
 	}
 	ks->base.duplex = DUPLEX_FULL;
+
+	if (link_info->an_info & ICE_AQ_AN_COMPLETED)
+		ethtool_link_ksettings_add_link_mode(ks, lp_advertising,
+						     Autoneg);
+
+	/* Set flow control negotiated Rx/Tx pause */
+	switch (pi->fc.current_mode) {
+	case ICE_FC_FULL:
+		ethtool_link_ksettings_add_link_mode(ks, lp_advertising, Pause);
+		break;
+	case ICE_FC_TX_PAUSE:
+		ethtool_link_ksettings_add_link_mode(ks, lp_advertising, Pause);
+		ethtool_link_ksettings_add_link_mode(ks, lp_advertising,
+						     Asym_Pause);
+		break;
+	case ICE_FC_RX_PAUSE:
+		ethtool_link_ksettings_add_link_mode(ks, lp_advertising,
+						     Asym_Pause);
+		break;
+	case ICE_FC_PFC:
+		/* fall through */
+	default:
+		ethtool_link_ksettings_del_link_mode(ks, lp_advertising, Pause);
+		ethtool_link_ksettings_del_link_mode(ks, lp_advertising,
+						     Asym_Pause);
+		break;
+	}
 }
 
 /**
@@ -2078,9 +2106,12 @@ ice_get_link_ksettings(struct net_device *netdev,
 	struct ice_aqc_get_phy_caps_data *caps;
 	struct ice_link_status *hw_link_info;
 	struct ice_vsi *vsi = np->vsi;
+	enum ice_status status;
+	int err = 0;
 
 	ethtool_link_ksettings_zero_link_mode(ks, supported);
 	ethtool_link_ksettings_zero_link_mode(ks, advertising);
+	ethtool_link_ksettings_zero_link_mode(ks, lp_advertising);
 	hw_link_info = &vsi->port_info->phy.link_info;
 
 	/* set speed and duplex */
@@ -2125,48 +2156,36 @@ ice_get_link_ksettings(struct net_device *netdev,
 	/* flow control is symmetric and always supported */
 	ethtool_link_ksettings_add_link_mode(ks, supported, Pause);
 
-	switch (vsi->port_info->fc.req_mode) {
-	case ICE_FC_FULL:
+	caps = devm_kzalloc(&vsi->back->pdev->dev, sizeof(*caps), GFP_KERNEL);
+	if (!caps)
+		return -ENOMEM;
+
+	status = ice_aq_get_phy_caps(vsi->port_info, false,
+				     ICE_AQC_REPORT_SW_CFG, caps, NULL);
+	if (status) {
+		err = -EIO;
+		goto done;
+	}
+
+	/* Set the advertised flow control based on the PHY capability */
+	if ((caps->caps & ICE_AQC_PHY_EN_TX_LINK_PAUSE) &&
+	    (caps->caps & ICE_AQC_PHY_EN_RX_LINK_PAUSE)) {
 		ethtool_link_ksettings_add_link_mode(ks, advertising, Pause);
-		break;
-	case ICE_FC_TX_PAUSE:
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
 						     Asym_Pause);
-		break;
-	case ICE_FC_RX_PAUSE:
+	} else if (caps->caps & ICE_AQC_PHY_EN_TX_LINK_PAUSE) {
+		ethtool_link_ksettings_add_link_mode(ks, advertising,
+						     Asym_Pause);
+	} else if (caps->caps & ICE_AQC_PHY_EN_RX_LINK_PAUSE) {
 		ethtool_link_ksettings_add_link_mode(ks, advertising, Pause);
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
 						     Asym_Pause);
-		break;
-	case ICE_FC_PFC:
-	default:
+	} else {
 		ethtool_link_ksettings_del_link_mode(ks, advertising, Pause);
 		ethtool_link_ksettings_del_link_mode(ks, advertising,
 						     Asym_Pause);
-		break;
 	}
 
-	caps = devm_kzalloc(&vsi->back->pdev->dev, sizeof(*caps), GFP_KERNEL);
-	if (!caps)
-		goto done;
-
-	if (ice_aq_get_phy_caps(vsi->port_info, false, ICE_AQC_REPORT_TOPO_CAP,
-				caps, NULL))
-		netdev_info(netdev, "Get phy capability failed.\n");
-
-	/* Set supported FEC modes based on PHY capability */
-	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_NONE);
-
-	if (caps->link_fec_options & ICE_AQC_PHY_FEC_10G_KR_40G_KR4_EN ||
-	    caps->link_fec_options & ICE_AQC_PHY_FEC_25G_KR_CLAUSE74_EN)
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_BASER);
-	if (caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN)
-		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
-
-	if (ice_aq_get_phy_caps(vsi->port_info, false, ICE_AQC_REPORT_SW_CFG,
-				caps, NULL))
-		netdev_info(netdev, "Get phy capability failed.\n");
-
 	/* Set advertised FEC modes based on PHY capability */
 	ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_NONE);
 
@@ -2178,9 +2197,25 @@ ice_get_link_ksettings(struct net_device *netdev,
 	    caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_544_REQ)
 		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
 
+	status = ice_aq_get_phy_caps(vsi->port_info, false,
+				     ICE_AQC_REPORT_TOPO_CAP, caps, NULL);
+	if (status) {
+		err = -EIO;
+		goto done;
+	}
+
+	/* Set supported FEC modes based on PHY capability */
+	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_NONE);
+
+	if (caps->link_fec_options & ICE_AQC_PHY_FEC_10G_KR_40G_KR4_EN ||
+	    caps->link_fec_options & ICE_AQC_PHY_FEC_25G_KR_CLAUSE74_EN)
+		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_BASER);
+	if (caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN)
+		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
+
 done:
 	devm_kfree(&vsi->back->pdev->dev, caps);
-	return 0;
+	return err;
 }
 
 /**
@@ -2763,6 +2798,11 @@ static int ice_nway_reset(struct net_device *netdev)
  * ice_get_pauseparam - Get Flow Control status
  * @netdev: network interface device structure
  * @pause: ethernet pause (flow control) parameters
+ *
+ * Get requested flow control status from PHY capability.
+ * If autoneg is true, then ethtool will send the ETHTOOL_GSET ioctl which
+ * is handled by ice_get_link_ksettings. ice_get_link_ksettings will report
+ * the negotiated Rx/Tx pause via lp_advertising.
  */
 static void
 ice_get_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
-- 
2.21.0

