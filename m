Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A74F6BF6E7
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 18:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfIZQpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 12:45:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:33819 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbfIZQpa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 12:45:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 09:45:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="219465112"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2019 09:45:29 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     dledford@redhat.com, jgg@mellanox.com, gregkh@linuxfoundation.org
Cc:     Mustafa Ismail <mustafa.ismail@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [RFC 03/20] i40e: Register multi-function device to provide RDMA
Date:   Thu, 26 Sep 2019 09:45:02 -0700
Message-Id: <20190926164519.10471-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

Register multi-function devices (MFD) for the RDMA platform
function (irdma) driver to bind to. It realizes a single RDMA
driver capable of working with multiple LAN drivers over
multi-generation Intel HW supporting RDMA. There is also no load
ordering dependencies between i40e and irdma.

Summary of changes:
* Support to add/remove MFD devices
* Add 2 new client ops.
	* i40e_client_device_register() which is called during RDMA
	  probe() per PF. Validate client drv OPs and schedule service
	  task to call open()
	* i40e_client_device_unregister() called during RDMA remove()
	  per PF. Call client close() and release_qvlist.
* The global register/unregister calls exported for i40iw are retained
  until i40iw is removed from the kernel.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/infiniband/hw/i40iw/Makefile          |   1 -
 drivers/infiniband/hw/i40iw/i40iw.h           |   2 +-
 drivers/net/ethernet/intel/Kconfig            |   1 +
 drivers/net/ethernet/intel/i40e/i40e.h        |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c | 149 ++++++++++++++++--
 .../linux/net/intel}/i40e_client.h            |  21 +++
 6 files changed, 158 insertions(+), 19 deletions(-)
 rename {drivers/net/ethernet/intel/i40e => include/linux/net/intel}/i40e_client.h (92%)

diff --git a/drivers/infiniband/hw/i40iw/Makefile b/drivers/infiniband/hw/i40iw/Makefile
index 8942f8229945..34da9eba8a7c 100644
--- a/drivers/infiniband/hw/i40iw/Makefile
+++ b/drivers/infiniband/hw/i40iw/Makefile
@@ -1,5 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-ccflags-y :=  -I $(srctree)/drivers/net/ethernet/intel/i40e
 
 obj-$(CONFIG_INFINIBAND_I40IW) += i40iw.o
 
diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index 8feec35f95a7..3197e3536d5c 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -57,7 +57,7 @@
 #include "i40iw_d.h"
 #include "i40iw_hmc.h"
 
-#include <i40e_client.h>
+#include <linux/net/intel/i40e_client.h>
 #include "i40iw_type.h"
 #include "i40iw_p.h"
 #include <rdma/i40iw-abi.h>
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 48ec63f27869..6be57a86fe17 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -241,6 +241,7 @@ config I40E
 	tristate "Intel(R) Ethernet Controller XL710 Family support"
 	imply PTP_1588_CLOCK
 	depends on PCI
+	select MFD_CORE
 	---help---
 	  This driver supports Intel(R) Ethernet Controller XL710 Family of
 	  devices.  For more information on how to identify your adapter, go
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 2af9f6308f84..ed7c721fdcd4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -38,7 +38,7 @@
 #include <net/xdp_sock.h>
 #include "i40e_type.h"
 #include "i40e_prototype.h"
-#include "i40e_client.h"
+#include <linux/net/intel/i40e_client.h>
 #include <linux/avf/virtchnl.h>
 #include "i40e_virtchnl_pf.h"
 #include "i40e_txrx.h"
