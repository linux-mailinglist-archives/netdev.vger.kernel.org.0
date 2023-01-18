Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D38B671699
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjARIw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjARIwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:52:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFC49CBB3
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 00:04:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D6EF616F8
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6D1C433D2;
        Wed, 18 Jan 2023 08:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674029076;
        bh=ZzwgjVfnFi98wZXcL/AFToQ1T5VnAw8rSqP/X6yFozo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJSUGdY8dDCLCG4sEzg8sGMDdTZ4wN5Qhwek8gS2xjDTcEl5LyLBjetzxekAcuWzh
         yX8o9HJTUS8Xdk8bL3L9odNk1UI+gb1bVUuacxB5OeWYFe3CpmFUS3B4KH4ougm9et
         WFSB613Kplogl7iFsxx0LxSa8KixwfwoEciLOfEBLEeb9L7npkGdCpSqWBS4wi/nFu
         bLU5GtMijxaE+rShm4aocc9h9gbZFopP+DORErguhiLPsqk7r6KJL2OYyIIxj5xA/6
         IqC4CNpaiOuIh5PGxJMHNHBz4HlVqC7bocjDc2YRXevD4WHVm4tr5OvZGrmEM3jH3h
         XDVgRwBILlfRw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net 07/10] net/mlx5e: Remove optimization which prevented update of ESN state
Date:   Wed, 18 Jan 2023 00:04:11 -0800
Message-Id: <20230118080414.77902-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118080414.77902-1-saeed@kernel.org>
References: <20230118080414.77902-1-saeed@kernel.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

aso->use_cache variable introduced in commit 8c582ddfbb47 ("net/mlx5e: Handle
hardware IPsec limits events") was an optimization to skip recurrent calls
to mlx5e_ipsec_aso_query(). Such calls are possible when lifetime event is
generated:
 -> mlx5e_ipsec_handle_event()
  -> mlx5e_ipsec_aso_query() - first call
  -> xfrm_state_check_expire()
   -> mlx5e_xfrm_update_curlft()
    -> mlx5e_ipsec_aso_query() - second call

However, such optimization not really effective as mlx5e_ipsec_aso_query()
is needed to be called for update ESN anyway, which was missed due to misplaced
use_cache assignment.

Fixes: cee137a63431 ("net/mlx5e: Handle ESN update events")
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h     | 5 -----
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c | 5 -----
 2 files changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index a92e19c4c499..160f8883b93e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -122,11 +122,6 @@ struct mlx5e_ipsec_aso {
 	u8 ctx[MLX5_ST_SZ_BYTES(ipsec_aso)];
 	dma_addr_t dma_addr;
 	struct mlx5_aso *aso;
-	/* IPsec ASO caches data on every query call,
-	 * so in nested calls, we can use this boolean to save
-	 * recursive calls to mlx5e_ipsec_aso_query()
-	 */
-	u8 use_cache : 1;
 };
 
 struct mlx5e_ipsec {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 8e3614218fc4..aafbd7b244ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -320,7 +320,6 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 	if (ret)
 		goto unlock;
 
-	aso->use_cache = true;
 	if (attrs->esn_trigger &&
 	    !MLX5_GET(ipsec_aso, aso->ctx, esn_event_arm)) {
 		u32 mode_param = MLX5_GET(ipsec_aso, aso->ctx, mode_parameter);
@@ -333,7 +332,6 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 		    !MLX5_GET(ipsec_aso, aso->ctx, hard_lft_arm) ||
 		    !MLX5_GET(ipsec_aso, aso->ctx, remove_flow_enable))
 			xfrm_state_check_expire(sa_entry->x);
-	aso->use_cache = false;
 
 unlock:
 	spin_unlock(&sa_entry->x->lock);
@@ -458,9 +456,6 @@ int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
 	u8 ds_cnt;
 
 	lockdep_assert_held(&sa_entry->x->lock);
-	if (aso->use_cache)
-		return 0;
-
 	res = &mdev->mlx5e_res.hw_objs;
 
 	memset(aso->ctx, 0, sizeof(aso->ctx));
-- 
2.39.0

