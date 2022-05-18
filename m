Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB6D52B2B8
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbiERGuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiERGtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:49:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E91322291
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B0EF60BD6
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9F6C385A5;
        Wed, 18 May 2022 06:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856589;
        bh=mrlS9YSph+588lHkXfJyaIqM4P555Z3xUyKh1tFSRH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5MiChv0Kc723z4UqtUbuEa3wWOa1vKLrlq7qU4rOPVvTuaivFQZPhFxETvKuiOck
         WhHROVgkdPWK8zFP6Nku2B7YLZXqN4UEIUnkx8jT5hdZb0EuyaCbw2gBgI5zZi+T8G
         +dW4yScQMbP1QaemtzMQC3Cc5Mi7d3dGresA2EOAoCkJDtwkBRqTq2H/Ht3GWrun26
         2ZE4TrUNbRYJPbTPWvIHIIVI+fpf6YlMZQrdgoeD7Ta8kcO3vOCtEuCJ/WYJVJvWFH
         tVduupJJFz2hxLzTt/sL+LP806YKPjSJ9hsPBhmHHWrEarEGHT22vy52BksuN9syvB
         mFdoZrzGtqrsA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/16] net/mlx5e: Allocate virtually contiguous memory for reps structures
Date:   Tue, 17 May 2022 23:49:29 -0700
Message-Id: <20220518064938.128220-8-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

Physical continuity is not necessary, and requested allocation size might
be larger than PAGE_SIZE.
Hence, use v-alloc/free API.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 47f7b4c034cc..ce3b9e65c808 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -412,8 +412,8 @@ int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv)
 		    MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_TX_PORT_TS));
 	nch = priv->channels.num + ptp_sq;
 
-	sqs = kcalloc(nch * mlx5e_get_dcb_num_tc(&priv->channels.params), sizeof(*sqs),
-		      GFP_KERNEL);
+	sqs = kvcalloc(nch * mlx5e_get_dcb_num_tc(&priv->channels.params), sizeof(*sqs),
+		       GFP_KERNEL);
 	if (!sqs)
 		goto out;
 
@@ -430,7 +430,7 @@ int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv)
 	}
 
 	err = mlx5e_sqs2vport_start(esw, rep, sqs, num_sqs);
-	kfree(sqs);
+	kvfree(sqs);
 
 out:
 	if (err)
@@ -1269,7 +1269,7 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	struct mlx5e_rep_priv *rpriv;
 	int err;
 
-	rpriv = kzalloc(sizeof(*rpriv), GFP_KERNEL);
+	rpriv = kvzalloc(sizeof(*rpriv), GFP_KERNEL);
 	if (!rpriv)
 		return -ENOMEM;
 
@@ -1284,7 +1284,7 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		err = mlx5e_vport_vf_rep_load(dev, rep);
 
 	if (err)
-		kfree(rpriv);
+		kvfree(rpriv);
 
 	return err;
 }
@@ -1312,7 +1312,7 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	priv->profile->cleanup(priv);
 	mlx5e_destroy_netdev(priv);
 free_ppriv:
-	kfree(ppriv); /* mlx5e_rep_priv */
+	kvfree(ppriv); /* mlx5e_rep_priv */
 }
 
 static void *mlx5e_vport_rep_get_proto_dev(struct mlx5_eswitch_rep *rep)
-- 
2.36.1

