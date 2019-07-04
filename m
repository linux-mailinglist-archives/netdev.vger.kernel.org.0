Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D18C5F129
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 04:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfGDCMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 22:12:23 -0400
Received: from mga03.intel.com ([134.134.136.65]:7960 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727180AbfGDCMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 22:12:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 19:12:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,449,1557212400"; 
   d="scan'208";a="315741765"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 03 Jul 2019 19:12:18 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, dledford@redhat.com, jgg@mellanox.com
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, mustafa.ismail@intel.com,
        david.m.ertman@intel.com, Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 3/3] i40e: Register RDMA client devices to the virtual platform bus
Date:   Wed,  3 Jul 2019 19:12:52 -0700
Message-Id: <20190704021252.15534-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
References: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Register RDMA client devices to the virtual platform bus. The
unified RDMA driver 'irdma' registers as a platform driver and
will bind to these devices. This model is inspired by the discussion
in [1]. It realizes a single RDMA driver capable of working with
multiple LAN drivers over multi-generation Intel HW supporting RDMA.
There is also no load ordering dependencies between i40e and irdma.

Summary of changes:
* Register a platform client device per PF and unregister the platform
  device when PF goes away.
* Add 2 new client ops.
	* i40e_client_device_register() which is called during RDMA
	  probe() per PF. Validate client drv OPs and schedule service
	  task to call open()
	* i40e_client_device_unregister() called during RDMA remove()
	  per PF. Call client close() and release_qvlist.
* The global register/unregister calls exported for i40iw are retained
  until i40iw is removed from the kernel.

[1] https://patchwork.kernel.org/patch/10815567/

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_client.c | 116 ++++++++++++++----
 drivers/net/ethernet/intel/i40e/i40e_client.h |   8 ++
 2 files changed, 102 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index e81530ca08d0..133950d190a6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -30,11 +30,17 @@ static int i40e_client_update_vsi_ctxt(struct i40e_info *ldev,
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
@@ -71,6 +77,10 @@ int i40e_client_get_params(struct i40e_vsi *vsi, struct i40e_params *params)
 	return 0;
 }
 
+static void i40e_client_device_release(struct device *dev)
+{
+}
+
 /**
  * i40e_notify_client_of_vf_msg - call the client vf message callback
  * @vsi: the VSI with the message
@@ -287,9 +297,7 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	struct i40e_client_instance *cdev = NULL;
 	struct netdev_hw_addr *mac = NULL;
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
-
-	if (!registered_client || pf->cinst)
-		return;
+	struct platform_device *platform_dev;
 
 	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
 	if (!cdev)
@@ -308,6 +316,12 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	cdev->lan_info.fw_maj_ver = pf->hw.aq.fw_maj_ver;
 	cdev->lan_info.fw_min_ver = pf->hw.aq.fw_min_ver;
 	cdev->lan_info.fw_build = pf->hw.aq.fw_build;
+	platform_dev = &cdev->lan_info.platform_dev;
+	platform_dev->name = "i40e_rdma";
+	platform_dev->id = PLATFORM_DEVID_AUTO;
+	platform_dev->id_auto = true;
+	platform_dev->dev.release = i40e_client_device_release;
+	platform_dev->dev.parent = &pf->pdev->dev;
 	set_bit(__I40E_CLIENT_INSTANCE_NONE, &cdev->state);
 
 	if (i40e_client_get_params(vsi, &cdev->lan_info.params)) {
@@ -323,10 +337,12 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	else
 		dev_err(&pf->pdev->dev, "MAC address list is empty!\n");
 
-	cdev->client = registered_client;
+	cdev->client = NULL;
 	pf->cinst = cdev;
 
-	i40e_client_update_msix_info(pf);
+	cdev->lan_info.msix_count = pf->num_iwarp_msix;
+	cdev->lan_info.msix_entries = &pf->msix_entries[pf->iwarp_base_vector];
+	platform_device_register(platform_dev);
 }
 
 /**
@@ -347,7 +363,7 @@ void i40e_client_del_instance(struct i40e_pf *pf)
  **/
 void i40e_client_subtask(struct i40e_pf *pf)
 {
-	struct i40e_client *client = registered_client;
+	struct i40e_client *client;
 	struct i40e_client_instance *cdev;
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 	int ret = 0;
@@ -361,9 +377,11 @@ void i40e_client_subtask(struct i40e_pf *pf)
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
@@ -424,16 +442,7 @@ int i40e_lan_add_device(struct i40e_pf *pf)
 		 pf->hw.pf_id, pf->hw.bus.bus_id,
 		 pf->hw.bus.device, pf->hw.bus.func);
 
