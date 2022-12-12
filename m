Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09143649DFD
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiLLLfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiLLLfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:35:14 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665675F5A
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670844771; x=1702380771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7JM1baiJD2iMw81PtlfE+qey1ukL2LvHRr6pKrv5db4=;
  b=CMr7UPdBaNr8NmJ+TWCxky8erBOMAmaqdjX/D6l3pkI8haUl9ZzIIb/s
   mj6YiYcqJ4D32PvyZ+jWkXi4nmy8iLI9Mkyunwwf5h3znf6AdFOMeWLWU
   N44iuqbhUZJJFu+M1iL/8htSpVZWjTmiy7dVuDwERT3RMXThlpm8lc7Za
   12Sf31+FGIvhQtR0v+8Q+Ni8vClwlB+OZbU3f1DgZr+fsE2iDVHDPWY+c
   4vRjt7ZKHkZBItwGJEfwv5prDV1SBT75Gpz9JinqR4jRP0IGdyWPQTWUZ
   I2mPlYL+dhCUuXb05Yj9kbRUMHhmKPQH0FwpMZNXN1CRXKYE44+uuCMkw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="317861419"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="317861419"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 03:32:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="893459675"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="893459675"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by fmsmga006.fm.intel.com with ESMTP; 12 Dec 2022 03:32:47 -0800
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     alexandr.lobakin@intel.com, sridhar.samudrala@intel.com,
        wojciech.drewek@intel.com, lukasz.czapnik@intel.com,
        shiraz.saleem@intel.com, jesse.brandeburg@intel.com,
        mustafa.ismail@intel.com, przemyslaw.kitszel@intel.com,
        piotr.raczynski@intel.com, jacob.e.keller@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com,
        benjamin.mikailenko@intel.com, paul.m.stillwell.jr@intel.com,
        netdev@vger.kernel.org, kuba@kernel.org, leon@kernel.org,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v1 01/10] ice: move RDMA init to ice_idc.c
Date:   Mon, 12 Dec 2022 12:16:36 +0100
Message-Id: <20221212111645.1198680-2-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
References: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify probe flow by moving all RDMA related code to ice_init_rdma().
Unroll irq allocation if RDMA initialization fails.

Implement ice_deinit_rdma() and use it in remove flow.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Acked-by: Dave Ertman <david.m.ertman@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_idc.c  | 52 ++++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c | 29 +++----------
 3 files changed, 57 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index ea64bcff108a..f461a1b3c100 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -909,6 +909,7 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
 int ice_plug_aux_dev(struct ice_pf *pf);
 void ice_unplug_aux_dev(struct ice_pf *pf);
 int ice_init_rdma(struct ice_pf *pf);
