Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BB23093A8
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhA3JrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:47:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233361AbhA3DIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:08:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1B5B64DE2;
        Sat, 30 Jan 2021 02:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973590;
        bh=oCyKJ1cLNxE/k0y0GraCVl4B+H7EkvSw2dMFBNu8rJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnyRAfdkcVyTEhUl1YMYohyLNO9JnvHxQjfBawHpQEZTqFpJL1qumsvZCAC67LVt3
         nAWfJd0sQ6B4Kkvd6a1X7wP9/9PprSp76GLfWi03t+OXjLBqlUSKWEzxt07/EUn8mI
         1tNey6m+pJtgrjA+qSfL1Wiqc0cbIizlh8To9gryZUrg16L6Q/2cm8jcj4FLap/mgK
         Ri7R5z8zvbuamZMaSRXfCpqlCdROyXgSK57Qf2E8BeacjTXwR5n45aQbgEJ48LMrSv
         k+cEk+FPUi8Z8V2RPOH0Q+I02iRa/lan99HqDpS/flxBOf2a86JQtGLuidVrJ5Xl9r
         U1n/y7z/LI0yw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/11] net/mlx5: DR, Allow native protocol support for HW STEv1
Date:   Fri, 29 Jan 2021 18:26:11 -0800
Message-Id: <20210130022618.317351-5-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210130022618.317351-1-saeed@kernel.org>
References: <20210130022618.317351-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Some flex parser protocols are native as part of STEv1.
The check for supported protocols was modified to allow this.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c         | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index e3a002983c26..15673cd10039 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -113,7 +113,8 @@ dr_mask_is_vxlan_gpe_set(struct mlx5dr_match_misc3 *misc3)
 static bool
 dr_matcher_supp_vxlan_gpe(struct mlx5dr_cmd_caps *caps)
 {
-	return caps->flex_protocols & MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED;
+	return (caps->sw_format_ver == MLX5_STEERING_FORMAT_CONNECTX_6DX) ||
+	       (caps->flex_protocols & MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED);
 }
 
 static bool
@@ -135,7 +136,8 @@ static bool dr_mask_is_tnl_geneve_set(struct mlx5dr_match_misc *misc)
 static bool
 dr_matcher_supp_tnl_geneve(struct mlx5dr_cmd_caps *caps)
 {
-	return caps->flex_protocols & MLX5_FLEX_PARSER_GENEVE_ENABLED;
+	return (caps->sw_format_ver == MLX5_STEERING_FORMAT_CONNECTX_6DX) ||
+	       (caps->flex_protocols & MLX5_FLEX_PARSER_GENEVE_ENABLED);
 }
 
 static bool
@@ -148,12 +150,14 @@ dr_mask_is_tnl_geneve(struct mlx5dr_match_param *mask,
 
 static int dr_matcher_supp_icmp_v4(struct mlx5dr_cmd_caps *caps)
 {
-	return caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V4_ENABLED;
+	return (caps->sw_format_ver == MLX5_STEERING_FORMAT_CONNECTX_6DX) ||
+	       (caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V4_ENABLED);
 }
 
 static int dr_matcher_supp_icmp_v6(struct mlx5dr_cmd_caps *caps)
 {
-	return caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V6_ENABLED;
+	return (caps->sw_format_ver == MLX5_STEERING_FORMAT_CONNECTX_6DX) ||
+	       (caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V6_ENABLED);
 }
 
 static bool dr_mask_is_icmpv6_set(struct mlx5dr_match_misc3 *misc3)
-- 
2.29.2

