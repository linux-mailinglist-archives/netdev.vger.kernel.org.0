Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A70B106B7
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 11:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfEAJ6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 05:58:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34386 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726451AbfEAJ6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 05:58:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x419v8jE015954;
        Wed, 1 May 2019 02:58:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Dp0p3uZNyqjonO/w5jqWfVSqLg2rdErpgwVkSDGFm3E=;
 b=KSTYHVTxWr30EqPocxaJeuliFJNAmUAhJYcQUcLPWZE6iaLphDJhLolsXo6s0PEEgTid
 FDZovFCkgMNZuZPasgRT0WsoEwS8lcqcWuquKNgq9pg33vmDk7oiGpbqQPvMQguFqgvQ
 wnnubJihtnQ+Xw665NqneLQHegNdOpeHJ4cl5C5tMxupXV4wjD1E3LQUh92MTFb90Jea
 E2dcV2UclIBjP1q6FxuvXPcT6DnKx6m/uqYfi0tt9X+0vDPfg5am1XsPQEb+SFUqiZN2
 XSaWPqITRsGPCv8gXW0kAXPnXpdYAc7ymT8P8VhePxUHGy+4AFIssMmWWylTLBDqSfPk /g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2s6xgchwav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 May 2019 02:58:47 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 1 May
 2019 02:58:45 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 1 May 2019 02:58:45 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id D1DE33F7040;
        Wed,  1 May 2019 02:58:43 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <jgg@ziepe.ca>, <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH net-next 07/10] qed*: Add iWARP 100g support
Date:   Wed, 1 May 2019 12:57:19 +0300
Message-ID: <20190501095722.6902-8-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501095722.6902-1-michal.kalderon@marvell.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-01_04:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add iWARP engine affinity setting for supporting iWARP over 100g.
iWARP cannot be distinguished by the LLH from L2, hence the
engine division will affect L2 as well. For this reason we add
a module parameter in qedr that enables the engine division.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/main.c          | 22 ++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 27 +++++++++++++++++++++++++++
 include/linux/qed/qed_rdma_if.h            |  2 ++
 3 files changed, 51 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index d93c8a893a89..8bc6775abb79 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -52,6 +52,10 @@ MODULE_DESCRIPTION("QLogic 40G/100G ROCE Driver");
 MODULE_AUTHOR("QLogic Corporation");
 MODULE_LICENSE("Dual BSD/GPL");
 
+static uint iwarp_cmt;
+module_param(iwarp_cmt, uint, 0444);
+MODULE_PARM_DESC(iwarp_cmt, " iWARP: Support CMT mode. 0 - Disabled, 1 - Enabled. Default: Disabled");
+
 #define QEDR_WQ_MULTIPLIER_DFT	(3)
 
 static void qedr_ib_dispatch_event(struct qedr_dev *dev, u8 port_num,
@@ -886,7 +890,21 @@ static struct qedr_dev *qedr_add(struct qed_dev *cdev, struct pci_dev *pdev,
 	dev->user_dpm_enabled = dev_info.user_dpm_enabled;
 	dev->rdma_type = dev_info.rdma_type;
 	dev->num_hwfns = dev_info.common.num_hwfns;
+
+	if (IS_IWARP(dev) && QEDR_IS_CMT(dev)) {
+		if (!iwarp_cmt) {
+			DP_ERR(dev,
+			       "By default, iWARP is not supported over a 100G device. Can use the \"iwarp_cmt\" module parameter to enable it.\n");
+			rc = -EINVAL;
+			goto init_err;
+		}
+
+		rc = dev->ops->iwarp_set_engine_affin(cdev, false /* !reset */);
+		if (rc)
+			goto init_err;
+	}
 	dev->affin_hwfn_idx = dev->ops->common->get_affin_hwfn_idx(cdev);
+
 	dev->rdma_ctx = dev->ops->rdma_get_rdma_ctx(cdev);
 
 	dev->num_cnq = dev->ops->rdma_get_min_cnq_msix(cdev);
@@ -947,6 +965,10 @@ static void qedr_remove(struct qedr_dev *dev)
 	qedr_stop_hw(dev);
 	qedr_sync_free_irqs(dev);
 	qedr_free_resources(dev);
+
+	if (IS_IWARP(dev) && QEDR_IS_CMT(dev) && iwarp_cmt)
+		dev->ops->iwarp_set_engine_affin(dev->cdev, true /* reset */);
+
 	ib_dealloc_device(&dev->ibdev);
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index e4d63359864e..1bcbb4ceeb2e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1916,6 +1916,32 @@ static int qed_roce_ll2_set_mac_filter(struct qed_dev *cdev,
 	return rc;
 }
 
+static int qed_iwarp_set_engine_affin(struct qed_dev *cdev, bool b_reset)
+{
+	enum qed_eng eng;
+	u8 ppfid = 0;
+	int rc;
+
+	if (b_reset)
+		eng = QED_BOTH_ENG;
+	else
+		eng = cdev->l2_affin_hint ? QED_ENG1 : QED_ENG0;
+
+	rc = qed_llh_set_ppfid_affinity(cdev, ppfid, eng);
+	if (rc) {
+		DP_NOTICE(cdev,
+			  "Failed to set the engine affinity of ppfid %d\n",
+			  ppfid);
+		return rc;
+	}
+
+	DP_VERBOSE(cdev, (QED_MSG_RDMA | QED_MSG_SP),
+		   "LLH: Set the engine affinity of non-RoCE packets as %d\n",
+		   eng);
+
+	return 0;
+}
+
 static const struct qed_rdma_ops qed_rdma_ops_pass = {
 	.common = &qed_common_ops_pass,
 	.fill_dev_info = &qed_fill_rdma_dev_info,
@@ -1955,6 +1981,7 @@ static const struct qed_rdma_ops qed_rdma_ops_pass = {
 	.ll2_set_fragment_of_tx_packet = &qed_ll2_set_fragment_of_tx_packet,
 	.ll2_set_mac_filter = &qed_roce_ll2_set_mac_filter,
 	.ll2_get_stats = &qed_ll2_get_stats,
+	.iwarp_set_engine_affin = &qed_iwarp_set_engine_affin,
 	.iwarp_connect = &qed_iwarp_connect,
 	.iwarp_create_listen = &qed_iwarp_create_listen,
 	.iwarp_destroy_listen = &qed_iwarp_destroy_listen,
diff --git a/include/linux/qed/qed_rdma_if.h b/include/linux/qed/qed_rdma_if.h
index d15f8e4815e3..898f595ea3d6 100644
--- a/include/linux/qed/qed_rdma_if.h
+++ b/include/linux/qed/qed_rdma_if.h
@@ -670,6 +670,8 @@ struct qed_rdma_ops {
 	int (*ll2_set_mac_filter)(struct qed_dev *cdev,
 				  u8 *old_mac_address, u8 *new_mac_address);
 
+	int (*iwarp_set_engine_affin)(struct qed_dev *cdev, bool b_reset);
+
 	int (*iwarp_connect)(void *rdma_cxt,
 			     struct qed_iwarp_connect_in *iparams,
 			     struct qed_iwarp_connect_out *oparams);
-- 
2.14.5

