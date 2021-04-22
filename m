Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8FB3679D3
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 08:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbhDVGWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 02:22:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34154 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhDVGWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 02:22:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M6L1o9122173;
        Thu, 22 Apr 2021 06:21:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=X83JZ/2N1DSnIYFTbCumPVNF60Vg3JGcOSd41nEHEtw=;
 b=NlJTO1CoACXSskzDR12OQjpWN4dyF7uI71aMBQ7XIU5tN7u/3UjesPalwBZtxq/JJVzw
 rdiV0Gk0QHc/FtcqmesKG8mAzXx1x+GcrlDy1DLQ5u+cIeKjYvSMx5Sn8BUWVU7HgAP2
 xhukCkWe8XqedheX3id02qYMUywCCQ8qEHvD9De04i2jpy1nNqUD1+Ky+ZdoGWfoBqFy
 BkBLEH1kJq3vS4VxyQutE4g2r/VUEDMGl/JpfIbL/RhFZ2bD4hxbGBec/a+zeJiGu+qf
 lUPoV7CLHCqh1O1pqNv+XdHKXBp6RlIuHg7mDxxVxVVw6obxOcyTRkGKDfVR2wrEOQex Iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37yn6ccbe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 06:21:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M6KxE0103825;
        Thu, 22 Apr 2021 06:21:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 383005yxvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 06:21:52 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 13M6LpvK005891;
        Thu, 22 Apr 2021 06:21:52 GMT
Received: from lab02.no.oracle.com (/10.172.144.56)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Apr 2021 23:21:50 -0700
From:   Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
To:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2 net-next] net/mlx4: Treat VFs fair when handling comm_channel_events
Date:   Thu, 22 Apr 2021 08:21:40 +0200
Message-Id: <1619072500-13789-1-git-send-email-hans.westgaard.ry@oracle.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220054
X-Proofpoint-GUID: rtvmX_WN58Hp7l6UtcTdqzw-3UvI-4WS
X-Proofpoint-ORIG-GUID: rtvmX_WN58Hp7l6UtcTdqzw-3UvI-4WS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handling comm_channel_event in mlx4_master_comm_channel uses a double
loop to determine which slaves have requested work. The search is
always started at lowest slave. This leads to unfairness; lower VFs
tends to be prioritized over higher VFs.

The patch uses find_next_bit to determine which slaves to handle.
Fairness is implemented by always starting at the next to the last
start.

An MPI program has been used to measure improvements. It runs 500
ibv_reg_mr, synchronizes with all other instances and then runs 500
ibv_dereg_mr.

The results running 500 processes, time reported is for running 500
calls:

ibv_reg_mr:
             Mod.   Org.
mlx4_1    403.356ms 424.674ms
mlx4_2    403.355ms 424.674ms
mlx4_3    403.354ms 424.674ms
mlx4_4    403.355ms 424.674ms
mlx4_5    403.357ms 424.677ms
mlx4_6    403.354ms 424.676ms
mlx4_7    403.357ms 424.675ms
mlx4_8    403.355ms 424.675ms

ibv_dereg_mr:
             Mod.   Org.
mlx4_1    116.408ms 142.818ms
mlx4_2    116.434ms 142.793ms
mlx4_3    116.488ms 143.247ms
mlx4_4    116.679ms 143.230ms
mlx4_5    112.017ms 107.204ms
mlx4_6    112.032ms 107.516ms
mlx4_7    112.083ms 184.195ms
mlx4_8    115.089ms 190.618ms

Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
---
v1 -> v2:                                                                                                                                                                                                                                
 - removed set but not user varible,
   reported by 'kernel test robot'
 - fixed reversed Christmas tree,
   removed else,
   removed extra varibles in printout,
   moved next_slave to struct mlx4_mfunc_master_ctx,
   as suggested by Tariq Toukan       
 drivers/net/ethernet/mellanox/mlx4/cmd.c  | 69 ++++++++++++++++++-------------
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |  1 +
 2 files changed, 41 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index c678344d22a2..8d751383530b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -2241,43 +2241,52 @@ void mlx4_master_comm_channel(struct work_struct *work)
 	struct mlx4_priv *priv =
 		container_of(mfunc, struct mlx4_priv, mfunc);
 	struct mlx4_dev *dev = &priv->dev;
