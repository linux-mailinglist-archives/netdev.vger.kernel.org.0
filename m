Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5ED66E54F
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbjAQRxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjAQRuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:50:39 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E104C6D3
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 09:39:57 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id x4so19951768pfj.1
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 09:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XK7xzdzdVe8CAOdpvnaMlGGiF3ESCl5P5F97tw3Hmvg=;
        b=Bo/fvXvQjMj2VkfNfsG2/XkizXgJueapBJER2ZI5hoyThFRdHPDLfDEWHax8kqkUnu
         rhCvjfeJBSJp57/LgGBStLlQ+V1dTU8CRMrnnJcZzQfNNN7wkkSBWdbeDwju5gDaXRZO
         snC0/uTv9HYHju7rfgUaDawdhqNzat1jwwJVA40UISoxLice8ydvtcgME3HWm8mNFOHD
         J/mPYbcBuAb5twGkIGywQTVK+jOkNQW2XVgTcn23nUTaORTUw4Kgpabow1kRDRWGzZPa
         A1S8ZV2KU9ogph6ebuVar0k7i1dyLkexssoW61wdfUIuOi+Yask/PtExCbqVPZ34sdZX
         RT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XK7xzdzdVe8CAOdpvnaMlGGiF3ESCl5P5F97tw3Hmvg=;
        b=i3lkli4lQ934w7+mucqQYz4rZP7EST9cphrba9sGgBOIyHCnvexLia2Au9b4m9Ceql
         doy+am6wdYeSTMA1lY/uD99hgoKz9n894geD2e5J14jLbF22Nz2SVWDc60rn63REVqaN
         ExRD+DRZAZZRQea7HKP2R+L2hxfS7E0LU7p6h8qdqeN5W2WpnclAW8qgtvZDw9bWCjwr
         w9ssVNuQKSj1KQBOHvZvdLQID62vx3LGXpAiDQj7YsYOpKRl1qluqN4JU44IxVbadoLC
         Ogs4gp/X0LW+KH++kO1e/o68xIzZD/9A0V4FcQU9LXPOVxMceytaQHJvzpk54cq8sJBG
         YeSA==
X-Gm-Message-State: AFqh2kr4rFWBuyp6sfcxPuXO4bkd8lP9Xpoae7O2RXdjII/SsB4OhA8+
        9ahop8u/6gJbOJbDmeFW85L49/PbpHX/JwOnUkejIA==
X-Google-Smtp-Source: AMrXdXveAFX9cyZAAbfPqAt2oTkm5zlLnLt9gJol5S7J+lqdFJfIu+5uFGMXlrnRISTw3fQbg7WhXp2PvPQreY1MuRc=
X-Received: by 2002:a65:6c15:0:b0:492:703:3f03 with SMTP id
 y21-20020a656c15000000b0049207033f03mr366761pgu.403.1673977196822; Tue, 17
 Jan 2023 09:39:56 -0800 (PST)
MIME-Version: 1.0
References: <20230117172825.3170190-1-arnd@kernel.org>
In-Reply-To: <20230117172825.3170190-1-arnd@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 17 Jan 2023 09:39:45 -0800
Message-ID: <CAKwvOdn5dubVN6qetnWJgHb-wektML_ptQ53M2JBgOeX_+r9Jg@mail.gmail.com>
Subject: Re: [PATCH] mlx5: reduce stack usage in mlx5_setup_tc
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, Lama Kayal <lkayal@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 9:28 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> Clang warns about excessive stack usage on 32-bit targets:
>
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c:3597:12: error: stack frame size (1184) exceeds limit (1024) in 'mlx5e_setup_tc' [-Werror,-Wframe-larger-than]
> static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
>
> It turns out that both the mlx5e_setup_tc_mqprio_dcb() function and
> the mlx5e_safe_switch_params() function it calls have a copy of
> 'struct mlx5e_params' on the stack, and this structure is fairly
> large.

The logic changes LGTM, but were the noinline_for_stack left behind
from earlier local revisions? Do we still need those if these structs
have been moved from the stack?

