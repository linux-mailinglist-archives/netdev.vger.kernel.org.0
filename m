Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EA66BC051
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbjCOW7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbjCOW7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F598F735
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DECD61E98
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D00C433D2;
        Wed, 15 Mar 2023 22:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921137;
        bh=kb3uOPzGjYwhDUgntULYKlyfqkzEutZa9UVxynrndpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJbjFXfDwcU/ENKJiPo7YmkfoFuZzodGyWpau1DGe9G84Nk69am6WdkbY/Aj52mN/
         t6EMpUV3vXsCgi5E27eknQJUkxS/U3PmcFC9XuPzqL4SNdT959tac0nPx/ZhKmEVnd
         SVxgkYpGLFoWVqkzlJJ7AHd5BbW78hKcaO/7LY8LJdxvrE6UdQUHEAf/3xpCXNJmzs
         Oz0BcROaJM2tCvt1NLU7g8O38VUXFgUQi6fjULDhKVuCRIzwcKsBQBjl6z79GAJrGt
         l6hFUmJ2bvQonxrdyrv3NLcGZLBwPk3wkuL5XKbFxP36/zN8QcQK5vfj8kbJ4jau8w
         WAtxXr7fmKvwg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: [net V2 11/14] net/sched: TC, fix raw counter initialization
Date:   Wed, 15 Mar 2023 15:58:44 -0700
Message-Id: <20230315225847.360083-12-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315225847.360083-1-saeed@kernel.org>
References: <20230315225847.360083-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@nvidia.com>

Freed counters may be reused by fs core.
As such, raw counters may not be initialized to zero.

Cache the counter values when the action stats object is initialized to
have a proper base value for calculating the difference from the previous
query.

Fixes: 2b68d659a704 ("net/mlx5e: TC, support per action stats")
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
index 626cb7470fa5..07c1895a2b23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
@@ -64,6 +64,7 @@ mlx5e_tc_act_stats_add(struct mlx5e_tc_act_stats_handle *handle,
 {
 	struct mlx5e_tc_act_stats *act_stats, *old_act_stats;
 	struct rhashtable *ht = &handle->ht;
+	u64 lastused;
 	int err = 0;
 
 	act_stats = kvzalloc(sizeof(*act_stats), GFP_KERNEL);
@@ -73,6 +74,10 @@ mlx5e_tc_act_stats_add(struct mlx5e_tc_act_stats_handle *handle,
 	act_stats->tc_act_cookie = act_cookie;
 	act_stats->counter = counter;
 
+	mlx5_fc_query_cached_raw(counter,
+				 &act_stats->lastbytes,
+				 &act_stats->lastpackets, &lastused);
+
 	rcu_read_lock();
 	old_act_stats = rhashtable_lookup_get_insert_fast(ht,
 							  &act_stats->hash,
-- 
2.39.2

