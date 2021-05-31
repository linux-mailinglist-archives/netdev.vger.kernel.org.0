Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292283969E9
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 00:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhEaW7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 18:59:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56750 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231859AbhEaW7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 18:59:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VMoNbh001273;
        Mon, 31 May 2021 15:55:15 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38vtnja4qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 15:55:15 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 15:55:12 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 31 May 2021 15:55:09 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <smalin@marvell.com>
Subject: [RFC PATCH v7 21/27] qedn: Add support of configuring HW filter block
Date:   Tue, 1 Jun 2021 01:52:16 +0300
Message-ID: <20210531225222.16992-22-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210531225222.16992-1-smalin@marvell.com>
References: <20210531225222.16992-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 0GcxVDPYcDqez6RBboLnbEUnMN8jWBLb
X-Proofpoint-ORIG-GUID: 0GcxVDPYcDqez6RBboLnbEUnMN8jWBLb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_15:2021-05-31,2021-05-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prabhakar Kushwaha <pkushwaha@marvell.com>

HW filter can be configured to filter TCP packets based on either
source or target TCP port. QEDN leverage this feature to route
NVMeTCP traffic.

This patch configures HW filter block based on source port for all
receiving packets to deliver correct QEDN PF.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/hw/qedn/qedn.h      |  15 +++++
 drivers/nvme/hw/qedn/qedn_main.c | 108 ++++++++++++++++++++++++++++++-
 2 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
index 0b1bd1ae2b0b..5994b30e9b6e 100644
--- a/drivers/nvme/hw/qedn/qedn.h
+++ b/drivers/nvme/hw/qedn/qedn.h
@@ -29,6 +29,11 @@
 #define QEDN_IRQ_NAME_LEN 24
 #define QEDN_IRQ_NO_FLAGS 0
 
+/* HW defines */
+
+/* QEDN_MAX_LLH_PORTS will be extended in future */
+#define QEDN_MAX_LLH_PORTS 16
+
 /* Destroy connection defines */
 #define QEDN_NON_ABORTIVE_TERMINATION 0
 #define QEDN_ABORTIVE_TERMINATION 1
