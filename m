Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD8F11179B2
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfLIWtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:49:43 -0500
Received: from mga12.intel.com ([192.55.52.136]:33717 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbfLIWtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 17:49:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 14:49:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,296,1571727600"; 
   d="scan'208";a="237912293"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 09 Dec 2019 14:49:39 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Date:   Mon,  9 Dec 2019 14:49:19 -0800
Message-Id: <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Register client virtbus device on the virtbus for the RDMA
virtbus driver (irdma) to bind to. It allows to realize a
single RDMA driver capable of working with multiple netdev
drivers over multi-generation Intel HW supporting RDMA.
There is also no load ordering dependencies between i40e and
irdma.

Summary of changes:
* Support to add/remove virtbus devices
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
 drivers/net/ethernet/intel/i40e/i40e_client.c | 109 +++++++++++++++---
 .../linux/net/intel}/i40e_client.h            |  20 +++-
 6 files changed, 112 insertions(+), 24 deletions(-)
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
index b88328fea1d0..8595f578fbe7 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -241,6 +241,7 @@ config I40E
 	tristate "Intel(R) Ethernet Controller XL710 Family support"
 	imply PTP_1588_CLOCK
 	depends on PCI
+	select VIRTUAL_BUS
 	---help---
 	  This driver supports Intel(R) Ethernet Controller XL710 Family of
 	  devices.  For more information on how to identify your adapter, go
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index cb6367334ca7..4321e81d347c 100644
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
index e81530ca08d0..a3dee729719b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -1,12 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include <linux/net/intel/i40e_client.h>
 #include <linux/list.h>
 #include <linux/errno.h>
 
 #include "i40e.h"
 #include "i40e_prototype.h"
-#include "i40e_client.h"
 
 static const char i40e_client_interface_version_str[] = I40E_CLIENT_VERSION_STR;
 static struct i40e_client *registered_client;
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
@@ -275,6 +281,27 @@ void i40e_client_update_msix_info(struct i40e_pf *pf)
 	cdev->lan_info.msix_entries = &pf->msix_entries[pf->iwarp_base_vector];
 }
 
+static int i40e_init_client_virtdev(struct i40e_pf *pf)
+{
+	struct i40e_info *ldev = &pf->cinst->lan_info;
+	struct pci_dev *pdev = pf->pdev;
+	struct virtbus_device *vdev;
+	int ret;
+
+	vdev = &ldev->vdev;
+	vdev->name = I40E_PEER_RDMA_NAME;
+	vdev->dev.parent = &pf->pdev->dev;
+
+	ret = virtbus_dev_register(vdev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failure adding client virtbus dev %s %d\n",
+			I40E_PEER_RDMA_NAME, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 /**
  * i40e_client_add_instance - add a client instance struct to the instance list
  * @pf: pointer to the board struct
@@ -288,9 +315,6 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	struct netdev_hw_addr *mac = NULL;
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 
-	if (!registered_client || pf->cinst)
-		return;
-
 	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
 	if (!cdev)
 		return;
@@ -326,7 +350,11 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	cdev->client = registered_client;
 	pf->cinst = cdev;
 
-	i40e_client_update_msix_info(pf);
+	cdev->lan_info.msix_count = pf->num_iwarp_msix;
+	cdev->lan_info.msix_entries = &pf->msix_entries[pf->iwarp_base_vector];
+
+	i40e_init_client_virtdev(pf);
+	set_bit(__I40E_CLIENT_INSTANCE_NONE, &cdev->state);
 }
 
 /**
@@ -347,7 +375,7 @@ void i40e_client_del_instance(struct i40e_pf *pf)
  **/
 void i40e_client_subtask(struct i40e_pf *pf)
 {
-	struct i40e_client *client = registered_client;
+	struct i40e_client *client;
 	struct i40e_client_instance *cdev;
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 	int ret = 0;
@@ -361,9 +389,11 @@ void i40e_client_subtask(struct i40e_pf *pf)
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
@@ -424,16 +454,8 @@ int i40e_lan_add_device(struct i40e_pf *pf)
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
 
@@ -453,6 +475,8 @@ int i40e_lan_del_device(struct i40e_pf *pf)
 	struct i40e_device *ldev, *tmp;
 	int ret = -ENODEV;
 
+	virtbus_dev_unregister(&pf->cinst->lan_info.vdev);
+
 	/* First, remove any client instance. */
 	i40e_client_del_instance(pf);
 
@@ -733,6 +757,59 @@ static int i40e_client_update_vsi_ctxt(struct i40e_info *ldev,
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
index 72994baf4941..1ca9c1eae60e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.h
+++ b/include/linux/net/intel/i40e_client.h
@@ -4,6 +4,9 @@
 #ifndef _I40E_CLIENT_H_
 #define _I40E_CLIENT_H_
 
+#include <linux/virtual_bus.h>
+
+#define I40E_PEER_RDMA_NAME	"i40e_rdma"
 #define I40E_CLIENT_STR_LENGTH 10
 
 /* Client interface version should be updated anytime there is a change in the
@@ -41,8 +44,8 @@ struct i40e_client;
  * In order for us to keep the interface simple, SW will define a
  * unique type value for AEQ.
  */
-#define I40E_QUEUE_TYPE_PE_AEQ  0x80
-#define I40E_QUEUE_INVALID_IDX	0xFFFF
+#define I40E_QUEUE_TYPE_PE_AEQ 0x80
+#define I40E_QUEUE_INVALID_IDX 0xFFFF
 
 struct i40e_qv_info {
 	u32 v_idx; /* msix_vector */
@@ -67,7 +70,7 @@ struct i40e_prio_qos_params {
 	u8 reserved;
 };
 
-#define I40E_CLIENT_MAX_USER_PRIORITY        8
+#define I40E_CLIENT_MAX_USER_PRIORITY 8
 /* Struct to hold Client QoS */
 struct i40e_qos_params {
 	struct i40e_prio_qos_params prio_qos[I40E_CLIENT_MAX_USER_PRIORITY];
@@ -80,12 +83,13 @@ struct i40e_params {
 
 /* Structure to hold Lan device info for a client device */
 struct i40e_info {
+	struct virtbus_device vdev;
 	struct i40e_client_version version;
 	u8 lanmac[6];
 	struct net_device *netdev;
 	struct pci_dev *pcidev;
 	u8 __iomem *hw_addr;
-	u8 fid;	/* function id, PF id or VF id */
+	u8 fid; /* function id, PF id or VF id */
 #define I40E_CLIENT_FTYPE_PF 0
 #define I40E_CLIENT_FTYPE_VF 1
 	u8 ftype; /* function type, PF or VF */
@@ -97,8 +101,9 @@ struct i40e_info {
 	struct i40e_qvlist_info *qvlist_info;
 	struct i40e_params params;
 	struct i40e_ops *ops;
+	struct i40e_client *client;
 
-	u16 msix_count;	 /* number of msix vectors*/
+	u16 msix_count;  /* number of msix vectors*/
 	/* Array down below will be dynamically allocated based on msix_count */
 	struct msix_entry *msix_entries;
 	u16 itr_index; /* Which ITR index the PE driver is suppose to use */
@@ -132,6 +137,11 @@ struct i40e_ops {
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
-- 
2.23.0

