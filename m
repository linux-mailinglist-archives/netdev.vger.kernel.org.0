Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A58412FBD7
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 18:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgACRwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 12:52:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49572 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbgACRwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 12:52:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003HiEsF132508;
        Fri, 3 Jan 2020 17:52:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=3rvXjxhb73UH9jUVx/PUmcUyxptNGpIN+gad9QF2ih8=;
 b=FA57/6TdDGXT+MNRaVGPvfwpETjl92jAdsOLZGr1zUgh/V3nia88ssHH5833s0ynAh6Z
 KWa2D57Qro4RTHpo4DzF7gh9qYmwq/bhTzLtBu8eGEcagrsAyBrtySE9I+cZ9Z9VCpDL
 c+mXk10TjO7tInjJwdCgUlo97eWXP0076abMSK37OMeH2kYQwFfvda49jg5tkX1Ty8X9
 P1hfBwTi38Nq5nP8g2S0BDtU8178ur7PO2STilpyMDtbOWdehqmEFdIdzTm/at/BvzAb
 dJWZp1maZSu8VEjKj8RGeYbSJwSLxJhS5mNG66slzvO8WR7kcWs99dOzYIVUt4HZY/wK mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x5y0pwf48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 17:52:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003HiWnD183872;
        Fri, 3 Jan 2020 17:52:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xa5fgnedc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 17:52:27 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 003HqNdI023996;
        Fri, 3 Jan 2020 17:52:23 GMT
Received: from Lirans-MBP.Home (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 09:52:23 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     eli@mellanox.com, tariqt@mellanox.com, danielm@mellanox.com,
        jgg@ziepe.ca, Liran Alon <liran.alon@oracle.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
Subject: [PATCH v2] net: mlx5: Use iowriteXbe() to ring doorbell and remove reduntant wmb()
Date:   Fri,  3 Jan 2020 19:52:07 +0200
Message-Id: <20200103175207.72655-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=929
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=992 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030163
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, mlx5e_notify_hw() executes wmb() to complete writes to
cache-coherent memory before ringing doorbell. Doorbell is written
to by mlx5_write64() which use __raw_writeX().

This is semantically correct but executes reduntant wmb() in some
architectures. For example, in x86, a write to UC memory guarantees
that any previous write to WB/UC memory will be globally visible
before the write to UC memory. Therefore, there is no need to also
execute wmb() before write to doorbell which is mapped as UC memory.

The consideration regarding this between different architectures is
handled properly by the writeX() & iowriteX() accessors. Which is
defined differently for different architectures. E.g. On x86, it is
just a memory write. However, on ARM, it is defined as __iowmb()
folowed by a memory write. __iowmb() is defined as wmb().

Therefore, change mlx5_write64() to use iowriteXbe() and remove wmb()
from it's callers.

Note: This relies on the fact that mlx5 kernel driver currently don't
use Mellanox BlueFlame technology that write Tx descriptors to WC memory.
In that case, iowriteX() isn't sufficient to flush write-combined buffers
(WCBs) on x86 AMD CPUs. That's because AMD CPUs do not flush WCBs on
write to UC memory. In that case, a wmb() (SFENCE) is required before
writing to Tx doorbell.

In addition, change callers of mlx5_write64() to just pass value in
CPU endianness as now mlx5_write64() explicitly pass value as big-endian
to device by using iowriteXbe().

Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 drivers/infiniband/hw/mlx5/qp.c                        |  6 +-----
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h      |  7 +------
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c    |  2 --
 .../net/ethernet/mellanox/mlx5/core/steering/dr_send.c |  4 ----
 include/linux/mlx5/cq.h                                |  9 ++-------
 include/linux/mlx5/doorbell.h                          | 10 ++++------
 6 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7e51870e9e01..87cbecb693ea 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5329,11 +5329,7 @@ static int _mlx5_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 
 		qp->db.db[MLX5_SND_DBR] = cpu_to_be32(qp->sq.cur_post);
 
-		/* Make sure doorbell record is visible to the HCA before
-		 * we hit doorbell */
-		wmb();
-
-		mlx5_write64((__be32 *)ctrl, bf->bfreg->map + bf->offset);
+		mlx5_write64((u32 *)ctrl, bf->bfreg->map + bf->offset);
 		/* Make sure doorbells don't leak out of SQ spinlock
 		 * and reach the HCA out of order.
 		 */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 7c8796d9743f..ad3fd38456b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -108,12 +108,7 @@ mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
 
 	*wq->db = cpu_to_be32(pc);
 
-	/* ensure doorbell record is visible to device before ringing the
-	 * doorbell
-	 */
-	wmb();
-
-	mlx5_write64((__be32 *)ctrl, uar_map);
+	mlx5_write64((u32 *)ctrl, uar_map);
 }
 
 static inline bool mlx5e_transport_inline_tx_wqe(struct mlx5_wqe_ctrl_seg *cseg)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 61021133029e..e30b6c771218 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -133,8 +133,6 @@ static void mlx5_fpga_conn_notify_hw(struct mlx5_fpga_conn *conn, void *wqe)
 	/* ensure wqe is visible to device before updating doorbell record */
 	dma_wmb();
 	*conn->qp.wq.sq.db = cpu_to_be32(conn->qp.sq.pc);
