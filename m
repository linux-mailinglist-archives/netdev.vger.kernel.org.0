Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F32339677
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 19:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhCLS2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 13:28:38 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:52700 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbhCLS2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 13:28:22 -0500
Date:   Fri, 12 Mar 2021 18:28:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615573700; bh=L0uazoUIkN0zjdIavDun3gMD7KLrxkBn0hh1tsNwdYA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=nJrLBQ7QGtRHzE4HZ5TSZc7Iemy7dzVq8QJGuIEOco91HRWWipj82pCJeYaF1PTps
         kyr0+E0pBF+rH7GwUwVn6o9k/MKF/7g4YXni56+7Kw3uohsUD3tA0I1bPr47KT9q5v
         w/qMenB5m40w+KcGbqDiCaknD5JHTpTpLiNkPJsFpvoMEhrznz15eNVJxXktIyTaew
         hepGGaYI4w6w3lFIwzbl5DrhhqsrY2Sbs6D//JuMGNkhax93/0QYVOJg6OrO0I8bGA
         NyLhmbHZnnLiISbJtKI1M0Asn5rAV5a7b86qfjYngFIZSCuUtbC7J2GsJ9M3FZEtzz
         FYYwPjXgqOp2w==
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
Subject: Re: [PATCH net-next 4/4] gro: improve flow distribution across GRO buckets in dev_gro_receive()
Message-ID: <20210312182754.241807-1-alobakin@pm.me>
In-Reply-To: <CANn89i+T-r=i3GBv-9EWBjpR_NhgZ=vP08BwTGXc8Kw3nO+OEQ@mail.gmail.com>
References: <20210312162127.239795-1-alobakin@pm.me> <20210312162127.239795-5-alobakin@pm.me> <CANn89i+T-r=i3GBv-9EWBjpR_NhgZ=vP08BwTGXc8Kw3nO+OEQ@mail.gmail.com>
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
Date: Fri, 12 Mar 2021 17:33:53 +0100

> On Fri, Mar 12, 2021 at 5:22 PM Alexander Lobakin <alobakin@pm.me> wrote:
> >
> > Most of the functions that "convert" hash value into an index
> > (when RPS is configured / XPS is not configured / etc.) set
> > reciprocal_scale() on it. Its logics is simple, but fair enough and
> > accounts the entire input value.
> > On the opposite side, 'hash & (GRO_HASH_BUCKETS - 1)' expression uses
> > only 3 least significant bits of the value, which is far from
> > optimal (especially for XOR RSS hashers, where the hashes of two
> > different flows may differ only by 1 bit somewhere in the middle).
> >
> > Use reciprocal_scale() here too to take the entire hash value into
> > account and improve flow dispersion between GRO hash buckets.
> >
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  net/core/dev.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 65d9e7d9d1e8..bd7c9ba54623 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -5952,7 +5952,7 @@ static void gro_flush_oldest(struct napi_struct *=
napi, struct list_head *head)
> >
> >  static enum gro_result dev_gro_receive(struct napi_struct *napi, struc=
t sk_buff *skb)
> >  {
> > -       u32 bucket =3D skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
> > +       u32 bucket =3D reciprocal_scale(skb_get_hash_raw(skb), GRO_HASH=
_BUCKETS);
>
> This is going to use 3 high order bits instead of 3 low-order bits.

We-e-ell, seems like it.

> Now, had you use hash_32(skb_get_hash_raw(skb), 3), you could have
> claimed to use "more bits"

Nice suggestion, I'll try. If there won't be any visible improvements,
I'll just drop this one.

> Toeplitz already shuffles stuff.

As well as CRC and others, but I feel like we shouldn't rely only on
the hardware.

> Adding a multiply here seems not needed.
>
> Please provide experimental results, because this looks unnecessary to me=
.

Thanks,
Al

