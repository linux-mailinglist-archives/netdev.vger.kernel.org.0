Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8BA6039D8
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiJSGip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiJSGil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:38:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEB56D540
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:38:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F08CB8207D
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB86C433D6;
        Wed, 19 Oct 2022 06:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666161517;
        bh=f6/MonIYi56jFppHWg+g0BIwso7kY+yyNU6yof9Gns0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6+xx+iF0LGLwyO26ZUOZ4eJ+O9rwxWxVnzilFYQcJQs9bu116Eelyhv0EpIT9pC4
         N7xaZ7NgBYL7W54BnTvoRynsR0OW+dhM8JE89mNweI3ay38Mj+fdM/93g04qE2NwQF
         Rcd8wqSwBoPl2VasjNoUseO02wuQPsJVJ01MvjZG3yaJToyIEjg1KxNqS1hoXxaYBi
         FX/Acg6+aAzGQJhtrHpM4oo/iNM/LQp3eeQEcUQ+pdLytEUmq0CjP89gp+qnpRkDzm
         ELF+riImtCdUPv+jwiV6iuRpTtBQn+huIYIQ3ohjKvPyN5drn5ImUoV8NejUzhO7k+
         70WhKChqQ0xdw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rongwei Liu <rongweil@nvidia.com>
Subject: [net 03/16] net/mlx5: DR, Fix matcher disconnect error flow
Date:   Tue, 18 Oct 2022 23:38:00 -0700
Message-Id: <20221019063813.802772-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221019063813.802772-1-saeed@kernel.org>
References: <20221019063813.802772-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rongwei Liu <rongweil@nvidia.com>

When 2nd flow rules arrives, it will merge together with the
1st one if matcher criteria is the same.

If merge fails, driver will rollback the merge contents, and
reject the 2nd rule. At rollback stage, matcher can't be
disconnected unconditionally, otherise the 1st rule can't be
hit anymore.

Add logic to check if the matcher should be disconnected or not.

Fixes: cc2295cd54e4 ("net/mlx5: DR, Improve steering for empty or RX/TX-only matchers)
Signed-off-by: Rongwei Liu <rongweil@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index ddfaf7891188..91ff19f67695 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -1200,7 +1200,8 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 	}
 
 remove_from_nic_tbl:
-	mlx5dr_matcher_remove_from_tbl_nic(dmn, nic_matcher);
+	if (!nic_matcher->rules)
+		mlx5dr_matcher_remove_from_tbl_nic(dmn, nic_matcher);
 
 free_hw_ste:
 	mlx5dr_domain_nic_unlock(nic_dmn);
-- 
2.37.3

