Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A6D2035AC
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgFVL0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:26:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47288 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727996AbgFVLOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:14:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MB4TS3006545;
        Mon, 22 Jun 2020 04:14:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=bH4mOeMSy3lXy+89A4sAb2b4q/8m1695Bsw+MK0lANA=;
 b=HQ66IXUxD3VT8UKVzBv1CVd27NRRufoDpewJ9g1F1/287ZyhCTD4fXJNQXwZNqPSCUrT
 dTJRlUXio8TRLn2YpN3T97kjRayO4fMksCLs5KMNg4V40mUDcoSuC4Y9FjKRYno5aUTB
 XudpR73VM0pvQ+aNoYJ5BA/5T39Es0Hm3Iw/0XAq9Bl8f4XnT+VK5tPnG4MwiURe//hC
 nKvl3lf6lx5yax/RMGNtqBD4d9GWL3azzq/BhA+5xIDmZ4dlhDkn7B9hXIX3vsv0ieAM
 kMZ78rzxeCYwh9ORUv6abZTYIyfuVHNUUnN0Kylpe4eKIpj6fuQ3lF9AcsE4bE0RAhxV iQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 31sftpg5wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 04:14:32 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 04:14:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 04:14:30 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id CD7173F703F;
        Mon, 22 Jun 2020 04:14:26 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Yuval Mintz <yuval.mintz@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Ram Amrani" <ram.amrani@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 2/9] net: qed: fix async event callbacks unregistering
Date:   Mon, 22 Jun 2020 14:14:06 +0300
Message-ID: <20200622111413.7006-3-alobakin@marvell.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200622111413.7006-1-alobakin@marvell.com>
References: <20200622111413.7006-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_04:2020-06-22,2020-06-22 signatures=0
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
2.21.0

