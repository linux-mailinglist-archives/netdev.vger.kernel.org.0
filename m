Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB45436F04C
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 21:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhD2TSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 15:18:01 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9234 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241662AbhD2TM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 15:12:59 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13TJ6FOY019575;
        Thu, 29 Apr 2021 12:11:03 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 387erumw58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Apr 2021 12:11:03 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Apr
 2021 12:11:01 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 12:10:58 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>, <hch@lst.de>, <axboe@fb.com>,
        <kbusch@kernel.org>
CC:     =?UTF-8?q?David=20S=20=2E=20Miller=20davem=20=40=20davemloft=20=2E=20net=20=C2=A0--cc=3DJakub=20Kicinski?= 
        <kuba@kernel.org>, <smalin@marvell.com>, <aelior@marvell.com>,
        <mkalderon@marvell.com>, <okulkarni@marvell.com>,
        <pkushwaha@marvell.com>, <malin1024@gmail.com>
Subject: [RFC PATCH v4 20/27] qedn: Add connection-level slowpath functionality
Date:   Thu, 29 Apr 2021 22:09:19 +0300
Message-ID: <20210429190926.5086-21-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210429190926.5086-1-smalin@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: rblbXDVKIaInsOo1k3shlaYQ3oaVrYZS
X-Proofpoint-ORIG-GUID: rblbXDVKIaInsOo1k3shlaYQ3oaVrYZS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-29_10:2021-04-28,2021-04-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prabhakar Kushwaha <pkushwaha@marvell.com>

This patch will present the connection (queue) level slowpath
implementation relevant for create_queue flow.

The internal implementation:
- Add per controller slowpath workqeueue via pre_setup_ctrl

- qedn_main.c:
  Includes qedn's implementation of the create_queue op.

- qedn_conn.c will include main slowpath connection level functions,
  including:
    1. Per-queue resources allocation.
    2. Creating a new connection.
    3. Offloading the connection to the FW for TCP handshake.
    4. Destroy of a connection.
    5. Support of delete and free controller.
    6. TCP port management via qed_fetch_tcp_port, qed_return_tcp_port

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/nvme/hw/qedn/Makefile    |   5 +-
 drivers/nvme/hw/qedn/qedn.h      | 173 ++++++++++-
 drivers/nvme/hw/qedn/qedn_conn.c | 508 +++++++++++++++++++++++++++++++
 drivers/nvme/hw/qedn/qedn_main.c | 208 ++++++++++++-
 4 files changed, 883 insertions(+), 11 deletions(-)
 create mode 100644 drivers/nvme/hw/qedn/qedn_conn.c

diff --git a/drivers/nvme/hw/qedn/Makefile b/drivers/nvme/hw/qedn/Makefile
index cb169bbaae18..d8b343afcd16 100644
--- a/drivers/nvme/hw/qedn/Makefile
+++ b/drivers/nvme/hw/qedn/Makefile
@@ -1,5 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-obj-$(CONFIG_NVME_QEDN) := qedn.o
-
-qedn-y := qedn_main.o
\ No newline at end of file
+obj-$(CONFIG_NVME_QEDN) += qedn.o
+qedn-y := qedn_main.o qedn_conn.o
diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
index 5d4d04d144e4..ed0d43163da2 100644
--- a/drivers/nvme/hw/qedn/qedn.h
+++ b/drivers/nvme/hw/qedn/qedn.h
@@ -6,6 +6,7 @@
 #ifndef _QEDN_H_
 #define _QEDN_H_
 
+#include <linux/qed/common_hsi.h>
 #include <linux/qed/qed_if.h>
 #include <linux/qed/qed_nvmetcp_if.h>
 #include <linux/qed/qed_nvmetcp_ip_services_if.h>
@@ -37,8 +38,41 @@
 #define QEDN_IRQ_NAME_LEN 24
 #define QEDN_IRQ_NO_FLAGS 0
 
-/* TCP defines */
+/* Destroy connection defines */
+#define QEDN_NON_ABORTIVE_TERMINATION 0
+#define QEDN_ABORTIVE_TERMINATION 1
+
+/*
+ * TCP offload stack default configurations and defines.
+ * Future enhancements will allow controlling the configurable
+ * parameters via devlink.
+ */
 #define QEDN_TCP_RTO_DEFAULT 280
