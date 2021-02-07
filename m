Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1F231269B
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 19:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhBGSPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 13:15:30 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17414 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229691AbhBGSOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 13:14:54 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 117I67Ol029915;
        Sun, 7 Feb 2021 10:14:06 -0800
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrakmn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Feb 2021 10:14:05 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:14:04 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:14:04 -0800
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 7 Feb 2021 10:14:01 -0800
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <Erik.Smith@dell.com>,
        <Douglas.Farley@dell.com>, <smalin@marvell.com>,
        <aelior@marvell.com>, <mkalderon@marvell.com>,
        <pkushwaha@marvell.com>, <nassa@marvell.com>,
        <malin1024@gmail.com>, Dean Balandin <dbalandin@marvell.com>
Subject: [RFC PATCH v3 09/11] net-qed: Add NVMeTCP Offload PF Level FW and HW HSI
Date:   Sun, 7 Feb 2021 20:13:22 +0200
Message-ID: <20210207181324.11429-10-smalin@marvell.com>
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

This patch introduces the NVMeTCP device and PF level HSI and HSI
functionality in order to initialize and interact with the HW device.

This patch is based on the qede, qedr, qedi, qedf drivers HSI.

Signed-off-by: Dean Balandin <dbalandin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/Kconfig           |   3 +
 drivers/net/ethernet/qlogic/qed/Makefile      |   1 +
 drivers/net/ethernet/qlogic/qed/qed.h         |   3 +
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     |   1 +
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c | 269 ++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h |  48 ++++
 drivers/net/ethernet/qlogic/qed/qed_sp.h      |   2 +
 include/linux/qed/common_hsi.h                |   1 +
 include/linux/qed/nvmetcp_common.h            |  47 +++
 include/linux/qed/qed_if.h                    |  22 ++
 include/linux/qed/qed_nvmetcp_if.h            |  71 +++++
 11 files changed, 468 insertions(+)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
 create mode 100644 include/linux/qed/nvmetcp_common.h
 create mode 100644 include/linux/qed/qed_nvmetcp_if.h

diff --git a/drivers/net/ethernet/qlogic/Kconfig b/drivers/net/ethernet/qlogic/Kconfig
index 4366c7a8de95..1ddd82d83e3f 100644
--- a/drivers/net/ethernet/qlogic/Kconfig
+++ b/drivers/net/ethernet/qlogic/Kconfig
@@ -109,6 +109,9 @@ config QED_RDMA
 config QED_ISCSI
 	bool
 
+config QED_NVMETCP
+	bool
+
 config QED_FCOE
 	bool
 
diff --git a/drivers/net/ethernet/qlogic/qed/Makefile b/drivers/net/ethernet/qlogic/qed/Makefile
index 8251755ec18c..c8f4d40a6285 100644
--- a/drivers/net/ethernet/qlogic/qed/Makefile
+++ b/drivers/net/ethernet/qlogic/qed/Makefile
@@ -23,6 +23,7 @@ qed-y :=			\
 	qed_sp_commands.o	\
 	qed_spq.o
 
+qed-$(CONFIG_QED_NVMETCP) += qed_nvmetcp.o
 qed-$(CONFIG_QED_FCOE) += qed_fcoe.o
 qed-$(CONFIG_QED_ISCSI) += qed_iscsi.o
 qed-$(CONFIG_QED_LL2) += qed_ll2.o
diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index a20cb8a0c377..91d4635009ab 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -240,6 +240,7 @@ enum QED_FEATURE {
 	QED_VF,
 	QED_RDMA_CNQ,
 	QED_ISCSI_CQ,
+	QED_NVMETCP_CQ = QED_ISCSI_CQ,
 	QED_FCOE_CQ,
 	QED_VF_L2_QUE,
 	QED_MAX_FEATURES,
@@ -592,6 +593,7 @@ struct qed_hwfn {
 	struct qed_ooo_info		*p_ooo_info;
 	struct qed_rdma_info		*p_rdma_info;
 	struct qed_iscsi_info		*p_iscsi_info;
+	struct qed_nvmetcp_info		*p_nvmetcp_info;
 	struct qed_fcoe_info		*p_fcoe_info;
 	struct qed_pf_params		pf_params;
 
@@ -828,6 +830,7 @@ struct qed_dev {
 		struct qed_eth_cb_ops		*eth;
 		struct qed_fcoe_cb_ops		*fcoe;
 		struct qed_iscsi_cb_ops		*iscsi;
+		struct qed_nvmetcp_cb_ops	*nvmetcp;
 	} protocol_ops;
 	void				*ops_cookie;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 559df9f4d656..24472f6a83c2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -20,6 +20,7 @@
 #include <linux/qed/fcoe_common.h>
 #include <linux/qed/eth_common.h>
 #include <linux/qed/iscsi_common.h>
+#include <linux/qed/nvmetcp_common.h>
 #include <linux/qed/iwarp_common.h>
 #include <linux/qed/rdma_common.h>
 #include <linux/qed/roce_common.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
new file mode 100644
index 000000000000..720b32a35820
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
@@ -0,0 +1,269 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright 2021 Marvell. All rights reserved.
+ */
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+#include <asm/param.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/etherdevice.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/log2.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/stddef.h>
+#include <linux/string.h>
+#include <linux/workqueue.h>
+#include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/qed/qed_nvmetcp_if.h>
+#include "qed.h"
+#include "qed_cxt.h"
+#include "qed_dev_api.h"
+#include "qed_hsi.h"
+#include "qed_hw.h"
+#include "qed_int.h"
+#include "qed_nvmetcp.h"
+#include "qed_ll2.h"
+#include "qed_mcp.h"
+#include "qed_sp.h"
+#include "qed_reg_addr.h"
+
+static int qed_nvmetcp_async_event(struct qed_hwfn *p_hwfn, u8 fw_event_code,
+				   u16 echo, union event_ring_data *data,
+				   u8 fw_return_code)
+{
+	if (p_hwfn->p_nvmetcp_info->event_cb) {
+		struct qed_nvmetcp_info *p_nvmetcp = p_hwfn->p_nvmetcp_info;
+
+		return p_nvmetcp->event_cb(p_nvmetcp->event_context,
+					 fw_event_code, data);
+	} else {
+		DP_NOTICE(p_hwfn, "nvmetcp async completion is not set\n");
+		return -EINVAL;
+	}
+}
+
+static int qed_sp_nvmetcp_func_start(struct qed_hwfn *p_hwfn,
+				     enum spq_mode comp_mode,
+				     struct qed_spq_comp_cb *p_comp_addr,
+				     void *event_context,
+				     nvmetcp_event_cb_t async_event_cb)
+{
+	struct nvmetcp_init_ramrod_params *p_ramrod = NULL;
+	struct scsi_init_func_queues *p_queue = NULL;
+	struct qed_nvmetcp_pf_params *p_params = NULL;
+	struct nvmetcp_spe_func_init *p_init = NULL;
+	struct qed_sp_init_data init_data = {};
+	struct qed_spq_entry *p_ent = NULL;
+	int rc = 0;
+	u16 val;
+	u8 i;
+
+	/* Get SPQ entry */
+	init_data.cid = qed_spq_get_cid(p_hwfn);
+	init_data.opaque_fid = p_hwfn->hw_info.opaque_fid;
+	init_data.comp_mode = comp_mode;
+	init_data.p_comp_data = p_comp_addr;
+
+	rc = qed_sp_init_request(p_hwfn, &p_ent,
+				 NVMETCP_RAMROD_CMD_ID_INIT_FUNC,
+				 PROTOCOLID_NVMETCP, &init_data);
+	if (rc)
+		return rc;
+
+	p_ramrod = &p_ent->ramrod.nvmetcp_init;
+	p_init = &p_ramrod->nvmetcp_init_spe;
+	p_params = &p_hwfn->pf_params.nvmetcp_pf_params;
+	p_queue = &p_init->q_params;
+
+	p_init->num_sq_pages_in_ring = p_params->num_sq_pages_in_ring;
+	p_init->num_r2tq_pages_in_ring = p_params->num_r2tq_pages_in_ring;
+	p_init->num_uhq_pages_in_ring = p_params->num_uhq_pages_in_ring;
+	p_init->ll2_rx_queue_id = RESC_START(p_hwfn, QED_LL2_RAM_QUEUE) +
+					p_params->ll2_ooo_queue_id;
+
+	p_init->func_params.log_page_size = ilog2(PAGE_SIZE);
+	p_init->func_params.num_tasks = cpu_to_le16(p_params->num_tasks);
+
+	DMA_REGPAIR_LE(p_queue->glbl_q_params_addr,
+		       p_params->glbl_q_params_addr);
+
+	p_queue->cq_num_entries = cpu_to_le16(QED_NVMETCP_FW_CQ_SIZE);
+	p_queue->num_queues = p_params->num_queues;
+	p_queue->queue_relative_offset = (u8)RESC_START(p_hwfn, QED_CMDQS_CQS);
+	p_queue->cq_sb_pi = p_params->gl_rq_pi;
+
+	for (i = 0; i < p_params->num_queues; i++) {
+		val = qed_get_igu_sb_id(p_hwfn, i);
+		p_queue->cq_cmdq_sb_num_arr[i] = cpu_to_le16(val);
+	}
+
+	/* p_ramrod->tcp_init.min_rto = cpu_to_le16(p_params->min_rto); */
+	p_ramrod->tcp_init.two_msl_timer = cpu_to_le32(QED_TCP_TWO_MSL_TIMER);
+	p_ramrod->tcp_init.tx_sws_timer = cpu_to_le16(QED_TCP_SWS_TIMER);
+	p_init->half_way_close_timeout = cpu_to_le16(QED_TCP_HALF_WAY_CLOSE_TIMEOUT);
+	p_ramrod->tcp_init.max_fin_rt = QED_TCP_MAX_FIN_RT;
+
+	p_hwfn->p_nvmetcp_info->event_context = event_context;
+	p_hwfn->p_nvmetcp_info->event_cb = async_event_cb;
+
+	qed_spq_register_async_cb(p_hwfn, PROTOCOLID_NVMETCP,
+				  qed_nvmetcp_async_event);
+
+	return qed_spq_post(p_hwfn, p_ent, NULL);
+}
+
+static int qed_sp_nvmetcp_func_stop(struct qed_hwfn *p_hwfn,
+				    enum spq_mode comp_mode,
+				    struct qed_spq_comp_cb *p_comp_addr)
+{
+	struct qed_spq_entry *p_ent = NULL;
+	struct qed_sp_init_data init_data;
+	int rc = 0;
+
+	/* Get SPQ entry */
+	memset(&init_data, 0, sizeof(init_data));
+	init_data.cid = qed_spq_get_cid(p_hwfn);
+	init_data.opaque_fid = p_hwfn->hw_info.opaque_fid;
+	init_data.comp_mode = comp_mode;
+	init_data.p_comp_data = p_comp_addr;
+
+	rc = qed_sp_init_request(p_hwfn, &p_ent,
+				 NVMETCP_RAMROD_CMD_ID_DESTROY_FUNC,
+				 PROTOCOLID_NVMETCP, &init_data);
+	if (rc)
+		return rc;
+
+	rc = qed_spq_post(p_hwfn, p_ent, NULL);
+
+	qed_spq_unregister_async_cb(p_hwfn, PROTOCOLID_NVMETCP);
+	return rc;
+}
+
+static int qed_fill_nvmetcp_dev_info(struct qed_dev *cdev,
+				     struct qed_dev_nvmetcp_info *info)
+{
+	struct qed_hwfn *hwfn = QED_AFFIN_HWFN(cdev);
+
+	int rc;
+
+	memset(info, 0, sizeof(*info));
+	rc = qed_fill_dev_info(cdev, &info->common);
+
+	info->num_cqs = FEAT_NUM(hwfn, QED_NVMETCP_CQ);
+
+	return rc;
+}
+
+static void qed_register_nvmetcp_ops(struct qed_dev *cdev,
+				     struct qed_nvmetcp_cb_ops *ops,
+				     void *cookie)
+{
+	cdev->protocol_ops.nvmetcp = ops;
+	cdev->ops_cookie = cookie;
+}
+
+static int qed_nvmetcp_stop(struct qed_dev *cdev)
+{
+	int rc;
+
+	if (!(cdev->flags & QED_FLAG_STORAGE_STARTED)) {
+		DP_NOTICE(cdev, "nvmetcp already stopped\n");
+		return 0;
+	}
+
+	if (!hash_empty(cdev->connections)) {
+		DP_NOTICE(cdev,
+			  "Can't stop nvmetcp - not all connections were returned\n");
+		return -EINVAL;
+	}
+
+	/* Stop the nvmetcp */
+	rc = qed_sp_nvmetcp_func_stop(QED_AFFIN_HWFN(cdev), QED_SPQ_MODE_EBLOCK,
+				      NULL);
+	cdev->flags &= ~QED_FLAG_STORAGE_STARTED;
+
+	return rc;
+}
+
+static int qed_nvmetcp_start(struct qed_dev *cdev,
+			     struct qed_nvmetcp_tid *tasks,
+			     void *event_context,
+			     nvmetcp_event_cb_t async_event_cb)
+{
+	struct qed_tid_mem *tid_info;
+	int rc;
+
+	if (cdev->flags & QED_FLAG_STORAGE_STARTED) {
+		DP_NOTICE(cdev, "nvmetcp already started;\n");
+		return 0;
+	}
+
+	rc = qed_sp_nvmetcp_func_start(QED_AFFIN_HWFN(cdev),
+				       QED_SPQ_MODE_EBLOCK,
+				       NULL,
+				       event_context,
+				       async_event_cb);
+	if (rc) {
+		DP_NOTICE(cdev, "Failed to start nvmetcp\n");
+		return rc;
+	}
+
+	cdev->flags |= QED_FLAG_STORAGE_STARTED;
+	hash_init(cdev->connections);
+
+	if (!tasks)
+		return 0;
+
+	tid_info = kzalloc(sizeof(*tid_info), GFP_KERNEL);
+
+	if (!tid_info) {
+		qed_nvmetcp_stop(cdev);
+		return -ENOMEM;
+	}
+
+	rc = qed_cxt_get_tid_mem_info(QED_AFFIN_HWFN(cdev), tid_info);
+	if (rc) {
+		DP_NOTICE(cdev, "Failed to gather task information\n");
+		qed_nvmetcp_stop(cdev);
+		kfree(tid_info);
+		return rc;
+	}
+
+	/* Fill task information */
+	tasks->size = tid_info->tid_size;
+	tasks->num_tids_per_block = tid_info->num_tids_per_block;
+	memcpy(tasks->blocks, tid_info->blocks,
+	       MAX_TID_BLOCKS_NVMETCP * sizeof(u8 *));
+
+	kfree(tid_info);
+
+	return 0;
+}
+
+static const struct qed_nvmetcp_ops qed_nvmetcp_ops_pass = {
+	.common = &qed_common_ops_pass,
+	.ll2 = &qed_ll2_ops_pass,
+	.fill_dev_info = &qed_fill_nvmetcp_dev_info,
+	.register_ops = &qed_register_nvmetcp_ops,
+	.start = &qed_nvmetcp_start,
+	.stop = &qed_nvmetcp_stop,
+
+	/* Placeholder - Connection level ops */
+};
+
+const struct qed_nvmetcp_ops *qed_get_nvmetcp_ops(void)
+{
+	return &qed_nvmetcp_ops_pass;
+}
+EXPORT_SYMBOL(qed_get_nvmetcp_ops);
+
+void qed_put_nvmetcp_ops(void)
+{
+}
+EXPORT_SYMBOL(qed_put_nvmetcp_ops);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
new file mode 100644
index 000000000000..cb10d526a241
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright 2021 Marvell. All rights reserved.
+ */
+
+#ifndef _QED_NVMETCP_H
+#define _QED_NVMETCP_H
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/qed/tcp_common.h>
+#include <linux/qed/qed_nvmetcp_if.h>
+#include <linux/qed/qed_chain.h>
+#include "qed.h"
+#include "qed_hsi.h"
+#include "qed_mcp.h"
+#include "qed_sp.h"
+
+#define QED_NVMETCP_FW_CQ_SIZE	(4 * 1024)
+
+/* tcp parameters */
+#define QED_TCP_TWO_MSL_TIMER 4000
+#define QED_TCP_HALF_WAY_CLOSE_TIMEOUT 10
+#define QED_TCP_MAX_FIN_RT 2
+#define QED_TCP_SWS_TIMER 5000
+
+struct qed_nvmetcp_info {
+	spinlock_t lock; /* Connection resources. */
+	struct list_head free_list;
+	u16 max_num_outstanding_tasks;
+	void *event_context;
+	nvmetcp_event_cb_t event_cb;
+};
+
+#if IS_ENABLED(CONFIG_QED_NVMETCP)
+void qed_nvmetcp_setup(struct qed_hwfn *p_hwfn);
+
+void qed_nvmetcp_free(struct qed_hwfn *p_hwfn);
+
+#else /* IS_ENABLED(CONFIG_QED_NVMETCP) */
+static inline void qed_nvmetcp_setup(struct qed_hwfn *p_hwfn) {}
+
+static inline void qed_nvmetcp_free(struct qed_hwfn *p_hwfn) {}
+
+#endif /* IS_ENABLED(CONFIG_QED_NVMETCP) */
+
+#endif
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp.h b/drivers/net/ethernet/qlogic/qed/qed_sp.h
index 993f1357b6fc..525159e747a5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp.h
@@ -100,6 +100,8 @@ union ramrod_data {
 	struct iscsi_spe_conn_mac_update iscsi_conn_mac_update;
 	struct iscsi_spe_conn_termination iscsi_conn_terminate;
 
+	struct nvmetcp_init_ramrod_params nvmetcp_init;
+
 	struct vf_start_ramrod_data vf_start;
 	struct vf_stop_ramrod_data vf_stop;
 };
diff --git a/include/linux/qed/common_hsi.h b/include/linux/qed/common_hsi.h
index 977807e1be53..59c5e5866607 100644
--- a/include/linux/qed/common_hsi.h
+++ b/include/linux/qed/common_hsi.h
@@ -703,6 +703,7 @@ enum mf_mode {
 /* Per-protocol connection types */
 enum protocol_type {
 	PROTOCOLID_ISCSI,
+	PROTOCOLID_NVMETCP = PROTOCOLID_ISCSI,
 	PROTOCOLID_FCOE,
 	PROTOCOLID_ROCE,
 	PROTOCOLID_CORE,
diff --git a/include/linux/qed/nvmetcp_common.h b/include/linux/qed/nvmetcp_common.h
new file mode 100644
index 000000000000..0b097125efce
--- /dev/null
+++ b/include/linux/qed/nvmetcp_common.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright 2021 Marvell. All rights reserved.
+ */
+
+#ifndef __NVMETCP_COMMON__
+#define __NVMETCP_COMMON__
+
+#include "tcp_common.h"
+
+/*  * NVMeTCP firmware function init parameters */
+struct nvmetcp_spe_func_init {
+	__le16 reserved;
+	__le16 half_way_close_timeout;
+	u8 num_sq_pages_in_ring;
+	u8 num_r2tq_pages_in_ring;
+	u8 num_uhq_pages_in_ring;
+	u8 ll2_rx_queue_id;
+	u8 flags;
+#define NVMETCP_SPE_FUNC_INIT_COUNTERS_EN_MASK   0x1
+#define NVMETCP_SPE_FUNC_INIT_COUNTERS_EN_SHIFT  0
+#define NVMETCP_SPE_FUNC_INIT_NVMETCP_MODE_MASK  0x1
+#define NVMETCP_SPE_FUNC_INIT_NVMETCP_MODE_SHIFT 1
+#define NVMETCP_SPE_FUNC_INIT_RESERVED0_MASK     0x3F
+#define NVMETCP_SPE_FUNC_INIT_RESERVED0_SHIFT    2
+	u8 debug_flags;
+	__le16 reserved1;
+	__le32 reserved2;
+	struct scsi_init_func_params func_params;
+	struct scsi_init_func_queues q_params;
+};
+
+/* NVMeTCP init params passed by driver to FW in NVMeTCP init ramrod. */
+struct nvmetcp_init_ramrod_params {
+	struct nvmetcp_spe_func_init nvmetcp_init_spe;
+	struct tcp_init_params tcp_init;
+};
+
+/* NVMeTCP Ramrod Command IDs */
+enum nvmetcp_ramrod_cmd_id {
+	NVMETCP_RAMROD_CMD_ID_UNUSED = 0,
+	NVMETCP_RAMROD_CMD_ID_INIT_FUNC = 1,
+	NVMETCP_RAMROD_CMD_ID_DESTROY_FUNC = 2,
+	MAX_NVMETCP_RAMROD_CMD_ID
+};
+
+#endif /* __NVMETCP_COMMON__ */
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 68d17a4fbf20..524f57821ba2 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -542,6 +542,26 @@ struct qed_iscsi_pf_params {
 	u8 bdq_pbl_num_entries[3];
 };
 
+struct qed_nvmetcp_pf_params {
+	u64 glbl_q_params_addr;
+	u16 cq_num_entries;
+
+	u16 num_cons;
+	u16 num_tasks;
+
+	u8 num_sq_pages_in_ring;
+	u8 num_r2tq_pages_in_ring;
+	u8 num_uhq_pages_in_ring;
+
+	u8 num_queues;
+	u8 gl_rq_pi;
+	u8 gl_cmd_pi;
+	u8 debug_mode;
+	u8 ll2_ooo_queue_id;
+
+	u16 min_rto;
+};
+
 struct qed_rdma_pf_params {
 	/* Supplied to QED during resource allocation (may affect the ILT and
 	 * the doorbell BAR).
@@ -560,6 +580,7 @@ struct qed_pf_params {
 	struct qed_eth_pf_params eth_pf_params;
 	struct qed_fcoe_pf_params fcoe_pf_params;
 	struct qed_iscsi_pf_params iscsi_pf_params;
+	struct qed_nvmetcp_pf_params nvmetcp_pf_params;
 	struct qed_rdma_pf_params rdma_pf_params;
 };
 
@@ -662,6 +683,7 @@ enum qed_sb_type {
 enum qed_protocol {
 	QED_PROTOCOL_ETH,
 	QED_PROTOCOL_ISCSI,
+	QED_PROTOCOL_NVMETCP = QED_PROTOCOL_ISCSI,
 	QED_PROTOCOL_FCOE,
 };
 
diff --git a/include/linux/qed/qed_nvmetcp_if.h b/include/linux/qed/qed_nvmetcp_if.h
new file mode 100644
index 000000000000..4e0f4c02d347
--- /dev/null
+++ b/include/linux/qed/qed_nvmetcp_if.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright 2021 Marvell. All rights reserved.
+ */
+
+#ifndef _QED_NVMETCP_IF_H
+#define _QED_NVMETCP_IF_H
+#include <linux/types.h>
+#include <linux/qed/qed_if.h>
+
+typedef int (*nvmetcp_event_cb_t) (void *context,
+				   u8 fw_event_code, void *fw_handle);
+
+struct qed_dev_nvmetcp_info {
+	struct qed_dev_info common;
+
+	u8 num_cqs;
+};
+
+#define MAX_TID_BLOCKS_NVMETCP (512)
+struct qed_nvmetcp_tid {
+	u32 size;		/* In bytes per task */
+	u32 num_tids_per_block;
+	u8 *blocks[MAX_TID_BLOCKS_NVMETCP];
+};
+
+struct qed_nvmetcp_cb_ops {
+	struct qed_common_cb_ops common;
+};
+
+/**
+ * struct qed_nvmetcp_ops - qed NVMeTCP operations.
+ * @common:		common operations pointer
+ * @ll2:		light L2 operations pointer
+ * @fill_dev_info:	fills NVMeTCP specific information
+ *			@param cdev
+ *			@param info
+ *			@return 0 on success, otherwise error value.
+ * @register_ops:	register nvmetcp operations
+ *			@param cdev
+ *			@param ops - specified using qed_nvmetcp_cb_ops
+ *			@param cookie - driver private
+ * @start:		nvmetcp in FW
+ *			@param cdev
+ *			@param tasks - qed will fill information about tasks
+ *			return 0 on success, otherwise error value.
+ * @stop:		nvmetcp in FW
+ *			@param cdev
+ *			return 0 on success, otherwise error value.
+ */
+struct qed_nvmetcp_ops {
+	const struct qed_common_ops *common;
+
+	const struct qed_ll2_ops *ll2;
+
+	int (*fill_dev_info)(struct qed_dev *cdev,
+			     struct qed_dev_nvmetcp_info *info);
+
+	void (*register_ops)(struct qed_dev *cdev,
+			     struct qed_nvmetcp_cb_ops *ops, void *cookie);
+
+	int (*start)(struct qed_dev *cdev,
+		     struct qed_nvmetcp_tid *tasks,
+		     void *event_context, nvmetcp_event_cb_t async_event_cb);
+
+	int (*stop)(struct qed_dev *cdev);
+};
+
+const struct qed_nvmetcp_ops *qed_get_nvmetcp_ops(void);
+void qed_put_nvmetcp_ops(void);
+#endif
-- 
2.22.0

