Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993CB12E986
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 18:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgABRpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 12:45:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54244 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbgABRpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 12:45:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002HYSRY078653;
        Thu, 2 Jan 2020 17:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=rtuRNTtVVtJIaZAg5pdQvtTXh3quWct1+9sb1iHznU4=;
 b=kBxHgLJYkV/L37AeI4RN7F1U4nzjqaK/TU4LBPamePQYgCeuzMxyUnNOtLWZCPT+kDrO
 9gCigGh5pKlTETM28y8qBlb7xS0vlGE9AZuCOQIWgNC0WYDc7Dyq5Uun0VuqeoKWHy7B
 4FkB665PvzCstNY4n7g6o6107ecegl7/zIsKZu16+Gtv9lZ3Mg85OXHPQN3zUoq+lDNs
 8L4b9OBHDgqFjOs0LCMPgeip6D5eWnbHMKJ/OvNJ3rZyheawvpgeHgtQDKGSeFyUvw1q
 Ce4BOo+5cWme6QfkTFUkgW29yo4/T0CqiWBcXcO34QWgVG2KSrCCKu740DhosthgUY0N Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x5y0prjfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 17:44:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002HYJ5r028075;
        Thu, 2 Jan 2020 17:44:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2x8gjatysh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 17:44:57 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 002HitbU012326;
        Thu, 2 Jan 2020 17:44:55 GMT
Received: from Lirans-MBP.Home (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 09:44:54 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     eli@mellanox.com, tariqt@mellanox.com, danielm@mellanox.com,
        Liran Alon <liran.alon@oracle.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
Subject: [PATCH] net: mlx5: Use writeX() to ring doorbell and remove reduntant wmb()
Date:   Thu,  2 Jan 2020 19:44:36 +0200
Message-Id: <20200102174436.66329-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=963
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001020149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001020149
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, mlx5e_notify_hw() executes wmb() to complete writes to cache-coherent
memory before ringing doorbell. Doorbell is written to by mlx5_write64()
which use __raw_writeX().

This is semantically correct but executes reduntant wmb() in some architectures.
For example, in x86, a write to UC memory guarantees that any previous write to
WB memory will be globally visible before the write to UC memory. Therefore, there
is no need to also execute wmb() before write to doorbell which is mapped as UC memory.

The consideration regarding this between different architectures is handled
properly by the writeX() macro. Which is defined differently for different
architectures. E.g. On x86, it is just a memory write. However, on ARM, it
is defined as __iowmb() folowed by a memory write. __iowmb() is defined
as wmb().

Therefore, change mlx5_write64() to use writeX() and remove wmb() from
it's callers.

Note: This relies on the fact that mlx5 kernel driver currently don't use
Mellanox BlueFlame technology that write Tx descriptors to WC memory. In
that case, writeX() isn't sufficient to flush write-combined buffers
(WCBs) on x86 AMD CPUs. That's because AMD CPUs do not flush WCBs on
write to UC memory. In that case, a wmb() (SFENCE) is required before
writing to Tx doorbell.

Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 drivers/infiniband/hw/mlx5/qp.c                           | 4 ----
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h         | 5 -----
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c       | 2 --
 .../net/ethernet/mellanox/mlx5/core/steering/dr_send.c    | 4 ----
 include/linux/mlx5/cq.h                                   | 5 -----
 include/linux/mlx5/doorbell.h                             | 8 +++-----
 6 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7e51870e9e01..5c2d660fada6 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5329,10 +5329,6 @@ static int _mlx5_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 
 		qp->db.db[MLX5_SND_DBR] = cpu_to_be32(qp->sq.cur_post);
 
-		/* Make sure doorbell record is visible to the HCA before
-		 * we hit doorbell */
-		wmb();
-
 		mlx5_write64((__be32 *)ctrl, bf->bfreg->map + bf->offset);
 		/* Make sure doorbells don't leak out of SQ spinlock
 		 * and reach the HCA out of order.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 7c8796d9743f..932891ea78d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -108,11 +108,6 @@ mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
 
 	*wq->db = cpu_to_be32(pc);
 
-	/* ensure doorbell record is visible to device before ringing the
-	 * doorbell
-	 */
-	wmb();
-
 	mlx5_write64((__be32 *)ctrl, uar_map);
 }
 
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
index 40748fc1b11b..28744a725e64 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -162,11 +162,6 @@ static inline void mlx5_cq_arm(struct mlx5_core_cq *cq, u32 cmd,
 
 	*cq->arm_db = cpu_to_be32(sn << 28 | cmd | ci);
 
-	/* Make sure that the doorbell record in host memory is
-	 * written before ringing the doorbell via PCI MMIO.
-	 */
-	wmb();
-
 	doorbell[0] = cpu_to_be32(sn << 28 | cmd | ci);
 	doorbell[1] = cpu_to_be32(cq->cqn);
 
diff --git a/include/linux/mlx5/doorbell.h b/include/linux/mlx5/doorbell.h
index 5c267707e1df..e606d5760fa7 100644
--- a/include/linux/mlx5/doorbell.h
+++ b/include/linux/mlx5/doorbell.h
@@ -43,17 +43,15 @@
  * Note that the write is not atomic on 32-bit systems! In contrast to 64-bit
  * ones, it requires proper locking. mlx5_write64 doesn't do any locking, so use
  * it at your own discretion, protected by some kind of lock on 32 bits.
- *
- * TODO: use write{q,l}_relaxed()
  */
 
 static inline void mlx5_write64(__be32 val[2], void __iomem *dest)
 {
 #if BITS_PER_LONG == 64
-	__raw_writeq(*(u64 *)val, dest);
+	writeq(*(u64 *)val, dest);
 #else
-	__raw_writel((__force u32) val[0], dest);
-	__raw_writel((__force u32) val[1], dest + 4);
+	writel((__force u32) val[0], dest);
+	writel((__force u32) val[1], dest + 4);
 #endif
 }
 
-- 
2.20.1

