Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8AD355FF4
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347406AbhDGAQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:16:09 -0400
Received: from mga17.intel.com ([192.55.52.151]:60815 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347388AbhDGAQD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:16:03 -0400
IronPort-SDR: X4kWVhGXd1wpyDZVqOPb86ENAAYNKB5sX/MMOOpqbn6PnQSWZHosQH2VenXRf9KLOEB5XI98NW
 rBLFR9gzzWJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="173263119"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="173263119"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:15:54 -0700
IronPort-SDR: 2OhWcP+htNSXMtZ6b4xDWaio/BA5wBc3dbWH+lbjVQ0qrnTaFf9W+NWKYqADOLTIB2WNYjb2mH
 u/lImU+040yA==
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="396440850"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.212.32.74])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:15:54 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v4 resend 07/23] i40e: Register auxiliary devices to provide RDMA
Date:   Tue,  6 Apr 2021 19:14:46 -0500
Message-Id: <20210407001502.1890-8-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210407001502.1890-1-shiraz.saleem@intel.com>
References: <20210407001502.1890-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert i40e to use the auxiliary bus infrastructure to export
the RDMA functionality of the device to the RDMA driver.
Register i40e client auxiliary RDMA device on the auxiliary bus per
PCIe device function for the new auxiliary rdma driver (irdma) to
attach to.

This replaces the need for the global i40e_register_client and
i40e_unregister_client symbols to connect the netdev and rdma
driver. It will be obsoleted once irdma replaces i40iw in the kernel
for the X722 device.

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/net/ethernet/intel/Kconfig            |   1 +
 drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
 drivers/net/ethernet/intel/i40e/i40e_client.c | 156 ++++++++++++++++++++++----
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   1 +
 4 files changed, 140 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index cbc5968..ccb7ad6 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -241,6 +241,7 @@ config I40E
 	tristate "Intel(R) Ethernet Controller XL710 Family support"
 	imply PTP_1588_CLOCK
 	depends on PCI
+	select AUXILIARY_BUS
 	help
 	  This driver supports Intel(R) Ethernet Controller XL710 Family of
 	  devices.  For more information on how to identify your adapter, go
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index cd53981..3246fef 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -867,6 +867,8 @@ struct i40e_netdev_priv {
 	struct i40e_vsi *vsi;
 };
 
