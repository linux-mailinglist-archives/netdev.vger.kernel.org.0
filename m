Return-Path: <netdev+bounces-11601-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23300733A9D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:15:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBB03280F23
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD7922600;
	Fri, 16 Jun 2023 20:11:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904711ED58
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EADC433C9;
	Fri, 16 Jun 2023 20:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946306;
	bh=6OpojD3Xe+AnBZcW3gSPYy8ClR4/NRvqsXse+WOTvc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Al/F10A6aCya2mmAHvod/FR/JAwelo72tcFXSeckgIAvubdL/VFl9z/5c+0t/1yVP
	 di/a5h7MtxuMYnpuzbhFPj9Jl5RG7Z+5OpCDpUx6vNC8T8nJDSaFCakAsB6v0OD4mw
	 h9aonlOqRAESBAz8kQSUXtPqmoIiTn3QtoD5H9SYkU7kU0EFP2xoZC5mlEY+kwsI5M
	 PPcpZMpni/ZgB7Fh0mHbvHQYsLxcVutIWPGDzzyldTJ67wyBJw0gDdXt0hyaYD6TNS
	 xgnSCm4j4IsRrbbFwu3nOlJ3wx5Hj0QYvtqW+V+xiVlj8ccBzdoNjMRd02bG5ljmUf
	 tSHH/uMmK0r+w==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>
Subject: [net-next 12/15] net/mlx5: Fix the macro for accessing EC VF vports
Date: Fri, 16 Jun 2023 13:11:10 -0700
Message-Id: <20230616201113.45510-13-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616201113.45510-1-saeed@kernel.org>
References: <20230616201113.45510-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Jurgens <danielj@nvidia.com>

The last value is not set correctly. This results in representors not
being created for all EC VFs when the base value is higher than 0.

Fixes: a7719b29a821 ("net/mlx5: Add management of EC VF vports")
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index bcbab06759c4..7064609f4998 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -668,6 +668,7 @@ void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw);
 			  index,					\
 			  vport,					\
 			  MLX5_CAP_GEN_2((esw->dev), ec_vf_vport_base),	\
+			  MLX5_CAP_GEN_2((esw->dev), ec_vf_vport_base) +\
 			  (last) - 1)
 
 struct mlx5_eswitch *mlx5_devlink_eswitch_get(struct devlink *devlink);
-- 
2.40.1


