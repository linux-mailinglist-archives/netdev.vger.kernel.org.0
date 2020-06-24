Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87482068F8
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388147AbgFXAXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:23:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:52394 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388117AbgFXAXE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 20:23:04 -0400
IronPort-SDR: V5qyXsSfZnUTijcrgGXIA2PdT8SuVWf63fEnRadtIBFalCqLw+DABHBGvh1lZpH5DWILYtj/pr
 Btl9MsDaYTmw==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="144308306"
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="144308306"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 17:22:56 -0700
IronPort-SDR: f4xBDoI3wC0fMt3Syj17fV7Wfh79DVgbVm/Fhr1T9SymXmsmsNzpX6mktEyFYWqlU4f6OMVIQM
 kwP1sGuJL92Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="293374256"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga002.jf.intel.com with ESMTP; 23 Jun 2020 17:22:54 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 8/8] i40e: Remove scheduling while atomic possibility
Date:   Tue, 23 Jun 2020 17:22:52 -0700
Message-Id: <20200624002252.942257-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624002252.942257-1-jeffrey.t.kirsher@intel.com>
References: <20200624002252.942257-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

In some occasions task held spinlock, while being rescheduled due to
mutex_lock.  Moved function call outside of atomic context.  Without
this patch there is a race condition, which might result in scheduling
while atomic.

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 234 ++++++++++--------
 1 file changed, 137 insertions(+), 97 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 56b9e445732b..8e133d6545bd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1106,39 +1106,81 @@ static int i40e_quiesce_vf_pci(struct i40e_vf *vf)
 	return -EIO;
 }
 
-static inline int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi);
+/**
+ * i40e_getnum_vf_vsi_vlan_filters
+ * @vsi: pointer to the vsi
+ *
+ * called to get the number of VLANs offloaded on this VF
+ **/
+static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
+{
+	struct i40e_mac_filter *f;
+	int num_vlans = 0, bkt;
+
+	hash_for_each(vsi->mac_filter_hash, bkt, f, hlist) {
+		if (f->vlan >= 0 && f->vlan <= I40E_MAX_VLANID)
+			num_vlans++;
+	}
+
+	return num_vlans;
+}
 
 /**
- * i40e_config_vf_promiscuous_mode
- * @vf: pointer to the VF info
- * @vsi_id: VSI id
- * @allmulti: set MAC L2 layer multicast promiscuous enable/disable
- * @alluni: set MAC L2 layer unicast promiscuous enable/disable
+ * i40e_get_vlan_list_sync
+ * @vsi: pointer to the VSI
+ * @num_vlans: number of VLANs in mac_filter_hash, returned to caller
+ * @vlan_list: list of VLANs present in mac_filter_hash, returned to caller.
+ *             This array is allocated here, but has to be freed in caller.
  *
- * Called from the VF to configure the promiscuous mode of
- * VF vsis and from the VF reset path to reset promiscuous mode.
+ * Called to get number of VLANs and VLAN list present in mac_filter_hash.
  **/
