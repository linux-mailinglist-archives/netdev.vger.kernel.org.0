Return-Path: <netdev+bounces-9075-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 769B4727046
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:08:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2AE41C208E1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CC448249;
	Wed,  7 Jun 2023 21:04:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807F646FE4
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 21:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED92C433A8;
	Wed,  7 Jun 2023 21:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686171880;
	bh=8sCXY1B4DQd1o4Ka7KZAPoloKoGNpJo+CtM+mi4AaG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ph6ebfYVX1adlKz8CkzeWtCdhKFThpjADz5AlcCZHf54waBDHO+oOWSHavzBZjGdT
	 PQwrfu3uF3JL+6/6GSYgqqDKpXc37hQVUTlfOxsUtHOTX2SfRRSkeYMiTzQKRc6raM
	 MNr5Mz7inGVT8Liz7k/6QLsxn8fndu7rbW/X8Y6geeT0VTZjFN05eqHfTWVFmgWXV+
	 Klt1j9MI9afVs88GjSfRARoGGbbSkTzJ6i45cvgc5bw+9vGD8wMNBhjhQtvxQVb0gG
	 cS4L70MQuX3MPPF0ss1vjZoWAei7geknQJiKhyyTXGTIVYB7k+OCQZhZUwGNY3L91W
	 3vN3eQnQzZHfg==
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
	Oz Shlomo <ozsh@nvidia.com>,
	Paul Blakey <paulb@nvidia.com>
Subject: [net-next V2 11/14] net/mlx5e: TC, refactor access to hash key
Date: Wed,  7 Jun 2023 14:04:07 -0700
Message-Id: <20230607210410.88209-12-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607210410.88209-1-saeed@kernel.org>
References: <20230607210410.88209-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oz Shlomo <ozsh@nvidia.com>

Currently, a temp object is filled and used as a key for rhashtable_lookup.
Lookups will only works while key remains the first attribute in the
relevant rhashtable node object.

Fix this by passing a key, instead of a object containing the key.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c    | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
index 07c1895a2b23..7aa926e542d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
@@ -25,8 +25,8 @@ struct mlx5e_tc_act_stats {
 
 static const struct rhashtable_params act_counters_ht_params = {
 	.head_offset = offsetof(struct mlx5e_tc_act_stats, hash),
-	.key_offset = 0,
-	.key_len = offsetof(struct mlx5e_tc_act_stats, counter),
+	.key_offset = offsetof(struct mlx5e_tc_act_stats, tc_act_cookie),
+	.key_len = sizeof_field(struct mlx5e_tc_act_stats, tc_act_cookie),
 	.automatic_shrinking = true,
 };
 
@@ -169,14 +169,11 @@ mlx5e_tc_act_stats_fill_stats(struct mlx5e_tc_act_stats_handle *handle,
 {
 	struct rhashtable *ht = &handle->ht;
 	struct mlx5e_tc_act_stats *item;
-	struct mlx5e_tc_act_stats key;
 	u64 pkts, bytes, lastused;
 	int err = 0;
 
-	key.tc_act_cookie = fl_act->cookie;
-
 	rcu_read_lock();
-	item = rhashtable_lookup(ht, &key, act_counters_ht_params);
+	item = rhashtable_lookup(ht, &fl_act->cookie, act_counters_ht_params);
 	if (!item) {
 		rcu_read_unlock();
 		err = -ENOENT;
-- 
2.40.1


