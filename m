Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7182A9B2
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 14:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbfEZMYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 08:24:16 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40618 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727857AbfEZMYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 08:24:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4QCLjUW001370;
        Sun, 26 May 2019 05:24:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=LhZYNq21xh+jiQdYgua9LE7uLPnWUJLRDhoun0tC6qw=;
 b=BnCzOHgXXDQdLQ6ENoDtNI9j1/qnBc2cvYW57QaAmER87UbM/Re5twZEyUqQqO4oh69H
 Vkd3ZeCT00qzjOc20X97mw33KNyFVOmixeRLx5QR0T6IxUNbIRLwMjtLpSzjZrBAUQ+/
 74SgomJTFPtNHNXDryQ+qKJCeK1gFxARw44Ty0XAHx2sIRPHrmnIdy5FsH8idZizIHhC
 p0esErFSntNPmnGomGuoqmEPs/hF93mrr1eJ4NU+KrfJK0/opoDQHV+vMbFVACMC5Sa0
 xrNTmop8b7DVhirYAHfDycOjRBl+fN472kebfJNHWYQTC/1aTBI8lkAtmLU7TnNTyeah 4g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2sq57fubtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 26 May 2019 05:24:09 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 26 May
 2019 05:24:07 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Sun, 26 May 2019 05:24:07 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 9D21C3F703F;
        Sun, 26 May 2019 05:24:05 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <dledford@redhat.com>, <jgg@ziepe.ca>, <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 net-next 08/11] qed*: Add iWARP 100g support
Date:   Sun, 26 May 2019 15:22:27 +0300
Message-ID: <20190526122230.30039-9-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190526122230.30039-1-michal.kalderon@marvell.com>
References: <20190526122230.30039-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-26_08:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add iWARP engine affinity setting for supporting iWARP over 100g.
iWARP cannot be distinguished by the LLH from L2, hence the
engine division will affect L2 as well. For this reason we add
a parameter to devlink to determine the engine division.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/main.c          | 13 +++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 31 ++++++++++++++++++++++++++++++
 include/linux/qed/qed_rdma_if.h            |  2 ++
 3 files changed, 46 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index d93c8a893a89..d961d306da11 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -886,7 +886,16 @@ static struct qedr_dev *qedr_add(struct qed_dev *cdev, struct pci_dev *pdev,
 	dev->user_dpm_enabled = dev_info.user_dpm_enabled;
 	dev->rdma_type = dev_info.rdma_type;
 	dev->num_hwfns = dev_info.common.num_hwfns;
+
+	if (IS_IWARP(dev) && QEDR_IS_CMT(dev)) {
+		rc = dev->ops->iwarp_set_engine_affin(cdev, false);
+		if (rc) {
+			DP_ERR(dev, "iWARP is disabled over a 100g device Enabling it may impact L2 performance. To enable it run devlink dev param set <dev> name iwarp_cmt value true cmode runtime\n");
+			goto init_err;
+		}
+	}
 	dev->affin_hwfn_idx = dev->ops->common->get_affin_hwfn_idx(cdev);
+
 	dev->rdma_ctx = dev->ops->rdma_get_rdma_ctx(cdev);
 
 	dev->num_cnq = dev->ops->rdma_get_min_cnq_msix(cdev);
@@ -947,6 +956,10 @@ static void qedr_remove(struct qedr_dev *dev)
 	qedr_stop_hw(dev);
 	qedr_sync_free_irqs(dev);
 	qedr_free_resources(dev);
+
+	if (IS_IWARP(dev) && QEDR_IS_CMT(dev))
+		dev->ops->iwarp_set_engine_affin(dev->cdev, true);
+
 	ib_dealloc_device(&dev->ibdev);
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index e4d63359864e..f900fde448db 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1916,6 +1916,36 @@ static int qed_roce_ll2_set_mac_filter(struct qed_dev *cdev,
 	return rc;
 }
 
+static int qed_iwarp_set_engine_affin(struct qed_dev *cdev, bool b_reset)
+{
+	enum qed_eng eng;
+	u8 ppfid = 0;
+	int rc;
+
+	/* Make sure iwarp cmt mode is enabled before setting affinity */
+	if (!cdev->iwarp_cmt)
+		return -EINVAL;
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
@@ -1955,6 +1985,7 @@ static const struct qed_rdma_ops qed_rdma_ops_pass = {
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