-	/* Make sure that doorbell record is visible before ringing */
-	wmb();
 	mlx5_write64(wqe, conn->fdev->conn_res.uar->map + MLX5_BF_OFFSET);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 51803eef13dd..cfcbd4e338cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -213,10 +213,6 @@ static void dr_cmd_notify_hw(struct mlx5dr_qp *dr_qp, void *ctrl)
 {
 	dma_wmb();
 	*dr_qp->wq.sq.db = cpu_to_be32(dr_qp->sq.pc & 0xfffff);
-
-	/* After wmb() the hw aware of new work */
-	wmb();
-
 	mlx5_write64(ctrl, dr_qp->uar->map + MLX5_BF_OFFSET);
 }
 
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index 40748fc1b11b..4631ad35da53 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -162,13 +162,8 @@ static inline void mlx5_cq_arm(struct mlx5_core_cq *cq, u32 cmd,
 
 	*cq->arm_db = cpu_to_be32(sn << 28 | cmd | ci);
 
-	/* Make sure that the doorbell record in host memory is
-	 * written before ringing the doorbell via PCI MMIO.
-	 */
-	wmb();
-
-	doorbell[0] = cpu_to_be32(sn << 28 | cmd | ci);
-	doorbell[1] = cpu_to_be32(cq->cqn);
+	doorbell[0] = sn << 28 | cmd | ci;
+	doorbell[1] = cq->cqn;
 
 	mlx5_write64(doorbell, uar_page + MLX5_CQ_DOORBELL);
 }
diff --git a/include/linux/mlx5/doorbell.h b/include/linux/mlx5/doorbell.h
index 5c267707e1df..9c1d35777323 100644
--- a/include/linux/mlx5/doorbell.h
+++ b/include/linux/mlx5/doorbell.h
@@ -43,17 +43,15 @@
  * Note that the write is not atomic on 32-bit systems! In contrast to 64-bit
  * ones, it requires proper locking. mlx5_write64 doesn't do any locking, so use
  * it at your own discretion, protected by some kind of lock on 32 bits.
- *
- * TODO: use write{q,l}_relaxed()
  */
 
-static inline void mlx5_write64(__be32 val[2], void __iomem *dest)
+static inline void mlx5_write64(u32 val[2], void __iomem *dest)
 {
 #if BITS_PER_LONG == 64
-	__raw_writeq(*(u64 *)val, dest);
+	iowrite64be(*(u64 *)val, dest);
 #else
-	__raw_writel((__force u32) val[0], dest);
-	__raw_writel((__force u32) val[1], dest + 4);
+	iowrite32be(val[0], dest);
+	iowrite32be(val[1], dest + 4);
 #endif
 }
 
-- 
2.20.1