>
> Use dynamic allocation for both.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 36 ++++++++++++-------
>  1 file changed, 23 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 6bb0fdaa5efa..e5198c26e383 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -2993,37 +2993,42 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
>         return err;
>  }
>
> -int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
> +noinline_for_stack int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
>                              struct mlx5e_params *params,
>                              mlx5e_fp_preactivate preactivate,
>                              void *context, bool reset)
>  {
> -       struct mlx5e_channels new_chs = {};
> +       struct mlx5e_channels *new_chs;
>         int err;
>
>         reset &= test_bit(MLX5E_STATE_OPENED, &priv->state);
>         if (!reset)
>                 return mlx5e_switch_priv_params(priv, params, preactivate, context);
>
> -       new_chs.params = *params;
> +       new_chs = kzalloc(sizeof(*new_chs), GFP_KERNEL);
> +       if (!new_chs)
> +               return -ENOMEM;
> +       new_chs->params = *params;
>
> -       mlx5e_selq_prepare_params(&priv->selq, &new_chs.params);
> +       mlx5e_selq_prepare_params(&priv->selq, &new_chs->params);
>
> -       err = mlx5e_open_channels(priv, &new_chs);
> +       err = mlx5e_open_channels(priv, new_chs);
>         if (err)
>                 goto err_cancel_selq;
>
> -       err = mlx5e_switch_priv_channels(priv, &new_chs, preactivate, context);
> +       err = mlx5e_switch_priv_channels(priv, new_chs, preactivate, context);
>         if (err)
>                 goto err_close;
>
> +       kfree(new_chs);
>         return 0;
>
>  err_close:
> -       mlx5e_close_channels(&new_chs);
> +       mlx5e_close_channels(new_chs);
>
>  err_cancel_selq:
>         mlx5e_selq_cancel(&priv->selq);
> +       kfree(new_chs);
>         return err;
>  }
>
> @@ -3419,10 +3424,10 @@ static void mlx5e_params_mqprio_reset(struct mlx5e_params *params)
>         mlx5e_params_mqprio_dcb_set(params, 1);
>  }
>
> -static int mlx5e_setup_tc_mqprio_dcb(struct mlx5e_priv *priv,
> +static noinline_for_stack int mlx5e_setup_tc_mqprio_dcb(struct mlx5e_priv *priv,
>                                      struct tc_mqprio_qopt *mqprio)
>  {
> -       struct mlx5e_params new_params;
> +       struct mlx5e_params *new_params;
>         u8 tc = mqprio->num_tc;
>         int err;
>
> @@ -3431,10 +3436,13 @@ static int mlx5e_setup_tc_mqprio_dcb(struct mlx5e_priv *priv,
>         if (tc && tc != MLX5E_MAX_NUM_TC)
>                 return -EINVAL;
>
> -       new_params = priv->channels.params;
> -       mlx5e_params_mqprio_dcb_set(&new_params, tc ? tc : 1);
> +       new_params = kmemdup(&priv->channels.params,
> +                            sizeof(priv->channels.params), GFP_KERNEL);
> +       if (!new_params)
> +               return -ENOMEM;
> +       mlx5e_params_mqprio_dcb_set(new_params, tc ? tc : 1);
>
> -       err = mlx5e_safe_switch_params(priv, &new_params,
> +       err = mlx5e_safe_switch_params(priv, new_params,
>                                        mlx5e_num_channels_changed_ctx, NULL, true);
>
>         if (!err && priv->mqprio_rl) {
> @@ -3445,6 +3453,8 @@ static int mlx5e_setup_tc_mqprio_dcb(struct mlx5e_priv *priv,
>
>         priv->max_opened_tc = max_t(u8, priv->max_opened_tc,
>                                     mlx5e_get_dcb_num_tc(&priv->channels.params));
> +
> +       kfree(new_params);
>         return err;
>  }
>
> @@ -3533,7 +3543,7 @@ static struct mlx5e_mqprio_rl *mlx5e_mqprio_rl_create(struct mlx5_core_dev *mdev
>         return rl;
>  }
>
> -static int mlx5e_setup_tc_mqprio_channel(struct mlx5e_priv *priv,
> +static noinline_for_stack int mlx5e_setup_tc_mqprio_channel(struct mlx5e_priv *priv,
>                                          struct tc_mqprio_qopt_offload *mqprio)
>  {
>         mlx5e_fp_preactivate preactivate;
> --
> 2.39.0
>


-- 
Thanks,
~Nick Desaulniers
