Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0A860CA76
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiJYK6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbiJYK6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:58:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3449F752
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0A0061876
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 10:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C2BC433C1;
        Tue, 25 Oct 2022 10:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666695499;
        bh=wT+S+ocHo7gZUWrqpuMWXoRnBrxUcltKWZvtN7+Y2Dw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r6rF1EzBy2wAZyURvjjaSJySGO9A/f+i2hOC8frC5V76S5jjLOLNOJDQwWYHvsoCe
         GPsa0eRixwtvj2hH8Xmde59PuTXWMHCa2g0zKU7OC9m98ZHgibNZwmjoGMkTbl0MUk
         ROIubKjVyMVr90Xyzc+JR5JMEBBoHlWFSFSG8mW+g5Ae3TkDzlYgOBulIbRmC8kBeo
         WSkBDE/yT77ccZoo4Gz1B3mXt8HeklMDXEk1SzxERc3FEj9wrHQlkDY5QiZSjrFCF7
         WDk0IRWG8qRQhxTo/XbjCgsJCP/zNA7/XEaDy5nx4T/osyAyR+xu6Dc3NAHuO3Hwm0
         cimhjvRDQWTyA==
Date:   Tue, 25 Oct 2022 11:58:14 +0100
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v1 1/6] net/mlx5e: Support devlink reload of
 IPsec core
Message-ID: <20221025105814.foarlkx6nmxazeie@sx1>
References: <cover.1666630548.git.leonro@nvidia.com>
 <2ef26b5cfbc2870e65391320bbf70491cda6321f.1666630548.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2ef26b5cfbc2870e65391320bbf70491cda6321f.1666630548.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 Oct 19:59, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>Change IPsec initialization flow to allow future creation of hardware
>resources that should be released and allocated during devlink reload
>operation. As part of that change, update function signature to be
>void as no callers are actually interested in it.
>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>---

...

>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>index 794cd8dfe9c9..324e5759b049 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>@@ -761,7 +761,6 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
> 			     struct net_device *netdev)
> {
> 	struct mlx5e_priv *priv = netdev_priv(netdev);
>-	int err;
>
> 	priv->fs = mlx5e_fs_init(priv->profile, mdev,
> 				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
>@@ -770,10 +769,6 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
> 		return -ENOMEM;
> 	}
>
>-	err = mlx5e_ipsec_init(priv);
>-	if (err)
>-		mlx5_core_err(mdev, "Uplink rep IPsec initialization failed, %d\n", err);
>-

Original code had ipsec enabled for uplink rep and nic profile only, but not
other vport reps. your below code will enable ipsec and alloc resources for
other vport reps, which will be a huge waste of memory and hw resources on
switchdev system with lots of vports.

Please make sure not to enable ipsec on ALL reps.

> 	mlx5e_vxlan_set_netdev_info(priv);
> 	mlx5e_build_rep_params(netdev);
> 	mlx5e_timestamp_init(priv);
>@@ -783,7 +778,6 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
> static void mlx5e_cleanup_rep(struct mlx5e_priv *priv)
> {
> 	mlx5e_fs_cleanup(priv->fs);
>-	mlx5e_ipsec_cleanup(priv);
> }
>
> static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
>@@ -1074,6 +1068,8 @@ static void mlx5e_rep_enable(struct mlx5e_priv *priv)

this function isn't invoked from uplink rep, so you broke functionality.

> {
> 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
>
>+	mlx5e_ipsec_init(priv);
>+
> 	mlx5e_set_netdev_mtu_boundaries(priv);
> 	mlx5e_rep_neigh_init(rpriv);
> }
>@@ -1083,6 +1079,7 @@ static void mlx5e_rep_disable(struct mlx5e_priv *priv)
> 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
>
> 	mlx5e_rep_neigh_cleanup(rpriv);
>+	mlx5e_ipsec_cleanup(priv);
> }
>
> static int mlx5e_update_rep_rx(struct mlx5e_priv *priv)
>-- 
>2.37.3
>
