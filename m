Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813CE2F63E2
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbhANPLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:11:44 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38992 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729314AbhANPLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:11:42 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 14 Jan 2021 17:10:45 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10EFAh0I000835;
        Thu, 14 Jan 2021 17:10:45 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, dsahern@gmail.com,
        smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v2 net-next 18/21] net/mlx5e: NVMEoTCP ddp setup and resync
Date:   Thu, 14 Jan 2021 17:10:30 +0200
Message-Id: <20210114151033.13020-19-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210114151033.13020-1-borisp@mellanox.com>
References: <20210114151033.13020-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

NVMEoTCP offload uses buffer registration for every NVME request to perform direct data placement,
The registration is done via KLM UMR WQE's.
The driver resync handler advertise the software resync response via static params WQE.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 33 +++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 22fa1e9f3e7a..c2967cb4cb6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -751,6 +751,30 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 			 struct sock *sk,
 			 struct tcp_ddp_io *ddp)
 {
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct scatterlist *sg = ddp->sg_table.sgl;
+	struct mlx5e_nvmeotcp_queue *queue;
+	struct mlx5_core_dev *mdev;
+	int i, size = 0, count = 0;
+
+	queue = container_of(tcp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, tcp_ddp_ctx);
+
+	mdev = queue->priv->mdev;
+	count = dma_map_sg(mdev->device, ddp->sg_table.sgl, ddp->nents,
+			   DMA_FROM_DEVICE);
+
+	if (WARN_ON(count > mlx5e_get_max_sgl(mdev)))
+		return -ENOSPC;
+
+	for (i = 0; i < count; i++)
+		size += sg[i].length;
+
+	queue->ccid_table[ddp->command_id].size = size;
+	queue->ccid_table[ddp->command_id].ddp = ddp;
+	queue->ccid_table[ddp->command_id].sgl = sg;
+	queue->ccid_table[ddp->command_id].ccid_gen++;
+	queue->ccid_table[ddp->command_id].sgl_length = count;
+
 	return 0;
 }
 
@@ -788,11 +812,11 @@ mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 			    struct tcp_ddp_io *ddp,
 			    void *ddp_ctx)
 {
-	struct mlx5e_nvmeotcp_queue *queue =
-		(struct mlx5e_nvmeotcp_queue *)tcp_ddp_get_ctx(sk);
+	struct mlx5e_nvmeotcp_queue *queue;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct nvmeotcp_queue_entry *q_entry;
 
+	queue = container_of(tcp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, tcp_ddp_ctx);
 	q_entry  = &queue->ccid_table[ddp->command_id];
 	WARN_ON(q_entry->sgl_length == 0);
 
@@ -808,6 +832,11 @@ static void
 mlx5e_nvmeotcp_dev_resync(struct net_device *netdev,
 			  struct sock *sk, u32 seq)
 {
+	struct mlx5e_nvmeotcp_queue *queue =
+		container_of(tcp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, tcp_ddp_ctx);
+
+	queue->after_resync_cqe = 1;
+	mlx5e_nvmeotcp_rx_post_static_params_wqe(queue, seq);
 }
 
 static const struct tcp_ddp_dev_ops mlx5e_nvmeotcp_ops = {
-- 
2.24.1

