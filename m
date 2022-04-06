Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC894F5C43
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiDFLj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiDFLhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:37:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1089577797;
        Wed,  6 Apr 2022 01:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42832B8217D;
        Wed,  6 Apr 2022 08:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB91C385A5;
        Wed,  6 Apr 2022 08:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233601;
        bh=eaGubmhC9CMZBE4w4fb+w3wsLhfhSm0Lj978ig3snW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNQZKg0PKkjhLaPNLwd46pkRtFFCVFIp5e9qNtpRkk0wd/pttbcxBS6wJlwRR4hPx
         iuvUwjE6I6Z3CRbxzcnfKrw++cwu0e08McwblUE/g/YVlId9wCPvtj6VJmhteKXxld
         eAD3atU97Q7v7mgccfauU8sF/xR3+R/qxRj+WDMjahlCtH7tTWQRiUqgHwjZIRUQkv
         u9vW35wgcvkutQ4InXTvZ4ixrltUYCK34qwh4c72F4RINu3Bc8tWRS5whKQBosUl85
         yClXtcnJI5gk4qAlKn6QEA0sdzSrDlIKpAhnQ9e9FSJqDjCmPvHQmTBPkCJ26qy5AO
         hE++h4Da8/Icg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 12/17] net/mlx5: Align flow steering allocation namespace to common style
Date:   Wed,  6 Apr 2022 11:25:47 +0300
Message-Id: <cfb411a8a9ed2a1471810af254bdc0f03469f79c.1649232994.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649232994.git.leonro@nvidia.com>
References: <cover.1649232994.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Flow steering is a low level internal driver API, as such it relies on
the callers to check if namespace is supported and not rely on some
compilation flag.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 6 ------
 2 files changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index a0ac17c3f12f..33e9f86cf7d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -878,9 +878,7 @@ static int mlx5_cmd_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 		table_type = FS_FT_NIC_RX;
 		break;
 	case MLX5_FLOW_NAMESPACE_EGRESS:
-#ifdef CONFIG_MLX5_IPSEC
 	case MLX5_FLOW_NAMESPACE_EGRESS_KERNEL:
-#endif
 		max_actions = MLX5_CAP_FLOWTABLE_NIC_TX(dev, max_modify_header_actions);
 		table_type = FS_FT_NIC_TX;
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index fe7bdccea301..297e6a468a3e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -186,24 +186,18 @@ static struct init_tree_node {
 
 static struct init_tree_node egress_root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-#ifdef CONFIG_MLX5_IPSEC
 	.ar_size = 2,
-#else
-	.ar_size = 1,
-#endif
 	.children = (struct init_tree_node[]) {
 		ADD_PRIO(0, MLX5_BY_PASS_NUM_PRIOS, 0,
 			 FS_CHAINING_CAPS_EGRESS,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
 						  BY_PASS_PRIO_NUM_LEVELS))),
-#ifdef CONFIG_MLX5_IPSEC
 		ADD_PRIO(0, KERNEL_TX_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS_EGRESS,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				ADD_MULTIPLE_PRIO(KERNEL_TX_IPSEC_NUM_PRIOS,
 						  KERNEL_TX_IPSEC_NUM_LEVELS))),
-#endif
 	}
 };
 
-- 
2.35.1

