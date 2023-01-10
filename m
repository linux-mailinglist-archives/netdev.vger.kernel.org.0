Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBADD663918
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjAJGML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjAJGLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:11:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7D83FA03
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A2CC614E5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F75BC433D2;
        Tue, 10 Jan 2023 06:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331105;
        bh=CxaI5HcErkqGsVWHP3hmMXk/B9QZBJO5WRoHKI0Mf1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0LoEIu1Jfaj605xblY05ANdwVN/0VHus2aVcM5/QYqPjLZyj/fJqFPSy+WPjZS5o
         FwzJuQDAVsFfgQV4uEJlatTCAwPfp4riZ2aowY6YmRepAYZWUcWXe0MxnSYytFJhou
         eSwkIGOkAGH0JivWYozRYFQofIxEXdGvIleIH2YKo4Cgm5pKSovvrHiZg1Vu7NZNBD
         agxZDapL9zrXntuRnQaaIHDBxQp3gINIkedcprKO7Se7eaz8y5fh8mqj+Cn+mByTFA
         4/Stpf8lvUd8WC/eTJEVNRjppvTAMCyt3xCWeuP/0Oi99c9B9PKDk65fnXSHUIsB7l
         7lRMDBhdchhrw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net 09/16] net/mlx5e: TC, ignore match level for post meter rules
Date:   Mon,  9 Jan 2023 22:11:16 -0800
Message-Id: <20230110061123.338427-10-saeed@kernel.org>
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

From: Oz Shlomo <ozsh@nvidia.com>

The post meter table only matches on reg_c5. As such, the inner/outer
match levels are irrelevant for the match critieria. The cited patch only
sets the outer criteria to none, thus setting the inner match level for
encapsulated packets. This caused rules with police action on tunnel
devices to not find an existing flow group for the match criteria, thus
failing to offload the rule.

Set both the inner and outer match levels to none for post_meter rules.

Fixes: 0d8c38d44f33 ("net/mlx5e: TC, init post meter rules with branching attributes")
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
index 8d7d761482d2..50b60fd00946 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
@@ -127,6 +127,7 @@ mlx5e_post_meter_add_rule(struct mlx5e_priv *priv,
 		attr->counter = act_counter;
 
 	attr->flags |= MLX5_ATTR_FLAG_NO_IN_PORT;
+	attr->inner_match_level = MLX5_MATCH_NONE;
 	attr->outer_match_level = MLX5_MATCH_NONE;
 	attr->chain = 0;
 	attr->prio = 0;
-- 
2.39.0

