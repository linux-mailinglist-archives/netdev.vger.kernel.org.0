Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB92C312695
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 19:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhBGSOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 13:14:49 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10268 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229491AbhBGSOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 13:14:39 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 117I6FSi016859;
        Sun, 7 Feb 2021 10:13:36 -0800
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq2dmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Feb 2021 10:13:36 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:13:34 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:13:33 -0800
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 7 Feb 2021 10:13:31 -0800
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <Erik.Smith@dell.com>,
        <Douglas.Farley@dell.com>, <smalin@marvell.com>,
        <aelior@marvell.com>, <mkalderon@marvell.com>,
        <pkushwaha@marvell.com>, <nassa@marvell.com>,
        <malin1024@gmail.com>, Dean Balandin <dbalandin@marvell.com>
Subject: [RFC PATCH v3 01/11] nvme-tcp-offload: Add nvme-tcp-offload - NVMeTCP HW offload ULP
Date:   Sun, 7 Feb 2021 20:13:14 +0200
Message-ID: <20210207181324.11429-2-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210207181324.11429-1-smalin@marvell.com>
References: <20210207181324.11429-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-07_08:2021-02-05,2021-02-07 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch will present the structure for the NVMeTCP offload common
layer driver. This module is added under "drivers/nvme/host/" and future
offload drivers which will register to it will be placed under
"drivers/nvme/hw".
This new driver will be enabled by the Kconfig "NVM Express over Fabrics
TCP offload commmon layer".
In order to support the new transport type, for host mode, no change is
needed.

Each new vendor-specific offload driver will register to this ULP during
its probe function, by filling out the nvme_tcp_ofld_dev->ops and
nvme_tcp_ofld_dev->private_data and calling nvme_tcp_ofld_register_dev
with the initialized struct.

The internal implementation:
- tcp-offload.h:
  Includes all common structs and ops to be used and shared by offload
  drivers.

- tcp-offload.c:
  Includes the init function which registers as a NVMf transport just
  like any other transport.

Signed-off-by: Dean Balandin <dbalandin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/nvme/host/Kconfig       |  16 +++
 drivers/nvme/host/Makefile      |   3 +
 drivers/nvme/host/tcp-offload.c | 124 ++++++++++++++++++++++++
 drivers/nvme/host/tcp-offload.h | 167 ++++++++++++++++++++++++++++++++
 4 files changed, 310 insertions(+)
 create mode 100644 drivers/nvme/host/tcp-offload.c
 create mode 100644 drivers/nvme/host/tcp-offload.h

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index a44d49d63968..6e869e94e67f 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -84,3 +84,19 @@ config NVME_TCP
 	  from https://github.com/linux-nvme/nvme-cli.
 
 	  If unsure, say N.
+
+config NVME_TCP_OFFLOAD
+	tristate "NVM Express over Fabrics TCP offload common layer"
+	default m
+	depends on INET
+	depends on BLK_DEV_NVME
+	select NVME_FABRICS
+	help
+	  This provides support for the NVMe over Fabrics protocol using
+	  the TCP offload transport. This allows you to use remote block devices
+	  exported using the NVMe protocol set.
+
+	  To configure a NVMe over Fabrics controller use the nvme-cli tool
+	  from https://github.com/linux-nvme/nvme-cli.
+
+	  If unsure, say N.
diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
index d7f6a87687b8..0e7ef044cf29 100644
--- a/drivers/nvme/host/Makefile
+++ b/drivers/nvme/host/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_NVME_FABRICS)		+= nvme-fabrics.o
 obj-$(CONFIG_NVME_RDMA)			+= nvme-rdma.o
 obj-$(CONFIG_NVME_FC)			+= nvme-fc.o
 obj-$(CONFIG_NVME_TCP)			+= nvme-tcp.o
+obj-$(CONFIG_NVME_TCP_OFFLOAD)	+= nvme-tcp-offload.o
 
 nvme-core-y				:= core.o
 nvme-core-$(CONFIG_TRACING)		+= trace.o
@@ -26,3 +27,5 @@ nvme-rdma-y				+= rdma.o
 nvme-fc-y				+= fc.o
 
 nvme-tcp-y				+= tcp.o
