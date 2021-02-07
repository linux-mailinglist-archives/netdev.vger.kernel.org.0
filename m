Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35EC31269C
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 19:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhBGSPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 13:15:43 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29508 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229692AbhBGSO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 13:14:57 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 117I6H9j029942;
        Sun, 7 Feb 2021 10:14:09 -0800
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrakms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Feb 2021 10:14:09 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:14:08 -0800
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 7 Feb 2021 10:14:04 -0800
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <Erik.Smith@dell.com>,
        <Douglas.Farley@dell.com>, <smalin@marvell.com>,
        <aelior@marvell.com>, <mkalderon@marvell.com>,
        <pkushwaha@marvell.com>, <nassa@marvell.com>,
        <malin1024@gmail.com>, Dean Balandin <dbalandin@marvell.com>
Subject: [RFC PATCH v3 10/11] nvme-qedn: Add qedn probe
Date:   Sun, 7 Feb 2021 20:13:23 +0200
Message-ID: <20210207181324.11429-11-smalin@marvell.com>
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

As part of the qedn init, the driver will register as a pci device and
will work with the Marvell fastlinQ NICs.
The HW ops- qed_nvmetcp_ops are similar to other "qed_*_ops" which are
used by the qede, qedr, qedf and qedi device drivers.

Struct qedn_ctx is per pci physical function (PF) container for
PF-specific attributes and resources.

Signed-off-by: Dean Balandin <dbalandin@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/nvme/hw/Kconfig     |   1 +
 drivers/nvme/hw/qedn/qedn.c | 193 +++++++++++++++++++++++++++++++++++-
 drivers/nvme/hw/qedn/qedn.h |  49 +++++++++
 3 files changed, 238 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/hw/Kconfig b/drivers/nvme/hw/Kconfig
index 374f1f9dbd3d..91b1bd6f07d8 100644
--- a/drivers/nvme/hw/Kconfig
+++ b/drivers/nvme/hw/Kconfig
@@ -2,6 +2,7 @@
 config NVME_QEDN
 	tristate "Marvell NVM Express over Fabrics TCP offload"
 	depends on NVME_TCP_OFFLOAD
+	select QED_NVMETCP
 	help
 	  This enables the Marvell NVMe TCP offload support (qedn).
 
diff --git a/drivers/nvme/hw/qedn/qedn.c b/drivers/nvme/hw/qedn/qedn.c
index 1fe33335989c..11b31d086d27 100644
--- a/drivers/nvme/hw/qedn/qedn.c
+++ b/drivers/nvme/hw/qedn/qedn.c
@@ -14,6 +14,10 @@
 
 #define CHIP_NUM_AHP_NVMETCP 0x8194
 
