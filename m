Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E1341D519
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349212AbhI3IGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:32924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348969AbhI3IEu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 04:04:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E24F2610A4;
        Thu, 30 Sep 2021 08:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632988988;
        bh=/IwAPcZZlpEb+3D73aRSgtdWWJWBPxYKI2jCQS30M0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nskj3rgX9wRCMLTmDu8dNBBwKkjhdUScy9Q3mwfPZ7nYsZAfeLdRhTI2X4gJRKXdr
         K9IIrvE8G/EtlMuphOpwIGT6V84fFWxijPyx1N55YJk5ItUsjqcQwLalDm4C4O1thl
         qbPWwcABq+78XXwyQxEDgAATohacoH1OpW4cCoBBN8KS5FGmKEMI+6ue6iRFTa21Ey
         saO0+QZidFuUbV7h1YnIMvMMg2iq+6XaZMzva0M6R2Dfm69HYQP98WC8kgI+PxHTHM
         +VheOkNMKu+aQ5eEdmgt1k1AZhMN9HfC0Aub/MM9h+M8Wpe+m34YPJbG4+QblsNjIg
         A4cOPmQmlAQyA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next v2 11/13] RDMA/mlx5: Add modify_op_stat() support
Date:   Thu, 30 Sep 2021 11:02:27 +0300
Message-Id: <156d648a9283162d7d944277a1bb77a3fd585d49.1632988543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632988543.git.leonro@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Add support for ib callback modify_op_stat() to add or remove an
optional counter. When adding, a steering flow table is created
with a rule that catches and counts all the matching packets;
When removing, the table and flow counter are destroyed.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/counters.c | 79 +++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |  1 +
 include/rdma/ib_verbs.h               |  2 +
 3 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 6aa54ee441db..787cd4c73f35 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -12,6 +12,7 @@
 struct mlx5_ib_counter {
 	const char *name;
 	size_t offset;
+	u32 type;
 };
 
 #define INIT_Q_COUNTER(_name)		\
@@ -75,19 +76,19 @@ static const struct mlx5_ib_counter ext_ppcnt_cnts[] = {
 	INIT_EXT_PPCNT_COUNTER(rx_icrc_encapsulated),
 };
 
-#define INIT_OP_COUNTER(_name)                                          \
-	{ .name = #_name }
+#define INIT_OP_COUNTER(_name, _type)		\
+	{ .name = #_name, .type = MLX5_IB_OPCOUNTER_##_type}
 
 static const struct mlx5_ib_counter basic_op_cnts[] = {
-	INIT_OP_COUNTER(cc_rx_ce_pkts),
+	INIT_OP_COUNTER(cc_rx_ce_pkts, CC_RX_CE_PKTS),
 };
 
 static const struct mlx5_ib_counter rdmarx_cnp_op_cnts[] = {
-	INIT_OP_COUNTER(cc_rx_cnp_pkts),
+	INIT_OP_COUNTER(cc_rx_cnp_pkts, CC_RX_CNP_PKTS),
 };
 
 static const struct mlx5_ib_counter rdmatx_cnp_op_cnts[] = {
-	INIT_OP_COUNTER(cc_tx_cnp_pkts),
+	INIT_OP_COUNTER(cc_tx_cnp_pkts, CC_TX_CNP_PKTS),
 };
 
 static int mlx5_ib_read_counters(struct ib_counters *counters,
@@ -453,6 +454,7 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 	for (i = 0; i < ARRAY_SIZE(basic_op_cnts); i++, j++) {
 		descs[j].name = basic_op_cnts[i].name;
 		descs[j].flags |= IB_STAT_FLAG_OPTIONAL;
+		descs[j].priv = &basic_op_cnts[i].type;
 	}
 
 	if (MLX5_CAP_FLOWTABLE(dev->mdev,
@@ -460,6 +462,7 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 		for (i = 0; i < ARRAY_SIZE(rdmarx_cnp_op_cnts); i++, j++) {
 			descs[j].name = rdmarx_cnp_op_cnts[i].name;
 			descs[j].flags |= IB_STAT_FLAG_OPTIONAL;
+			descs[j].priv = &rdmarx_cnp_op_cnts[i].type;
 		}
 	}
 
@@ -468,6 +471,7 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 		for (i = 0; i < ARRAY_SIZE(rdmatx_cnp_op_cnts); i++, j++) {
 			descs[j].name = rdmatx_cnp_op_cnts[i].name;
 			descs[j].flags |= IB_STAT_FLAG_OPTIONAL;
+			descs[j].priv = &rdmatx_cnp_op_cnts[i].type;
 		}
 	}
 }
@@ -537,7 +541,7 @@ static void mlx5_ib_dealloc_counters(struct mlx5_ib_dev *dev)
 {
 	u32 in[MLX5_ST_SZ_DW(dealloc_q_counter_in)] = {};
 	int num_cnt_ports;
-	int i;
+	int i, j;
 
 	num_cnt_ports = is_mdev_switchdev_mode(dev->mdev) ? 1 : dev->num_ports;
 
@@ -552,6 +556,18 @@ static void mlx5_ib_dealloc_counters(struct mlx5_ib_dev *dev)
 		}
 		kfree(dev->port[i].cnts.descs);
 		kfree(dev->port[i].cnts.offsets);
+
+		for (j = 0; j < MLX5_IB_OPCOUNTER_MAX; j++) {
+			if (!dev->port[i].cnts.opfcs[j].fc)
+				continue;
+
+			mlx5_ib_fs_remove_op_fc(dev,
+						&dev->port[i].cnts.opfcs[j],
+						j);
+			mlx5_fc_destroy(dev->mdev,
+					dev->port[i].cnts.opfcs[j].fc);
+			dev->port[i].cnts.opfcs[j].fc = NULL;
+		}
 	}
 }
 