+#define QEDN_TCP_ECN_EN 0
+#define QEDN_TCP_TS_EN 0
+#define QEDN_TCP_DA_EN 0
+#define QEDN_TCP_KA_EN 0
+#define QEDN_TCP_TOS 0
+#define QEDN_TCP_TTL 0xfe
+#define QEDN_TCP_FLOW_LABEL 0
+#define QEDN_TCP_KA_TIMEOUT 7200000
+#define QEDN_TCP_KA_INTERVAL 10000
+#define QEDN_TCP_KA_MAX_PROBE_COUNT 10
+#define QEDN_TCP_MAX_RT_TIME 1200
+#define QEDN_TCP_MAX_CWND 4
+#define QEDN_TCP_RCV_WND_SCALE 2
+#define QEDN_TCP_TS_OPTION_LEN 12
+
+/* SP Work queue defines */
+#define QEDN_SP_WORKQUEUE "qedn_sp_wq"
+#define QEDN_SP_WORKQUEUE_MAX_ACTIVE 1
+
+#define QEDN_HOST_MAX_SQ_SIZE (512)
+#define QEDN_SQ_SIZE (2 * QEDN_HOST_MAX_SQ_SIZE)
+
+/* Timeouts and delay constants */
+#define QEDN_WAIT_CON_ESTABLSH_TMO 10000 /* 10 seconds */
+#define QEDN_RLS_CONS_TMO 5000 /* 5 sec */
 
 enum qedn_state {
 	QEDN_STATE_CORE_PROBED = 0,
@@ -78,6 +112,12 @@ struct qedn_ctx {
 	/* Accessed with atomic bit ops, used with enum qedn_state */
 	unsigned long state;
 
+	u8 local_mac_addr[ETH_ALEN];
+	u16 mtu;
+
+	/* Connections */
+	DECLARE_HASHTABLE(conn_ctx_hash, 16);
+
 	/* Fast path queues */
 	u8 num_fw_cqs;
 	struct qedn_fp_queue *fp_q_arr;
@@ -85,6 +125,126 @@ struct qedn_ctx {
 	dma_addr_t fw_cq_array_phy; /* Physical address of fw_cq_array_virt */
 };
 
+struct qedn_endpoint {
+	/* FW Params */
+	struct qed_chain fw_sq_chain;
+	void __iomem *p_doorbell;
+
+	/* TCP Params */
+	__be32 dst_addr[4]; /* In network order */
+	__be32 src_addr[4]; /* In network order */
+	u16 src_port;
+	u16 dst_port;
+	u16 vlan_id;
+	u8 src_mac[ETH_ALEN];
+	u8 dst_mac[ETH_ALEN];
+	u8 ip_type;
+};
+
+enum sp_work_agg_action {
+	CREATE_CONNECTION = 0,
+	SEND_ICREQ,
+	HANDLE_ICRESP,
+	DESTROY_CONNECTION,
+};
+
+enum qedn_ctrl_agg_state {
+	QEDN_CTRL_SET_TO_OFLD_CTRL = 0, /* CTRL set to OFLD_CTRL */
+	QEDN_STATE_SP_WORK_THREAD_SET, /* slow patch WQ was created*/
+	LLH_FILTER, /* LLH filter added */
+	QEDN_RECOVERY,
+	ADMINQ_CONNECTED, /* At least one connection has attempted offload */
+	ERR_FLOW,
+};
+
+enum qedn_ctrl_sp_wq_state {
+	QEDN_CTRL_STATE_UNINITIALIZED = 0,
+	QEDN_CTRL_STATE_FREE_CTRL,
+	QEDN_CTRL_STATE_CTRL_ERR,
+};
+
+/* Any change to this enum requires an update of qedn_conn_state_str */
+enum qedn_conn_state {
+	CONN_STATE_CONN_IDLE = 0,
+	CONN_STATE_CREATE_CONNECTION,
+	CONN_STATE_WAIT_FOR_CONNECT_DONE,
+	CONN_STATE_OFFLOAD_COMPLETE,
+	CONN_STATE_WAIT_FOR_UPDATE_EQE,
+	CONN_STATE_WAIT_FOR_IC_COMP,
+	CONN_STATE_NVMETCP_CONN_ESTABLISHED,
+	CONN_STATE_DESTROY_CONNECTION,
+	CONN_STATE_WAIT_FOR_DESTROY_DONE,
+	CONN_STATE_DESTROY_COMPLETE
+};
+
+struct qedn_ctrl {
+	struct list_head glb_entry;
+	struct list_head pf_entry;
+
+	struct qedn_ctx *qedn;
+	struct nvme_tcp_ofld_queue *queue;
+	struct nvme_tcp_ofld_ctrl *ctrl;
+
+	struct workqueue_struct *sp_wq;
+	enum qedn_ctrl_sp_wq_state sp_wq_state;
+
+	struct work_struct sp_wq_entry;
+
+	struct qedn_llh_filter *llh_filter;
+
+	unsigned long agg_state;
+
+	atomic_t host_num_active_conns;
+};
+
+/* Connection level struct */
+struct qedn_conn_ctx {
+	struct qedn_ctx *qedn;
+	struct nvme_tcp_ofld_queue *queue;
+	struct nvme_tcp_ofld_ctrl *ctrl;
+	u32 conn_handle;
+	u32 fw_cid;
+
+	atomic_t est_conn_indicator;
+	atomic_t destroy_conn_indicator;
+	wait_queue_head_t conn_waitq;
+
+	struct work_struct sp_wq_entry;
+
+	/* Connection aggregative state.
+	 * Can have different states independently.
+	 */
+	unsigned long agg_work_action;
+
+	struct hlist_node hash_node;
+	struct nvmetcp_host_cccid_itid_entry *host_cccid_itid;
+	dma_addr_t host_cccid_itid_phy_addr;
+	struct qedn_endpoint ep;
+	int abrt_flag;
+
+	/* Connection resources - turned on to indicate what resource was
+	 * allocated, to that it can later be released.
+	 */
+	unsigned long resrc_state;
+
+	/* Connection state */
+	spinlock_t conn_state_lock;
+	enum qedn_conn_state state;
+
+	size_t sq_depth;
+
+	/* "dummy" socket */
+	struct socket *sock;
+};
+
+enum qedn_conn_resources_state {
+	QEDN_CONN_RESRC_FW_SQ,
+	QEDN_CONN_RESRC_ACQUIRE_CONN,
+	QEDN_CONN_RESRC_CCCID_ITID_MAP,
+	QEDN_CONN_RESRC_TCP_PORT,
+	QEDN_CONN_RESRC_MAX = 64
+};
+
 struct qedn_global {
 	struct list_head qedn_pf_list;
 
@@ -95,4 +255,15 @@ struct qedn_global {
 	struct mutex glb_mutex;
 };
 
+struct qedn_conn_ctx *qedn_get_conn_hash(struct qedn_ctx *qedn, u16 icid);
+int qedn_event_cb(void *context, u8 fw_event_code, void *event_ring_data);
+void qedn_sp_wq_handler(struct work_struct *work);
+void qedn_set_sp_wa(struct qedn_conn_ctx *conn_ctx, u32 bit);
+void qedn_clr_sp_wa(struct qedn_conn_ctx *conn_ctx, u32 bit);
+int qedn_initialize_endpoint(struct qedn_endpoint *ep, u8 *local_mac_addr,
+			     struct nvme_tcp_ofld_ctrl_con_params *conn_params);
+int qedn_wait_for_conn_est(struct qedn_conn_ctx *conn_ctx);
+int qedn_set_con_state(struct qedn_conn_ctx *conn_ctx, enum qedn_conn_state new_state);
+void qedn_terminate_connection(struct qedn_conn_ctx *conn_ctx, int abrt_flag);
+
 #endif /* _QEDN_H_ */
diff --git a/drivers/nvme/hw/qedn/qedn_conn.c b/drivers/nvme/hw/qedn/qedn_conn.c
new file mode 100644
index 000000000000..9bfc0a5f0cdb
--- /dev/null
+++ b/drivers/nvme/hw/qedn/qedn_conn.c
@@ -0,0 +1,508 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2021 Marvell. All rights reserved.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+ /* Kernel includes */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <net/tcp.h>
+
+/* Driver includes */
+#include "qedn.h"
+
+extern const struct qed_nvmetcp_ops *qed_ops;
+
+static const char * const qedn_conn_state_str[] = {
+	"CONN_IDLE",
+	"CREATE_CONNECTION",
+	"WAIT_FOR_CONNECT_DONE",
+	"OFFLOAD_COMPLETE",
+	"WAIT_FOR_UPDATE_EQE",
+	"WAIT_FOR_IC_COMP",
+	"NVMETCP_CONN_ESTABLISHED",
+	"DESTROY_CONNECTION",
+	"WAIT_FOR_DESTROY_DONE",
+	"DESTROY_COMPLETE",
+	NULL
+};
+
+int qedn_set_con_state(struct qedn_conn_ctx *conn_ctx, enum qedn_conn_state new_state)
+{
+	spin_lock_bh(&conn_ctx->conn_state_lock);
+	conn_ctx->state = new_state;
+	spin_unlock_bh(&conn_ctx->conn_state_lock);
+
+	return 0;
+}
+
+static void qedn_return_tcp_port(struct qedn_conn_ctx *conn_ctx)
+{
+	if (conn_ctx->sock && conn_ctx->sock->sk) {
+		qed_return_tcp_port(conn_ctx->sock);
+		conn_ctx->sock = NULL;
+	}
+
+	conn_ctx->ep.src_port = 0;
+}
+
+int qedn_wait_for_conn_est(struct qedn_conn_ctx *conn_ctx)
+{
+	int wrc, rc;
+
+	wrc = wait_event_interruptible_timeout(conn_ctx->conn_waitq,
+					       atomic_read(&conn_ctx->est_conn_indicator) > 0,
+					       msecs_to_jiffies(QEDN_WAIT_CON_ESTABLSH_TMO));
+	atomic_set(&conn_ctx->est_conn_indicator, 0);
+	if (!wrc ||
+	    conn_ctx->state != CONN_STATE_NVMETCP_CONN_ESTABLISHED) {
+		rc = -ETIMEDOUT;
+
+		/* If error was prior or during offload, conn_ctx was released.
+		 * If the error was after offload sync has completed, we need to
+		 * terminate the connection ourselves.
+		 */
+		if (conn_ctx &&
+		    conn_ctx->state >= CONN_STATE_WAIT_FOR_CONNECT_DONE &&
+		    conn_ctx->state <= CONN_STATE_NVMETCP_CONN_ESTABLISHED)
+			qedn_terminate_connection(conn_ctx,
+						  QEDN_ABORTIVE_TERMINATION);
+	} else {
+		rc = 0;
+	}
+
+	return rc;
+}
+
+int qedn_fill_ep_addr4(struct qedn_endpoint *ep,
+		       struct nvme_tcp_ofld_ctrl_con_params *conn_params)
+{
+	struct sockaddr_in *raddr = (struct sockaddr_in *)&conn_params->remote_ip_addr;
+	struct sockaddr_in *laddr = (struct sockaddr_in *)&conn_params->local_ip_addr;
+
+	ep->ip_type = TCP_IPV4;
+	ep->src_port = laddr->sin_port;
+	ep->dst_port = ntohs(raddr->sin_port);
+
+	ep->src_addr[0] = laddr->sin_addr.s_addr;
+	ep->dst_addr[0] = raddr->sin_addr.s_addr;
+
+	return 0;
+}
+
+int qedn_fill_ep_addr6(struct qedn_endpoint *ep,
+		       struct nvme_tcp_ofld_ctrl_con_params *conn_params)
+{
+	struct sockaddr_in6 *raddr6 = (struct sockaddr_in6 *)&conn_params->remote_ip_addr;
+	struct sockaddr_in6 *laddr6 = (struct sockaddr_in6 *)&conn_params->local_ip_addr;
+	int i;
+
+	ep->ip_type = TCP_IPV6;
+	ep->src_port = laddr6->sin6_port;
+	ep->dst_port = ntohs(raddr6->sin6_port);
+
+	for (i = 0; i < 4; i++) {
+		ep->src_addr[i] = laddr6->sin6_addr.in6_u.u6_addr32[i];
+		ep->dst_addr[i] = raddr6->sin6_addr.in6_u.u6_addr32[i];
+	}
+
+	return 0;
+}
+
+int qedn_initialize_endpoint(struct qedn_endpoint *ep, u8 *local_mac_addr,
+			     struct nvme_tcp_ofld_ctrl_con_params *conn_params)
+{
+	ether_addr_copy(ep->dst_mac, conn_params->remote_mac_addr.sa_data);
+	ether_addr_copy(ep->src_mac, local_mac_addr);
+	ep->vlan_id = conn_params->vlan_id;
+	if (conn_params->remote_ip_addr.ss_family == AF_INET)
+		qedn_fill_ep_addr4(ep, conn_params);
+	else
+		qedn_fill_ep_addr6(ep, conn_params);
+
+	return -1;
+}
+
+static void qedn_release_conn_ctx(struct qedn_conn_ctx *conn_ctx)
+{
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	int rc = 0;
+
+	if (test_bit(QEDN_CONN_RESRC_FW_SQ, &conn_ctx->resrc_state)) {
+		qed_ops->common->chain_free(qedn->cdev,
+					    &conn_ctx->ep.fw_sq_chain);
+		clear_bit(QEDN_CONN_RESRC_FW_SQ, &conn_ctx->resrc_state);
+	}
+
+	if (test_bit(QEDN_CONN_RESRC_ACQUIRE_CONN, &conn_ctx->resrc_state)) {
+		hash_del(&conn_ctx->hash_node);
+		rc = qed_ops->release_conn(qedn->cdev, conn_ctx->conn_handle);
+		if (rc)
+			pr_warn("Release_conn returned with an error %u\n",
+				rc);
+
+		clear_bit(QEDN_CONN_RESRC_ACQUIRE_CONN, &conn_ctx->resrc_state);
+	}
+
+	if (test_bit(QEDN_CONN_RESRC_CCCID_ITID_MAP, &conn_ctx->resrc_state)) {
+		dma_free_coherent(&qedn->pdev->dev,
+				  conn_ctx->sq_depth *
+				  sizeof(struct nvmetcp_host_cccid_itid_entry),
+				  conn_ctx->host_cccid_itid,
+				  conn_ctx->host_cccid_itid_phy_addr);
+		clear_bit(QEDN_CONN_RESRC_CCCID_ITID_MAP,
+			  &conn_ctx->resrc_state);
+	}
+
+	if (test_bit(QEDN_CONN_RESRC_TCP_PORT, &conn_ctx->resrc_state)) {
+		qedn_return_tcp_port(conn_ctx);
+		clear_bit(QEDN_CONN_RESRC_TCP_PORT,
+			  &conn_ctx->resrc_state);
+	}
+
+	if (conn_ctx->resrc_state)
+		pr_err("Conn resources state isn't 0 as expected 0x%lx\n",
+		       conn_ctx->resrc_state);
+
+	atomic_inc(&conn_ctx->destroy_conn_indicator);
+	qedn_set_con_state(conn_ctx, CONN_STATE_DESTROY_COMPLETE);
+	wake_up_interruptible(&conn_ctx->conn_waitq);
+}
+
+static int qedn_alloc_fw_sq(struct qedn_ctx *qedn,
+			    struct qedn_endpoint *ep)
+{
+	struct qed_chain_init_params params = {
+		.mode           = QED_CHAIN_MODE_PBL,
+		.intended_use   = QED_CHAIN_USE_TO_PRODUCE,
+		.cnt_type       = QED_CHAIN_CNT_TYPE_U16,
+		.num_elems      = QEDN_SQ_SIZE,
+		.elem_size      = sizeof(struct nvmetcp_wqe),
+	};
+	int rc;
+
+	rc = qed_ops->common->chain_alloc(qedn->cdev,
+					   &ep->fw_sq_chain,
+					   &params);
+	if (rc) {
+		pr_err("Failed to allocate SQ chain\n");
+
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int qedn_nvmetcp_offload_conn(struct qedn_conn_ctx *conn_ctx)
+{
+	struct qed_nvmetcp_params_offload offld_prms = { 0 };
+	struct qedn_endpoint *qedn_ep = &conn_ctx->ep;
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	u8 ts_hdr_size = 0;
+	u32 hdr_size;
+	int rc, i;
+
+	ether_addr_copy(offld_prms.src.mac, qedn_ep->src_mac);
+	ether_addr_copy(offld_prms.dst.mac, qedn_ep->dst_mac);
+	offld_prms.vlan_id = qedn_ep->vlan_id;
+	offld_prms.ecn_en = QEDN_TCP_ECN_EN;
+	offld_prms.timestamp_en =  QEDN_TCP_TS_EN;
+	offld_prms.delayed_ack_en = QEDN_TCP_DA_EN;
+	offld_prms.tcp_keep_alive_en = QEDN_TCP_KA_EN;
+	offld_prms.ip_version = qedn_ep->ip_type;
+
+	offld_prms.src.ip[0] = ntohl(qedn_ep->src_addr[0]);
+	offld_prms.dst.ip[0] = ntohl(qedn_ep->dst_addr[0]);
+	if (qedn_ep->ip_type == TCP_IPV6) {
+		for (i = 1; i < 4; i++) {
+			offld_prms.src.ip[i] = ntohl(qedn_ep->src_addr[i]);
+			offld_prms.dst.ip[i] = ntohl(qedn_ep->dst_addr[i]);
+		}
+	}
+
+	offld_prms.ttl = QEDN_TCP_TTL;
+	offld_prms.tos_or_tc = QEDN_TCP_TOS;
+	offld_prms.dst.port = qedn_ep->dst_port;
+	offld_prms.src.port = qedn_ep->src_port;
+	offld_prms.nvmetcp_cccid_itid_table_addr =
+		conn_ctx->host_cccid_itid_phy_addr;
+	offld_prms.nvmetcp_cccid_max_range = conn_ctx->sq_depth;
+
+	/* Calculate MSS */
+	if (offld_prms.timestamp_en)
+		ts_hdr_size = QEDN_TCP_TS_OPTION_LEN;
+
+	hdr_size = qedn_ep->ip_type == TCP_IPV4 ?
+		   sizeof(struct iphdr) : sizeof(struct ipv6hdr);
+	hdr_size += sizeof(struct tcphdr) + ts_hdr_size;
+
+	offld_prms.mss = qedn->mtu - hdr_size;
+	offld_prms.rcv_wnd_scale = QEDN_TCP_RCV_WND_SCALE;
+	offld_prms.cwnd = QEDN_TCP_MAX_CWND * offld_prms.mss;
+	offld_prms.ka_max_probe_cnt = QEDN_TCP_KA_MAX_PROBE_COUNT;
+	offld_prms.ka_timeout = QEDN_TCP_KA_TIMEOUT;
+	offld_prms.ka_interval = QEDN_TCP_KA_INTERVAL;
+	offld_prms.max_rt_time = QEDN_TCP_MAX_RT_TIME;
+	offld_prms.sq_pbl_addr =
+		(u64)qed_chain_get_pbl_phys(&qedn_ep->fw_sq_chain);
+
+	rc = qed_ops->offload_conn(qedn->cdev,
+				   conn_ctx->conn_handle,
+				   &offld_prms);
+	if (rc)
+		pr_err("offload_conn returned with an error\n");
+
+	return rc;
+}
+
+static int qedn_fetch_tcp_port(struct qedn_conn_ctx *conn_ctx)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl;
+	struct qedn_ctrl *qctrl;
+	int rc = 0;
+
+	ctrl = conn_ctx->ctrl;
+	qctrl = (struct qedn_ctrl *)ctrl->private_data;
+
+	rc = qed_fetch_tcp_port(ctrl->conn_params.local_ip_addr,
+				&conn_ctx->sock, &conn_ctx->ep.src_port);
+
+	return rc;
+}
+
+static void qedn_decouple_conn(struct qedn_conn_ctx *conn_ctx)
+{
+	struct nvme_tcp_ofld_queue *queue;
+
+	queue = conn_ctx->queue;
+	queue->private_data = NULL;
+}
+
+void qedn_terminate_connection(struct qedn_conn_ctx *conn_ctx, int abrt_flag)
+{
+	struct qedn_ctrl *qctrl;
+
+	if (!conn_ctx)
+		return;
+
+	qctrl = (struct qedn_ctrl *)conn_ctx->ctrl->private_data;
+
+	if (test_and_set_bit(DESTROY_CONNECTION, &conn_ctx->agg_work_action))
+		return;
+
+	qedn_set_con_state(conn_ctx, CONN_STATE_DESTROY_CONNECTION);
+	conn_ctx->abrt_flag = abrt_flag;
+
+	queue_work(qctrl->sp_wq, &conn_ctx->sp_wq_entry);
+}
+
+/* Slowpath EQ Callback */
+int qedn_event_cb(void *context, u8 fw_event_code, void *event_ring_data)
+{
+	struct nvmetcp_connect_done_results *eqe_connect_done;
+	struct nvmetcp_eqe_data *eqe_data;
+	struct nvme_tcp_ofld_ctrl *ctrl;
+	struct qedn_conn_ctx *conn_ctx;
+	struct qedn_ctrl *qctrl;
+	struct qedn_ctx *qedn;
+	u16 icid;
+	int rc;
+
+	if (!context || !event_ring_data) {
+		pr_err("Recv event with ctx NULL\n");
+
+		return -EINVAL;
+	}
+
+	qedn = (struct qedn_ctx *)context;
+
+	if (fw_event_code != NVMETCP_EVENT_TYPE_ASYN_CONNECT_COMPLETE) {
+		eqe_data = (struct nvmetcp_eqe_data *)event_ring_data;
+		icid = le16_to_cpu(eqe_data->icid);
+		pr_err("EQE Info: icid=0x%x, conn_id=0x%x, err-code=0x%x, err-pdu-opcode-reserved=0x%x\n",
+		       eqe_data->icid, eqe_data->conn_id,
+		       eqe_data->error_code,
+		       eqe_data->error_pdu_opcode_reserved);
+	} else {
+		eqe_connect_done =
+			(struct nvmetcp_connect_done_results *)event_ring_data;
+		icid = le16_to_cpu(eqe_connect_done->icid);
+	}
+
+	conn_ctx = qedn_get_conn_hash(qedn, icid);
+	if (!conn_ctx) {
+		pr_err("Connection with icid=0x%x doesn't exist in conn list\n", icid);
+
+		return -EINVAL;
+	}
+
+	ctrl = conn_ctx->ctrl;
+	qctrl = (struct qedn_ctrl *)ctrl->private_data;
+
+	switch (fw_event_code) {
+	case NVMETCP_EVENT_TYPE_ASYN_CONNECT_COMPLETE:
+		if (conn_ctx->state != CONN_STATE_WAIT_FOR_CONNECT_DONE) {
+			pr_err("CID=0x%x - ASYN_CONNECT_COMPLETE: Unexpected connection state %u\n",
+			       conn_ctx->fw_cid, conn_ctx->state);
+		} else {
+			rc = qedn_set_con_state(conn_ctx, CONN_STATE_OFFLOAD_COMPLETE);
+
+			if (rc)
+				return rc;
+
+			/* Placeholder - for ICReq flow */
+		}
+
+		break;
+	case NVMETCP_EVENT_TYPE_ASYN_TERMINATE_DONE:
+		if (conn_ctx->state != CONN_STATE_WAIT_FOR_DESTROY_DONE)
+			pr_err("CID=0x%x - ASYN_TERMINATE_DONE: Unexpected connection state %u\n",
+			       conn_ctx->fw_cid, conn_ctx->state);
+		else
+			queue_work(qctrl->sp_wq, &conn_ctx->sp_wq_entry);
+
+		break;
+	default:
+		pr_err("CID=0x%x - Recv Unknown Event %u\n", conn_ctx->fw_cid, fw_event_code);
+		break;
+	}
+
+	return 0;
+}
+
+static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx)
+{
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	size_t dma_size;
+	int rc;
+
+	rc = qedn_alloc_fw_sq(qedn, &conn_ctx->ep);
+	if (rc) {
+		pr_err("Failed to allocate FW SQ\n");
+		goto rel_conn;
+	}
+
+	set_bit(QEDN_CONN_RESRC_FW_SQ, &conn_ctx->resrc_state);
+	rc = qed_ops->acquire_conn(qedn->cdev,
+				   &conn_ctx->conn_handle,
+				   &conn_ctx->fw_cid,
+				   &conn_ctx->ep.p_doorbell);
+	if (rc) {
+		pr_err("Couldn't acquire connection\n");
+		goto rel_conn;
+	}
+
+	hash_add(qedn->conn_ctx_hash, &conn_ctx->hash_node,
+		 conn_ctx->conn_handle);
+	set_bit(QEDN_CONN_RESRC_ACQUIRE_CONN, &conn_ctx->resrc_state);
+
+	/* Placeholder - Allocate task resources and initialize fields */
+
+	rc = qedn_fetch_tcp_port(conn_ctx);
+	if (rc)
+		goto rel_conn;
+
+	set_bit(QEDN_CONN_RESRC_TCP_PORT, &conn_ctx->resrc_state);
+	dma_size = conn_ctx->sq_depth *
+			   sizeof(struct nvmetcp_host_cccid_itid_entry);
+	conn_ctx->host_cccid_itid =
+			dma_alloc_coherent(&qedn->pdev->dev,
+					   dma_size,
+					   &conn_ctx->host_cccid_itid_phy_addr,
+					   GFP_ATOMIC);
+	if (!conn_ctx->host_cccid_itid) {
+		pr_err("CCCID-iTID Map allocation failed\n");
+		goto rel_conn;
+	}
+
+	memset(conn_ctx->host_cccid_itid, 0xFF, dma_size);
+	set_bit(QEDN_CONN_RESRC_CCCID_ITID_MAP, &conn_ctx->resrc_state);
+	rc = qedn_set_con_state(conn_ctx, CONN_STATE_WAIT_FOR_CONNECT_DONE);
+	if (rc)
+		goto rel_conn;
+
+	rc = qedn_nvmetcp_offload_conn(conn_ctx);
+	if (rc) {
+		pr_err("Offload error: CID=0x%x\n", conn_ctx->fw_cid);
+		goto rel_conn;
+	}
+
+	return 0;
+
+rel_conn:
+	pr_err("qedn create queue ended with ERROR\n");
+	qedn_release_conn_ctx(conn_ctx);
+
+	return -EINVAL;
+}
+
+void qedn_destroy_connection(struct qedn_conn_ctx *conn_ctx)
+{
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	int rc;
+
+	qedn_decouple_conn(conn_ctx);
+
+	if (qedn_set_con_state(conn_ctx, CONN_STATE_WAIT_FOR_DESTROY_DONE))
+		return;
+
+	/* Placeholder - task cleanup */
+
+	rc = qed_ops->destroy_conn(qedn->cdev, conn_ctx->conn_handle,
+				   conn_ctx->abrt_flag);
+	if (rc)
+		pr_warn("destroy_conn failed - rc %u\n", rc);
+}
+
+void qedn_sp_wq_handler(struct work_struct *work)
+{
+	struct qedn_conn_ctx *conn_ctx;
+	struct qedn_ctx *qedn;
+	int rc;
+
+	conn_ctx = container_of(work, struct qedn_conn_ctx, sp_wq_entry);
+	qedn = conn_ctx->qedn;
+
+	if (conn_ctx->state == CONN_STATE_DESTROY_COMPLETE) {
+		pr_err("Connection already released!\n");
+
+		return;
+	}
+
+	if (conn_ctx->state == CONN_STATE_WAIT_FOR_DESTROY_DONE) {
+		qedn_release_conn_ctx(conn_ctx);
+
+		return;
+	}
+
+	qedn = conn_ctx->qedn;
+	if (test_bit(DESTROY_CONNECTION, &conn_ctx->agg_work_action)) {
+		qedn_destroy_connection(conn_ctx);
+
+		return;
+	}
+
+	if (test_bit(CREATE_CONNECTION, &conn_ctx->agg_work_action)) {
+		qedn_clr_sp_wa(conn_ctx, CREATE_CONNECTION);
+		rc = qedn_prep_and_offload_queue(conn_ctx);
+		if (rc) {
+			pr_err("Error in queue prepare & firmware offload\n");
+
+			return;
+		}
+	}
+}
+
+/* Clear connection aggregative slowpath work action */
+void qedn_clr_sp_wa(struct qedn_conn_ctx *conn_ctx, u32 bit)
+{
+	clear_bit(bit, &conn_ctx->agg_work_action);
+}
+
+/* Set connection aggregative slowpath work action */
+void qedn_set_sp_wa(struct qedn_conn_ctx *conn_ctx, u32 bit)
+{
+	set_bit(bit, &conn_ctx->agg_work_action);
+}
diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qedn_main.c
index 0135a1f490da..70beb84b9793 100644
--- a/drivers/nvme/hw/qedn/qedn_main.c
+++ b/drivers/nvme/hw/qedn/qedn_main.c
@@ -23,6 +23,38 @@ static struct pci_device_id qedn_pci_tbl[] = {
 	{0, 0},
 };
 
+static bool qedn_matches_qede(struct qedn_ctx *qedn, struct pci_dev *qede_pdev)
+{
+	struct pci_dev *qedn_pdev = qedn->pdev;
+
+	return (qede_pdev->bus->number == qedn_pdev->bus->number &&
+		PCI_SLOT(qede_pdev->devfn) == PCI_SLOT(qedn_pdev->devfn) &&
+		PCI_FUNC(qede_pdev->devfn) == qedn->dev_info.port_id);
+}
+
+static struct qedn_ctx *qedn_get_pf_from_pdev(struct pci_dev *qede_pdev)
+{
+	struct list_head *pf_list = NULL;
+	struct qedn_ctx *qedn = NULL;
+	int rc;
+
+	pf_list = &qedn_glb.qedn_pf_list;
+	if (!pf_list) {
+		pr_err("Failed fetching pf list for nvmet_add_port\n");
+		rc = -EFAULT;
+		goto pf_list_err;
+	}
+
+	list_for_each_entry(qedn, pf_list, gl_pf_entry) {
+		if (qedn_matches_qede(qedn, qede_pdev))
+			return qedn;
+	}
+
+pf_list_err:
+
+	return NULL;
+}
+
 static int
 qedn_claim_dev(struct nvme_tcp_ofld_dev *dev,
 	       struct nvme_tcp_ofld_ctrl_con_params *conn_params)
@@ -70,22 +102,167 @@ qedn_claim_dev(struct nvme_tcp_ofld_dev *dev,
 	return true;
 }
 
-static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qid,
-			     size_t q_size)
+static int qedn_setup_ctrl(struct nvme_tcp_ofld_ctrl *ctrl, bool new)
 {
-	/* Placeholder - qedn_create_queue */
+	struct nvme_tcp_ofld_dev *dev = ctrl->dev;
+	struct qedn_ctrl *qctrl = NULL;
+	struct qedn_ctx *qedn = NULL;
+	int rc = 0;
+
+	if (new) {
+		qctrl = kzalloc(sizeof(*qctrl), GFP_KERNEL);
+		if (!qctrl)
+			return -ENOMEM;
+
+		ctrl->private_data = (void *)qctrl;
+		set_bit(QEDN_CTRL_SET_TO_OFLD_CTRL, &qctrl->agg_state);
+
+		qctrl->sp_wq = alloc_workqueue(QEDN_SP_WORKQUEUE, WQ_MEM_RECLAIM,
+					       QEDN_SP_WORKQUEUE_MAX_ACTIVE);
+		if (!qctrl->sp_wq) {
+			rc = -ENODEV;
+			pr_err("Unable to create slowpath work queue!\n");
+			kfree(qctrl);
+
+			return rc;
+		}
+
+		set_bit(QEDN_STATE_SP_WORK_THREAD_SET, &qctrl->agg_state);
+	}
+
+	qedn = qedn_get_pf_from_pdev(dev->qede_pdev);
+	if (!qedn) {
+		pr_err("Failed locating QEDN for ip=%pIS\n",
+		       &ctrl->conn_params.local_ip_addr);
+		rc = -EFAULT;
+		goto err_out;
+	}
+
+	qctrl->qedn = qedn;
+
+	/* Placeholder - setup LLH filter */
+
+	return 0;
+
+err_out:
+	flush_workqueue(qctrl->sp_wq);
+	kfree(qctrl);
+
+	return rc;
+}
+
+static int qedn_release_ctrl(struct nvme_tcp_ofld_ctrl *ctrl)
+{
+	struct qedn_ctrl *qctrl = (struct qedn_ctrl *)ctrl->private_data;
+
+	if (test_and_clear_bit(QEDN_STATE_SP_WORK_THREAD_SET, &qctrl->agg_state))
+		flush_workqueue(qctrl->sp_wq);
+
+	if (test_and_clear_bit(QEDN_CTRL_SET_TO_OFLD_CTRL, &qctrl->agg_state)) {
+		kfree(qctrl);
+		ctrl->private_data = NULL;
+	}
+
+	qctrl->agg_state = 0;
+	kfree(ctrl);
+
+	return 0;
+}
+
+static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qid, size_t q_size)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = queue->ctrl;
+	struct qedn_conn_ctx *conn_ctx;
+	struct qedn_ctrl *qctrl;
+	struct qedn_ctx *qedn;
+	int rc;
+
+	qctrl = (struct qedn_ctrl *)ctrl->private_data;
+	qedn = qctrl->qedn;
+
+	/* Allocate qedn connection context */
+	conn_ctx = kzalloc(sizeof(*conn_ctx), GFP_KERNEL);
+	if (!conn_ctx)
+		return -ENOMEM;
+
+	queue->private_data = conn_ctx;
+	conn_ctx->qedn = qedn;
+	conn_ctx->queue = queue;
+	conn_ctx->ctrl = ctrl;
+	conn_ctx->sq_depth = q_size;
+
+	init_waitqueue_head(&conn_ctx->conn_waitq);
+	atomic_set(&conn_ctx->est_conn_indicator, 0);
+	atomic_set(&conn_ctx->destroy_conn_indicator, 0);
+
+	spin_lock_init(&conn_ctx->conn_state_lock);
+
+	qedn_initialize_endpoint(&conn_ctx->ep, qedn->local_mac_addr,
+				 &ctrl->conn_params);
+
+	atomic_inc(&qctrl->host_num_active_conns);
+
+	qedn_set_sp_wa(conn_ctx, CREATE_CONNECTION);
+	qedn_set_con_state(conn_ctx, CONN_STATE_CREATE_CONNECTION);
+	INIT_WORK(&conn_ctx->sp_wq_entry, qedn_sp_wq_handler);
+	queue_work(qctrl->sp_wq, &conn_ctx->sp_wq_entry);
+
+	/* Wait for the connection establishment to complete - this includes the
+	 * FW TCP connection establishment and the NVMeTCP ICReq & ICResp
+	 */
+	rc = qedn_wait_for_conn_est(conn_ctx);
+	if (rc)
+		return -ENXIO;
 
 	return 0;
 }
 
 static void qedn_drain_queue(struct nvme_tcp_ofld_queue *queue)
 {
-	/* Placeholder - qedn_drain_queue */
+	/* No queue drain is required */
+}
+
+#define ATOMIC_READ_DESTROY_IND atomic_read(&conn_ctx->destroy_conn_indicator)
+#define TERMINATE_TIMEOUT msecs_to_jiffies(QEDN_RLS_CONS_TMO)
+static inline void
+qedn_queue_wait_for_terminate_complete(struct qedn_conn_ctx *conn_ctx)
+{
+	/* Returns valid non-0 */
+	int wrc, state;
+
+	wrc = wait_event_interruptible_timeout(conn_ctx->conn_waitq,
+					       ATOMIC_READ_DESTROY_IND > 0,
+					       TERMINATE_TIMEOUT);
+
+	atomic_set(&conn_ctx->destroy_conn_indicator, 0);
+
+	spin_lock_bh(&conn_ctx->conn_state_lock);
+	state = conn_ctx->state;
+	spin_unlock_bh(&conn_ctx->conn_state_lock);
+
+	if (!wrc  || state != CONN_STATE_DESTROY_COMPLETE)
+		pr_warn("Timed out waiting for clear-SQ on FW conns");
 }
 
 static void qedn_destroy_queue(struct nvme_tcp_ofld_queue *queue)
 {
-	/* Placeholder - qedn_destroy_queue */
+	struct qedn_conn_ctx *conn_ctx;
+
+	if (!queue) {
+		pr_err("ctrl has no queues\n");
+
+		return;
+	}
+
+	conn_ctx = (struct qedn_conn_ctx *)queue->private_data;
+	if (!conn_ctx)
+		return;
+
+	qedn_terminate_connection(conn_ctx, QEDN_ABORTIVE_TERMINATION);
+
+	qedn_queue_wait_for_terminate_complete(conn_ctx);
+
+	kfree(conn_ctx);
 }
 
 static int qedn_poll_queue(struct nvme_tcp_ofld_queue *queue)
