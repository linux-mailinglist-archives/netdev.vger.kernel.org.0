Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8184841E4BD
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350550AbhI3XXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:23:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350162AbhI3XWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46686619E7;
        Thu, 30 Sep 2021 23:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044061;
        bh=l5/N+lqRCSsmY95mBZtUZFDZ0e5/N7Ulq5D8PrDgF/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fm22nkWnRmQuDU7trzs9LwiGDdtqECH/4XrLU6tQiQaVVPZ/yJj7YEFg8QK6OALh8
         mZ8AGcRievBbZ04i66JHTXmPonOMRuj5KeL1qvkbEyIwU0Of2dGcxMopZeOhsh3LO7
         +UJbwn+TJzg0O8uH0A5BTKNfkTvflT7i9RjsW9drSLy2C0zyJbJN3cfe1W+OMpZwi8
         bar9tG/ARs5+HqvPsJE3+mY4fHidBt4FLzGHfOGKZCiiWqFfXmqhfHcgIoG37Jd94x
         Te8E8Q7HFYUS4mXabv+kcq1wn3TjlLzl7qRzO65hE4BA44RV6d1sXdwFwB+BTrFiwD
         mwGKOjJX4SbvA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: Use array_size() helper
Date:   Thu, 30 Sep 2021 16:20:50 -0700
Message-Id: <20210930232050.41779-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

Use array_size() helper to aid in 2-factor allocation instances.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3fd515e7bf30..3ab5929ff131 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -930,9 +930,10 @@ static int mlx5e_alloc_xdpsq_fifo(struct mlx5e_xdpsq *sq, int numa)
 	struct mlx5e_xdp_info_fifo *xdpi_fifo = &sq->db.xdpi_fifo;
 	int wq_sz        = mlx5_wq_cyc_get_size(&sq->wq);
 	int dsegs_per_wq = wq_sz * MLX5_SEND_WQEBB_NUM_DS;
+	size_t size;
 
-	xdpi_fifo->xi = kvzalloc_node(sizeof(*xdpi_fifo->xi) * dsegs_per_wq,
-				      GFP_KERNEL, numa);
+	size = array_size(sizeof(*xdpi_fifo->xi), dsegs_per_wq);
+	xdpi_fifo->xi = kvzalloc_node(size, GFP_KERNEL, numa);
 	if (!xdpi_fifo->xi)
 		return -ENOMEM;
 
@@ -946,10 +947,11 @@ static int mlx5e_alloc_xdpsq_fifo(struct mlx5e_xdpsq *sq, int numa)
 static int mlx5e_alloc_xdpsq_db(struct mlx5e_xdpsq *sq, int numa)
 {
 	int wq_sz = mlx5_wq_cyc_get_size(&sq->wq);
+	size_t size;
 	int err;
 
-	sq->db.wqe_info = kvzalloc_node(sizeof(*sq->db.wqe_info) * wq_sz,
-					GFP_KERNEL, numa);
+	size = array_size(sizeof(*sq->db.wqe_info), wq_sz);
+	sq->db.wqe_info = kvzalloc_node(size, GFP_KERNEL, numa);
 	if (!sq->db.wqe_info)
 		return -ENOMEM;
 
-- 
2.31.1

