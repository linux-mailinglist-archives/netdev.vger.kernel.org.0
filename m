Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2362F41D516
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349180AbhI3IGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:32888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348966AbhI3IEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 04:04:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B39861884;
        Thu, 30 Sep 2021 08:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632988981;
        bh=BKLRNSpziHIogTGyQwgRIzKdPL5GFjN/umPeU5uqcso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aE1bE2gFpVQ7gwvx8At0n2CizMl4vVmB/Ja8BbnCeOyAIUKmWDfmywqXsMrlNjlUb
         Y64hP7Ns7jQTrnV+sCgLHwM+PkamINTF77PwYxAd4VjQ05TZHhCxNEWZ9cW2vBdvEP
         3IVzblGYP5ixp5oTu2o1cze2zaNgjanLEfA0E+iu2WaZBOpFhNtBYzBbUNNIEiZV2o
         ciaC616DxkEtLRhWR3kv+Mu/dI674YBC1n7HpGHGa1GP4QW4E7bDGJf/7Qg6+wX1gM
         21ne5x/TwGJZCAVwXuWwqznu+100U0hD15gVQ+e2a5wXKfr5MJrC0R9qe8e/4Q/6qA
         /kh73ilVZyQwg==
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
Subject: [PATCH rdma-next v2 09/13] RDMA/mlx5: Support optional counters in hw_stats initialization
Date:   Thu, 30 Sep 2021 11:02:25 +0300
Message-Id: <840fc0529c50b3988a5856b7a5b3b3ab8384d88c.1632988543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632988543.git.leonro@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Add optional counter support when allocate and initialize hw_stats
structure. Optional counters have IB_STAT_FLAG_OPTIONAL flag set
and are disabled by default.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/counters.c | 90 ++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |  1 +
 2 files changed, 75 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index d2208b3c5925..6aa54ee441db 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -75,6 +75,21 @@ static const struct mlx5_ib_counter ext_ppcnt_cnts[] = {
 	INIT_EXT_PPCNT_COUNTER(rx_icrc_encapsulated),
 };
 
+#define INIT_OP_COUNTER(_name)                                          \
+	{ .name = #_name }
+
+static const struct mlx5_ib_counter basic_op_cnts[] = {
+	INIT_OP_COUNTER(cc_rx_ce_pkts),
+};
+
+static const struct mlx5_ib_counter rdmarx_cnp_op_cnts[] = {
+	INIT_OP_COUNTER(cc_rx_cnp_pkts),
+};
+
+static const struct mlx5_ib_counter rdmatx_cnp_op_cnts[] = {
+	INIT_OP_COUNTER(cc_tx_cnp_pkts),
+};
+
 static int mlx5_ib_read_counters(struct ib_counters *counters,
 				 struct ib_counters_read_attr *read_attr,
 				 struct uverbs_attr_bundle *attrs)
@@ -161,17 +176,34 @@ u16 mlx5_ib_get_counters_id(struct mlx5_ib_dev *dev, u32 port_num)
 	return cnts->set_id;
 }
 
+static struct rdma_hw_stats *do_alloc_stats(const struct mlx5_ib_counters *cnts)
+{
+	struct rdma_hw_stats *stats;
+	u32 num_hw_counters;
+	int i;
+
+	num_hw_counters = cnts->num_q_counters + cnts->num_cong_counters +
+			  cnts->num_ext_ppcnt_counters;
+	stats = rdma_alloc_hw_stats_struct(cnts->descs,
+					   num_hw_counters +
+					   cnts->num_op_counters,
+					   RDMA_HW_STATS_DEFAULT_LIFESPAN);
+	if (!stats)
+		return NULL;
+
+	for (i = 0; i < cnts->num_op_counters; i++)
+		set_bit(num_hw_counters + i, stats->is_disabled);
+
+	return stats;
+}
+
 static struct rdma_hw_stats *
 mlx5_ib_alloc_hw_device_stats(struct ib_device *ibdev)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	const struct mlx5_ib_counters *cnts = &dev->port[0].cnts;
 
-	return rdma_alloc_hw_stats_struct(cnts->descs,
-					  cnts->num_q_counters +
-						  cnts->num_cong_counters +
-						  cnts->num_ext_ppcnt_counters,
-					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
+	return do_alloc_stats(cnts);
 }
 
 static struct rdma_hw_stats *
