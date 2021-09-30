Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEEC41D518
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349235AbhI3IGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:32962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348971AbhI3IE5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 04:04:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2456961555;
        Thu, 30 Sep 2021 08:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632988992;
        bh=ZXsgui6K1v26MR0Wplsym8mCWKz8YQMR5/E84DamG+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m28FTE4T3JQv2Q+HbIHX/peahaqqwxX2uGk2mnwU80D/9IhRvgR63Gd3Tke0kVDyQ
         x+1Rx2m3kfp6fbWdNQyfSkjVy7MjavyLIdXdEqWP2jQhtPJB9GPK4fIg1y7/w1o3wz
         frCKdWDEqe214wfmY3V+dgbjOTW7S80AHinLOfiI4hWBNCLhWliKMpXSMt6gOxLig8
         HijqyXR4Fx4V3FDU53AjdeZDNrtHWWXBZ1jcgzjYMSNE02czpzyX+IOQ57rqu4LLNm
         glfI78qRVwWIQLm0jR1JuyWYYR36hhS6caTRsU6zw2EL2NGJA0D3UDC0PStSxt/wNN
         ILrKsQxvAxpEA==
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
Subject: [PATCH rdma-next v2 12/13] RDMA/mlx5: Add optional counter support in get_hw_stats callback
Date:   Thu, 30 Sep 2021 11:02:28 +0300
Message-Id: <f01ef876250e1acf4fbef3167fb103a53b620197.1632988543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632988543.git.leonro@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
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
index 787cd4c73f35..206c190d0ce4 100644
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
+	else if ((index > 0) && (index < num_hw_counters))
+		return do_get_hw_stats(ibdev, stats, port_num, index);
+	else if ((index >= num_hw_counters) && (index < num_counters))
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