@@ -132,6 +309,8 @@ static struct nvme_tcp_ofld_ops qedn_ofld_ops = {
 		 *	NVMF_OPT_NR_POLL_QUEUES | NVMF_OPT_TOS
 		 */
 	.claim_dev = qedn_claim_dev,
+	.setup_ctrl = qedn_setup_ctrl,
+	.release_ctrl = qedn_release_ctrl,
 	.create_queue = qedn_create_queue,
 	.drain_queue = qedn_drain_queue,
 	.destroy_queue = qedn_destroy_queue,
@@ -141,6 +320,21 @@ static struct nvme_tcp_ofld_ops qedn_ofld_ops = {
 	.commit_rqs = qedn_commit_rqs,
 };
 
+struct qedn_conn_ctx *qedn_get_conn_hash(struct qedn_ctx *qedn, u16 icid)
+{
+	struct qedn_conn_ctx *conn = NULL;
+
+	hash_for_each_possible(qedn->conn_ctx_hash, conn, hash_node, icid) {
+		if (conn->conn_handle == icid)
+			break;
+	}
+
+	if (!conn || conn->conn_handle != icid)
+		return NULL;
+
+	return conn;
+}
+
 /* Fastpath IRQ handler */
 static irqreturn_t qedn_irq_handler(int irq, void *dev_id)
 {
@@ -241,7 +435,7 @@ static int qedn_setup_irq(struct qedn_ctx *qedn)
 
 static inline void qedn_init_pf_struct(struct qedn_ctx *qedn)
 {
-	/* Placeholder - Initialize qedn fields */
+	hash_init(qedn->conn_ctx_hash);
 }
 
 static inline void
@@ -607,7 +801,7 @@ static int __qedn_probe(struct pci_dev *pdev)
 	rc = qed_ops->start(qedn->cdev,
 			    NULL /* Placeholder for FW IO-path resources */,
 			    qedn,
-			    NULL /* Placeholder for FW Event callback */);
+			    qedn_event_cb);
 	if (rc) {
 		rc = -ENODEV;
 		pr_err("Cannot start NVMeTCP Function\n");
-- 
2.22.0

