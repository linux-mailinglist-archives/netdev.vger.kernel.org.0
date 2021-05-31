Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B0E3969D7
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 00:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhEaW4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 18:56:22 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30476 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232320AbhEaW4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 18:56:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VMnt6u021107;
        Mon, 31 May 2021 15:54:28 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38vjqj36tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 15:54:28 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 15:54:26 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 31 May 2021 15:54:23 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <smalin@marvell.com>
Subject: [RFC PATCH v7 11/27] qed: Add NVMeTCP Offload Connection Level FW and HW HSI
Date:   Tue, 1 Jun 2021 01:52:06 +0300
Message-ID: <20210531225222.16992-12-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210531225222.16992-1-smalin@marvell.com>
References: <20210531225222.16992-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: q8-54coe0yHNtWFPP-rX4yZzayQxquEQ
X-Proofpoint-ORIG-GUID: q8-54coe0yHNtWFPP-rX4yZzayQxquEQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_15:2021-05-31,2021-05-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the NVMeTCP HSI and HSI functionality in order to
initialize and interact with the HW device as part of the connection level
HSI.

This includes:
- Connection offload: offload a TCP connection to the FW.
- Connection update: update the ICReq-ICResp params
- Connection clear SQ: outstanding IOs FW flush.
- Connection termination: terminate the TCP connection and flush the FW.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c | 582 +++++++++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h |  63 ++
 drivers/net/ethernet/qlogic/qed/qed_sp.h      |   3 +
 include/linux/qed/nvmetcp_common.h            | 143 +++++
 include/linux/qed/qed_nvmetcp_if.h            |  94 +++
 5 files changed, 883 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
index 001d6247d22c..c485026321be 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
@@ -259,6 +259,580 @@ static int qed_nvmetcp_start(struct qed_dev *cdev,
 	return 0;
 }
 
