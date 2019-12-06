Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E04B114DF9
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 10:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfLFJDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 04:03:15 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:32994 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfLFJDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 04:03:14 -0500
Received: by mail-qt1-f196.google.com with SMTP id d5so6525198qto.0;
        Fri, 06 Dec 2019 01:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4tbKkekER333Twvb67f3cngnfvkAi6jTZ/GdJ9JgPf4=;
        b=X9co4B3rVbqTvYyDPm9FqucKm6+Q1DL49DK6Sy6cWrgSnw71hIbGMnfEe23XaBprnu
         oO1WzWFXwj2dG1DJ0N40WjuRYZUf81y7dcJ/ce2chdHtWq2HW26f7J+bvUJvDlE1rUGT
         0U1l/efPbNisPqZ1SPnr/MmC1piDj5OlSAdNyQcXMnIQlIloFgNG1qlsbYYI2e3A0Sy0
         WN3rFPIOUvfyp4F9PMsBuiIWpXRJL0E7e2WwJm0XonBoxkxl3u0q9eGFAr9JFF4uc4eU
         CyKEAyEUvF9scYRyg/mmVoT8DIJ0uPN3P54iJKpSvm1UFt5I9r97Iv6Orn+l9WQxKsFB
         S78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4tbKkekER333Twvb67f3cngnfvkAi6jTZ/GdJ9JgPf4=;
        b=brDMDAlDd4sFfgTSH6cH++Xqke1K/NXK5gwrFkX7461tgj5tms2uFAFW7Gh2INdWYr
         eIbRLTuEgkkcuUUxXGPIyKhT1wJYSsLWGNgg0kt4HD8XvZj/U4m1JSmwG9SVid68YcJ0
         y7v4beUBAZh41X6x4Qk6sE+/QFebmoQsiOo5v8WvlUOf5keKrfE4XFqRlUT63S50cMRS
         zzZ3o7iiKj37IIsoiDTkKKwjE3vTq0+ugkcUbJbS+8JZHJldJZZKffFmKzui2zre/1NH
         hv/p1ff/GxoCe0OBS6ujYe95+6Af0eZOyO4WWZ2s54TqMz+d3Ex/DZlX2hw4vKX8MjwP
         ezOw==
X-Gm-Message-State: APjAAAXvB2ppY/qgO+kcrJQhC1iByAkLrUnKqE5m5Ww2TFDgOBIXoZ6T
        qyZoFl3e7bYfA8n9vwyfM5TWscVu6TzOphyjctk=
X-Google-Smtp-Source: APXvYqxwa1tM15HsIA/KM2bFVG8a5aIU1GoDhuDHG1k00LBd1hJSPKslpC210A0c9MjxsPOIsYp0rhIJnm0ZpXMmSBE=
X-Received: by 2002:ac8:2310:: with SMTP id a16mr11592314qta.46.1575622993436;
 Fri, 06 Dec 2019 01:03:13 -0800 (PST)
