Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31AA36A130F
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 23:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjBWWxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 17:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBWWw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 17:52:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386C7C64F
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 14:52:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D518617C4
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 22:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FA2C4339B;
        Thu, 23 Feb 2023 22:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677192777;
        bh=eZPZQ5R4WqYaW5NTkzJ3rPL+cUyMVqc53UYG9ruo2LM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o73rh8QgMAHfTqrrVSZyBV4nq6HeXgdHg27mPF0xOtChh7xqfcNzNQY388v6tPxFG
         unyVOO7UyxEVZyJCp03+tQfoVvfQKyz5T6M8xZiEDmlYat1u6ZmJUXU2892nrTxSgc
         lKhYCKCN9MfKI8NDi4jJyaUMSRJp2AqlrSidqJQBI0ncjkTlvHPzbOFpjvgCabQDBI
         +xpkvY8q4vtvgWqbpYRSQZOfpMUyd5n7tEv4frBO5xr3x3JNZCg+Xj45yXtT0fJ5Ys
         L3wOiC08e45T8k3NKMYelI5CkoG/ho5cFKMASLJUpKDWQW068fGk6xkCJ6kwh3lNbA
         Aykz0xNiocY9w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net 02/10] net/mlx5e: TC, fix return value check in mlx5e_tc_act_stats_create()
Date:   Thu, 23 Feb 2023 14:52:39 -0800
Message-Id: <20230223225247.586552-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230223225247.586552-1-saeed@kernel.org>
References: <20230223225247.586552-1-saeed@kernel.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

kvzalloc() returns NULL pointer not PTR_ERR() when it fails,
so replace the IS_ERR() check with NULL pointer check.

Fixes: d13674b1d14c ("net/mlx5e: TC, map tc action cookie to a hw counter")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
index f71766dca660..626cb7470fa5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
@@ -37,7 +37,7 @@ mlx5e_tc_act_stats_create(void)
 	int err;
 
 	handle = kvzalloc(sizeof(*handle), GFP_KERNEL);
-	if (IS_ERR(handle))
+	if (!handle)
 		return ERR_PTR(-ENOMEM);
 
 	err = rhashtable_init(&handle->ht, &act_counters_ht_params);
-- 
2.39.1

