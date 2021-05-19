Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B908738874A
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239202AbhESGHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238492AbhESGH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5DAB613AD;
        Wed, 19 May 2021 06:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404369;
        bh=ImTkEi17xnztBrf4rHv3vHo2rR/vYYEqHmeCwa4w3hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKei46rjABS9Yvp+yxcpiFZzG5t0L1+khWdY0pOwp+Y7q1PXP0xwURcJWK5oWERRx
         f0ULWrmFYQ7CVYDae2Gu2+fUhWbKkPJxoQc3YOAiqxtrAaG2I7Em4VktU95gKXq6P7
         1DjRTvkwtQrvBtIKeq2QOXldqrdmcX1zKDWK8HhZKP90f/K7Sp+Hr0eKc5nu9AkaHY
         2EM43NjfeJl8P91dzCsmfrBZvaRIhebIlnqsdjH7TfAdkcI99w1kAK2DB3fHKreqDa
         NCp7E0LvjU1AsJ44UOSmyNkCaxE7TeMS+tfZmM8biZFw3QAze4k5uAy1Z2xp5AOcjq
         2+ZBUXFI4S2Iw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Dennis Afanasev <dennis.afanasev@stateless.net>,
        Maor Dickman <maord@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/16] net/mlx5e: Make sure fib dev exists in fib event
Date:   Tue, 18 May 2021 23:05:15 -0700
Message-Id: <20210519060523.17875-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

For unreachable route entry the fib dev does not exists.

Fixes: 8914add2c9e5 ("net/mlx5e: Handle FIB events to update tunnel endpoint device")
Reported-by: Dennis Afanasev <dennis.afanasev@stateless.net>
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 593503bc4d07..f1fb11680d20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1505,7 +1505,7 @@ mlx5e_init_fib_work_ipv4(struct mlx5e_priv *priv,
 
 	fen_info = container_of(info, struct fib_entry_notifier_info, info);
 	fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
-	if (fib_dev->netdev_ops != &mlx5e_netdev_ops ||
+	if (!fib_dev || fib_dev->netdev_ops != &mlx5e_netdev_ops ||
 	    fen_info->dst_len != 32)
 		return NULL;
 
-- 
2.31.1

