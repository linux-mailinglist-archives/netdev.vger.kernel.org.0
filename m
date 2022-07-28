Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DC1584736
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiG1UrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiG1Uq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:46:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7396BD5B
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:46:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD168B82591
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E96CC433D6;
        Thu, 28 Jul 2022 20:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041213;
        bh=lQwk+inSo4KGD8BiEEWX3OHo8wF/hPIfK9CL45JJMng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSB3EN7l/VsqquDMGTadcNmnWPhQwICgJhGJUy6qFnComIkONkrTNQrs4UIQncoPf
         D2C6bPJhd+x+AUFwjjO4II6dULBYjdrqHLjO7/QD74CCWWQi+B5mkkBm1hnSh0tZC3
         HI2V2IP4toQ0CgMY3puYR5pRHHlSHvrjAr1mUN+TDD3rAXE/6Zj32VNYwir65mbBTJ
         J3//tU0QM7x1oLUMXr17AnkGHe60kPgo235strOfRIScOZIgPQqfZ5/FDkWC0KWmZB
         1GFIP3zStTvGGBRxz398DE/5Ug9ptU6z3eC95B18z6KvKppichdq2AbIa9Nv7tsfz6
         SH8PUjG4JimBA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net 2/9] net/mlx5e: TC, Fix post_act to not match on in_port metadata
Date:   Thu, 28 Jul 2022 13:46:33 -0700
Message-Id: <20220728204640.139990-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728204640.139990-1-saeed@kernel.org>
References: <20220728204640.139990-1-saeed@kernel.org>
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

From: Maor Dickman <maord@nvidia.com>

The cited commit changed CT to use multi table actions post act infrastructure instead
of using it own post act infrastructure, this broke decap during VF tunnel offload
(Stack devices) with CT due to wrong match on in_port metadata in the post act table.
This changed only broke VF tunnel offload because it modify the packet in_port metadata
to be VF metadata and it isn't propagate the post act creation.

Fixed by modify post act rules to match only on fte_id and not match on in_port metadata
which isn't needed.

Fixes: a81283263bb0 ("net/mlx5e: Use multi table support for CT and sample actions")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
index dea137dd744b..2b64dd557b5d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -128,6 +128,7 @@ mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *at
 	post_attr->inner_match_level = MLX5_MATCH_NONE;
 	post_attr->outer_match_level = MLX5_MATCH_NONE;
 	post_attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_DECAP;
+	post_attr->flags |= MLX5_ATTR_FLAG_NO_IN_PORT;
 
 	handle->ns_type = post_act->ns_type;
 	/* Splits were handled before post action */
-- 
2.37.1

