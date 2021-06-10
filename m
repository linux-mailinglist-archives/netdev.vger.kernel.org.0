Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5943A2276
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhFJDAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhFJDAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 300EA61424;
        Thu, 10 Jun 2021 02:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293902;
        bh=a186X5VBGSAGg7rPQ4EQxyHwpMxglZt8Sjr76giOYFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uf0AZ1CrAlhT3wY45HdDV89K+o4hrcEvEMXhNEx+CakEf883E0x55HK0tqvtRVzT9
         CMGPtlZO8v3imzv0gg6ahfaLxJovQEQlS1qD7J4ayzdRmu56tZdieyxsnRUxC45fAi
         4dIfrOsPALVApnFMzofFI4cvK8d02/6VdrBWckLItMhRX+PIAR2XkgWUH+DsIItx7S
         rQAGKZUl83nmmjM1Pohkab/pz8AcwnkxvikKE//v7gvsWHS6gLbY5UGEKi3fdVu5eB
         JzSDy/JERifjjMWIHZSlGQMfvJj10WSErGdsb8auPk0uibBZHpSEzVB7a5ud0YQAyT
         2MVbXm4WRBYhw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/16] net/mlx5e: Refactor mlx5e_eswitch_{*}rep() helpers
Date:   Wed,  9 Jun 2021 19:58:06 -0700
Message-Id: <20210610025814.274607-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Change the helper to functions to accept constant pointer to struct
net_device. This is necessary for following patches in series that pass
mlx5e_eswitch_rep() as a callback to kernel bridge infrastructure code.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 34eb1118670f..40db54412041 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -536,13 +536,13 @@ static const struct net_device_ops mlx5e_netdev_ops_rep = {
 	.ndo_change_carrier      = mlx5e_rep_change_carrier,
 };
 
-bool mlx5e_eswitch_uplink_rep(struct net_device *netdev)
+bool mlx5e_eswitch_uplink_rep(const struct net_device *netdev)
 {
 	return netdev->netdev_ops == &mlx5e_netdev_ops &&
 	       mlx5e_is_uplink_rep(netdev_priv(netdev));
 }
 
-bool mlx5e_eswitch_vf_rep(struct net_device *netdev)
+bool mlx5e_eswitch_vf_rep(const struct net_device *netdev)
 {
 	return netdev->netdev_ops == &mlx5e_netdev_ops_rep;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 22585015c7a7..47a2dfb7792a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -231,9 +231,9 @@ void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv);
 
 void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
 
-bool mlx5e_eswitch_vf_rep(struct net_device *netdev);
-bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
-static inline bool mlx5e_eswitch_rep(struct net_device *netdev)
+bool mlx5e_eswitch_vf_rep(const struct net_device *netdev);
+bool mlx5e_eswitch_uplink_rep(const struct net_device *netdev);
+static inline bool mlx5e_eswitch_rep(const struct net_device *netdev)
 {
 	return mlx5e_eswitch_vf_rep(netdev) ||
 	       mlx5e_eswitch_uplink_rep(netdev);
-- 
2.31.1