-static i40e_status i40e_config_vf_promiscuous_mode(struct i40e_vf *vf,
-						   u16 vsi_id,
-						   bool allmulti,
-						   bool alluni)
+static void i40e_get_vlan_list_sync(struct i40e_vsi *vsi, int *num_vlans,
+					   s16 **vlan_list)
 {
-	struct i40e_pf *pf = vf->pf;
-	struct i40e_hw *hw = &pf->hw;
 	struct i40e_mac_filter *f;
-	i40e_status aq_ret = 0;
-	struct i40e_vsi *vsi;
+	int i = 0;
 	int bkt;
 
-	vsi = i40e_find_vsi_from_id(pf, vsi_id);
-	if (!i40e_vc_isvalid_vsi_id(vf, vsi_id) || !vsi)
-		return I40E_ERR_PARAM;
+	spin_lock_bh(&vsi->mac_filter_hash_lock);
+	*num_vlans = i40e_getnum_vf_vsi_vlan_filters(vsi);
+	*vlan_list = kcalloc(*num_vlans, sizeof(**vlan_list), GFP_ATOMIC);
+	if (!(*vlan_list))
+		goto err;
 
-	if (vf->port_vlan_id) {
-		aq_ret = i40e_aq_set_vsi_mc_promisc_on_vlan(hw, vsi->seid,
-							    allmulti,
-							    vf->port_vlan_id,
-							    NULL);
+	hash_for_each(vsi->mac_filter_hash, bkt, f, hlist) {
+		if (f->vlan < 0 || f->vlan > I40E_MAX_VLANID)
+			continue;
+		(*vlan_list)[i++] = f->vlan;
+	}
+err:
+	spin_unlock_bh(&vsi->mac_filter_hash_lock);
+}
+
+/**
+ * i40e_set_vsi_promisc
+ * @vf: pointer to the VF struct
+ * @seid: VSI number
+ * @multi_enable: set MAC L2 layer multicast promiscuous enable/disable
+ *                for a given VLAN
+ * @unicast_enable: set MAC L2 layer unicast promiscuous enable/disable
+ *                  for a given VLAN
+ * @vl: List of VLANs - apply filter for given VLANs
+ * @num_vlans: Number of elements in @vl
+ **/
+static i40e_status
+i40e_set_vsi_promisc(struct i40e_vf *vf, u16 seid, bool multi_enable,
+		     bool unicast_enable, s16 *vl, int num_vlans)
+{
+	struct i40e_pf *pf = vf->pf;
+	struct i40e_hw *hw = &pf->hw;
+	i40e_status aq_ret;
+	int i;
+
+	/* No VLAN to set promisc on, set on VSI */
+	if (!num_vlans || !vl) {
+		aq_ret = i40e_aq_set_vsi_multicast_promiscuous(hw, seid,
+							       multi_enable,
+							       NULL);
 		if (aq_ret) {
 			int aq_err = pf->hw.aq.asq_last_status;
 
@@ -1147,13 +1189,14 @@ static i40e_status i40e_config_vf_promiscuous_mode(struct i40e_vf *vf,
 				vf->vf_id,
 				i40e_stat_str(&pf->hw, aq_ret),
 				i40e_aq_str(&pf->hw, aq_err));
+
 			return aq_ret;
 		}
 
-		aq_ret = i40e_aq_set_vsi_uc_promisc_on_vlan(hw, vsi->seid,
-							    alluni,
-							    vf->port_vlan_id,
-							    NULL);
+		aq_ret = i40e_aq_set_vsi_unicast_promiscuous(hw, seid,
+							     unicast_enable,
+							     NULL, true);
+
 		if (aq_ret) {
 			int aq_err = pf->hw.aq.asq_last_status;
 
@@ -1163,68 +1206,84 @@ static i40e_status i40e_config_vf_promiscuous_mode(struct i40e_vf *vf,
 				i40e_stat_str(&pf->hw, aq_ret),
 				i40e_aq_str(&pf->hw, aq_err));
 		}
+
 		return aq_ret;
-	} else if (i40e_getnum_vf_vsi_vlan_filters(vsi)) {
-		hash_for_each(vsi->mac_filter_hash, bkt, f, hlist) {
-			if (f->vlan < 0 || f->vlan > I40E_MAX_VLANID)
-				continue;
-			aq_ret = i40e_aq_set_vsi_mc_promisc_on_vlan(hw,
-								    vsi->seid,
-								    allmulti,
-								    f->vlan,
-								    NULL);
-			if (aq_ret) {
-				int aq_err = pf->hw.aq.asq_last_status;
+	}
 
-				dev_err(&pf->pdev->dev,
-					"Could not add VLAN %d to multicast promiscuous domain err %s aq_err %s\n",
-					f->vlan,
-					i40e_stat_str(&pf->hw, aq_ret),
-					i40e_aq_str(&pf->hw, aq_err));
-			}
+	for (i = 0; i < num_vlans; i++) {
+		aq_ret = i40e_aq_set_vsi_mc_promisc_on_vlan(hw, seid,
+							    multi_enable,
+							    vl[i], NULL);
+		if (aq_ret) {
+			int aq_err = pf->hw.aq.asq_last_status;
+
+			dev_err(&pf->pdev->dev,
+				"VF %d failed to set multicast promiscuous mode err %s aq_err %s\n",
+				vf->vf_id,
+				i40e_stat_str(&pf->hw, aq_ret),
+				i40e_aq_str(&pf->hw, aq_err));
+		}
 
-			aq_ret = i40e_aq_set_vsi_uc_promisc_on_vlan(hw,
-								    vsi->seid,
-								    alluni,
-								    f->vlan,
-								    NULL);
-			if (aq_ret) {
-				int aq_err = pf->hw.aq.asq_last_status;
+		aq_ret = i40e_aq_set_vsi_uc_promisc_on_vlan(hw, seid,
+							    unicast_enable,
+							    vl[i], NULL);
+		if (aq_ret) {
+			int aq_err = pf->hw.aq.asq_last_status;
 
-				dev_err(&pf->pdev->dev,
-					"Could not add VLAN %d to Unicast promiscuous domain err %s aq_err %s\n",
-					f->vlan,
-					i40e_stat_str(&pf->hw, aq_ret),
-					i40e_aq_str(&pf->hw, aq_err));
-			}
+			dev_err(&pf->pdev->dev,
+				"VF %d failed to set unicast promiscuous mode err %s aq_err %s\n",
+				vf->vf_id,
+				i40e_stat_str(&pf->hw, aq_ret),
+				i40e_aq_str(&pf->hw, aq_err));
 		}
-		return aq_ret;
 	}
-	aq_ret = i40e_aq_set_vsi_multicast_promiscuous(hw, vsi->seid, allmulti,
-						       NULL);
-	if (aq_ret) {
-		int aq_err = pf->hw.aq.asq_last_status;
+	return aq_ret;
+}
 
-		dev_err(&pf->pdev->dev,
-			"VF %d failed to set multicast promiscuous mode err %s aq_err %s\n",
-			vf->vf_id,
-			i40e_stat_str(&pf->hw, aq_ret),
-			i40e_aq_str(&pf->hw, aq_err));
+/**
+ * i40e_config_vf_promiscuous_mode
+ * @vf: pointer to the VF info
+ * @vsi_id: VSI id
+ * @allmulti: set MAC L2 layer multicast promiscuous enable/disable
+ * @alluni: set MAC L2 layer unicast promiscuous enable/disable
+ *
+ * Called from the VF to configure the promiscuous mode of
+ * VF vsis and from the VF reset path to reset promiscuous mode.
+ **/
+static i40e_status i40e_config_vf_promiscuous_mode(struct i40e_vf *vf,
+						   u16 vsi_id,
+						   bool allmulti,
+						   bool alluni)
+{
+	i40e_status aq_ret = I40E_SUCCESS;
+	struct i40e_pf *pf = vf->pf;
+	struct i40e_vsi *vsi;
+	int num_vlans;
+	s16 *vl;
+
+	vsi = i40e_find_vsi_from_id(pf, vsi_id);
+	if (!i40e_vc_isvalid_vsi_id(vf, vsi_id) || !vsi)
+		return I40E_ERR_PARAM;
+
+	if (vf->port_vlan_id) {
+		aq_ret = i40e_set_vsi_promisc(vf, vsi->seid, allmulti,
+					      alluni, &vf->port_vlan_id, 1);
 		return aq_ret;
-	}
+	} else if (i40e_getnum_vf_vsi_vlan_filters(vsi)) {
+		i40e_get_vlan_list_sync(vsi, &num_vlans, &vl);
 
-	aq_ret = i40e_aq_set_vsi_unicast_promiscuous(hw, vsi->seid, alluni,
-						     NULL, true);
-	if (aq_ret) {
-		int aq_err = pf->hw.aq.asq_last_status;
+		if (!vl)
+			return I40E_ERR_NO_MEMORY;
 
-		dev_err(&pf->pdev->dev,
-			"VF %d failed to set unicast promiscuous mode err %s aq_err %s\n",
-			vf->vf_id,
-			i40e_stat_str(&pf->hw, aq_ret),
-			i40e_aq_str(&pf->hw, aq_err));
+		aq_ret = i40e_set_vsi_promisc(vf, vsi->seid, allmulti, alluni,
+					      vl, num_vlans);
+		kfree(vl);
+		return aq_ret;
 	}
 
+	/* no VLANs to set on, set on VSI */
+	aq_ret = i40e_set_vsi_promisc(vf, vsi->seid, allmulti, alluni,
+				      NULL, 0);
 	return aq_ret;
 }
 
@@ -1972,25 +2031,6 @@ static void i40e_vc_reset_vf_msg(struct i40e_vf *vf)
 		i40e_reset_vf(vf, false);
 }
 
-/**
- * i40e_getnum_vf_vsi_vlan_filters
- * @vsi: pointer to the vsi
- *
- * called to get the number of VLANs offloaded on this VF
- **/
-static inline int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
-{
-	struct i40e_mac_filter *f;
-	int num_vlans = 0, bkt;
-
-	hash_for_each(vsi->mac_filter_hash, bkt, f, hlist) {
-		if (f->vlan >= 0 && f->vlan <= I40E_MAX_VLANID)
-			num_vlans++;
-	}
-
-	return num_vlans;
-}
-
 /**
  * i40e_vc_config_promiscuous_mode_msg
  * @vf: pointer to the VF info
-- 
2.26.2

