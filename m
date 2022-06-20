Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00621551F20
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 16:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241832AbiFTOkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 10:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245190AbiFTOj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 10:39:59 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C95A49FC6
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 06:59:52 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id EA42F320133;
        Mon, 20 Jun 2022 14:59:51 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o3HwV-0000p8-Lf;
        Mon, 20 Jun 2022 14:59:51 +0100
Subject: [PATCH net-next 8/8] sfc: Separate netdev probe/remove from PCI
 probe/remove
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     jonathan.s.cooper@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Mon, 20 Jun 2022 14:59:51 +0100
Message-ID: <165573359154.2982.3558513705929382829.stgit@palantir17.mph.net>
In-Reply-To: <165573340676.2982.8456666672406894221.stgit@palantir17.mph.net>
References: <165573340676.2982.8456666672406894221.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Cooper <jonathan.s.cooper@amd.com>

The netdev probe will be used when moving from the vDPA to EF100 BAR config.
The netdev remove will be used when moving from the EF100 to vDPA BAR config.

In the process, change several log messages to pci_ instead of netif_
to remove the "(unregistered net_device)" text.

Signed-off-by: Jon Cooper <jonathan.s.cooper@amd.com>
Co-authored-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100.c        |   65 +++++------------
 drivers/net/ethernet/sfc/ef100_netdev.c |  117 ++++++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/ef100_netdev.h |    4 +
 drivers/net/ethernet/sfc/ef100_nic.c    |   80 ++++-----------------
 drivers/net/ethernet/sfc/ef100_nic.h    |   10 ++-
 drivers/net/ethernet/sfc/efx.c          |    2 -
 drivers/net/ethernet/sfc/efx_common.c   |   38 +++++-----
 drivers/net/ethernet/sfc/mcdi.c         |   12 +--
 8 files changed, 182 insertions(+), 146 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
