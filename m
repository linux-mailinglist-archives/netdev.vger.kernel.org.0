Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93EE60A4AC
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 14:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbiJXMPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 08:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbiJXMNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 08:13:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5058A24BDB
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 04:54:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE5486126B
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B170DC433D7;
        Mon, 24 Oct 2022 11:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666612458;
        bh=f6/MonIYi56jFppHWg+g0BIwso7kY+yyNU6yof9Gns0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mcCkI2MLHVLAkmpQ1zvdqbdIlsBP44f/DDP041/2b11WR0GDFZWF4ujnpiEBA5dw/
         N0/xGodFkY/1IY4NYVPQELKwrNyV/4fXkF+dMMVTGsB5RR5I2WwYD579hw/jdkAAN1
         ae1WqdVbI5UwCmaWWUgwDMfo7aHLWTPb7qWklihzIWBNLCTWxreohAeRN5yl5WGmRz
         II+akSGZ+jG06SZNPdtfNrWMkjFHxB9t/Bc/IQQ2t71/nPs1lCQa+vJDJc4JMI3P2a
         WwWZabaHK6VelJ39i/Xe9dYph9fEHhW+EN6WupfTW0W1s/ziTzT4Gsdhg1Bm5KtuMu
         cf6Vgl9SUAI7A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rongwei Liu <rongweil@nvidia.com>
Subject: [V3 net 03/16] net/mlx5: DR, Fix matcher disconnect error flow
Date:   Mon, 24 Oct 2022 12:53:44 +0100
Message-Id: <20221024115357.37278-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024115357.37278-1-saeed@kernel.org>
References: <20221024115357.37278-1-saeed@kernel.org>
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

