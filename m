Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BAA36F03F
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 21:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhD2TRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 15:17:45 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41140 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239528AbhD2TLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 15:11:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13TJ6cox019681;
        Thu, 29 Apr 2021 12:09:50 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 387erumvxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Apr 2021 12:09:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Apr
 2021 12:09:49 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 12:09:46 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>, <hch@lst.de>, <axboe@fb.com>,
        <kbusch@kernel.org>
CC:     =?UTF-8?q?David=20S=20=2E=20Miller=20davem=20=40=20davemloft=20=2E=20net=20=C2=A0--cc=3DJakub=20Kicinski?= 
        <kuba@kernel.org>, <smalin@marvell.com>, <aelior@marvell.com>,
        <mkalderon@marvell.com>, <okulkarni@marvell.com>,
        <pkushwaha@marvell.com>, <malin1024@gmail.com>
Subject: [RFC PATCH v4 03/27] qed: Add qed-NVMeTCP personality
Date:   Thu, 29 Apr 2021 22:09:02 +0300
Message-ID: <20210429190926.5086-4-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210429190926.5086-1-smalin@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: txliZhpqHizXfcVMuwRkrMI2luj8Pqjn
X-Proofpoint-ORIG-GUID: txliZhpqHizXfcVMuwRkrMI2luj8Pqjn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-29_10:2021-04-28,2021-04-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omkar Kulkarni <okulkarni@marvell.com>

This patch adds qed NVMeTCP personality in order to support the NVMeTCP
qed functionalities and manage the HW device shared resources.
The same design is used with Eth (qede), RDMA(qedr), iSCSI (qedi) and
FCoE (qedf).

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h         |  3 ++
 drivers/net/ethernet/qlogic/qed/qed_cxt.c     | 32 ++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_cxt.h     |  1 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c     | 44 ++++++++++++++++---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     |  3 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c     | 31 ++++++++-----
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     |  3 ++
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c |  3 +-
 drivers/net/ethernet/qlogic/qed/qed_ooo.c     |  5 ++-
 .../net/ethernet/qlogic/qed/qed_sp_commands.c |  1 +
 10 files changed, 108 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 91d4635009ab..7ae648c4edba 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -200,6 +200,7 @@ enum qed_pci_personality {
 	QED_PCI_ETH,
 	QED_PCI_FCOE,
 	QED_PCI_ISCSI,
+	QED_PCI_NVMETCP,
 	QED_PCI_ETH_ROCE,
 	QED_PCI_ETH_IWARP,
 	QED_PCI_ETH_RDMA,
@@ -285,6 +286,8 @@ struct qed_hw_info {
 	((dev)->hw_info.personality == QED_PCI_FCOE)
 #define QED_IS_ISCSI_PERSONALITY(dev)					\
 	((dev)->hw_info.personality == QED_PCI_ISCSI)
+#define QED_IS_NVMETCP_PERSONALITY(dev)					\
+	((dev)->hw_info.personality == QED_PCI_NVMETCP)
 
 	/* Resource Allocation scheme results */
 	u32				resc_start[QED_MAX_RESC];
diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 0a22f8ce9a2c..6cef75723e38 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -2106,6 +2106,30 @@ int qed_cxt_set_pf_params(struct qed_hwfn *p_hwfn, u32 rdma_tasks)
 		}
 		break;
 	}
+	case QED_PCI_NVMETCP:
+	{
+		struct qed_nvmetcp_pf_params *p_params;
+
+		p_params = &p_hwfn->pf_params.nvmetcp_pf_params;
+
+		if (p_params->num_cons && p_params->num_tasks) {
+			qed_cxt_set_proto_cid_count(p_hwfn,
+						    PROTOCOLID_NVMETCP,
+						    p_params->num_cons,
+						    0);
+
+			qed_cxt_set_proto_tid_count(p_hwfn,
+						    PROTOCOLID_NVMETCP,
+						    QED_CTX_NVMETCP_TID_SEG,
+						    0,
+						    p_params->num_tasks,
+						    true);
+		} else {
+			DP_INFO(p_hwfn->cdev,
+				"NvmeTCP personality used without setting params!\n");
+		}
+		break;
+	}
 	default:
 		return -EINVAL;
 	}