-	__be32 *bit_vec;
+	u32 lbit_vec[COMM_CHANNEL_BIT_ARRAY_SIZE];
+	u32 nmbr_bits;
 	u32 comm_cmd;
-	u32 vec;
-	int i, j, slave;
+	int i, slave;
 	int toggle;
+	bool first = true;
 	int served = 0;
 	int reported = 0;
 	u32 slt;
 
-	bit_vec = master->comm_arm_bit_vector;
-	for (i = 0; i < COMM_CHANNEL_BIT_ARRAY_SIZE; i++) {
-		vec = be32_to_cpu(bit_vec[i]);
-		for (j = 0; j < 32; j++) {
-			if (!(vec & (1 << j)))
-				continue;
-			++reported;
-			slave = (i * 32) + j;
-			comm_cmd = swab32(readl(
-					  &mfunc->comm[slave].slave_write));
-			slt = swab32(readl(&mfunc->comm[slave].slave_read))
-				     >> 31;
-			toggle = comm_cmd >> 31;
-			if (toggle != slt) {
-				if (master->slave_state[slave].comm_toggle
-				    != slt) {
-					pr_info("slave %d out of sync. read toggle %d, state toggle %d. Resynching.\n",
-						slave, slt,
-						master->slave_state[slave].comm_toggle);
-					master->slave_state[slave].comm_toggle =
-						slt;
-				}
-				mlx4_master_do_cmd(dev, slave,
-						   comm_cmd >> 16 & 0xff,
-						   comm_cmd & 0xffff, toggle);
-				++served;
+	for (i = 0; i < COMM_CHANNEL_BIT_ARRAY_SIZE; i++)
+		lbit_vec[i] = be32_to_cpu(master->comm_arm_bit_vector[i]);
+	nmbr_bits = dev->persist->num_vfs + 1;
+	if (++master->next_slave >= nmbr_bits)
+		master->next_slave = 0;
+	slave = master->next_slave;
+	while (true) {
+		slave = find_next_bit((const unsigned long *)&lbit_vec, nmbr_bits, slave);
+		if  (!first && slave >= master->next_slave)
+			break;
+		if (slave == nmbr_bits) {
+			if (!first)
+				break;
+			first = false;
+			slave = 0;
+			continue;
+		}
+		++reported;
+		comm_cmd = swab32(readl(&mfunc->comm[slave].slave_write));
+		slt = swab32(readl(&mfunc->comm[slave].slave_read)) >> 31;
+		toggle = comm_cmd >> 31;
+		if (toggle != slt) {
+			if (master->slave_state[slave].comm_toggle
+			    != slt) {
+				pr_info("slave %d out of sync. read toggle %d, state toggle %d. Resynching.\n",
+					slave, slt,
+					master->slave_state[slave].comm_toggle);
+				master->slave_state[slave].comm_toggle =
+					slt;
 			}
+			mlx4_master_do_cmd(dev, slave,
+					   comm_cmd >> 16 & 0xff,
+					   comm_cmd & 0xffff, toggle);
+			++served;
 		}
+		slave++;
 	}
 
 	if (reported && reported != served)
@@ -2389,6 +2398,8 @@ int mlx4_multi_func_init(struct mlx4_dev *dev)
 		if (!priv->mfunc.master.vf_oper)
 			goto err_comm_oper;
 
+		priv->mfunc.master.next_slave = 0;
+
 		for (i = 0; i < dev->num_slaves; ++i) {
 			vf_admin = &priv->mfunc.master.vf_admin[i];
 			vf_oper = &priv->mfunc.master.vf_oper[i];
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 64bed7ac3836..6ccf340660d9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -603,6 +603,7 @@ struct mlx4_mfunc_master_ctx {
 	struct mlx4_slave_event_eq slave_eq;
 	struct mutex		gen_eqe_mutex[MLX4_MFUNC_MAX];
 	struct mlx4_qos_manager qos_ctl[MLX4_MAX_PORTS + 1];
+	u32			next_slave; /* mlx4_master_comm_channel */
 };
 
 struct mlx4_mfunc {
-- 
1.8.3.1

