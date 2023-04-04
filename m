Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FCB6D6A9C
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 19:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbjDDRb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 13:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236083AbjDDRbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 13:31:03 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9246E6A57
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 10:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680629382; x=1712165382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=siyP84gTlYqVwOsdjVtq7BYtlGS1ByNmP2wTA5UGlek=;
  b=KWlvbHUTrjc6nCvSWVo545ZSfJd74h7Vg1tYNKpaP6+bzv+bcn2X7qkX
   dsw1rPDeSoIStdPgxEq3q5NlWdR54E/zzrkB3MZTSUNG3bc+LUaYnxNZA
   r+KECB8JWAfYM+LEBDHgv3qhssQM/NOKWHV8FLJPqmukF4+kXBluzK42Q
   0sOSrtkEgVSdt3NJmKePQcaLBDiWN5PVRKQoc8dA1gwks724rxHhIxgXi
   ZZWGd9AtTxnBcCdsOa6qU7UdOTRLGFfqCPZ1oHHQI8u71OHjKRnhUrS0V
   yC8MeCcqbh8xhe9ochx8AZow9hHjEf4htBpeCUKqn1VLtQHLW2qHIW6L1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="326283275"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="326283275"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 10:27:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="750997262"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="750997262"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 04 Apr 2023 10:27:45 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Ahmed Zaki <ahmed.zaki@intel.com>, anthony.l.nguyen@intel.com,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net 1/2] iavf: refactor VLAN filter states
Date:   Tue,  4 Apr 2023 10:25:21 -0700
Message-Id: <20230404172523.451026-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230404172523.451026-1-anthony.l.nguyen@intel.com>
References: <20230404172523.451026-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ahmed Zaki <ahmed.zaki@intel.com>

The VLAN filter states are currently being saved as individual bits.
This is error prone as multiple bits might be mistakenly set.

Fix by replacing the bits with a single state enum. Also, add an
"ACTIVE" state for filters that are accepted by the PF.

Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        | 15 +++++----
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  8 ++---
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 31 +++++++++----------
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 232bc61d9eee..dd3b1c0fec4e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -158,15 +158,18 @@ struct iavf_vlan {
 	u16 tpid;
 };
 
+enum iavf_vlan_state_t {
+	__IAVF_VLAN_INVALID,
+	__IAVF_VLAN_ADD,	/* filter needs to be added */
+	__IAVF_VLAN_IS_NEW,	/* filter is new, wait for PF answer */
+	__IAVF_VLAN_ACTIVE,	/* filter is accepted by PF */
+	__IAVF_VLAN_REMOVE,	/* filter needs to be removed */
+};
+
 struct iavf_vlan_filter {
 	struct list_head list;
 	struct iavf_vlan vlan;
-	struct {
-		u8 is_new_vlan:1;	/* filter is new, wait for PF answer */
-		u8 remove:1;		/* filter needs to be removed */
-		u8 add:1;		/* filter needs to be added */
-		u8 padding:5;
-	};
+	enum iavf_vlan_state_t state;
 };
 
 #define IAVF_MAX_TRAFFIC_CLASS	4
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 095201e83c9d..5e3429677daa 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -791,7 +791,7 @@ iavf_vlan_filter *iavf_add_vlan(struct iavf_adapter *adapter,
 		f->vlan = vlan;
 
 		list_add_tail(&f->list, &adapter->vlan_filter_list);
-		f->add = true;
+		f->state = __IAVF_VLAN_ADD;
 		adapter->aq_required |= IAVF_FLAG_AQ_ADD_VLAN_FILTER;
 	}
 
@@ -813,7 +813,7 @@ static void iavf_del_vlan(struct iavf_adapter *adapter, struct iavf_vlan vlan)
 
 	f = iavf_find_vlan(adapter, vlan);
 	if (f) {
-		f->remove = true;
+		f->state = __IAVF_VLAN_REMOVE;
 		adapter->aq_required |= IAVF_FLAG_AQ_DEL_VLAN_FILTER;
 	}
 
