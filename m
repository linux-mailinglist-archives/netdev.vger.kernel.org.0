Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF16286B5C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 01:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgJGXLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 19:11:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:53903 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbgJGXLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 19:11:06 -0400
IronPort-SDR: GnwvP8h0BfwL4+Pg4GxHKiWjrbpRfmn/4OomBw4Hh4gginrH1RnI3/tj8AaI0wl1h1Aj1BFioB
 J9B5Y99TLFFQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="249880364"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="249880364"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 16:11:05 -0700
IronPort-SDR: vRF8Idd7CzFcD7ib+ljRj4750pjgAZ2D8w2TxS0vupoLtwPHT/OrNQKidO0TrGBtlyeFaRB+SQ
 fcwJ8g/A5fmQ==
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="461557632"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 16:11:05 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jaroslaw Gawin <jaroslawx.gawin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 1/3] i40e: Allow changing FEC settings on X722 if supported by FW
Date:   Wed,  7 Oct 2020 16:10:48 -0700
Message-Id: <20201007231050.1438704-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007231050.1438704-1-anthony.l.nguyen@intel.com>
References: <20201007231050.1438704-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jaroslaw Gawin <jaroslawx.gawin@intel.com>

Starting with API version 1.10 firmware for X722 devices has ability
to change FEC settings in PHY. Code added in this patch allows
changing FEC settings if the capability flag indicates the device
supports this feature.

Signed-off-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  6 +++++
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  2 ++
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 22 ++++++++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 19 ++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  1 +
 5 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index c897a2863e4f..593912b17609 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -541,6 +541,12 @@ static void i40e_set_hw_flags(struct i40e_hw *hw)
 		    (aq->api_maj_ver == 1 &&
 		     aq->api_min_ver >= I40E_MINOR_VER_GET_LINK_INFO_X722))
 			hw->flags |= I40E_HW_FLAG_AQ_PHY_ACCESS_CAPABLE;
+
+		if (aq->api_maj_ver > 1 ||
+		    (aq->api_maj_ver == 1 &&
+		     aq->api_min_ver >= I40E_MINOR_VER_FW_REQUEST_FEC_X722))
+			hw->flags |= I40E_HW_FLAG_X722_FEC_REQUEST_CAPABLE;
+
 		fallthrough;
 	default:
 		break;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index c0c8efe42fce..1e960c3c7ef0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -24,6 +24,8 @@
 #define I40E_MINOR_VER_GET_LINK_INFO_X722 0x0009
 /* API version 1.6 for X722 devices adds ability to stop FW LLDP agent */
 #define I40E_MINOR_VER_FW_LLDP_STOPPABLE_X722 0x0006
+/* API version 1.10 for X722 devices adds ability to request FEC encoding */
+#define I40E_MINOR_VER_FW_REQUEST_FEC_X722 0x000A
 
 struct i40e_aq_desc {
 	__le16 flags;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index dc1577156bb6..b29447c0f549 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -891,6 +891,7 @@ static void i40e_get_settings_link_up(struct i40e_hw *hw,
 		if (hw_link_info->requested_speeds & I40E_LINK_SPEED_10GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     10000baseT_Full);
+		i40e_get_settings_link_up_fec(hw_link_info->req_fec_info, ks);
 		break;
 	case I40E_PHY_TYPE_SGMII:
 		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
@@ -1484,11 +1485,18 @@ static int i40e_set_fec_param(struct net_device *netdev,
 	int err = 0;
 
 	if (hw->device_id != I40E_DEV_ID_25G_SFP28 &&
-	    hw->device_id != I40E_DEV_ID_25G_B) {
+	    hw->device_id != I40E_DEV_ID_25G_B &&
+	    hw->device_id != I40E_DEV_ID_KX_X722) {
 		err = -EPERM;
 		goto done;
 	}
 
+	if (hw->mac.type == I40E_MAC_X722 &&
+	    !(hw->flags & I40E_HW_FLAG_X722_FEC_REQUEST_CAPABLE)) {
+		netdev_err(netdev, "Setting FEC encoding not supported by firmware. Please update the NVM image.\n");
+		return -EINVAL;
+	}
+
 	switch (fecparam->fec) {
 	case ETHTOOL_FEC_AUTO:
 		fec_cfg = I40E_AQ_SET_FEC_AUTO;
@@ -4951,8 +4959,7 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 		}
 	}
 
-	if (((changed_flags & I40E_FLAG_RS_FEC) ||
-	     (changed_flags & I40E_FLAG_BASE_R_FEC)) &&
+	if (changed_flags & I40E_FLAG_RS_FEC &&
 	    pf->hw.device_id != I40E_DEV_ID_25G_SFP28 &&
 	    pf->hw.device_id != I40E_DEV_ID_25G_B) {
 		dev_warn(&pf->pdev->dev,
@@ -4960,6 +4967,15 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 		return -EOPNOTSUPP;
 	}
 
+	if (changed_flags & I40E_FLAG_BASE_R_FEC &&
+	    pf->hw.device_id != I40E_DEV_ID_25G_SFP28 &&
+	    pf->hw.device_id != I40E_DEV_ID_25G_B &&
+	    pf->hw.device_id != I40E_DEV_ID_KX_X722) {
+		dev_warn(&pf->pdev->dev,
+			 "Device does not support changing FEC configuration\n");
+		return -EOPNOTSUPP;
+	}
+
 	/* Process any additional changes needed as a result of flag changes.
 	 * The changed_flags value reflects the list of bits that were
 	 * changed in the code above.
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 929c64789119..4f8a2154b93f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6622,6 +6622,25 @@ void i40e_print_link_message(struct i40e_vsi *vsi, bool isup)
 			else
 				req_fec = "CL74 FC-FEC/BASE-R";
 		}
+		netdev_info(vsi->netdev,
+			    "NIC Link is Up, %sbps Full Duplex, Requested FEC: %s, Negotiated FEC: %s, Autoneg: %s, Flow Control: %s\n",
+			    speed, req_fec, fec, an, fc);
+	} else if (pf->hw.device_id == I40E_DEV_ID_KX_X722) {
+		req_fec = "None";
+		fec = "None";
+		an = "False";
+
+		if (pf->hw.phy.link_info.an_info & I40E_AQ_AN_COMPLETED)
+			an = "True";
+
+		if (pf->hw.phy.link_info.fec_info &
+		    I40E_AQ_CONFIG_FEC_KR_ENA)
+			fec = "CL74 FC-FEC/BASE-R";
+
+		if (pf->hw.phy.link_info.req_fec_info &
+		    I40E_AQ_REQUEST_FEC_KR)
+			req_fec = "CL74 FC-FEC/BASE-R";
+
 		netdev_info(vsi->netdev,
 			    "NIC Link is Up, %sbps Full Duplex, Requested FEC: %s, Negotiated FEC: %s, Autoneg: %s, Flow Control: %s\n",
 			    speed, req_fec, fec, an, fc);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 97d29df65f9e..c0bdc666f557 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -595,6 +595,7 @@ struct i40e_hw {
 #define I40E_HW_FLAG_FW_LLDP_PERSISTENT     BIT_ULL(5)
 #define I40E_HW_FLAG_AQ_PHY_ACCESS_EXTENDED BIT_ULL(6)
 #define I40E_HW_FLAG_DROP_MODE              BIT_ULL(7)
+#define I40E_HW_FLAG_X722_FEC_REQUEST_CAPABLE BIT_ULL(8)
 	u64 flags;
 
 	/* Used in set switch config AQ command */
-- 
2.26.2

