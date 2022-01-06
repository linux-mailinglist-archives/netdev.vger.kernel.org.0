Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3304A486BF6
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 22:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244296AbiAFVdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 16:33:43 -0500
Received: from mga06.intel.com ([134.134.136.31]:26402 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244236AbiAFVdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 16:33:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641504822; x=1673040822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=obqPNR/qwqXYCON00Vcv9E4YEnx05jB0iQgDBDt2eyA=;
  b=aqzQ4N40s42T8nRKqjRCWTtMly3fcH3CJSo+jYxJ4qPdiBNxq+YXyPF1
   VKObNnX2SpMIyb+Jherzxcfu7vY21L4U3FZfyOCIBEhoVegLOXTAK7owL
   eO+nrku4aRlVn/F5GPGusn7T1VgXPN8QxcXznO/8nMp7VhG/wGF9GChEg
   H6QM1eWwZm+Ggf06nCR//d3J6eMnNHzzS/O2WfA/rvErLhtQMEVrhdPWb
   HQiCPralvz2jwTYHKTPFiaDHCO7j79CYkSmBzpTzqXwxd+dzD5KJOAHPx
   GClR4GvmRiZyGQyi35fZ7htLa1ZOSrwCb08m2qKFwwEsp2ReIGYfjf2vm
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="303490345"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="303490345"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 13:33:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="611972890"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jan 2022 13:33:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karen Sornek <karen.sornek@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 2/7] i40e: Add placeholder for ndo set VLANs
Date:   Thu,  6 Jan 2022 13:32:56 -0800
Message-Id: <20220106213301.11392-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
References: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

VLANs set by ndo, were not accounted.
Implement placeholder, by which driver can account VLANs set by
ndo. Ensure that once PF changes trunk, every guest filter
is removed from the list 'vm_vlan_list'.
Implement logic for deletion/addition of guest(from VM) filters.

Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 96 +++++++++++++++++--
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    | 10 ++
 2 files changed, 98 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index b785d09c19f8..1c7eb9766876 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -986,6 +986,79 @@ static void i40e_disable_vf_mappings(struct i40e_vf *vf)
 	i40e_flush(hw);
 }
 
+/**
+ * i40e_add_vmvlan_to_list
+ * @vf: pointer to the VF info
+ * @vfl:  pointer to the VF VLAN tag filters list
+ * @vlan_idx: vlan_id index in VLAN tag filters list
+ *
+ * add VLAN tag into the VLAN list for VM
+ **/
+static i40e_status
+i40e_add_vmvlan_to_list(struct i40e_vf *vf,
+			struct virtchnl_vlan_filter_list *vfl,
+			u16 vlan_idx)
+{
+	struct i40e_vm_vlan *vlan_elem;
+
+	vlan_elem = kzalloc(sizeof(*vlan_elem), GFP_KERNEL);
+	if (!vlan_elem)
+		return I40E_ERR_NO_MEMORY;
+	vlan_elem->vlan = vfl->vlan_id[vlan_idx];
+	vlan_elem->vsi_id = vfl->vsi_id;
+	INIT_LIST_HEAD(&vlan_elem->list);
+	vf->num_vlan++;
+	list_add(&vlan_elem->list, &vf->vm_vlan_list);
+	return 0;
+}
+
+/**
+ * i40e_del_vmvlan_from_list
+ * @vsi: pointer to the VSI structure
+ * @vf: pointer to the VF info
+ * @vlan: VLAN tag to be removed from the list
+ *
+ * delete VLAN tag from the VLAN list for VM
+ **/
+static void i40e_del_vmvlan_from_list(struct i40e_vsi *vsi,
+				      struct i40e_vf *vf, u16 vlan)
+{
+	struct i40e_vm_vlan *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &vf->vm_vlan_list, list) {
+		if (vlan == entry->vlan) {
+			i40e_vsi_kill_vlan(vsi, vlan);
+			vf->num_vlan--;
+			list_del(&entry->list);
+			kfree(entry);
+			break;
+		}
+	}
+}
+
+/**
+ * i40e_free_vmvlan_list
+ * @vsi: pointer to the VSI structure
+ * @vf: pointer to the VF info
+ *
+ * remove whole list of VLAN tags for VM
+ **/
+static void i40e_free_vmvlan_list(struct i40e_vsi *vsi, struct i40e_vf *vf)
+{
+	struct i40e_vm_vlan *entry, *tmp;
+
+	if (list_empty(&vf->vm_vlan_list))
+		return;
+
+	list_for_each_entry_safe(entry, tmp, &vf->vm_vlan_list, list) {
+		if (vsi)
+			i40e_vsi_kill_vlan(vsi, entry->vlan);
+		list_del(&entry->list);
+		kfree(entry);
+	}
+	vf->num_vlan = 0;
+}
+
 /**
  * i40e_free_vf_res
  * @vf: pointer to the VF info
@@ -1061,6 +1134,9 @@ static void i40e_free_vf_res(struct i40e_vf *vf)
 		wr32(hw, reg_idx, reg);
 		i40e_flush(hw);
 	}
+
+	i40e_free_vmvlan_list(NULL, vf);
+
 	/* reset some of the state variables keeping track of the resources */
 	vf->num_queue_pairs = 0;
 	clear_bit(I40E_VF_STATE_MC_PROMISC, &vf->vf_states);
