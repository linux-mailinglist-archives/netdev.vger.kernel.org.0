Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7FD60E2A1
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiJZNxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbiJZNw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:52:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B38107CCB
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:52:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB2EF61EFA
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 13:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805EAC433D7;
        Wed, 26 Oct 2022 13:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666792333;
        bh=f6/MonIYi56jFppHWg+g0BIwso7kY+yyNU6yof9Gns0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkFKlHEwwlAJlIllD/rEvjYuTOuY9GP9uXvZf+SWU7lUuzkRMTHBhSD5vp1BcLIuP
         nV1DpFk/eucejgK1ugAhxBm0RYjfX1Y17FrDUxG7upob7Ln4Cklo9meb6pYvls3SPm
         6UIoOh7rc2bWeHEcaULymk6QH2/Sp/nVqUDVbXH7Rsu4jUOOO5gD448k3XjT9lhs2Z
         wQ71eZZ8ZxCXfOtcn6R92Vt/zvWenCy3fanbAch11iUXrWubKUfkwZiKxTFEwmq3R2
         a0TUmaWyILA6VT4Fuj0MJFu0KEgx8igCtroLyHqyYjo0w0dJZtpbULVpNHhcUQqz9s
         rovyTDQeM9nRg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rongwei Liu <rongweil@nvidia.com>
Subject: [V4 net 03/15] net/mlx5: DR, Fix matcher disconnect error flow
Date:   Wed, 26 Oct 2022 14:51:41 +0100
Message-Id: <20221026135153.154807-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221026135153.154807-1-saeed@kernel.org>
References: <20221026135153.154807-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

