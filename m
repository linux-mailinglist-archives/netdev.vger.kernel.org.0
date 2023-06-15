Return-Path: <netdev+bounces-11121-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 677ED73196D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22207281843
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1240168A2;
	Thu, 15 Jun 2023 12:59:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BE716404
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:59:30 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E189213F
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686833969; x=1718369969;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JcrYUR58qpMheWpFgQE00BiitNYzYFa+Njs0RKuYuiM=;
  b=fdygXoVZVTa6I9alQrfNGCUfEo0PjoxKddHUeRyPbeAPKEFUqJ72Ped9
   uoQkupzbHiXTsVToLHwpCXjiVJHvD7pfxZupNPhNm5yrmTj5ZXyXOR/7k
   19fV2nHU6U2Gi+pW1ehZWp1TtM3ypkd1qsTkBofrsdyopc+lU63f1mrBv
   y90eTAPhTJlB25PpE8h4aQt4nUq0ny8OOflkpcv64lfWAc10UrFXZxbfJ
   oVPbV7rbjeTW/+Dvp2IOyl6koZhMfElfrPFSXoWOHFQtSpiUR+jH2ZCS+
   rnV2qJoVzS3Nb4AxnRvIzkpHykK5fXY+vWZlpXa80PVwIXdGZyhjQpD91
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="424794833"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="424794833"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 05:59:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="825259751"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="825259751"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by fmsmga002.fm.intel.com with ESMTP; 15 Jun 2023 05:59:27 -0700
From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	jacob.e.keller@intel.com,
	przemyslaw.kitszel@intel.com,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH iwl-next v1 3/4] ice: set MSI-X vector count on VF
Date: Thu, 15 Jun 2023 14:38:29 +0200
Message-Id: <20230615123830.155927-4-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
References: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement ops needed to set MSI-X vector count on VF.

sriov_get_vf_total_msix() should return total number of MSI-X that can
be used by the VFs. Return the value set by devlink resources API
(pf->req_msix.vf).

sriov_set_msix_vec_count() will set number of MSI-X on particular VF.
Disable VF register mapping, rebuild VSI with new MSI-X and queues
values and enable new VF register mapping.

For best performance set number of queues equal to number of MSI-X.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c  |  2 +
 drivers/net/ethernet/intel/ice/ice_sriov.c | 69 ++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_sriov.h | 13 ++++
 3 files changed, 84 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9d55290b6dcc..1061161ec737 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5545,6 +5545,8 @@ static struct pci_driver ice_driver = {
 #endif /* CONFIG_PM */
 	.shutdown = ice_shutdown,
 	.sriov_configure = ice_sriov_configure,
+	.sriov_get_vf_total_msix = ice_sriov_get_vf_total_msix,
+	.sriov_set_msix_vec_count = ice_sriov_set_msix_vec_count,
 	.err_handler = &ice_pci_err_handler
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index da0f1deef89b..e20ef1924fae 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -971,6 +971,75 @@ static int ice_check_sriov_allowed(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_sriov_get_vf_total_msix - return number of MSI-X used by VFs
+ * @pdev: pointer to pci_dev struct
+ *
+ * The function is called via sysfs ops
+ */
+u32 ice_sriov_get_vf_total_msix(struct pci_dev *pdev)
+{
+	struct ice_pf *pf = pci_get_drvdata(pdev);
+
+	return pf->sriov_irq_size - ice_get_max_used_msix_vector(pf);
+}
+
+/**
+ * ice_sriov_set_msix_vec_count
+ * @vf_dev: pointer to pci_dev struct of VF device
+ * @msix_vec_count: new value for MSI-X amount on this VF
+ *
+ * Set requested MSI-X, queues and registers for @vf_dev.
+ *
+ * First do some sanity checks like if there are any VFs, if the new value
+ * is correct etc. Then disable old mapping (MSI-X and queues registers), change
+ * MSI-X and queues, rebuild VSI and enable new mapping.
+ *
+ * If it is possible (driver not binded to VF) try to remap also other VFs to
+ * linearize irqs register usage.
+ */
+int ice_sriov_set_msix_vec_count(struct pci_dev *vf_dev, int msix_vec_count)
+{
+	struct pci_dev *pdev = pci_physfn(vf_dev);
+	struct ice_pf *pf = pci_get_drvdata(pdev);
+	struct ice_vf *vf;
+	u16 queues;
+	int id;
+
+	if (!ice_get_num_vfs(pf))
+		return -ENOENT;
+
+	if (!msix_vec_count)
+		return 0;
+
+	queues = msix_vec_count;
+	/* add 1 MSI-X for OICR */
+	msix_vec_count += 1;
+
+	/* Transition of PCI VF function number to function_id */
+	for (id = 0; id < pci_num_vf(pdev); id++) {
+		if (vf_dev->devfn == pci_iov_virtfn_devfn(pdev, id))
+			break;
+	}
+
+	if (id == pci_num_vf(pdev))
+		return -ENOENT;
+
+	vf = ice_get_vf_by_id(pf, id);
+
+	if (!vf)
+		return -ENOENT;
+
+	ice_dis_vf_mappings(vf);
+	vf->num_msix = msix_vec_count;
+	vf->num_vf_qs = queues;
+	ice_vsi_rebuild(ice_get_vf_vsi(vf), ICE_VSI_FLAG_NO_INIT);
+	ice_ena_vf_mappings(vf);
+	ice_put_vf(vf);
+
+	return 0;
+}
+
 /**
  * ice_sriov_configure - Enable or change number of VFs via sysfs
  * @pdev: pointer to a pci_dev structure
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.h b/drivers/net/ethernet/intel/ice/ice_sriov.h
index 346cb2666f3a..77e3dc5feefd 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.h
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.h
@@ -60,6 +60,8 @@ void ice_print_vfs_mdd_events(struct ice_pf *pf);
 void ice_print_vf_rx_mdd_event(struct ice_vf *vf);
 bool
 ice_vc_validate_pattern(struct ice_vf *vf, struct virtchnl_proto_hdrs *proto);
+u32 ice_sriov_get_vf_total_msix(struct pci_dev *pdev);
+int ice_sriov_set_msix_vec_count(struct pci_dev *vf_dev, int msix_vec_count);
 #else /* CONFIG_PCI_IOV */
 static inline void ice_process_vflr_event(struct ice_pf *pf) { }
 static inline void ice_free_vfs(struct ice_pf *pf) { }
@@ -142,5 +144,16 @@ ice_get_vf_stats(struct net_device __always_unused *netdev,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline u32 ice_sriov_get_vf_total_msix(struct pci_dev *pdev)
+{
+	return 0;
+}
+
+static inline int
+ice_sriov_set_msix_vec_count(struct pci_dev *vf_dev, int msix_vec_count)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_PCI_IOV */
 #endif /* _ICE_SRIOV_H_ */
-- 
2.40.1


