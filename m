Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034BB672729
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjARSgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjARSgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DBD5B5A3
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9AEA61944
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222C5C433F1;
        Wed, 18 Jan 2023 18:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066981;
        bh=9kS58ho4hCeteUwEmtcEjIxYuNgqehhD5NMlKL2hXok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIK3yxkK3fkkPIGWmdX43DOr4I91KtE2BZ2/F7Nszj2ZWZLwXrHMOvBhOLxo0mBj3
         26VrgsD3LKQ/XeBVQOacd9vXjJlZODE9GbUtOQEaIweFY1BIC5mWzt82RgXgClF857
         J/daI3DibffyLhaQqsa0PwMRDDsT1B1fdlsv4FREiLcM971nABWkrI0lDo7LApUd5L
         0PiV9hlhAVF2CYNFhHR7tyuSgwootZeck4YHxL46gYUGf/De2lAuVLEoavS7fHPael
         AAPNXl4rIukt03NZCRhTd8nkSer5jucHOmZn7nMd6ic4/ZN8EIJzWzfPVR/PXwioA2
         qBDJnK+Fd4O1A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: Remove redundant allocation of spec in create indirect fwd group
Date:   Wed, 18 Jan 2023 10:36:01 -0800
Message-Id: <20230118183602.124323-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118183602.124323-1-saeed@kernel.org>
References: <20230118183602.124323-1-saeed@kernel.org>
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

From: Maor Dickman <maord@nvidia.com>

mlx5_add_flow_rules supports creating rules without any matches by passing NULL
pointer instead of spec, if NULL is passed it will use a static empty spec.
This make allocation of spec in mlx5_create_indir_fwd_group unnecessary.

Remove the redundant allocation.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/esw/indir_table.c  | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
index 8a94870c5b43..9959e9fd15a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
@@ -212,19 +212,12 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
 	int err = 0, inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {};
-	struct mlx5_flow_spec *spec;
 	u32 *in;
 
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
 
-	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
-	if (!spec) {
-		kvfree(in);
-		return -ENOMEM;
-	}
-
 	/* Hold one entry */
 	MLX5_SET(create_flow_group_in, in, start_flow_index, MLX5_ESW_INDIR_TABLE_FWD_IDX);
 	MLX5_SET(create_flow_group_in, in, end_flow_index, MLX5_ESW_INDIR_TABLE_FWD_IDX);
@@ -240,14 +233,13 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
 	dest.vport.num = e->vport;
 	dest.vport.vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
 	dest.vport.flags = MLX5_FLOW_DEST_VPORT_VHCA_ID;
-	e->fwd_rule = mlx5_add_flow_rules(e->ft, spec, &flow_act, &dest, 1);
+	e->fwd_rule = mlx5_add_flow_rules(e->ft, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(e->fwd_rule)) {
 		mlx5_destroy_flow_group(e->fwd_grp);
 		err = PTR_ERR(e->fwd_rule);
 	}
 
 err_out:
-	kvfree(spec);
 	kvfree(in);
 	return err;
 }
-- 
2.39.0

