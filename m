Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267546686D8
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 23:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjALWXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 17:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240646AbjALWXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 17:23:01 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E97E34D67
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 14:18:22 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id v127so16151483vsb.12
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 14:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Ak9ex9KkP5k38I4thsB2lxDQYxF0p3f9sAxehfdP/E=;
        b=WjyLs8JpR6uQN07KdVnnGclEVuKMrAfN0yrX3wxESLDPu18HY2PvLDyvf4yFuXS+yF
         E5exeTs8QntT8dIsSAW2iYssL5vZfrUzu6tbMCyb5+Q/K2QXdfxA4TSQmdckHFun1npT
         wcANb2TmKXJ3lYL3i1CTvd21ZEwHGb67EBh/6oNJVfPf1I38TUYMRXQn9jE+ouCy0IB6
         x5rfLsQTrFMSw1U43lemYZRdJkpKFRObmNONlhh7TaRxN6N3hMbus8anPaxvf6c/4AkZ
         nDkTYAyqtk7OfVKr4V5kDmmdWMelnc8TMv3e9BdN6E34U50XJXKul6AFJhUYKxBqbM5b
         kOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Ak9ex9KkP5k38I4thsB2lxDQYxF0p3f9sAxehfdP/E=;
        b=LWx4HkVHhcennJh8crFVYF+Z7k1u8i0vxpsIeuL9RtfRVHV7NhcFkNaK6HGBLS/1aH
         sx2FC/LZtQjfFqokVixZOMCIUuwog9nmelPd/LqywH4PtFpLe2waFKHLRaR13PhIVpmb
         eZaBC1KhfFb/3xEQM8Omgi3r2fWZTZ1sPmuN5lFQ2meggR0FfwlZ8BoMlU080wnkF8dk
         5mmBwYCNE3xmR4MWJ6r2PKbRXGfSCuv/zEM2MyKMfaslCrKyEpiI1Y9XG4OYn2p2uosv
         augj42gZuNvEb6uFspIUTFcH/KbFqrj2Neh/4NLh7zw3JzPH6jom8hsO+u40SWXKhh1R
         8TsQ==
X-Gm-Message-State: AFqh2kpY05bUk3s93iynXav96lnChHjzVAHze2BpQe31tScay3LUSiLJ
        +gfKR5SSSLwfOUHffAu7wcHhAd/y0gQd11mUQxn6FA==
X-Google-Smtp-Source: AMrXdXvvxiGkdysW2Uyx28SEPTThJl9H/aX3/cdm7K4H6mPXNuXGEx/Szf7KIOuUy0O88DxhGujrAzbXtfaOHPoMQ+g=
X-Received: by 2002:a67:fd96:0:b0:3ce:a104:cc37 with SMTP id
 k22-20020a67fd96000000b003cea104cc37mr5801569vsq.2.1673561901277; Thu, 12 Jan
 2023 14:18:21 -0800 (PST)
MIME-Version: 1.0
References: <20230112003230.3779451-1-sdf@google.com> <20230112003230.3779451-16-sdf@google.com>
 <a0bac9bd-6772-64d4-8fd5-756ff4d8c2ad@gmail.com> <CAKH8qBsUOdRax0m5XM8guudSX_VYpJuMz_mzdMJegDsq4_ezwA@mail.gmail.com>
 <87k01rfojm.fsf@toke.dk> <87h6wvfmfa.fsf@toke.dk>
In-Reply-To: <87h6wvfmfa.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 12 Jan 2023 14:18:08 -0800
Message-ID: <CAKH8qBvBsAj0s36=xHKz3XN5Nq1bDcEP1AOsnf9+Sgtm5wWUyQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v7 15/17] net/mlx5e: Introduce
 wrapper for xdp_buff
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
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
Content-Transfer-Encoding: quoted-printable
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

