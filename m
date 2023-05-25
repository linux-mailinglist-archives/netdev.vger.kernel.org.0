Return-Path: <netdev+bounces-5212-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C192C710384
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33A921C20E8D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EAAA8825;
	Thu, 25 May 2023 03:49:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE15A951
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B3CC433AA;
	Thu, 25 May 2023 03:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986558;
	bh=K7OMQCQoT1nyOVKZl6YgzwcCOIMMzDsOyvSyrnavl64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PssBGWF9riXmIQvvAjTu9noNITlbXJ+iyfv5kGU8KsVPGDoVq7zSg2s3wL6/0fb8L
	 vEF0aFO2zjYBkech9kMniKVS9fZLZsbwbAkGsXIlxoIFj7lvt0eh7/a8DpNyLEIIdg
	 sq+Su3AN7oXtSUNl/Ln0xa/LxHQgm1g9cz0VoPNghYt+ge3a47B4IFPJK6Z79ssUSM
	 abI0qtxaMWmfPbQjdjHS5oVbRWTIvM4lkaB6kQSIBI/+I9PZtywfOSidLZbD7j8n67
	 fGoeUrLG/Qdsj+OsYhArgRYF5ad4G5eZIzmRHgMwfP9bg0kvEqNlrZdQtgd27uO3ex
	 BC694rSYEk0Yw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [net 12/17] net/mlx5: DR, Add missing mutex init/destroy in pattern manager
Date: Wed, 24 May 2023 20:48:42 -0700
Message-Id: <20230525034847.99268-13-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525034847.99268-1-saeed@kernel.org>
References: <20230525034847.99268-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add missing mutex init/destroy as caught by the lock's debug warning:
 DEBUG_LOCKS_WARN_ON(lock->magic != lock)

Fixes: da5d0027d666 ("net/mlx5: DR, Add cache for modify header pattern")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c
index 13e06a6a6b22..d6947fe13d56 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c
@@ -213,6 +213,8 @@ struct mlx5dr_ptrn_mgr *mlx5dr_ptrn_mgr_create(struct mlx5dr_domain *dmn)
 	}
 
 	INIT_LIST_HEAD(&mgr->ptrn_list);
+	mutex_init(&mgr->modify_hdr_mutex);
+
 	return mgr;
 
 free_mgr:
@@ -237,5 +239,6 @@ void mlx5dr_ptrn_mgr_destroy(struct mlx5dr_ptrn_mgr *mgr)
 	}
 
 	mlx5dr_icm_pool_destroy(mgr->ptrn_icm_pool);
+	mutex_destroy(&mgr->modify_hdr_mutex);
 	kfree(mgr);
 }
-- 
2.40.1


