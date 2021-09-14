Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9B040BC01
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 01:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbhINXJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 19:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236023AbhINXJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 19:09:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B272C61165;
        Tue, 14 Sep 2021 23:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631660889;
        bh=AXYVdRfc4tw37Rv3J+S77liopuKThea9wDm664VbZvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhWaE23/2KpwIT2KbB3TsEkVaf68+bQ9WnmbhgeKov+XJ47SfbAr3RvAe7jd3yjc3
         fs0aiJ3I5XvW8XrmP9By8ug7RnTaSYbzRUVfy1yQ1X9mnWpJDn3JnGM/djAaAM72Ha
         xlIgDd6mr2QhOCbxiuhpfI9lihq3noABDmNME2nFOQ670xb9w8LZUATO8KcA7yE4MQ
         TKGqgkm/esjJ6bd/ClbIln+4RJMeVPT+GAHaXrpgAe41XQgcc7iBn1pMe7Jz1qsltP
         q5gsMkvhGK9xANQPbfvek4WS4/QPACe56BVCu0eQ6gtwjlZO2A8vkzIpQTKZQCVl85
         Bx6XZDaGgRH8g==
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
Subject: [PATCH rdma-next v1 11/11] RDMA/mlx5: Add optional counter support in get_hw_stats callback
Date:   Wed, 15 Sep 2021 02:07:30 +0300
Message-Id: <584d4fb2a5e3fe4b6390f5ea43cf96f65625b026.1631660727.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631660727.git.leonro@nvidia.com>
References: <cover.1631660727.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

When get_hw_stats is called, query and return the optional counter
statistic as well.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/counters.c | 88 ++++++++++++++++++++++++++-
 1 file changed, 85 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 627077514e14..4ba2dafe62b5 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -270,9 +270,9 @@ static int mlx5_ib_query_ext_ppcnt_counters(struct mlx5_ib_dev *dev,
 	return ret;
 }
 
-static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
-				struct rdma_hw_stats *stats,
-				u32 port_num, int index)
+static int do_get_hw_stats(struct ib_device *ibdev,
+			   struct rdma_hw_stats *stats,
+			   u32 port_num, int index)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	const struct mlx5_ib_counters *cnts = get_counters(dev, port_num - 1);
@@ -324,6 +324,88 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	return num_counters;
 }
 
+static int do_get_op_stat(struct ib_device *ibdev,
+			  struct rdma_hw_stats *stats,
+			  u32 port_num, int index)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	const struct mlx5_ib_counters *cnts;
+	const struct mlx5_ib_op_fc *opfcs;
+	u64 packets = 0, bytes;
+	u32 type;
+	int ret;
+
+	cnts = get_counters(dev, port_num - 1);
+	opfcs = cnts->opfcs;
+	type = *(u32 *)cnts->descs[index].priv;
+	if (type >= MLX5_IB_OPCOUNTER_MAX)
+		return -EINVAL;
+
+	if (!opfcs[type].fc)
+		goto out;
+
+	ret = mlx5_fc_query(dev->mdev, opfcs[type].fc,
+			    &packets, &bytes);
+	if (ret)
+		return ret;
+
+out:
+	stats->value[index] = packets;
+	return index;
+}
+
+static int do_get_op_stats(struct ib_device *ibdev,
+			   struct rdma_hw_stats *stats,
+			   u32 port_num)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	const struct mlx5_ib_counters *cnts;
+	int index, ret, num_hw_counters;
+
+	cnts = get_counters(dev, port_num - 1);
+	num_hw_counters = cnts->num_q_counters + cnts->num_cong_counters +
+			  cnts->num_ext_ppcnt_counters;
+	for (index = num_hw_counters;
+	     index < num_hw_counters + cnts->num_op_counters; index++) {
+		ret = do_get_op_stat(ibdev, stats, port_num, index);
+		if (ret != index)
+			return ret;
+	}
+
+	return cnts->num_op_counters;
+}
+
+static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
+				struct rdma_hw_stats *stats,
+				u32 port_num, int index)
+{
+	int num_counters, num_hw_counters, num_op_counters;
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	const struct mlx5_ib_counters *cnts;
+
+	cnts = get_counters(dev, port_num - 1);
+	num_hw_counters = cnts->num_q_counters + cnts->num_cong_counters +
+		cnts->num_ext_ppcnt_counters;
+	num_counters = num_hw_counters + cnts->num_op_counters;
+
+	if ((index < 0) || (index > num_counters))
+		return -EINVAL;
+	else if (index < num_hw_counters)
+		return do_get_hw_stats(ibdev, stats, port_num, index);
+	else if (index < num_counters)
+		return do_get_op_stat(ibdev, stats, port_num, index);
+
+	num_hw_counters = do_get_hw_stats(ibdev, stats, port_num, index);
+	if (num_hw_counters < 0)
+		return num_hw_counters;
+
+	num_op_counters = do_get_op_stats(ibdev, stats, port_num);
+	if (num_op_counters < 0)
+		return num_op_counters;
+
+	return num_hw_counters + num_op_counters;
+}
+
 static struct rdma_hw_stats *
 mlx5_ib_counter_alloc_stats(struct rdma_counter *counter)
 {
-- 
2.31.1