@@ -1296,11 +1296,11 @@ static void iavf_clear_mac_vlan_filters(struct iavf_adapter *adapter)
 	/* remove all VLAN filters */
 	list_for_each_entry_safe(vlf, vlftmp, &adapter->vlan_filter_list,
 				 list) {
-		if (vlf->add) {
+		if (vlf->state == __IAVF_VLAN_ADD) {
 			list_del(&vlf->list);
 			kfree(vlf);
 		} else {
-			vlf->remove = true;
+			vlf->state = __IAVF_VLAN_REMOVE;
 		}
 	}
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 4e17d006c52d..9ba83f0d212e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -642,7 +642,7 @@ static void iavf_vlan_add_reject(struct iavf_adapter *adapter)
 
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 	list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
-		if (f->is_new_vlan) {
+		if (f->state == __IAVF_VLAN_IS_NEW) {
 			if (f->vlan.tpid == ETH_P_8021Q)
 				clear_bit(f->vlan.vid,
 					  adapter->vsi.active_cvlans);
@@ -679,7 +679,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 
 	list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-		if (f->add)
+		if (f->state == __IAVF_VLAN_ADD)
 			count++;
 	}
 	if (!count || !VLAN_FILTERING_ALLOWED(adapter)) {
@@ -710,11 +710,10 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 		vvfl->vsi_id = adapter->vsi_res->vsi_id;
 		vvfl->num_elements = count;
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-			if (f->add) {
+			if (f->state == __IAVF_VLAN_ADD) {
 				vvfl->vlan_id[i] = f->vlan.vid;
 				i++;
-				f->add = false;
-				f->is_new_vlan = true;
+				f->state = __IAVF_VLAN_IS_NEW;
 				if (i == count)
 					break;
 			}
@@ -760,7 +759,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 		vvfl_v2->vport_id = adapter->vsi_res->vsi_id;
 		vvfl_v2->num_elements = count;
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-			if (f->add) {
+			if (f->state == __IAVF_VLAN_ADD) {
 				struct virtchnl_vlan_supported_caps *filtering_support =
 					&adapter->vlan_v2_caps.filtering.filtering_support;
 				struct virtchnl_vlan *vlan;
@@ -778,8 +777,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 				vlan->tpid = f->vlan.tpid;
 
 				i++;
-				f->add = false;
-				f->is_new_vlan = true;
+				f->state = __IAVF_VLAN_IS_NEW;
 			}
 		}
 
@@ -822,10 +820,11 @@ void iavf_del_vlans(struct iavf_adapter *adapter)
 		 * filters marked for removal to enable bailing out before
 		 * sending a virtchnl message
 		 */
-		if (f->remove && !VLAN_FILTERING_ALLOWED(adapter)) {
+		if (f->state == __IAVF_VLAN_REMOVE &&
+		    !VLAN_FILTERING_ALLOWED(adapter)) {
 			list_del(&f->list);
 			kfree(f);
-		} else if (f->remove) {
+		} else if (f->state == __IAVF_VLAN_REMOVE) {
 			count++;
 		}
 	}
@@ -857,7 +856,7 @@ void iavf_del_vlans(struct iavf_adapter *adapter)
 		vvfl->vsi_id = adapter->vsi_res->vsi_id;
 		vvfl->num_elements = count;
 		list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
-			if (f->remove) {
+			if (f->state == __IAVF_VLAN_REMOVE) {
 				vvfl->vlan_id[i] = f->vlan.vid;
 				i++;
 				list_del(&f->list);
@@ -901,7 +900,7 @@ void iavf_del_vlans(struct iavf_adapter *adapter)
 		vvfl_v2->vport_id = adapter->vsi_res->vsi_id;
 		vvfl_v2->num_elements = count;
 		list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
-			if (f->remove) {
+			if (f->state == __IAVF_VLAN_REMOVE) {
 				struct virtchnl_vlan_supported_caps *filtering_support =
 					&adapter->vlan_v2_caps.filtering.filtering_support;
 				struct virtchnl_vlan *vlan;
@@ -2192,7 +2191,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 				list_for_each_entry(vlf,
 						    &adapter->vlan_filter_list,
 						    list)
-					vlf->add = true;
+					vlf->state = __IAVF_VLAN_ADD;
 
 				adapter->aq_required |=
 					IAVF_FLAG_AQ_ADD_VLAN_FILTER;
@@ -2260,7 +2259,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 				list_for_each_entry(vlf,
 						    &adapter->vlan_filter_list,
 						    list)
-					vlf->add = true;
+					vlf->state = __IAVF_VLAN_ADD;
 
 				aq_required |= IAVF_FLAG_AQ_ADD_VLAN_FILTER;
 			}
@@ -2444,8 +2443,8 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 
 		spin_lock_bh(&adapter->mac_vlan_list_lock);
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-			if (f->is_new_vlan) {
-				f->is_new_vlan = false;
+			if (f->state == __IAVF_VLAN_IS_NEW) {
+				f->state = __IAVF_VLAN_ACTIVE;
 				if (f->vlan.tpid == ETH_P_8021Q)
 					set_bit(f->vlan.vid,
 						adapter->vsi.active_cvlans);
-- 
2.38.1

