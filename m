Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DB63641C7
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 14:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239146AbhDSMiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 08:38:11 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:62981 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbhDSMiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 08:38:10 -0400
Date:   Mon, 19 Apr 2021 12:37:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1618835859; bh=hAip5T1OKUqZJna/3RbmtxAVwcUejPt/uS4wnGoJlVk=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=CBNpDCGdHI2HZN83e6vJIpGeykxkCikGjDAJbWyQLvLYTxM0DzxBFt57PC/jevGEF
         DOxe5LZbe5VJ1tRBcy+gU/DfPc02maVS+78gu0fb8YtTm0qpcVD6QduFpTZwgsTLzz
         Zxm1HvEb5Dqx6ORvKyphrviCO/hcirX6fPzR02KTTgXsfI4Ue3aBiPCC41OwyZmuci
         jjmgKHzPm3/4oYtpUejiCOcGk3QIbl2fY6ZfmKj2QI9049UlpEpncNk50UKfCI3K4Z
         01Ky7Wc7YMFMleWN7dG9kh/a+S0pu/4p3XECQZ0FSWHakGAXNeICvy1tdGSaNuw13/
         GB7OAgOyPsE9A==
To:     Eric Dumazet <edumazet@google.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net] gro: fix napi_gro_frags() Fast GRO breakage due to IP alignment check
Message-ID: <20210419123720.4421-1-alobakin@pm.me>
In-Reply-To: <CANn89iJQebFaJKsj3BC0tY27f1ttDpbpMOXjOFtgrFNVN_B9wA@mail.gmail.com>
References: <20210418114200.5839-1-alobakin@pm.me> <CANn89iJQebFaJKsj3BC0tY27f1ttDpbpMOXjOFtgrFNVN_B9wA@mail.gmail.com>
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
Date: Mon, 19 Apr 2021 13:05:16 +0200

> On Sun, Apr 18, 2021 at 1:43 PM Alexander Lobakin <alobakin@pm.me> wrote:
> >
> > Commit 38ec4944b593 ("gro: ensure frag0 meets IP header alignment")
> > did the right thing, but missed the fact that napi_gro_frags() logics
> > calls for skb_gro_reset_offset() *before* pulling Ethernet header
> > to the skb linear space.
> > That said, the introduced check for frag0 address being aligned to 4
> > always fails for it as Ethernet header is obviously 14 bytes long,
> > and in case with NET_IP_ALIGN its start is not aligned to 4.
> >
> > Fix this by adding @nhoff argument to skb_gro_reset_offset() which
> > tells if an IP header is placed right at the start of frag0 or not.
> > This restores Fast GRO for napi_gro_frags() that became very slow
> > after the mentioned commit, and preserves the introduced check to
> > avoid silent unaligned accesses.
> >
> > Fixes: 38ec4944b593 ("gro: ensure frag0 meets IP header alignment")
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  net/core/dev.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 1f79b9aa9a3f..965d5f9b6fee 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -5914,7 +5914,7 @@ static struct list_head *gro_list_prepare(struct =
napi_struct *napi,
> >         return head;
> >  }
> >
> > -static void skb_gro_reset_offset(struct sk_buff *skb)
> > +static void skb_gro_reset_offset(struct sk_buff *skb, u32 nhoff)
> >  {
> >         const struct skb_shared_info *pinfo =3D skb_shinfo(skb);
> >         const skb_frag_t *frag0 =3D &pinfo->frags[0];
> > @@ -5925,7 +5925,7 @@ static void skb_gro_reset_offset(struct sk_buff *=
skb)
> >
> >         if (!skb_headlen(skb) && pinfo->nr_frags &&
> >             !PageHighMem(skb_frag_page(frag0)) &&
> > -           (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))) {
> > +           (!NET_IP_ALIGN || !((skb_frag_off(frag0) + nhoff) & 3))) {
> >                 NAPI_GRO_CB(skb)->frag0 =3D skb_frag_address(frag0);
> >                 NAPI_GRO_CB(skb)->frag0_len =3D min_t(unsigned int,
> >                                                     skb_frag_size(frag0=
),
> > @@ -6143,7 +6143,7 @@ gro_result_t napi_gro_receive(struct napi_struct =
*napi, struct sk_buff *skb)
> >         skb_mark_napi_id(skb, napi);
> >         trace_napi_gro_receive_entry(skb);
> >
> > -       skb_gro_reset_offset(skb);
> > +       skb_gro_reset_offset(skb, 0);
> >
> >         ret =3D napi_skb_finish(napi, skb, dev_gro_receive(napi, skb));
> >         trace_napi_gro_receive_exit(ret);
> > @@ -6232,7 +6232,7 @@ static struct sk_buff *napi_frags_skb(struct napi=
_struct *napi)
> >         napi->skb =3D NULL;
> >
> >         skb_reset_mac_header(skb);
> > -       skb_gro_reset_offset(skb);
> > +       skb_gro_reset_offset(skb, hlen);
> >
> >         if (unlikely(skb_gro_header_hard(skb, hlen))) {
> >                 eth =3D skb_gro_header_slow(skb, hlen, 0);
> > --
> > 2.31.1
> >
> >
>
> Good catch, thanks.
>
> This has the unfortunate effect of increasing code length on x86,
> maybe we should have an exception to
> normal rules so that skb_gro_reset_offset() is inlined.

Agree. To mitigate this codegrowth we either go with NET_IP_ALIGN
ifdeffery or just inline skb_gro_reset_offset(). The function is
tiny itself, I don't see a reason to not do this.
Will drop v2 in a moment.

> Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks,
Al