MIME-Version: 1.0
References: <20191205155028.28854-1-maximmi@mellanox.com> <20191205155028.28854-3-maximmi@mellanox.com>
In-Reply-To: <20191205155028.28854-3-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 6 Dec 2019 10:03:02 +0100
Message-ID: <CAJ+HfNhnDr7CA4b-y_9dQXjhraRY9hWuN_mGdfnHQ752EzHAmQ@mail.gmail.com>
Subject: Re: [PATCH bpf 2/4] net/mlx5e: Fix concurrency issues between config
 flow and XSK
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Dec 2019 at 16:52, Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> After disabling resources necessary for XSK (the XDP program, channels,
> XSK queues), use synchronize_rcu to wait until the XSK wakeup function
> finishes, before freeing the resources.
>
> Suspend XSK wakeups during switching channels. If the XDP program is
> being removed, synchronize_rcu before closing the old channels to allow
> XSK wakeup to complete.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 22 ++++++++-----------
>  .../mellanox/mlx5/core/en/xsk/setup.c         |  1 +
>  .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  2 +-
>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 +---------------
>  5 files changed, 13 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> index f1a7bc46f1c0..61084c3744ba 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -760,7 +760,7 @@ enum {
>         MLX5E_STATE_OPENED,
>         MLX5E_STATE_DESTROYING,
>         MLX5E_STATE_XDP_TX_ENABLED,
> -       MLX5E_STATE_XDP_OPEN,
> +       MLX5E_STATE_XDP_ACTIVE,
>  };
>
>  struct mlx5e_rqt {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> index 36ac1e3816b9..d7587f40ecae 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> @@ -75,12 +75,18 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
>  static inline void mlx5e_xdp_tx_enable(struct mlx5e_priv *priv)
>  {
>         set_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
> +
> +       if (priv->channels.params.xdp_prog)
> +               set_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
>  }
>
>  static inline void mlx5e_xdp_tx_disable(struct mlx5e_priv *priv)
>  {
> +       if (priv->channels.params.xdp_prog)
> +               clear_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
> +
>         clear_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
> -       /* let other device's napi(s) see our new state */
> +       /* Let other device's napi(s) and XSK wakeups see our new state. */
>         synchronize_rcu();
>  }
>
> @@ -89,19 +95,9 @@ static inline bool mlx5e_xdp_tx_is_enabled(struct mlx5e_priv *priv)
>         return test_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
>  }
>
> -static inline void mlx5e_xdp_set_open(struct mlx5e_priv *priv)
> -{
> -       set_bit(MLX5E_STATE_XDP_OPEN, &priv->state);
> -}
> -
> -static inline void mlx5e_xdp_set_closed(struct mlx5e_priv *priv)
> -{
> -       clear_bit(MLX5E_STATE_XDP_OPEN, &priv->state);
> -}
> -
> -static inline bool mlx5e_xdp_is_open(struct mlx5e_priv *priv)
> +static inline bool mlx5e_xdp_is_active(struct mlx5e_priv *priv)
>  {
> -       return test_bit(MLX5E_STATE_XDP_OPEN, &priv->state);
> +       return test_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
>  }
>
>  static inline void mlx5e_xmit_xdp_doorbell(struct mlx5e_xdpsq *sq)
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
> index 631af8dee517..c28cbae42331 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
> @@ -144,6 +144,7 @@ void mlx5e_close_xsk(struct mlx5e_channel *c)
>  {
>         clear_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
>         napi_synchronize(&c->napi);
> +       synchronize_rcu(); /* Sync with the XSK wakeup. */

Again, so my idea was that the read-lock can be done here, instead of
the generic AF_XDP code, since it's driver specific. Agree?

>
>         mlx5e_close_rq(&c->xskrq);
>         mlx5e_close_cq(&c->xskrq.cq);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
> index 87827477d38c..fe2d596cb361 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
> @@ -14,7 +14,7 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
>         struct mlx5e_channel *c;
>         u16 ix;
>
> -       if (unlikely(!mlx5e_xdp_is_open(priv)))
> +       if (unlikely(!mlx5e_xdp_is_active(priv)))
>                 return -ENETDOWN;
>
>         if (unlikely(!mlx5e_qid_get_ch_if_in_group(params, qid, MLX5E_RQ_GROUP_XSK, &ix)))
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 09ed7f5f688b..fe1a42fa214b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -3006,12 +3006,9 @@ void mlx5e_timestamp_init(struct mlx5e_priv *priv)
>  int mlx5e_open_locked(struct net_device *netdev)
>  {
>         struct mlx5e_priv *priv = netdev_priv(netdev);
> -       bool is_xdp = priv->channels.params.xdp_prog;
>         int err;
>
>         set_bit(MLX5E_STATE_OPENED, &priv->state);
> -       if (is_xdp)
> -               mlx5e_xdp_set_open(priv);
>
>         err = mlx5e_open_channels(priv, &priv->channels);
>         if (err)
> @@ -3026,8 +3023,6 @@ int mlx5e_open_locked(struct net_device *netdev)
>         return 0;
>
>  err_clear_state_opened_flag:
> -       if (is_xdp)
> -               mlx5e_xdp_set_closed(priv);
>         clear_bit(MLX5E_STATE_OPENED, &priv->state);
>         return err;
>  }
> @@ -3059,8 +3054,6 @@ int mlx5e_close_locked(struct net_device *netdev)
>         if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
>                 return 0;
>
> -       if (priv->channels.params.xdp_prog)
> -               mlx5e_xdp_set_closed(priv);
>         clear_bit(MLX5E_STATE_OPENED, &priv->state);
>
>         netif_carrier_off(priv->netdev);
> @@ -4377,16 +4370,6 @@ static int mlx5e_xdp_allowed(struct mlx5e_priv *priv, struct bpf_prog *prog)
>         return 0;
>  }
>
> -static int mlx5e_xdp_update_state(struct mlx5e_priv *priv)
> -{
> -       if (priv->channels.params.xdp_prog)
> -               mlx5e_xdp_set_open(priv);
> -       else
> -               mlx5e_xdp_set_closed(priv);
> -
> -       return 0;
> -}
> -
>  static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
>  {
>         struct mlx5e_priv *priv = netdev_priv(netdev);
> @@ -4421,7 +4404,7 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
>                 mlx5e_set_rq_type(priv->mdev, &new_channels.params);
>                 old_prog = priv->channels.params.xdp_prog;
>
> -               err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_xdp_update_state);
> +               err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
>                 if (err)
>                         goto unlock;
>         } else {
> --
> 2.20.1
>
