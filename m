Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857075F5953
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 19:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiJERr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 13:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiJERrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 13:47:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C0480BDB;
        Wed,  5 Oct 2022 10:45:58 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295GedKv005552;
        Wed, 5 Oct 2022 17:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=PAfKF245rJVuyKQIojRzi3hHRTZzW3nXv15RmqODTr4=;
 b=0aV3/2SVZS5xIpa0qWVT1kpY9eh9NGdlvN9f0B1oWw8FMiSgwZoEZos/o2/kwOsFUVJE
 vRUw9gxI4j7KIc7Usm70B+OjL+GNF9P3NzuC/JZyuHnzFNEpCGgkLjnqe9BMYY2Q55kN
 4o+2Yf3v7uytSiMWgZC04gUWARuoajok13ftIJg94mwNzfwX7f2NRzdVNs0uzAKV7YWF
 nrS5wX59rVW+vd/o3/g41sj9vh+qs9Vuud/VdN6HEzmRjjGREjwvIpC/KFjL033xj4rU
 A9EbfFZmrc7aQSejPm6rCMKujdD0fyVjjd72mHmNutSJKZxnbSlfmyTEFCKpOOIQuKQK Iw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k15up1e6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 17:45:31 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 295HQq3C029578;
        Wed, 5 Oct 2022 17:45:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc05t2t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 17:45:30 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 295HjUb6024064;
        Wed, 5 Oct 2022 17:45:30 GMT
Received: from rsajanku-mac.us.oracle.com (dhcp-10-159-236-222.vpn.oracle.com [10.159.236.222])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3jxc05t2sa-1;
        Wed, 05 Oct 2022 17:45:29 +0000
From:   Rohit Nair <rohit.sajan.kumar@oracle.com>
To:     leon@kernel.org, jgg@ziepe.ca, saeedm@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     manjunath.b.patil@oracle.com, rama.nichanamatlu@oracle.com,
        rohit.sajan.kumar@oracle.com,
        Michael Guralnik <michaelgur@nvidia.com>
Subject: [PATCH 1/1] IB/mlx5: Add a signature check to received EQEs and CQEs
Date:   Wed,  5 Oct 2022 10:45:20 -0700
Message-Id: <20221005174521.63619-1-rohit.sajan.kumar@oracle.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_05,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210050110
X-Proofpoint-GUID: 7fg1NbIa4R_lG-oT8MZX2aGtcx9eazeq
X-Proofpoint-ORIG-GUID: 7fg1NbIa4R_lG-oT8MZX2aGtcx9eazeq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As PRM defines, the bytewise XOR of the EQE and the EQE index should be
0xff. Otherwise, we can assume we have a corrupt EQE. The same is
applicable to CQE as well.

Adding a check to verify the EQE and CQE is valid in that aspect and if
not, dump the CQE and EQE to dmesg to be inspected.

This patch does not introduce any significant performance degradations
and has been tested using qperf.

Suggested-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Rohit Nair <rohit.sajan.kumar@oracle.com>
---
 drivers/infiniband/hw/mlx5/cq.c              | 40 ++++++++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 39 +++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index be189e0..2a6d722 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -441,6 +441,44 @@ static void mlx5_ib_poll_sw_comp(struct mlx5_ib_cq *cq, int num_entries,
 	}
 }
 
