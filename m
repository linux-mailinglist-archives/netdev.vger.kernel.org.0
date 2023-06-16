Return-Path: <netdev+bounces-11580-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53D15733A5C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:05:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 853931C21085
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69DAE209BF;
	Fri, 16 Jun 2023 20:01:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C095209B6
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC1EC43215;
	Fri, 16 Jun 2023 20:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686945695;
	bh=75AtcKkgZXWpMRyDvb85+ZL+zonSdTWx/okyXKNkmzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9jlPLH2v/hozkzROU3LOPkrvzCJAXxcpFqI7b7D0wrSo81iJtUSavVyklhcvCPp0
	 HPbwgWFoLVyaGh4tOF/Du/2hC/dRdb1CGta5L2hUQD2u44Jm+KfkjgieiUiy/PfoKs
	 68ps940s+7yhvgK+daC5b7a2+9goTJBSgL0VfQ6rfHaUSvjjjfRtezgGvwtYiogAcd
	 6K3iIfH5uTclH7E6sx572Cna+1z7PtWaNwOq202W2pm/+t3XncfMn2HwudYW/G4zWn
	 RyRgomkM+uYzZmB68LRB7p8YPXJNbK1Z3JZ9wHu/5sQZ+SFCDQ+MP0/iECz6FrCArp
	 LG+u6ITDYgdTQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [net 11/12] net/mlx5e: Drop XFRM state lock when modifying flow steering
Date: Fri, 16 Jun 2023 13:01:18 -0700
Message-Id: <20230616200119.44163-12-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616200119.44163-1-saeed@kernel.org>
References: <20230616200119.44163-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

XFRM state which is changed to be XFRM_STATE_EXPIRED doesn't really
need to hold lock while modifying flow steering rules to drop traffic.

That state can be deleted only and as such mlx5e_ipsec_handle_tx_limit()
work will be canceled anyway and won't run in parallel.

Fixes: b2f7b01d36a9 ("net/mlx5e: Simulate missing IPsec TX limits hardware functionality")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c    | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index d1c801723d35..891d39b4bfd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -61,16 +61,19 @@ static void mlx5e_ipsec_handle_tx_limit(struct work_struct *_work)
 	struct mlx5e_ipsec_sa_entry *sa_entry = dwork->sa_entry;
 	struct xfrm_state *x = sa_entry->x;
 
-	spin_lock(&x->lock);
+	if (sa_entry->attrs.drop)
+		return;
+
+	spin_lock_bh(&x->lock);
 	xfrm_state_check_expire(x);
 	if (x->km.state == XFRM_STATE_EXPIRED) {
 		sa_entry->attrs.drop = true;
-		mlx5e_accel_ipsec_fs_modify(sa_entry);
-	}
-	spin_unlock(&x->lock);
+		spin_unlock_bh(&x->lock);
 
-	if (sa_entry->attrs.drop)
+		mlx5e_accel_ipsec_fs_modify(sa_entry);
 		return;
+	}
+	spin_unlock_bh(&x->lock);
 
 	queue_delayed_work(sa_entry->ipsec->wq, &dwork->dwork,
 			   MLX5_IPSEC_RESCHED);
-- 
2.40.1


