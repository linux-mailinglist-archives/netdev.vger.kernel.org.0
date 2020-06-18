Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC541FEAD8
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgFRFUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:20:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:59432 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgFRFUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 01:20:53 -0400
IronPort-SDR: rGu7ZLDOQu//kT+4gyhLiC3fNeGuDVJJcAMw2u3NW2flcaidkZ/5CKOlQ+UjYoltBbRur2nsfL
 RJRxpRbHQ23Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="160505313"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="160505313"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:13:50 -0700
IronPort-SDR: yjOK5C92848D/udjI2964taELtKbXD5JYxEFUYK7TN8QG0UUYhIBuBB2iObA+EZm7AjmnRzi85
 gC8ehNUdndxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="263495590"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2020 22:13:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] iecm: Add basic netdevice functionality
Date:   Wed, 17 Jun 2020 22:13:34 -0700
Message-Id: <20200618051344.516587-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

This implements probe, interface up/down, and netdev_ops.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iecm/iecm_lib.c    | 404 +++++++++++++++++-
 drivers/net/ethernet/intel/iecm/iecm_main.c   |   7 +-
 drivers/net/ethernet/intel/iecm/iecm_txrx.c   |   6 +-
 .../net/ethernet/intel/iecm/iecm_virtchnl.c   |  73 +++-
 4 files changed, 467 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/iecm/iecm_lib.c b/drivers/net/ethernet/intel/iecm/iecm_lib.c
