Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEBD2053FA
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 15:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732898AbgFWNye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 09:54:34 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7604 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732750AbgFWNxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 09:53:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NDjKAw024458;
        Tue, 23 Jun 2020 06:53:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=iRI8cQaocIwnSe3/XKLZ6IaN24mIo0ElD2hSCgdK2AQ=;
 b=qpzXxO+Xi3cyxkLduh5FQe2H3aTmgA4iJ++Yaea2OvqXK7V8r3xO161NgDosujV02n69
 O7G1pzr6I+eiu5KXaDfVMIu/CVWViUfaz03/lnxOweJuK/ckXdOAmSn7uW+aVsZnHFvP
 qIKSsGwsU+KMe7VXmJDPeqEbZVmCfRywiB8tCFcJ6fg2VZ1L+NrDVFKeJzGyFwBdcVJF
 J5tQY6GHuhpztdJ/vZ4v0RUlDt1V8mvJQGy/mu5trl15V9+gqUia2hKvDICInqiq5CEv
 b7Z9hNxbbA2dsVSxn/eQmBFVjf4yoB9qytnLh2ajquO0NFxAtBZz6bzTBzTIq+3civnp bg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 31ujw9r0wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 06:53:23 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 06:53:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 06:53:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Jun 2020 06:53:22 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id 6D2CE3F703F;
        Tue, 23 Jun 2020 06:53:18 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Denis Bolotin" <denis.bolotin@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net 2/9] net: qed: fix async event callbacks unregistering
Date:   Tue, 23 Jun 2020 16:51:30 +0300
Message-ID: <20200623135136.3185-3-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623135136.3185-1-alobakin@marvell.com>
References: <20200623135136.3185-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_06:2020-06-23,2020-06-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qed_spq_unregister_async_cb() should be called before
qed_rdma_info_free() to avoid crash-spawning uses-after-free.
Instead of calling it from each subsystem exit code, do it in one place
on PF down.

Fixes: 291d57f67d24 ("qed: Fix rdma_info structure allocation")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c   | 9 +++++++--
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 2 --
 drivers/net/ethernet/qlogic/qed/qed_roce.c  | 1 -
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 1eebf30fa798..b41ada668948 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -1368,6 +1368,8 @@ static void qed_dbg_user_data_free(struct qed_hwfn *p_hwfn)
 
 void qed_resc_free(struct qed_dev *cdev)
 {
+	struct qed_rdma_info *rdma_info;
+	struct qed_hwfn *p_hwfn;
 	int i;
 
 	if (IS_VF(cdev)) {
@@ -1385,7 +1387,8 @@ void qed_resc_free(struct qed_dev *cdev)
 	qed_llh_free(cdev);
 
 	for_each_hwfn(cdev, i) {
-		struct qed_hwfn *p_hwfn = &cdev->hwfns[i];
+		p_hwfn = cdev->hwfns + i;
+		rdma_info = p_hwfn->p_rdma_info;
 
 		qed_cxt_mngr_free(p_hwfn);
 		qed_qm_info_free(p_hwfn);
@@ -1404,8 +1407,10 @@ void qed_resc_free(struct qed_dev *cdev)
 			qed_ooo_free(p_hwfn);
 		}
 
-		if (QED_IS_RDMA_PERSONALITY(p_hwfn))
+		if (QED_IS_RDMA_PERSONALITY(p_hwfn) && rdma_info) {
+			qed_spq_unregister_async_cb(p_hwfn, rdma_info->proto);
 			qed_rdma_info_free(p_hwfn);
+		}
 
 		qed_iov_free(p_hwfn);
 		qed_l2_free(p_hwfn);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index d2fe61a5cf56..5409a2da6106 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -2836,8 +2836,6 @@ int qed_iwarp_stop(struct qed_hwfn *p_hwfn)
 	if (rc)
 		return rc;
 
-	qed_spq_unregister_async_cb(p_hwfn, PROTOCOLID_IWARP);
-
 	return qed_iwarp_ll2_stop(p_hwfn);
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index 4566815f7b87..7271dd7166e5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -113,7 +113,6 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
 			break;
 		}
 	}
-	qed_spq_unregister_async_cb(p_hwfn, PROTOCOLID_ROCE);
 }
 
 static void qed_rdma_copy_gids(struct qed_rdma_qp *qp, __le32 *src_gid,
-- 
2.25.1

