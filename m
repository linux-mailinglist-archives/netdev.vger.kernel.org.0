Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5CF3992BD
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 20:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhFBSpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:45:20 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12438 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229468AbhFBSpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:45:16 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 152IeJk8013044;
        Wed, 2 Jun 2021 11:43:18 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38wufgv8jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 11:43:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 11:43:15 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 2 Jun 2021 11:43:11 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <linux-nvme@lists.infradead.org>, <sagi@grimberg.me>, <hch@lst.de>,
        <axboe@fb.com>, <kbusch@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <smalin@marvell.com>, Dean Balandin <dbalandin@marvell.com>
Subject: [PATCH 1/8] nvme-tcp-offload: Add nvme-tcp-offload - NVMeTCP HW offload ULP
Date:   Wed, 2 Jun 2021 21:42:39 +0300
Message-ID: <20210602184246.14184-2-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210602184246.14184-1-smalin@marvell.com>
References: <20210602184246.14184-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: mpncSV4oOhqoIoMQLwcQHUkLnwoRcAyj
X-Proofpoint-GUID: mpncSV4oOhqoIoMQLwcQHUkLnwoRcAyj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_10:2021-06-02,2021-06-02 signatures=0
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

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dean Balandin <dbalandin@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 MAINTAINERS                     |   8 ++
 drivers/nvme/host/Kconfig       |  17 +++
 drivers/nvme/host/Makefile      |   3 +
 drivers/nvme/host/tcp-offload.c | 124 ++++++++++++++++++++
 drivers/nvme/host/tcp-offload.h | 199 ++++++++++++++++++++++++++++++++
 5 files changed, 351 insertions(+)
 create mode 100644 drivers/nvme/host/tcp-offload.c
 create mode 100644 drivers/nvme/host/tcp-offload.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5c90148f0369..64cdffb8aaed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13003,6 +13003,14 @@ F:	drivers/nvme/host/
 F:	include/linux/nvme.h
 F:	include/uapi/linux/nvme_ioctl.h
 
+NVM EXPRESS TCP OFFLOAD TRANSPORT DRIVERS
+M:	Shai Malin <smalin@marvell.com>
+M:	Ariel Elior <aelior@marvell.com>
+L:	linux-nvme@lists.infradead.org
+S:	Supported
+F:	drivers/nvme/host/tcp-offload.c
+F:	drivers/nvme/host/tcp-offload.h
+
 NVM EXPRESS FC TRANSPORT DRIVERS
 M:	James Smart <james.smart@broadcom.com>
 L:	linux-nvme@lists.infradead.org
diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index 494675aeaaad..9c6f4d776daf 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -85,3 +85,20 @@ config NVME_TCP
 	  from https://github.com/linux-nvme/nvme-cli.
 
 	  If unsure, say N.
+
+config NVME_TCP_OFFLOAD
+	tristate "NVM Express over Fabrics TCP offload common layer"
+	default m
+	depends on BLOCK
+	depends on INET
+	select NVME_CORE
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
index cbc509784b2e..3c3fdf83ce38 100644
--- a/drivers/nvme/host/Makefile
+++ b/drivers/nvme/host/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_NVME_FABRICS)		+= nvme-fabrics.o
 obj-$(CONFIG_NVME_RDMA)			+= nvme-rdma.o
 obj-$(CONFIG_NVME_FC)			+= nvme-fc.o
 obj-$(CONFIG_NVME_TCP)			+= nvme-tcp.o
+obj-$(CONFIG_NVME_TCP_OFFLOAD)	+= nvme-tcp-offload.o
 
 nvme-core-y				:= core.o ioctl.o
 nvme-core-$(CONFIG_TRACING)		+= trace.o
@@ -26,3 +27,5 @@ nvme-rdma-y				+= rdma.o
 nvme-fc-y				+= fc.o
 
 nvme-tcp-y				+= tcp.o