@@ -68,6 +73,7 @@
 enum qedn_state {
 	QEDN_STATE_CORE_PROBED = 0,
 	QEDN_STATE_CORE_OPEN,
+	QEDN_STATE_LLH_PORT_FILTER_SET,
 	QEDN_STATE_MFW_STATE,
 	QEDN_STATE_NVMETCP_OPEN,
 	QEDN_STATE_IRQ_SET,
@@ -99,6 +105,8 @@ struct qedn_ctx {
 	/* Accessed with atomic bit ops, used with enum qedn_state */
 	unsigned long state;
 
+	u8 num_llh_filters;
+	struct list_head llh_filter_list;
 	u8 local_mac_addr[ETH_ALEN];
 	u16 mtu;
 
@@ -165,6 +173,12 @@ enum qedn_conn_state {
 	CONN_STATE_DESTROY_COMPLETE
 };
 
+struct qedn_llh_filter {
+	struct list_head entry;
+	u16 port;
+	u16 ref_cnt;
+};
+
 struct qedn_ctrl {
 	struct list_head glb_entry;
 	struct list_head pf_entry;
@@ -248,5 +262,6 @@ int qedn_wait_for_conn_est(struct qedn_conn_ctx *conn_ctx);
 int qedn_set_con_state(struct qedn_conn_ctx *conn_ctx, enum qedn_conn_state new_state);
 void qedn_terminate_connection(struct qedn_conn_ctx *conn_ctx);
 void qedn_cleanp_fw(struct qedn_conn_ctx *conn_ctx);
+__be16 qedn_get_in_port(struct sockaddr_storage *sa);
 
 #endif /* _QEDN_H_ */
diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qedn_main.c
index 2e82f3ef62f5..da37a801859f 100644
--- a/drivers/nvme/hw/qedn/qedn_main.c
+++ b/drivers/nvme/hw/qedn/qedn_main.c
@@ -22,6 +22,81 @@ static struct pci_device_id qedn_pci_tbl[] = {
 	{0, 0},
 };
 
+__be16 qedn_get_in_port(struct sockaddr_storage *sa)
+{
+	return sa->ss_family == AF_INET
+		? ((struct sockaddr_in *)sa)->sin_port
+		: ((struct sockaddr_in6 *)sa)->sin6_port;
+}
+
+struct qedn_llh_filter *qedn_add_llh_filter(struct qedn_ctx *qedn, u16 tcp_port)
+{
+	struct qedn_llh_filter *llh_filter = NULL;
+	struct qedn_llh_filter *llh_tmp = NULL;
+	bool new_filter = 1;
+	int rc = 0;
+
+	/* Check if LLH filter already defined */
+	list_for_each_entry_safe(llh_filter, llh_tmp, &qedn->llh_filter_list, entry) {
+		if (llh_filter->port == tcp_port) {
+			new_filter = 0;
+			llh_filter->ref_cnt++;
+			break;
+		}
+	}
+
+	if (new_filter) {
+		if (qedn->num_llh_filters >= QEDN_MAX_LLH_PORTS) {
+			pr_err("PF reached the max target ports limit %u. %u\n",
+			       qedn->dev_info.common.abs_pf_id,
+			       qedn->num_llh_filters);
+
+			return NULL;
+		}
+
+		rc = qed_ops->add_src_tcp_port_filter(qedn->cdev, tcp_port);
+		if (rc) {
+			pr_err("LLH port configuration failed. port:%u; rc:%u\n", tcp_port, rc);
+
+			return NULL;
+		}
+
+		llh_filter = kzalloc(sizeof(*llh_filter), GFP_KERNEL);
+		if (!llh_filter) {
+			qed_ops->remove_src_tcp_port_filter(qedn->cdev, tcp_port);
+
+			return NULL;
+		}
+
+		llh_filter->port = tcp_port;
+		llh_filter->ref_cnt = 1;
+		++qedn->num_llh_filters;
+		list_add_tail(&llh_filter->entry, &qedn->llh_filter_list);
+		set_bit(QEDN_STATE_LLH_PORT_FILTER_SET, &qedn->state);
+	}
+
+	return llh_filter;
+}
+
+void qedn_dec_llh_filter(struct qedn_ctx *qedn, struct qedn_llh_filter *llh_filter)
+{
+	if (!llh_filter)
+		return;
+
+	llh_filter->ref_cnt--;
+	if (!llh_filter->ref_cnt) {
+		list_del(&llh_filter->entry);
+
+		/* Remove LLH protocol port filter */
+		qed_ops->remove_src_tcp_port_filter(qedn->cdev, llh_filter->port);
+
+		--qedn->num_llh_filters;
+		kfree(llh_filter);
+		if (!qedn->num_llh_filters)
+			clear_bit(QEDN_STATE_LLH_PORT_FILTER_SET, &qedn->state);
+	}
+}
+
 static bool qedn_matches_qede(struct qedn_ctx *qedn, struct pci_dev *qede_pdev)
 {
 	struct pci_dev *qedn_pdev = qedn->pdev;
@@ -103,8 +178,10 @@ qedn_claim_dev(struct nvme_tcp_ofld_dev *dev,
 static int qedn_setup_ctrl(struct nvme_tcp_ofld_ctrl *ctrl)
 {
 	struct nvme_tcp_ofld_dev *dev = ctrl->dev;
+	struct qedn_llh_filter *llh_filter = NULL;
 	struct qedn_ctrl *qctrl = NULL;
 	struct qedn_ctx *qedn = NULL;
+	__be16 remote_port;
 	bool new = true;
 	int rc = 0;
 
@@ -142,7 +219,22 @@ static int qedn_setup_ctrl(struct nvme_tcp_ofld_ctrl *ctrl)
 	qedn = container_of(dev, struct qedn_ctx, qedn_ofld_dev);
 	qctrl->qedn = qedn;
 
-	/* Placeholder - setup LLH filter */
+	if (qedn->num_llh_filters == 0) {
+		qedn->mtu = dev->ndev->mtu;
+		memcpy(qedn->local_mac_addr, dev->ndev->dev_addr, ETH_ALEN);
+	}
+
+	remote_port = qedn_get_in_port(&ctrl->conn_params.remote_ip_addr);
+	if (new) {
+		llh_filter = qedn_add_llh_filter(qedn, ntohs(remote_port));
+		if (!llh_filter) {
+			rc = -EFAULT;
+			goto err_out;
+		}
+
+		qctrl->llh_filter = llh_filter;
+		set_bit(LLH_FILTER, &qctrl->agg_state);
+	}
 
 	return 0;
 err_out:
@@ -160,6 +252,12 @@ static int qedn_release_ctrl(struct nvme_tcp_ofld_ctrl *ctrl)
 	if (!qctrl)
 		return -ENODEV;
 
+	if (test_and_clear_bit(LLH_FILTER, &qctrl->agg_state) &&
+	    qctrl->llh_filter) {
+		qedn_dec_llh_filter(qctrl->qedn, qctrl->llh_filter);
+		qctrl->llh_filter = NULL;
+	}
+
 	if (test_and_clear_bit(QEDN_STATE_SP_WORK_THREAD_SET, &qctrl->agg_state))
 		flush_workqueue(qctrl->sp_wq);
 
@@ -440,6 +538,8 @@ static int qedn_setup_irq(struct qedn_ctx *qedn)
 
 static inline void qedn_init_pf_struct(struct qedn_ctx *qedn)
 {
+	INIT_LIST_HEAD(&qedn->llh_filter_list);
+	qedn->num_llh_filters = 0;
 	hash_init(qedn->conn_ctx_hash);
 }
 
@@ -681,6 +781,12 @@ static void __qedn_remove(struct pci_dev *pdev)
 		return;
 	}
 
+	if (test_and_clear_bit(QEDN_STATE_LLH_PORT_FILTER_SET, &qedn->state)) {
+		pr_err("LLH port configuration removal. %d filters still set\n",
+		       qedn->num_llh_filters);
+		qed_ops->clear_all_filters(qedn->cdev);
+	}
+
 	if (test_and_clear_bit(QEDN_STATE_REGISTERED_OFFLOAD_DEV, &qedn->state))
 		nvme_tcp_ofld_unregister_dev(&qedn->qedn_ofld_dev);
 
-- 
2.22.0

