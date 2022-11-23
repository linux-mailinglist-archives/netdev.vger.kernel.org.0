Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7356E636E19
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiKWXGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiKWXGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:06:36 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E588152DF1
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 15:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669244792; x=1700780792;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dbEDTH6e3RIvNJHn015uQlRvX/v5eJCz8hriLbHj3mM=;
  b=JFb4T+3MsyIGzzTtZGA0tHB43coKDPnkqRLXQC3kX+duo+Rhu10T5Hjy
   2JAdo4HSFTDMQkyT/ftR9yNpqxNlr2b95guJKzvn7Wd/HxbbSiqTcA8Gn
   a2sHD6F+4G2D186tujOYg9hz1IGEDYC9hI9f+IeNCL6dSLg16xnGJ09Fj
   TWq6q60mJzJaNCordJz9V5usG+Tg+4QULDdVrAWJcbHVHin+yc8+shFlY
   EelQfIFtOKYIVNy1vvW8UMBkVVslGOdpf1XA8nU7pKJRiWWln5Wy9PVBl
   gGD64pHoZelFTN9cNkxPbRrTZiBN+CJYMWvY+2k3kWI0WUo79JW88YjGh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="376318627"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="376318627"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:06:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="705531268"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="705531268"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 23 Nov 2022 15:06:29 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v3 2/6] ice: Remove and replace ice speed defines with ethtool.h versions
Date:   Wed, 23 Nov 2022 15:06:17 -0800
Message-Id: <20221123230621.3562805-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123230621.3562805-1-anthony.l.nguyen@intel.com>
References: <20221123230621.3562805-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

The driver is currently using ICE_LINK_SPEED_* defines that mirror what
ethtool.h defines, with one exception ICE_LINK_SPEED_UNKNOWN.

This issue is fixed by the following changes:

1. replace ICE_LINK_SPEED_UNKNOWN with 0 because SPEED_UNKNOWN in
   ethtool.h is "-1" and that doesn't match the driver's expected behavior
2. transform ICE_LINK_SPEED_*MBPS to SPEED_* using static tables and
   fls()-1 to convert from BIT() to an index in a table.

Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Co-developed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
bloat-o-meter results of change:
add/remove: 3/0 grow/shrink: 2/3 up/down: 158/-652 (-494)
Function                                     old     new   delta
ice_legacy_aq_to_vc_speed                      -      60     +60
ice_aq_to_link_speed                           -      60     +60
ice_get_link_speed                             -      20     +20
ice_set_min_bw_limit                         329     338      +9
ice_set_max_bw_limit                         334     343      +9
ice_get_link_speed_kbps                      195      40    -155
ice_get_link_speed_mbps                      195      29    -166
ice_conv_link_speed_to_virtchnl              382      51    -331
Total: Before=536449, After=535955, chg -0.09%

 drivers/net/ethernet/intel/ice/ice_common.c   | 41 ++++++++-
 drivers/net/ethernet/intel/ice/ice_common.h   |  1 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    | 12 ---
 drivers/net/ethernet/intel/ice/ice_lib.c      | 32 +------
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c   | 92 +++++--------------
 5 files changed, 69 insertions(+), 109 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 216370ec60d4..d02b55b6aa9c 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2948,8 +2948,8 @@ bool ice_is_100m_speed_supported(struct ice_hw *hw)
  * Note: In the structure of [phy_type_low, phy_type_high], there should
  * be one bit set, as this function will convert one PHY type to its
  * speed.
- * If no bit gets set, ICE_LINK_SPEED_UNKNOWN will be returned
- * If more than one bit gets set, ICE_LINK_SPEED_UNKNOWN will be returned
+ * If no bit gets set, ICE_AQ_LINK_SPEED_UNKNOWN will be returned
+ * If more than one bit gets set, ICE_AQ_LINK_SPEED_UNKNOWN will be returned
  */
 static u16
 ice_get_link_speed_based_on_phy_type(u64 phy_type_low, u64 phy_type_high)
@@ -5515,3 +5515,40 @@ bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw)
 				     ICE_FW_API_REPORT_DFLT_CFG_MIN,
 				     ICE_FW_API_REPORT_DFLT_CFG_PATCH);
 }
