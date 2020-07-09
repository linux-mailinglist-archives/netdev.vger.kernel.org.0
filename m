Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AAB21A9B7
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 23:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgGIV1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 17:27:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:49964 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgGIV06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 17:26:58 -0400
IronPort-SDR: dTjE5BcwtOf1pu75+p5iJbgYFSGOhLKq3whcAFzoqPNE296toDt54zT3A+mueMKFauDowG78tz
 Mwf+x3Aq6mvw==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="147202446"
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="147202446"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 14:26:54 -0700
IronPort-SDR: lidt9z6oPXzhfu70zrtoa6CE2UNd+AeoFuqkQw9bKMkU9v3ZwoVjntjUheKtDMWMmjW5f0IZ1x
 1mG7NX05CECA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="284293640"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by orsmga006.jf.intel.com with ESMTP; 09 Jul 2020 14:26:53 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>,
        Jacek Naczyk <jacek.naczyk@intel.com>
Subject: [RFC PATCH net-next 1/6] ice: Add support for unified NVM update flow capability
Date:   Thu,  9 Jul 2020 14:26:47 -0700
Message-Id: <20200709212652.2785924-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.27.0.353.gb9a2d1a0207f
In-Reply-To: <20200709212652.2785924-1-jacob.e.keller@intel.com>
References: <20200709212652.2785924-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacek Naczyk <jacek.naczyk@intel.com>

Extends function parsing response from Discover Device
Capability AQC to check if the device supports unified NVM update flow.

Signed-off-by: Jacek Naczyk <jacek.naczyk@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 1 +
 drivers/net/ethernet/intel/ice/ice_common.c     | 7 +++++++
 drivers/net/ethernet/intel/ice/ice_type.h       | 3 +++
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index d1640ff2aea9..59d3bbcf692e 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -109,6 +109,7 @@ struct ice_aqc_list_caps_elem {
 #define ICE_AQC_CAPS_MSIX				0x0043
 #define ICE_AQC_CAPS_FD					0x0045
 #define ICE_AQC_CAPS_MAX_MTU				0x0047
+#define ICE_AQC_CAPS_NVM_MGMT				0x0080
 
 	u8 major_ver;
 	u8 minor_ver;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 4579939073c3..dcfb75c10944 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1857,6 +1857,13 @@ ice_parse_common_caps(struct ice_hw *hw, struct ice_hw_common_caps *caps,
 			  "%s: msix_vector_first_id = %d\n", prefix,
 			  caps->msix_vector_first_id);
 		break;
+	case ICE_AQC_CAPS_NVM_MGMT:
+		caps->nvm_unified_update =
+			(number & ICE_NVM_MGMT_UNIFIED_UPD_SUPPORT) ?
+			true : false;
+		ice_debug(hw, ICE_DBG_INIT, "%s: nvm_unified_update = %d\n", prefix,
+			  caps->nvm_unified_update);
+		break;
 	case ICE_AQC_CAPS_MAX_MTU:
 		caps->max_mtu = number;
 		ice_debug(hw, ICE_DBG_INIT, "%s: max_mtu = %d\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index bf31ccf01100..40e013c65150 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -262,6 +262,9 @@ struct ice_hw_common_caps {
 	u8 rss_table_entry_width;	/* RSS Entry width in bits */
 
 	u8 dcb;
+
+	bool nvm_unified_update;
+#define ICE_NVM_MGMT_UNIFIED_UPD_SUPPORT	BIT(3)
 };
 
 /* Function specific capabilities */
-- 
2.27.0.353.gb9a2d1a0207f

