Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F80F6B9D78
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjCNRuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjCNRuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:50:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A13AB893
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F72CB81ACB
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 17:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA65C4339B;
        Tue, 14 Mar 2023 17:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678816196;
        bh=kb3uOPzGjYwhDUgntULYKlyfqkzEutZa9UVxynrndpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgw6JSN7WQsTzdyQCp3lvYnjAviR/oWTLTyucIDDbu8fPddgBKftJdcRAY+dmC8iX
         tp9pOGV3ASYZv0whQvQOqOyOdI2i9goRT5UtBzJfXtJd2IqUrBFkjzch8dqfKReZNS
         sHTo3a0q5u3YLGBkzYG5XKxVJIEY80fRpFbXamKOHJN9GmShELqgwJ9jLWZL17mGNq
         TUByY0B43Z1wJX3ipSukqXLE5arYgbRC9E/d8bOsUYMAtbDcR4U0yHOVrwlx3A2FBv
         58NSbP9OB61vHDBOnlMBxz/fYaupFnKqVGCCyHMxz+1aCfjyA9FkOdnfgzfvs2Zb+C
         8cvhvDT2az/lg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: [net 11/14] net/sched: TC, fix raw counter initialization
Date:   Tue, 14 Mar 2023 10:49:37 -0700
Message-Id: <20230314174940.62221-12-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314174940.62221-1-saeed@kernel.org>
References: <20230314174940.62221-1-saeed@kernel.org>
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

