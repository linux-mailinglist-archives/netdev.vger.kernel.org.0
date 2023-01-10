Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BC966390F
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjAJGLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjAJGLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:11:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279B41DDDD
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BC3E614E6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0494C433D2;
        Tue, 10 Jan 2023 06:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331097;
        bh=kcqokmsYZ5/lv7Vc4w1LSy3KoNZczuboM4t6vh7phKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivFE7cpTeB427IHoFjLxPhRBqC2z6noGwA9s1EcJP5tuSuZlpRGsL1N4JQJrSxwKP
         QzqcEY39g+m1JCkXHR5PpUun7sl3fELCCMnl7awkWeCIytOc1B45cQaGczGvNnHU41
         AZRwD7opYT9Tm9ljY+ZeEnY3i+kPWM4VWlusm7/93dOnkbIvrPjrWxxxaHHzjSxN0T
         PHPVYfPiXc8QXTk0z6vAPEUc55h8Yu2kgaU20T46EHnhvA6boWwTJQZhgqhO9PON7o
         P5FflgrUNJ4nmugvhKvGhSCZ7qPwT1xTWvby9oWHqx+gVVmy6Pk9xRfoj50nLwaY8s
         /lg6hvt0+TDDA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: [net 01/16] net/mlx5: DR, Fix 'stack frame size exceeds limit' error in dr_rule
Date:   Mon,  9 Jan 2023 22:11:08 -0800
Message-Id: <20230110061123.338427-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

If the kernel configuration asks the compiler to check frame limit of 1K,
dr_rule_create_rule_nic exceed this limit:
    "stack frame size (1184) exceeds limit (1024)"

Fixing this issue by checking configured frame limit and using the
optimization STE array only for cases with the usual 2K (or larger)
stack size warning.

Fixes: b9b81e1e9382 ("net/mlx5: DR, For short chains of STEs, avoid allocating ste_arr dynamically")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c    | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 74cbe53ee9db..b851141e03de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -3,7 +3,12 @@
 
 #include "dr_types.h"
 
+#if defined(CONFIG_FRAME_WARN) && (CONFIG_FRAME_WARN < 2048)
+/* don't try to optimize STE allocation if the stack is too constaraining */
+#define DR_RULE_MAX_STES_OPTIMIZED 0
+#else
 #define DR_RULE_MAX_STES_OPTIMIZED 5
+#endif
 #define DR_RULE_MAX_STE_CHAIN_OPTIMIZED (DR_RULE_MAX_STES_OPTIMIZED + DR_ACTION_MAX_STES)
 
 static int dr_rule_append_to_miss_list(struct mlx5dr_domain *dmn,
@@ -1218,10 +1223,7 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 
 	mlx5dr_domain_nic_unlock(nic_dmn);
 
-	if (unlikely(!hw_ste_arr_is_opt))
-		kfree(hw_ste_arr);
-
-	return 0;
+	goto out;
 
 free_rule:
 	dr_rule_clean_rule_members(rule, nic_rule);
@@ -1238,6 +1240,7 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 free_hw_ste:
 	mlx5dr_domain_nic_unlock(nic_dmn);
 
+out:
 	if (unlikely(!hw_ste_arr_is_opt))
 		kfree(hw_ste_arr);
 
-- 
2.39.0

