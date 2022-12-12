Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960D3649E02
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiLLLgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiLLLfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:35:52 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B28FACE
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670844792; x=1702380792;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4qBemkVgf2MyuQqqTXIr8Z6qQK7bf5sqdrIdEFaqAkQ=;
  b=KTEfmA4iytcZ+uypHb6j/k4g/3kUPHiUtTPQWvVt1fGUb6H0wnp8U8UO
   hPoB/4KfR1kyL0sQ4mSaNqiSrkYNBIjJuG9HGK+vX0TRS0DqvzZKBfvkn
   hIrXogsifLf9VVjKgZUVeRAv7knkIShInbsNh4NxgSZu4zYN9h8qW4bBs
   0REQBrTd38dxc/hPi7M+kUE62iW7WDTepJ6pnq7HVlKVJcFxwGiTYMYPR
   R98OpfP4zAbsfH3kzkqP694noW0MUMpUpnh6YhVECtL3Kjzrq1qrmuaoC
   33kLwTeKvl0l5fd/uYDbQ/LZPtP0jznWYEvnbzJ7ep2kn4gxPOpO2Sfoz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="317861500"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="317861500"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 03:33:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="893459797"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="893459797"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by fmsmga006.fm.intel.com with ESMTP; 12 Dec 2022 03:33:07 -0800
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
Subject: [PATCH net-next v1 06/10] ice: split probe into smaller functions
Date:   Mon, 12 Dec 2022 12:16:41 +0100
Message-Id: <20221212111645.1198680-7-michal.swiatkowski@linux.intel.com>
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

Part of code from probe can be reused in reload flow. Move this code to
separate function. Create unroll functions for each part of
initialization, like: ice_init_dev() and ice_deinit_dev(). It
simplifies unrolling and can be used in remove flow.