+const struct qed_nvmetcp_ops *qed_ops;
+
+/* Global context instance */
+struct qedn_global qedn_glb;
 static struct pci_device_id qedn_pci_tbl[] = {
 	{ PCI_VDEVICE(QLOGIC, CHIP_NUM_AHP_NVMETCP), 0 },
 	{0, 0},
@@ -94,12 +98,132 @@ static struct nvme_tcp_ofld_ops qedn_ofld_ops = {
 	.send_req = qedn_send_req,
 };
 
+/* Initialize qedn fields, such as locks, lists, atomics, workqueues , hashes */
+static inline void qedn_init_pf_struct(struct qedn_ctx *qedn)
+{
+	/* Placeholder */
+}
+
+static inline void
+qedn_init_core_probe_params(struct qed_probe_params *probe_params)
+{
+	memset(probe_params, 0, sizeof(*probe_params));
+	probe_params->protocol = QED_PROTOCOL_NVMETCP;
+	probe_params->is_vf = false;
+	probe_params->recov_in_prog = 0;
+}
+
+static inline int qedn_core_probe(struct qedn_ctx *qedn)
+{
+	struct qed_probe_params probe_params;
+	int rc = 0;
+
+	qedn_init_core_probe_params(&probe_params);
+	pr_info("Starting QED probe\n");
+	qedn->cdev = qed_ops->common->probe(qedn->pdev, &probe_params);
+	if (!qedn->cdev) {
+		rc = -ENODEV;
+		pr_err("QED probe failed\n");
+	}
+
+	return rc;
+}
+
+static void qedn_add_pf_to_gl_list(struct qedn_ctx *qedn)
+{
+	mutex_lock(&qedn_glb.glb_mutex);
+	list_add_tail(&qedn->gl_pf_entry, &qedn_glb.qedn_pf_list);
+	mutex_unlock(&qedn_glb.glb_mutex);
+}
+
+static void qedn_remove_pf_from_gl_list(struct qedn_ctx *qedn)
+{
+	mutex_lock(&qedn_glb.glb_mutex);
+	list_del_init(&qedn->gl_pf_entry);
+	mutex_unlock(&qedn_glb.glb_mutex);
+}
+
+static int qedn_set_nvmetcp_pf_param(struct qedn_ctx *qedn)
+{
+	struct qed_nvmetcp_pf_params *pf_params;
+
+	pf_params = &qedn->pf_params.nvmetcp_pf_params;
+	memset(pf_params, 0, sizeof(*pf_params));
+	qedn->num_fw_cqs = min_t(u8, qedn->dev_info.num_cqs, num_online_cpus());
+
+	pf_params->num_cons = QEDN_MAX_CONNS_PER_PF;
+	pf_params->num_tasks = QEDN_MAX_TASKS_PER_PF;
+
+	/* Placeholder - Initialize function level queues */
+
+	/* Placeholder - Initialize TCP params */
+
+	/* Queues */
+	pf_params->num_sq_pages_in_ring = QEDN_NVMETCP_NUM_FW_SQ_PAGES * 2;
+	pf_params->num_r2tq_pages_in_ring = QEDN_NVMETCP_NUM_FW_SQ_PAGES;
+	pf_params->num_uhq_pages_in_ring = QEDN_NVMETCP_NUM_FW_SQ_PAGES;
+	pf_params->num_queues = qedn->num_fw_cqs;
+	pf_params->cq_num_entries = QEDN_FW_CQ_SIZE;
+
+	/* the CQ SB pi */
+	pf_params->gl_rq_pi = QEDN_PROTO_CQ_PROD_IDX;
+
+	return 0;
+}
+
+static inline int qedn_slowpath_start(struct qedn_ctx *qedn)
+{
+	struct qed_slowpath_params sp_params = {};
+	int rc = 0;
+
+	/* Start the Slowpath-process */
+	sp_params.int_mode = QED_INT_MODE_MSIX;
+	sp_params.drv_major = QEDN_MAJOR_VERSION;
+	sp_params.drv_minor = QEDN_MINOR_VERSION;
+	sp_params.drv_rev = QEDN_REVISION_VERSION;
+	sp_params.drv_eng = QEDN_ENGINEERING_VERSION;
+	strlcpy(sp_params.name, "qedn NVMeTCP", QED_DRV_VER_STR_SIZE);
+	rc = qed_ops->common->slowpath_start(qedn->cdev, &sp_params);
+	if (rc)
+		pr_err("Cannot start slowpath\n");
+
+	return rc;
+}
+
 static void __qedn_remove(struct pci_dev *pdev)
 {
 	struct qedn_ctx *qedn = pci_get_drvdata(pdev);
+	int rc;
+
+	pr_notice("qedn remove started: abs PF id=%u\n",
+		  qedn->dev_info.common.abs_pf_id);
+
+	if (test_and_set_bit(QEDN_STATE_MODULE_REMOVE_ONGOING, &qedn->state)) {
+		pr_err("Remove already ongoing\n");
+
+		return;
+	}
+
+	if (test_and_clear_bit(QEDN_STATE_REGISTERED_OFFLOAD_DEV, &qedn->state))
+		nvme_tcp_ofld_unregister_dev(&qedn->qedn_ofld_dev);
+
+	if (test_and_set_bit(QEDN_STATE_MFW_STATE, &qedn->state)) {
+		rc = qed_ops->common->update_drv_state(qedn->cdev, false);
+		if (rc)
+			pr_err("Failed to send drv state to MFW\n");
+	}
+
+	if (test_and_clear_bit(QEDN_STATE_GL_PF_LIST_ADDED, &qedn->state))
+		qedn_remove_pf_from_gl_list(qedn);
+	else
+		pr_err("Failed to remove from global PF list\n");
+
+	if (test_and_clear_bit(QEDN_STATE_CORE_OPEN, &qedn->state))
+		qed_ops->common->slowpath_stop(qedn->cdev);
+
+	if (test_and_clear_bit(QEDN_STATE_CORE_PROBED, &qedn->state))
+		qed_ops->common->remove(qedn->cdev);
 
-	pr_notice("Starting qedn_remove\n");
-	nvme_tcp_ofld_unregister_dev(&qedn->qedn_ofld_dev);
 	kfree(qedn);
 	pr_notice("Ending qedn_remove successfully\n");
 }
@@ -139,15 +263,56 @@ static int __qedn_probe(struct pci_dev *pdev)
 	if (!qedn)
 		return -ENODEV;
 
+	qedn_init_pf_struct(qedn);
+
+	/* QED probe */
+	rc = qedn_core_probe(qedn);
+	if (rc)
+		goto exit_probe_and_release_mem;
+
+	set_bit(QEDN_STATE_CORE_PROBED, &qedn->state);
+
+	/* For global number of FW CQs */
+	rc = qed_ops->fill_dev_info(qedn->cdev, &qedn->dev_info);
+	if (rc) {
+		pr_err("fill_dev_info failed\n");
+		goto exit_probe_and_release_mem;
+	}
+
+	qedn_add_pf_to_gl_list(qedn);
+	set_bit(QEDN_STATE_GL_PF_LIST_ADDED, &qedn->state);
+
+	rc = qedn_set_nvmetcp_pf_param(qedn);
+	if (rc)
+		goto exit_probe_and_release_mem;
+
+	qed_ops->common->update_pf_params(qedn->cdev, &qedn->pf_params);
+	rc = qedn_slowpath_start(qedn);
+	if (rc)
+		goto exit_probe_and_release_mem;
+
+	set_bit(QEDN_STATE_CORE_OPEN, &qedn->state);
+
+	rc = qed_ops->common->update_drv_state(qedn->cdev, true);
+	if (rc) {
+		pr_err("Failed to send drv state to MFW\n");
+		goto exit_probe_and_release_mem;
+	}
+
+	set_bit(QEDN_STATE_MFW_STATE, &qedn->state);
+
 	qedn->qedn_ofld_dev.ops = &qedn_ofld_ops;
 	INIT_LIST_HEAD(&qedn->qedn_ofld_dev.entry);
 	rc = nvme_tcp_ofld_register_dev(&qedn->qedn_ofld_dev);
 	if (rc)
-		goto release_qedn;
+		goto exit_probe_and_release_mem;
+
+	set_bit(QEDN_STATE_REGISTERED_OFFLOAD_DEV, &qedn->state);
 
 	return 0;
-release_qedn:
-	kfree(qedn);
+exit_probe_and_release_mem:
+	__qedn_remove(pdev);
+	pr_err("probe ended with error\n");
 
 	return rc;
 }
