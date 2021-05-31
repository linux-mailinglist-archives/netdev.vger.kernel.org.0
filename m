Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2283B3969E2
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 00:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhEaW6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 18:58:32 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25072 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232412AbhEaW6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 18:58:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VMporJ002250;
        Mon, 31 May 2021 15:54:19 -0700
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38vtnja4nx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 15:54:19 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 15:54:17 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 31 May 2021 15:54:14 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <smalin@marvell.com>
Subject: [RFC PATCH v7 09/27] qed: Add TCP_ULP FW resource layout
Date:   Tue, 1 Jun 2021 01:52:04 +0300
Message-ID: <20210531225222.16992-10-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210531225222.16992-1-smalin@marvell.com>
References: <20210531225222.16992-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: ZKh840SdasYa3jqy24UDl3MCyO4Op2S_
X-Proofpoint-ORIG-GUID: ZKh840SdasYa3jqy24UDl3MCyO4Op2S_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_15:2021-05-31,2021-05-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omkar Kulkarni <okulkarni@marvell.com>

Add TCP_ULP as a storage common TCP offlload FW resource layout.
This will be used by the core driver (QED) for both the NVMeTCP and iSCSI.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/net/ethernet/qlogic/qed/qed.h         |  1 +
 drivers/net/ethernet/qlogic/qed/qed_cxt.c     | 18 ++++++++---------
 drivers/net/ethernet/qlogic/qed/qed_cxt.h     |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c     |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c   | 20 +++++++++----------
 drivers/net/ethernet/qlogic/qed/qed_ll2.c     |  8 ++++----
 drivers/net/ethernet/qlogic/qed/qed_ooo.c     |  2 +-
 .../net/ethernet/qlogic/qed/qed_sp_commands.c |  2 +-
 include/linux/qed/common_hsi.h                |  2 +-
 include/linux/qed/qed_ll2_if.h                |  2 +-
 11 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index a20cb8a0c377..deba23068c3a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -239,6 +239,7 @@ enum QED_FEATURE {
 	QED_PF_L2_QUE,
 	QED_VF,
 	QED_RDMA_CNQ,
+	QED_NVMETCP_CQ,
 	QED_ISCSI_CQ,
 	QED_FCOE_CQ,
 	QED_VF_L2_QUE,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 0a22f8ce9a2c..fcabbaa518df 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -94,14 +94,14 @@ struct src_ent {
 
 static bool src_proto(enum protocol_type type)
 {
-	return type == PROTOCOLID_ISCSI ||
+	return type == PROTOCOLID_TCP_ULP ||
 	       type == PROTOCOLID_FCOE ||
 	       type == PROTOCOLID_IWARP;
 }
 
 static bool tm_cid_proto(enum protocol_type type)
 {
-	return type == PROTOCOLID_ISCSI ||
+	return type == PROTOCOLID_TCP_ULP ||
 	       type == PROTOCOLID_FCOE ||
 	       type == PROTOCOLID_ROCE ||
 	       type == PROTOCOLID_IWARP;
@@ -2090,13 +2090,13 @@ int qed_cxt_set_pf_params(struct qed_hwfn *p_hwfn, u32 rdma_tasks)
 
 		if (p_params->num_cons && p_params->num_tasks) {
 			qed_cxt_set_proto_cid_count(p_hwfn,
-						    PROTOCOLID_ISCSI,
+						    PROTOCOLID_TCP_ULP,
 						    p_params->num_cons,
 						    0);
 
 			qed_cxt_set_proto_tid_count(p_hwfn,
-						    PROTOCOLID_ISCSI,
-						    QED_CXT_ISCSI_TID_SEG,
+						    PROTOCOLID_TCP_ULP,
+						    QED_CXT_TCP_ULP_TID_SEG,
 						    0,
 						    p_params->num_tasks,
 						    true);
@@ -2129,8 +2129,8 @@ int qed_cxt_get_tid_mem_info(struct qed_hwfn *p_hwfn,
 		seg = QED_CXT_FCOE_TID_SEG;
 		break;
 	case QED_PCI_ISCSI:
-		proto = PROTOCOLID_ISCSI;
-		seg = QED_CXT_ISCSI_TID_SEG;
+		proto = PROTOCOLID_TCP_ULP;
+		seg = QED_CXT_TCP_ULP_TID_SEG;
 		break;
 	default:
 		return -EINVAL;
@@ -2455,8 +2455,8 @@ int qed_cxt_get_task_ctx(struct qed_hwfn *p_hwfn,
 		seg = QED_CXT_FCOE_TID_SEG;
 		break;
 	case QED_PCI_ISCSI:
-		proto = PROTOCOLID_ISCSI;
-		seg = QED_CXT_ISCSI_TID_SEG;
+		proto = PROTOCOLID_TCP_ULP;
+		seg = QED_CXT_TCP_ULP_TID_SEG;
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.h b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
index 056e79620a0e..8adb7ed0c12d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
@@ -50,7 +50,7 @@ int qed_cxt_get_cid_info(struct qed_hwfn *p_hwfn,
 int qed_cxt_get_tid_mem_info(struct qed_hwfn *p_hwfn,
 			     struct qed_tid_mem *p_info);
 
-#define QED_CXT_ISCSI_TID_SEG	PROTOCOLID_ISCSI
+#define QED_CXT_TCP_ULP_TID_SEG	PROTOCOLID_TCP_ULP
 #define QED_CXT_ROCE_TID_SEG	PROTOCOLID_ROCE
 #define QED_CXT_FCOE_TID_SEG	PROTOCOLID_FCOE
 enum qed_cxt_elem_type {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index d2f5855b2ea7..c231d0e56571 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -2266,7 +2266,7 @@ int qed_resc_alloc(struct qed_dev *cdev)
 		} else if (p_hwfn->hw_info.personality == QED_PCI_ISCSI) {
 			num_cons =
 			    qed_cxt_get_proto_cid_count(p_hwfn,
-							PROTOCOLID_ISCSI,
+							PROTOCOLID_TCP_ULP,
 							NULL);
 			n_eqes += 2 * num_cons;
 		}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 559df9f4d656..9dbeb2efdc51 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -1118,7 +1118,7 @@ struct outer_tag_config_struct {
 /* personality per PF */
 enum personality_type {
 	BAD_PERSONALITY_TYP,
-	PERSONALITY_ISCSI,
+	PERSONALITY_TCP_ULP,
 	PERSONALITY_FCOE,
 	PERSONALITY_RDMA_AND_ETH,
 	PERSONALITY_RDMA,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
index 4eae4ee3538f..041201631fd4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
@@ -158,7 +158,7 @@ qed_sp_iscsi_func_start(struct qed_hwfn *p_hwfn,
 
 	rc = qed_sp_init_request(p_hwfn, &p_ent,
 				 ISCSI_RAMROD_CMD_ID_INIT_FUNC,
-				 PROTOCOLID_ISCSI, &init_data);
+				 PROTOCOLID_TCP_ULP, &init_data);
 	if (rc)
 		return rc;
 
@@ -250,7 +250,7 @@ qed_sp_iscsi_func_start(struct qed_hwfn *p_hwfn,
 	p_hwfn->p_iscsi_info->event_context = event_context;
 	p_hwfn->p_iscsi_info->event_cb = async_event_cb;
 
-	qed_spq_register_async_cb(p_hwfn, PROTOCOLID_ISCSI,
+	qed_spq_register_async_cb(p_hwfn, PROTOCOLID_TCP_ULP,
 				  qed_iscsi_async_event);
 
 	return qed_spq_post(p_hwfn, p_ent, NULL);
@@ -286,7 +286,7 @@ static int qed_sp_iscsi_conn_offload(struct qed_hwfn *p_hwfn,
 
 	rc = qed_sp_init_request(p_hwfn, &p_ent,
 				 ISCSI_RAMROD_CMD_ID_OFFLOAD_CONN,
-				 PROTOCOLID_ISCSI, &init_data);
+				 PROTOCOLID_TCP_ULP, &init_data);
 	if (rc)
 		return rc;
 
@@ -465,7 +465,7 @@ static int qed_sp_iscsi_conn_update(struct qed_hwfn *p_hwfn,
 
 	rc = qed_sp_init_request(p_hwfn, &p_ent,
 				 ISCSI_RAMROD_CMD_ID_UPDATE_CONN,
-				 PROTOCOLID_ISCSI, &init_data);
+				 PROTOCOLID_TCP_ULP, &init_data);
 	if (rc)
 		return rc;
 
@@ -506,7 +506,7 @@ qed_sp_iscsi_mac_update(struct qed_hwfn *p_hwfn,
 
 	rc = qed_sp_init_request(p_hwfn, &p_ent,
 				 ISCSI_RAMROD_CMD_ID_MAC_UPDATE,
-				 PROTOCOLID_ISCSI, &init_data);
+				 PROTOCOLID_TCP_ULP, &init_data);
 	if (rc)
 		return rc;
 
@@ -548,7 +548,7 @@ static int qed_sp_iscsi_conn_terminate(struct qed_hwfn *p_hwfn,
 
 	rc = qed_sp_init_request(p_hwfn, &p_ent,
 				 ISCSI_RAMROD_CMD_ID_TERMINATION_CONN,
-				 PROTOCOLID_ISCSI, &init_data);
+				 PROTOCOLID_TCP_ULP, &init_data);
 	if (rc)
 		return rc;
 
@@ -582,7 +582,7 @@ static int qed_sp_iscsi_conn_clear_sq(struct qed_hwfn *p_hwfn,
 
 	rc = qed_sp_init_request(p_hwfn, &p_ent,
 				 ISCSI_RAMROD_CMD_ID_CLEAR_SQ,
-				 PROTOCOLID_ISCSI, &init_data);
+				 PROTOCOLID_TCP_ULP, &init_data);
 	if (rc)
 		return rc;
 
@@ -606,13 +606,13 @@ static int qed_sp_iscsi_func_stop(struct qed_hwfn *p_hwfn,
 
 	rc = qed_sp_init_request(p_hwfn, &p_ent,
 				 ISCSI_RAMROD_CMD_ID_DESTROY_FUNC,
-				 PROTOCOLID_ISCSI, &init_data);
+				 PROTOCOLID_TCP_ULP, &init_data);
 	if (rc)
 		return rc;
 
 	rc = qed_spq_post(p_hwfn, p_ent, NULL);
 
-	qed_spq_unregister_async_cb(p_hwfn, PROTOCOLID_ISCSI);
+	qed_spq_unregister_async_cb(p_hwfn, PROTOCOLID_TCP_ULP);
 	return rc;
 }
 
@@ -786,7 +786,7 @@ static int qed_iscsi_acquire_connection(struct qed_hwfn *p_hwfn,
 	u32 icid;
 
 	spin_lock_bh(&p_hwfn->p_iscsi_info->lock);
-	rc = qed_cxt_acquire_cid(p_hwfn, PROTOCOLID_ISCSI, &icid);
+	rc = qed_cxt_acquire_cid(p_hwfn, PROTOCOLID_TCP_ULP, &icid);
 	spin_unlock_bh(&p_hwfn->p_iscsi_info->lock);
 	if (rc)
 		return rc;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 49783f365079..286e53927866 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -1037,8 +1037,8 @@ static int qed_sp_ll2_tx_queue_start(struct qed_hwfn *p_hwfn,
 	case QED_LL2_TYPE_FCOE:
 		p_ramrod->conn_type = PROTOCOLID_FCOE;
 		break;
-	case QED_LL2_TYPE_ISCSI:
-		p_ramrod->conn_type = PROTOCOLID_ISCSI;
+	case QED_LL2_TYPE_TCP_ULP:
+		p_ramrod->conn_type = PROTOCOLID_TCP_ULP;
 		break;
 	case QED_LL2_TYPE_ROCE:
 		p_ramrod->conn_type = PROTOCOLID_ROCE;
@@ -1048,7 +1048,7 @@ static int qed_sp_ll2_tx_queue_start(struct qed_hwfn *p_hwfn,
 		break;
 	case QED_LL2_TYPE_OOO:
 		if (p_hwfn->hw_info.personality == QED_PCI_ISCSI)
-			p_ramrod->conn_type = PROTOCOLID_ISCSI;
+			p_ramrod->conn_type = PROTOCOLID_TCP_ULP;
 		else
 			p_ramrod->conn_type = PROTOCOLID_IWARP;
 		break;
@@ -2442,7 +2442,7 @@ static int __qed_ll2_start(struct qed_hwfn *p_hwfn,
 		conn_type = QED_LL2_TYPE_FCOE;
 		break;
 	case QED_PCI_ISCSI:
-		conn_type = QED_LL2_TYPE_ISCSI;
+		conn_type = QED_LL2_TYPE_TCP_ULP;
 		break;
 	case QED_PCI_ETH_ROCE:
 		conn_type = QED_LL2_TYPE_ROCE;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ooo.c b/drivers/net/ethernet/qlogic/qed/qed_ooo.c
index 88353aa404dc..599da0d7366b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ooo.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ooo.c
@@ -83,7 +83,7 @@ int qed_ooo_alloc(struct qed_hwfn *p_hwfn)
 
 	switch (p_hwfn->hw_info.personality) {
 	case QED_PCI_ISCSI:
-		proto = PROTOCOLID_ISCSI;
+		proto = PROTOCOLID_TCP_ULP;
 		break;
 	case QED_PCI_ETH_RDMA:
 	case QED_PCI_ETH_IWARP:
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
index aa71adcf31ee..ee7dc0a7da6c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
@@ -385,7 +385,7 @@ int qed_sp_pf_start(struct qed_hwfn *p_hwfn,
 		p_ramrod->personality = PERSONALITY_FCOE;
 		break;
 	case QED_PCI_ISCSI:
-		p_ramrod->personality = PERSONALITY_ISCSI;
+		p_ramrod->personality = PERSONALITY_TCP_ULP;
 		break;
 	case QED_PCI_ETH_ROCE:
 	case QED_PCI_ETH_IWARP:
diff --git a/include/linux/qed/common_hsi.h b/include/linux/qed/common_hsi.h
index 977807e1be53..0a3807e927c5 100644
--- a/include/linux/qed/common_hsi.h
+++ b/include/linux/qed/common_hsi.h
@@ -702,7 +702,7 @@ enum mf_mode {
 
 /* Per-protocol connection types */
 enum protocol_type {
-	PROTOCOLID_ISCSI,
+	PROTOCOLID_TCP_ULP,
 	PROTOCOLID_FCOE,
 	PROTOCOLID_ROCE,
 	PROTOCOLID_CORE,
diff --git a/include/linux/qed/qed_ll2_if.h b/include/linux/qed/qed_ll2_if.h
index 2f64ed79cee9..fa5e213ed1f7 100644
--- a/include/linux/qed/qed_ll2_if.h
+++ b/include/linux/qed/qed_ll2_if.h
@@ -19,7 +19,7 @@
 
 enum qed_ll2_conn_type {
 	QED_LL2_TYPE_FCOE,
-	QED_LL2_TYPE_ISCSI,
+	QED_LL2_TYPE_TCP_ULP,
 	QED_LL2_TYPE_TEST,
 	QED_LL2_TYPE_OOO,
 	QED_LL2_TYPE_RESERVED2,
-- 
2.22.0

