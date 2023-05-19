Return-Path: <netdev+bounces-3977-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FA4D709EA6
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 287811C2132D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F10C413AC6;
	Fri, 19 May 2023 17:56:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07B312B7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8266EC433EF;
	Fri, 19 May 2023 17:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518973;
	bh=LUOmJfdUAr7N2kDDfKVZOBjGVwjrwGkBep1Y2soV4zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbhavPqfA3ZPwv8a1J05n1dPirEtVwHDf8xYhOlIyK3+9tiHx3t6CcFGKx4ahRdvw
	 YLmi5z2TvXtptLOKNupZTUdscWNhNzzBkqOSxSNHN46lpzMwVVPkvCnyN/6EuqSuZ+
	 4mIL9gCS7TzCBZzrG7BUhbqiiHmcQ3BNUnJZg86XGns5jK7WkXhqJqmYuLvFflNxcC
	 l+BdWp7uUgQr+9wb19mj0X5sLK+2q9daAcmBqmq62h0oXgLxjSABHPwNtSpkaK+1rR
	 dY/H8AURnsytaAYBWovzMjdaYZjP8CRd1AwhPdaZR11aUmb7OAlabeR0grDD6vEOzv
	 4fmvSmXAdhpxA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: E-Switch, Update when to set other vport context
Date: Fri, 19 May 2023 10:55:47 -0700
Message-Id: <20230519175557.15683-6-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519175557.15683-1-saeed@kernel.org>
References: <20230519175557.15683-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

Other vport context should be set if vport number is not 0.
In case of ECPF, vport 0 represents the host PF representor so also
need to set other vport context.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c        | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c          | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
index 45b839116212..d599e50af346 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
@@ -35,7 +35,8 @@ esw_acl_table_create(struct mlx5_eswitch *esw, struct mlx5_vport *vport, int ns,
 	}
 
 	ft_attr.max_fte = size;
-	ft_attr.flags = MLX5_FLOW_TABLE_OTHER_VPORT;
+	if (vport_num || mlx5_core_is_ecpf(esw->dev))
+		ft_attr.flags = MLX5_FLOW_TABLE_OTHER_VPORT;
 	acl = mlx5_create_vport_flow_table(root_ns, &ft_attr, vport_num);
 	if (IS_ERR(acl)) {
 		err = PTR_ERR(acl);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 901c53751b0a..bf97a593d1d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -113,7 +113,8 @@ static int arm_vport_context_events_cmd(struct mlx5_core_dev *dev, u16 vport,
 		 opcode, MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
 	MLX5_SET(modify_nic_vport_context_in, in, field_select.change_event, 1);
 	MLX5_SET(modify_nic_vport_context_in, in, vport_number, vport);
-	MLX5_SET(modify_nic_vport_context_in, in, other_vport, 1);
+	if (vport || mlx5_core_is_ecpf(dev))
+		MLX5_SET(modify_nic_vport_context_in, in, other_vport, 1);
 	nic_vport_ctx = MLX5_ADDR_OF(modify_nic_vport_context_in,
 				     in, nic_vport_context);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index ba7e3df22413..bc66b078a8a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -288,7 +288,8 @@ int mlx5_query_nic_vport_mac_list(struct mlx5_core_dev *dev,
 		 MLX5_CMD_OP_QUERY_NIC_VPORT_CONTEXT);
 	MLX5_SET(query_nic_vport_context_in, in, allowed_list_type, list_type);
 	MLX5_SET(query_nic_vport_context_in, in, vport_number, vport);
-	MLX5_SET(query_nic_vport_context_in, in, other_vport, 1);
+	if (vport || mlx5_core_is_ecpf(dev))
+		MLX5_SET(query_nic_vport_context_in, in, other_vport, 1);
 
 	err = mlx5_cmd_exec(dev, in, sizeof(in), out, out_sz);
 	if (err)
-- 
2.40.1


