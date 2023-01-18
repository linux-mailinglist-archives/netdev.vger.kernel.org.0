Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2640E67169E
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjARIxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjARIw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:52:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614359CBB7
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 00:04:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DB3B616FF
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961C4C433F0;
        Wed, 18 Jan 2023 08:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674029078;
        bh=Df4hMM0enjST14rE99cmCn7ZhwZuNfslgE3D3zD63pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLXtEVJKao5G1cKYagsZA2uF22Sww5IOjqfzPdh5xqgEfOB+gz/q5FQqk5ki1SckB
         BsLfC9rxTJvBavzEmh9ADrsP0VFwfj0xPCDHb2W4zy5gWNdHrHTbYSu/+H0Et8GepL
         ym5hcALwkLKBTLE+rdobOG3fw3GfRgW/HAYJa0wqtHcYAlr8PNlGsYHcLT1UXnhx6q
         yWcI7RgTK+GBFVE8sbafqY6L1AfTQ2WBNZLo24lVxH1FIDIQWggGWNo8Anf5wKfVqy
         NV/xtyBDfhY9//x7BzziMoiarA7uaFBabfpGeGQjIHM04GJeJezFCPMg6iBWvNLTWu
         WwZ9AKxBkSVEA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net 09/10] net/mlx5: E-switch, Fix switchdev mode after devlink reload
Date:   Wed, 18 Jan 2023 00:04:13 -0800
Message-Id: <20230118080414.77902-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118080414.77902-1-saeed@kernel.org>
References: <20230118080414.77902-1-saeed@kernel.org>
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

From: Chris Mi <cmi@nvidia.com>

The cited commit removes eswitch mode none. So after devlink reload
in switchdev mode, eswitch mode is not changed. But actually eswitch
is disabled during devlink reload.

Fix it by setting eswitch mode to legacy when disabling eswitch
which is called by reload_down.

Fixes: f019679ea5f2 ("net/mlx5: E-switch, Remove dependency between sriov and eswitch mode")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 0dfd5742c6fe..9daf55e90367 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1464,6 +1464,7 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
 	mlx5_lag_disable_change(esw->dev);
 	down_write(&esw->mode_lock);
 	mlx5_eswitch_disable_locked(esw);
+	esw->mode = MLX5_ESWITCH_LEGACY;
 	up_write(&esw->mode_lock);
 	mlx5_lag_enable_change(esw->dev);
 }
-- 
2.39.0