index 57a20204a7c8..6023d0c727fb 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_lib.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_lib.c
@@ -24,7 +24,17 @@ static void iecm_mb_intr_rel_irq(struct iecm_adapter *adapter)
  */
 static void iecm_intr_rel(struct iecm_adapter *adapter)
 {
-	/* stub */
+	if (!adapter->msix_entries)
+		return;
+	clear_bit(__IECM_MB_INTR_MODE, adapter->flags);
+	clear_bit(__IECM_MB_INTR_TRIGGER, adapter->flags);
+	iecm_mb_intr_rel_irq(adapter);
+
+	pci_free_irq_vectors(adapter->pdev);
+	kfree(adapter->msix_entries);
+	adapter->msix_entries = NULL;
+	kfree(adapter->req_vec_chunks);
+	adapter->req_vec_chunks = NULL;
 }
 
 /**
@@ -96,7 +106,53 @@ void iecm_intr_distribute(struct iecm_adapter *adapter)
  */
 static int iecm_intr_req(struct iecm_adapter *adapter)
 {
-	/* stub */
+	int min_vectors, max_vectors, err = 0;
+	unsigned int vector;
+	int num_vecs;
+	int v_actual;
+
+	num_vecs = adapter->vports[0]->num_q_vectors +
+		   IECM_MAX_NONQ_VEC + IECM_MAX_RDMA_VEC;
+
+	min_vectors = IECM_MIN_VEC;
+#define IECM_MAX_EVV_MAPPED_VEC 16
+	max_vectors = min(num_vecs, IECM_MAX_EVV_MAPPED_VEC);
+
+	v_actual = pci_alloc_irq_vectors(adapter->pdev, min_vectors,
+					 max_vectors, PCI_IRQ_MSIX);
+	if (v_actual < 0) {
+		dev_err(&adapter->pdev->dev, "Failed to allocate MSIX vectors: %d\n",
+			v_actual);
+		return v_actual;
+	}
+
+	adapter->msix_entries = kcalloc(v_actual, sizeof(struct msix_entry),
+					GFP_KERNEL);
+
+	if (!adapter->msix_entries) {
+		pci_free_irq_vectors(adapter->pdev);
+		return -ENOMEM;
+	}
+
+	for (vector = 0; vector < v_actual; vector++) {
+		adapter->msix_entries[vector].entry = vector;
+		adapter->msix_entries[vector].vector =
+			pci_irq_vector(adapter->pdev, vector);
+	}
+	adapter->num_msix_entries = v_actual;
+	adapter->num_req_msix = num_vecs;
+
+	iecm_intr_distribute(adapter);
+
+	err = iecm_mb_intr_init(adapter);
+	if (err)
+		goto intr_rel;
+	iecm_mb_irq_enable(adapter);
+	return err;
+
+intr_rel:
+	iecm_intr_rel(adapter);
+	return err;
 }
 
 /**
@@ -118,7 +174,21 @@ static int iecm_cfg_netdev(struct iecm_vport *vport)
  */
 static int iecm_cfg_hw(struct iecm_adapter *adapter)
 {
-	/* stub */
+	struct pci_dev *pdev = adapter->pdev;
+	struct iecm_hw *hw = &adapter->hw;
+
+	hw->hw_addr_len = pci_resource_len(pdev, 0);
+	hw->hw_addr = ioremap(pci_resource_start(pdev, 0), hw->hw_addr_len);
+
+	if (!hw->hw_addr)
+		return -EIO;
+
+	hw->back = adapter;
+	hw->bus.device = PCI_SLOT(pdev->devfn);
+	hw->bus.func = PCI_FUNC(pdev->devfn);
+	hw->bus.bus_id = pdev->bus->number;
+
+	return 0;
 }
 
 /**
@@ -132,7 +202,22 @@ static int iecm_cfg_hw(struct iecm_adapter *adapter)
  */
 static int iecm_get_free_slot(void *array, int size, int curr)
 {
-	/* stub */
+	int **tmp_array = (int **)array;
+	int next;
+
+	if (curr < (size - 1) && !tmp_array[curr + 1]) {
+		next = curr + 1;
+	} else {
+		int i = 0;
+
+		while ((i < size) && (tmp_array[i]))
+			i++;
+		if (i == size)
+			next = IECM_NO_FREE_SLOT;
+		else
+			next = i;
+	}
+	return next;
 }
 
 /**
@@ -141,7 +226,9 @@ static int iecm_get_free_slot(void *array, int size, int curr)
  */
 struct iecm_vport *iecm_netdev_to_vport(struct net_device *netdev)
 {
-	/* stub */
+	struct iecm_netdev_priv *np = netdev_priv(netdev);
+
+	return np->vport;
 }
 
 /**
@@ -150,7 +237,9 @@ struct iecm_vport *iecm_netdev_to_vport(struct net_device *netdev)
  */
 struct iecm_adapter *iecm_netdev_to_adapter(struct net_device *netdev)
 {
-	/* stub */
+	struct iecm_netdev_priv *np = netdev_priv(netdev);
+
+	return np->vport->adapter;
 }
 
 /**
@@ -185,7 +274,22 @@ static int iecm_stop(struct net_device *netdev)
  */
 int iecm_vport_rel(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter;
+
+	if (!vport->adapter)
+		return -ENODEV;
+	adapter = vport->adapter;
+
+	iecm_vport_stop(vport);
+	iecm_deinit_rss(vport);
+	unregister_netdev(vport->netdev);
+	free_netdev(vport->netdev);
+	vport->netdev = NULL;
+	if (adapter->dev_ops.vc_ops.destroy_vport)
+		adapter->dev_ops.vc_ops.destroy_vport(vport);
+	kfree(vport);
+
+	return 0;
 }
 
 /**
@@ -194,7 +298,24 @@ int iecm_vport_rel(struct iecm_vport *vport)
  */
 static void iecm_vport_rel_all(struct iecm_adapter *adapter)
 {
-	/* stub */
+	int err, i;
+
+	if (!adapter->vports)
+		return;
+
+	for (i = 0; i < adapter->num_alloc_vport; i++) {
+		if (!adapter->vports[i])
+			continue;
+
+		err = iecm_vport_rel(adapter->vports[i]);
+		if (err)
+			dev_dbg(&adapter->pdev->dev,
+				"Failed to release adapter->vport[%d], err %d,\n",
+				i, err);
+		else
+			adapter->vports[i] = NULL;
+	}
+	adapter->num_alloc_vport = 0;
 }
 
 /**
@@ -217,7 +338,47 @@ void iecm_vport_set_hsplit(struct iecm_vport *vport, struct bpf_prog *prog)
 static struct iecm_vport *
 iecm_vport_alloc(struct iecm_adapter *adapter, int vport_id)
 {
-	/* stub */
+	struct iecm_vport *vport = NULL;
+
+	if (adapter->next_vport == IECM_NO_FREE_SLOT)
+		return vport;
+
+	/* Need to protect the allocation of the vports at the adapter level */
+	mutex_lock(&adapter->sw_mutex);
+
+	vport = kzalloc(sizeof(*vport), GFP_KERNEL);
+	if (!vport)
+		goto unlock_adapter;
+
+	vport->adapter = adapter;
+	vport->idx = adapter->next_vport;
+	vport->compln_clean_budget = IECM_TX_COMPLQ_CLEAN_BUDGET;
+	adapter->num_alloc_vport++;
+	adapter->dev_ops.vc_ops.vport_init(vport, vport_id);
+
+	/* Setup default MSIX irq handler for the vport */
+	vport->irq_q_handler = iecm_vport_intr_clean_queues;
+	vport->q_vector_base = IECM_MAX_NONQ_VEC;
+
+	/* fill vport slot in the adapter struct */
+	adapter->vports[adapter->next_vport] = vport;
+	if (iecm_cfg_netdev(vport))
+		goto cfg_netdev_fail;
+
+	/* prepare adapter->next_vport for next use */
+	adapter->next_vport = iecm_get_free_slot(adapter->vports,
+						 adapter->num_alloc_vport,
+						 adapter->next_vport);
+
+	goto unlock_adapter;
+
+cfg_netdev_fail:
+	adapter->vports[adapter->next_vport] = NULL;
+	kfree(vport);
+	vport = NULL;
+unlock_adapter:
+	mutex_unlock(&adapter->sw_mutex);
+	return vport;
 }
 
 /**
@@ -227,7 +388,22 @@ iecm_vport_alloc(struct iecm_adapter *adapter, int vport_id)
  */
 static void iecm_service_task(struct work_struct *work)
 {
-	/* stub */
+	struct iecm_adapter *adapter = container_of(work,
+						    struct iecm_adapter,
+						    serv_task.work);
+
+	if (test_bit(__IECM_MB_INTR_MODE, adapter->flags)) {
+		if (test_and_clear_bit(__IECM_MB_INTR_TRIGGER,
+				       adapter->flags)) {
+			iecm_recv_mb_msg(adapter, VIRTCHNL_OP_UNKNOWN, NULL, 0);
+			iecm_mb_irq_enable(adapter);
+		}
+	} else {
+		iecm_recv_mb_msg(adapter, VIRTCHNL_OP_UNKNOWN, NULL, 0);
+	}
+
+	queue_delayed_work(adapter->serv_wq, &adapter->serv_task,
+			   msecs_to_jiffies(300));
 }
 
 /**
@@ -261,7 +437,41 @@ static int iecm_vport_open(struct iecm_vport *vport)
  */
 static void iecm_init_task(struct work_struct *work)
 {
-	/* stub */
+	struct iecm_adapter *adapter = container_of(work,
+						    struct iecm_adapter,
+						    init_task.work);
+	struct iecm_vport *vport;
+	struct pci_dev *pdev;
+	int vport_id, err;
+
+	err = adapter->dev_ops.vc_ops.core_init(adapter, &vport_id);
+	if (err)
+		return;
+
+	pdev = adapter->pdev;
+	vport = iecm_vport_alloc(adapter, vport_id);
+	if (!vport) {
+		err = -EFAULT;
+		dev_err(&pdev->dev, "probe failed on vport setup:%d\n",
+			err);
+		return;
+	}
+	/* Start the service task before requesting vectors. This will ensure
+	 * vector information response from mailbox is handled
+	 */
+	queue_delayed_work(adapter->serv_wq, &adapter->serv_task,
+			   msecs_to_jiffies(5 * (pdev->devfn & 0x07)));
+	err = iecm_intr_req(adapter);
+	if (err) {
+		dev_err(&pdev->dev, "failed to enable interrupt vectors: %d\n",
+			err);
+		iecm_vport_rel(vport);
+		return;
+	}
+	/* Once state is put into DOWN, driver is ready for dev_open */
+	adapter->state = __IECM_DOWN;
+	if (test_and_clear_bit(__IECM_UP_REQUESTED, adapter->flags))
+		iecm_vport_open(vport);
 }
 
 /**
@@ -272,7 +482,40 @@ static void iecm_init_task(struct work_struct *work)
  */
 static int iecm_api_init(struct iecm_adapter *adapter)
 {
-	/* stub */
+	struct iecm_reg_ops *reg_ops = &adapter->dev_ops.reg_ops;
+	struct pci_dev *pdev = adapter->pdev;
+
+	if (!adapter->dev_ops.reg_ops_init) {
+		dev_err(&pdev->dev, "Invalid device, register API init not defined.\n");
+		return -EINVAL;
+	}
+	adapter->dev_ops.reg_ops_init(adapter);
+	if (!(reg_ops->ctlq_reg_init && reg_ops->vportq_reg_init &&
+	      reg_ops->intr_reg_init && reg_ops->mb_intr_reg_init &&
+	      reg_ops->reset_reg_init && reg_ops->trigger_reset)) {
+		dev_err(&pdev->dev, "Invalid device, missing one or more register functions\n");
+		return -EINVAL;
+	}
+
+	if (adapter->dev_ops.vc_ops_init) {
+		struct iecm_virtchnl_ops *vc_ops;
+
+		adapter->dev_ops.vc_ops_init(adapter);
+		vc_ops = &adapter->dev_ops.vc_ops;
+		if (!(vc_ops->core_init && vc_ops->vport_init &&
+		      vc_ops->vport_queue_ids_init && vc_ops->get_caps &&
+		      vc_ops->config_queues && vc_ops->enable_queues &&
+		      vc_ops->disable_queues && vc_ops->irq_map_unmap &&
+		      vc_ops->get_set_rss_lut && vc_ops->get_set_rss_hash &&
+		      vc_ops->adjust_qs && vc_ops->get_ptype)) {
+			dev_err(&pdev->dev, "Invalid device, missing one or more virtchnl functions\n");
+			return -EINVAL;
+		}
+	} else {
+		iecm_vc_ops_init(adapter);
+	}
+
+	return 0;
 }
 
 /**
@@ -284,7 +527,11 @@ static int iecm_api_init(struct iecm_adapter *adapter)
  */
 void iecm_deinit_task(struct iecm_adapter *adapter)
 {
-	/* stub */
+	iecm_vport_rel_all(adapter);
+	cancel_delayed_work_sync(&adapter->serv_task);
+	iecm_deinit_dflt_mbx(adapter);
+	iecm_vport_params_buf_rel(adapter);
+	iecm_intr_rel(adapter);
 }
 
 /**
@@ -306,7 +553,13 @@ iecm_init_hard_reset(struct iecm_adapter *adapter)
  */
 static void iecm_vc_event_task(struct work_struct *work)
 {
-	/* stub */
+	struct iecm_adapter *adapter = container_of(work,
+						    struct iecm_adapter,
+						    vc_event_task.work);
+
+	if (test_bit(__IECM_HR_CORE_RESET, adapter->flags) ||
+	    test_bit(__IECM_HR_FUNC_RESET, adapter->flags))
+		iecm_init_hard_reset(adapter);
 }
 
 /**
@@ -335,7 +588,103 @@ int iecm_probe(struct pci_dev *pdev,
 	       const struct pci_device_id __always_unused *ent,
 	       struct iecm_adapter *adapter)
 {
-	/* stub */
+	int err;
+
+	adapter->pdev = pdev;
+	err = iecm_api_init(adapter);
+	if (err) {
+		dev_err(&pdev->dev, "Device API is incorrectly configured\n");
+		return err;
+	}
+
+	err = pcim_iomap_regions(pdev, BIT(IECM_BAR0), pci_name(pdev));
+	if (err) {
+		dev_err(&pdev->dev, "BAR0 I/O map error %d\n", err);
+		return err;
+	}
+
+	/* set up for high or low DMA */
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err)
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (err) {
+		dev_err(&pdev->dev, "DMA configuration failed: 0x%x\n", err);
+		return err;
+	}
+
+	pci_enable_pcie_error_reporting(pdev);
+	pci_set_master(pdev);
+	pci_set_drvdata(pdev, adapter);
+
+	adapter->init_wq =
+		alloc_workqueue("%s", WQ_MEM_RECLAIM, 0, KBUILD_MODNAME);
+	if (!adapter->init_wq) {
+		dev_err(&pdev->dev, "Failed to allocate workqueue\n");
+		err = -ENOMEM;
+		goto err_wq_alloc;
+	}
+
+	adapter->serv_wq =
+		alloc_workqueue("%s", WQ_MEM_RECLAIM, 0, KBUILD_MODNAME);
+	if (!adapter->serv_wq) {
+		dev_err(&pdev->dev, "Failed to allocate workqueue\n");
+		err = -ENOMEM;
+		goto err_mbx_wq_alloc;
+	}
+	/* setup msglvl */
+	adapter->msg_enable = netif_msg_init(debug, IECM_DFLT_NETIF_M);
+
+	adapter->vports = kcalloc(IECM_MAX_NUM_VPORTS,
+				  sizeof(*adapter->vports), GFP_KERNEL);
+	if (!adapter->vports) {
+		err = -ENOMEM;
+		goto err_vport_alloc;
+	}
+
+	err = iecm_vport_params_buf_alloc(adapter);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to alloc vport params buffer: %d\n",
+			err);
+		goto err_mb_res;
+	}
+
+	err = iecm_cfg_hw(adapter);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to configure HW structure for adapter: %d\n",
+			err);
+		goto err_cfg_hw;
+	}
+
+	mutex_init(&adapter->sw_mutex);
+	mutex_init(&adapter->vc_msg_lock);
+	mutex_init(&adapter->reset_lock);
+	init_waitqueue_head(&adapter->vchnl_wq);
+
+	INIT_DELAYED_WORK(&adapter->serv_task, iecm_service_task);
+	INIT_DELAYED_WORK(&adapter->init_task, iecm_init_task);
+	INIT_DELAYED_WORK(&adapter->vc_event_task, iecm_vc_event_task);
+
+	mutex_lock(&adapter->reset_lock);
+	set_bit(__IECM_HR_DRV_LOAD, adapter->flags);
+	err = iecm_init_hard_reset(adapter);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to reset device: %d\n", err);
+		goto err_mb_init;
+	}
+
+	return 0;
+err_mb_init:
+err_cfg_hw:
+	iecm_vport_params_buf_rel(adapter);
+err_mb_res:
+	kfree(adapter->vports);
+err_vport_alloc:
+	destroy_workqueue(adapter->serv_wq);
+err_mbx_wq_alloc:
+	destroy_workqueue(adapter->init_wq);
+err_wq_alloc:
+	pci_disable_pcie_error_reporting(pdev);
+	return err;
 }
 EXPORT_SYMBOL(iecm_probe);
 
