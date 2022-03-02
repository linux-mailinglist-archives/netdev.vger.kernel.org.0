Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C090C4C9A40
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 02:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbiCBBDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 20:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiCBBDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 20:03:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA56220C3;
        Tue,  1 Mar 2022 17:02:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 273B36159F;
        Wed,  2 Mar 2022 01:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76344C340F3;
        Wed,  2 Mar 2022 01:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646182946;
        bh=TQAJQbjyWV4JMwUwseuG0w73QjUd7yOWzDkU+uUu3Vg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qg7GtMJkxm2i3XkEAl4kkMT9IvWQA9jd9b8232zgWAnlVJLXKEgFYrJMkb0TYiLd1
         S4uJExFVTK8nunBzRhdKNpJar53ZNl/DFVVA4T7CJ4rzSCmhgPU8oIDkFBEcZVKghX
         OIst8wxvJsOx6jDKG4hMDYIDJcRJoalDVsiAWHOrGD4mAS+GvwNI99Yo/pWQqz7voy
         1kJP0ZL8h82x8xsSJT0WqSkUiSKaQfxIosH/x/2IQYWFyjROQAQ8Gfn/uQN0nDIqoN
         3PfTyjZiTyGeys9cP1HHQ+1jF6RJA4qDuQPrPKFwhNUq+GoJAy5wTs3OJ69L8CKTFu
         CuHcU/UHfpqfQ==
Date:   Tue, 1 Mar 2022 17:02:25 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        ttoukan.linux@gmail.com, brouer@redhat.com, leon@kernel.org,
        linux-rdma@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [net-next v8 4/4] mlx5: add support for page_pool_get_stats
Message-ID: <20220302010225.dlhj3mtikog63zxz@sx1>
References: <1646172610-129397-1-git-send-email-jdamato@fastly.com>
 <1646172610-129397-5-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1646172610-129397-5-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01 Mar 14:10, Joe Damato wrote:
>This change adds support for the page_pool_get_stats API to mlx5. If the
>user has enabled CONFIG_PAGE_POOL_STATS in their kernel, ethtool will
>output page pool stats.
>

I was hoping to see something other than ethtool, a driver-less approach,
page_pool is a first class citizen, it collects own stats and should be
able to report own stats without the need for driver help.

I understand these stats are per driver ring, but we can always come up with
a naming convention in the page pool to allow correlating page-pool stats
with per ring driver stats.

Anyway i can't think of a simple hack, so this patch is a good temporary
compromise until we come up with the right approach.

>Signed-off-by: Joe Damato <jdamato@fastly.com>
>---
> drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 75 ++++++++++++++++++++++
> drivers/net/ethernet/mellanox/mlx5/core/en_stats.h | 27 +++++++-
> 2 files changed, 101 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
>index 3e5d8c7..eb518ec 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
>@@ -37,6 +37,10 @@
> #include "en/ptp.h"
> #include "en/port.h"
>
>+#ifdef CONFIG_PAGE_POOL_STATS
>+#include <net/page_pool.h>
>+#endif
>+
> static unsigned int stats_grps_num(struct mlx5e_priv *priv)
> {
> 	return !priv->profile->stats_grps_num ? 0 :
>@@ -183,6 +187,19 @@ static const struct counter_desc sw_stats_desc[] = {
> 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_congst_umr) },
> 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_arfs_err) },
> 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_recover) },
>+#ifdef CONFIG_PAGE_POOL_STATS
>+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_fast) },
>+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_slow) },
>+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_slow_high_order) },
>+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_empty) },
>+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_refill) },
>+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_waive) },
>+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_cached) },
>+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_cache_full) },
>+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_ring) },
>+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_ring_full) },
>+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_released_ref) },
>+#endif
> #ifdef CONFIG_MLX5_EN_TLS
> 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_packets) },
> 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_bytes) },
>@@ -349,6 +366,19 @@ static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
> 	s->rx_congst_umr              += rq_stats->congst_umr;
> 	s->rx_arfs_err                += rq_stats->arfs_err;
> 	s->rx_recover                 += rq_stats->recover;
>+#ifdef CONFIG_PAGE_POOL_STATS
>+	s->rx_pp_alloc_fast          += rq_stats->pp_alloc_fast;
>+	s->rx_pp_alloc_slow          += rq_stats->pp_alloc_slow;
>+	s->rx_pp_alloc_empty         += rq_stats->pp_alloc_empty;
>+	s->rx_pp_alloc_refill        += rq_stats->pp_alloc_refill;
>+	s->rx_pp_alloc_waive         += rq_stats->pp_alloc_waive;
>+	s->rx_pp_alloc_slow_high_order		+= rq_stats->pp_alloc_slow_high_order;
>+	s->rx_pp_recycle_cached			+= rq_stats->pp_recycle_cached;
>+	s->rx_pp_recycle_cache_full		+= rq_stats->pp_recycle_cache_full;
>+	s->rx_pp_recycle_ring			+= rq_stats->pp_recycle_ring;
>+	s->rx_pp_recycle_ring_full		+= rq_stats->pp_recycle_ring_full;
>+	s->rx_pp_recycle_released_ref		+= rq_stats->pp_recycle_released_ref;
>+#endif
> #ifdef CONFIG_MLX5_EN_TLS
> 	s->rx_tls_decrypted_packets   += rq_stats->tls_decrypted_packets;
> 	s->rx_tls_decrypted_bytes     += rq_stats->tls_decrypted_bytes;
>@@ -455,6 +485,35 @@ static void mlx5e_stats_grp_sw_update_stats_qos(struct mlx5e_priv *priv,
> 	}
> }
>
>+#ifdef CONFIG_PAGE_POOL_STATS
>+static void mlx5e_stats_update_stats_rq_page_pool(struct mlx5e_channel *c)
>+{
>+	struct mlx5e_rq_stats *rq_stats = c->rq.stats;
>+	struct page_pool *pool = c->rq.page_pool;
>+	struct page_pool_stats stats = { 0 };
>+
you can drop the 0, just {} should be enough.

>+	if (!page_pool_get_stats(pool, &stats))
>+		return;
>+

you can contain the whole page_pool_stats objects inside rq_stats object,
and avoid all the assignments below.

just do:
    page_pool_get_stats(pool, &rq_stats.pp);
    return;

>+	rq_stats->pp_alloc_fast = stats.alloc_stats.fast;
>+	rq_stats->pp_alloc_slow = stats.alloc_stats.slow;
>+	rq_stats->pp_alloc_slow_high_order = stats.alloc_stats.slow_high_order;
>+	rq_stats->pp_alloc_empty = stats.alloc_stats.empty;
>+	rq_stats->pp_alloc_waive = stats.alloc_stats.waive;
>+	rq_stats->pp_alloc_refill = stats.alloc_stats.refill;
>+
>+	rq_stats->pp_recycle_cached = stats.recycle_stats.cached;
>+	rq_stats->pp_recycle_cache_full = stats.recycle_stats.cache_full;
>+	rq_stats->pp_recycle_ring = stats.recycle_stats.ring;
>+	rq_stats->pp_recycle_ring_full = stats.recycle_stats.ring_full;
>+	rq_stats->pp_recycle_released_ref = stats.recycle_stats.released_refcnt;
>+}
>+#else
>+static void mlx5e_stats_update_stats_rq_page_pool(struct mlx5e_channel *c)
>+{
>+}
>+#endif
