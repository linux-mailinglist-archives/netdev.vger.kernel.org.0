Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A2E678D0E
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 01:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbjAXA5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 19:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbjAXA5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 19:57:11 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA6929428
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 16:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674521830; x=1706057830;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=db4z7XTwWmGOFESkGMLxt6MgKyU8MP1EQfLQRLsltQY=;
  b=S93LGFYZ27k/b3WV4Sv1eE/aCfPs5z43WglPDispzfxhLsNfcobgXHqg
   jU2ScU4j0Ze4RNSqYqBq5/wDH7gKid74lJqIRvtio5GI7tRoi/sl2yoiX
   OIHeow6WWt2COQLJPzEC0EYYK7ll5wCjTh+YNonL/tnqsNvP48E6u3FwX
   Oo9KwFVc9HNsxraujSEk6dkpSlvbnS55GAhHuSvXdgGQyjw5Lr1j3S7iL
   W9aDOdkdQ8MmAHRwmK47n19n4SiHTZGQTSTq+gx+bd8nPUDl1zZPKCcNC
   m8MWOm/CEFoYEtT2Abx9vpuzWgvKY6g/w/jjT8CHjWJa3myqsTbZiaMoQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="309780335"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="309780335"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 16:57:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="804395114"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="804395114"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga001.fm.intel.com with ESMTP; 23 Jan 2023 16:57:09 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jiri@nvidia.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/1] ice: move devlink port creation/deletion
Date:   Mon, 23 Jan 2023 16:57:14 -0800
Message-Id: <20230124005714.3996270-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

Commit a286ba738714 ("ice: reorder PF/representor devlink
port register/unregister flows") moved the code to create
and destroy the devlink PF port. This was fine, but created
a corner case issue in the case of ice_register_netdev()
failing. In that case, the driver would end up calling
ice_devlink_destroy_pf_port() twice.

Additionally, it makes no sense to tie creation of the devlink
PF port to the creation of the netdev so separate out the
code to create/destroy the devlink PF port from the netdev
code. This makes it a cleaner interface.

Fixes: a286ba738714 ("ice: reorder PF/representor devlink port register/unregister flows")
Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
There will be a merge conflict when rebasing with next-next.

Resolution:
static void ice_remove(struct pci_dev *
  		ice_remove_arfs(pf);
  	ice_setup_mc_magic_wake(pf);
  	ice_vsi_release_all(pf);
 -	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
 +	mutex_destroy(&hw->fdir_fltr_lock);
+ 	ice_devlink_destroy_pf_port(pf);
  	ice_set_wake(pf);
  	ice_free_irq_msix_misc(pf);
  	ice_for_each_vsi(pf, i) {

 drivers/net/ethernet/intel/ice/ice_lib.c  |  3 ---
 drivers/net/ethernet/intel/ice/ice_main.c | 25 +++++++++++++++--------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 94aa834cd9a6..a596e07b3ce9 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3235,9 +3235,6 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		}
 	}
 
-	if (vsi->type == ICE_VSI_PF)
-		ice_devlink_destroy_pf_port(pf);
-
 	if (vsi->type == ICE_VSI_VF &&
 	    vsi->agg_node && vsi->agg_node->valid)
 		vsi->agg_node->num_vsis--;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a9a7f8b52140..237ede2cffb0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4590,7 +4590,7 @@ static void ice_print_wake_reason(struct ice_pf *pf)
 }
 
 /**
- * ice_register_netdev - register netdev and devlink port
+ * ice_register_netdev - register netdev
  * @pf: pointer to the PF struct
  */
 static int ice_register_netdev(struct ice_pf *pf)
@@ -4602,11 +4602,6 @@ static int ice_register_netdev(struct ice_pf *pf)
 	if (!vsi || !vsi->netdev)
 		return -EIO;
 
-	err = ice_devlink_create_pf_port(pf);
-	if (err)
-		goto err_devlink_create;
-
-	SET_NETDEV_DEVLINK_PORT(vsi->netdev, &pf->devlink_port);
 	err = register_netdev(vsi->netdev);
 	if (err)
 		goto err_register_netdev;
@@ -4617,8 +4612,6 @@ static int ice_register_netdev(struct ice_pf *pf)
 
 	return 0;
 err_register_netdev:
-	ice_devlink_destroy_pf_port(pf);
-err_devlink_create:
 	free_netdev(vsi->netdev);
 	vsi->netdev = NULL;
 	clear_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
@@ -4636,6 +4629,7 @@ static int
 ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 {
 	struct device *dev = &pdev->dev;
+	struct ice_vsi *vsi;
 	struct ice_pf *pf;
 	struct ice_hw *hw;
 	int i, err;
@@ -4918,6 +4912,18 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	pcie_print_link_status(pf->pdev);
 
 probe_done:
+	err = ice_devlink_create_pf_port(pf);
+	if (err)
+		goto err_create_pf_port;
+
+	vsi = ice_get_main_vsi(pf);
+	if (!vsi || !vsi->netdev) {
+		err = -EINVAL;
+		goto err_netdev_reg;
+	}
+
+	SET_NETDEV_DEVLINK_PORT(vsi->netdev, &pf->devlink_port);
+
 	err = ice_register_netdev(pf);
 	if (err)
 		goto err_netdev_reg;
@@ -4955,6 +4961,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 err_devlink_reg_param:
 	ice_devlink_unregister_params(pf);
 err_netdev_reg:
+	ice_devlink_destroy_pf_port(pf);
+err_create_pf_port:
 err_send_version_unroll:
 	ice_vsi_release_all(pf);
 err_alloc_sw_unroll:
@@ -5083,6 +5091,7 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_setup_mc_magic_wake(pf);
 	ice_vsi_release_all(pf);
 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
+	ice_devlink_destroy_pf_port(pf);
 	ice_set_wake(pf);
 	ice_free_irq_msix_misc(pf);
 	ice_for_each_vsi(pf, i) {
-- 
2.38.1