@@ -2132,6 +2156,10 @@ int qed_cxt_get_tid_mem_info(struct qed_hwfn *p_hwfn,
 		proto = PROTOCOLID_ISCSI;
 		seg = QED_CXT_ISCSI_TID_SEG;
 		break;
+	case QED_PCI_NVMETCP:
+		proto = PROTOCOLID_NVMETCP;
+		seg = QED_CTX_NVMETCP_TID_SEG;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2458,6 +2486,10 @@ int qed_cxt_get_task_ctx(struct qed_hwfn *p_hwfn,
 		proto = PROTOCOLID_ISCSI;
 		seg = QED_CXT_ISCSI_TID_SEG;
 		break;
+	case QED_PCI_NVMETCP:
+		proto = PROTOCOLID_NVMETCP;
+		seg = QED_CTX_NVMETCP_TID_SEG;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.h b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
index 056e79620a0e..8f1a77cb33f6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
@@ -51,6 +51,7 @@ int qed_cxt_get_tid_mem_info(struct qed_hwfn *p_hwfn,
 			     struct qed_tid_mem *p_info);
 
 #define QED_CXT_ISCSI_TID_SEG	PROTOCOLID_ISCSI
+#define QED_CTX_NVMETCP_TID_SEG PROTOCOLID_NVMETCP
 #define QED_CXT_ROCE_TID_SEG	PROTOCOLID_ROCE
 #define QED_CXT_FCOE_TID_SEG	PROTOCOLID_FCOE
 enum qed_cxt_elem_type {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index d2f5855b2ea7..d3f8cc42d07e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -37,6 +37,7 @@
 #include "qed_sriov.h"
 #include "qed_vf.h"
 #include "qed_rdma.h"
+#include "qed_nvmetcp.h"
 
 static DEFINE_SPINLOCK(qm_lock);
 
@@ -667,7 +668,8 @@ qed_llh_set_engine_affin(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	}
 
 	/* Storage PF is bound to a single engine while L2 PF uses both */
-	if (QED_IS_FCOE_PERSONALITY(p_hwfn) || QED_IS_ISCSI_PERSONALITY(p_hwfn))
+	if (QED_IS_FCOE_PERSONALITY(p_hwfn) || QED_IS_ISCSI_PERSONALITY(p_hwfn) ||
+	    QED_IS_NVMETCP_PERSONALITY(p_hwfn))
 		eng = cdev->fir_affin ? QED_ENG1 : QED_ENG0;
 	else			/* L2_PERSONALITY */
 		eng = QED_BOTH_ENG;
@@ -1164,6 +1166,9 @@ void qed_llh_remove_mac_filter(struct qed_dev *cdev,
 	if (!test_bit(QED_MF_LLH_MAC_CLSS, &cdev->mf_bits))
 		goto out;
 
+	if (QED_IS_NVMETCP_PERSONALITY(p_hwfn))
+		return;
+
 	ether_addr_copy(filter.mac.addr, mac_addr);
 	rc = qed_llh_shadow_remove_filter(cdev, ppfid, &filter, &filter_idx,
 					  &ref_cnt);
@@ -1381,6 +1386,11 @@ void qed_resc_free(struct qed_dev *cdev)
 			qed_ooo_free(p_hwfn);
 		}
 
+		if (p_hwfn->hw_info.personality == QED_PCI_NVMETCP) {
+			qed_nvmetcp_free(p_hwfn);
+			qed_ooo_free(p_hwfn);
+		}
+
 		if (QED_IS_RDMA_PERSONALITY(p_hwfn) && rdma_info) {
 			qed_spq_unregister_async_cb(p_hwfn, rdma_info->proto);
 			qed_rdma_info_free(p_hwfn);
@@ -1423,6 +1433,7 @@ static u32 qed_get_pq_flags(struct qed_hwfn *p_hwfn)
 		flags |= PQ_FLAGS_OFLD;
 		break;
 	case QED_PCI_ISCSI:
+	case QED_PCI_NVMETCP:
 		flags |= PQ_FLAGS_ACK | PQ_FLAGS_OOO | PQ_FLAGS_OFLD;
 		break;
 	case QED_PCI_ETH_ROCE:
@@ -2269,6 +2280,12 @@ int qed_resc_alloc(struct qed_dev *cdev)
 							PROTOCOLID_ISCSI,
 							NULL);
 			n_eqes += 2 * num_cons;
+		} else if (p_hwfn->hw_info.personality == QED_PCI_NVMETCP) {
+			num_cons =
+			    qed_cxt_get_proto_cid_count(p_hwfn,
+							PROTOCOLID_NVMETCP,
+							NULL);
+			n_eqes += 2 * num_cons;
 		}
 
 		if (n_eqes > 0xFFFF) {
@@ -2313,6 +2330,15 @@ int qed_resc_alloc(struct qed_dev *cdev)
 				goto alloc_err;
 		}
 
+		if (p_hwfn->hw_info.personality == QED_PCI_NVMETCP) {
+			rc = qed_nvmetcp_alloc(p_hwfn);
+			if (rc)
+				goto alloc_err;
+			rc = qed_ooo_alloc(p_hwfn);
+			if (rc)
+				goto alloc_err;
+		}
+
 		if (QED_IS_RDMA_PERSONALITY(p_hwfn)) {
 			rc = qed_rdma_info_alloc(p_hwfn);
 			if (rc)
@@ -2393,6 +2419,11 @@ void qed_resc_setup(struct qed_dev *cdev)
 			qed_iscsi_setup(p_hwfn);
 			qed_ooo_setup(p_hwfn);
 		}
+
+		if (p_hwfn->hw_info.personality == QED_PCI_NVMETCP) {
+			qed_nvmetcp_setup(p_hwfn);
+			qed_ooo_setup(p_hwfn);
+		}
 	}
 }
 