@@ -345,7 +694,22 @@ EXPORT_SYMBOL(iecm_probe);
  */
 void iecm_remove(struct pci_dev *pdev)
 {
-	/* stub */
+	struct iecm_adapter *adapter = pci_get_drvdata(pdev);
+
+	if (!adapter)
+		return;
+
+	iecm_deinit_task(adapter);
+	cancel_delayed_work_sync(&adapter->vc_event_task);
+	destroy_workqueue(adapter->serv_wq);
+	destroy_workqueue(adapter->init_wq);
+	kfree(adapter->vports);
+	kfree(adapter->vport_params_recvd);
+	kfree(adapter->vport_params_reqd);
+	mutex_destroy(&adapter->sw_mutex);
+	mutex_destroy(&adapter->vc_msg_lock);
+	mutex_destroy(&adapter->reset_lock);
+	pci_disable_pcie_error_reporting(pdev);
 }
 EXPORT_SYMBOL(iecm_remove);
 
@@ -355,7 +719,13 @@ EXPORT_SYMBOL(iecm_remove);
  */
 void iecm_shutdown(struct pci_dev *pdev)
 {
-	/* stub */
+	struct iecm_adapter *adapter;
+
+	adapter = pci_get_drvdata(pdev);
+	adapter->state = __IECM_REMOVE;
+
+	if (system_state == SYSTEM_POWER_OFF)
+		pci_set_power_state(pdev, PCI_D3hot);
 }
 EXPORT_SYMBOL(iecm_shutdown);
 