+
+nvme-tcp-offload-y		+= tcp-offload.o
diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
new file mode 100644
index 000000000000..ee3800250e47
--- /dev/null
+++ b/drivers/nvme/host/tcp-offload.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright 2021 Marvell. All rights reserved.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+/* Kernel includes */
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+/* Driver includes */
+#include "tcp-offload.h"
+
+static LIST_HEAD(nvme_tcp_ofld_devices);
+static DECLARE_RWSEM(nvme_tcp_ofld_devices_rwsem);
+
+/**
+ * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
+ * function.
+ * @dev:	NVMeTCP offload device instance to be registered to the
+ *		common tcp offload instance.
+ *
+ * API function that registers the type of vendor specific driver
+ * being implemented to the common NVMe over TCP offload library. Part of
+ * the overall init sequence of starting up an offload driver.
+ */
+int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev)
+{
+	struct nvme_tcp_ofld_ops *ops = dev->ops;
+
+	if (!ops->claim_dev ||
+	    !ops->create_queue ||
+	    !ops->drain_queue ||
+	    !ops->destroy_queue ||
+	    !ops->poll_queue ||
+	    !ops->init_req ||
+	    !ops->map_sg ||
+	    !ops->send_req)
+		return -EINVAL;
+
+	down_write(&nvme_tcp_ofld_devices_rwsem);
+	list_add_tail(&dev->entry, &nvme_tcp_ofld_devices);
+	up_write(&nvme_tcp_ofld_devices_rwsem);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvme_tcp_ofld_register_dev);
+
+/**
+ * nvme_tcp_ofld_unregister_dev() - NVMeTCP Offload Library unregistration
+ * function.
+ * @dev:	NVMeTCP offload device instance to be unregistered from the
+ *		common tcp offload instance.
+ *
+ * API function that unregisters the type of vendor specific driver being
+ * implemented from the common NVMe over TCP offload library.
+ * Part of the overall exit sequence of unloading the implemented driver.
+ */
+void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev)
+{
+	down_write(&nvme_tcp_ofld_devices_rwsem);
+	list_del(&dev->entry);
+	up_write(&nvme_tcp_ofld_devices_rwsem);
+}
+EXPORT_SYMBOL_GPL(nvme_tcp_ofld_unregister_dev);
+
+/**
+ * nvme_tcp_ofld_report_queue_err() - NVMeTCP Offload report error event
+ * callback function. Pointed to by nvme_tcp_ofld_queue->report_err.
+ * @queue:	NVMeTCP offload queue instance on which the error has occurred.
+ *
+ * API function that allows the vendor specific offload driver to reports errors
+ * to the common offload layer, to invoke error recovery.
+ */
+int nvme_tcp_ofld_report_queue_err(struct nvme_tcp_ofld_queue *queue)
+{
+	/* Placeholder - invoke error recovery flow */
+
+	return 0;
+}
+
+/**
+ * nvme_tcp_ofld_req_done() - NVMeTCP Offload request done callback
+ * function. Pointed to by nvme_tcp_ofld_req->done.
+ * @req:	NVMeTCP offload request to complete.
+ * @result:     The nvme_result.
+ * @status:     The completion status.
+ *
+ * API function that allows the vendor specific offload driver to report request
+ * completions to the common offload layer.
+ */
+void
+nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
+		       union nvme_result *result,
+		       __le16 status)
+{
+	/* Placeholder - complete request with/without error */
+}
+
+static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
+	.name		= "tcp_offload",
+	.module		= THIS_MODULE,
+	.required_opts	= NVMF_OPT_TRADDR,
+	.allowed_opts	= NVMF_OPT_TRSVCID | NVMF_OPT_DISABLE_SQFLOW |
+			  NVMF_OPT_NR_WRITE_QUEUES | NVMF_OPT_HOST_TRADDR |
+			  NVMF_OPT_CTRL_LOSS_TMO | NVMF_OPT_RECONNECT_DELAY |
+			  NVMF_OPT_HDR_DIGEST | NVMF_OPT_DATA_DIGEST |
+			  NVMF_OPT_NR_POLL_QUEUES | NVMF_OPT_TOS,
+};
+
+static int __init nvme_tcp_ofld_init_module(void)
+{
+	nvmf_register_transport(&nvme_tcp_ofld_transport);
+
+	return 0;
+}
+
+static void __exit nvme_tcp_ofld_cleanup_module(void)
+{
+	nvmf_unregister_transport(&nvme_tcp_ofld_transport);
+}
+
+module_init(nvme_tcp_ofld_init_module);
+module_exit(nvme_tcp_ofld_cleanup_module);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-offload.h
new file mode 100644
index 000000000000..468617a58e34
--- /dev/null
+++ b/drivers/nvme/host/tcp-offload.h
@@ -0,0 +1,167 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright 2021 Marvell. All rights reserved.
+ */
+
+/* Linux includes */
+#include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
+#include <linux/types.h>
+#include <linux/nvme-tcp.h>
+
+/* Driver includes */
+#include "nvme.h"
+#include "fabrics.h"
+
+/* Forward declarations */
+struct nvme_tcp_ofld_ops;
+
+/* Representation of a vendor-specific device. This is the struct used to
+ * register to the offload layer by the vendor-specific driver during its probe
+ * function.
+ * Allocated by vendor-specific driver.
+ */
+struct nvme_tcp_ofld_dev {
+	struct list_head entry;
+	struct nvme_tcp_ofld_ops *ops;
+};
+
+/* Per IO struct holding the nvme_request and command
+ * Allocated by blk-mq.
+ */
+struct nvme_tcp_ofld_req {
+	struct nvme_request req;
+	struct nvme_command nvme_cmd;
+	struct nvme_tcp_ofld_queue *queue;
+
+	/* Vendor specific driver context */
+	void *private_data;
+
+	void (*done)(struct nvme_tcp_ofld_req *req,
+		     union nvme_result *result,
+		     __le16 status);
+};
+
+/* Allocated by nvme_tcp_ofld */
+struct nvme_tcp_ofld_queue {
+	/* Offload device associated to this queue */
+	struct nvme_tcp_ofld_dev *dev;
+	struct nvme_tcp_ofld_ctrl *ctrl;
+
+	/* Vendor specific driver context */
+	void *private_data;
+
+	/* Error callback function */
+	int (*report_err)(struct nvme_tcp_ofld_queue *queue);
+};
+
+/* Connectivity (routing) params used for establishing a connection */
+struct nvme_tcp_ofld_ctrl_con_params {
+	/* Input params */
+	struct sockaddr_storage remote_ip_addr;
+
+	/* If NVMF_OPT_HOST_TRADDR is provided it will be set in local_ip_addr
+	 * in nvme_tcp_ofld_create_ctrl().
+	 * If NVMF_OPT_HOST_TRADDR is not provided the local_ip_addr will be
+	 * initialized by claim_dev().
+	 */
+	struct sockaddr_storage local_ip_addr;
+
+	/* Output params */
+	struct sockaddr	remote_mac_addr;
+	struct sockaddr	local_mac_addr;
+	u16 vlan_id;
+};
+
+/* Allocated by nvme_tcp_ofld */
+struct nvme_tcp_ofld_ctrl {
+	struct nvme_ctrl nctrl;
+	struct nvme_tcp_ofld_dev *dev;
+
+	/* admin and IO queues */
+	struct blk_mq_tag_set tag_set;
+	struct blk_mq_tag_set admin_tag_set;
+	struct nvme_tcp_ofld_queue *queues;
+
+	/* Connectivity params */
+	struct nvme_tcp_ofld_ctrl_con_params conn_params;
+
+	/* Vendor specific driver context */
+	void *private_data;
+};
+
+struct nvme_tcp_ofld_ops {
+	const char *name;
+	struct module *module;
+
+	/* For vendor-specific driver to report what opts it supports */
+	int required_opts; /* bitmap using enum nvmf_parsing_opts */
+	int allowed_opts; /* bitmap using enum nvmf_parsing_opts */
+
+	/**
+	 * claim_dev: Return True if addr is reachable via offload device.
+	 * @dev: The offload device to check.
+	 * @conn_params: ptr to routing params to be filled by the lower
+	 *               driver. Input+Output argument.
+	 */
+	int (*claim_dev)(struct nvme_tcp_ofld_dev *dev,
+			 struct nvme_tcp_ofld_ctrl_con_params *conn_params);
+
+	/**
+	 * create_queue: Create offload queue and establish TCP + NVMeTCP
+	 * (icreq+icresp) connection. Return true on successful connection.
+	 * Based on nvme_tcp_alloc_queue.
+	 * @queue: The queue itself - used as input and output.
+	 * @qid: The queue ID associated with the requested queue.
+	 * @q_size: The queue depth.
+	 */
+	int (*create_queue)(struct nvme_tcp_ofld_queue *queue, int qid,
+			    size_t q_size);
+
+	/**
+	 * drain_queue: Drain a given queue - Returning from this function
+	 * ensures that no additional completions will arrive on this queue.
+	 * @queue: The queue to drain.
+	 */
+	void (*drain_queue)(struct nvme_tcp_ofld_queue *queue);
+
+	/**
+	 * destroy_queue: Close the TCP + NVMeTCP connection of a given queue
+	 * and make sure its no longer active (no completions will arrive on the
+	 * queue).
+	 * @queue: The queue to destroy.
+	 */
+	void (*destroy_queue)(struct nvme_tcp_ofld_queue *queue);
+
+	/**
+	 * poll_queue: Poll a given queue for completions.
+	 * @queue: The queue to poll.
+	 */
+	int (*poll_queue)(struct nvme_tcp_ofld_queue *queue);
+
+	/**
+	 * init_req: Initialize vendor-specific params for a new request.
+	 * @req: Ptr to request to be initialized. Input+Output argument.
+	 */
+	int (*init_req)(struct nvme_tcp_ofld_req *req);
+
+	/**
+	 * send_req: Dispatch a request. Returns the execution status.
+	 * @req: Ptr to request to be sent.
+	 */
+	int (*send_req)(struct nvme_tcp_ofld_req *req);
+
+	/**
+	 * map_sg: Map a scatter/gather list to DMA addresses Returns the
+	 * number of SGs entries mapped successfully.
+	 * @dev: The device for which the DMA addresses are to be created.
+	 * @req: The request corresponding to the SGs, to allow vendor-specific
+	 *       driver to initialize additional params if it needs to.
+	 */
+	int (*map_sg)(struct nvme_tcp_ofld_dev *dev,
+		      struct nvme_tcp_ofld_req *req);
+};
+
+/* Exported functions for lower vendor specific offload drivers */
+int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
+void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
-- 
2.22.0

