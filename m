Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63A5687BCB
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjBBLMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjBBLMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:12:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820B812596
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 03:12:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E24A61ADA
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 11:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80B8C433A4;
        Thu,  2 Feb 2023 11:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675336322;
        bh=SDbKFBzTPLybvoUMPF2tzTClvG/DsLOpABSl9IK8/O0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NoLgYVS9UEgb7wwy+PpN0yiFDDFKd3Uo9ZJmQRvTXfdB/9i0ysA9RZgq5Fpx8zKr/
         yd5bWe3ZzwNd3jiL3LxRp0SNgReaVKNyHy8K1g2bmgoGD49duZ10nAvYyOL+r2871X
         Otw/mSG38VydyLLCyUd790W6dyGanA0sZ9QZbNTrZU6/9pHeiRGfsqO1TZCtJwfY6a
         d7k5bmU+MEHGQGhxt2R5/Kg4vjq4Yq6Ekfg8MI6IBfIGRKBfbx+QaoJKxzkN4ggeyk
         YWYTvLr4gS1AODbJCDIyq4iIeHXjqgQPZIQv7+ugbgc0H+u+NkiFN28WE77wtB8AiV
         YE+pP4q4h8caw==
Date:   Thu, 2 Feb 2023 13:11:57 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v7 6/6] net/mlx5e: TC, Set CT miss to the
 specific ct action instance
Message-ID: <Y9uafQ+6gyZFS8Wl@unreal>
References: <20230131091027.8093-1-paulb@nvidia.com>
 <20230131091027.8093-7-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131091027.8093-7-paulb@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 11:10:27AM +0200, Paul Blakey wrote:
> Currently, CT misses restore the missed chain on the tc skb extension so
> tc will continue from the relevant chain. Instead, restore the CT action's
> miss cookie on the extension, which will instruct tc to continue from the
> this specific CT action instance on the relevant filter's action list.
> 
> Map the CT action's miss_cookie to a new miss object (ACT_MISS), and use
> this miss mapping instead of the current chain miss object (CHAIN_MISS)
> for CT action misses.
> 
> To restore this new miss mapping value, add a RX restore rule for each
> such mapping value.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Oz Sholmo <ozsh@nvidia.com>
> ---
>  .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 32 +++++-----
>  .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |  2 +
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 61 ++++++++++++++++---
>  .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  6 ++
>  .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 +
>  5 files changed, 79 insertions(+), 24 deletions(-)

<...>

> -static bool mlx5e_tc_restore_skb_chain(struct sk_buff *skb, struct mlx5_tc_ct_priv *ct_priv,
> -				       u32 chain, u32 zone_restore_id,
> -				       u32 tunnel_id,  struct mlx5e_tc_update_priv *tc_priv)
> +static bool mlx5e_tc_restore_skb_tc_meta(struct sk_buff *skb, struct mlx5_tc_ct_priv *ct_priv,
> +					 struct mlx5_mapped_obj *mapped_obj, u32 zone_restore_id,
> +					 u32 tunnel_id,  struct mlx5e_tc_update_priv *tc_priv)
>  {
> +	u32 chain = mapped_obj->type == MLX5_MAPPED_OBJ_CHAIN ? mapped_obj->chain : 0;
> +	u64 act_miss_cookie = mapped_obj->type == MLX5_MAPPED_OBJ_ACT_MISS ?
> +			      mapped_obj->act_miss_cookie : 0;

It will be easier for reader if such assignment is separated from
variables declarations.

>  	struct mlx5e_priv *priv = netdev_priv(skb->dev);
>  	struct tc_skb_ext *tc_skb_ext;

<...>

> +void mlx5e_tc_action_miss_mapping_put(struct mlx5e_priv *priv, struct mlx5_flow_attr *attr,
> +				      u32 act_miss_mapping)
> +{
> +	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
> +	struct mapping_ctx *ctx = esw->offloads.reg_c0_obj_pool;

Reversed Christmas tree, please.

Thanks