+static struct qed_hash_nvmetcp_con *qed_nvmetcp_get_hash(struct qed_dev *cdev,
+							 u32 handle)
+{
+	struct qed_hash_nvmetcp_con *hash_con = NULL;
+
+	if (!(cdev->flags & QED_FLAG_STORAGE_STARTED))
+		return NULL;
+
+	hash_for_each_possible(cdev->connections, hash_con, node, handle) {
+		if (hash_con->con->icid == handle)
+			break;
+	}
+
+	if (!hash_con || hash_con->con->icid != handle)
+		return NULL;
+
+	return hash_con;
+}
+
+static int qed_sp_nvmetcp_conn_offload(struct qed_hwfn *p_hwfn,
+				       struct qed_nvmetcp_conn *p_conn,
+				       enum spq_mode comp_mode,
+				       struct qed_spq_comp_cb *p_comp_addr)
+{
+	struct nvmetcp_spe_conn_offload *p_ramrod = NULL;
+	struct tcp_offload_params_opt2 *p_tcp = NULL;
+	struct qed_sp_init_data init_data = { 0 };
+	struct qed_spq_entry *p_ent = NULL;
+	dma_addr_t r2tq_pbl_addr;
+	dma_addr_t xhq_pbl_addr;
+	dma_addr_t uhq_pbl_addr;
+	u16 physical_q;
+	int rc = 0;
+	u8 i;
+
+	/* Get SPQ entry */
+	init_data.cid = p_conn->icid;
+	init_data.opaque_fid = p_hwfn->hw_info.opaque_fid;
+	init_data.comp_mode = comp_mode;
+	init_data.p_comp_data = p_comp_addr;
+
+	rc = qed_sp_init_request(p_hwfn, &p_ent,
+				 NVMETCP_RAMROD_CMD_ID_OFFLOAD_CONN,
+				 PROTOCOLID_TCP_ULP, &init_data);
+	if (rc)
+		return rc;
+
+	p_ramrod = &p_ent->ramrod.nvmetcp_conn_offload;
+
+	/* Transmission PQ is the first of the PF */
+	physical_q = qed_get_cm_pq_idx(p_hwfn, PQ_FLAGS_OFLD);
+	p_conn->physical_q0 = cpu_to_le16(physical_q);
+	p_ramrod->nvmetcp.physical_q0 = cpu_to_le16(physical_q);
+
+	/* nvmetcp Pure-ACK PQ */
+	physical_q = qed_get_cm_pq_idx(p_hwfn, PQ_FLAGS_ACK);
+	p_conn->physical_q1 = cpu_to_le16(physical_q);
+	p_ramrod->nvmetcp.physical_q1 = cpu_to_le16(physical_q);
+
+	p_ramrod->conn_id = cpu_to_le16(p_conn->conn_id);
+
+	DMA_REGPAIR_LE(p_ramrod->nvmetcp.sq_pbl_addr, p_conn->sq_pbl_addr);
+
+	r2tq_pbl_addr = qed_chain_get_pbl_phys(&p_conn->r2tq);
+	DMA_REGPAIR_LE(p_ramrod->nvmetcp.r2tq_pbl_addr, r2tq_pbl_addr);
+
+	xhq_pbl_addr = qed_chain_get_pbl_phys(&p_conn->xhq);
+	DMA_REGPAIR_LE(p_ramrod->nvmetcp.xhq_pbl_addr, xhq_pbl_addr);
+
+	uhq_pbl_addr = qed_chain_get_pbl_phys(&p_conn->uhq);
+	DMA_REGPAIR_LE(p_ramrod->nvmetcp.uhq_pbl_addr, uhq_pbl_addr);
+
+	p_ramrod->nvmetcp.flags = p_conn->offl_flags;
+	p_ramrod->nvmetcp.default_cq = p_conn->default_cq;
+	p_ramrod->nvmetcp.initial_ack = 0;
+
+	DMA_REGPAIR_LE(p_ramrod->nvmetcp.nvmetcp.cccid_itid_table_addr,
+		       p_conn->nvmetcp_cccid_itid_table_addr);
+	p_ramrod->nvmetcp.nvmetcp.cccid_max_range =
+		 cpu_to_le16(p_conn->nvmetcp_cccid_max_range);
+
+	p_tcp = &p_ramrod->tcp;
+
+	qed_set_fw_mac_addr(&p_tcp->remote_mac_addr_hi,
+			    &p_tcp->remote_mac_addr_mid,
+			    &p_tcp->remote_mac_addr_lo, p_conn->remote_mac);
+	qed_set_fw_mac_addr(&p_tcp->local_mac_addr_hi,
+			    &p_tcp->local_mac_addr_mid,
+			    &p_tcp->local_mac_addr_lo, p_conn->local_mac);
+
+	p_tcp->vlan_id = cpu_to_le16(p_conn->vlan_id);
+	p_tcp->flags = cpu_to_le16(p_conn->tcp_flags);
+
+	p_tcp->ip_version = p_conn->ip_version;
+	if (p_tcp->ip_version == TCP_IPV6) {
+		for (i = 0; i < 4; i++) {
+			p_tcp->remote_ip[i] = cpu_to_le32(p_conn->remote_ip[i]);
+			p_tcp->local_ip[i] = cpu_to_le32(p_conn->local_ip[i]);
+		}
+	} else {
+		p_tcp->remote_ip[0] = cpu_to_le32(p_conn->remote_ip[0]);
+		p_tcp->local_ip[0] = cpu_to_le32(p_conn->local_ip[0]);
+	}
+
+	p_tcp->flow_label = cpu_to_le32(p_conn->flow_label);
+	p_tcp->ttl = p_conn->ttl;
+	p_tcp->tos_or_tc = p_conn->tos_or_tc;
+	p_tcp->remote_port = cpu_to_le16(p_conn->remote_port);
+	p_tcp->local_port = cpu_to_le16(p_conn->local_port);
+	p_tcp->mss = cpu_to_le16(p_conn->mss);
+	p_tcp->rcv_wnd_scale = p_conn->rcv_wnd_scale;
+	p_tcp->connect_mode = p_conn->connect_mode;
+	p_tcp->cwnd = cpu_to_le32(p_conn->cwnd);
+	p_tcp->ka_max_probe_cnt = p_conn->ka_max_probe_cnt;
+	p_tcp->ka_timeout = cpu_to_le32(p_conn->ka_timeout);
+	p_tcp->max_rt_time = cpu_to_le32(p_conn->max_rt_time);
+	p_tcp->ka_interval = cpu_to_le32(p_conn->ka_interval);
+
+	return qed_spq_post(p_hwfn, p_ent, NULL);
+}
+
+static int qed_sp_nvmetcp_conn_update(struct qed_hwfn *p_hwfn,
+				      struct qed_nvmetcp_conn *p_conn,
+				      enum spq_mode comp_mode,
+				      struct qed_spq_comp_cb *p_comp_addr)
+{
+	struct nvmetcp_conn_update_ramrod_params *p_ramrod = NULL;
+	struct qed_spq_entry *p_ent = NULL;
+	struct qed_sp_init_data init_data;
+	int rc = -EINVAL;
+	u32 dval;
+
+	/* Get SPQ entry */
+	memset(&init_data, 0, sizeof(init_data));
+	init_data.cid = p_conn->icid;
+	init_data.opaque_fid = p_hwfn->hw_info.opaque_fid;
+	init_data.comp_mode = comp_mode;
+	init_data.p_comp_data = p_comp_addr;
+
+	rc = qed_sp_init_request(p_hwfn, &p_ent,
+				 NVMETCP_RAMROD_CMD_ID_UPDATE_CONN,
+				 PROTOCOLID_TCP_ULP, &init_data);
+	if (rc)
+		return rc;
+
+	p_ramrod = &p_ent->ramrod.nvmetcp_conn_update;
+	p_ramrod->conn_id = cpu_to_le16(p_conn->conn_id);
+	p_ramrod->flags = p_conn->update_flag;
+	p_ramrod->max_seq_size = cpu_to_le32(p_conn->max_seq_size);
+	dval = p_conn->max_recv_pdu_length;
+	p_ramrod->max_recv_pdu_length = cpu_to_le32(dval);
+	dval = p_conn->max_send_pdu_length;
+	p_ramrod->max_send_pdu_length = cpu_to_le32(dval);
+	dval = p_conn->first_seq_length;
+	p_ramrod->first_seq_length = cpu_to_le32(dval);
+
+	return qed_spq_post(p_hwfn, p_ent, NULL);
+}
+
+static int qed_sp_nvmetcp_conn_terminate(struct qed_hwfn *p_hwfn,
+					 struct qed_nvmetcp_conn *p_conn,
+					 enum spq_mode comp_mode,
+					 struct qed_spq_comp_cb *p_comp_addr)
+{
+	struct nvmetcp_spe_conn_termination *p_ramrod = NULL;
+	struct qed_spq_entry *p_ent = NULL;
+	struct qed_sp_init_data init_data;
+	int rc = -EINVAL;
+
+	/* Get SPQ entry */
+	memset(&init_data, 0, sizeof(init_data));
+	init_data.cid = p_conn->icid;
+	init_data.opaque_fid = p_hwfn->hw_info.opaque_fid;
+	init_data.comp_mode = comp_mode;
+	init_data.p_comp_data = p_comp_addr;
+
+	rc = qed_sp_init_request(p_hwfn, &p_ent,
+				 NVMETCP_RAMROD_CMD_ID_TERMINATION_CONN,
+				 PROTOCOLID_TCP_ULP, &init_data);
+	if (rc)
+		return rc;
+
+	p_ramrod = &p_ent->ramrod.nvmetcp_conn_terminate;
+	p_ramrod->conn_id = cpu_to_le16(p_conn->conn_id);
+	p_ramrod->abortive = p_conn->abortive_dsconnect;
+
+	return qed_spq_post(p_hwfn, p_ent, NULL);
+}
+
+static int qed_sp_nvmetcp_conn_clear_sq(struct qed_hwfn *p_hwfn,
+					struct qed_nvmetcp_conn *p_conn,
+					enum spq_mode comp_mode,
+					struct qed_spq_comp_cb *p_comp_addr)
+{
+	struct qed_spq_entry *p_ent = NULL;
+	struct qed_sp_init_data init_data;
+	int rc = -EINVAL;
+
+	/* Get SPQ entry */
+	memset(&init_data, 0, sizeof(init_data));
+	init_data.cid = p_conn->icid;
+	init_data.opaque_fid = p_hwfn->hw_info.opaque_fid;
+	init_data.comp_mode = comp_mode;
+	init_data.p_comp_data = p_comp_addr;
+
+	rc = qed_sp_init_request(p_hwfn, &p_ent,
+				 NVMETCP_RAMROD_CMD_ID_CLEAR_SQ,
+				 PROTOCOLID_TCP_ULP, &init_data);
+	if (rc)
+		return rc;
+
+	return qed_spq_post(p_hwfn, p_ent, NULL);
+}
+
+static void __iomem *qed_nvmetcp_get_db_addr(struct qed_hwfn *p_hwfn, u32 cid)
+{
+	return (u8 __iomem *)p_hwfn->doorbells +
+			     qed_db_addr(cid, DQ_DEMS_LEGACY);
+}
+
+static int qed_nvmetcp_allocate_connection(struct qed_hwfn *p_hwfn,
+					   struct qed_nvmetcp_conn **p_out_conn)
+{
+	struct qed_chain_init_params params = {
+		.mode		= QED_CHAIN_MODE_PBL,
+		.intended_use	= QED_CHAIN_USE_TO_CONSUME_PRODUCE,
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U16,
+	};
+	struct qed_nvmetcp_pf_params *p_params = NULL;
+	struct qed_nvmetcp_conn *p_conn = NULL;
+	int rc = 0;
+
+	/* Try finding a free connection that can be used */
+	spin_lock_bh(&p_hwfn->p_nvmetcp_info->lock);
+	if (!list_empty(&p_hwfn->p_nvmetcp_info->free_list))
+		p_conn = list_first_entry(&p_hwfn->p_nvmetcp_info->free_list,
+					  struct qed_nvmetcp_conn, list_entry);
+	if (p_conn) {
+		list_del(&p_conn->list_entry);
+		spin_unlock_bh(&p_hwfn->p_nvmetcp_info->lock);
+		*p_out_conn = p_conn;
+
+		return 0;
+	}
+	spin_unlock_bh(&p_hwfn->p_nvmetcp_info->lock);
+
+	/* Need to allocate a new connection */
+	p_params = &p_hwfn->pf_params.nvmetcp_pf_params;
+
+	p_conn = kzalloc(sizeof(*p_conn), GFP_KERNEL);
+	if (!p_conn)
+		return -ENOMEM;
+
+	params.num_elems = p_params->num_r2tq_pages_in_ring *
+			   QED_CHAIN_PAGE_SIZE / sizeof(struct nvmetcp_wqe);
+	params.elem_size = sizeof(struct nvmetcp_wqe);
+
+	rc = qed_chain_alloc(p_hwfn->cdev, &p_conn->r2tq, &params);
+	if (rc)
+		goto nomem_r2tq;
+
+	params.num_elems = p_params->num_uhq_pages_in_ring *
+			   QED_CHAIN_PAGE_SIZE / sizeof(struct iscsi_uhqe);
+	params.elem_size = sizeof(struct iscsi_uhqe);
+
+	rc = qed_chain_alloc(p_hwfn->cdev, &p_conn->uhq, &params);
+	if (rc)
+		goto nomem_uhq;
+
+	params.elem_size = sizeof(struct iscsi_xhqe);
+
+	rc = qed_chain_alloc(p_hwfn->cdev, &p_conn->xhq, &params);
+	if (rc)
+		goto nomem;
+
+	p_conn->free_on_delete = true;
+	*p_out_conn = p_conn;
+
+	return 0;
+
+nomem:
+	qed_chain_free(p_hwfn->cdev, &p_conn->uhq);
+nomem_uhq:
+	qed_chain_free(p_hwfn->cdev, &p_conn->r2tq);
+nomem_r2tq:
+	kfree(p_conn);
+
+	return -ENOMEM;
+}
+
+static int qed_nvmetcp_acquire_connection(struct qed_hwfn *p_hwfn,
+					  struct qed_nvmetcp_conn **p_out_conn)
+{
+	struct qed_nvmetcp_conn *p_conn = NULL;
+	int rc = 0;
+	u32 icid;
+
+	spin_lock_bh(&p_hwfn->p_nvmetcp_info->lock);
+	rc = qed_cxt_acquire_cid(p_hwfn, PROTOCOLID_TCP_ULP, &icid);
+	spin_unlock_bh(&p_hwfn->p_nvmetcp_info->lock);
+
+	if (rc)
+		return rc;
+
+	rc = qed_nvmetcp_allocate_connection(p_hwfn, &p_conn);
+	if (rc) {
+		spin_lock_bh(&p_hwfn->p_nvmetcp_info->lock);
+		qed_cxt_release_cid(p_hwfn, icid);
+		spin_unlock_bh(&p_hwfn->p_nvmetcp_info->lock);
+
+		return rc;
+	}
+
+	p_conn->icid = icid;
+	p_conn->conn_id = (u16)icid;
+	p_conn->fw_cid = (p_hwfn->hw_info.opaque_fid << 16) | icid;
+	*p_out_conn = p_conn;
+
+	return rc;
+}
+
+static void qed_nvmetcp_release_connection(struct qed_hwfn *p_hwfn,
+					   struct qed_nvmetcp_conn *p_conn)
+{
+	spin_lock_bh(&p_hwfn->p_nvmetcp_info->lock);
+	list_add_tail(&p_conn->list_entry, &p_hwfn->p_nvmetcp_info->free_list);
+	qed_cxt_release_cid(p_hwfn, p_conn->icid);
+	spin_unlock_bh(&p_hwfn->p_nvmetcp_info->lock);
+}
+
+static void qed_nvmetcp_free_connection(struct qed_hwfn *p_hwfn,
+					struct qed_nvmetcp_conn *p_conn)
+{
+	qed_chain_free(p_hwfn->cdev, &p_conn->xhq);
+	qed_chain_free(p_hwfn->cdev, &p_conn->uhq);
+	qed_chain_free(p_hwfn->cdev, &p_conn->r2tq);
+
+	kfree(p_conn);
+}
+
+int qed_nvmetcp_alloc(struct qed_hwfn *p_hwfn)
+{
+	struct qed_nvmetcp_info *p_nvmetcp_info;
+
+	p_nvmetcp_info = kzalloc(sizeof(*p_nvmetcp_info), GFP_KERNEL);
+	if (!p_nvmetcp_info)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&p_nvmetcp_info->free_list);
+
+	p_hwfn->p_nvmetcp_info = p_nvmetcp_info;
+
+	return 0;
+}
+
+void qed_nvmetcp_setup(struct qed_hwfn *p_hwfn)
+{
+	spin_lock_init(&p_hwfn->p_nvmetcp_info->lock);
+}
+
+void qed_nvmetcp_free(struct qed_hwfn *p_hwfn)
+{
+	struct qed_nvmetcp_conn *p_conn = NULL;
+
+	if (!p_hwfn->p_nvmetcp_info)
+		return;
+
+	while (!list_empty(&p_hwfn->p_nvmetcp_info->free_list)) {
+		p_conn = list_first_entry(&p_hwfn->p_nvmetcp_info->free_list,
+					  struct qed_nvmetcp_conn, list_entry);
+		if (p_conn) {
+			list_del(&p_conn->list_entry);
+			qed_nvmetcp_free_connection(p_hwfn, p_conn);
+		}
+	}
+
+	kfree(p_hwfn->p_nvmetcp_info);
+	p_hwfn->p_nvmetcp_info = NULL;
+}
+
+static int qed_nvmetcp_acquire_conn(struct qed_dev *cdev,
+				    u32 *handle,
+				    u32 *fw_cid, void __iomem **p_doorbell)
+{
+	struct qed_hash_nvmetcp_con *hash_con;
+	int rc;
+
+	/* Allocate a hashed connection */
+	hash_con = kzalloc(sizeof(*hash_con), GFP_ATOMIC);
+	if (!hash_con)
+		return -ENOMEM;
+
+	/* Acquire the connection */
+	rc = qed_nvmetcp_acquire_connection(QED_AFFIN_HWFN(cdev),
+					    &hash_con->con);
+	if (rc) {
+		DP_NOTICE(cdev, "Failed to acquire Connection\n");
+		kfree(hash_con);
+
+		return rc;
+	}
+
+	/* Added the connection to hash table */
+	*handle = hash_con->con->icid;
+	*fw_cid = hash_con->con->fw_cid;
+	hash_add(cdev->connections, &hash_con->node, *handle);
+
+	if (p_doorbell)
+		*p_doorbell = qed_nvmetcp_get_db_addr(QED_AFFIN_HWFN(cdev),
+						      *handle);
+
+	return 0;
+}
+
+static int qed_nvmetcp_release_conn(struct qed_dev *cdev, u32 handle)
+{
+	struct qed_hash_nvmetcp_con *hash_con;
+
+	hash_con = qed_nvmetcp_get_hash(cdev, handle);
+	if (!hash_con) {
+		DP_NOTICE(cdev, "Failed to find connection for handle %d\n",
+			  handle);
+
+		return -EINVAL;
+	}
+
+	hlist_del(&hash_con->node);
+	qed_nvmetcp_release_connection(QED_AFFIN_HWFN(cdev), hash_con->con);
+	kfree(hash_con);
+
+	return 0;
+}
+
+static int qed_nvmetcp_offload_conn(struct qed_dev *cdev, u32 handle,
+				    struct qed_nvmetcp_params_offload *conn_info)
+{
+	struct qed_hash_nvmetcp_con *hash_con;
+	struct qed_nvmetcp_conn *con;
+
+	hash_con = qed_nvmetcp_get_hash(cdev, handle);
+	if (!hash_con) {
+		DP_NOTICE(cdev, "Failed to find connection for handle %d\n",
+			  handle);
+
+		return -EINVAL;
+	}
+
+	/* Update the connection with information from the params */
+	con = hash_con->con;
+
+	/* FW initializations */
+	con->layer_code = NVMETCP_SLOW_PATH_LAYER_CODE;
+	con->sq_pbl_addr = conn_info->sq_pbl_addr;
+	con->nvmetcp_cccid_max_range = conn_info->nvmetcp_cccid_max_range;
+	con->nvmetcp_cccid_itid_table_addr = conn_info->nvmetcp_cccid_itid_table_addr;
+	con->default_cq = conn_info->default_cq;
+
+	SET_FIELD(con->offl_flags, NVMETCP_CONN_OFFLOAD_PARAMS_TARGET_MODE, 0);
+	SET_FIELD(con->offl_flags, NVMETCP_CONN_OFFLOAD_PARAMS_NVMETCP_MODE, 1);
+	SET_FIELD(con->offl_flags, NVMETCP_CONN_OFFLOAD_PARAMS_TCP_ON_CHIP_1B, 1);
+
+	/* Networking and TCP stack initializations */
+	ether_addr_copy(con->local_mac, conn_info->src.mac);
+	ether_addr_copy(con->remote_mac, conn_info->dst.mac);
+	memcpy(con->local_ip, conn_info->src.ip, sizeof(con->local_ip));
+	memcpy(con->remote_ip, conn_info->dst.ip, sizeof(con->remote_ip));
+	con->local_port = conn_info->src.port;
+	con->remote_port = conn_info->dst.port;
+	con->vlan_id = conn_info->vlan_id;
+
+	if (conn_info->timestamp_en)
+		SET_FIELD(con->tcp_flags, TCP_OFFLOAD_PARAMS_OPT2_TS_EN, 1);
+
+	if (conn_info->delayed_ack_en)
+		SET_FIELD(con->tcp_flags, TCP_OFFLOAD_PARAMS_OPT2_DA_EN, 1);
+
+	if (conn_info->tcp_keep_alive_en)
+		SET_FIELD(con->tcp_flags, TCP_OFFLOAD_PARAMS_OPT2_KA_EN, 1);
+
+	if (conn_info->ecn_en)
+		SET_FIELD(con->tcp_flags, TCP_OFFLOAD_PARAMS_OPT2_ECN_EN, 1);
+
+	con->ip_version = conn_info->ip_version;
+	con->flow_label = QED_TCP_FLOW_LABEL;
+	con->ka_max_probe_cnt = conn_info->ka_max_probe_cnt;
+	con->ka_timeout = conn_info->ka_timeout;
+	con->ka_interval = conn_info->ka_interval;
+	con->max_rt_time = conn_info->max_rt_time;
+	con->ttl = conn_info->ttl;
+	con->tos_or_tc = conn_info->tos_or_tc;
+	con->mss = conn_info->mss;
+	con->cwnd = conn_info->cwnd;
+	con->rcv_wnd_scale = conn_info->rcv_wnd_scale;
+	con->connect_mode = 0; /* TCP_CONNECT_ACTIVE */
+
+	return qed_sp_nvmetcp_conn_offload(QED_AFFIN_HWFN(cdev), con,
+					 QED_SPQ_MODE_EBLOCK, NULL);
+}
+
+static int qed_nvmetcp_update_conn(struct qed_dev *cdev,
+				   u32 handle,
+				   struct qed_nvmetcp_params_update *conn_info)
+{
+	struct qed_hash_nvmetcp_con *hash_con;
+	struct qed_nvmetcp_conn *con;
+
+	hash_con = qed_nvmetcp_get_hash(cdev, handle);
+	if (!hash_con) {
+		DP_NOTICE(cdev, "Failed to find connection for handle %d\n",
+			  handle);
+
+		return -EINVAL;
+	}
+
+	/* Update the connection with information from the params */
+	con = hash_con->con;
+
+	SET_FIELD(con->update_flag,
+		  ISCSI_CONN_UPDATE_RAMROD_PARAMS_INITIAL_R2T, 0);
+	SET_FIELD(con->update_flag,
+		  ISCSI_CONN_UPDATE_RAMROD_PARAMS_IMMEDIATE_DATA, 1);
+
+	if (conn_info->hdr_digest_en)
+		SET_FIELD(con->update_flag, ISCSI_CONN_UPDATE_RAMROD_PARAMS_HD_EN, 1);
+
+	if (conn_info->data_digest_en)
+		SET_FIELD(con->update_flag, ISCSI_CONN_UPDATE_RAMROD_PARAMS_DD_EN, 1);
+
+	/* Placeholder - initialize pfv, cpda, hpda */
+
+	con->max_seq_size = conn_info->max_io_size;
+	con->max_recv_pdu_length = conn_info->max_recv_pdu_length;
+	con->max_send_pdu_length = conn_info->max_send_pdu_length;
+	con->first_seq_length = conn_info->max_io_size;
+
+	return qed_sp_nvmetcp_conn_update(QED_AFFIN_HWFN(cdev), con,
+					QED_SPQ_MODE_EBLOCK, NULL);
+}
+
+static int qed_nvmetcp_clear_conn_sq(struct qed_dev *cdev, u32 handle)
+{
+	struct qed_hash_nvmetcp_con *hash_con;
+
+	hash_con = qed_nvmetcp_get_hash(cdev, handle);
+	if (!hash_con) {
+		DP_NOTICE(cdev, "Failed to find connection for handle %d\n",
+			  handle);
+
+		return -EINVAL;
+	}
+
+	return qed_sp_nvmetcp_conn_clear_sq(QED_AFFIN_HWFN(cdev), hash_con->con,
+					    QED_SPQ_MODE_EBLOCK, NULL);
+}
+
+static int qed_nvmetcp_destroy_conn(struct qed_dev *cdev,
+				    u32 handle, u8 abrt_conn)
+{
+	struct qed_hash_nvmetcp_con *hash_con;
+
+	hash_con = qed_nvmetcp_get_hash(cdev, handle);
+	if (!hash_con) {
+		DP_NOTICE(cdev, "Failed to find connection for handle %d\n",
+			  handle);
+
+		return -EINVAL;
+	}
+
+	hash_con->con->abortive_dsconnect = abrt_conn;
+
+	return qed_sp_nvmetcp_conn_terminate(QED_AFFIN_HWFN(cdev), hash_con->con,
+					   QED_SPQ_MODE_EBLOCK, NULL);
+}
+
 static const struct qed_nvmetcp_ops qed_nvmetcp_ops_pass = {
 	.common = &qed_common_ops_pass,
 	.ll2 = &qed_ll2_ops_pass,
@@ -266,8 +840,12 @@ static const struct qed_nvmetcp_ops qed_nvmetcp_ops_pass = {
 	.register_ops = &qed_register_nvmetcp_ops,
 	.start = &qed_nvmetcp_start,
 	.stop = &qed_nvmetcp_stop,
-
-	/* Placeholder - Connection level ops */
+	.acquire_conn = &qed_nvmetcp_acquire_conn,
+	.release_conn = &qed_nvmetcp_release_conn,
+	.offload_conn = &qed_nvmetcp_offload_conn,
+	.update_conn = &qed_nvmetcp_update_conn,
+	.destroy_conn = &qed_nvmetcp_destroy_conn,
+	.clear_sq = &qed_nvmetcp_clear_conn_sq,
 };
 
 const struct qed_nvmetcp_ops *qed_get_nvmetcp_ops(void)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
index 774b46ade408..749169f0bdb1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
@@ -19,6 +19,7 @@
 #define QED_NVMETCP_FW_CQ_SIZE (4 * 1024)
 
 /* tcp parameters */
+#define QED_TCP_FLOW_LABEL 0
 #define QED_TCP_TWO_MSL_TIMER 4000
 #define QED_TCP_HALF_WAY_CLOSE_TIMEOUT 10
 #define QED_TCP_MAX_FIN_RT 2
@@ -32,6 +33,68 @@ struct qed_nvmetcp_info {
 	nvmetcp_event_cb_t event_cb;
 };
 
+struct qed_hash_nvmetcp_con {
+	struct hlist_node node;
+	struct qed_nvmetcp_conn *con;
+};
+
+struct qed_nvmetcp_conn {
+	struct list_head list_entry;
+	bool free_on_delete;
+
+	u16 conn_id;
+	u32 icid;
+	u32 fw_cid;
+
+	u8 layer_code;
+	u8 offl_flags;
+	u8 connect_mode;
+
+	dma_addr_t sq_pbl_addr;
+	struct qed_chain r2tq;
+	struct qed_chain xhq;
+	struct qed_chain uhq;
+
+	u8 local_mac[6];
+	u8 remote_mac[6];
+	u8 ip_version;
+	u8 ka_max_probe_cnt;
+
+	u16 vlan_id;
+	u16 tcp_flags;
+	u32 remote_ip[4];
+	u32 local_ip[4];
+
+	u32 flow_label;
+	u32 ka_timeout;
+	u32 ka_interval;
+	u32 max_rt_time;
+
+	u8 ttl;
+	u8 tos_or_tc;
+	u16 remote_port;
+	u16 local_port;
+	u16 mss;
+	u8 rcv_wnd_scale;
+	u32 rcv_wnd;
+	u32 cwnd;
+
+	u8 update_flag;
+	u8 default_cq;
+	u8 abortive_dsconnect;
+
+	u32 max_seq_size;
+	u32 max_recv_pdu_length;
+	u32 max_send_pdu_length;
+	u32 first_seq_length;
+
+	u16 physical_q0;
+	u16 physical_q1;
+
+	u16 nvmetcp_cccid_max_range;
+	dma_addr_t nvmetcp_cccid_itid_table_addr;
+};
+
 #if IS_ENABLED(CONFIG_QED_NVMETCP)
 int qed_nvmetcp_alloc(struct qed_hwfn *p_hwfn);
 void qed_nvmetcp_setup(struct qed_hwfn *p_hwfn);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp.h b/drivers/net/ethernet/qlogic/qed/qed_sp.h
index 525159e747a5..60ff3222bf55 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp.h
@@ -101,6 +101,9 @@ union ramrod_data {
 	struct iscsi_spe_conn_termination iscsi_conn_terminate;
 
 	struct nvmetcp_init_ramrod_params nvmetcp_init;
+	struct nvmetcp_spe_conn_offload nvmetcp_conn_offload;
+	struct nvmetcp_conn_update_ramrod_params nvmetcp_conn_update;
+	struct nvmetcp_spe_conn_termination nvmetcp_conn_terminate;
 
 	struct vf_start_ramrod_data vf_start;
 	struct vf_stop_ramrod_data vf_stop;
diff --git a/include/linux/qed/nvmetcp_common.h b/include/linux/qed/nvmetcp_common.h
index e9ccfc07041d..c8836b71b866 100644
--- a/include/linux/qed/nvmetcp_common.h
+++ b/include/linux/qed/nvmetcp_common.h
@@ -6,6 +6,8 @@
 
 #include "tcp_common.h"
 
+#define NVMETCP_SLOW_PATH_LAYER_CODE (6)
+
 /* NVMeTCP firmware function init parameters */
 struct nvmetcp_spe_func_init {
 	__le16 half_way_close_timeout;
@@ -43,6 +45,10 @@ enum nvmetcp_ramrod_cmd_id {
 	NVMETCP_RAMROD_CMD_ID_UNUSED = 0,
 	NVMETCP_RAMROD_CMD_ID_INIT_FUNC = 1,
 	NVMETCP_RAMROD_CMD_ID_DESTROY_FUNC = 2,
+	NVMETCP_RAMROD_CMD_ID_OFFLOAD_CONN = 3,
+	NVMETCP_RAMROD_CMD_ID_UPDATE_CONN = 4,
+	NVMETCP_RAMROD_CMD_ID_TERMINATION_CONN = 5,
+	NVMETCP_RAMROD_CMD_ID_CLEAR_SQ = 6,
 	MAX_NVMETCP_RAMROD_CMD_ID
 };
 
@@ -51,4 +57,141 @@ struct nvmetcp_glbl_queue_entry {
 	struct regpair reserved;
 };
 
+/* NVMeTCP conn level EQEs */
+enum nvmetcp_eqe_opcode {
+	NVMETCP_EVENT_TYPE_INIT_FUNC = 0, /* Response after init Ramrod */
+	NVMETCP_EVENT_TYPE_DESTROY_FUNC, /* Response after destroy Ramrod */
+	NVMETCP_EVENT_TYPE_OFFLOAD_CONN,/* Response after option 2 offload Ramrod */
+	NVMETCP_EVENT_TYPE_UPDATE_CONN, /* Response after update Ramrod */
+	NVMETCP_EVENT_TYPE_CLEAR_SQ, /* Response after clear sq Ramrod */
+	NVMETCP_EVENT_TYPE_TERMINATE_CONN, /* Response after termination Ramrod */
+	NVMETCP_EVENT_TYPE_RESERVED0,
+	NVMETCP_EVENT_TYPE_RESERVED1,
+	NVMETCP_EVENT_TYPE_ASYN_CONNECT_COMPLETE, /* Connect completed (A-syn EQE) */
+	NVMETCP_EVENT_TYPE_ASYN_TERMINATE_DONE, /* Termination completed (A-syn EQE) */
+	NVMETCP_EVENT_TYPE_START_OF_ERROR_TYPES = 10, /* Separate EQs from err EQs */
+	NVMETCP_EVENT_TYPE_ASYN_ABORT_RCVD, /* TCP RST packet receive (A-syn EQE) */
+	NVMETCP_EVENT_TYPE_ASYN_CLOSE_RCVD, /* TCP FIN packet receive (A-syn EQE) */
+	NVMETCP_EVENT_TYPE_ASYN_SYN_RCVD, /* TCP SYN+ACK packet receive (A-syn EQE) */
+	NVMETCP_EVENT_TYPE_ASYN_MAX_RT_TIME, /* TCP max retransmit time (A-syn EQE) */
+	NVMETCP_EVENT_TYPE_ASYN_MAX_RT_CNT, /* TCP max retransmit count (A-syn EQE) */
+	NVMETCP_EVENT_TYPE_ASYN_MAX_KA_PROBES_CNT, /* TCP ka probes count (A-syn EQE) */
+	NVMETCP_EVENT_TYPE_ASYN_FIN_WAIT2, /* TCP fin wait 2 (A-syn EQE) */
+	NVMETCP_EVENT_TYPE_NVMETCP_CONN_ERROR, /* NVMeTCP error response (A-syn EQE) */
+	NVMETCP_EVENT_TYPE_TCP_CONN_ERROR, /* NVMeTCP error - tcp error (A-syn EQE) */
+	MAX_NVMETCP_EQE_OPCODE
+};
+
+struct nvmetcp_conn_offload_section {
+	struct regpair cccid_itid_table_addr; /* CCCID to iTID table address */
+	__le16 cccid_max_range; /* CCCID max value - used for validation */
+	__le16 reserved[3];
+};
+
+/* NVMe TCP connection offload params passed by driver to FW in NVMeTCP offload ramrod */
+struct nvmetcp_conn_offload_params {
+	struct regpair sq_pbl_addr;
+	struct regpair r2tq_pbl_addr;
+	struct regpair xhq_pbl_addr;
+	struct regpair uhq_pbl_addr;
+	__le16 physical_q0;
+	__le16 physical_q1;
+	u8 flags;
+#define NVMETCP_CONN_OFFLOAD_PARAMS_TCP_ON_CHIP_1B_MASK 0x1
+#define NVMETCP_CONN_OFFLOAD_PARAMS_TCP_ON_CHIP_1B_SHIFT 0
+#define NVMETCP_CONN_OFFLOAD_PARAMS_TARGET_MODE_MASK 0x1
+#define NVMETCP_CONN_OFFLOAD_PARAMS_TARGET_MODE_SHIFT 1
+#define NVMETCP_CONN_OFFLOAD_PARAMS_RESTRICTED_MODE_MASK 0x1
+#define NVMETCP_CONN_OFFLOAD_PARAMS_RESTRICTED_MODE_SHIFT 2
+#define NVMETCP_CONN_OFFLOAD_PARAMS_NVMETCP_MODE_MASK 0x1
+#define NVMETCP_CONN_OFFLOAD_PARAMS_NVMETCP_MODE_SHIFT 3
+#define NVMETCP_CONN_OFFLOAD_PARAMS_RESERVED1_MASK 0xF
+#define NVMETCP_CONN_OFFLOAD_PARAMS_RESERVED1_SHIFT 4
+	u8 default_cq;
+	__le16 reserved0;
+	__le32 reserved1;
+	__le32 initial_ack;
+
+	struct nvmetcp_conn_offload_section nvmetcp; /* NVMe/TCP section */
+};
+
+/* NVMe TCP and TCP connection offload params passed by driver to FW in NVMeTCP offload ramrod. */
+struct nvmetcp_spe_conn_offload {
+	__le16 reserved;
+	__le16 conn_id;
+	__le32 fw_cid;
+	struct nvmetcp_conn_offload_params nvmetcp;
+	struct tcp_offload_params_opt2 tcp;
+};
+
+/* NVMeTCP connection update params passed by driver to FW in NVMETCP update ramrod. */
+struct nvmetcp_conn_update_ramrod_params {
+	__le16 reserved0;
+	__le16 conn_id;
+	__le32 reserved1;
+	u8 flags;
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_HD_EN_MASK 0x1
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_HD_EN_SHIFT 0
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_DD_EN_MASK 0x1
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_DD_EN_SHIFT 1
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED0_MASK 0x1
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED0_SHIFT 2
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED1_MASK 0x1
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED1_DATA_SHIFT 3
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED2_MASK 0x1
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED2_SHIFT 4
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED3_MASK 0x1
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED3_SHIFT 5
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED4_MASK 0x1
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED4_SHIFT 6
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED5_MASK 0x1
+#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED5_SHIFT 7
+	u8 reserved3[3];
+	__le32 max_seq_size;
+	__le32 max_send_pdu_length;
+	__le32 max_recv_pdu_length;
+	__le32 first_seq_length;
+	__le32 reserved4[5];
+};
+
+/* NVMeTCP connection termination request */
+struct nvmetcp_spe_conn_termination {
+	__le16 reserved0;
+	__le16 conn_id;
+	__le32 reserved1;
+	u8 abortive;
+	u8 reserved2[7];
+	struct regpair reserved3;
+	struct regpair reserved4;
+};
+
+struct nvmetcp_dif_flags {
+	u8 flags;
+};
+
+enum nvmetcp_wqe_type {
+	NVMETCP_WQE_TYPE_NORMAL,
+	NVMETCP_WQE_TYPE_TASK_CLEANUP,
+	NVMETCP_WQE_TYPE_MIDDLE_PATH,
+	NVMETCP_WQE_TYPE_IC,
+	MAX_NVMETCP_WQE_TYPE
+};
+
+struct nvmetcp_wqe {
+	__le16 task_id;
+	u8 flags;
+#define NVMETCP_WQE_WQE_TYPE_MASK 0x7 /* [use nvmetcp_wqe_type] */
+#define NVMETCP_WQE_WQE_TYPE_SHIFT 0
+#define NVMETCP_WQE_NUM_SGES_MASK 0xF
+#define NVMETCP_WQE_NUM_SGES_SHIFT 3
+#define NVMETCP_WQE_RESPONSE_MASK 0x1
+#define NVMETCP_WQE_RESPONSE_SHIFT 7
+	struct nvmetcp_dif_flags prot_flags;
+	__le32 contlen_cdbsize;
+#define NVMETCP_WQE_CONT_LEN_MASK 0xFFFFFF
+#define NVMETCP_WQE_CONT_LEN_SHIFT 0
+#define NVMETCP_WQE_CDB_SIZE_OR_NVMETCP_CMD_MASK 0xFF
+#define NVMETCP_WQE_CDB_SIZE_OR_NVMETCP_CMD_SHIFT 24
+};
+
 #endif /* __NVMETCP_COMMON__ */
diff --git a/include/linux/qed/qed_nvmetcp_if.h b/include/linux/qed/qed_nvmetcp_if.h
index abc1f41862e3..96263e3cfa1e 100644
--- a/include/linux/qed/qed_nvmetcp_if.h
+++ b/include/linux/qed/qed_nvmetcp_if.h
@@ -25,6 +25,50 @@ struct qed_nvmetcp_tid {
 	u8 *blocks[MAX_TID_BLOCKS_NVMETCP];
 };
 
+struct qed_nvmetcp_id_params {
+	u8 mac[ETH_ALEN];
+	u32 ip[4];
+	u16 port;
+};
+
+struct qed_nvmetcp_params_offload {
+	/* FW initializations */
+	dma_addr_t sq_pbl_addr;
+	dma_addr_t nvmetcp_cccid_itid_table_addr;
+	u16 nvmetcp_cccid_max_range;
+	u8 default_cq;
+
+	/* Networking and TCP stack initializations */
+	struct qed_nvmetcp_id_params src;
+	struct qed_nvmetcp_id_params dst;
+	u32 ka_timeout;
+	u32 ka_interval;
+	u32 max_rt_time;
+	u32 cwnd;
+	u16 mss;
+	u16 vlan_id;
+	bool timestamp_en;
+	bool delayed_ack_en;
+	bool tcp_keep_alive_en;
+	bool ecn_en;
+	u8 ip_version;
+	u8 ka_max_probe_cnt;
+	u8 ttl;
+	u8 tos_or_tc;
+	u8 rcv_wnd_scale;
+};
+
+struct qed_nvmetcp_params_update {
+	u32 max_io_size;
+	u32 max_recv_pdu_length;
+	u32 max_send_pdu_length;
+
+	/* Placeholder: pfv, cpda, hpda */
+
+	bool hdr_digest_en;
+	bool data_digest_en;
+};
+
 struct qed_nvmetcp_cb_ops {
 	struct qed_common_cb_ops common;
 };
@@ -48,6 +92,38 @@ struct qed_nvmetcp_cb_ops {
  * @stop:		nvmetcp in FW
  *			@param cdev
  *			return 0 on success, otherwise error value.
+ * @acquire_conn:	acquire a new nvmetcp connection
+ *			@param cdev
+ *			@param handle - qed will fill handle that should be
+ *				used henceforth as identifier of the
+ *				connection.
+ *			@param p_doorbell - qed will fill the address of the
+ *				doorbell.
+ *			@return 0 on sucesss, otherwise error value.
+ * @release_conn:	release a previously acquired nvmetcp connection
+ *			@param cdev
+ *			@param handle - the connection handle.
+ *			@return 0 on success, otherwise error value.
+ * @offload_conn:	configures an offloaded connection
+ *			@param cdev
+ *			@param handle - the connection handle.
+ *			@param conn_info - the configuration to use for the
+ *				offload.
+ *			@return 0 on success, otherwise error value.
+ * @update_conn:	updates an offloaded connection
+ *			@param cdev
+ *			@param handle - the connection handle.
+ *			@param conn_info - the configuration to use for the
+ *				offload.
+ *			@return 0 on success, otherwise error value.
+ * @destroy_conn:	stops an offloaded connection
+ *			@param cdev
+ *			@param handle - the connection handle.
+ *			@return 0 on success, otherwise error value.
+ * @clear_sq:		clear all task in sq
+ *			@param cdev
+ *			@param handle - the connection handle.
+ *			@return 0 on success, otherwise error value.
  */
 struct qed_nvmetcp_ops {
 	const struct qed_common_ops *common;
@@ -65,6 +141,24 @@ struct qed_nvmetcp_ops {
 		     void *event_context, nvmetcp_event_cb_t async_event_cb);
 
 	int (*stop)(struct qed_dev *cdev);
+
+	int (*acquire_conn)(struct qed_dev *cdev,
+			    u32 *handle,
+			    u32 *fw_cid, void __iomem **p_doorbell);
+
+	int (*release_conn)(struct qed_dev *cdev, u32 handle);
+
+	int (*offload_conn)(struct qed_dev *cdev,
+			    u32 handle,
+			    struct qed_nvmetcp_params_offload *conn_info);
+
+	int (*update_conn)(struct qed_dev *cdev,
+			   u32 handle,
+			   struct qed_nvmetcp_params_update *conn_info);
+
+	int (*destroy_conn)(struct qed_dev *cdev, u32 handle, u8 abrt_conn);
+
+	int (*clear_sq)(struct qed_dev *cdev, u32 handle);
 };
 
 const struct qed_nvmetcp_ops *qed_get_nvmetcp_ops(void);
-- 
2.22.0

