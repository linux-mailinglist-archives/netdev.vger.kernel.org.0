Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD7468E50D
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjBHAhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjBHAh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFC13EFFC
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 616C960F96
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90F7C433D2;
        Wed,  8 Feb 2023 00:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816644;
        bh=aqhfJn5GZUzuV8dJfLS1uypWXgLEoh5asbC6yW4hI8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5gs1WZ9z5ZFN67T6FH3XdiriUNLYad1CwgXP7KdFLN2Wh/WLLmpjqv/Ij7gp+VeZ
         MGUtq01m9Pw08n8AIQuVnAcGA0nI+YTYX0rMLAvm1MUo09hDu9SqqHnoHE3EJgsU6I
         n+CpQLtgM4c/rCT0wVdNZWxmf/Jjtc2DAxdhPbjdHxOyg1EIOrbfx4y9TCq3Z5dhOc
         zzQiGr7VVF7RRP9PJoo77hRlAYuxViIuaKaJjIfuLM/Esy8dJmxCI1O5wGbu6AkXcf
         QpvSgq7D11jXeJkDFEsaaycUTr4vDLt4A7Entnwhd8Ox4P0tiaXgyWJtt5AHZDqBFL
         tkZu1/fti14Ng==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [net-next 07/15] net/mlx5e: Remove incorrect debugfs_create_dir NULL check in hairpin
Date:   Tue,  7 Feb 2023 16:37:04 -0800
Message-Id: <20230208003712.68386-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208003712.68386-1-saeed@kernel.org>
References: <20230208003712.68386-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

Remove the NULL check on debugfs_create_dir() return value as the
function returns an ERR pointer on failure, not NULL.
The check is not replaced with a IS_ERR_OR_NULL() as
debugfs_create_file(), and debugfs functions in general don't need error
checking.

Fixes: 0e414518d6d8 ("net/mlx5e: Add hairpin debugfs files")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index bf4cff8b1d42..e2ec80ebde58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1124,8 +1124,6 @@ static void mlx5e_tc_debugfs_init(struct mlx5e_tc_table *tc,
 		return;
 
 	tc->dfs_root = debugfs_create_dir("tc", dfs_root);
-	if (!tc->dfs_root)
-		return;
 
 	debugfs_create_file("hairpin_num_queues", 0644, tc->dfs_root,
 			    &tc->hairpin_params, &fops_hairpin_queues);
-- 
2.39.1

