Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D963977FF
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 18:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhFAQ1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 12:27:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:41945 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233064AbhFAQ1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 12:27:54 -0400
IronPort-SDR: kmqennW5Al1HRCtWP/xG3OuIkj1LA0g0KYgn3soQvphbjWJ60GVdI7ZNgdohxfrf0oKCs2XMjp
 Na3ear1GxdAA==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="200568755"
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="200568755"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 09:24:25 -0700
IronPort-SDR: MawpE8mxBcGDDBwyCb1wwdvw1WG/n05OQyF3iuAd9GJtwo0yX/Lpxb00rdiad/oItu4VFbmc5S
 esqevqdSCi1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="411292770"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 01 Jun 2021 09:24:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, dledford@redhat.com,
        jgg@mellanox.com
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, anthony.l.nguyen@intel.com,
        david.m.ertman@intel.com
Subject: [PATCH net-next v3 7/7] i40e: Register auxiliary devices to provide RDMA
Date:   Tue,  1 Jun 2021 09:26:44 -0700
Message-Id: <20210601162644.1469616-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210601162644.1469616-1-anthony.l.nguyen@intel.com>
References: <20210601162644.1469616-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Convert i40e to use the auxiliary bus infrastructure to export
the RDMA functionality of the device to the RDMA driver.
Register i40e client auxiliary RDMA device on the auxiliary bus per
PCIe device function for the new auxiliary rdma driver (irdma) to
attach to.

The global i40e_register_client and i40e_unregister_client symbols
will be obsoleted once irdma replaces i40iw in the kernel
for the X722 device.

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/Kconfig            |   1 +
 drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
 drivers/net/ethernet/intel/i40e/i40e_client.c | 130 +++++++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   1 +
 4 files changed, 114 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index d8a12da5c49a..eae1b42e48db 100644
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
index 85d3dd3a3339..b9417dc0007c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -870,6 +870,8 @@ struct i40e_netdev_priv {
 	struct i40e_vsi *vsi;
 };
 
+extern struct ida i40e_client_ida;
+
 /* struct that defines an interrupt vector */
 struct i40e_q_vector {
 	struct i40e_vsi *vsi;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index 63eab14a26df..e07ed065d3a4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -12,6 +12,7 @@ static const char i40e_client_interface_version_str[] = I40E_CLIENT_VERSION_STR;
 static struct i40e_client *registered_client;
 static LIST_HEAD(i40e_devices);
 static DEFINE_MUTEX(i40e_device_mutex);
+DEFINE_IDA(i40e_client_ida);
 
 static int i40e_client_virtchnl_send(struct i40e_info *ldev,
 				     struct i40e_client *client,
@@ -275,6 +276,57 @@ void i40e_client_update_msix_info(struct i40e_pf *pf)
 	cdev->lan_info.msix_entries = &pf->msix_entries[pf->iwarp_base_vector];
 }
 
+static void i40e_auxiliary_dev_release(struct device *dev)
+{
+	struct i40e_auxiliary_device *i40e_aux_dev =
+			container_of(dev, struct i40e_auxiliary_device, aux_dev.dev);
+
+	ida_free(&i40e_client_ida, i40e_aux_dev->aux_dev.id);
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
+	ret = ida_alloc(&i40e_client_ida, GFP_KERNEL);
+	if (ret < 0) {
+		kfree(i40e_aux_dev);
+		return ret;
+	}
+	aux_dev->id = ret;
+
+	ret = auxiliary_device_init(aux_dev);
+	if (ret < 0) {
+		ida_free(&i40e_client_ida, aux_dev->id);
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
@@ -286,9 +338,6 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	struct netdev_hw_addr *mac = NULL;
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 
-	if (!registered_client || pf->cinst)
-		return;
-
 	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
 	if (!cdev)
 		return;
@@ -308,11 +357,8 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
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
@@ -324,7 +370,17 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	cdev->client = registered_client;
 	pf->cinst = cdev;
 
-	i40e_client_update_msix_info(pf);
+	cdev->lan_info.msix_count = pf->num_iwarp_msix;
+	cdev->lan_info.msix_entries = &pf->msix_entries[pf->iwarp_base_vector];
+
+	if (i40e_register_auxiliary_dev(&cdev->lan_info, "iwarp"))
+		goto free_cdev;
+
+	return;
+
+free_cdev:
+	kfree(cdev);
+	pf->cinst = NULL;
 }
 
 /**
@@ -345,7 +401,7 @@ void i40e_client_del_instance(struct i40e_pf *pf)
  **/
 void i40e_client_subtask(struct i40e_pf *pf)
 {
-	struct i40e_client *client = registered_client;
+	struct i40e_client *client;
 	struct i40e_client_instance *cdev;
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 	int ret = 0;
@@ -359,9 +415,11 @@ void i40e_client_subtask(struct i40e_pf *pf)
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
@@ -423,16 +481,8 @@ int i40e_lan_add_device(struct i40e_pf *pf)
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
 
@@ -449,9 +499,13 @@ int i40e_lan_add_device(struct i40e_pf *pf)
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
 
@@ -732,6 +786,42 @@ static int i40e_client_update_vsi_ctxt(struct i40e_info *ldev,
 	return err;
 }
 
+void i40e_client_device_register(struct i40e_info *ldev, struct i40e_client *client)
+{
+	struct i40e_pf *pf = ldev->pf;
+
+	pf->cinst->client = client;
+	set_bit(__I40E_CLIENT_SERVICE_REQUESTED, pf->state);
+	i40e_service_event_schedule(pf);
+}
+EXPORT_SYMBOL_GPL(i40e_client_device_register);
+
+void i40e_client_device_unregister(struct i40e_info *ldev)
+{
+	struct i40e_pf *pf = ldev->pf;
+	struct i40e_client_instance *cdev = pf->cinst;
+
+	if (!cdev)
+		return;
+
+	while (test_and_set_bit(__I40E_SERVICE_SCHED, pf->state))
+		usleep_range(500, 1000);
+
+	if (test_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state)) {
+		cdev->client->ops->close(&cdev->lan_info, cdev->client, false);
+		clear_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state);
+		i40e_client_release_qvlist(&cdev->lan_info);
+	}
+
+	pf->cinst->client = NULL;
+	clear_bit(__I40E_SERVICE_SCHED, pf->state);
+}
+EXPORT_SYMBOL_GPL(i40e_client_device_unregister);
+
+/* Retain these legacy global registration/unregistration calls till i40iw is
+ * removed from the kernel. The irdma unified driver does not use these
+ * exported symbols.
+ */
 /**
  * i40e_register_client - Register a i40e client driver with the L2 driver
  * @client: pointer to the i40e_client struct
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 704e474879c5..9db1968fc491 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -16270,6 +16270,7 @@ static void __exit i40e_exit_module(void)
 {
 	pci_unregister_driver(&i40e_driver);
 	destroy_workqueue(i40e_wq);
+	ida_destroy(&i40e_client_ida);
 	i40e_dbg_exit();
 }
 module_exit(i40e_exit_module);
-- 
2.26.2