index a77100239e7c..425017fbcb25 100644
--- a/drivers/net/ethernet/sfc/ef100.c
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -423,44 +423,32 @@ static int ef100_pci_find_func_ctrl_window(struct efx_nic *efx,
  */
 static void ef100_pci_remove(struct pci_dev *pci_dev)
 {
+	struct efx_nic *efx = pci_get_drvdata(pci_dev);
 	struct efx_probe_data *probe_data;
-	struct efx_nic *efx;
 
-	efx = pci_get_drvdata(pci_dev);
 	if (!efx)
 		return;
 
-	rtnl_lock();
-	dev_close(efx->net_dev);
-	rtnl_unlock();
-
-	/* Unregistering our netdev notifier triggers unbinding of TC indirect
-	 * blocks, so we have to do it before PCI removal.
-	 */
-	unregister_netdevice_notifier(&efx->netdev_notifier);
-#if defined(CONFIG_SFC_SRIOV)
-	if (!efx->type->is_vf)
-		efx_ef100_pci_sriov_disable(efx);
-#endif
+	probe_data = container_of(efx, struct efx_probe_data, efx);
+	ef100_remove_netdev(probe_data);
+
 	ef100_remove(efx);
 	efx_fini_io(efx);
-	netif_dbg(efx, drv, efx->net_dev, "shutdown successful\n");
+
+	pci_dbg(pci_dev, "shutdown successful\n");
+
+	pci_disable_pcie_error_reporting(pci_dev);
 
 	pci_set_drvdata(pci_dev, NULL);
 	efx_fini_struct(efx);
-	free_netdev(efx->net_dev);
-	probe_data = container_of(efx, struct efx_probe_data, efx);
 	kfree(probe_data);
-
-	pci_disable_pcie_error_reporting(pci_dev);
 };
 
 static int ef100_pci_probe(struct pci_dev *pci_dev,
 			   const struct pci_device_id *entry)
 {
-	struct efx_probe_data *probe_data, **probe_ptr;
 	struct ef100_func_ctl_window fcw = { 0 };
-	struct net_device *net_dev;
+	struct efx_probe_data *probe_data;
 	struct efx_nic *efx;
 	int rc;
 
@@ -471,31 +459,22 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
 	probe_data->pci_dev = pci_dev;
 	efx = &probe_data->efx;
 
-	/* Allocate and initialise a struct net_device */
-	net_dev = alloc_etherdev_mq(sizeof(probe_data), EFX_MAX_CORE_TX_QUEUES);
-	if (!net_dev)
-		return -ENOMEM;
-	probe_ptr = netdev_priv(net_dev);
-	*probe_ptr = probe_data;
 	efx->type = (const struct efx_nic_type *)entry->driver_data;
 
+	efx->pci_dev = pci_dev;
 	pci_set_drvdata(pci_dev, efx);
-	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
-	efx->net_dev = net_dev;
 	rc = efx_init_struct(efx, pci_dev);
 	if (rc)
 		goto fail;
 
-	efx->mdio.dev = net_dev;
 	efx->vi_stride = EF100_DEFAULT_VI_STRIDE;
-	netif_info(efx, probe, efx->net_dev,
-		   "Solarflare EF100 NIC detected\n");
+	pci_info(pci_dev, "Solarflare EF100 NIC detected\n");
 
 	rc = ef100_pci_find_func_ctrl_window(efx, &fcw);
 	if (rc) {
-		netif_err(efx, probe, efx->net_dev,
-			  "Error looking for ef100 function control window, rc=%d\n",
-			  rc);
+		pci_err(pci_dev,
+			"Error looking for ef100 function control window, rc=%d\n",
+			rc);
 		goto fail;
 	}
 
@@ -507,8 +486,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
 	}
 
 	if (fcw.offset > pci_resource_len(efx->pci_dev, fcw.bar) - ESE_GZ_FCW_LEN) {
-		netif_err(efx, probe, efx->net_dev,
-			  "Func control window overruns BAR\n");
+		pci_err(pci_dev, "Func control window overruns BAR\n");
 		rc = -EIO;
 		goto fail;
 	}
@@ -522,19 +500,16 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
 
 	efx->reg_base = fcw.offset;
 
-	efx->netdev_notifier.notifier_call = ef100_netdev_event;
-	rc = register_netdevice_notifier(&efx->netdev_notifier);
-	if (rc) {
-		netif_err(efx, probe, efx->net_dev,
-			  "Failed to register netdevice notifier, rc=%d\n", rc);
+	rc = efx->type->probe(efx);
+	if (rc)
 		goto fail;
-	}
 
-	rc = efx->type->probe(efx);
+	efx->state = STATE_PROBED;
+	rc = ef100_probe_netdev(probe_data);
 	if (rc)
 		goto fail;
 
-	netif_dbg(efx, probe, efx->net_dev, "initialisation successful\n");
+	pci_dbg(pci_dev, "initialisation successful\n");
 
 	return 0;
 
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 7a80979f4ab7..c8e40a0eef7b 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -22,6 +22,7 @@
 #include "ef100_regs.h"
 #include "mcdi_filters.h"
 #include "rx_common.h"
+#include "ef100_sriov.h"
 
 static void ef100_update_name(struct efx_nic *efx)
 {
@@ -243,13 +244,14 @@ int ef100_netdev_event(struct notifier_block *this,
 	struct efx_nic *efx = container_of(this, struct efx_nic, netdev_notifier);
 	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
 
-	if (efx->net_dev == net_dev && event == NETDEV_CHANGENAME)
+	if (efx->net_dev == net_dev &&
+	    (event == NETDEV_CHANGENAME || event == NETDEV_REGISTER))
 		ef100_update_name(efx);
 
 	return NOTIFY_DONE;
 }
 
-int ef100_register_netdev(struct efx_nic *efx)
+static int ef100_register_netdev(struct efx_nic *efx)
 {
 	struct net_device *net_dev = efx->net_dev;
 	int rc;
@@ -287,7 +289,7 @@ int ef100_register_netdev(struct efx_nic *efx)
 	return rc;
 }
 
-void ef100_unregister_netdev(struct efx_nic *efx)
+static void ef100_unregister_netdev(struct efx_nic *efx)
 {
 	if (efx_dev_registered(efx)) {
 		efx_fini_mcdi_logging(efx);
@@ -295,3 +297,112 @@ void ef100_unregister_netdev(struct efx_nic *efx)
 		unregister_netdev(efx->net_dev);
 	}
 }
+
+void ef100_remove_netdev(struct efx_probe_data *probe_data)
+{
+	struct efx_nic *efx = &probe_data->efx;
+
+	if (!efx->net_dev)
+		return;
+
+	rtnl_lock();
+	dev_close(efx->net_dev);
+	rtnl_unlock();
+
+	unregister_netdevice_notifier(&efx->netdev_notifier);
+#if defined(CONFIG_SFC_SRIOV)
+        if (!efx->type->is_vf)
+                efx_ef100_pci_sriov_disable(efx);
+#endif
+
+	ef100_unregister_netdev(efx);
+
+	down_write(&efx->filter_sem);
+	efx_mcdi_filter_table_remove(efx);
+	up_write(&efx->filter_sem);
+	efx_fini_channels(efx);
+	kfree(efx->phy_data);
+	efx->phy_data = NULL;
+
+	free_netdev(efx->net_dev);
+	efx->net_dev = NULL;
+	efx->state = STATE_PROBED;
+}
+
+int ef100_probe_netdev(struct efx_probe_data *probe_data)
+{
+	struct efx_nic *efx = &probe_data->efx;
+	struct efx_probe_data **probe_ptr;
+	struct net_device *net_dev;
+	int rc;
+
+	if (efx->mcdi->fn_flags &
+			(1 << MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_NO_ACTIVE_PORT)) {
+		pci_info(efx->pci_dev, "No network port on this PCI function");
+		return 0;
+	}
+
+	/* Allocate and initialise a struct net_device */
+	net_dev = alloc_etherdev_mq(sizeof(probe_data), EFX_MAX_CORE_TX_QUEUES);
+	if (!net_dev)
+		return -ENOMEM;
+	probe_ptr = netdev_priv(net_dev);
+	*probe_ptr = probe_data;
+	efx->net_dev = net_dev;
+	SET_NETDEV_DEV(net_dev, &efx->pci_dev->dev);
+
+	net_dev->features |= efx->type->offload_features;
+	net_dev->hw_features |= efx->type->offload_features;
+	net_dev->hw_enc_features |= efx->type->offload_features;
+	net_dev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_SG |
+				  NETIF_F_HIGHDMA | NETIF_F_ALL_TSO;
+	netif_set_tso_max_segs(net_dev,
+                               ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
+	efx->mdio.dev = net_dev;
+
+	rc = efx_ef100_init_datapath_caps(efx);
+	if (rc < 0)
+		goto fail;
+
+	rc = ef100_phy_probe(efx);
+	if (rc)
+		goto fail;
+
+	rc = efx_init_channels(efx);
+	if (rc)
+		goto fail;
+
+
+	down_write(&efx->filter_sem);
+	rc = ef100_filter_table_probe(efx);
+	up_write(&efx->filter_sem);
+	if (rc)
+		goto fail;
+
+	netdev_rss_key_fill(efx->rss_context.rx_hash_key,
+			sizeof(efx->rss_context.rx_hash_key));
+
+	/* Don't fail init if RSS setup doesn't work. */
+	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
+
+	rc = ef100_register_netdev(efx);
+	if (rc)
+		goto fail;
+
+	if (!efx->type->is_vf) {
+		rc = ef100_probe_netdev_pf(efx);
+		if (rc)
+			goto fail;
+	}
+
+	efx->netdev_notifier.notifier_call = ef100_netdev_event;
+	rc = register_netdevice_notifier(&efx->netdev_notifier);
+	if (rc) {
+		netif_err(efx, probe, efx->net_dev,
+				"Failed to register netdevice notifier, rc=%d\n", rc);
+		goto fail;
+	}
+
+fail:
+	return rc;
+}
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.h b/drivers/net/ethernet/sfc/ef100_netdev.h
index d40abb7cc086..38b032ba0953 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.h
+++ b/drivers/net/ethernet/sfc/ef100_netdev.h
@@ -13,5 +13,5 @@
 
 int ef100_netdev_event(struct notifier_block *this,
 		       unsigned long event, void *ptr);
-int ef100_register_netdev(struct efx_nic *efx);
-void ef100_unregister_netdev(struct efx_nic *efx);
+int ef100_probe_netdev(struct efx_probe_data *probe_data);
+void ef100_remove_netdev(struct efx_probe_data *probe_data);
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index fcbc9de1bbf2..f89e695cf8ac 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -148,7 +148,7 @@ static int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address)
 	return 0;
 }
 
-static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
+int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V7_OUT_LEN);
 	struct ef100_nic_data *nic_data = efx->nic_data;