-	/* If a client has already been registered, we need to add an instance
-	 * of it to our new LAN device.
-	 */
-	if (registered_client)
-		i40e_client_add_instance(pf);
-
-	/* Since in some cases register may have happened before a device gets
-	 * added, we can schedule a subtask to go initiate the clients if
-	 * they can be launched at probe time.
-	 */
+	i40e_client_add_instance(pf);
 	set_bit(__I40E_CLIENT_SERVICE_REQUESTED, pf->state);
 	i40e_service_event_schedule(pf);
 
@@ -453,6 +462,8 @@ int i40e_lan_del_device(struct i40e_pf *pf)
 	struct i40e_device *ldev, *tmp;
 	int ret = -ENODEV;
 
+	platform_device_unregister(&pf->cinst->lan_info.platform_dev);
+
 	/* First, remove any client instance. */
 	i40e_client_del_instance(pf);
 
@@ -505,10 +516,7 @@ static void i40e_client_release(struct i40e_client *client)
 				 "Client %s instance for PF id %d closed\n",
 				 client->name, pf->hw.pf_id);
 		}
-		/* delete the client instance */
-		i40e_client_del_instance(pf);
-		dev_info(&pf->pdev->dev, "Deleted client instance of Client %s\n",
-			 client->name);
+		cdev->client = NULL;
 		clear_bit(__I40E_SERVICE_SCHED, pf->state);
 	}
 	mutex_unlock(&i40e_device_mutex);
@@ -527,7 +535,7 @@ static void i40e_client_prepare(struct i40e_client *client)
 	mutex_lock(&i40e_device_mutex);
 	list_for_each_entry(ldev, &i40e_devices, list) {
 		pf = ldev->pf;
-		i40e_client_add_instance(pf);
+		pf->cinst->client = registered_client;
 		/* Start the client subtask */
 		set_bit(__I40E_CLIENT_SERVICE_REQUESTED, pf->state);
 		i40e_service_event_schedule(pf);
@@ -733,6 +741,70 @@ static int i40e_client_update_vsi_ctxt(struct i40e_info *ldev,
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
+	if (client->version.major != I40E_CLIENT_VERSION_MAJOR ||
+	    client->version.minor != I40E_CLIENT_VERSION_MINOR) {
+		pr_err("i40e: Failed to register client %s due to mismatched client interface version\n",
+		       client->name);
+		pr_err("Client is using version: %02d.%02d.%02d while LAN driver supports %s\n",
+		       client->version.major, client->version.minor,
+		       client->version.build,
+		       i40e_client_interface_version_str);
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
+	cdev->client->ops->close(&cdev->lan_info, cdev->client, false);
+	clear_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state);
+	i40e_client_release_qvlist(&cdev->lan_info);
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
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.h b/drivers/net/ethernet/intel/i40e/i40e_client.h
index 72994baf4941..0cfdb35e93d6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.h
@@ -4,6 +4,8 @@
 #ifndef _I40E_CLIENT_H_
 #define _I40E_CLIENT_H_
 
+#include <linux/platform_device.h>
+
 #define I40E_CLIENT_STR_LENGTH 10
 
 /* Client interface version should be updated anytime there is a change in the
@@ -80,6 +82,7 @@ struct i40e_params {
 
 /* Structure to hold Lan device info for a client device */
 struct i40e_info {
+	struct platform_device platform_dev;
 	struct i40e_client_version version;
 	u8 lanmac[6];
 	struct net_device *netdev;
@@ -97,6 +100,7 @@ struct i40e_info {
 	struct i40e_qvlist_info *qvlist_info;
 	struct i40e_params params;
 	struct i40e_ops *ops;
+	struct i40e_client *client;
 
 	u16 msix_count;	 /* number of msix vectors*/
 	/* Array down below will be dynamically allocated based on msix_count */
@@ -132,6 +136,10 @@ struct i40e_ops {
 			       struct i40e_client *client,
 			       bool is_vf, u32 vf_id,
 			       u32 flag, u32 valid_flag);
+
+	int (*client_device_register)(struct i40e_info *ldev);
+
+	void (*client_device_unregister)(struct i40e_info *ldev);
 };
 
 struct i40e_client_ops {
-- 
2.21.0

