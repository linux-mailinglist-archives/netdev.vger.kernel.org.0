Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6ABD22BA5B
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgGWXrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:43322 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbgGWXrh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:37 -0400
IronPort-SDR: pds1+GEHSRq863iRQrR0GfrwpcK0epmU9Ml1gte9SWe6hvEX+D9V1ZCwwd4z4urBAFd+cTayS4
 Kk05uMY2SOQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="235515441"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="235515441"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:27 -0700
IronPort-SDR: AZaOHbrxqpsM5tI0PtWCXJTFIQBbLGcv6rmgmPf8UVWjthWKHuQjHJZyBG53XdroyA4UmIy8Sr
 57GyxIgmHlZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742323"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 15/15] ice: add 1G SGMII PHY type
Date:   Thu, 23 Jul 2020 16:47:20 -0700
Message-Id: <20200723234720.1547308-16-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
References: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

There isn't a case for 1G SGMII in ice_get_media_type() so add
the handling for it.

Also handle the special case where some direct attach
cables may report that they support 1G SGMII, but
that is erroneous since SGMII is supposed to be a
backplane media type (between a MAC and a PHY). If
the driver doesn't handle this special case then a
user could see the 'Port' in ethtool change from
'Direct attach Copper' to 'Backplane' when they have
forced the speed to 1G, but the cable hasn't changed.

Lastly, change ice_aq_get_phy_caps() to save the
module_type info if the function was called with
ICE_AQC_REPORT_TOPO_CAP. This call uses the media
information to populate the module_type. If no
media is present then the values in module_type
will be 0.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h |  1 +
 drivers/net/ethernet/intel/ice/ice_common.c     | 17 ++++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 4315a784b975..b363e0223670 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -993,6 +993,7 @@ struct ice_aqc_get_phy_caps_data {
 	u8 module_type[ICE_MODULE_TYPE_TOTAL_BYTE];
 #define ICE_AQC_MOD_TYPE_BYTE0_SFP_PLUS			0xA0
 #define ICE_AQC_MOD_TYPE_BYTE0_QSFP_PLUS		0x80
+#define ICE_AQC_MOD_TYPE_IDENT				1
 #define ICE_AQC_MOD_TYPE_BYTE1_SFP_PLUS_CU_PASSIVE	BIT(0)
 #define ICE_AQC_MOD_TYPE_BYTE1_SFP_PLUS_CU_ACTIVE	BIT(1)
 #define ICE_AQC_MOD_TYPE_BYTE1_10G_BASE_SR		BIT(4)
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index bb9952038efa..c72cc77b8d67 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -194,6 +194,8 @@ ice_aq_get_phy_caps(struct ice_port_info *pi, bool qual_mods, u8 report_mode,
 	if (!status && report_mode == ICE_AQC_REPORT_TOPO_CAP) {
 		pi->phy.phy_type_low = le64_to_cpu(pcaps->phy_type_low);
 		pi->phy.phy_type_high = le64_to_cpu(pcaps->phy_type_high);
+		memcpy(pi->phy.link_info.module_type, &pcaps->module_type,
+		       sizeof(pi->phy.link_info.module_type));
 	}
 
 	return status;
@@ -266,6 +268,18 @@ static enum ice_media_type ice_get_media_type(struct ice_port_info *pi)
 		return ICE_MEDIA_UNKNOWN;
 
 	if (hw_link_info->phy_type_low) {
+		/* 1G SGMII is a special case where some DA cable PHYs
+		 * may show this as an option when it really shouldn't
+		 * be since SGMII is meant to be between a MAC and a PHY
+		 * in a backplane. Try to detect this case and handle it
+		 */
+		if (hw_link_info->phy_type_low == ICE_PHY_TYPE_LOW_1G_SGMII &&
+		    (hw_link_info->module_type[ICE_AQC_MOD_TYPE_IDENT] ==
+		    ICE_AQC_MOD_TYPE_BYTE1_SFP_PLUS_CU_ACTIVE ||
+		    hw_link_info->module_type[ICE_AQC_MOD_TYPE_IDENT] ==
+		    ICE_AQC_MOD_TYPE_BYTE1_SFP_PLUS_CU_PASSIVE))
+			return ICE_MEDIA_DA;
+
 		switch (hw_link_info->phy_type_low) {
 		case ICE_PHY_TYPE_LOW_1000BASE_SX:
 		case ICE_PHY_TYPE_LOW_1000BASE_LX:
@@ -2647,9 +2661,6 @@ enum ice_status ice_update_link_info(struct ice_port_info *pi)
 
 		status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP,
 					     pcaps, NULL);
-		if (!status)
-			memcpy(li->module_type, &pcaps->module_type,
-			       sizeof(li->module_type));
 
 		devm_kfree(ice_hw_to_dev(hw), pcaps);
 	}
-- 
2.26.2

