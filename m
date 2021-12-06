Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F9646A4BD
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346762AbhLFSkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:40:02 -0500
Received: from mga05.intel.com ([192.55.52.43]:31032 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344983AbhLFSkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 13:40:01 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="323631997"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="323631997"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 10:36:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="461943033"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 06 Dec 2021 10:36:23 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karen Sornek <karen.sornek@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net v2 3/5] i40e: Fix failed opcode appearing if handling messages from VF
Date:   Mon,  6 Dec 2021 10:35:17 -0800
Message-Id: <20211206183519.2733180-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211206183519.2733180-1-anthony.l.nguyen@intel.com>
References: <20211206183519.2733180-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

Fix failed operation code appearing if handling messages from VF.
Implemented by waiting for VF appropriate state if request starts
handle while VF reset.
Without this patch the message handling request while VF is in
a reset state ends with error -5 (I40E_ERR_PARAM).

Fixes: 5c3c48ac6bf5 ("i40e: implement virtual device interface")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 70 +++++++++++++------
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  2 +
 2 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 80ae264c99ba..f651861442c2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1948,6 +1948,32 @@ static int i40e_vc_send_resp_to_vf(struct i40e_vf *vf,
 	return i40e_vc_send_msg_to_vf(vf, opcode, retval, NULL, 0);
 }
 
+/**
+ * i40e_sync_vf_state
+ * @vf: pointer to the VF info
+ * @state: VF state
+ *
+ * Called from a VF message to synchronize the service with a potential
+ * VF reset state
+ **/
+static bool i40e_sync_vf_state(struct i40e_vf *vf, enum i40e_vf_states state)
+{
+	int i;
+
+	/* When handling some messages, it needs VF state to be set.
+	 * It is possible that this flag is cleared during VF reset,
+	 * so there is a need to wait until the end of the reset to
+	 * handle the request message correctly.
+	 */
+	for (i = 0; i < I40E_VF_STATE_WAIT_COUNT; i++) {
+		if (test_bit(state, &vf->vf_states))
+			return true;
+		usleep_range(10000, 20000);
+	}
+
+	return test_bit(state, &vf->vf_states);
+}
+
 /**
  * i40e_vc_get_version_msg
  * @vf: pointer to the VF info
@@ -2008,7 +2034,7 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 	size_t len = 0;
 	int ret;
 
-	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_INIT)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -2131,7 +2157,7 @@ static int i40e_vc_config_promiscuous_mode_msg(struct i40e_vf *vf, u8 *msg)
 	bool allmulti = false;
 	bool alluni = false;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err_out;
 	}
@@ -2219,7 +2245,7 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 	struct i40e_vsi *vsi;
 	u16 num_qps_all = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2368,7 +2394,7 @@ static int i40e_vc_config_irq_map_msg(struct i40e_vf *vf, u8 *msg)
 	i40e_status aq_ret = 0;
 	int i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2540,7 +2566,7 @@ static int i40e_vc_disable_queues_msg(struct i40e_vf *vf, u8 *msg)
 	struct i40e_pf *pf = vf->pf;
 	i40e_status aq_ret = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2590,7 +2616,7 @@ static int i40e_vc_request_queues_msg(struct i40e_vf *vf, u8 *msg)
 	u8 cur_pairs = vf->num_queue_pairs;
 	struct i40e_pf *pf = vf->pf;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states))
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE))
 		return -EINVAL;
 
 	if (req_pairs > I40E_MAX_VF_QUEUES) {
@@ -2635,7 +2661,7 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg)
 
 	memset(&stats, 0, sizeof(struct i40e_eth_stats));
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2752,7 +2778,7 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 	i40e_status ret = 0;
 	int i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, al->vsi_id)) {
 		ret = I40E_ERR_PARAM;
 		goto error_param;
@@ -2824,7 +2850,7 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 	i40e_status ret = 0;
 	int i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, al->vsi_id)) {
 		ret = I40E_ERR_PARAM;
 		goto error_param;
@@ -2968,7 +2994,7 @@ static int i40e_vc_remove_vlan_msg(struct i40e_vf *vf, u8 *msg)
 	i40e_status aq_ret = 0;
 	int i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, vfl->vsi_id)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
@@ -3088,9 +3114,9 @@ static int i40e_vc_config_rss_key(struct i40e_vf *vf, u8 *msg)
 	struct i40e_vsi *vsi = NULL;
 	i40e_status aq_ret = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, vrk->vsi_id) ||
-	    (vrk->key_len != I40E_HKEY_ARRAY_SIZE)) {
+	    vrk->key_len != I40E_HKEY_ARRAY_SIZE) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3119,9 +3145,9 @@ static int i40e_vc_config_rss_lut(struct i40e_vf *vf, u8 *msg)
 	i40e_status aq_ret = 0;
 	u16 i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, vrl->vsi_id) ||
-	    (vrl->lut_entries != I40E_VF_HLUT_ARRAY_SIZE)) {
+	    vrl->lut_entries != I40E_VF_HLUT_ARRAY_SIZE) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3154,7 +3180,7 @@ static int i40e_vc_get_rss_hena(struct i40e_vf *vf, u8 *msg)
 	i40e_status aq_ret = 0;
 	int len = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3190,7 +3216,7 @@ static int i40e_vc_set_rss_hena(struct i40e_vf *vf, u8 *msg)
 	struct i40e_hw *hw = &pf->hw;
 	i40e_status aq_ret = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3215,7 +3241,7 @@ static int i40e_vc_enable_vlan_stripping(struct i40e_vf *vf, u8 *msg)
 	i40e_status aq_ret = 0;
 	struct i40e_vsi *vsi;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3241,7 +3267,7 @@ static int i40e_vc_disable_vlan_stripping(struct i40e_vf *vf, u8 *msg)
 	i40e_status aq_ret = 0;
 	struct i40e_vsi *vsi;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3468,7 +3494,7 @@ static int i40e_vc_del_cloud_filter(struct i40e_vf *vf, u8 *msg)
 	i40e_status aq_ret = 0;
 	int i, ret;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3599,7 +3625,7 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 	i40e_status aq_ret = 0;
 	int i, ret;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err_out;
 	}
@@ -3708,7 +3734,7 @@ static int i40e_vc_add_qch_msg(struct i40e_vf *vf, u8 *msg)
 	i40e_status aq_ret = 0;
 	u64 speed = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3824,7 +3850,7 @@ static int i40e_vc_del_qch_msg(struct i40e_vf *vf, u8 *msg)
 	struct i40e_pf *pf = vf->pf;
 	i40e_status aq_ret = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index 091e32c1bb46..49575a640a84 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -18,6 +18,8 @@
 
 #define I40E_MAX_VF_PROMISC_FLAGS	3
 
+#define I40E_VF_STATE_WAIT_COUNT	20
+
 /* Various queue ctrls */
 enum i40e_queue_ctrl {
 	I40E_QUEUE_CTRL_UNKNOWN = 0,
-- 
2.31.1

