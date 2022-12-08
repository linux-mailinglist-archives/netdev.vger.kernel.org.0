Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B9A6475F7
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiLHTHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiLHTH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:07:27 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BBD9492A
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 11:07:23 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 130so2018348pfu.8
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 11:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p72DqsSWTk0V96ispZBBSfGe61c1WSp/d/Jwlj5rNog=;
        b=baD7IsgxJleNn3Su5CnlSO7rICWbWl4mmP35bA+EJ+xa7EJBFkj35Gk1NWZtXhmyE/
         53IUwcem9a5T02Db1x2pm5FfWEfhsiLpZ21IN5hkLJsVB/Txs7AGR4X6l6FAg7A9PIwx
         vBXUYATNPd1MVovwRZVJLPpMLZYjJIKOeLsaFZ+Qy5Sl1hRA0vl6fdOQEHup/+P8dhG4
         p78TEeVkvCUDybypa0o7FjmqJJjNHN4ZsvvhJhW97Dt6QXLJQy8ib3jbvFeYkIJfZklt
         hQ05He3oVVDuNHCM/p5VsaJj0AO6RMt0YtFMENaD/88HqikE+X6qxiBzWLSby39HfXt8
         OG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p72DqsSWTk0V96ispZBBSfGe61c1WSp/d/Jwlj5rNog=;
        b=JvHKwy0aTkSYSa0yLyQkb7g2O8B164eb+7FTfKlmIB5RaqS1WrA+A0gdBJcesrLB1g
         C7ECYhfFhx+9WmCZxRxsxa32l88Vj4nPM8j1o4Ucp1Qf+CGfQ3svfRAwvzdZ30ROXEUa
         JBJWb9R5H1+N16Lp6bEtr/OItLn9+iRQ8eLVf1KIFdotx2bQwqQQxvkp+RmeD3U9g1st
         S9vcCFV06qBk6NDvCnehbg/6cm5aKKLtp6UocJGLLCCoyx5ivXuxqLhCyCQ+XRAnOu8G
         vo1oyROdpvukkAs6iMhXgtATMdvsMJW/GPuk6EjRNmDYmUkS1kiFOY3iX9dZsl9DLRwE
         r77Q==
X-Gm-Message-State: ANoB5plRF9pI8RNG9/t8mWwKLQM9riW/sO3nrFqBQZx1PUobItiuEKTb
        RnKoixOswWP9k2gA+vVQ/2w8lknqAVNNiuLG25YaqA==
X-Google-Smtp-Source: AA0mqf6MG+ddiWqf4IpmAK44iS9BfOOxJ4NEc7q1DctE3S91gWYOJ7F0DkxPqbtq90opI2EQ+jdypRxpQcQ+J7o29mc=
X-Received: by 2002:a62:2785:0:b0:576:bb84:7b50 with SMTP id
 n127-20020a622785000000b00576bb847b50mr21665733pfn.71.1670526442493; Thu, 08
 Dec 2022 11:07:22 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-9-sdf@google.com>
 <d97a9bc2-7d78-44e5-b223-16723a11c021@gmail.com>
In-Reply-To: <d97a9bc2-7d78-44e5-b223-16723a11c021@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 8 Dec 2022 11:07:10 -0800
Message-ID: <CAKH8qBsuNGu_V+Ww7Ci57J4OrGv=dvGRA=ZEP7RsqLL-SMW29A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 08/12] mxl4: Support RX XDP metadata
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 10:09 PM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>
> Typo in title mxl4 -> mlx4.
> Preferably: net/mlx4_en.

Oh, I always have to fight with this. Somehow mxl feels more natural
:-) Thanks for spotting, will use net/mlx4_en instead. (presumably the
same should be for mlx5?)

