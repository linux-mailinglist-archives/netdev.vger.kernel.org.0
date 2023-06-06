Return-Path: <netdev+bounces-8285-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A82723880
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:12:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EC6A1C20D13
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1805689;
	Tue,  6 Jun 2023 07:12:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157D2566E
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DE7C433D2;
	Tue,  6 Jun 2023 07:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686035550;
	bh=LvJ3Nqcwx2ubTY72fUCes0Oz3BY+iZ9j20J0IG69fCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZUhdFYvNzdOuokcbi7lpllfMb+RBoR41UkANJsb1/b5Jf1kz4SCveTA4cTfnwW+e
	 KFcERgf9+pBd8WeRNFsgGnxHEk3v28fz+3Ohgp4PtENGTS8V/XZCg2/yCiYWDObE0C
	 qYhNrDw8EJatfWtP8p5halQGcKUdzN+ewshKcV4G3IG3lky8AGzET97QLD9GdwEf6c
	 zcGeQGqiACnSfD97WFz1YQ1KK3x78xkDCxA6zwW0UzU3xdLyqHHK9juvvsfCQicEoI
	 M8QEQgGNh9uaJe3yxUeXu5ubza25d1c7agKaMdnQfz+7wlN+HvSItCMYKUNFMq+sip
	 iJ9db1mwcClgg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 01/15] RDMA/mlx5: Free second uplink ib port
Date: Tue,  6 Jun 2023 00:12:05 -0700
Message-Id: <20230606071219.483255-2-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606071219.483255-1-saeed@kernel.org>
References: <20230606071219.483255-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

The cited patch introduce ib port for the slave device uplink in
case of multiport eswitch. However, this ib port didn't perform
anything when unloaded.
Unload the new ib port properly.

Fixes: 27f9e0ccb6da ("net/mlx5: Lag, Add single RDMA device in multiport mode")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index ddcfc116b19a..a4db22fe1883 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -126,7 +126,7 @@ mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	    !mlx5_lag_is_master(mdev)) {
 		struct mlx5_core_dev *peer_mdev;
 
-		if (rep->vport == MLX5_VPORT_UPLINK)
+		if (rep->vport == MLX5_VPORT_UPLINK && !mlx5_lag_is_mpesw(mdev))
 			return;
 		peer_mdev = mlx5_lag_get_peer_mdev(mdev);
 		vport_index += mlx5_eswitch_get_total_vports(peer_mdev);
@@ -146,6 +146,9 @@ mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 		struct mlx5_core_dev *peer_mdev;
 		struct mlx5_eswitch *esw;
 
+		if (mlx5_lag_is_shared_fdb(mdev) && !mlx5_lag_is_master(mdev))
+			return;
+
 		if (mlx5_lag_is_shared_fdb(mdev)) {
 			peer_mdev = mlx5_lag_get_peer_mdev(mdev);
 			esw = peer_mdev->priv.eswitch;
-- 
2.40.1


