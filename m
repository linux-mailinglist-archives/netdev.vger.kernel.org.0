Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F280B35FEE8
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhDOA3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:29:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:27420 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231616AbhDOA25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:57 -0400
IronPort-SDR: B9MeW7akpIsm3IBwY7+NUcgDDg9lzuFiA4qrgT8gM45zXKBoKWJsnsfUY2aInvHgSOQKx8/XIh
 ciTKkGW0KAMw==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262254"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262254"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:27 -0700
IronPort-SDR: lAD3Ii9vB+e+e6rR9ZDkmS7tWm/+RLxEoHcvfES1XPxty+XajojK2UJZND48bm/5x+APkuRaec
 fVOjGbnDtPpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379541"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 13/15] ice: suppress false cppcheck issues
Date:   Wed, 14 Apr 2021 17:30:11 -0700
Message-Id: <20210415003013.19717-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Silence false errors, warnings and style issues reported by cppcheck.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 3 +++
 drivers/net/ethernet/intel/ice/ice_nvm.c       | 1 +
 drivers/net/ethernet/intel/ice/ice_sched.c     | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 4b83960876f4..06ac9badee77 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -334,6 +334,7 @@ ice_boost_tcam_handler(u32 sect_type, void *section, u32 index, u32 *offset)
 	if (sect_type != ICE_SID_RXPARSER_BOOST_TCAM)
 		return NULL;
 
+	/* cppcheck-suppress nullPointer */
 	if (index > ICE_MAX_BST_TCAMS_IN_BUF)
 		return NULL;
 
@@ -404,6 +405,7 @@ ice_label_enum_handler(u32 __always_unused sect_type, void *section, u32 index,
 	if (!section)
 		return NULL;
 
+	/* cppcheck-suppress nullPointer */
 	if (index > ICE_MAX_LABELS_IN_BUF)
 		return NULL;
 
@@ -2067,6 +2069,7 @@ ice_match_prop_lst(struct list_head *list1, struct list_head *list2)
 		count++;
 	list_for_each_entry(tmp2, list2, list)
 		chk_count++;
+	/* cppcheck-suppress knownConditionTrueFalse */
 	if (!count || count != chk_count)
 		return false;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 75ccbfc07f99..fee37a5844cf 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -644,6 +644,7 @@ ice_get_orom_civd_data(struct ice_hw *hw, enum ice_bank_select bank,
 
 		/* Verify that the simple checksum is zero */
 		for (i = 0; i < sizeof(tmp); i++)
+			/* cppcheck-suppress objectIndex */
 			sum += ((u8 *)&tmp)[i];
 
 		if (sum) {
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 97562051fe14..2f097637e405 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -988,6 +988,7 @@ ice_sched_add_nodes_to_layer(struct ice_port_info *pi,
 	*num_nodes_added = 0;
 	while (*num_nodes_added < num_nodes) {
 		u16 max_child_nodes, num_added = 0;
+		/* cppcheck-suppress unusedVariable */
 		u32 temp;
 
 		status = ice_sched_add_nodes_to_hw_layer(pi, tc_node, parent,
-- 
2.26.2