Avoid freeing port info as it could be reused in reload path.
Will be freed in remove path since is allocated via devm_kzalloc().

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h        |   2 +
 drivers/net/ethernet/intel/ice/ice_common.c |  11 +-
 drivers/net/ethernet/intel/ice/ice_main.c   | 897 ++++++++++++--------
 3 files changed, 559 insertions(+), 351 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 70a9609f1b80..99c7003d9f35 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -933,6 +933,8 @@ int ice_open(struct net_device *netdev);
 int ice_open_internal(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
 void ice_service_task_schedule(struct ice_pf *pf);
+int ice_load(struct ice_pf *pf);
+void ice_unload(struct ice_pf *pf);
 
 /**
  * ice_set_rdma_cap - enable RDMA support
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 0e9584e50d82..dd1c9bf20c0a 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1113,8 +1113,10 @@ int ice_init_hw(struct ice_hw *hw)
 	if (status)
 		goto err_unroll_cqinit;
 
-	hw->port_info = devm_kzalloc(ice_hw_to_dev(hw),
-				     sizeof(*hw->port_info), GFP_KERNEL);
+	if (!hw->port_info)
+		hw->port_info = devm_kzalloc(ice_hw_to_dev(hw),
+					     sizeof(*hw->port_info),
+					     GFP_KERNEL);
 	if (!hw->port_info) {
 		status = -ENOMEM;
 		goto err_unroll_cqinit;
@@ -1242,11 +1244,6 @@ void ice_deinit_hw(struct ice_hw *hw)
 	ice_free_hw_tbls(hw);
 	mutex_destroy(&hw->tnl_lock);
 
-	if (hw->port_info) {
-		devm_kfree(ice_hw_to_dev(hw), hw->port_info);
-		hw->port_info = NULL;
-	}
-
 	/* Attempt to disable FW logging before shutting down control queues */
 	ice_cfg_fw_log(hw, false);
 	ice_destroy_all_ctrlq(hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8e648b2b34d9..d8f51aee78ff 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3428,53 +3428,6 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	netdev->hw_features |= NETIF_F_RXFCS;
 }
 
-/**
- * ice_cfg_netdev - Allocate, configure and register a netdev
- * @vsi: the VSI associated with the new netdev
- *
- * Returns 0 on success, negative value on failure
- */
-static int ice_cfg_netdev(struct ice_vsi *vsi)
-{
-	struct ice_netdev_priv *np;
-	struct net_device *netdev;
-	u8 mac_addr[ETH_ALEN];
-
-	netdev = alloc_etherdev_mqs(sizeof(*np), vsi->alloc_txq,
-				    vsi->alloc_rxq);
-	if (!netdev)
-		return -ENOMEM;
-
-	set_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
-	vsi->netdev = netdev;
-	np = netdev_priv(netdev);
-	np->vsi = vsi;
-
-	ice_set_netdev_features(netdev);
-
-	ice_set_ops(netdev);
-
-	if (vsi->type == ICE_VSI_PF) {
-		SET_NETDEV_DEV(netdev, ice_pf_to_dev(vsi->back));
-		ether_addr_copy(mac_addr, vsi->port_info->mac.perm_addr);
-		eth_hw_addr_set(netdev, mac_addr);
-		ether_addr_copy(netdev->perm_addr, mac_addr);
-	}
-
-	netdev->priv_flags |= IFF_UNICAST_FLT;
-
-	/* Setup netdev TC information */
-	ice_vsi_cfg_netdev_tc(vsi, vsi->tc_cfg.ena_tc);
-
-	/* setup watchdog timeout value to be 5 second */
-	netdev->watchdog_timeo = 5 * HZ;
-
-	netdev->min_mtu = ETH_MIN_MTU;
-	netdev->max_mtu = ICE_MAX_MTU;
-
-	return 0;
-}
-
 /**
  * ice_fill_rss_lut - Fill the RSS lookup table with default values
  * @lut: Lookup table
@@ -3727,76 +3680,6 @@ static int ice_tc_indir_block_register(struct ice_vsi *vsi)
 	return flow_indr_dev_register(ice_indr_setup_tc_cb, np);
 }
 
-/**
- * ice_setup_pf_sw - Setup the HW switch on startup or after reset
- * @pf: board private structure
- *
- * Returns 0 on success, negative value on failure
- */
-static int ice_setup_pf_sw(struct ice_pf *pf)
-{
-	struct device *dev = ice_pf_to_dev(pf);
-	bool dvm = ice_is_dvm_ena(&pf->hw);
-	struct ice_vsi *vsi;
-	int status;
-
-	if (ice_is_reset_in_progress(pf->state))
-		return -EBUSY;
-
-	status = ice_aq_set_port_params(pf->hw.port_info, dvm, NULL);
-	if (status)
-		return -EIO;
-
-	vsi = ice_pf_vsi_setup(pf, pf->hw.port_info);
-	if (!vsi)
-		return -ENOMEM;
-
-	/* init channel list */
-	INIT_LIST_HEAD(&vsi->ch_list);
-
-	status = ice_cfg_netdev(vsi);
-	if (status)
-		goto unroll_vsi_setup;
-	/* netdev has to be configured before setting frame size */
-	ice_vsi_cfg_frame_size(vsi);
-
-	/* init indirect block notifications */
-	status = ice_tc_indir_block_register(vsi);
-	if (status) {
-		dev_err(dev, "Failed to register netdev notifier\n");
-		goto unroll_cfg_netdev;
-	}
-
-	/* Setup DCB netlink interface */
-	ice_dcbnl_setup(vsi);
-
-	/* registering the NAPI handler requires both the queues and
-	 * netdev to be created, which are done in ice_pf_vsi_setup()
-	 * and ice_cfg_netdev() respectively
-	 */
-	ice_napi_add(vsi);
-
-	status = ice_init_mac_fltr(pf);
-	if (status)
-		goto unroll_napi_add;
-
-	return 0;
-
-unroll_napi_add:
-	ice_tc_indir_block_unregister(vsi);
-unroll_cfg_netdev:
-	ice_napi_del(vsi);
-	if (vsi->netdev) {
-		clear_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
-		free_netdev(vsi->netdev);
-		vsi->netdev = NULL;
-	}
-
-unroll_vsi_setup:
-	ice_vsi_release(vsi);
-	return status;
-}
-
 /**
  * ice_get_avail_q_count - Get count of queues in use
  * @pf_qmap: bitmap to get queue use count from
@@ -4494,6 +4377,21 @@ static int ice_init_fdir(struct ice_pf *pf)
 	return err;
 }
 
+static void ice_deinit_fdir(struct ice_pf *pf)
+{
+	struct ice_vsi *vsi = ice_get_ctrl_vsi(pf);
+
+	if (!vsi)
+		return;
+
+	ice_vsi_manage_fdir(vsi, false);
+	ice_vsi_release(vsi);
+	if (pf->ctrl_vsi_idx != ICE_NO_VSI) {
+		pf->vsi[pf->ctrl_vsi_idx] = NULL;
+		pf->ctrl_vsi_idx = ICE_NO_VSI;
+	}
+}
+
 /**
  * ice_get_opt_fw_name - return optional firmware file name or NULL
  * @pf: pointer to the PF instance
@@ -4663,133 +4561,198 @@ static void ice_print_wake_reason(struct ice_pf *pf)
 
 /**
  * ice_register_netdev - register netdev
- * @pf: pointer to the PF struct
+ * @vsi: pointer to the VSI struct
  */
-static int ice_register_netdev(struct ice_pf *pf)
+static int ice_register_netdev(struct ice_vsi *vsi)
 {
-	struct ice_vsi *vsi;
-	int err = 0;
+	int err;
 
-	vsi = ice_get_main_vsi(pf);
 	if (!vsi || !vsi->netdev)
 		return -EIO;
 
 	err = register_netdev(vsi->netdev);
 	if (err)
-		goto err_register_netdev;
+		return err;
 
 	set_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
 	netif_carrier_off(vsi->netdev);
 	netif_tx_stop_all_queues(vsi->netdev);
 
 	return 0;
-err_register_netdev:
-	free_netdev(vsi->netdev);
-	vsi->netdev = NULL;
-	clear_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
-	return err;
+}
+
+static void ice_unregister_netdev(struct ice_vsi *vsi)
+{
+	if (!vsi || !vsi->netdev)
+		return;
+
+	unregister_netdev(vsi->netdev);
+	clear_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
 }
 
 /**
- * ice_probe - Device initialization routine
- * @pdev: PCI device information struct
- * @ent: entry in ice_pci_tbl
+ * ice_cfg_netdev - Allocate, configure and register a netdev
+ * @vsi: the VSI associated with the new netdev
  *
- * Returns 0 on success, negative on failure
+ * Returns 0 on success, negative value on failure
  */
-static int
-ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
+static int ice_cfg_netdev(struct ice_vsi *vsi)
 {
-	struct device *dev = &pdev->dev;
-	struct ice_vsi *vsi;
-	struct ice_pf *pf;
-	struct ice_hw *hw;
-	int i, err;
+	struct ice_netdev_priv *np;
+	struct net_device *netdev;
+	u8 mac_addr[ETH_ALEN];
 
-	if (pdev->is_virtfn) {
-		dev_err(dev, "can't probe a virtual function\n");
-		return -EINVAL;
-	}
+	netdev = alloc_etherdev_mqs(sizeof(*np), vsi->alloc_txq,
+				    vsi->alloc_rxq);
+	if (!netdev)
+		return -ENOMEM;
 
-	/* this driver uses devres, see
-	 * Documentation/driver-api/driver-model/devres.rst
-	 */
-	err = pcim_enable_device(pdev);
-	if (err)
-		return err;
+	set_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
+	vsi->netdev = netdev;
+	np = netdev_priv(netdev);
+	np->vsi = vsi;
 
-	err = pcim_iomap_regions(pdev, BIT(ICE_BAR0), dev_driver_string(dev));
-	if (err) {
-		dev_err(dev, "BAR0 I/O map error %d\n", err);
-		return err;
+	ice_set_netdev_features(netdev);
+	ice_set_ops(netdev);
+
+	if (vsi->type == ICE_VSI_PF) {
+		SET_NETDEV_DEV(netdev, ice_pf_to_dev(vsi->back));
+		ether_addr_copy(mac_addr, vsi->port_info->mac.perm_addr);
+		eth_hw_addr_set(netdev, mac_addr);
 	}
 
-	pf = ice_allocate_pf(dev);
-	if (!pf)
-		return -ENOMEM;
+	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	/* initialize Auxiliary index to invalid value */
-	pf->aux_idx = -1;
+	/* Setup netdev TC information */
+	ice_vsi_cfg_netdev_tc(vsi, vsi->tc_cfg.ena_tc);
 
-	/* set up for high or low DMA */
-	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
-	if (err) {
-		dev_err(dev, "DMA configuration failed: 0x%x\n", err);
+	netdev->max_mtu = ICE_MAX_MTU;
+
+	return 0;
+}
+
+static void ice_decfg_netdev(struct ice_vsi *vsi)
+{
+	clear_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
+	free_netdev(vsi->netdev);
+	vsi->netdev = NULL;
+}
+
+static int ice_start_eth(struct ice_vsi *vsi)
+{
+	int err;
+
+	err = ice_init_mac_fltr(vsi->back);
+	if (err)
 		return err;
-	}
 
-	pci_enable_pcie_error_reporting(pdev);
-	pci_set_master(pdev);
+	rtnl_lock();
+	err = ice_vsi_open(vsi);
+	rtnl_unlock();
 
-	pf->pdev = pdev;
-	pci_set_drvdata(pdev, pf);
-	set_bit(ICE_DOWN, pf->state);
-	/* Disable service task until DOWN bit is cleared */
-	set_bit(ICE_SERVICE_DIS, pf->state);
+	return err;
+}
 
-	hw = &pf->hw;
-	hw->hw_addr = pcim_iomap_table(pdev)[ICE_BAR0];
-	pci_save_state(pdev);
+static int ice_init_eth(struct ice_pf *pf)
+{
+	struct ice_vsi *vsi = ice_get_main_vsi(pf);
+	struct device *dev = ice_pf_to_dev(pf);
+	int err;
 
-	hw->back = pf;
-	hw->vendor_id = pdev->vendor;
-	hw->device_id = pdev->device;
-	pci_read_config_byte(pdev, PCI_REVISION_ID, &hw->revision_id);
-	hw->subsystem_vendor_id = pdev->subsystem_vendor;
-	hw->subsystem_device_id = pdev->subsystem_device;
-	hw->bus.device = PCI_SLOT(pdev->devfn);
-	hw->bus.func = PCI_FUNC(pdev->devfn);
-	ice_set_ctrlq_len(hw);
+	if (!vsi)
+		return -EINVAL;
 
-	pf->msg_enable = netif_msg_init(debug, ICE_DFLT_NETIF_M);
+	/* init channel list */
+	INIT_LIST_HEAD(&vsi->ch_list);
 
-#ifndef CONFIG_DYNAMIC_DEBUG
-	if (debug < -1)
-		hw->debug_mask = debug;
-#endif
+	err = ice_cfg_netdev(vsi);
+	if (err)
+		return err;
+	/* Setup DCB netlink interface */
+	ice_dcbnl_setup(vsi);
 
-	err = ice_init_hw(hw);
+	err = ice_set_cpu_rx_rmap(vsi);
 	if (err) {
-		dev_err(dev, "ice_init_hw failed: %d\n", err);
-		err = -EIO;
-		goto err_exit_unroll;
+		dev_err(dev, "Failed to set CPU Rx map VSI %d error %d\n",
+			vsi->vsi_num, err);
+		goto err_set_cpu_rx_rmap;
 	}
+	err = ice_init_mac_fltr(pf);
+	if (err)
+		goto err_init_mac_fltr;
 
-	ice_init_feature_support(pf);
+	err = ice_devlink_create_pf_port(pf);
+	if (err)
+		goto err_devlink_create_pf_port;
 
-	err = ice_init_ddp_config(hw, pf);
+	SET_NETDEV_DEVLINK_PORT(vsi->netdev, &pf->devlink_port);
 
-	/* during topology change ice_init_hw may fail */
-	if (err) {
-		err = -EIO;
-		goto err_exit_unroll;
-	}
+	err = ice_register_netdev(vsi);
+	if (err)
+		goto err_register_netdev;
 
-	/* if ice_init_ddp_config fails, ICE_FLAG_ADV_FEATURES bit won't be
-	 * set in pf->state, which will cause ice_is_safe_mode to return
-	 * true
-	 */
-	if (ice_is_safe_mode(pf)) {
+	err = ice_tc_indir_block_register(vsi);
+	if (err)
+		goto err_tc_indir_block_register;
+
+	ice_napi_add(vsi);
+
+	return 0;
+
+err_tc_indir_block_register:
+	ice_unregister_netdev(vsi);
+err_register_netdev:
+	ice_devlink_destroy_pf_port(pf);
+err_devlink_create_pf_port:
+err_init_mac_fltr:
+	ice_free_cpu_rx_rmap(vsi);
+err_set_cpu_rx_rmap:
+	ice_decfg_netdev(vsi);
+	return err;
+}
+
+static void ice_deinit_eth(struct ice_pf *pf)
+{
+	struct ice_vsi *vsi = ice_get_main_vsi(pf);
+
+	if (!vsi)
+		return;
+
+	ice_vsi_close(vsi);
+	ice_unregister_netdev(vsi);
+	ice_devlink_destroy_pf_port(pf);
+	ice_free_cpu_rx_rmap(vsi);
+	ice_tc_indir_block_unregister(vsi);
+	ice_decfg_netdev(vsi);
+}
+
+static int ice_init_dev(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	int err;
+
+	err = ice_init_hw(hw);
+	if (err) {
+		dev_err(dev, "ice_init_hw failed: %d\n", err);
+		return err;
+	}
+
+	ice_init_feature_support(pf);
+
+	err = ice_init_ddp_config(hw, pf);
+
+	/* during topology change ice_init_hw may fail */
+	if (err) {
+		err = -EIO;
+		goto err_init_pf;
+	}
+
+	/* if ice_init_ddp_config fails, ICE_FLAG_ADV_FEATURES bit won't be
+	 * set in pf->state, which will cause ice_is_safe_mode to return
+	 * true
+	 */
+	if (ice_is_safe_mode(pf)) {
 		/* we already got function/device capabilities but these don't
 		 * reflect what the driver needs to do in safe mode. Instead of
 		 * adding conditional logic everywhere to ignore these
@@ -4801,62 +4764,38 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	err = ice_init_pf(pf);
 	if (err) {
 		dev_err(dev, "ice_init_pf failed: %d\n", err);
-		goto err_init_pf_unroll;
+		goto err_init_pf;
 	}
 
-	ice_devlink_init_regions(pf);
-
 	pf->hw.udp_tunnel_nic.set_port = ice_udp_tunnel_set_port;
 	pf->hw.udp_tunnel_nic.unset_port = ice_udp_tunnel_unset_port;
 	pf->hw.udp_tunnel_nic.flags = UDP_TUNNEL_NIC_INFO_MAY_SLEEP;
 	pf->hw.udp_tunnel_nic.shared = &pf->hw.udp_tunnel_shared;
-	i = 0;
 	if (pf->hw.tnl.valid_count[TNL_VXLAN]) {
-		pf->hw.udp_tunnel_nic.tables[i].n_entries =
+		pf->hw.udp_tunnel_nic.tables[0].n_entries =
 			pf->hw.tnl.valid_count[TNL_VXLAN];
-		pf->hw.udp_tunnel_nic.tables[i].tunnel_types =
+		pf->hw.udp_tunnel_nic.tables[0].tunnel_types =
 			UDP_TUNNEL_TYPE_VXLAN;
-		i++;
 	}
 	if (pf->hw.tnl.valid_count[TNL_GENEVE]) {
-		pf->hw.udp_tunnel_nic.tables[i].n_entries =
+		pf->hw.udp_tunnel_nic.tables[1].n_entries =
 			pf->hw.tnl.valid_count[TNL_GENEVE];
-		pf->hw.udp_tunnel_nic.tables[i].tunnel_types =
+		pf->hw.udp_tunnel_nic.tables[1].tunnel_types =
 			UDP_TUNNEL_TYPE_GENEVE;
-		i++;
-	}
-
-	pf->num_alloc_vsi = hw->func_caps.guar_num_vsi;
-	if (!pf->num_alloc_vsi) {
-		err = -EIO;
-		goto err_init_pf_unroll;
-	}
-	if (pf->num_alloc_vsi > UDP_TUNNEL_NIC_MAX_SHARING_DEVICES) {
-		dev_warn(&pf->pdev->dev,
-			 "limiting the VSI count due to UDP tunnel limitation %d > %d\n",
-			 pf->num_alloc_vsi, UDP_TUNNEL_NIC_MAX_SHARING_DEVICES);
-		pf->num_alloc_vsi = UDP_TUNNEL_NIC_MAX_SHARING_DEVICES;
-	}
-
-	pf->vsi = devm_kcalloc(dev, pf->num_alloc_vsi, sizeof(*pf->vsi),
-			       GFP_KERNEL);
-	if (!pf->vsi) {
-		err = -ENOMEM;
-		goto err_init_pf_unroll;
 	}
 
 	pf->vsi_stats = devm_kcalloc(dev, pf->num_alloc_vsi,
 				     sizeof(*pf->vsi_stats), GFP_KERNEL);
 	if (!pf->vsi_stats) {
 		err = -ENOMEM;
-		goto err_init_vsi_unroll;
+		goto err_alloc_stats;
 	}
 
 	err = ice_init_interrupt_scheme(pf);
 	if (err) {
 		dev_err(dev, "ice_init_interrupt_scheme failed: %d\n", err);
 		err = -EIO;
-		goto err_init_vsi_stats_unroll;
+		goto err_init_interrupt_scheme;
 	}
 
 	/* In case of MSIX we are going to setup the misc vector right here
@@ -4867,49 +4806,96 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	err = ice_req_irq_msix_misc(pf);
 	if (err) {
 		dev_err(dev, "setup of misc vector failed: %d\n", err);
-		goto err_init_interrupt_unroll;
+		goto err_req_irq_msix_misc;
 	}
 
-	/* create switch struct for the switch element created by FW on boot */
-	pf->first_sw = devm_kzalloc(dev, sizeof(*pf->first_sw), GFP_KERNEL);
-	if (!pf->first_sw) {
-		err = -ENOMEM;
-		goto err_msix_misc_unroll;
-	}
+	return 0;
 
-	if (hw->evb_veb)
-		pf->first_sw->bridge_mode = BRIDGE_MODE_VEB;
-	else
-		pf->first_sw->bridge_mode = BRIDGE_MODE_VEPA;
+err_req_irq_msix_misc:
+	ice_clear_interrupt_scheme(pf);
+err_init_interrupt_scheme:
+	devm_kfree(dev, pf->vsi_stats);
+err_alloc_stats:
+	ice_deinit_pf(pf);
+err_init_pf:
+	ice_deinit_hw(hw);
+	return err;
+}
 
-	pf->first_sw->pf = pf;
+static void ice_deinit_dev(struct ice_pf *pf)
+{
+	ice_free_irq_msix_misc(pf);
+	ice_clear_interrupt_scheme(pf);
+	ice_deinit_pf(pf);
+	ice_deinit_hw(&pf->hw);
+}
 
-	/* record the sw_id available for later use */
-	pf->first_sw->sw_id = hw->port_info->sw_id;
+static void ice_init_features(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
 
-	err = ice_setup_pf_sw(pf);
-	if (err) {
-		dev_err(dev, "probe failed due to setup PF switch: %d\n", err);
-		goto err_alloc_sw_unroll;
-	}
+	if (ice_is_safe_mode(pf))
+		return;
 
-	clear_bit(ICE_SERVICE_DIS, pf->state);
+	/* initialize DDP driven features */
+	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
+		ice_ptp_init(pf);
 
-	/* tell the firmware we are up */
-	err = ice_send_version(pf);
-	if (err) {
-		dev_err(dev, "probe failed sending driver version %s. error: %d\n",
-			UTS_RELEASE, err);
-		goto err_send_version_unroll;
+	if (ice_is_feature_supported(pf, ICE_F_GNSS))
+		ice_gnss_init(pf);
+
+	/* Note: Flow director init failure is non-fatal to load */
+	if (ice_init_fdir(pf))
+		dev_err(dev, "could not initialize flow director\n");
+
+	/* Note: DCB init failure is non-fatal to load */
+	if (ice_init_pf_dcb(pf, false)) {
+		clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
+		clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
+	} else {
+		ice_cfg_lldp_mib_change(&pf->hw, true);
 	}
 
-	/* since everything is good, start the service timer */
-	mod_timer(&pf->serv_tmr, round_jiffies(jiffies + pf->serv_tmr_period));
+	if (ice_init_lag(pf))
+		dev_warn(dev, "Failed to init link aggregation support\n");
+}
+
+static void ice_deinit_features(struct ice_pf *pf)
+{
+	ice_deinit_lag(pf);
+	if (test_bit(ICE_FLAG_DCB_CAPABLE, pf->flags))
+		ice_cfg_lldp_mib_change(&pf->hw, false);
+	ice_deinit_fdir(pf);
+	if (ice_is_feature_supported(pf, ICE_F_GNSS))
+		ice_gnss_exit(pf);
+	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
+		ice_ptp_release(pf);
+}
+
+static void ice_init_wakeup(struct ice_pf *pf)
+{
+	/* Save wakeup reason register for later use */
+	pf->wakeup_reason = rd32(&pf->hw, PFPM_WUS);
+
+	/* check for a power management event */
+	ice_print_wake_reason(pf);
+
+	/* clear wake status, all bits */
+	wr32(&pf->hw, PFPM_WUS, U32_MAX);
+
+	/* Disable WoL at init, wait for user to enable */
+	device_set_wakeup_enable(ice_pf_to_dev(pf), false);
+}
+
+static int ice_init_link(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	int err;
 
 	err = ice_init_link_events(pf->hw.port_info);
 	if (err) {
 		dev_err(dev, "ice_init_link_events failed: %d\n", err);
-		goto err_send_version_unroll;
+		return err;
 	}
 
 	/* not a fatal error if this fails */
@@ -4945,106 +4931,336 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		set_bit(ICE_FLAG_NO_MEDIA, pf->flags);
 	}
 
-	ice_verify_cacheline_size(pf);
+	return err;
+}
 
-	/* Save wakeup reason register for later use */
-	pf->wakeup_reason = rd32(hw, PFPM_WUS);
+static int ice_init_pf_sw(struct ice_pf *pf)
+{
+	bool dvm = ice_is_dvm_ena(&pf->hw);
+	struct ice_vsi *vsi;
+	int err;
 
-	/* check for a power management event */
-	ice_print_wake_reason(pf);
+	/* create switch struct for the switch element created by FW on boot */
+	pf->first_sw = kzalloc(sizeof(*pf->first_sw), GFP_KERNEL);
+	if (!pf->first_sw)
+		return -ENOMEM;
 
-	/* clear wake status, all bits */
-	wr32(hw, PFPM_WUS, U32_MAX);
+	if (pf->hw.evb_veb)
+		pf->first_sw->bridge_mode = BRIDGE_MODE_VEB;
+	else
+		pf->first_sw->bridge_mode = BRIDGE_MODE_VEPA;
 
-	/* Disable WoL at init, wait for user to enable */
-	device_set_wakeup_enable(dev, false);
+	pf->first_sw->pf = pf;
 
-	if (ice_is_safe_mode(pf)) {
-		ice_set_safe_mode_vlan_cfg(pf);
-		goto probe_done;
+	/* record the sw_id available for later use */
+	pf->first_sw->sw_id = pf->hw.port_info->sw_id;
+
+	err = ice_aq_set_port_params(pf->hw.port_info, dvm, NULL);
+	if (err)
+		goto err_aq_set_port_params;
+
+	vsi = ice_pf_vsi_setup(pf, pf->hw.port_info);
+	if (!vsi) {
+		err = -ENOMEM;
+		goto err_pf_vsi_setup;
 	}
 
-	/* initialize DDP driven features */
-	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
-		ice_ptp_init(pf);
+	return 0;
 
-	if (ice_is_feature_supported(pf, ICE_F_GNSS))
-		ice_gnss_init(pf);
+err_pf_vsi_setup:
+err_aq_set_port_params:
+	kfree(pf->first_sw);
+	return err;
+}
 
-	/* Note: Flow director init failure is non-fatal to load */
-	if (ice_init_fdir(pf))
-		dev_err(dev, "could not initialize flow director\n");
+static void ice_deinit_pf_sw(struct ice_pf *pf)
+{
+	struct ice_vsi *vsi = ice_get_main_vsi(pf);
 
-	/* Note: DCB init failure is non-fatal to load */
-	if (ice_init_pf_dcb(pf, false)) {
-		clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
-		clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
-	} else {
-		ice_cfg_lldp_mib_change(&pf->hw, true);
+	if (!vsi)
+		return;
+
+	ice_vsi_release(vsi);
+	kfree(pf->first_sw);
+}
+
+static int ice_alloc_vsis(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+
+	pf->num_alloc_vsi = pf->hw.func_caps.guar_num_vsi;
+	if (!pf->num_alloc_vsi)
+		return -EIO;
+
+	if (pf->num_alloc_vsi > UDP_TUNNEL_NIC_MAX_SHARING_DEVICES) {
+		dev_warn(dev,
+			 "limiting the VSI count due to UDP tunnel limitation %d > %d\n",
+			 pf->num_alloc_vsi, UDP_TUNNEL_NIC_MAX_SHARING_DEVICES);
+		pf->num_alloc_vsi = UDP_TUNNEL_NIC_MAX_SHARING_DEVICES;
 	}
 
-	if (ice_init_lag(pf))
-		dev_warn(dev, "Failed to init link aggregation support\n");
+	pf->vsi = devm_kcalloc(dev, pf->num_alloc_vsi, sizeof(*pf->vsi),
+			       GFP_KERNEL);
+	if (!pf->vsi)
+		return -ENOMEM;
 
-	/* print PCI link speed and width */
-	pcie_print_link_status(pf->pdev);
+	return 0;
+}
 
-probe_done:
-	err = ice_devlink_create_pf_port(pf);
+static void ice_dealloc_vsis(struct ice_pf *pf)
+{
+	pf->num_alloc_vsi = 0;
+	devm_kfree(ice_pf_to_dev(pf), pf->vsi);
+	pf->vsi = NULL;
+}
+
+static int ice_init_devlink(struct ice_pf *pf)
+{
+	int err;
+
+	err = ice_devlink_register_params(pf);
 	if (err)
-		goto err_create_pf_port;
+		return err;
 
-	vsi = ice_get_main_vsi(pf);
-	if (!vsi || !vsi->netdev)
-		goto err_netdev_reg;
+	ice_devlink_init_regions(pf);
+	ice_devlink_register(pf);
 
-	SET_NETDEV_DEVLINK_PORT(vsi->netdev, &pf->devlink_port);
+	return 0;
+}
 
-	err = ice_register_netdev(pf);
+static void ice_deinit_devlink(struct ice_pf *pf)
+{
+	ice_devlink_unregister(pf);
+	ice_devlink_destroy_regions(pf);
+	ice_devlink_unregister_params(pf);
+}
+
+static int ice_init(struct ice_pf *pf)
+{
+	int err;
+
+	err = ice_init_dev(pf);
 	if (err)
-		goto err_netdev_reg;
+		return err;
 
-	err = ice_devlink_register_params(pf);
+	err = ice_alloc_vsis(pf);
 	if (err)
-		goto err_netdev_reg;
+		goto err_alloc_vsis;
+
+	err = ice_init_pf_sw(pf);
+	if (err)
+		goto err_init_pf_sw;
+
+	ice_init_wakeup(pf);
+
+	err = ice_init_link(pf);
+	if (err)
+		goto err_init_link;
+
+	err = ice_send_version(pf);
+	if (err)
+		goto err_init_link;
+
+	ice_verify_cacheline_size(pf);
+
+	if (ice_is_safe_mode(pf))
+		ice_set_safe_mode_vlan_cfg(pf);
+	else
+		/* print PCI link speed and width */
+		pcie_print_link_status(pf->pdev);
 
 	/* ready to go, so clear down state bit */
 	clear_bit(ICE_DOWN, pf->state);
+	clear_bit(ICE_SERVICE_DIS, pf->state);
+
+	/* since everything is good, start the service timer */
+	mod_timer(&pf->serv_tmr, round_jiffies(jiffies + pf->serv_tmr_period));
+
+	return 0;
+
+err_init_link:
+	ice_deinit_pf_sw(pf);
+err_init_pf_sw:
+	ice_dealloc_vsis(pf);
+err_alloc_vsis:
+	ice_deinit_dev(pf);
+	return err;
+}
+
+static void ice_deinit(struct ice_pf *pf)
+{
+	set_bit(ICE_SERVICE_DIS, pf->state);
+	set_bit(ICE_DOWN, pf->state);
+
+	ice_deinit_dev(pf);
+	ice_dealloc_vsis(pf);
+	ice_deinit_pf_sw(pf);
+}
+
+/**
+ * ice_load - load pf by init hw and starting VSI
+ * @pf: pointer to the pf instance
+ */
+int ice_load(struct ice_pf *pf)
+{
+	struct ice_vsi *vsi;
+	int err;
+
+	err = ice_reset(&pf->hw, ICE_RESET_PFR);
+	if (err)
+		return err;
+
+	err = ice_init_dev(pf);
+	if (err)
+		return err;
+
+	vsi = ice_get_main_vsi(pf);
+	err = ice_vsi_cfg(vsi, NULL, NULL);
+	if (err)
+		goto err_vsi_cfg;
+
+	err = ice_start_eth(ice_get_main_vsi(pf));
+	if (err)
+		goto err_start_eth;
+
 	err = ice_init_rdma(pf);
+	if (err)
+		goto err_init_rdma;
+
+	ice_init_features(pf);
+	ice_service_task_restart(pf);
+
+	clear_bit(ICE_DOWN, pf->state);
+
+	return 0;
+
+err_init_rdma:
+	ice_vsi_close(ice_get_main_vsi(pf));
+err_start_eth:
+	ice_vsi_decfg(ice_get_main_vsi(pf));
+err_vsi_cfg:
+	ice_deinit_dev(pf);
+	return err;
+}
+
+/**
+ * ice_unload - unload pf by stopping VSI and deinit hw
+ * @pf: pointer to the pf instance
+ */
+void ice_unload(struct ice_pf *pf)
+{
+	ice_deinit_features(pf);
+	ice_deinit_rdma(pf);
+	ice_vsi_close(ice_get_main_vsi(pf));
+	ice_vsi_decfg(ice_get_main_vsi(pf));
+	ice_deinit_dev(pf);
+}
+
+/**
+ * ice_probe - Device initialization routine
+ * @pdev: PCI device information struct
+ * @ent: entry in ice_pci_tbl
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int
+ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
+{
+	struct device *dev = &pdev->dev;
+	struct ice_pf *pf;
+	struct ice_hw *hw;
+	int err;
+
+	if (pdev->is_virtfn) {
+		dev_err(dev, "can't probe a virtual function\n");
+		return -EINVAL;
+	}
+
+	/* this driver uses devres, see
+	 * Documentation/driver-api/driver-model/devres.rst
+	 */
+	err = pcim_enable_device(pdev);
+	if (err)
+		return err;
+
+	err = pcim_iomap_regions(pdev, BIT(ICE_BAR0), dev_driver_string(dev));
 	if (err) {
-		dev_err(dev, "Failed to initialize RDMA: %d\n", err);
-		err = -EIO;
-		goto err_devlink_reg_param;
+		dev_err(dev, "BAR0 I/O map error %d\n", err);
+		return err;
 	}
 
-	ice_devlink_register(pf);
-	return 0;
+	pf = ice_allocate_pf(dev);
+	if (!pf)
+		return -ENOMEM;
 
-err_devlink_reg_param:
-	ice_devlink_unregister_params(pf);
-err_netdev_reg:
-	ice_devlink_destroy_pf_port(pf);
-err_create_pf_port:
-err_send_version_unroll:
-	ice_vsi_release_all(pf);
-err_alloc_sw_unroll:
-	set_bit(ICE_SERVICE_DIS, pf->state);
+	/* initialize Auxiliary index to invalid value */
+	pf->aux_idx = -1;
+
+	/* set up for high or low DMA */
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(dev, "DMA configuration failed: 0x%x\n", err);
+		return err;
+	}
+
+	pci_enable_pcie_error_reporting(pdev);
+	pci_set_master(pdev);
+
+	pf->pdev = pdev;
+	pci_set_drvdata(pdev, pf);
 	set_bit(ICE_DOWN, pf->state);
-	devm_kfree(dev, pf->first_sw);
-err_msix_misc_unroll:
-	ice_free_irq_msix_misc(pf);
-err_init_interrupt_unroll:
-	ice_clear_interrupt_scheme(pf);
-err_init_vsi_stats_unroll:
-	devm_kfree(dev, pf->vsi_stats);
-	pf->vsi_stats = NULL;
-err_init_vsi_unroll:
-	devm_kfree(dev, pf->vsi);
-err_init_pf_unroll:
-	ice_deinit_pf(pf);
-	ice_devlink_destroy_regions(pf);
-	ice_deinit_hw(hw);
-err_exit_unroll:
+	/* Disable service task until DOWN bit is cleared */
+	set_bit(ICE_SERVICE_DIS, pf->state);
+
+	hw = &pf->hw;
+	hw->hw_addr = pcim_iomap_table(pdev)[ICE_BAR0];
+	pci_save_state(pdev);
+
+	hw->back = pf;
+	hw->port_info = NULL;
+	hw->vendor_id = pdev->vendor;
+	hw->device_id = pdev->device;
+	pci_read_config_byte(pdev, PCI_REVISION_ID, &hw->revision_id);
+	hw->subsystem_vendor_id = pdev->subsystem_vendor;
+	hw->subsystem_device_id = pdev->subsystem_device;
+	hw->bus.device = PCI_SLOT(pdev->devfn);
+	hw->bus.func = PCI_FUNC(pdev->devfn);
+	ice_set_ctrlq_len(hw);
+
+	pf->msg_enable = netif_msg_init(debug, ICE_DFLT_NETIF_M);
+
+#ifndef CONFIG_DYNAMIC_DEBUG
+	if (debug < -1)
+		hw->debug_mask = debug;
+#endif
+
+	err = ice_init(pf);
+	if (err)
+		goto err_init;
+
+	err = ice_init_eth(pf);
+	if (err)
+		goto err_init_eth;
+
+	err = ice_init_rdma(pf);
+	if (err)
+		goto err_init_rdma;
+
+	err = ice_init_devlink(pf);
+	if (err)
+		goto err_init_devlink;
+
+	ice_init_features(pf);
+
+	return 0;
+
+err_init_devlink:
+	ice_deinit_rdma(pf);
+err_init_rdma:
+	ice_deinit_eth(pf);
+err_init_eth:
+	ice_deinit(pf);
+err_init:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 	return err;
@@ -5120,7 +5336,7 @@ static void ice_remove(struct pci_dev *pdev)
 	struct ice_pf *pf = pci_get_drvdata(pdev);
 	int i;
 
-	ice_devlink_unregister(pf);
+	ice_deinit_devlink(pf);
 	for (i = 0; i < ICE_MAX_RESET_WAIT; i++) {
 		if (!ice_is_reset_in_progress(pf->state))
 			break;
@@ -5137,23 +5353,17 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_service_task_stop(pf);
 
 	ice_aq_cancel_waiting_tasks(pf);
-	ice_deinit_rdma(pf);
-	ice_devlink_unregister_params(pf);
 	set_bit(ICE_DOWN, pf->state);
 
-	ice_deinit_lag(pf);
-	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
-		ice_ptp_release(pf);
-	if (ice_is_feature_supported(pf, ICE_F_GNSS))
-		ice_gnss_exit(pf);
+	ice_deinit_features(pf);
+	ice_deinit_rdma(pf);
 	if (!ice_is_safe_mode(pf))
 		ice_remove_arfs(pf);
 	ice_setup_mc_magic_wake(pf);
 	ice_vsi_release_all(pf);
 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
-	ice_devlink_destroy_pf_port(pf);
 	ice_set_wake(pf);
-	ice_free_irq_msix_misc(pf);
+	ice_deinit_dev(pf);
 	ice_for_each_vsi(pf, i) {
 		if (!pf->vsi[i])
 			continue;
@@ -5171,7 +5381,6 @@ static void ice_remove(struct pci_dev *pdev)
 	 */
 	ice_reset(&pf->hw, ICE_RESET_PFR);
 	pci_wait_for_pending_transaction(pdev);
-	ice_clear_interrupt_scheme(pf);
 	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 }
-- 
2.36.1