+
+/* each of the indexes into the following array match the speed of a return
+ * value from the list of AQ returned speeds like the range:
+ * ICE_AQ_LINK_SPEED_10MB .. ICE_AQ_LINK_SPEED_100GB excluding
+ * ICE_AQ_LINK_SPEED_UNKNOWN which is BIT(15) and maps to BIT(14) in this
+ * array. The array is defined as 15 elements long because the link_speed
+ * returned by the firmware is a 16 bit * value, but is indexed
+ * by [fls(speed) - 1]
+ */
+static const u32 ice_aq_to_link_speed[15] = {
+	SPEED_10,	/* BIT(0) */
+	SPEED_100,
+	SPEED_1000,
+	SPEED_2500,
+	SPEED_5000,
+	SPEED_10000,
+	SPEED_20000,
+	SPEED_25000,
+	SPEED_40000,
+	SPEED_50000,
+	SPEED_100000,	/* BIT(10) */
+	0,
+	0,
+	0,
+	0		/* BIT(14) */
+};
+
+/**
+ * ice_get_link_speed - get integer speed from table
+ * @index: array index from fls(aq speed) - 1
+ *
+ * Returns: u32 value containing integer speed
+ */
+u32 ice_get_link_speed(u16 index)
+{
+	return ice_aq_to_link_speed[index];
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 8b6712b92e84..4c6a0b5c9304 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -163,6 +163,7 @@ int
 ice_aq_sff_eeprom(struct ice_hw *hw, u16 lport, u8 bus_addr,
 		  u16 mem_addr, u8 page, u8 set_page, u8 *data, u8 length,
 		  bool write, struct ice_sq_cd *cd);
+u32 ice_get_link_speed(u16 index);
 
 int
 ice_cfg_vsi_rdma(struct ice_port_info *pi, u16 vsi_handle, u16 tc_bitmap,
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index b3baf7c3f910..89f986a75cc8 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -908,17 +908,5 @@ static inline struct ice_rx_ptype_decoded ice_decode_rx_desc_ptype(u16 ptype)
 	return ice_ptype_lkup[ptype];
 }
 
-#define ICE_LINK_SPEED_UNKNOWN		0
-#define ICE_LINK_SPEED_10MBPS		10
-#define ICE_LINK_SPEED_100MBPS		100
-#define ICE_LINK_SPEED_1000MBPS		1000
-#define ICE_LINK_SPEED_2500MBPS		2500
-#define ICE_LINK_SPEED_5000MBPS		5000
-#define ICE_LINK_SPEED_10000MBPS	10000
-#define ICE_LINK_SPEED_20000MBPS	20000
-#define ICE_LINK_SPEED_25000MBPS	25000
-#define ICE_LINK_SPEED_40000MBPS	40000
-#define ICE_LINK_SPEED_50000MBPS	50000
-#define ICE_LINK_SPEED_100000MBPS	100000
 
 #endif /* _ICE_LAN_TX_RX_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 7276badfa19e..a2cfa0c614ce 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3850,33 +3850,11 @@ int ice_clear_dflt_vsi(struct ice_vsi *vsi)
  */
 int ice_get_link_speed_mbps(struct ice_vsi *vsi)
 {
-	switch (vsi->port_info->phy.link_info.link_speed) {
-	case ICE_AQ_LINK_SPEED_100GB:
-		return SPEED_100000;
-	case ICE_AQ_LINK_SPEED_50GB:
-		return SPEED_50000;
-	case ICE_AQ_LINK_SPEED_40GB:
-		return SPEED_40000;
-	case ICE_AQ_LINK_SPEED_25GB:
-		return SPEED_25000;
-	case ICE_AQ_LINK_SPEED_20GB:
-		return SPEED_20000;
-	case ICE_AQ_LINK_SPEED_10GB:
-		return SPEED_10000;
-	case ICE_AQ_LINK_SPEED_5GB:
-		return SPEED_5000;
-	case ICE_AQ_LINK_SPEED_2500MB:
-		return SPEED_2500;
-	case ICE_AQ_LINK_SPEED_1000MB:
-		return SPEED_1000;
-	case ICE_AQ_LINK_SPEED_100MB:
-		return SPEED_100;
-	case ICE_AQ_LINK_SPEED_10MB:
-		return SPEED_10;
-	case ICE_AQ_LINK_SPEED_UNKNOWN:
-	default:
-		return 0;
-	}
+	unsigned int link_speed;
+
+	link_speed = vsi->port_info->phy.link_info.link_speed;
+
+	return (int)ice_get_link_speed(fls(link_speed) - 1);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
index fc8c93fa4455..d4a4001b6e5d 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
@@ -39,6 +39,24 @@ ice_aq_send_msg_to_vf(struct ice_hw *hw, u16 vfid, u32 v_opcode, u32 v_retval,
 	return ice_sq_send_cmd(hw, &hw->mailboxq, &desc, msg, msglen, cd);
 }
 
+static const u32 ice_legacy_aq_to_vc_speed[15] = {
+	VIRTCHNL_LINK_SPEED_100MB,	/* BIT(0) */
+	VIRTCHNL_LINK_SPEED_100MB,
+	VIRTCHNL_LINK_SPEED_1GB,
+	VIRTCHNL_LINK_SPEED_1GB,
+	VIRTCHNL_LINK_SPEED_1GB,
+	VIRTCHNL_LINK_SPEED_10GB,
+	VIRTCHNL_LINK_SPEED_20GB,
+	VIRTCHNL_LINK_SPEED_25GB,
+	VIRTCHNL_LINK_SPEED_40GB,
+	VIRTCHNL_LINK_SPEED_40GB,
+	VIRTCHNL_LINK_SPEED_40GB,
+	VIRTCHNL_LINK_SPEED_UNKNOWN,
+	VIRTCHNL_LINK_SPEED_UNKNOWN,
+	VIRTCHNL_LINK_SPEED_UNKNOWN,
+	VIRTCHNL_LINK_SPEED_UNKNOWN	/* BIT(14) */
+};
+
 /**
  * ice_conv_link_speed_to_virtchnl
  * @adv_link_support: determines the format of the returned link speed
@@ -55,79 +73,17 @@ u32 ice_conv_link_speed_to_virtchnl(bool adv_link_support, u16 link_speed)
 {
 	u32 speed;
 
-	if (adv_link_support)
-		switch (link_speed) {
-		case ICE_AQ_LINK_SPEED_10MB:
-			speed = ICE_LINK_SPEED_10MBPS;
-			break;
-		case ICE_AQ_LINK_SPEED_100MB:
-			speed = ICE_LINK_SPEED_100MBPS;
-			break;
-		case ICE_AQ_LINK_SPEED_1000MB:
-			speed = ICE_LINK_SPEED_1000MBPS;
-			break;
-		case ICE_AQ_LINK_SPEED_2500MB:
-			speed = ICE_LINK_SPEED_2500MBPS;
-			break;
-		case ICE_AQ_LINK_SPEED_5GB:
-			speed = ICE_LINK_SPEED_5000MBPS;
-			break;
-		case ICE_AQ_LINK_SPEED_10GB:
-			speed = ICE_LINK_SPEED_10000MBPS;
-			break;
-		case ICE_AQ_LINK_SPEED_20GB:
-			speed = ICE_LINK_SPEED_20000MBPS;
-			break;
-		case ICE_AQ_LINK_SPEED_25GB:
-			speed = ICE_LINK_SPEED_25000MBPS;
-			break;
-		case ICE_AQ_LINK_SPEED_40GB:
-			speed = ICE_LINK_SPEED_40000MBPS;
-			break;
-		case ICE_AQ_LINK_SPEED_50GB:
-			speed = ICE_LINK_SPEED_50000MBPS;
-			break;
-		case ICE_AQ_LINK_SPEED_100GB:
-			speed = ICE_LINK_SPEED_100000MBPS;
-			break;
-		default:
-			speed = ICE_LINK_SPEED_UNKNOWN;
-			break;
-		}
-	else
+	if (adv_link_support) {
+		/* convert a BIT() value into an array index */
+		speed = ice_get_link_speed(fls(link_speed) - 1);
+	} else {
 		/* Virtchnl speeds are not defined for every speed supported in
 		 * the hardware. To maintain compatibility with older AVF
 		 * drivers, while reporting the speed the new speed values are
 		 * resolved to the closest known virtchnl speeds
 		 */
-		switch (link_speed) {
-		case ICE_AQ_LINK_SPEED_10MB:
-		case ICE_AQ_LINK_SPEED_100MB:
-			speed = (u32)VIRTCHNL_LINK_SPEED_100MB;
-			break;
-		case ICE_AQ_LINK_SPEED_1000MB:
-		case ICE_AQ_LINK_SPEED_2500MB:
-		case ICE_AQ_LINK_SPEED_5GB:
-			speed = (u32)VIRTCHNL_LINK_SPEED_1GB;
-			break;
-		case ICE_AQ_LINK_SPEED_10GB:
-			speed = (u32)VIRTCHNL_LINK_SPEED_10GB;
-			break;
-		case ICE_AQ_LINK_SPEED_20GB:
-			speed = (u32)VIRTCHNL_LINK_SPEED_20GB;
-			break;
-		case ICE_AQ_LINK_SPEED_25GB:
-			speed = (u32)VIRTCHNL_LINK_SPEED_25GB;
-			break;
-		case ICE_AQ_LINK_SPEED_40GB:
-		case ICE_AQ_LINK_SPEED_50GB:
-		case ICE_AQ_LINK_SPEED_100GB:
-			speed = (u32)VIRTCHNL_LINK_SPEED_40GB;
-			break;
-		default:
-			speed = (u32)VIRTCHNL_LINK_SPEED_UNKNOWN;
-			break;
-		}
+		speed = ice_legacy_aq_to_vc_speed[fls(link_speed) - 1];
+	}
 
 	return speed;
 }
-- 
2.35.1

