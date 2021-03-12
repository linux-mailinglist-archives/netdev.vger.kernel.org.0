Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBDD3396BC
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 19:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbhCLShm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 13:37:42 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:62345 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbhCLShK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 13:37:10 -0500
Date:   Fri, 12 Mar 2021 18:36:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615574228; bh=C4flYNl55MhaTml/vQIThEyldeDzlRdNXoMAWOGH2ZU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Qz+2/NJcNf9bDM6PkSlnYsbqlAX12lI2+aZ/GiEqrund2o7VjfuoRcv6C6wXppBZ/
         KoPhQqf2NMM85+XnHD+Sv6xkuWlX5SSbwdl6T4l4yWf4mtRCVVsO7iWk4U2aVAXp43
         LUNM5aMMbaUXX38bZoM5qlBzvs5lq/eVz/SGkL9lHS0hEIiICmkGBLZoQ9yWrsOduv
         0bQA82/45rbBgfWo9CvaD7ugphtytM/W6s36VLDdjddneMRTOYprNMapNNHbs6Oj3t
         y/AM2DzN3A4JY6ZNFY5qeHHylgDPhXAdIkdQcBCqjt4eICH/IVr31XnaONkSATSWNN
         +GbDLk+9HPuTQ==
To:     Eric Dumazet <edumazet@google.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next 2/4] gro: don't dereference napi->gro_hash[x] multiple times in dev_gro_receive()
Message-ID: <20210312183648.242117-1-alobakin@pm.me>
In-Reply-To: <CANn89iJvmakwfLFb6QS1ettiJM-D3cJ89bFPvZ=Gk2YyGpxQuw@mail.gmail.com>
References: <20210312162127.239795-1-alobakin@pm.me> <20210312162127.239795-3-alobakin@pm.me> <CANn89iJvmakwfLFb6QS1ettiJM-D3cJ89bFPvZ=Gk2YyGpxQuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 12 Mar 2021 17:47:04 +0100

> On Fri, Mar 12, 2021 at 5:22 PM Alexander Lobakin <alobakin@pm.me> wrote:
> >
> > GRO bucket index doesn't change through the entire function.
> > Store a pointer to the corresponding bucket on stack once and use
> > it later instead of dereferencing again and again.
> >
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  net/core/dev.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index adc42ba7ffd8..ee124aecb8a2 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -5957,6 +5957,7 @@ static void gro_flush_oldest(struct napi_struct *=
napi, struct list_head *head)
> >  static enum gro_result dev_gro_receive(struct napi_struct *napi, struc=
t sk_buff *skb)
> >  {
> >         u32 bucket =3D skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
> > +       struct gro_list *gro_list =3D &napi->gro_hash[bucket];
> >         struct list_head *head =3D &offload_base;
> >         struct packet_offload *ptype;
> >         __be16 type =3D skb->protocol;
> > @@ -6024,7 +6025,7 @@ static enum gro_result dev_gro_receive(struct nap=
i_struct *napi, struct sk_buff
> >         if (pp) {
> >                 skb_list_del_init(pp);
> >                 napi_gro_complete(napi, pp);
> > -               napi->gro_hash[bucket].count--;
> > +               gro_list->count--;
> >         }
> >
> >         if (same_flow)
> > @@ -6033,10 +6034,10 @@ static enum gro_result dev_gro_receive(struct n=
api_struct *napi, struct sk_buff
> >         if (NAPI_GRO_CB(skb)->flush)
> >                 goto normal;
> >
> > -       if (unlikely(napi->gro_hash[bucket].count >=3D MAX_GRO_SKBS)) {
> > +       if (unlikely(gro_list->count >=3D MAX_GRO_SKBS)) {
> >                 gro_flush_oldest(napi, gro_head);
> >         } else {
> > -               napi->gro_hash[bucket].count++;
> > +               gro_list->count++;
> >         }
> >         NAPI_GRO_CB(skb)->count =3D 1;
> >         NAPI_GRO_CB(skb)->age =3D jiffies;
> > @@ -6050,7 +6051,7 @@ static enum gro_result dev_gro_receive(struct nap=
i_struct *napi, struct sk_buff
> >         if (grow > 0)
> >                 gro_pull_from_frag0(skb, grow);
> >  ok:
> > -       if (napi->gro_hash[bucket].count) {
> > +       if (gro_list->count) {
> >                 if (!test_bit(bucket, &napi->gro_bitmask))
> >                         __set_bit(bucket, &napi->gro_bitmask);
> >         } else if (test_bit(bucket, &napi->gro_bitmask)) {
> > --
> > 2.30.2
> >
> >
>
> This adds more register pressure, do you have precise measures to
> confirm this change is a win ?
>
> Presumably the compiler should be able to optimize the code just fine,
> it can see @bucket does not change.

This is mostly (if not purely) cosmetic, I don't think it changes
anything at all for the most of sane compilers.

Regarding registers, since @gro_list and @gro_head are pretty the
same, we could drop @gro_head in favour of @gro_list and just use
@gro_list->list instead.

Al

