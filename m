Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04936CCBB0
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjC1U5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjC1U5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:57:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B094930E3
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:56:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37E44B81E71
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2456C433D2;
        Tue, 28 Mar 2023 20:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037016;
        bh=yMNLiTR8j04becl1ZR5ivLY3yitK6/gmHLnwTQHkQWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqBqkZNybGbVg4NfyleS2nB4IgpMVhGUSKfGb/w5hC2n+eYRaRq9MjGC613xyGZoh
         M6Cab1d0/4Qx7RfGUXQg/RLeDjJ6yQF1VGQ0TQCfdOFE9d0vr+rsPVeG5ZATAtFVyi
         gGp/6szWwg9VGYjC2eBn/BgY6bNsLijPd110CJ9GNK8EeSaSCnkV/vmfejW7blfEmV
         G64H2msew1YW9af4PAJ9DQEN/ZelpExEbh+9zkMvHqSvFe4XCoC5z0DX+eWY3NPo6m
         XujeNuuTOJXxlcChObxplTv/Tye6BoPUhPm0qAI2Q0t5mKEzYP9mVfW0FJkmcLzX6Z
         lVAQTFZoGlBnA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: RX, Change wqe last_in_page field from bool to bit flags
Date:   Tue, 28 Mar 2023 13:56:18 -0700
Message-Id: <20230328205623.142075-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230328205623.142075-1-saeed@kernel.org>
References: <20230328205623.142075-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

Change the bool flag to a bitfield as we'll use it in a downstream patch
in the series to add signaling about skipping a fragment release.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 566ddf7a7aa9..9ef4b7163e5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -605,13 +605,17 @@ struct mlx5e_frag_page {
 	u16 frags;
 };
 
+enum mlx5e_wqe_frag_flag {
+	MLX5E_WQE_FRAG_LAST_IN_PAGE,
+};
+
 struct mlx5e_wqe_frag_info {
 	union {
 		struct mlx5e_frag_page *frag_page;
 		struct xdp_buff **xskp;
 	};
 	u32 offset;
-	bool last_in_page;
+	u8 flags;
 };
 
 union mlx5e_alloc_units {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 53eef689f225..bb1cbf008876 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -532,7 +532,7 @@ static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 				next_frag.frag_page++;
 				next_frag.offset = 0;
 				if (prev)
-					prev->last_in_page = true;
+					prev->flags |= BIT(MLX5E_WQE_FRAG_LAST_IN_PAGE);
 			}
 			*frag = next_frag;
 
@@ -543,7 +543,7 @@ static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 	}
 
 	if (prev)
-		prev->last_in_page = true;
+		prev->flags |= BIT(MLX5E_WQE_FRAG_LAST_IN_PAGE);
 }
 
 static void mlx5e_init_xsk_buffs(struct mlx5e_rq *rq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 73bc373bf27d..f98212596c1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -323,7 +323,7 @@ static inline void mlx5e_put_rx_frag(struct mlx5e_rq *rq,
 				     struct mlx5e_wqe_frag_info *frag,
 				     bool recycle)
 {
-	if (frag->last_in_page)
+	if (frag->flags & BIT(MLX5E_WQE_FRAG_LAST_IN_PAGE))
 		mlx5e_page_release_fragmented(rq, frag->frag_page, recycle);
 }
 
-- 
2.39.2

