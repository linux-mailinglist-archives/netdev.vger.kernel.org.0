Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DFD22BAF3
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgGXAWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:22:21 -0400
Received: from mga07.intel.com ([134.134.136.100]:23104 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728256AbgGXAWU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 20:22:20 -0400
IronPort-SDR: kicZCVQfp8QXkBmR/MnjU75tf3RiVoRQnBnKfwjtibPYyXFdPeBK6mBey2FxKBJyyw8cYEEEaa
 kC5F64klwHng==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="215232504"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="215232504"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 17:22:19 -0700
IronPort-SDR: U+1UzRIk02MMEm1BwjDdt8nefIeTQn9bZBHN69hlUO0wV5sN72NVby8Jid32r9Fkc/1OYNF/6U
 ogGP8kNYEMBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="272441987"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga008.fm.intel.com with ESMTP; 23 Jul 2020 17:22:19 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Tom Herbert <tom@herbertland.com>,
        Jacek Naczyk <jacek.naczyk@intel.com>
Subject: [net-next v1 2/5] ice: Add support for unified NVM update flow capability
Date:   Thu, 23 Jul 2020 17:22:00 -0700
Message-Id: <20200724002203.451621-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.rc1.139.gd6b33fda9dd1
In-Reply-To: <20200724002203.451621-1-jacob.e.keller@intel.com>
References: <20200724002203.451621-1-jacob.e.keller@intel.com>
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
index b363e0223670..b97f50e60feb 100644
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
index c72cc77b8d67..249526f217ff 100644
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
index 08c616d9fffd..8eb1f184a886 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -244,6 +244,9 @@ struct ice_hw_common_caps {
 	u8 rss_table_entry_width;	/* RSS Entry width in bits */
 
 	u8 dcb;
+
+	bool nvm_unified_update;
+#define ICE_NVM_MGMT_UNIFIED_UPD_SUPPORT	BIT(3)
 };
 
 /* Function specific capabilities */
-- 
2.28.0.rc1.139.gd6b33fda9dd1

