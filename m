Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7613268E507
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjBHAhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjBHAhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723073E0A3
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15563B81B86
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01C4C433EF;
        Wed,  8 Feb 2023 00:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816638;
        bh=OLGWRZ03KuqAY44xT8TiOeyYC4io/BgLbDKUmhAdrtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QD23iSfWWUzAG9FlmI3EIRINvhecCiSAl+UqUDu8pBFWRd9rfkrOkgArjvYejqMfd
         kvyBqmO5Y6tRDp9kqmQ7W+Jhmc2bCb67xbMklHUJVDuvm5HqTLRhNg9LgK0MqMzoqP
         Rx3Gxb9EXzAslp9e00jPFsqcKAMK5Q8YJ2MNewABiNdsWKuwHrr32pZwWcD9NwQ074
         LMcI6RW1HVHaXpqwZsGMVhrZvdPkbPCUk0BHQuqyOwWDys8kucYUHPzkZPo3HlNXQ1
         p6mCT4VSsWZNR4l/S6GaVKBZYIodXmAl3cOL6YB4xvNv/mjCNE3ZnM+BRqQwG0tlvU
         BlDiaQb1jN0QA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next 01/15] mlx5: reduce stack usage in mlx5_setup_tc
Date:   Tue,  7 Feb 2023 16:36:58 -0800
Message-Id: <20230208003712.68386-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208003712.68386-1-saeed@kernel.org>
References: <20230208003712.68386-1-saeed@kernel.org>
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
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c   | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3973d86905e8..6b9267c19e00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3002,32 +3002,37 @@ int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
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
2.39.1