+static void verify_cqe(struct mlx5_cqe64 *cqe64, struct mlx5_ib_cq *cq)
+{
+	int i = 0;
+	u64 temp_xor = 0;
+	struct mlx5_ib_dev *dev = to_mdev(cq->ibcq.device);
+
+	u32 cons_index = cq->mcq.cons_index;
+	u64 *eight_byte_raw_cqe = (u64 *)cqe64;
+	u8 *temp_bytewise_xor = (u8 *)(&temp_xor);
+	u8 cqe_bytewise_xor = (cons_index & 0xff) ^
+				((cons_index & 0xff00) >> 8) ^
+				((cons_index & 0xff0000) >> 16);
+
+	for (i = 0; i < sizeof(struct mlx5_cqe64); i += 8) {
+		temp_xor ^= *eight_byte_raw_cqe;
+		eight_byte_raw_cqe++;
+	}
+
+	for (i = 0; i < (sizeof(u64)); i++) {
+		cqe_bytewise_xor ^= *temp_bytewise_xor;
+		temp_bytewise_xor++;
+	}
+
+	if (cqe_bytewise_xor == 0xff)
+		return;
+
+	dev_err(&dev->mdev->pdev->dev,
+		"Faulty CQE - checksum failure: cqe=0x%x cqn=0x%x cqe_bytewise_xor=0x%x\n",
+		cq->ibcq.cqe, cq->mcq.cqn, cqe_bytewise_xor);
+	dev_err(&dev->mdev->pdev->dev,
+		"cons_index=%u arm_sn=%u irqn=%u cqe_size=0x%x\n",
+		cq->mcq.cons_index, cq->mcq.arm_sn, cq->mcq.irqn, cq->mcq.cqe_sz);
+
+	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET,
+		       16, 1, cqe64, sizeof(*cqe64), false);
+	BUG();
+}
+
 static int mlx5_poll_one(struct mlx5_ib_cq *cq,
 			 struct mlx5_ib_qp **cur_qp,
 			 struct ib_wc *wc)
@@ -463,6 +501,8 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
 
 	cqe64 = (cq->mcq.cqe_sz == 64) ? cqe : cqe + 64;
 
+	verify_cqe(cqe64, cq);
+
 	++cq->mcq.cons_index;
 
 	/* Make sure we read CQ entry contents after we've checked the
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 229728c..f2a6d8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -102,6 +102,43 @@ static struct mlx5_core_cq *mlx5_eq_cq_get(struct mlx5_eq *eq, u32 cqn)
 	return cq;
 }
 
+static void verify_eqe(struct mlx5_eq *eq, struct mlx5_eqe *eqe)
+{
+	u64 *eight_byte_raw_eqe = (u64 *)eqe;
+	u8 eqe_bytewise_xor = (eq->cons_index & 0xff) ^
+			      ((eq->cons_index & 0xff00) >> 8) ^
+			      ((eq->cons_index & 0xff0000) >> 16);
+
+	int i = 0;
+	u64 temp_xor = 0;
+	u8 *temp_bytewise_xor = (u8 *)(&temp_xor);
+
+	for (i = 0; i < sizeof(struct mlx5_eqe); i += 8) {
+		temp_xor ^= *eight_byte_raw_eqe;
+		eight_byte_raw_eqe++;
+	}
+
+	for (i = 0; i < (sizeof(u64)); i++) {
+		eqe_bytewise_xor ^= *temp_bytewise_xor;
+		temp_bytewise_xor++;
+	}
+
+	if (eqe_bytewise_xor == 0xff)
+		return;
+
+	dev_err(&eq->dev->pdev->dev,
+		"Faulty EQE - checksum failure: ci=0x%x eqe_type=0x%x eqe_bytewise_xor=0x%x",
+		eq->cons_index, eqe->type, eqe_bytewise_xor);
+
+	dev_err(&eq->dev->pdev->dev,
+		"EQ addr=%p eqn=%u irqn=%u vec_index=%u",
+		eq, eq->eqn, eq->irqn, eq->vecidx);
+
+	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET,
+		       16, 1, eqe, sizeof(*eqe), false);
+	BUG();
+}
+
 static int mlx5_eq_comp_int(struct notifier_block *nb,
 			    __always_unused unsigned long action,
 			    __always_unused void *data)
@@ -127,6 +164,8 @@ static int mlx5_eq_comp_int(struct notifier_block *nb,
 		/* Assume (eqe->type) is always MLX5_EVENT_TYPE_COMP */
 		cqn = be32_to_cpu(eqe->data.comp.cqn) & 0xffffff;
 
+		verify_eqe(eq, eqe);
+
 		cq = mlx5_eq_cq_get(eq, cqn);
 		if (likely(cq)) {
 			++cq->arm_sn;
-- 
1.8.3.1