@@ -731,6 +747,56 @@ void mlx5_ib_counters_clear_description(struct ib_counters *counters)
 	mutex_unlock(&mcounters->mcntrs_mutex);
 }
 
+static int mlx5_ib_modify_stat(struct ib_device *device, u32 port,
+			       unsigned int index, bool enable)
+{
+	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_counters *cnts;
+	struct mlx5_ib_op_fc *opfc;
+	u32 num_hw_counters, type;
+	int ret = 0;
+
+	cnts = &dev->port[port - 1].cnts;
+	num_hw_counters = cnts->num_q_counters + cnts->num_cong_counters +
+		cnts->num_ext_ppcnt_counters;
+	if ((index < num_hw_counters) ||
+	    (index >= num_hw_counters + cnts->num_op_counters))
+		return -EINVAL;
+
+	if (!(cnts->descs[index].flags & IB_STAT_FLAG_OPTIONAL))
+		return -EINVAL;
+
+	type = *(u32 *)cnts->descs[index].priv;
+	if (type >= MLX5_IB_OPCOUNTER_MAX)
+		return -EINVAL;
+
+	opfc = &cnts->opfcs[type];
+
+	if (enable) {
+		if (opfc->fc)
+			return -EEXIST;
+
+		opfc->fc = mlx5_fc_create(dev->mdev, false);
+		if (IS_ERR(opfc->fc))
+			return PTR_ERR(opfc->fc);
+
+		ret = mlx5_ib_fs_add_op_fc(dev, port, opfc, type);
+		if (ret) {
+			mlx5_fc_destroy(dev->mdev, opfc->fc);
+			opfc->fc = NULL;
+		}
+	} else {
+		if (!opfc->fc)
+			return -EINVAL;
+
+		mlx5_ib_fs_remove_op_fc(dev, opfc, type);
+		mlx5_fc_destroy(dev->mdev, opfc->fc);
+		opfc->fc = NULL;
+	}
+
+	return ret;
+}
+
 static const struct ib_device_ops hw_stats_ops = {
 	.alloc_hw_port_stats = mlx5_ib_alloc_hw_port_stats,
 	.get_hw_stats = mlx5_ib_get_hw_stats,
@@ -739,6 +805,7 @@ static const struct ib_device_ops hw_stats_ops = {
 	.counter_dealloc = mlx5_ib_counter_dealloc,
 	.counter_alloc_stats = mlx5_ib_counter_alloc_stats,
 	.counter_update_stats = mlx5_ib_counter_update_stats,
+	.modify_hw_stat = mlx5_ib_modify_stat,
 };
 
 static const struct ib_device_ops hw_switchdev_stats_ops = {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index d81ff5078e5e..cf8b0653f0ce 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -821,6 +821,7 @@ struct mlx5_ib_counters {
 	u32 num_ext_ppcnt_counters;
 	u32 num_op_counters;
 	u16 set_id;
+	struct mlx5_ib_op_fc opfcs[MLX5_IB_OPCOUNTER_MAX];
 };
 
 int mlx5_ib_fs_add_op_fc(struct mlx5_ib_dev *dev, u32 port_num,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d3f41099faa4..1ef6a47a7bff 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -553,10 +553,12 @@ enum ib_stat_flag {
  * struct rdma_stat_desc
  * @name - The name of the counter
  * @flags - Flags of the counter; For example, IB_STAT_FLAG_OPTIONAL
+ * @priv - Driver private information; Core code should not use
  */
 struct rdma_stat_desc {
 	const char *name;
 	unsigned int flags;
+	const void *priv;
 };
 
 /**
-- 
2.31.1