+
+nvme-tcp-offload-y		+= tcp-offload.o
diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
new file mode 100644
index 000000000000..f7aa49f337dc
--- /dev/null
+++ b/drivers/nvme/host/tcp-offload.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
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
+static DEFINE_MUTEX(nvme_tcp_ofld_devices_mutex);
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
+	    !ops->setup_ctrl ||
+	    !ops->release_ctrl ||
+	    !ops->create_queue ||
+	    !ops->drain_queue ||
+	    !ops->destroy_queue ||
+	    !ops->poll_queue ||
+	    !ops->send_req)
+		return -EINVAL;
+
+	mutex_lock(&nvme_tcp_ofld_devices_mutex);
+	list_add_tail(&dev->entry, &nvme_tcp_ofld_devices);
+	mutex_unlock(&nvme_tcp_ofld_devices_mutex);
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
+	mutex_lock(&nvme_tcp_ofld_devices_mutex);
+	list_del(&dev->entry);
+	mutex_unlock(&nvme_tcp_ofld_devices_mutex);
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
+ * Handles both NVME_TCP_F_DATA_SUCCESS flag and NVMe CQ.
+ * @req:	NVMeTCP offload request to complete.
+ * @result:     The nvme_result.
+ * @status:     The completion status.
+ *
+ * API function that allows the vendor specific offload driver to report request
+ * completions to the common offload layer.
+ */
+void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
+			    union nvme_result *result,
+			    __le16 status)
+{
+	/* Placeholder - complete request with/without error */
+}
+
+static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
+	.name		= "tcp_offload",
+	.module		= THIS_MODULE,
+	.required_opts	= NVMF_OPT_TRADDR,
+	.allowed_opts	= NVMF_OPT_TRSVCID | NVMF_OPT_NR_WRITE_QUEUES  |
+			  NVMF_OPT_HOST_TRADDR | NVMF_OPT_CTRL_LOSS_TMO |
+			  NVMF_OPT_RECONNECT_DELAY | NVMF_OPT_HDR_DIGEST |
+			  NVMF_OPT_DATA_DIGEST | NVMF_OPT_NR_POLL_QUEUES |
+			  NVMF_OPT_TOS,
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
index 000000000000..520a0ea6f4b8
--- /dev/null
+++ b/drivers/nvme/host/tcp-offload.h
@@ -0,0 +1,199 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
+	struct net_device *ndev;
+	struct nvme_tcp_ofld_ops *ops;
+
+	/* Vendor specific driver context */
+	int num_hw_vectors;
+};
+
+/* Per IO struct holding the nvme_request and command
+ * Allocated by blk-mq.
+ */
+struct nvme_tcp_ofld_req {
+	struct nvme_request req;
+	struct nvme_command nvme_cmd;
+	struct list_head queue_entry;
+	struct nvme_tcp_ofld_queue *queue;
+
+	/* Vendor specific driver context */
+	void *private_data;
+
+	/* async flag is used to distinguish between async and IO flow
+	 * in common send_req() of nvme_tcp_ofld_ops.
+	 */
+	bool async;
+
+	void (*done)(struct nvme_tcp_ofld_req *req,
+		     union nvme_result *result,
+		     __le16 status);
+};
+
+enum nvme_tcp_ofld_queue_flags {
+	NVME_TCP_OFLD_Q_ALLOCATED = 0,
+	NVME_TCP_OFLD_Q_LIVE = 1,
+};
+
+/* Allocated by nvme_tcp_ofld */
+struct nvme_tcp_ofld_queue {
+	/* Offload device associated to this queue */
+	struct nvme_tcp_ofld_dev *dev;
+	struct nvme_tcp_ofld_ctrl *ctrl;
+	unsigned long flags;
+	size_t cmnd_capsule_len;
+
+	u8 hdr_digest;
+	u8 data_digest;
+	u8 tos;
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
+	struct sockaddr_storage remote_ip_addr;
+
+	/* If NVMF_OPT_HOST_TRADDR is provided it will be set in local_ip_addr
+	 * in nvme_tcp_ofld_create_ctrl().
+	 * If NVMF_OPT_HOST_TRADDR is not provided the local_ip_addr will be
+	 * initialized by claim_dev().
+	 */
+	struct sockaddr_storage local_ip_addr;
+};
+
+/* Allocated by nvme_tcp_ofld */
+struct nvme_tcp_ofld_ctrl {
+	struct nvme_ctrl nctrl;
+	struct list_head list;
+	struct nvme_tcp_ofld_dev *dev;
+
+	/* admin and IO queues */
+	struct blk_mq_tag_set tag_set;
+	struct blk_mq_tag_set admin_tag_set;
+	struct nvme_tcp_ofld_queue *queues;
+
+	struct work_struct err_work;
+	struct delayed_work connect_work;
+
+	/*
+	 * Each entry in the array indicates the number of queues of
+	 * corresponding type.
+	 */
+	u32 io_queues[HCTX_MAX_TYPES];
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
+	/* For vendor-specific driver to report what opts it supports.
+	 * It could be different than the ULP supported opts due to hardware
+	 * limitations. Also it could be different among different vendor
+	 * drivers.
+	 */
+	int required_opts; /* bitmap using enum nvmf_parsing_opts */
+	int allowed_opts; /* bitmap using enum nvmf_parsing_opts */
+
+	/* For vendor-specific max num of segments and IO sizes */
+	u32 max_hw_sectors;
+	u32 max_segments;
+
+	/**
+	 * claim_dev: Return True if addr is reachable via offload device.
+	 * @dev: The offload device to check.
+	 * @ctrl: The offload ctrl have the conn_params field. The
+	 * conn_params is to be filled with routing params by the lower
+	 * driver.
+	 */
+	int (*claim_dev)(struct nvme_tcp_ofld_dev *dev,
+			 struct nvme_tcp_ofld_ctrl *ctrl);
+
+	/**
+	 * setup_ctrl: Setup device specific controller structures.
+	 * @ctrl: The offload ctrl.
+	 */
+	int (*setup_ctrl)(struct nvme_tcp_ofld_ctrl *ctrl);
+
+	/**
+	 * release_ctrl: Release/Free device specific controller structures.
+	 * @ctrl: The offload ctrl.
+	 */
+	int (*release_ctrl)(struct nvme_tcp_ofld_ctrl *ctrl);
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
+			    size_t queue_size);
+
+	/**
+	 * drain_queue: Drain a given queue - blocking function call.
+	 * Return from this function ensures that no additional
+	 * completions will arrive on this queue and that the HW will
+	 * not access host memory.
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
+	 * send_req: Dispatch a request. Returns the execution status.
+	 * @req: Ptr to request to be sent.
+	 */
+	int (*send_req)(struct nvme_tcp_ofld_req *req);
+};
+
+/* Exported functions for lower vendor specific offload drivers */
+int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
+void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
-- 
2.22.0

