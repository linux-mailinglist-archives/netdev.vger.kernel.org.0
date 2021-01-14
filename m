Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B4B2F63F1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbhANPMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:12:24 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38889 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729263AbhANPLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:11:38 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 14 Jan 2021 17:10:45 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10EFAh0E000835;
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
Subject: [PATCH v2 net-next 14/21] net/mlx5e: KLM UMR helper macros
Date:   Thu, 14 Jan 2021 17:10:26 +0200
Message-Id: <20210114151033.13020-15-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210114151033.13020-1-borisp@mellanox.com>
References: <20210114151033.13020-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

Add helper macros for posting KLM UMR WQE.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index ff100c290b59..26259d68b98a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -152,6 +152,24 @@ struct page_pool;
 #define MLX5E_UMR_WQEBBS \
 	(DIV_ROUND_UP(MLX5E_UMR_WQE_INLINE_SZ, MLX5_SEND_WQE_BB))
 
+#define KLM_ALIGNMENT 4
+#define MLX5E_KLM_UMR_WQE_SZ(sgl_len)\
+	(sizeof(struct mlx5e_umr_wqe) +\
+	(sizeof(struct mlx5_klm) * (sgl_len)))
+
+#define MLX5E_KLM_UMR_WQEBBS(sgl_len)\
+	(DIV_ROUND_UP(MLX5E_KLM_UMR_WQE_SZ(sgl_len), MLX5_SEND_WQE_BB))
+
+#define MLX5E_KLM_UMR_DS_CNT(sgl_len)\
+	DIV_ROUND_UP(MLX5E_KLM_UMR_WQE_SZ(sgl_len), MLX5_SEND_WQE_DS)
+
+#define MLX5E_MAX_KLM_ENTRIES_PER_WQE(wqe_size)\
+	(((wqe_size) - sizeof(struct mlx5e_umr_wqe)) / sizeof(struct mlx5_klm))
+
+#define MLX5E_KLM_ENTRIES_PER_WQE(wqe_size)\
+	(MLX5E_MAX_KLM_ENTRIES_PER_WQE(wqe_size) -\
+			(MLX5E_MAX_KLM_ENTRIES_PER_WQE(wqe_size) % KLM_ALIGNMENT))
+
 #define MLX5E_MSG_LEVEL			NETIF_MSG_LINK
 
 #define mlx5e_dbg(mlevel, priv, format, ...)                    \
-- 
2.24.1