diff --git a/drivers/net/ethernet/intel/iecm/iecm_main.c b/drivers/net/ethernet/intel/iecm/iecm_main.c
index 0644581fc746..3b6eb44643de 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_main.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_main.c
@@ -30,7 +30,10 @@ MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all)");
  */
 static int __init iecm_module_init(void)
 {
-	/* stub */
+	pr_info("%s\n", iecm_driver_string);
+	pr_info("%s\n", iecm_copyright);
+
+	return 0;
 }
 module_init(iecm_module_init);
 
@@ -42,6 +45,6 @@ module_init(iecm_module_init);
  */
 static void __exit iecm_module_exit(void)
 {
-	/* stub */
+	pr_info("module unloaded\n");
 }
 module_exit(iecm_module_exit);
diff --git a/drivers/net/ethernet/intel/iecm/iecm_txrx.c b/drivers/net/ethernet/intel/iecm/iecm_txrx.c
index b4688daa744d..0d684adc15e5 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_txrx.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_txrx.c
@@ -989,7 +989,11 @@ static int iecm_rx_splitq_clean(struct iecm_queue *rxq, int budget)
 irqreturn_t
 iecm_vport_intr_clean_queues(int __always_unused irq, void *data)
 {
-	/* stub */
+	struct iecm_q_vector *q_vector = (struct iecm_q_vector *)data;
+
+	napi_schedule(&q_vector->napi);
+
+	return IRQ_HANDLED;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
index 271009350503..7bf7c02f2d6f 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
@@ -418,7 +418,47 @@ void iecm_deinit_dflt_mbx(struct iecm_adapter *adapter)
  */
 enum iecm_status iecm_init_dflt_mbx(struct iecm_adapter *adapter)
 {
-	/* stub */
+	struct iecm_ctlq_create_info ctlq_info[] = {
+		{
+			.type = IECM_CTLQ_TYPE_MAILBOX_TX,
+			.id = IECM_DFLT_MBX_ID,
+			.len = IECM_DFLT_MBX_Q_LEN,
+			.buf_size = IECM_DFLT_MBX_BUF_SIZE
+		},
+		{
+			.type = IECM_CTLQ_TYPE_MAILBOX_RX,
+			.id = IECM_DFLT_MBX_ID,
+			.len = IECM_DFLT_MBX_Q_LEN,
+			.buf_size = IECM_DFLT_MBX_BUF_SIZE
+		}
+	};
+	struct iecm_hw *hw = &adapter->hw;
+	enum iecm_status ret;
+
+	adapter->dev_ops.reg_ops.ctlq_reg_init(ctlq_info);
+
+#define NUM_Q 2
+	ret = iecm_ctlq_init(hw, NUM_Q, ctlq_info);
+	if (ret)
+		goto init_mbx_done;
+
+	hw->asq = iecm_find_ctlq(hw, IECM_CTLQ_TYPE_MAILBOX_TX,
+				 IECM_DFLT_MBX_ID);
+	hw->arq = iecm_find_ctlq(hw, IECM_CTLQ_TYPE_MAILBOX_RX,
+				 IECM_DFLT_MBX_ID);
+
+	if (!hw->asq || !hw->arq) {
+		iecm_ctlq_deinit(hw);
+		ret = IECM_ERR_CTLQ_ERROR;
+	}
+	adapter->state = __IECM_STARTUP;
+	/* Skew the delay for init tasks for each function based on fn number
+	 * to prevent every function from making the same call simultaneously.
+	 */
+	queue_delayed_work(adapter->init_wq, &adapter->init_task,
+			   msecs_to_jiffies(5 * (adapter->pdev->devfn & 0x07)));
+init_mbx_done:
+	return ret;
 }
 
 /**
@@ -440,7 +480,15 @@ int iecm_vport_params_buf_alloc(struct iecm_adapter *adapter)
  */
 void iecm_vport_params_buf_rel(struct iecm_adapter *adapter)
 {
-	/* stub */
+	int i = 0;
+
+	for (i = 0; i < IECM_MAX_NUM_VPORTS; i++) {
+		kfree(adapter->vport_params_recvd[i]);
+		kfree(adapter->vport_params_reqd[i]);
+	}
+
+	kfree(adapter->caps);
+	kfree(adapter->config_data.req_qs_chunks);
 }
 
 /**
@@ -565,6 +613,25 @@ static bool iecm_is_capability_ena(struct iecm_adapter *adapter, u64 flag)
  */
 void iecm_vc_ops_init(struct iecm_adapter *adapter)
 {
-	/* stub */
+	adapter->dev_ops.vc_ops.core_init = iecm_vc_core_init;
+	adapter->dev_ops.vc_ops.vport_init = iecm_vport_init;
+	adapter->dev_ops.vc_ops.vport_queue_ids_init =
+		iecm_vport_queue_ids_init;
+	adapter->dev_ops.vc_ops.get_caps = iecm_send_get_caps_msg;
+	adapter->dev_ops.vc_ops.is_cap_ena = iecm_is_capability_ena;
+	adapter->dev_ops.vc_ops.config_queues = iecm_send_config_queues_msg;
+	adapter->dev_ops.vc_ops.enable_queues = iecm_send_enable_queues_msg;
+	adapter->dev_ops.vc_ops.disable_queues = iecm_send_disable_queues_msg;
+	adapter->dev_ops.vc_ops.irq_map_unmap =
+		iecm_send_map_unmap_queue_vector_msg;
+	adapter->dev_ops.vc_ops.enable_vport = iecm_send_enable_vport_msg;
+	adapter->dev_ops.vc_ops.disable_vport = iecm_send_disable_vport_msg;
+	adapter->dev_ops.vc_ops.destroy_vport = iecm_send_destroy_vport_msg;
+	adapter->dev_ops.vc_ops.get_ptype = iecm_send_get_rx_ptype_msg;
+	adapter->dev_ops.vc_ops.get_set_rss_lut = iecm_send_get_set_rss_lut_msg;
+	adapter->dev_ops.vc_ops.get_set_rss_hash =
+		iecm_send_get_set_rss_hash_msg;
+	adapter->dev_ops.vc_ops.adjust_qs = iecm_vport_adjust_qs;
+	adapter->dev_ops.vc_ops.recv_mbx_msg = NULL;
 }
 EXPORT_SYMBOL(iecm_vc_ops_init);
-- 
2.26.2