@@ -327,7 +327,7 @@ static irqreturn_t ef100_msi_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int ef100_phy_probe(struct efx_nic *efx)
+int ef100_phy_probe(struct efx_nic *efx)
 {
 	struct efx_mcdi_phy_data *phy_data;
 	int rc;
@@ -365,7 +365,7 @@ static int ef100_phy_probe(struct efx_nic *efx)
 	return 0;
 }
 
-static int ef100_filter_table_probe(struct efx_nic *efx)
+int ef100_filter_table_probe(struct efx_nic *efx)
 {
 	return efx_mcdi_filter_table_probe(efx, true);
 }
@@ -905,8 +905,7 @@ static int ef100_check_design_params(struct efx_nic *efx)
 
 	efx_readd(efx, &reg, ER_GZ_PARAMS_TLV_LEN);
 	total_len = EFX_DWORD_FIELD(reg, EFX_DWORD_0);
-	netif_dbg(efx, probe, efx->net_dev, "%u bytes of design parameters\n",
-		  total_len);
+	pci_dbg(efx->pci_dev, "%u bytes of design parameters\n", total_len);
 	while (offset < total_len) {
 		efx_readd(efx, &reg, ER_GZ_PARAMS_TLV + offset);
 		data = EFX_DWORD_FIELD(reg, EFX_DWORD_0);
@@ -945,7 +944,6 @@ static int ef100_check_design_params(struct efx_nic *efx)
 static int ef100_probe_main(struct efx_nic *efx)
 {
 	unsigned int bar_size = resource_size(&efx->pci_dev->resource[efx->mem_bar]);
-	struct net_device *net_dev = efx->net_dev;
 	struct ef100_nic_data *nic_data;
 	char fw_version[32];
 	int i, rc;
@@ -958,24 +956,18 @@ static int ef100_probe_main(struct efx_nic *efx)
 		return -ENOMEM;
 	efx->nic_data = nic_data;
 	nic_data->efx = efx;
-	net_dev->features |= efx->type->offload_features;
-	net_dev->hw_features |= efx->type->offload_features;
-	net_dev->hw_enc_features |= efx->type->offload_features;
-	net_dev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_SG |
-				  NETIF_F_HIGHDMA | NETIF_F_ALL_TSO;
+	efx->max_vis = EF100_MAX_VIS;
 
 	/* Populate design-parameter defaults */
 	nic_data->tso_max_hdr_len = ESE_EF100_DP_GZ_TSO_MAX_HDR_LEN_DEFAULT;
 	nic_data->tso_max_frames = ESE_EF100_DP_GZ_TSO_MAX_NUM_FRAMES_DEFAULT;
 	nic_data->tso_max_payload_num_segs = ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_NUM_SEGS_DEFAULT;
 	nic_data->tso_max_payload_len = ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_LEN_DEFAULT;
-	netif_set_tso_max_segs(net_dev,
-			       ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
+
 	/* Read design parameters */
 	rc = ef100_check_design_params(efx);
 	if (rc) {
-		netif_err(efx, probe, efx->net_dev,
-			  "Unsupported design parameters\n");
+		pci_err(efx->pci_dev, "Unsupported design parameters\n");
 		goto fail;
 	}
 
@@ -1012,12 +1004,6 @@ static int ef100_probe_main(struct efx_nic *efx)
 	/* Post-IO section. */
 
 	rc = efx_mcdi_init(efx);
-	if (!rc && efx->mcdi->fn_flags &
-		   (1 << MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_NO_ACTIVE_PORT)) {
-		netif_info(efx, probe, efx->net_dev,
-			   "No network port on this PCI function");
-		rc = -ENODEV;
-	}
 	if (rc)
 		goto fail;
 	/* Reset (most) configuration for this function */
@@ -1033,67 +1019,37 @@ static int ef100_probe_main(struct efx_nic *efx)
 	if (rc)
 		goto fail;
 
-	rc = efx_ef100_init_datapath_caps(efx);
-	if (rc < 0)
-		goto fail;
-
-	efx->max_vis = EF100_MAX_VIS;
-
 	rc = efx_mcdi_port_get_number(efx);
 	if (rc < 0)
 		goto fail;
 	efx->port_num = rc;
 
 	efx_mcdi_print_fwver(efx, fw_version, sizeof(fw_version));
-	netif_dbg(efx, drv, efx->net_dev, "Firmware version %s\n", fw_version);
+	pci_dbg(efx->pci_dev, "Firmware version %s\n", fw_version);
 
 	if (compare_versions(fw_version, "1.1.0.1000") < 0) {
-		netif_info(efx, drv, efx->net_dev, "Firmware uses old event descriptors\n");
+		pci_info(efx->pci_dev, "Firmware uses old event descriptors\n");
 		rc = -EINVAL;
 		goto fail;
 	}
 
 	if (efx_has_cap(efx, UNSOL_EV_CREDIT_SUPPORTED)) {
-		netif_info(efx, drv, efx->net_dev, "Firmware uses unsolicited-event credits\n");
+		pci_info(efx->pci_dev, "Firmware uses unsolicited-event credits\n");
 		rc = -EINVAL;
 		goto fail;
 	}
 
-	rc = ef100_phy_probe(efx);
-	if (rc)
-		goto fail;
-
-	down_write(&efx->filter_sem);
-	rc = ef100_filter_table_probe(efx);
-	up_write(&efx->filter_sem);
-	if (rc)
-		goto fail;
-
-	netdev_rss_key_fill(efx->rss_context.rx_hash_key,
-			    sizeof(efx->rss_context.rx_hash_key));
-
-	/* Don't fail init if RSS setup doesn't work. */
-	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
-
-	rc = ef100_register_netdev(efx);
-	if (rc)
-		goto fail;
-
 	return 0;
 fail:
 	return rc;
 }
 
-int ef100_probe_pf(struct efx_nic *efx)
+int ef100_probe_netdev_pf(struct efx_nic *efx)
 {
+	struct ef100_nic_data *nic_data = efx->nic_data;
 	struct net_device *net_dev = efx->net_dev;
-	struct ef100_nic_data *nic_data;
-	int rc = ef100_probe_main(efx);
-
-	if (rc)
-		goto fail;
+	int rc;
 
-	nic_data = efx->nic_data;
 	rc = ef100_get_mac_address(efx, net_dev->perm_addr);
 	if (rc)
 		goto fail;
@@ -1116,14 +1072,6 @@ void ef100_remove(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
 
-	ef100_unregister_netdev(efx);
-
-	down_write(&efx->filter_sem);
-	efx_mcdi_filter_table_remove(efx);
-	up_write(&efx->filter_sem);
-	efx_fini_channels(efx);
-	kfree(efx->phy_data);
-	efx->phy_data = NULL;
 	efx_mcdi_detach(efx);
 	efx_mcdi_fini(efx);
 	if (nic_data)
@@ -1142,7 +1090,7 @@ void ef100_remove(struct efx_nic *efx)
 const struct efx_nic_type ef100_pf_nic_type = {
 	.revision = EFX_REV_EF100,
 	.is_vf = false,
-	.probe = ef100_probe_pf,
+	.probe = ef100_probe_main,
 	.offload_features = EF100_OFFLOAD_FEATURES,
 	.mcdi_max_ver = 2,
 	.mcdi_request = ef100_mcdi_request,
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index e799688d5264..744dbbdb4adc 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -8,6 +8,8 @@
  * under the terms of the GNU General Public License version 2 as published
  * by the Free Software Foundation, incorporated herein by reference.
  */
+#ifndef EFX_EF100_NIC_H
+#define EFX_EF100_NIC_H
 
 #include "net_driver.h"
 #include "nic_common.h"
@@ -15,7 +17,7 @@
 extern const struct efx_nic_type ef100_pf_nic_type;
 extern const struct efx_nic_type ef100_vf_nic_type;
 
-int ef100_probe_pf(struct efx_nic *efx);
+int ef100_probe_netdev_pf(struct efx_nic *efx);
 int ef100_probe_vf(struct efx_nic *efx);
 void ef100_remove(struct efx_nic *efx);
 
@@ -78,3 +80,9 @@ struct ef100_nic_data {
 
 #define efx_ef100_has_cap(caps, flag) \
 	(!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V4_OUT_ ## flag ## _LBN)))
+
+int efx_ef100_init_datapath_caps(struct efx_nic *efx);
+int ef100_phy_probe(struct efx_nic *efx);
+int ef100_filter_table_probe(struct efx_nic *efx);
+
+#endif	/* EFX_EF100_NIC_H */
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index c88e9de9dcd0..153d68e29b8b 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -886,7 +886,7 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 	efx_pci_remove_main(efx);
 
 	efx_fini_io(efx);
-	netif_dbg(efx, drv, efx->net_dev, "shutdown successful\n");
+	pci_dbg(efx->pci_dev, "shutdown successful\n");
 
 	efx_fini_struct(efx);
 	free_netdev(efx->net_dev);
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index b4a101d0d41d..c79f39a51cce 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1074,13 +1074,11 @@ int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
 	int rc;
 
 	efx->mem_bar = UINT_MAX;
-
-	netif_dbg(efx, probe, efx->net_dev, "initialising I/O bar=%d\n", bar);
+	pci_dbg(pci_dev, "initialising I/O bar=%d\n", bar);
 
 	rc = pci_enable_device(pci_dev);
 	if (rc) {
-		netif_err(efx, probe, efx->net_dev,
-			  "failed to enable PCI device\n");
+		pci_err(pci_dev, "failed to enable PCI device\n");
 		goto fail1;
 	}
 
@@ -1088,42 +1086,40 @@ int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
 
 	rc = dma_set_mask_and_coherent(&pci_dev->dev, dma_mask);
 	if (rc) {
-		netif_err(efx, probe, efx->net_dev,
-			  "could not find a suitable DMA mask\n");
+		pci_err(efx->pci_dev, "could not find a suitable DMA mask\n");
 		goto fail2;
 	}
-	netif_dbg(efx, probe, efx->net_dev,
-		  "using DMA mask %llx\n", (unsigned long long)dma_mask);
+	pci_dbg(efx->pci_dev, "using DMA mask %llx\n", (unsigned long long)dma_mask);
 
 	efx->membase_phys = pci_resource_start(efx->pci_dev, bar);
 	if (!efx->membase_phys) {
-		netif_err(efx, probe, efx->net_dev,
-			  "ERROR: No BAR%d mapping from the BIOS. "
-			  "Try pci=realloc on the kernel command line\n", bar);
+		pci_err(efx->pci_dev,
+			"ERROR: No BAR%d mapping from the BIOS. "
+			"Try pci=realloc on the kernel command line\n", bar);
 		rc = -ENODEV;
 		goto fail3;
 	}
 
 	rc = pci_request_region(pci_dev, bar, "sfc");
 	if (rc) {
-		netif_err(efx, probe, efx->net_dev,
-			  "request for memory BAR[%d] failed\n", bar);
+		pci_err(efx->pci_dev,
+			"request for memory BAR[%d] failed\n", bar);
 		rc = -EIO;
 		goto fail3;
 	}
 	efx->mem_bar = bar;
 	efx->membase = ioremap(efx->membase_phys, mem_map_size);
 	if (!efx->membase) {
-		netif_err(efx, probe, efx->net_dev,
-			  "could not map memory BAR[%d] at %llx+%x\n", bar,
-			  (unsigned long long)efx->membase_phys, mem_map_size);
+		pci_err(efx->pci_dev,
+			"could not map memory BAR[%d] at %llx+%x\n", bar,
+			(unsigned long long)efx->membase_phys, mem_map_size);
 		rc = -ENOMEM;
 		goto fail4;
 	}
-	netif_dbg(efx, probe, efx->net_dev,
-		  "memory BAR[%d] at %llx+%x (virtual %p)\n", bar,
-		  (unsigned long long)efx->membase_phys, mem_map_size,
-		  efx->membase);
+	pci_dbg(efx->pci_dev,
+		"memory BAR[%d] at %llx+%x (virtual %p)\n", bar,
+		(unsigned long long)efx->membase_phys, mem_map_size,
+		efx->membase);
 
 	return 0;
 
@@ -1139,7 +1135,7 @@ int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
 
 void efx_fini_io(struct efx_nic *efx)
 {
-	netif_dbg(efx, drv, efx->net_dev, "shutting down I/O\n");
+	pci_dbg(efx->pci_dev, "shutting down I/O\n");
 
 	if (efx->membase) {
 		iounmap(efx->membase);
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index a3425b6be3f7..e6f5d96caf52 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -99,14 +99,12 @@ int efx_mcdi_init(struct efx_nic *efx)
 	 */
 	rc = efx_mcdi_drv_attach(efx, true, &already_attached);
 	if (rc) {
-		netif_err(efx, probe, efx->net_dev,
-			  "Unable to register driver with MCPU\n");
+		pci_err(efx->pci_dev, "Unable to register driver with MCPU\n");
 		goto fail2;
 	}
 	if (already_attached)
 		/* Not a fatal error */
-		netif_err(efx, probe, efx->net_dev,
-			  "Host already registered with MCPU\n");
+		pci_err(efx->pci_dev, "Host already registered with MCPU\n");
 
 	if (efx->mcdi->fn_flags &
 	    (1 << MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_PRIMARY))
@@ -1447,7 +1445,7 @@ void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len)
 	return;
 
 fail:
-	netif_err(efx, probe, efx->net_dev, "%s: failed rc=%d\n", __func__, rc);
+	pci_err(efx->pci_dev, "%s: failed rc=%d\n", __func__, rc);
 	buf[0] = 0;
 }
 
@@ -1471,7 +1469,7 @@ static int efx_mcdi_drv_attach(struct efx_nic *efx, bool driver_operating,
 	 * care what firmware we get.
 	 */
 	if (rc == -EPERM) {
-		netif_dbg(efx, probe, efx->net_dev,
+		pci_dbg(efx->pci_dev,
 			  "efx_mcdi_drv_attach with fw-variant setting failed EPERM, trying without it\n");
 		MCDI_SET_DWORD(inbuf, DRV_ATTACH_IN_FIRMWARE_ID,
 			       MC_CMD_FW_DONT_CARE);
@@ -1514,7 +1512,7 @@ static int efx_mcdi_drv_attach(struct efx_nic *efx, bool driver_operating,
 	return 0;
 
 fail:
-	netif_err(efx, probe, efx->net_dev, "%s: failed rc=%d\n", __func__, rc);
+	pci_err(efx->pci_dev, "%s: failed rc=%d\n", __func__, rc);
 	return rc;
 }
 