@@ -2854,7 +2885,8 @@ static int qed_hw_init_pf(struct qed_hwfn *p_hwfn,
 
 	/* Protocol Configuration */
 	STORE_RT_REG(p_hwfn, PRS_REG_SEARCH_TCP_RT_OFFSET,
-		     (p_hwfn->hw_info.personality == QED_PCI_ISCSI) ? 1 : 0);
+		     ((p_hwfn->hw_info.personality == QED_PCI_ISCSI) ||
+			 (p_hwfn->hw_info.personality == QED_PCI_NVMETCP)) ? 1 : 0);
 	STORE_RT_REG(p_hwfn, PRS_REG_SEARCH_FCOE_RT_OFFSET,
 		     (p_hwfn->hw_info.personality == QED_PCI_FCOE) ? 1 : 0);
 	STORE_RT_REG(p_hwfn, PRS_REG_SEARCH_ROCE_RT_OFFSET, 0);
@@ -3531,7 +3563,7 @@ static void qed_hw_set_feat(struct qed_hwfn *p_hwfn)
 					       RESC_NUM(p_hwfn,
 							QED_CMDQS_CQS));
 
-	if (QED_IS_ISCSI_PERSONALITY(p_hwfn))
+	if (QED_IS_ISCSI_PERSONALITY(p_hwfn) || QED_IS_NVMETCP_PERSONALITY(p_hwfn))
 		feat_num[QED_ISCSI_CQ] = min_t(u32, sb_cnt.cnt,
 					       RESC_NUM(p_hwfn,
 							QED_CMDQS_CQS));
@@ -3734,7 +3766,8 @@ int qed_hw_get_dflt_resc(struct qed_hwfn *p_hwfn,
 		break;
 	case QED_BDQ:
 		if (p_hwfn->hw_info.personality != QED_PCI_ISCSI &&
-		    p_hwfn->hw_info.personality != QED_PCI_FCOE)
+		    p_hwfn->hw_info.personality != QED_PCI_FCOE &&
+			p_hwfn->hw_info.personality != QED_PCI_NVMETCP)
 			*p_resc_num = 0;
 		else
 			*p_resc_num = 1;
