Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2A06EC11C
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 18:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjDWQbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 12:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDWQbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 12:31:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC37E74
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 09:31:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 029B361574
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 16:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9618DC433D2;
        Sun, 23 Apr 2023 16:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682267460;
        bh=tXabWo78luj/12oz5pK7X9hqlEX2z+8TxF6kbtdJ/LU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GhRnXR9cniFSb5G9eJlk9Az6GNA2e01MCdwNGjkMEJLIKniDXWG6P3N9R0nWCZsOh
         kCMgudIOzJIgHzGndtPJFII7jbg9cqErk7B5DhVVKXZQPnVHMb+PcQ4yRH2RPOOsaZ
         tnKvm567mPjOd8ZPiizybogLNkxy5LoM7VX40w0Vvaz1SHVY+Ny3/8r0GXgClLisK5
         EasGerSm3GqoKJaNA+wLBL7W9Yc2UeYvQdmh2y4rTdwaUCHeLwmdPQJsrDtsrlC+Oc
         dIUSXFS20rZXO6OuMfQPs5j3NkRUD8wD643jJI0IQe43k/Ve9OV06jpewcVGcD60gu
         lIVlRkG+qGy0w==
Date:   Sun, 23 Apr 2023 19:30:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dima Chumak <dchumak@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next V2 2/4] net/mlx5: Implement devlink port
 function cmds to control ipsec_crypto
Message-ID: <20230423163055.GC4782@unreal>
References: <20230421104901.897946-1-dchumak@nvidia.com>
 <20230421104901.897946-3-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421104901.897946-3-dchumak@nvidia.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 01:48:59PM +0300, Dima Chumak wrote:
> Implement devlink port function commands to enable / disable IPsec
> crypto offloads.  This is used to control the IPsec capability of the
> device.
> 
> When ipsec_crypto is enabled for a VF, it prevents adding IPsec crypto
> offloads on the PF, because the two cannot be active simultaneously due
> to HW constraints. Conversely, if there are any active IPsec crypto
> offloads on the PF, it's not allowed to enable ipsec_crypto on a VF,
> until PF IPsec offloads are cleared.
> 
> Signed-off-by: Dima Chumak <dchumak@nvidia.com>
> ---
> v1 -> v2:
>  - Fix build when CONFIG_XFRM is not set.
>  - Fix switchdev mode init for HW that doesn't have ipsec_offload
>    capability
>  - Perform additional capability checks to test if ipsec_crypto offload
>    is supported by the HW
> ---
>  .../ethernet/mellanox/mlx5/switchdev.rst      |   8 +
>  .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
>  .../net/ethernet/mellanox/mlx5/core/devlink.c |   6 +-
>  .../mellanox/mlx5/core/en_accel/ipsec.c       |  18 +
>  .../ethernet/mellanox/mlx5/core/esw/ipsec.c   | 329 ++++++++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/eswitch.c |  29 ++
>  .../net/ethernet/mellanox/mlx5/core/eswitch.h |  23 ++
>  .../mellanox/mlx5/core/eswitch_offloads.c     | 105 ++++++
>  .../ethernet/mellanox/mlx5/core/lib/ipsec.h   |  41 +++
>  include/linux/mlx5/driver.h                   |   1 +
>  include/linux/mlx5/mlx5_ifc.h                 |   3 +
>  11 files changed, 563 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec.h

<...>

> @@ -622,6 +624,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
>  	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
>  	struct net_device *netdev = x->xso.real_dev;
>  	struct mlx5e_ipsec *ipsec;
> +	struct mlx5_eswitch *esw;
>  	struct mlx5e_priv *priv;
>  	gfp_t gfp;
>  	int err;
> @@ -646,6 +649,11 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
>  	if (err)
>  		goto err_xfrm;
>  
> +	esw = priv->mdev->priv.eswitch;
> +	if (esw && mlx5_esw_vport_ipsec_offload_enabled(esw))
> +		return -EBUSY;
> +	mlx5_eswitch_ipsec_offloads_count_inc(priv->mdev);


<...>

> +void mlx5_esw_vport_ipsec_offload_enable(struct mlx5_eswitch *esw)
> +{
> +	esw->enabled_ipsec_vf_count++;
> +	WARN_ON(!esw->enabled_ipsec_vf_count);
> +}
> +
> +void mlx5_esw_vport_ipsec_offload_disable(struct mlx5_eswitch *esw)
> +{
> +	esw->enabled_ipsec_vf_count--;
> +	WARN_ON(esw->enabled_ipsec_vf_count == U16_MAX);
> +}
> +
> +bool mlx5_esw_vport_ipsec_offload_enabled(struct mlx5_eswitch *esw)
> +{
> +	return !!esw->enabled_ipsec_vf_count;
> +}

I afraid that without proper locking everything above is racy.

We are storing all offloaded SAs in Xarray DB, so you can simply check
if that DB is empty or not by calling to xa_empty(). However, it will be
not an easy task to make proper locking.

So I would expect to see here something close
to mlx5_eswitch_block_encap/mlx5_eswitch_unblock_encap, which take devlink and
eswitch locks in the right order.

Thanks
