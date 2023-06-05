Return-Path: <netdev+bounces-7900-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80E4572209A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:10:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBF081C20B7E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FBC5125CD;
	Mon,  5 Jun 2023 08:10:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D989C11CAE
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC13C4339E;
	Mon,  5 Jun 2023 08:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685952604;
	bh=5iov22buVFICyxnzTciqk7t42nhxP2GxNdjPThuX5AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwgwUX01SIljDAeLnxWfrsobkXw89iJb+/s/bC/b2uyMH5o1hKNQgTPpPAfJnw/KZ
	 tkEWLr68BDMPDK+llC4ArFEwPSYUyitFbFXDNgi9pnfBCSmWwGylJW+SUP/+oHRu8X
	 zXDnjLrcGn0dAQFAvWw4tYgQjQyfmg2XFroIuaOT6WVgQbNYqoT6ALttLQHH9qB/ug
	 jTqvu5mpppUscsYBbaEaFERA4q7I9GQOn8t/WQwDNjh++L6GEhcKeghsM3/9DJmy0s
	 IvfRrcelMT/qg07tMtGKGgerPIcCv92fwPLIdA4ktJ8vFHGjPZbmbX9WuV0Gd5f68h
	 D9RzlEjTUzWDQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Raed Salem <raeds@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net 3/4] net/mlx5e: Drop XFRM state lock when modifying flow steering
Date: Mon,  5 Jun 2023 11:09:51 +0300
Message-Id: <63612a659fe38ec043f2f791acb95ab3134e577d.1685950599.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685950599.git.leonro@nvidia.com>
References: <cover.1685950599.git.leonro@nvidia.com>
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