@@ -3755,7 +3788,8 @@ int qed_hw_get_dflt_resc(struct qed_hwfn *p_hwfn,
 			*p_resc_start = 0;
 		else if (p_hwfn->cdev->num_ports_in_engine == 4)
 			*p_resc_start = p_hwfn->port_id;
-		else if (p_hwfn->hw_info.personality == QED_PCI_ISCSI)
+		else if (p_hwfn->hw_info.personality == QED_PCI_ISCSI ||
+			 p_hwfn->hw_info.personality == QED_PCI_NVMETCP)
 			*p_resc_start = p_hwfn->port_id;
 		else if (p_hwfn->hw_info.personality == QED_PCI_FCOE)
 			*p_resc_start = p_hwfn->port_id + 2;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 24472f6a83c2..9c9ec8f53ef8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -12148,7 +12148,8 @@ struct public_func {
 #define FUNC_MF_CFG_PROTOCOL_ISCSI              0x00000010
 #define FUNC_MF_CFG_PROTOCOL_FCOE               0x00000020
 #define FUNC_MF_CFG_PROTOCOL_ROCE               0x00000030
-#define FUNC_MF_CFG_PROTOCOL_MAX	0x00000030
+#define FUNC_MF_CFG_PROTOCOL_NVMETCP    0x00000040
+#define FUNC_MF_CFG_PROTOCOL_MAX	0x00000040
 
 #define FUNC_MF_CFG_MIN_BW_MASK		0x0000ff00
 #define FUNC_MF_CFG_MIN_BW_SHIFT	8
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 49783f365079..88bfcdcd4a4c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -960,7 +960,8 @@ static int qed_sp_ll2_rx_queue_start(struct qed_hwfn *p_hwfn,
 
 	if (test_bit(QED_MF_LL2_NON_UNICAST, &p_hwfn->cdev->mf_bits) &&
 	    p_ramrod->main_func_queue && conn_type != QED_LL2_TYPE_ROCE &&
-	    conn_type != QED_LL2_TYPE_IWARP) {
+	    conn_type != QED_LL2_TYPE_IWARP &&
+		(!QED_IS_NVMETCP_PERSONALITY(p_hwfn))) {
 		p_ramrod->mf_si_bcast_accept_all = 1;
 		p_ramrod->mf_si_mcast_accept_all = 1;
 	} else {
@@ -1049,6 +1050,8 @@ static int qed_sp_ll2_tx_queue_start(struct qed_hwfn *p_hwfn,
 	case QED_LL2_TYPE_OOO:
 		if (p_hwfn->hw_info.personality == QED_PCI_ISCSI)
 			p_ramrod->conn_type = PROTOCOLID_ISCSI;
+		else if (p_hwfn->hw_info.personality == QED_PCI_NVMETCP)
+			p_ramrod->conn_type = PROTOCOLID_NVMETCP;
 		else
 			p_ramrod->conn_type = PROTOCOLID_IWARP;
 		break;
@@ -1634,7 +1637,8 @@ int qed_ll2_establish_connection(void *cxt, u8 connection_handle)
 	if (rc)
 		goto out;
 
-	if (!QED_IS_RDMA_PERSONALITY(p_hwfn))
+	if (!QED_IS_RDMA_PERSONALITY(p_hwfn) &&
+	    !QED_IS_NVMETCP_PERSONALITY(p_hwfn))
 		qed_wr(p_hwfn, p_ptt, PRS_REG_USE_LIGHT_L2, 1);
 
 	qed_ll2_establish_connection_ooo(p_hwfn, p_ll2_conn);
@@ -2376,7 +2380,8 @@ static int qed_ll2_start_ooo(struct qed_hwfn *p_hwfn,
 static bool qed_ll2_is_storage_eng1(struct qed_dev *cdev)
 {
 	return (QED_IS_FCOE_PERSONALITY(QED_LEADING_HWFN(cdev)) ||
-		QED_IS_ISCSI_PERSONALITY(QED_LEADING_HWFN(cdev))) &&
+		QED_IS_ISCSI_PERSONALITY(QED_LEADING_HWFN(cdev)) ||
+		QED_IS_NVMETCP_PERSONALITY(QED_LEADING_HWFN(cdev))) &&
 		(QED_AFFIN_HWFN(cdev) != QED_LEADING_HWFN(cdev));
 }
 
@@ -2402,11 +2407,13 @@ static int qed_ll2_stop(struct qed_dev *cdev)
 
 	if (cdev->ll2->handle == QED_LL2_UNUSED_HANDLE)
 		return 0;
+	if (!QED_IS_NVMETCP_PERSONALITY(p_hwfn))
+		qed_llh_remove_mac_filter(cdev, 0, cdev->ll2_mac_address);
 
 	qed_llh_remove_mac_filter(cdev, 0, cdev->ll2_mac_address);
 	eth_zero_addr(cdev->ll2_mac_address);
 
-	if (QED_IS_ISCSI_PERSONALITY(p_hwfn))
+	if (QED_IS_ISCSI_PERSONALITY(p_hwfn) || QED_IS_NVMETCP_PERSONALITY(p_hwfn))
 		qed_ll2_stop_ooo(p_hwfn);
 
 	/* In CMT mode, LL2 is always started on engine 0 for a storage PF */
@@ -2442,6 +2449,7 @@ static int __qed_ll2_start(struct qed_hwfn *p_hwfn,
 		conn_type = QED_LL2_TYPE_FCOE;
 		break;
 	case QED_PCI_ISCSI:
+	case QED_PCI_NVMETCP:
 		conn_type = QED_LL2_TYPE_ISCSI;
 		break;
 	case QED_PCI_ETH_ROCE:
@@ -2567,7 +2575,7 @@ static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
 		}
 	}
 
-	if (QED_IS_ISCSI_PERSONALITY(p_hwfn)) {
+	if (QED_IS_ISCSI_PERSONALITY(p_hwfn) || QED_IS_NVMETCP_PERSONALITY(p_hwfn)) {
 		DP_VERBOSE(cdev, QED_MSG_STORAGE, "Starting OOO LL2 queue\n");
 		rc = qed_ll2_start_ooo(p_hwfn, params);
 		if (rc) {
@@ -2576,10 +2584,13 @@ static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
 		}
 	}
 
-	rc = qed_llh_add_mac_filter(cdev, 0, params->ll2_mac_address);
-	if (rc) {
-		DP_NOTICE(cdev, "Failed to add an LLH filter\n");
-		goto err3;
+	if (!QED_IS_NVMETCP_PERSONALITY(p_hwfn)) {
+		rc = qed_llh_add_mac_filter(cdev, 0, params->ll2_mac_address);
+		if (rc) {
+			DP_NOTICE(cdev, "Failed to add an LLH filter\n");
+			goto err3;
+		}
+
 	}
 
 	ether_addr_copy(cdev->ll2_mac_address, params->ll2_mac_address);
@@ -2587,7 +2598,7 @@ static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
 	return 0;
 
 err3:
-	if (QED_IS_ISCSI_PERSONALITY(p_hwfn))
+	if (QED_IS_ISCSI_PERSONALITY(p_hwfn) || QED_IS_NVMETCP_PERSONALITY(p_hwfn))
 		qed_ll2_stop_ooo(p_hwfn);
 err2:
 	if (b_is_storage_eng1)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index cd882c453394..4387292c37e2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -2446,6 +2446,9 @@ qed_mcp_get_shmem_proto(struct qed_hwfn *p_hwfn,
 	case FUNC_MF_CFG_PROTOCOL_ISCSI:
 		*p_proto = QED_PCI_ISCSI;
 		break;
+	case FUNC_MF_CFG_PROTOCOL_NVMETCP:
+		*p_proto = QED_PCI_NVMETCP;
+		break;
 	case FUNC_MF_CFG_PROTOCOL_FCOE:
 		*p_proto = QED_PCI_FCOE;
 		break;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
index 3e3192a3ad9b..6190adf965bc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
@@ -1306,7 +1306,8 @@ int qed_mfw_process_tlv_req(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	}
 
 	if ((tlv_group & QED_MFW_TLV_ISCSI) &&
-	    p_hwfn->hw_info.personality != QED_PCI_ISCSI) {
+	    p_hwfn->hw_info.personality != QED_PCI_ISCSI &&
+		p_hwfn->hw_info.personality != QED_PCI_NVMETCP) {
 		DP_VERBOSE(p_hwfn, QED_MSG_SP,
 			   "Skipping iSCSI TLVs for non-iSCSI function\n");
 		tlv_group &= ~QED_MFW_TLV_ISCSI;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ooo.c b/drivers/net/ethernet/qlogic/qed/qed_ooo.c
index 88353aa404dc..d37bb2463f98 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ooo.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ooo.c
@@ -16,7 +16,7 @@
 #include "qed_ll2.h"
 #include "qed_ooo.h"
 #include "qed_cxt.h"
-
+#include "qed_nvmetcp.h"
 static struct qed_ooo_archipelago
 *qed_ooo_seek_archipelago(struct qed_hwfn *p_hwfn,
 			  struct qed_ooo_info
@@ -85,6 +85,9 @@ int qed_ooo_alloc(struct qed_hwfn *p_hwfn)
 	case QED_PCI_ISCSI:
 		proto = PROTOCOLID_ISCSI;
 		break;
+	case QED_PCI_NVMETCP:
+		proto = PROTOCOLID_NVMETCP;
+		break;
 	case QED_PCI_ETH_RDMA:
 	case QED_PCI_ETH_IWARP:
 		proto = PROTOCOLID_IWARP;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
index aa71adcf31ee..60b3876387a9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
@@ -385,6 +385,7 @@ int qed_sp_pf_start(struct qed_hwfn *p_hwfn,
 		p_ramrod->personality = PERSONALITY_FCOE;
 		break;
 	case QED_PCI_ISCSI:
+	case QED_PCI_NVMETCP:
 		p_ramrod->personality = PERSONALITY_ISCSI;
 		break;
 	case QED_PCI_ETH_ROCE:
-- 
2.22.0

