Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4830A339A09
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbhCLXjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:39:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:32790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235812AbhCLXi6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:38:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B53464F5E;
        Fri, 12 Mar 2021 23:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615592338;
        bh=AToiMjuvf7q5MNlYrDuWplOjwxdjkej4TyVig2MDdo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4JG3CRPInEstvhHxaKFN/4IweDaKDY93h4huht5YLjqszdfEzmU/s5S/N562VZth
         WS+PhsqN9j09F5VWoKQVWpTJCuI1ebePxxz9eT7wvG2wDKrTRieKUIYGdTHS0Y/8tH
         FLTfZMjR5ETiVQsV8fcoWmQikqPPWTwdJCgtrRnOLQZ7DVR0F8vNhbs3xqTE0k8LiQ
         EqmnHHHpwuJejmHAId+uV5y8rLzbiPekKuboms0driStD+WQ+s91izT1yD0xmUQ/RM
         Otl9PY4+T6J1hEjZZGRcfsm4EQf0dHBcuTYo04qUtCpvtYh9j4lQUCfCravaGak8p5
         w3YnOMJ1FqanA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: [net-next 06/13] net/mlx5: Read congestion counters from all ports when lag is active
Date:   Fri, 12 Mar 2021 15:38:44 -0800
Message-Id: <20210312233851.494832-7-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312233851.494832-1-saeed@kernel.org>
References: <20210312233851.494832-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

Read congestion counters from all ports in any lag mode rather than
only in RoCE lag mode (e.g., VF lag).

Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 83a05371e2aa..127bb92da150 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -768,7 +768,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 
 	spin_lock(&lag_lock);
 	ldev = mlx5_lag_dev_get(dev);
-	if (ldev && __mlx5_lag_is_roce(ldev)) {
+	if (ldev && __mlx5_lag_is_active(ldev)) {
 		num_ports = MLX5_MAX_PORTS;
 		mdev[MLX5_LAG_P1] = ldev->pf[MLX5_LAG_P1].dev;
 		mdev[MLX5_LAG_P2] = ldev->pf[MLX5_LAG_P2].dev;
-- 
2.29.2

