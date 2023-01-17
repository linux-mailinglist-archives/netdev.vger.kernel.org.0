Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A19E670D10
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjAQXRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjAQXPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:15:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5244345B;
        Tue, 17 Jan 2023 13:03:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95BA06130C;
        Tue, 17 Jan 2023 21:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECD6C433D2;
        Tue, 17 Jan 2023 21:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673989414;
        bh=Z1yj3AKv/D0tTj/52SlF339uoYemMNAwZOwWB+tc454=;
        h=From:To:Cc:Subject:Date:From;
        b=Qxhz+jC1xMpz2hMxYPK3Fyh4vjWrdfcgaKBkL7uTJJnC0AR3xgxbyOcKTMfIcyRrP
         AYmt3oofTG03GXnkvUzYXq6B9lzVS1XvEv6TkW/q3LFBjL1IMLQOZmrs5liSdvbQJW
         SxQO0Q2zNOh6jOFzLoBPJ6hbJKJacULQYJOv86oD3VuUrBAllXWs6icRmaqdrWmHwH
         DZhLOrZQyflX2bFV1PQqJFwTVERJ22jqnNAnUSIX/CP1ZUSaQbb9HRO+DlctktpwoI
         lI88hzMjLIdt4jst+ktPd44D6sK2OiSnbqhoouKJmb+gipkGxwsaSGs2ET5ind+cOm
         V5rxjIHXj5PLA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, Lama Kayal <lkayal@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH] [v2] mlx5: reduce stack usage in mlx5_setup_tc
Date:   Tue, 17 Jan 2023 22:01:55 +0100
Message-Id: <20230117210324.1371169-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.0
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

From: Arnd Bergmann <arnd@arndb.de>

Clang warns about excessive stack usage on 32-bit targets:

drivers/net/ethernet/mellanox/mlx5/core/en_main.c:3597:12: error: stack frame size (1184) exceeds limit (1024) in 'mlx5e_setup_tc' [-Werror,-Wframe-larger-than]
static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,

It turns out that both the mlx5e_setup_tc_mqprio_dcb() function and
the mlx5e_safe_switch_params() function it calls have a copy of
'struct mlx5e_params' on the stack, and this structure is fairly
large.

Use dynamic allocation for the inner one.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: simplify the patch
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c   | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6bb0fdaa5efa..b0b872728653 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2998,32 +2998,37 @@ int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
 			     mlx5e_fp_preactivate preactivate,
 			     void *context, bool reset)
 {
-	struct mlx5e_channels new_chs = {};
+	struct mlx5e_channels *new_chs;
 	int err;
 
 	reset &= test_bit(MLX5E_STATE_OPENED, &priv->state);
 	if (!reset)
 		return mlx5e_switch_priv_params(priv, params, preactivate, context);
 
-	new_chs.params = *params;
+	new_chs = kzalloc(sizeof(*new_chs), GFP_KERNEL);
+	if (!new_chs)
+		return -ENOMEM;
+	new_chs->params = *params;
 
-	mlx5e_selq_prepare_params(&priv->selq, &new_chs.params);
+	mlx5e_selq_prepare_params(&priv->selq, &new_chs->params);
 
-	err = mlx5e_open_channels(priv, &new_chs);
+	err = mlx5e_open_channels(priv, new_chs);
 	if (err)
 		goto err_cancel_selq;
 
-	err = mlx5e_switch_priv_channels(priv, &new_chs, preactivate, context);
+	err = mlx5e_switch_priv_channels(priv, new_chs, preactivate, context);
 	if (err)
 		goto err_close;
 
+	kfree(new_chs);
 	return 0;
 
 err_close:
-	mlx5e_close_channels(&new_chs);
+	mlx5e_close_channels(new_chs);
 
 err_cancel_selq:
 	mlx5e_selq_cancel(&priv->selq);
+	kfree(new_chs);
 	return err;
 }
 
-- 
2.39.0