+void ice_deinit_rdma(struct ice_pf *pf);
 const char *ice_aq_str(enum ice_aq_err aq_err);
 bool ice_is_wol_supported(struct ice_hw *hw);
 void ice_fdir_del_all_fltrs(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 9bf6fa5ed4c8..2148e49679b1 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -6,6 +6,8 @@
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
 
+static DEFINE_IDA(ice_aux_ida);
+
 /**
  * ice_get_auxiliary_drv - retrieve iidc_auxiliary_drv struct
  * @pf: pointer to PF struct
@@ -248,6 +250,17 @@ static int ice_reserve_rdma_qvector(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_free_rdma_qvector - free vector resources reserved for RDMA driver
+ * @pf: board private structure to initialize
+ */
+static void ice_free_rdma_qvector(struct ice_pf *pf)
+{
+	pf->num_avail_sw_msix -= pf->num_rdma_msix;
+	ice_free_res(pf->irq_tracker, pf->rdma_base_vector,
+		     ICE_RES_RDMA_VEC_ID);
+}
+
 /**
  * ice_adev_release - function to be mapped to AUX dev's release op
  * @dev: pointer to device to free
@@ -334,12 +347,47 @@ int ice_init_rdma(struct ice_pf *pf)
 	struct device *dev = &pf->pdev->dev;
 	int ret;
 
+	if (!ice_is_rdma_ena(pf)) {
+		dev_warn(dev, "RDMA is not supported on this device\n");
+		return 0;
+	}
+
+	pf->aux_idx = ida_alloc(&ice_aux_ida, GFP_KERNEL);
+	if (pf->aux_idx < 0) {
+		dev_err(dev, "Failed to allocate device ID for AUX driver\n");
+		return -ENOMEM;
+	}
+
 	/* Reserve vector resources */
 	ret = ice_reserve_rdma_qvector(pf);
 	if (ret < 0) {
 		dev_err(dev, "failed to reserve vectors for RDMA\n");
-		return ret;
+		goto err_reserve_rdma_qvector;
 	}
 	pf->rdma_mode |= IIDC_RDMA_PROTOCOL_ROCEV2;
-	return ice_plug_aux_dev(pf);
+	ret = ice_plug_aux_dev(pf);
+	if (ret)
+		goto err_plug_aux_dev;
+	return 0;
+
+err_plug_aux_dev:
+	ice_free_rdma_qvector(pf);
+err_reserve_rdma_qvector:
+	pf->adev = NULL;
+	ida_free(&ice_aux_ida, pf->aux_idx);
+	return ret;
+}
+
+/**
+ * ice_deinit_rdma - deinitialize RDMA on PF
+ * @pf: ptr to ice_pf
+ */
+void ice_deinit_rdma(struct ice_pf *pf)
+{
+	if (!ice_is_rdma_ena(pf))
+		return;
+
+	ice_unplug_aux_dev(pf);
+	ice_free_rdma_qvector(pf);
+	ida_free(&ice_aux_ida, pf->aux_idx);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d01d1073ffec..59a88c00b91d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -44,7 +44,6 @@ MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all), hw debug_mask (0x8XXXX
 MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all)");
 #endif /* !CONFIG_DYNAMIC_DEBUG */
 
-static DEFINE_IDA(ice_aux_ida);
 DEFINE_STATIC_KEY_FALSE(ice_xdp_locking_key);
 EXPORT_SYMBOL(ice_xdp_locking_key);
 
@@ -5011,30 +5010,16 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	/* ready to go, so clear down state bit */
 	clear_bit(ICE_DOWN, pf->state);
-	if (ice_is_rdma_ena(pf)) {
-		pf->aux_idx = ida_alloc(&ice_aux_ida, GFP_KERNEL);
-		if (pf->aux_idx < 0) {
-			dev_err(dev, "Failed to allocate device ID for AUX driver\n");
-			err = -ENOMEM;
-			goto err_devlink_reg_param;
-		}
-
-		err = ice_init_rdma(pf);
-		if (err) {
-			dev_err(dev, "Failed to initialize RDMA: %d\n", err);
-			err = -EIO;
-			goto err_init_aux_unroll;
-		}
-	} else {
-		dev_warn(dev, "RDMA is not supported on this device\n");
+	err = ice_init_rdma(pf);
+	if (err) {
+		dev_err(dev, "Failed to initialize RDMA: %d\n", err);
+		err = -EIO;
+		goto err_devlink_reg_param;
 	}
 
 	ice_devlink_register(pf);
 	return 0;
 
-err_init_aux_unroll:
-	pf->adev = NULL;
-	ida_free(&ice_aux_ida, pf->aux_idx);
 err_devlink_reg_param:
 	ice_devlink_unregister_params(pf);
 err_netdev_reg:
@@ -5152,9 +5137,7 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_service_task_stop(pf);
 
 	ice_aq_cancel_waiting_tasks(pf);
-	ice_unplug_aux_dev(pf);
-	if (pf->aux_idx >= 0)
-		ida_free(&ice_aux_ida, pf->aux_idx);
+	ice_deinit_rdma(pf);
 	ice_devlink_unregister_params(pf);
 	set_bit(ICE_DOWN, pf->state);
 
-- 
2.36.1