@@ -655,6 +655,7 @@ struct i40e_pf {
 	u16 last_sw_conf_valid_flags;
 	/* List to keep previous DDP profiles to be rolled back in the future */
 	struct list_head ddp_old_prof;
+	int peer_idx;
 };
 
 /**
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index e81530ca08d0..13edd8fa9bec 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -6,8 +6,9 @@
 
 #include "i40e.h"
 #include "i40e_prototype.h"
-#include "i40e_client.h"
+#include <linux/net/intel/i40e_client.h>
 
+static struct mfd_cell i40e_mfd_cells[] = ASSIGN_PEER_INFO;
 static const char i40e_client_interface_version_str[] = I40E_CLIENT_VERSION_STR;
 static struct i40e_client *registered_client;
 static LIST_HEAD(i40e_devices);
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
@@ -275,6 +282,55 @@ void i40e_client_update_msix_info(struct i40e_pf *pf)
 	cdev->lan_info.msix_entries = &pf->msix_entries[pf->iwarp_base_vector];
 }
 
+DEFINE_IDA(i40e_peer_index_ida);
+
+int i40e_init_peer_devices(struct i40e_pf *pf)
+{
+	struct i40e_peer_dev_platform_data *platform_data;
+	struct pci_dev *pdev = pf->pdev;
+	int status = 0;
+	int i;
+
+	platform_data = kcalloc(ARRAY_SIZE(i40e_mfd_cells),
+				sizeof(*platform_data), GFP_KERNEL);
+	if (!platform_data)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(i40e_mfd_cells); i++) {
+		/* don't create an RDMA MFD device if NIC does not
+		 * support RDMA functionality
+		 */
+		if (i40e_mfd_cells[i].id == I40E_PEER_RDMA_ID &&
+		    !(I40E_FLAG_IWARP_ENABLED & pf->flags)) {
+			dev_warn(&pf->pdev->dev,
+				 "RDMA not supported with this config\n");
+			continue;
+		}
+		platform_data[i].ldev = &pf->cinst->lan_info;
+		i40e_mfd_cells[i].platform_data = &platform_data[i];
+		i40e_mfd_cells[i].pdata_size = sizeof(platform_data);
+	}
+
+	status = ida_simple_get(&i40e_peer_index_ida, 0, 0, GFP_KERNEL);
+	if (status < 0) {
+		dev_err(&pdev->dev,
+			"failed to get unique index for device\n");
+		return status;
+	}
+
+	pf->peer_idx = status;
+	status = mfd_add_devices(&pf->pdev->dev, pf->peer_idx,
+				 i40e_mfd_cells, ARRAY_SIZE(i40e_mfd_cells),
+				 NULL, 0, NULL);
+
+	if (status)
+		dev_err(&pf->pdev->dev,
+			"Failure adding MFD devs for peers: %d\n", status);
+
+	kfree(platform_data);
+	return status;
+}
+
 /**
  * i40e_client_add_instance - add a client instance struct to the instance list
  * @pf: pointer to the board struct
@@ -288,9 +344,6 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	struct netdev_hw_addr *mac = NULL;
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 
-	if (!registered_client || pf->cinst)
-		return;
-
 	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
 	if (!cdev)
 		return;
@@ -326,7 +379,11 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	cdev->client = registered_client;
 	pf->cinst = cdev;
 
-	i40e_client_update_msix_info(pf);
+	cdev->lan_info.msix_count = pf->num_iwarp_msix;
+	cdev->lan_info.msix_entries = &pf->msix_entries[pf->iwarp_base_vector];
+
+	i40e_init_peer_devices(pf);
+	set_bit(__I40E_CLIENT_INSTANCE_NONE, &cdev->state);
 }
 
 /**
@@ -347,7 +404,7 @@ void i40e_client_del_instance(struct i40e_pf *pf)
  **/
 void i40e_client_subtask(struct i40e_pf *pf)
 {
-	struct i40e_client *client = registered_client;
+	struct i40e_client *client;
 	struct i40e_client_instance *cdev;
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 	int ret = 0;
@@ -361,9 +418,11 @@ void i40e_client_subtask(struct i40e_pf *pf)
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
@@ -424,16 +483,8 @@ int i40e_lan_add_device(struct i40e_pf *pf)
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
 
@@ -453,6 +504,8 @@ int i40e_lan_del_device(struct i40e_pf *pf)
 	struct i40e_device *ldev, *tmp;
 	int ret = -ENODEV;
 
+	mfd_remove_devices(&pf->pdev->dev);
+
 	/* First, remove any client instance. */
 	i40e_client_del_instance(pf);
 
@@ -733,6 +786,70 @@ static int i40e_client_update_vsi_ctxt(struct i40e_info *ldev,
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
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.h b/include/linux/net/intel/i40e_client.h
similarity index 92%
rename from drivers/net/ethernet/intel/i40e/i40e_client.h
rename to include/linux/net/intel/i40e_client.h
index 72994baf4941..916794653991 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.h
+++ b/include/linux/net/intel/i40e_client.h
@@ -4,6 +4,11 @@
 #ifndef _I40E_CLIENT_H_
 #define _I40E_CLIENT_H_
 
+#include <linux/mfd/core.h>
+
+#define I40E_PEER_RDMA_NAME	"i40e_rdma"
+#define I40E_PEER_RDMA_ID	PLATFORM_DEVID_AUTO
+
 #define I40E_CLIENT_STR_LENGTH 10
 
 /* Client interface version should be updated anytime there is a change in the
@@ -80,6 +85,7 @@ struct i40e_params {
 
 /* Structure to hold Lan device info for a client device */
 struct i40e_info {
+	struct platform_device *platform_dev;
 	struct i40e_client_version version;
 	u8 lanmac[6];
 	struct net_device *netdev;
@@ -97,6 +103,7 @@ struct i40e_info {
 	struct i40e_qvlist_info *qvlist_info;
 	struct i40e_params params;
 	struct i40e_ops *ops;
+	struct i40e_client *client;
 
 	u16 msix_count;	 /* number of msix vectors*/
 	/* Array down below will be dynamically allocated based on msix_count */
@@ -132,6 +139,11 @@ struct i40e_ops {
 			       struct i40e_client *client,
 			       bool is_vf, u32 vf_id,
 			       u32 flag, u32 valid_flag);
+
+	int (*client_device_register)(struct i40e_info *ldev);
+
+	void (*client_device_unregister)(struct i40e_info *ldev);
+
 };
 
 struct i40e_client_ops {
@@ -200,4 +212,13 @@ static inline bool i40e_client_is_registered(struct i40e_client *client)
 int i40e_register_client(struct i40e_client *client);
 int i40e_unregister_client(struct i40e_client *client);
 
+#define ASSIGN_PEER_INFO						\
+{									\
+	{ .name = I40E_PEER_RDMA_NAME, .id = I40E_PEER_RDMA_ID },	\
+}
+
+struct i40e_peer_dev_platform_data {
+	struct i40e_info *ldev;
+};
+
 #endif /* _I40E_CLIENT_H_ */
-- 
2.21.0