+extern struct ida i40e_client_ida;
+
 /* struct that defines an interrupt vector */
 struct i40e_q_vector {
 	struct i40e_vsi *vsi;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index a2dba32..2eb5aba 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -12,6 +12,7 @@
 static struct i40e_client *registered_client;
 static LIST_HEAD(i40e_devices);
 static DEFINE_MUTEX(i40e_device_mutex);
+DEFINE_IDA(i40e_client_ida);
 
 static int i40e_client_virtchnl_send(struct i40e_info *ldev,
 				     struct i40e_client *client,
@@ -30,11 +31,17 @@ static int i40e_client_update_vsi_ctxt(struct i40e_info *ldev,
 				       bool is_vf, u32 vf_id,
 				       u32 flag, u32 valid_flag);
 
+static int i40e_client_device_register(struct i40e_info *ldev);
+
+static void i40e_client_device_unregister(struct i40e_info *ldev);
+
 static struct i40e_ops i40e_lan_ops = {
 	.virtchnl_send = i40e_client_virtchnl_send,
 	.setup_qvlist = i40e_client_setup_qvlist,
 	.request_reset = i40e_client_request_reset,
 	.update_vsi_ctxt = i40e_client_update_vsi_ctxt,
+	.client_device_register = i40e_client_device_register,
+	.client_device_unregister = i40e_client_device_unregister,
 };
 
 /**
@@ -275,6 +282,57 @@ void i40e_client_update_msix_info(struct i40e_pf *pf)
 	cdev->lan_info.msix_entries = &pf->msix_entries[pf->iwarp_base_vector];
 }
 
+static void i40e_auxiliary_dev_release(struct device *dev)
+{
+	struct i40e_auxiliary_device *i40e_aux_dev =
+			container_of(dev, struct i40e_auxiliary_device, aux_dev.dev);
+
+	ida_simple_remove(&i40e_client_ida, i40e_aux_dev->aux_dev.id);
+	kfree(i40e_aux_dev);
+}
+
+static int i40e_register_auxiliary_dev(struct i40e_info *ldev, const char *name)
+{
+	struct i40e_auxiliary_device *i40e_aux_dev;
+	struct pci_dev *pdev = ldev->pcidev;
+	struct auxiliary_device *aux_dev;
+	int ret;
+
+	i40e_aux_dev = kzalloc(sizeof(*i40e_aux_dev), GFP_KERNEL);
+	if (!i40e_aux_dev)
+		return -ENOMEM;
+
+	i40e_aux_dev->ldev = ldev;
+
+	aux_dev = &i40e_aux_dev->aux_dev;
+	aux_dev->name = name;
+	aux_dev->dev.parent = &pdev->dev;
+	aux_dev->dev.release = i40e_auxiliary_dev_release;
+	ldev->aux_dev = aux_dev;
+
+	ret = ida_simple_get(&i40e_client_ida, 0, 0, GFP_KERNEL);
+	if (ret < 0) {
+		kfree(i40e_aux_dev);
+		return ret;
+	}
+	aux_dev->id = ret;
+
+	ret = auxiliary_device_init(aux_dev);
+	if (ret < 0) {
+		ida_simple_remove(&i40e_client_ida, aux_dev->id);
+		kfree(i40e_aux_dev);
+		return ret;
+	}
+
+	ret = auxiliary_device_add(aux_dev);
+	if (ret) {
+		auxiliary_device_uninit(aux_dev);
+		return ret;
+	}
+
+	return ret;
+}
+
 /**
  * i40e_client_add_instance - add a client instance struct to the instance list
  * @pf: pointer to the board struct
@@ -286,9 +344,6 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	struct netdev_hw_addr *mac = NULL;
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 
-	if (!registered_client || pf->cinst)
-		return;
-
 	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
 	if (!cdev)
 		return;
@@ -308,11 +363,8 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	cdev->lan_info.fw_build = pf->hw.aq.fw_build;
 	set_bit(__I40E_CLIENT_INSTANCE_NONE, &cdev->state);
 
-	if (i40e_client_get_params(vsi, &cdev->lan_info.params)) {
-		kfree(cdev);
-		cdev = NULL;
-		return;
-	}
+	if (i40e_client_get_params(vsi, &cdev->lan_info.params))
+		goto free_cdev;
 
 	mac = list_first_entry(&cdev->lan_info.netdev->dev_addrs.list,
 			       struct netdev_hw_addr, list);
@@ -324,7 +376,17 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	cdev->client = registered_client;
 	pf->cinst = cdev;
 
-	i40e_client_update_msix_info(pf);
+	cdev->lan_info.msix_count = pf->num_iwarp_msix;
+	cdev->lan_info.msix_entries = &pf->msix_entries[pf->iwarp_base_vector];
+
+	if (i40e_register_auxiliary_dev(&cdev->lan_info, "intel_rdma_iwarp"))
+		goto free_cdev;
+
+	return;
+
+free_cdev:
+	kfree(cdev);
+	pf->cinst = NULL;
 }
 
 /**
@@ -345,7 +407,7 @@ void i40e_client_del_instance(struct i40e_pf *pf)
  **/
 void i40e_client_subtask(struct i40e_pf *pf)
 {
-	struct i40e_client *client = registered_client;
+	struct i40e_client *client;
 	struct i40e_client_instance *cdev;
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 	int ret = 0;
@@ -359,9 +421,11 @@ void i40e_client_subtask(struct i40e_pf *pf)
 	    test_bit(__I40E_CONFIG_BUSY, pf->state))
 		return;
 
-	if (!client || !cdev)
+	if (!cdev || !cdev->client)
 		return;
 
+	client = cdev->client;
+
 	/* Here we handle client opens. If the client is down, and
 	 * the netdev is registered, then open the client.
 	 */
@@ -422,16 +486,8 @@ int i40e_lan_add_device(struct i40e_pf *pf)
 		 pf->hw.pf_id, pf->hw.bus.bus_id,
 		 pf->hw.bus.device, pf->hw.bus.func);
 
-	/* If a client has already been registered, we need to add an instance
-	 * of it to our new LAN device.
-	 */
-	if (registered_client)
-		i40e_client_add_instance(pf);
+	i40e_client_add_instance(pf);
 
-	/* Since in some cases register may have happened before a device gets
-	 * added, we can schedule a subtask to go initiate the clients if
-	 * they can be launched at probe time.
-	 */
 	set_bit(__I40E_CLIENT_SERVICE_REQUESTED, pf->state);
 	i40e_service_event_schedule(pf);
 
@@ -448,9 +504,13 @@ int i40e_lan_add_device(struct i40e_pf *pf)
  **/
 int i40e_lan_del_device(struct i40e_pf *pf)
 {
+	struct auxiliary_device *aux_dev = pf->cinst->lan_info.aux_dev;
 	struct i40e_device *ldev, *tmp;
 	int ret = -ENODEV;
 
+	auxiliary_device_delete(aux_dev);
+	auxiliary_device_uninit(aux_dev);
+
 	/* First, remove any client instance. */
 	i40e_client_del_instance(pf);
 
@@ -731,6 +791,62 @@ static int i40e_client_update_vsi_ctxt(struct i40e_info *ldev,
 	return err;
 }
 
+static int i40e_client_device_register(struct i40e_info *ldev)
+{
+	struct i40e_client *client;
+	struct i40e_pf *pf;
+
+	if (!ldev) {
+		pr_err("Failed to reg client dev: ldev ptr NULL\n");
+		return -EINVAL;
+	}
+
+	client = ldev->client;
+	pf = ldev->pf;
+	if (!client) {
+		pr_err("Failed to reg client dev: client ptr NULL\n");
+		return -EINVAL;
+	}
+
+	if (!ldev->ops || !client->ops) {
+		pr_err("Failed to reg client dev: client dev peer_ops/ops NULL\n");
+		return -EINVAL;
+	}
+
+	pf->cinst->client = ldev->client;
+	set_bit(__I40E_CLIENT_SERVICE_REQUESTED, pf->state);
+	i40e_service_event_schedule(pf);
+
+	return 0;
+}
+
+static void i40e_client_device_unregister(struct i40e_info *ldev)
+{
+	struct i40e_pf *pf = ldev->pf;
+	struct i40e_client_instance *cdev = pf->cinst;
+
+	while (test_and_set_bit(__I40E_SERVICE_SCHED, pf->state))
+		usleep_range(500, 1000);
+
+	if (!cdev || !cdev->client || !cdev->client->ops ||
+	    !cdev->client->ops->close) {
+		dev_err(&pf->pdev->dev, "Cannot close client device\n");
+		return;
+	}
+	if (test_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state)) {
+		cdev->client->ops->close(&cdev->lan_info, cdev->client, false);
+		clear_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state);
+		i40e_client_release_qvlist(&cdev->lan_info);
+	}
+
+	pf->cinst->client = NULL;
+	clear_bit(__I40E_SERVICE_SCHED, pf->state);
+}
+
+/* Retain legacy global registration/unregistration calls till i40iw is
+ * deprecated from the kernel. The irdma unified driver does not use these
+ * exported symbols.
+ */
 /**
  * i40e_register_client - Register a i40e client driver with the L2 driver
  * @client: pointer to the i40e_client struct
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 353deae..d8d3b136 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -16272,6 +16272,7 @@ static void __exit i40e_exit_module(void)
 {
 	pci_unregister_driver(&i40e_driver);
 	destroy_workqueue(i40e_wq);
+	ida_destroy(&i40e_client_ida);
 	i40e_dbg_exit();
 }
 module_exit(i40e_exit_module);
-- 
1.8.3.1

