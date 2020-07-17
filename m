Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CCA224332
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgGQSfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:35:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:34689 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgGQSfq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 14:35:46 -0400
IronPort-SDR: +qaDRoh6RBHFtX2fBQZu+eU5QB8pTDRjvqNZl4JZ9p6yfncYrmM7FCVPZQ+hqTAZo+CPhCSCs8
 Fn2Yn3bHMB+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="129736657"
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="129736657"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 11:35:45 -0700
IronPort-SDR: NKAwfi01vuHl+kWeHziyewZklh8id3wJPF/1rdpQ62uHa83QTvqRB6HbB4ZkxjB7XQ6wviRUJf
 cWa+6vR8Mk8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="486542501"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jul 2020 11:35:44 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Tom Herbert <tom@herbertland.com>,
        Jacek Naczyk <jacek.naczyk@intel.com>
Subject: [RFC PATCH net-next v2 1/6] ice: Add support for unified NVM update flow capability
Date:   Fri, 17 Jul 2020 11:35:36 -0700
Message-Id: <20200717183541.797878-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.27.0.353.gb9a2d1a0207f
In-Reply-To: <20200717183541.797878-1-jacob.e.keller@intel.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
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
index 63cff81d234f..ffa7490b5789 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1855,6 +1855,13 @@ ice_parse_common_caps(struct ice_hw *hw, struct ice_hw_common_caps *caps,
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
index 1fe8b0cbf064..f91b6d944b63 100644
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