@@ -1766,6 +1842,7 @@ int i40e_alloc_vfs(struct i40e_pf *pf, u16 num_alloc_vfs)
 
 		set_bit(I40E_VF_STATE_PRE_ENABLE, &vfs[i].vf_states);
 
+		INIT_LIST_HEAD(&vfs[i].vm_vlan_list);
 	}
 	pf->num_alloc_vfs = num_alloc_vfs;
 
@@ -2969,12 +3046,13 @@ static int i40e_vc_add_vlan_msg(struct i40e_vf *vf, u8 *msg)
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = NULL;
 	i40e_status aq_ret = 0;
-	int i;
+	u16 i;
 
-	if ((vf->num_vlan >= I40E_VC_MAX_VLAN_PER_VF) &&
+	if ((vf->num_vlan + vfl->num_elements > I40E_VC_MAX_VLAN_PER_VF) &&
 	    !test_bit(I40E_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps)) {
 		dev_err(&pf->pdev->dev,
 			"VF is not trusted, switch the VF to trusted to add more VLAN addresses\n");
+		aq_ret = I40E_ERR_CONFIG;
 		goto error_param;
 	}
 	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
@@ -2998,11 +3076,14 @@ static int i40e_vc_add_vlan_msg(struct i40e_vf *vf, u8 *msg)
 	}
 
 	i40e_vlan_stripping_enable(vsi);
+
 	for (i = 0; i < vfl->num_elements; i++) {
-		/* add new VLAN filter */
 		int ret = i40e_vsi_add_vlan(vsi, vfl->vlan_id[i]);
-		if (!ret)
-			vf->num_vlan++;
+		if (!ret && vfl->vlan_id[i]) {
+			aq_ret = i40e_add_vmvlan_to_list(vf, vfl, i);
+			if (aq_ret)
+				goto error_param;
+		}
 
 		if (test_bit(I40E_VF_STATE_UC_PROMISC, &vf->vf_states))
 			i40e_aq_set_vsi_uc_promisc_on_vlan(&pf->hw, vsi->seid,
@@ -3040,7 +3121,7 @@ static int i40e_vc_remove_vlan_msg(struct i40e_vf *vf, u8 *msg)
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = NULL;
 	i40e_status aq_ret = 0;
-	int i;
+	u16 i;
 
 	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, vfl->vsi_id)) {
@@ -3063,8 +3144,7 @@ static int i40e_vc_remove_vlan_msg(struct i40e_vf *vf, u8 *msg)
 	}
 
 	for (i = 0; i < vfl->num_elements; i++) {
-		i40e_vsi_kill_vlan(vsi, vfl->vlan_id[i]);
-		vf->num_vlan--;
+		i40e_del_vmvlan_from_list(vsi, vf, vfl->vlan_id[i]);
 
 		if (test_bit(I40E_VF_STATE_UC_PROMISC, &vf->vf_states))
 			i40e_aq_set_vsi_uc_promisc_on_vlan(&pf->hw, vsi->seid,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index 49575a640a84..182604bd9a24 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -62,6 +62,13 @@ struct i40evf_channel {
 	u64 max_tx_rate; /* bandwidth rate allocation for VSIs */
 };
 
+/* used for VLAN list 'vm_vlan_list' by VM for trusted and untrusted VF */
+struct i40e_vm_vlan {
+	struct list_head list;
+	s16 vlan;
+	u16 vsi_id;
+};
+
 /* VF information structure */
 struct i40e_vf {
 	struct i40e_pf *pf;
@@ -103,6 +110,9 @@ struct i40e_vf {
 	bool spoofchk;
 	u16 num_vlan;
 
+	/* VLAN list created by VM for trusted and untrusted VF */
+	struct list_head vm_vlan_list;
+
 	/* ADq related variables */
 	bool adq_enabled; /* flag to enable adq */
 	u8 num_tc;
-- 
2.31.1