@@ -165,13 +330,30 @@ static struct pci_driver qedn_pci_driver = {
 	.shutdown = qedn_shutdown,
 };
 
+static inline void qedn_init_global_contxt(void)
+{
+	INIT_LIST_HEAD(&qedn_glb.qedn_pf_list);
+	INIT_LIST_HEAD(&qedn_glb.ctrl_list);
+	mutex_init(&qedn_glb.glb_mutex);
+}
+
 static int __init qedn_init(void)
 {
 	int rc;
 
+	qedn_init_global_contxt();
+
+	qed_ops = qed_get_nvmetcp_ops();
+	if (!qed_ops) {
+		pr_err("Failed to get QED NVMeTCP ops\n");
+
+		return -EINVAL;
+	}
+
 	rc = pci_register_driver(&qedn_pci_driver);
 	if (rc) {
 		pr_err("Failed to register pci driver\n");
+
 		return -EINVAL;
 	}
 
@@ -183,6 +365,7 @@ static int __init qedn_init(void)
 static void __exit qedn_cleanup(void)
 {
 	pci_unregister_driver(&qedn_pci_driver);
+	qed_put_nvmetcp_ops();
 	pr_notice("Unloading qedn ended\n");
 }
 
diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
index 401fde08000e..634e1217639a 100644
--- a/drivers/nvme/hw/qedn/qedn.h
+++ b/drivers/nvme/hw/qedn/qedn.h
@@ -3,12 +3,61 @@
  * Copyright 2021 Marvell. All rights reserved.
  */
 
+#include <linux/qed/qed_if.h>
+#include <linux/qed/qed_nvmetcp_if.h>
+
 /* Driver includes */
 #include "../../host/tcp-offload.h"
 
+#define QEDN_MAJOR_VERSION		8
+#define QEDN_MINOR_VERSION		62
+#define QEDN_REVISION_VERSION		10
+#define QEDN_ENGINEERING_VERSION	0
+#define DRV_MODULE_VERSION __stringify(QEDE_MAJOR_VERSION) "."	\
+		__stringify(QEDE_MINOR_VERSION) "."		\
+		__stringify(QEDE_REVISION_VERSION) "."		\
+		__stringify(QEDE_ENGINEERING_VERSION)
+
 #define QEDN_MODULE_NAME "qedn"
 
+#define QEDN_MAX_TASKS_PER_PF (32 * 1024)
+#define QEDN_MAX_CONNS_PER_PF (8 * 1024)
+#define QEDN_FW_CQ_SIZE (4 * 1024)
+#define QEDN_PROTO_CQ_PROD_IDX	0
+#define QEDN_NVMETCP_NUM_FW_SQ_PAGES 4
+
+enum qedn_state {
+	QEDN_STATE_CORE_PROBED = 0,
+	QEDN_STATE_CORE_OPEN,
+	QEDN_STATE_GL_PF_LIST_ADDED,
+	QEDN_STATE_MFW_STATE,
+	QEDN_STATE_REGISTERED_OFFLOAD_DEV,
+	QEDN_STATE_MODULE_REMOVE_ONGOING,
+};
+
 struct qedn_ctx {
 	struct pci_dev *pdev;
+	struct qed_dev *cdev;
+	struct qed_dev_nvmetcp_info dev_info;
 	struct nvme_tcp_ofld_dev qedn_ofld_dev;
+	struct qed_pf_params pf_params;
+
+	/* Global PF list entry */
+	struct list_head gl_pf_entry;
+
+	/* Accessed with atomic bit ops , used with enum qedn_state */
+	unsigned long state;
+
+	/* Fast path queues */
+	u8 num_fw_cqs;
+};
+
+struct qedn_global {
+	struct list_head qedn_pf_list;
+
+	/* Host mode */
+	struct list_head ctrl_list;
+
+	/* Mutex for accessing the global struct */
+	struct mutex glb_mutex;
 };
-- 
2.22.0

