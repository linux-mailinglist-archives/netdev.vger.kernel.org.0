Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C25E388C80
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 13:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348544AbhESLRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 07:17:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55034 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1346088AbhESLRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 07:17:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JB9dlt020130;
        Wed, 19 May 2021 04:15:14 -0700
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38mqc1hyt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:15:14 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 May
 2021 04:15:13 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 19 May 2021 04:15:09 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>,
        "Dean Balandin" <dbalandin@marvell.com>
Subject: [RFC PATCH v5 10/27] qed: Add NVMeTCP Offload PF Level FW and HW HSI
Date:   Wed, 19 May 2021 14:13:23 +0300
Message-ID: <20210519111340.20613-11-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210519111340.20613-1-smalin@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: LTX_8PWanu4hCjXHv20sJ-z5vfbis_1w
X-Proofpoint-ORIG-GUID: LTX_8PWanu4hCjXHv20sJ-z5vfbis_1w
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_04:2021-05-19,2021-05-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the NVMeTCP device and PF level HSI and HSI
functionality in order to initialize and interact with the HW device.
The patch also adds qed NVMeTCP personality.

This patch is based on the qede, qedr, qedi, qedf drivers HSI.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dean Balandin <dbalandin@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/Kconfig           |   3 +
 drivers/net/ethernet/qlogic/qed/Makefile      |   2 +
 drivers/net/ethernet/qlogic/qed/qed.h         |   5 +
 drivers/net/ethernet/qlogic/qed/qed_cxt.c     |  26 ++
 drivers/net/ethernet/qlogic/qed/qed_dev.c     |  48 ++-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c     |  32 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     |   3 +
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c |   3 +-
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c | 282 ++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h |  51 ++++
 drivers/net/ethernet/qlogic/qed/qed_ooo.c     |   3 +-
 drivers/net/ethernet/qlogic/qed/qed_sp.h      |   2 +
 .../net/ethernet/qlogic/qed/qed_sp_commands.c |   1 +
 include/linux/qed/nvmetcp_common.h            |  54 ++++
 include/linux/qed/qed_if.h                    |  22 ++
 include/linux/qed/qed_nvmetcp_if.h            |  72 +++++
 17 files changed, 593 insertions(+), 20 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
 create mode 100644 include/linux/qed/nvmetcp_common.h
 create mode 100644 include/linux/qed/qed_nvmetcp_if.h

diff --git a/drivers/net/ethernet/qlogic/Kconfig b/drivers/net/ethernet/qlogic/Kconfig
index 6b5ddb07ee83..98f430905ffa 100644
--- a/drivers/net/ethernet/qlogic/Kconfig
+++ b/drivers/net/ethernet/qlogic/Kconfig
@@ -110,6 +110,9 @@ config QED_RDMA
 config QED_ISCSI
 	bool
 
+config QED_NVMETCP
+	bool
+
 config QED_FCOE
 	bool
 
diff --git a/drivers/net/ethernet/qlogic/qed/Makefile b/drivers/net/ethernet/qlogic/qed/Makefile
index 8251755ec18c..7cb0db67ba5b 100644
--- a/drivers/net/ethernet/qlogic/qed/Makefile
+++ b/drivers/net/ethernet/qlogic/qed/Makefile
@@ -28,6 +28,8 @@ qed-$(CONFIG_QED_ISCSI) += qed_iscsi.o
 qed-$(CONFIG_QED_LL2) += qed_ll2.o
 qed-$(CONFIG_QED_OOO) += qed_ooo.o
 
+qed-$(CONFIG_QED_NVMETCP) += qed_nvmetcp.o
+
 qed-$(CONFIG_QED_RDMA) +=	\
 	qed_iwarp.o		\
 	qed_rdma.o		\
diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index deba23068c3a..bc9bdb9d1bb9 100644
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
@@ -593,6 +596,7 @@ struct qed_hwfn {
 	struct qed_ooo_info		*p_ooo_info;
 	struct qed_rdma_info		*p_rdma_info;
 	struct qed_iscsi_info		*p_iscsi_info;
+	struct qed_nvmetcp_info		*p_nvmetcp_info;
 	struct qed_fcoe_info		*p_fcoe_info;
 	struct qed_pf_params		pf_params;
 
@@ -829,6 +833,7 @@ struct qed_dev {
 		struct qed_eth_cb_ops		*eth;
 		struct qed_fcoe_cb_ops		*fcoe;
 		struct qed_iscsi_cb_ops		*iscsi;
+		struct qed_nvmetcp_cb_ops	*nvmetcp;
 	} protocol_ops;
 	void				*ops_cookie;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index fcabbaa518df..8080bf433493 100644
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
+						    PROTOCOLID_TCP_ULP,
+						    p_params->num_cons,
+						    0);
+
+			qed_cxt_set_proto_tid_count(p_hwfn,
+						    PROTOCOLID_TCP_ULP,
+						    QED_CXT_TCP_ULP_TID_SEG,
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
@@ -2129,6 +2153,7 @@ int qed_cxt_get_tid_mem_info(struct qed_hwfn *p_hwfn,
 		seg = QED_CXT_FCOE_TID_SEG;
 		break;
 	case QED_PCI_ISCSI:
+	case QED_PCI_NVMETCP:
 		proto = PROTOCOLID_TCP_ULP;
 		seg = QED_CXT_TCP_ULP_TID_SEG;
 		break;
@@ -2455,6 +2480,7 @@ int qed_cxt_get_task_ctx(struct qed_hwfn *p_hwfn,
 		seg = QED_CXT_FCOE_TID_SEG;
 		break;
 	case QED_PCI_ISCSI:
+	case QED_PCI_NVMETCP:
 		proto = PROTOCOLID_TCP_ULP;
 		seg = QED_CXT_TCP_ULP_TID_SEG;
 		break;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index c231d0e56571..932b892f1ef1 100644
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
@@ -2263,7 +2274,8 @@ int qed_resc_alloc(struct qed_dev *cdev)
 			 * at the same time
 			 */
 			n_eqes += num_cons + 2 * MAX_NUM_VFS_BB + n_srq;
-		} else if (p_hwfn->hw_info.personality == QED_PCI_ISCSI) {
+		} else if (p_hwfn->hw_info.personality == QED_PCI_ISCSI ||
+			   p_hwfn->hw_info.personality == QED_PCI_NVMETCP) {
 			num_cons =
 			    qed_cxt_get_proto_cid_count(p_hwfn,
 							PROTOCOLID_TCP_ULP,
@@ -2313,6 +2325,15 @@ int qed_resc_alloc(struct qed_dev *cdev)
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
@@ -2393,6 +2414,11 @@ void qed_resc_setup(struct qed_dev *cdev)
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
 
@@ -2854,7 +2880,8 @@ static int qed_hw_init_pf(struct qed_hwfn *p_hwfn,
 
 	/* Protocol Configuration */
 	STORE_RT_REG(p_hwfn, PRS_REG_SEARCH_TCP_RT_OFFSET,
-		     (p_hwfn->hw_info.personality == QED_PCI_ISCSI) ? 1 : 0);
+		     ((p_hwfn->hw_info.personality == QED_PCI_ISCSI) ||
+			 (p_hwfn->hw_info.personality == QED_PCI_NVMETCP)) ? 1 : 0);
 	STORE_RT_REG(p_hwfn, PRS_REG_SEARCH_FCOE_RT_OFFSET,
 		     (p_hwfn->hw_info.personality == QED_PCI_FCOE) ? 1 : 0);
 	STORE_RT_REG(p_hwfn, PRS_REG_SEARCH_ROCE_RT_OFFSET, 0);
@@ -3535,14 +3562,21 @@ static void qed_hw_set_feat(struct qed_hwfn *p_hwfn)
 		feat_num[QED_ISCSI_CQ] = min_t(u32, sb_cnt.cnt,
 					       RESC_NUM(p_hwfn,
 							QED_CMDQS_CQS));
+
+	if (QED_IS_NVMETCP_PERSONALITY(p_hwfn))
+		feat_num[QED_NVMETCP_CQ] = min_t(u32, sb_cnt.cnt,
+						 RESC_NUM(p_hwfn,
+							  QED_CMDQS_CQS));
+
 	DP_VERBOSE(p_hwfn,
 		   NETIF_MSG_PROBE,
-		   "#PF_L2_QUEUES=%d VF_L2_QUEUES=%d #ROCE_CNQ=%d FCOE_CQ=%d ISCSI_CQ=%d #SBS=%d\n",
+		   "#PF_L2_QUEUES=%d VF_L2_QUEUES=%d #ROCE_CNQ=%d FCOE_CQ=%d ISCSI_CQ=%d NVMETCP_CQ=%d #SBS=%d\n",
 		   (int)FEAT_NUM(p_hwfn, QED_PF_L2_QUE),
 		   (int)FEAT_NUM(p_hwfn, QED_VF_L2_QUE),
 		   (int)FEAT_NUM(p_hwfn, QED_RDMA_CNQ),
 		   (int)FEAT_NUM(p_hwfn, QED_FCOE_CQ),
 		   (int)FEAT_NUM(p_hwfn, QED_ISCSI_CQ),
+		   (int)FEAT_NUM(p_hwfn, QED_NVMETCP_CQ),
 		   (int)sb_cnt.cnt);
 }
 
@@ -3734,7 +3768,8 @@ int qed_hw_get_dflt_resc(struct qed_hwfn *p_hwfn,
 		break;
 	case QED_BDQ:
 		if (p_hwfn->hw_info.personality != QED_PCI_ISCSI &&
-		    p_hwfn->hw_info.personality != QED_PCI_FCOE)
+		    p_hwfn->hw_info.personality != QED_PCI_FCOE &&
+			p_hwfn->hw_info.personality != QED_PCI_NVMETCP)
 			*p_resc_num = 0;
 		else
 			*p_resc_num = 1;
@@ -3755,7 +3790,8 @@ int qed_hw_get_dflt_resc(struct qed_hwfn *p_hwfn,
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
index 9dbeb2efdc51..fb1baa2da2d0 100644
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
@@ -12147,7 +12148,8 @@ struct public_func {
 #define FUNC_MF_CFG_PROTOCOL_ISCSI              0x00000010
 #define FUNC_MF_CFG_PROTOCOL_FCOE               0x00000020
 #define FUNC_MF_CFG_PROTOCOL_ROCE               0x00000030
-#define FUNC_MF_CFG_PROTOCOL_MAX	0x00000030
+#define FUNC_MF_CFG_PROTOCOL_NVMETCP    0x00000040
+#define FUNC_MF_CFG_PROTOCOL_MAX	0x00000040
 
 #define FUNC_MF_CFG_MIN_BW_MASK		0x0000ff00
 #define FUNC_MF_CFG_MIN_BW_SHIFT	8
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 286e53927866..02a4610d9330 100644
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
@@ -1047,7 +1048,8 @@ static int qed_sp_ll2_tx_queue_start(struct qed_hwfn *p_hwfn,
 		p_ramrod->conn_type = PROTOCOLID_IWARP;
 		break;
 	case QED_LL2_TYPE_OOO:
-		if (p_hwfn->hw_info.personality == QED_PCI_ISCSI)
+		if (p_hwfn->hw_info.personality == QED_PCI_ISCSI ||
+		    p_hwfn->hw_info.personality == QED_PCI_NVMETCP)
 			p_ramrod->conn_type = PROTOCOLID_TCP_ULP;
 		else
 			p_ramrod->conn_type = PROTOCOLID_IWARP;
@@ -1634,7 +1636,8 @@ int qed_ll2_establish_connection(void *cxt, u8 connection_handle)
 	if (rc)
 		goto out;
 
-	if (!QED_IS_RDMA_PERSONALITY(p_hwfn))
+	if (!QED_IS_RDMA_PERSONALITY(p_hwfn) &&
+	    !QED_IS_NVMETCP_PERSONALITY(p_hwfn))
 		qed_wr(p_hwfn, p_ptt, PRS_REG_USE_LIGHT_L2, 1);
 
 	qed_ll2_establish_connection_ooo(p_hwfn, p_ll2_conn);
@@ -2376,7 +2379,8 @@ static int qed_ll2_start_ooo(struct qed_hwfn *p_hwfn,
 static bool qed_ll2_is_storage_eng1(struct qed_dev *cdev)
 {
 	return (QED_IS_FCOE_PERSONALITY(QED_LEADING_HWFN(cdev)) ||
-		QED_IS_ISCSI_PERSONALITY(QED_LEADING_HWFN(cdev))) &&
+		QED_IS_ISCSI_PERSONALITY(QED_LEADING_HWFN(cdev)) ||
+		QED_IS_NVMETCP_PERSONALITY(QED_LEADING_HWFN(cdev))) &&
 		(QED_AFFIN_HWFN(cdev) != QED_LEADING_HWFN(cdev));
 }
 
@@ -2402,11 +2406,13 @@ static int qed_ll2_stop(struct qed_dev *cdev)
 
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
@@ -2442,6 +2448,7 @@ static int __qed_ll2_start(struct qed_hwfn *p_hwfn,
 		conn_type = QED_LL2_TYPE_FCOE;
 		break;
 	case QED_PCI_ISCSI:
+	case QED_PCI_NVMETCP:
 		conn_type = QED_LL2_TYPE_TCP_ULP;
 		break;
 	case QED_PCI_ETH_ROCE:
@@ -2567,7 +2574,7 @@ static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
 		}
 	}
 
-	if (QED_IS_ISCSI_PERSONALITY(p_hwfn)) {
+	if (QED_IS_ISCSI_PERSONALITY(p_hwfn) || QED_IS_NVMETCP_PERSONALITY(p_hwfn)) {
 		DP_VERBOSE(cdev, QED_MSG_STORAGE, "Starting OOO LL2 queue\n");
 		rc = qed_ll2_start_ooo(p_hwfn, params);
 		if (rc) {
@@ -2576,10 +2583,13 @@ static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
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
@@ -2587,7 +2597,7 @@ static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
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
diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
new file mode 100644
index 000000000000..001d6247d22c
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
@@ -0,0 +1,282 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+/* Copyright 2021 Marvell. All rights reserved. */
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+#include <asm/param.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/etherdevice.h>
+#include <linux/kernel.h>
+#include <linux/log2.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/stddef.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/list.h>
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
+
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
+	struct qed_nvmetcp_pf_params *p_params = NULL;
+	struct scsi_init_func_queues *p_queue = NULL;
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
+				 PROTOCOLID_TCP_ULP, &init_data);
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
+	SET_FIELD(p_init->flags, NVMETCP_SPE_FUNC_INIT_NVMETCP_MODE, 1);
+
+	p_init->func_params.log_page_size = ilog2(PAGE_SIZE);
+	p_init->func_params.num_tasks = cpu_to_le16(p_params->num_tasks);
+	p_init->debug_flags = p_params->debug_mode;
+
+	DMA_REGPAIR_LE(p_queue->glbl_q_params_addr,
+		       p_params->glbl_q_params_addr);
+
+	p_queue->cq_num_entries = cpu_to_le16(QED_NVMETCP_FW_CQ_SIZE);
+	p_queue->num_queues = p_params->num_queues;
+	val = RESC_START(p_hwfn, QED_CMDQS_CQS);
+	p_queue->queue_relative_offset = cpu_to_le16((u16)val);
+	p_queue->cq_sb_pi = p_params->gl_rq_pi;
+
+	for (i = 0; i < p_params->num_queues; i++) {
+		val = qed_get_igu_sb_id(p_hwfn, i);
+		p_queue->cq_cmdq_sb_num_arr[i] = cpu_to_le16(val);
+	}
+
+	SET_FIELD(p_queue->q_validity,
+		  SCSI_INIT_FUNC_QUEUES_CMD_VALID, 0);
+	p_queue->cmdq_num_entries = 0;
+	p_queue->bdq_resource_id = (u8)RESC_START(p_hwfn, QED_BDQ);
+
+	/* p_ramrod->tcp_init.min_rto = cpu_to_le16(p_params->min_rto); */
+	p_ramrod->tcp_init.two_msl_timer = cpu_to_le32(QED_TCP_TWO_MSL_TIMER);
+	p_ramrod->tcp_init.tx_sws_timer = cpu_to_le16(QED_TCP_SWS_TIMER);
+	p_init->half_way_close_timeout = cpu_to_le16(QED_TCP_HALF_WAY_CLOSE_TIMEOUT);
+	p_ramrod->tcp_init.max_fin_rt = QED_TCP_MAX_FIN_RT;
+
+	SET_FIELD(p_ramrod->nvmetcp_init_spe.params,
+		  NVMETCP_SPE_FUNC_INIT_MAX_SYN_RT, QED_TCP_MAX_FIN_RT);
+
+	p_hwfn->p_nvmetcp_info->event_context = event_context;
+	p_hwfn->p_nvmetcp_info->event_cb = async_event_cb;
+
+	qed_spq_register_async_cb(p_hwfn, PROTOCOLID_TCP_ULP,
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
+	int rc;
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
+				 PROTOCOLID_TCP_ULP, &init_data);
+	if (rc)
+		return rc;
+
+	rc = qed_spq_post(p_hwfn, p_ent, NULL);
+
+	qed_spq_unregister_async_cb(p_hwfn, PROTOCOLID_TCP_ULP);
+
+	return rc;
+}
+
+static int qed_fill_nvmetcp_dev_info(struct qed_dev *cdev,
+				     struct qed_dev_nvmetcp_info *info)
+{
+	struct qed_hwfn *hwfn = QED_AFFIN_HWFN(cdev);
+	int rc;
+
+	memset(info, 0, sizeof(*info));
+	rc = qed_fill_dev_info(cdev, &info->common);
+
+	info->port_id = MFW_PORT(hwfn);
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
+
+		return 0;
+	}
+
+	if (!hash_empty(cdev->connections)) {
+		DP_NOTICE(cdev,
+			  "Can't stop nvmetcp - not all connections were returned\n");
+
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
+
+		return 0;
+	}
+
+	rc = qed_sp_nvmetcp_func_start(QED_AFFIN_HWFN(cdev),
+				       QED_SPQ_MODE_EBLOCK, NULL,
+				       event_context, async_event_cb);
+	if (rc) {
+		DP_NOTICE(cdev, "Failed to start nvmetcp\n");
+
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
+
+		return -ENOMEM;
+	}
+
+	rc = qed_cxt_get_tid_mem_info(QED_AFFIN_HWFN(cdev), tid_info);
+	if (rc) {
+		DP_NOTICE(cdev, "Failed to gather task information\n");
+		qed_nvmetcp_stop(cdev);
+		kfree(tid_info);
+
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
index 000000000000..774b46ade408
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+/* Copyright 2021 Marvell. All rights reserved. */
+
+#ifndef _QED_NVMETCP_H
+#define _QED_NVMETCP_H
+
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
+#define QED_NVMETCP_FW_CQ_SIZE (4 * 1024)
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
+int qed_nvmetcp_alloc(struct qed_hwfn *p_hwfn);
+void qed_nvmetcp_setup(struct qed_hwfn *p_hwfn);
+void qed_nvmetcp_free(struct qed_hwfn *p_hwfn);
+
+#else /* IS_ENABLED(CONFIG_QED_NVMETCP) */
+static inline int qed_nvmetcp_alloc(struct qed_hwfn *p_hwfn)
+{
+	return -EINVAL;
+}
+
+static inline void qed_nvmetcp_setup(struct qed_hwfn *p_hwfn) {}
+static inline void qed_nvmetcp_free(struct qed_hwfn *p_hwfn) {}
+
+#endif /* IS_ENABLED(CONFIG_QED_NVMETCP) */
+
+#endif
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ooo.c b/drivers/net/ethernet/qlogic/qed/qed_ooo.c
index 599da0d7366b..b8c5641b29a8 100644
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
@@ -83,6 +83,7 @@ int qed_ooo_alloc(struct qed_hwfn *p_hwfn)
 
 	switch (p_hwfn->hw_info.personality) {
 	case QED_PCI_ISCSI:
+	case QED_PCI_NVMETCP:
 		proto = PROTOCOLID_TCP_ULP;
 		break;
 	case QED_PCI_ETH_RDMA:
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
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
index ee7dc0a7da6c..b4ed54ffef9b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
@@ -385,6 +385,7 @@ int qed_sp_pf_start(struct qed_hwfn *p_hwfn,
 		p_ramrod->personality = PERSONALITY_FCOE;
 		break;
 	case QED_PCI_ISCSI:
+	case QED_PCI_NVMETCP:
 		p_ramrod->personality = PERSONALITY_TCP_ULP;
 		break;
 	case QED_PCI_ETH_ROCE:
diff --git a/include/linux/qed/nvmetcp_common.h b/include/linux/qed/nvmetcp_common.h
new file mode 100644
index 000000000000..e9ccfc07041d
--- /dev/null
+++ b/include/linux/qed/nvmetcp_common.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+/* Copyright 2021 Marvell. All rights reserved. */
+
+#ifndef __NVMETCP_COMMON__
+#define __NVMETCP_COMMON__
+
+#include "tcp_common.h"
+
+/* NVMeTCP firmware function init parameters */
+struct nvmetcp_spe_func_init {
+	__le16 half_way_close_timeout;
+	u8 num_sq_pages_in_ring;
+	u8 num_r2tq_pages_in_ring;
+	u8 num_uhq_pages_in_ring;
+	u8 ll2_rx_queue_id;
+	u8 flags;
+#define NVMETCP_SPE_FUNC_INIT_COUNTERS_EN_MASK 0x1
+#define NVMETCP_SPE_FUNC_INIT_COUNTERS_EN_SHIFT 0
+#define NVMETCP_SPE_FUNC_INIT_NVMETCP_MODE_MASK 0x1
+#define NVMETCP_SPE_FUNC_INIT_NVMETCP_MODE_SHIFT 1
+#define NVMETCP_SPE_FUNC_INIT_RESERVED0_MASK 0x3F
+#define NVMETCP_SPE_FUNC_INIT_RESERVED0_SHIFT 2
+	u8 debug_flags;
+	__le16 reserved1;
+	u8 params;
+#define NVMETCP_SPE_FUNC_INIT_MAX_SYN_RT_MASK	0xF
+#define NVMETCP_SPE_FUNC_INIT_MAX_SYN_RT_SHIFT	0
+#define NVMETCP_SPE_FUNC_INIT_RESERVED1_MASK	0xF
+#define NVMETCP_SPE_FUNC_INIT_RESERVED1_SHIFT	4
+	u8 reserved2[5];
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
+struct nvmetcp_glbl_queue_entry {
+	struct regpair cq_pbl_addr;
+	struct regpair reserved;
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
index 000000000000..abc1f41862e3
--- /dev/null
+++ b/include/linux/qed/qed_nvmetcp_if.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+/* Copyright 2021 Marvell. All rights reserved. */
+
+#ifndef _QED_NVMETCP_IF_H
+#define _QED_NVMETCP_IF_H
+#include <linux/types.h>
+#include <linux/qed/qed_if.h>
+
+#define QED_NVMETCP_MAX_IO_SIZE	0x800000
+
+typedef int (*nvmetcp_event_cb_t) (void *context,
+				   u8 fw_event_code, void *fw_handle);
+
+struct qed_dev_nvmetcp_info {
+	struct qed_dev_info common;
+
+	u8 port_id;  /* Physical port */
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