@@ -180,11 +212,7 @@ mlx5_ib_alloc_hw_port_stats(struct ib_device *ibdev, u32 port_num)
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	const struct mlx5_ib_counters *cnts = &dev->port[port_num - 1].cnts;
 
-	return rdma_alloc_hw_stats_struct(cnts->descs,
-					  cnts->num_q_counters +
-						  cnts->num_cong_counters +
-						  cnts->num_ext_ppcnt_counters,
-					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
+	return do_alloc_stats(cnts);
 }
 
 static int mlx5_ib_query_q_counters(struct mlx5_core_dev *mdev,
@@ -302,11 +330,7 @@ mlx5_ib_counter_alloc_stats(struct rdma_counter *counter)
 	const struct mlx5_ib_counters *cnts =
 		get_counters(dev, counter->port - 1);
 
-	return rdma_alloc_hw_stats_struct(cnts->descs,
-					  cnts->num_q_counters +
-					  cnts->num_cong_counters +
-					  cnts->num_ext_ppcnt_counters,
-					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
+	return do_alloc_stats(cnts);
 }
 
 static int mlx5_ib_counter_update_stats(struct rdma_counter *counter)
@@ -425,13 +449,34 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 			offsets[j] = ext_ppcnt_cnts[i].offset;
 		}
 	}
+
+	for (i = 0; i < ARRAY_SIZE(basic_op_cnts); i++, j++) {
+		descs[j].name = basic_op_cnts[i].name;
+		descs[j].flags |= IB_STAT_FLAG_OPTIONAL;
+	}
+
+	if (MLX5_CAP_FLOWTABLE(dev->mdev,
+			       ft_field_support_2_nic_receive_rdma.bth_opcode)) {
+		for (i = 0; i < ARRAY_SIZE(rdmarx_cnp_op_cnts); i++, j++) {
+			descs[j].name = rdmarx_cnp_op_cnts[i].name;
+			descs[j].flags |= IB_STAT_FLAG_OPTIONAL;
+		}
+	}
+
+	if (MLX5_CAP_FLOWTABLE(dev->mdev,
+			       ft_field_support_2_nic_transmit_rdma.bth_opcode)) {
+		for (i = 0; i < ARRAY_SIZE(rdmatx_cnp_op_cnts); i++, j++) {
+			descs[j].name = rdmatx_cnp_op_cnts[i].name;
+			descs[j].flags |= IB_STAT_FLAG_OPTIONAL;
+		}
+	}
 }
 
 
 static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
 				    struct mlx5_ib_counters *cnts)
 {
-	u32 num_counters;
+	u32 num_counters, num_op_counters;
 
 	num_counters = ARRAY_SIZE(basic_q_cnts);
 
@@ -457,6 +502,19 @@ static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
 		cnts->num_ext_ppcnt_counters = ARRAY_SIZE(ext_ppcnt_cnts);
 		num_counters += ARRAY_SIZE(ext_ppcnt_cnts);
 	}
+
+	num_op_counters = ARRAY_SIZE(basic_op_cnts);
+
+	if (MLX5_CAP_FLOWTABLE(dev->mdev,
+			       ft_field_support_2_nic_receive_rdma.bth_opcode))
+		num_op_counters += ARRAY_SIZE(rdmarx_cnp_op_cnts);
+
+	if (MLX5_CAP_FLOWTABLE(dev->mdev,
+			       ft_field_support_2_nic_transmit_rdma.bth_opcode))
+		num_op_counters += ARRAY_SIZE(rdmatx_cnp_op_cnts);
+
+	cnts->num_op_counters = num_op_counters;
+	num_counters += num_op_counters;
 	cnts->descs = kcalloc(num_counters,
 			      sizeof(struct rdma_stat_desc), GFP_KERNEL);
 	if (!cnts->descs)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6f5451d96dd7..8215d7ab579d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -803,6 +803,7 @@ struct mlx5_ib_counters {
 	u32 num_q_counters;
 	u32 num_cong_counters;
 	u32 num_ext_ppcnt_counters;
+	u32 num_op_counters;
 	u16 set_id;
 };
 
-- 
2.31.1

