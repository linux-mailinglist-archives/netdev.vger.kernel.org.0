Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03D041B9A0
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242890AbhI1Vvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241482AbhI1Vvs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 17:51:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3799C6127A;
        Tue, 28 Sep 2021 21:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632865808;
        bh=OHwpnjwm82cj6sJjtQtvCN3PkpAY98SAptr+7neTpeA=;
        h=Date:From:To:Cc:Subject:From;
        b=GOHttJZ8dM0gRk1EolNJ3bxuhNWc75vnpW/Yzpt8Ii3gRolWMvdQfavyXhdhnMBY7
         yvbrehz/jQCus9ZiTkggNVk7FfHHtfpKkRAXSv7RkBzOxYX6qqB8V4r4h1k2J56M5r
         Uk7BJ/lH39jgjqsmGJA1O2cJmnP07AwMJRtXhGqXDPCMn/01w4qmgm38q0Kvh1+fG2
         d6aFXcI70saF869FLR/E6zV6kgchD6Wc+uqXrAEHGBODkrtarn/fHnD28+x/jvyfba
         UzuPubxBgHifGe56rIi8eC8+4oxFuUdpQ5IgA2bpslMAZ9Ijj8hQ1ZREi4nu2xBu9H
         A2OQABoVKehGQ==
Date:   Tue, 28 Sep 2021 16:54:10 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][net-next] net/mlx5e: Use array_size() helper
Message-ID: <20210928215410.GA275646@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use array_size() helper to aid in 2-factor allocation instances.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
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
2.27.0

