Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD153115ED
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhBEWpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:45:44 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:14053 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbhBENFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 08:05:46 -0500
Date:   Fri, 05 Feb 2021 13:03:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612530205; bh=3j2lZ80aPDVQbBRbqSe5SVXT7GRlnN8V+70zH4XgnmM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=H9hZFvGT+/344ukLx5zy3I4NISCOySc0Ws1ms2hJdrnqrYiLjy6zcTNZKPj7zwTnU
         YD6VaGXQJVW5BcsGWU+iuw/Na/HotIZNLsLy5pDQLSOLu6SHPbcBC7x+Ab/LSAfIq4
         06mQkqj+H+gVk9V98PtID5ofbe70FNZRxDrajglGNf6EhBeCMRWSzkErmbkB8VhkeH
         i8uM+RzswqcU4BtWcIKFMN39GNpk+yEoETpXglw4s3TT8+vcmUiiU7MYkpBHif4Qpp
         2nNRBhT/l593T0p8PDSqIoB33zapVODlGnQipF6Wg5lph3El9/FMjAKy5xH/J5r/rf
         oFYqgz3STfVlQ==
To:     Eric Dumazet <edumazet@google.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Saeed Mahameed <saeed@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Sperbeck <jsperbeck@google.com>,
        Jian Yang <jianyang@google.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net] net: gro: do not keep too many GRO packets in napi->rx_list
Message-ID: <20210205130238.5741-1-alobakin@pm.me>
In-Reply-To: <CANn89iJ4ki9m6ne0W72QZuSJsBvrv9BMf9Me5hL9gw2tUnHhWg@mail.gmail.com>
References: <20210204213146.4192368-1-eric.dumazet@gmail.com> <dbad0731e30c920cf4ab3458dfce3c73060e917c.camel@kernel.org> <CANn89iJ4ki9m6ne0W72QZuSJsBvrv9BMf9Me5hL9gw2tUnHhWg@mail.gmail.com>
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
Date: Thu, 4 Feb 2021 23:44:17 +0100

> On Thu, Feb 4, 2021 at 11:14 PM Saeed Mahameed <saeed@kernel.org> wrote:
> >
> > On Thu, 2021-02-04 at 13:31 -0800, Eric Dumazet wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > Commit c80794323e82 ("net: Fix packet reordering caused by GRO and
> > > listified RX cooperation") had the unfortunate effect of adding
> > > latencies in common workloads.
> > >
> > > Before the patch, GRO packets were immediately passed to
> > > upper stacks.
> > >
> > > After the patch, we can accumulate quite a lot of GRO
> > > packets (depdending on NAPI budget).
> > >
> >
> > Why napi budget ? looking at the code it seems to be more related to
> > MAX_GRO_SKBS * gro_normal_batch, since we are counting GRO SKBs as 1
>
>
> Simply because we call gro_normal_list() from napi_poll(),
>
> So we flush the napi rx_list every 64 packets under stress.(assuming
> NIC driver uses NAPI_POLL_WEIGHT),
> or more often if napi_complete_done() is called if the budget was not exh=
austed.

Saeed,

Eric means that if we have e.g. 8 GRO packets with 8 segs each, then
rx_list will be flushed only after processing of 64 ingress frames.

> GRO always has been able to keep MAX_GRO_SKBS in its layer, but no recent=
 patch
> has changed this part.
>
>
> >
> >
> > but maybe i am missing some information about the actual issue you are
> > hitting.
>
>
> Well, the issue is precisely described in the changelog.
>
> >
> >
> > > My fix is counting in napi->rx_count number of segments
> > > instead of number of logical packets.
> > >
> > > Fixes: c80794323e82 ("net: Fix packet reordering caused by GRO and
> > > listified RX cooperation")
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Bisected-by: John Sperbeck <jsperbeck@google.com>
> > > Tested-by: Jian Yang <jianyang@google.com>
> > > Cc: Maxim Mikityanskiy <maximmi@mellanox.com>
> > > Cc: Alexander Lobakin <alobakin@dlink.ru>

It's strange why mailmap didn't pick up my active email at pm.me.

Anyways, this fix is correct for me. It restores the original Edward's
logics, but without spurious out-of-order deliveries.
Moreover, the pre-patch behaviour can easily be achieved by increasing
net.core.gro_normal_batch if needed.

Thanks!

Reviewed-by: Alexander Lobakin <alobakin@pm.me>

> > > Cc: Saeed Mahameed <saeedm@mellanox.com>
> > > Cc: Edward Cree <ecree@solarflare.com>
> > > ---
> > >  net/core/dev.c | 11 ++++++-----
> > >  1 file changed, 6 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index
> > > a979b86dbacda9dfe31dd8b269024f7f0f5a8ef1..449b45b843d40ece7dd1e2ed6a5
> > > 996ee1db9f591 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -5735,10 +5735,11 @@ static void gro_normal_list(struct
> > > napi_struct *napi)
> > >  /* Queue one GRO_NORMAL SKB up for list processing. If batch size
> > > exceeded,
> > >   * pass the whole batch up to the stack.
> > >   */
> > > -static void gro_normal_one(struct napi_struct *napi, struct sk_buff
> > > *skb)
> > > +static void gro_normal_one(struct napi_struct *napi, struct sk_buff
> > > *skb, int segs)
> > >  {
> > >         list_add_tail(&skb->list, &napi->rx_list);
> > > -       if (++napi->rx_count >=3D gro_normal_batch)
> > > +       napi->rx_count +=3D segs;
> > > +       if (napi->rx_count >=3D gro_normal_batch)
> > >                 gro_normal_list(napi);
> > >  }
> > >
> > > @@ -5777,7 +5778,7 @@ static int napi_gro_complete(struct napi_struct
> > > *napi, struct sk_buff *skb)
> > >         }
> > >
> > >  out:
> > > -       gro_normal_one(napi, skb);
> > > +       gro_normal_one(napi, skb, NAPI_GRO_CB(skb)->count);
> >
> > Seems correct to me,
> >
> > Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

Al