> On 12/6/2022 4:45 AM, Stanislav Fomichev wrote:
> > RX timestamp and hash for now. Tested using the prog from the next
> > patch.
> >
> > Also enabling xdp metadata support; don't see why it's disabled,
> > there is enough headroom..
> >
> > Cc: Tariq Toukan <tariqt@nvidia.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   drivers/net/ethernet/mellanox/mlx4/en_clock.c | 13 +++++--
> >   .../net/ethernet/mellanox/mlx4/en_netdev.c    | 10 +++++
> >   drivers/net/ethernet/mellanox/mlx4/en_rx.c    | 38 ++++++++++++++++++-
> >   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |  1 +
> >   include/linux/mlx4/device.h                   |  7 ++++
> >   5 files changed, 64 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
> > index 98b5ffb4d729..9e3b76182088 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
> > @@ -58,9 +58,7 @@ u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
> >       return hi | lo;
> >   }
> >
> > -void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
> > -                         struct skb_shared_hwtstamps *hwts,
> > -                         u64 timestamp)
> > +u64 mlx4_en_get_hwtstamp(struct mlx4_en_dev *mdev, u64 timestamp)
> >   {
> >       unsigned int seq;
> >       u64 nsec;
> > @@ -70,8 +68,15 @@ void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
> >               nsec = timecounter_cyc2time(&mdev->clock, timestamp);
> >       } while (read_seqretry(&mdev->clock_lock, seq));
> >
> > +     return ns_to_ktime(nsec);
> > +}
> > +
> > +void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
> > +                         struct skb_shared_hwtstamps *hwts,
> > +                         u64 timestamp)
> > +{
> >       memset(hwts, 0, sizeof(struct skb_shared_hwtstamps));
> > -     hwts->hwtstamp = ns_to_ktime(nsec);
> > +     hwts->hwtstamp = mlx4_en_get_hwtstamp(mdev, timestamp);
> >   }
> >
> >   /**
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> > index 8800d3f1f55c..1cb63746a851 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> > @@ -2855,6 +2855,11 @@ static const struct net_device_ops mlx4_netdev_ops = {
> >       .ndo_features_check     = mlx4_en_features_check,
> >       .ndo_set_tx_maxrate     = mlx4_en_set_tx_maxrate,
> >       .ndo_bpf                = mlx4_xdp,
> > +
> > +     .ndo_xdp_rx_timestamp_supported = mlx4_xdp_rx_timestamp_supported,
> > +     .ndo_xdp_rx_timestamp   = mlx4_xdp_rx_timestamp,
> > +     .ndo_xdp_rx_hash_supported = mlx4_xdp_rx_hash_supported,
> > +     .ndo_xdp_rx_hash        = mlx4_xdp_rx_hash,
> >   };
> >
> >   static const struct net_device_ops mlx4_netdev_ops_master = {
> > @@ -2887,6 +2892,11 @@ static const struct net_device_ops mlx4_netdev_ops_master = {
> >       .ndo_features_check     = mlx4_en_features_check,
> >       .ndo_set_tx_maxrate     = mlx4_en_set_tx_maxrate,
> >       .ndo_bpf                = mlx4_xdp,
> > +
> > +     .ndo_xdp_rx_timestamp_supported = mlx4_xdp_rx_timestamp_supported,
> > +     .ndo_xdp_rx_timestamp   = mlx4_xdp_rx_timestamp,
> > +     .ndo_xdp_rx_hash_supported = mlx4_xdp_rx_hash_supported,
> > +     .ndo_xdp_rx_hash        = mlx4_xdp_rx_hash,
> >   };
> >
> >   struct mlx4_en_bond {
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > index 9c114fc723e3..1b8e1b2d8729 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > @@ -663,8 +663,40 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
> >
> >   struct mlx4_xdp_buff {
> >       struct xdp_buff xdp;
> > +     struct mlx4_cqe *cqe;
> > +     struct mlx4_en_dev *mdev;
> > +     struct mlx4_en_rx_ring *ring;
> > +     struct net_device *dev;
> >   };
> >
> > +bool mlx4_xdp_rx_timestamp_supported(const struct xdp_md *ctx)
> > +{
> > +     struct mlx4_xdp_buff *_ctx = (void *)ctx;
> > +
> > +     return _ctx->ring->hwtstamp_rx_filter == HWTSTAMP_FILTER_ALL;
> > +}
> > +
> > +u64 mlx4_xdp_rx_timestamp(const struct xdp_md *ctx)
> > +{
> > +     struct mlx4_xdp_buff *_ctx = (void *)ctx;
> > +
> > +     return mlx4_en_get_hwtstamp(_ctx->mdev, mlx4_en_get_cqe_ts(_ctx->cqe));
> > +}
> > +
> > +bool mlx4_xdp_rx_hash_supported(const struct xdp_md *ctx)
> > +{
> > +     struct mlx4_xdp_buff *_ctx = (void *)ctx;
> > +
> > +     return _ctx->dev->features & NETIF_F_RXHASH;
> > +}
> > +
> > +u32 mlx4_xdp_rx_hash(const struct xdp_md *ctx)
> > +{
> > +     struct mlx4_xdp_buff *_ctx = (void *)ctx;
> > +
> > +     return be32_to_cpu(_ctx->cqe->immed_rss_invalid);
> > +}
> > +
> >   int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
> >   {
> >       struct mlx4_en_priv *priv = netdev_priv(dev);
> > @@ -781,8 +813,12 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
> >                                               DMA_FROM_DEVICE);
> >
> >                       xdp_prepare_buff(&mxbuf.xdp, va - frags[0].page_offset,
> > -                                      frags[0].page_offset, length, false);
> > +                                      frags[0].page_offset, length, true);
> >                       orig_data = mxbuf.xdp.data;
> > +                     mxbuf.cqe = cqe;
> > +                     mxbuf.mdev = priv->mdev;
> > +                     mxbuf.ring = ring;
> > +                     mxbuf.dev = dev;
> >
> >                       act = bpf_prog_run_xdp(xdp_prog, &mxbuf.xdp);
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> > index e132ff4c82f2..b7c0d4899ad7 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> > +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> > @@ -792,6 +792,7 @@ int mlx4_en_netdev_event(struct notifier_block *this,
> >    * Functions for time stamping
> >    */
> >   u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe);
> > +u64 mlx4_en_get_hwtstamp(struct mlx4_en_dev *mdev, u64 timestamp);
> >   void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
> >                           struct skb_shared_hwtstamps *hwts,
> >                           u64 timestamp);
> > diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
> > index 6646634a0b9d..d5904da1d490 100644
> > --- a/include/linux/mlx4/device.h
> > +++ b/include/linux/mlx4/device.h
> > @@ -1585,4 +1585,11 @@ static inline int mlx4_get_num_reserved_uar(struct mlx4_dev *dev)
> >       /* The first 128 UARs are used for EQ doorbells */
> >       return (128 >> (PAGE_SHIFT - dev->uar_page_shift));
> >   }
> > +
> > +struct xdp_md;
> > +bool mlx4_xdp_rx_timestamp_supported(const struct xdp_md *ctx);
> > +u64 mlx4_xdp_rx_timestamp(const struct xdp_md *ctx);
> > +bool mlx4_xdp_rx_hash_supported(const struct xdp_md *ctx);
> > +u32 mlx4_xdp_rx_hash(const struct xdp_md *ctx);
> > +
>
> These are ethernet only functions, not known to the mlx4 core driver.
> Please move to mlx4_en.h, and use mlx4_en_xdp_*() prefix.

For sure, thanks for the review!

> >   #endif /* MLX4_DEVICE_H */