On Thu, Jan 12, 2023 at 1:55 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:
>
> > Stanislav Fomichev <sdf@google.com> writes:
> >
> >> On Thu, Jan 12, 2023 at 12:07 AM Tariq Toukan <ttoukan.linux@gmail.com=
> wrote:
> >>>
> >>>
> >>>
> >>> On 12/01/2023 2:32, Stanislav Fomichev wrote:
> >>> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>> >
> >>> > Preparation for implementing HW metadata kfuncs. No functional chan=
ge.
> >>> >
> >>> > Cc: Tariq Toukan <tariqt@nvidia.com>
> >>> > Cc: Saeed Mahameed <saeedm@nvidia.com>
> >>> > Cc: John Fastabend <john.fastabend@gmail.com>
> >>> > Cc: David Ahern <dsahern@gmail.com>
> >>> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> >>> > Cc: Jakub Kicinski <kuba@kernel.org>
> >>> > Cc: Willem de Bruijn <willemb@google.com>
> >>> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> >>> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> >>> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> >>> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> >>> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> >>> > Cc: xdp-hints@xdp-project.net
> >>> > Cc: netdev@vger.kernel.org
> >>> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >>> > ---
> >>> >   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
> >>> >   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
> >>> >   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
> >>> >   .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 ++++----
> >>> >   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 +++++++++-----=
-----
> >>> >   5 files changed, 50 insertions(+), 43 deletions(-)
> >>> >
> >>> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers=
/net/ethernet/mellanox/mlx5/core/en.h
> >>> > index 2d77fb8a8a01..af663978d1b4 100644
> >>> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> >>> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> >>> > @@ -469,6 +469,7 @@ struct mlx5e_txqsq {
> >>> >   union mlx5e_alloc_unit {
> >>> >       struct page *page;
> >>> >       struct xdp_buff *xsk;
> >>> > +     struct mlx5e_xdp_buff *mxbuf;
> >>>
> >>> In XSK files below you mix usage of both alloc_units[page_idx].mxbuf =
and
> >>> alloc_units[page_idx].xsk, while both fields share the memory of a un=
ion.
> >>>
> >>> As struct mlx5e_xdp_buff wraps struct xdp_buff, I think that you just
> >>> need to change the existing xsk field type from struct xdp_buff *xsk
> >>> into struct mlx5e_xdp_buff *xsk and align the usage.
> >>
> >> Hmmm, good point. I'm actually not sure how it works currently.
> >> mlx5e_alloc_unit.mxbuf doesn't seem to be initialized anywhere? Toke,
> >> am I missing something?
> >
> > It's initialised piecemeal in different places; but yeah, we're mixing
> > things a bit...
> >
> >> I'm thinking about something like this:

Seems more invasive? I don't care much tbf, but what's wrong with
keeping 'xdp_buff xsk' member and use it consistently?

> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> >> b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> >> index af663978d1b4..2d77fb8a8a01 100644
> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> >> @@ -469,7 +469,6 @@ struct mlx5e_txqsq {
> >>  union mlx5e_alloc_unit {
> >>         struct page *page;
> >>         struct xdp_buff *xsk;
> >> -       struct mlx5e_xdp_buff *mxbuf;
> >>  };
> >
> > Hmm, for consistency with the non-XSK path we should rather go the othe=
r
> > direction and lose the xsk member, moving everything to mxbuf? Let me
> > give that a shot...
>
> Something like the below?
>
> -Toke
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/e=
thernet/mellanox/mlx5/core/en.h
> index 6de02d8aeab8..cb9cdb6421c5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -468,7 +468,6 @@ struct mlx5e_txqsq {
>
>  union mlx5e_alloc_unit {
>         struct page *page;
> -       struct xdp_buff *xsk;
>         struct mlx5e_xdp_buff *mxbuf;
>  };
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en/xdp.h
> index cb568c62aba0..95694a25ec31 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> @@ -33,6 +33,7 @@
>  #define __MLX5_EN_XDP_H__
>
>  #include <linux/indirect_call_wrapper.h>
> +#include <net/xdp_sock_drv.h>
>
>  #include "en.h"
>  #include "en/txrx.h"
> @@ -112,6 +113,21 @@ static inline void mlx5e_xmit_xdp_doorbell(struct ml=
x5e_xdpsq *sq)
>         }
>  }
>
> +static inline struct mlx5e_xdp_buff *mlx5e_xsk_buff_alloc(struct xsk_buf=
f_pool *pool)
> +{
> +       return (struct mlx5e_xdp_buff *)xsk_buff_alloc(pool);
> +}
> +
> +static inline void mlx5e_xsk_buff_free(struct mlx5e_xdp_buff *mxbuf)
> +{
> +       xsk_buff_free(&mxbuf->xdp);
> +}
> +
> +static inline dma_addr_t mlx5e_xsk_buff_xdp_get_frame_dma(struct mlx5e_x=
dp_buff *mxbuf)
> +{
> +       return xsk_buff_xdp_get_frame_dma(&mxbuf->xdp);
> +}
> +
>  /* Enable inline WQEs to shift some load from a congested HCA (HW) to
>   * a less congested cpu (SW).
>   */
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/driver=
s/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> index 8bf3029abd3c..1f166dbb7f22 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> @@ -3,7 +3,6 @@
>
>  #include "rx.h"
>  #include "en/xdp.h"
> -#include <net/xdp_sock_drv.h>
>  #include <linux/filter.h>
>
>  /* RX data path */
> @@ -21,7 +20,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 i=
x)
>         if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool, rq->mpwqe.pages_pe=
r_wqe)))
>                 goto err;
>
> -       BUILD_BUG_ON(sizeof(wi->alloc_units[0]) !=3D sizeof(wi->alloc_uni=
ts[0].xsk));
> +       BUILD_BUG_ON(sizeof(wi->alloc_units[0]) !=3D sizeof(wi->alloc_uni=
ts[0].mxbuf));
>         batch =3D xsk_buff_alloc_batch(rq->xsk_pool, (struct xdp_buff **)=
wi->alloc_units,
>                                      rq->mpwqe.pages_per_wqe);
> @@ -33,8 +32,8 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 i=
x)
>          * the first error, which will mean there are no more valid descr=
iptors.
>          */
>         for (; batch < rq->mpwqe.pages_per_wqe; batch++) {
> -               wi->alloc_units[batch].xsk =3D xsk_buff_alloc(rq->xsk_poo=
l);
> -               if (unlikely(!wi->alloc_units[batch].xsk))
> +               wi->alloc_units[batch].mxbuf =3D mlx5e_xsk_buff_alloc(rq-=
>xsk_pool);
> +               if (unlikely(!wi->alloc_units[batch].mxbuf))
>                         goto err_reuse_batch;
>         }
>
> @@ -44,7 +43,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 i=
x)
>
>         if (likely(rq->mpwqe.umr_mode =3D=3D MLX5E_MPWRQ_UMR_MODE_ALIGNED=
)) {
>                 for (i =3D 0; i < batch; i++) {
> -                       dma_addr_t addr =3D xsk_buff_xdp_get_frame_dma(wi=
->alloc_units[i].xsk);
> +                       dma_addr_t addr =3D mlx5e_xsk_buff_xdp_get_frame_=
dma(wi->alloc_units[i].mxbuf);
>
>                         umr_wqe->inline_mtts[i] =3D (struct mlx5_mtt) {
>                                 .ptag =3D cpu_to_be64(addr | MLX5_EN_WR),
> @@ -53,7 +52,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 i=
x)
>                 }
>         } else if (unlikely(rq->mpwqe.umr_mode =3D=3D MLX5E_MPWRQ_UMR_MOD=
E_UNALIGNED)) {
>                 for (i =3D 0; i < batch; i++) {
> -                       dma_addr_t addr =3D xsk_buff_xdp_get_frame_dma(wi=
->alloc_units[i].xsk);
> +                       dma_addr_t addr =3D mlx5e_xsk_buff_xdp_get_frame_=
dma(wi->alloc_units[i].mxbuf);
>
>                         umr_wqe->inline_ksms[i] =3D (struct mlx5_ksm) {
>                                 .key =3D rq->mkey_be,
> @@ -65,7 +64,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 i=
x)
>                 u32 mapping_size =3D 1 << (rq->mpwqe.page_shift - 2);
>
>                 for (i =3D 0; i < batch; i++) {
> -                       dma_addr_t addr =3D xsk_buff_xdp_get_frame_dma(wi=
->alloc_units[i].xsk);
> +                       dma_addr_t addr =3D mlx5e_xsk_buff_xdp_get_frame_=
dma(wi->alloc_units[i].mxbuf);
>
>                         umr_wqe->inline_ksms[i << 2] =3D (struct mlx5_ksm=
) {
>                                 .key =3D rq->mkey_be,
> @@ -91,7 +90,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 i=
x)
>                 __be32 frame_size =3D cpu_to_be32(rq->xsk_pool->chunk_siz=
e);
>
>                 for (i =3D 0; i < batch; i++) {
> -                       dma_addr_t addr =3D xsk_buff_xdp_get_frame_dma(wi=
->alloc_units[i].xsk);
> +                       dma_addr_t addr =3D mlx5e_xsk_buff_xdp_get_frame_=
dma(wi->alloc_units[i].mxbuf);
>
>                         umr_wqe->inline_klms[i << 1] =3D (struct mlx5_klm=
) {
>                                 .key =3D rq->mkey_be,
> @@ -137,7 +136,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16=
 ix)
>
>  err_reuse_batch:
>         while (--batch >=3D 0)
> -               xsk_buff_free(wi->alloc_units[batch].xsk);
> +               mlx5e_xsk_buff_free(wi->alloc_units[batch].mxbuf);
>
>  err:
>         rq->stats->buff_alloc_err++;
> @@ -156,7 +155,7 @@ int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *=
rq, u16 ix, int wqe_bulk)
>          * allocate XDP buffers straight into alloc_units.
>          */
>         BUILD_BUG_ON(sizeof(rq->wqe.alloc_units[0]) !=3D
> -                    sizeof(rq->wqe.alloc_units[0].xsk));
> +                    sizeof(rq->wqe.alloc_units[0].mxbuf));
>         buffs =3D (struct xdp_buff **)rq->wqe.alloc_units;
>         contig =3D mlx5_wq_cyc_get_size(wq) - ix;
>         if (wqe_bulk <=3D contig) {
> @@ -177,8 +176,9 @@ int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *=
rq, u16 ix, int wqe_bulk)
>                 /* Assumes log_num_frags =3D=3D 0. */
>                 frag =3D &rq->wqe.frags[j];
>
> -               addr =3D xsk_buff_xdp_get_frame_dma(frag->au->xsk);
> +               addr =3D mlx5e_xsk_buff_xdp_get_frame_dma(frag->au->mxbuf=
);
>                 wqe->data[0].addr =3D cpu_to_be64(addr + rq->buff.headroo=
m);
> +               frag->au->mxbuf->rq =3D rq;
>         }
>
>         return alloc;
> @@ -199,12 +199,13 @@ int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u1=
6 ix, int wqe_bulk)
>                 /* Assumes log_num_frags =3D=3D 0. */
>                 frag =3D &rq->wqe.frags[j];
>
> -               frag->au->xsk =3D xsk_buff_alloc(rq->xsk_pool);
> -               if (unlikely(!frag->au->xsk))
> +               frag->au->mxbuf =3D mlx5e_xsk_buff_alloc(rq->xsk_pool);
> +               if (unlikely(!frag->au->mxbuf))
>                         return i;
>
> -               addr =3D xsk_buff_xdp_get_frame_dma(frag->au->xsk);
> +               addr =3D mlx5e_xsk_buff_xdp_get_frame_dma(frag->au->mxbuf=
);
>                 wqe->data[0].addr =3D cpu_to_be64(addr + rq->buff.headroo=
m);
> +               frag->au->mxbuf->rq =3D rq;
>         }
>
>         return wqe_bulk;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_rx.c
> index 7b08653be000..4313165709cb 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -41,7 +41,6 @@
>  #include <net/gro.h>
>  #include <net/udp.h>
>  #include <net/tcp.h>
> -#include <net/xdp_sock_drv.h>
>  #include "en.h"
>  #include "en/txrx.h"
>  #include "en_tc.h"
> @@ -434,7 +433,7 @@ static inline void mlx5e_free_rx_wqe(struct mlx5e_rq =
*rq,
>                  * put into the Reuse Ring, because there is no way to re=
turn
>                  * the page to the userspace when the interface goes down=
.
>                  */
> -               xsk_buff_free(wi->au->xsk);
> +               mlx5e_xsk_buff_free(wi->au->mxbuf);
>                 return;
>         }
>
> @@ -515,7 +514,7 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e=
_mpw_info *wi, bool recycle
>                  */
>                 for (i =3D 0; i < rq->mpwqe.pages_per_wqe; i++)
>                         if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitm=
ap))
> -                               xsk_buff_free(alloc_units[i].xsk);
> +                               mlx5e_xsk_buff_free(alloc_units[i].mxbuf)=
;
>         } else {
>                 for (i =3D 0; i < rq->mpwqe.pages_per_wqe; i++)
>                         if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitm=
ap))
>
