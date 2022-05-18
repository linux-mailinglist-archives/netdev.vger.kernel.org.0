Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20C552B260
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiERGfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiERGfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:35:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FF3712EC
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:34:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F24A6176F
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF635C34100;
        Wed, 18 May 2022 06:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652855689;
        bh=L4xCrQIc+vCsH7u+cuFcrThNJHghWaYzOKy+fycCSW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPuhbBf5wiKwwbz+Z0RvLPiIEZvxKXGu2MMsz9Ju8/h3ptHN8whJzVymilwhMyOQg
         lRmp0NMm483oUBcv9DCY5mTufDlaL95Zr6/RK+dgp2+1lHs0NJrdyErt63gc+5horg
         UvgjmPnNiBwT4kCrx4GuerKPcqvQjXkcfNBCgMel8T9bmvKFnik/0B/pzQwTzDOarL
         WU5DBBdXM3kLavXsrdan0skj56gd+UuQEeDM2+GtDmO6uoW1Rgl20BP/NQp8Q35Ltk
         woWuVuCTgUD/dMGoeK/h9xV774Y0CV/xYPr4cbNmukIaiMxlecWo4ueX0tDEKXdZtB
         bziseeFJWzP/g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/11] net/mlx5e: CT: Fix setting flow_source for smfs ct tuples
Date:   Tue, 17 May 2022 23:34:26 -0700
Message-Id: <20220518063427.123758-11-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518063427.123758-1-saeed@kernel.org>
References: <20220518063427.123758-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Cited patch sets flow_source to ANY overriding the provided spec
flow_source, avoiding the optimization done by commit c9c079b4deaa
("net/mlx5: CT: Set flow source hint from provided tuple device").

To fix the above, set the dr_rule flow_source from provided flow spec.

Fixes: 3ee61ebb0df1 ("net/mlx5: CT: Add software steering ct flow steering provider")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c
index 271261bf1dc2..bec9ed0103a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c
@@ -330,7 +330,7 @@ mlx5_ct_fs_smfs_ct_rule_add(struct mlx5_ct_fs *fs, struct mlx5_flow_spec *spec,
 	}
 
 	rule = mlx5_smfs_rule_create(smfs_matcher->dr_matcher, spec, num_actions, actions,
-				     MLX5_FLOW_CONTEXT_FLOW_SOURCE_ANY_VPORT);
+				     spec->flow_context.flow_source);
 	if (!rule) {
 		err = -EINVAL;
 		goto err_create;
-- 
2.36.1

