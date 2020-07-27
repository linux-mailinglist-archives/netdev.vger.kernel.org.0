Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2854C22F45E
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgG0QKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728384AbgG0QKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:10:01 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A545C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:10:01 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x9so9032812ybd.4
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6WkMXhPlqouOzrZ+HaNJmNaTxRXpwkjT2+EPpFPb/Xg=;
        b=QAUqLjZiC1VhUa9aypeHxSyfgXlFYRESM4DWQGGiLBhmvDSbfUfduaLkIQGGuGejln
         V5tY9Fb9TyzWNitoqForMQDOAXCw/KIeAG2mHjRqb6bqy7RIWlPSvVfus6bXAhoR8Bup
         zzm5HkC21SJokmC0esx90CyiUToBFhJ8laSys3uISqxfnJH/gLYBC5r0XaSpNiVE1Kyv
         pJiZU7P3U9bUM/qlJigGFqlS/anSMg1DDqJ0DKn2zpUOr1bDQAJF6QYlu7/L1GNaqkAK
         KJI7tOCX/p4UN4TFG4lPKckcgVHGFrr9E0vvQq3YjUcFRSPINSy47/4ixgnRmaUzmTT0
         qv/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6WkMXhPlqouOzrZ+HaNJmNaTxRXpwkjT2+EPpFPb/Xg=;
        b=SwDV+cgIBepCFPWejm9l4HsH1AuucS0OVJBceUq/l+pivzzkh2QNJfA/jqwmc6ArtP
         vToSs80+ZEIwcr6M15rVeiJH/XCzX93a98/588D5oziU3U3Fg+NhrhZr+Vx6DB8x/Pds
         TNumikcog2JEdBFkiBMC3AOCvD3xtOqlP53ytZ17WmvhZ+Zt5MP6TBPCoW/wzsxUwhDE
         27i3gjxPq4VSkaT8fpmxW/ZNSgT1TYZD5WZ8dARdwcvru2ljC95Fn/NgISulhhTdoS9O
         8eOFdzY8lxyT6ARK1upPSZNpKQ2RLbt+2M/SfS3Ob+iBu/vfh9qhf/GocntxsNKeECC5
         zEdw==
X-Gm-Message-State: AOAM531eiwVORo/KE4on8POSHPcagMfjQFuLTcm/o93JoJG4lrmR6sRv
        KNl+Ube5UZLWRj+74gr8XW8ehdlvMYoyNM3IZ2ULuQ==
X-Google-Smtp-Source: ABdhPJyjUFJhTGHEll5xoh7WrNwp3JvFOy4bDNHoUUklbgMY42+p0wudoZm5eyxDuxzOZ56b3E0GpJ4UU75ozEjq1Ig=
X-Received: by 2002:a25:3106:: with SMTP id x6mr32788760ybx.364.1595866199979;
 Mon, 27 Jul 2020 09:09:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-16-jonathan.lemon@gmail.com> <CANn89iJ5vyx0WqdKTB3uHaWJrG-3jNXqXs6r7PacSqg0jRsRKA@mail.gmail.com>
 <20200727155549.gbwosugbugknsneo@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200727155549.gbwosugbugknsneo@bsd-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jul 2020 09:09:48 -0700
Message-ID: <CANn89iKY27R=ryQLohFPWa9dr6R9dMgB-hj+9eJO6H4NqfVKVw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 15/21] net/tcp: add MSG_NETDMA flag for sendmsg()
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        borisp@mellanox.com, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 8:56 AM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Mon, Jul 27, 2020 at 08:19:43AM -0700, Eric Dumazet wrote:
> > On Mon, Jul 27, 2020 at 12:51 AM Jonathan Lemon
> > <jonathan.lemon@gmail.com> wrote:
> > >
> > > This flag indicates that the attached data is a zero-copy send,
> > > and the pages should be retrieved from the netgpu module.  The
> > > socket should should already have been attached to a netgpu queue.
> > >
> > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > > ---
> > >  include/linux/socket.h | 1 +
> > >  net/ipv4/tcp.c         | 8 ++++++++
> > >  2 files changed, 9 insertions(+)
> > >
> > > diff --git a/include/linux/socket.h b/include/linux/socket.h
> > > index 04d2bc97f497..63816cc25dee 100644
> > > --- a/include/linux/socket.h
> > > +++ b/include/linux/socket.h
> > > @@ -310,6 +310,7 @@ struct ucred {
> > >                                           */
> > >
> > >  #define MSG_ZEROCOPY   0x4000000       /* Use user data in kernel path */
> > > +#define MSG_NETDMA     0x8000000
> > >  #define MSG_FASTOPEN   0x20000000      /* Send data in TCP SYN */
> > >  #define MSG_CMSG_CLOEXEC 0x40000000    /* Set close_on_exec for file
> > >                                            descriptor received through
> > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > index 261c28ccc8f6..340ce319edc9 100644
> > > --- a/net/ipv4/tcp.c
> > > +++ b/net/ipv4/tcp.c
> > > @@ -1214,6 +1214,14 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
> > >                         uarg->zerocopy = 0;
> > >         }
> > >
> > > +       if (flags & MSG_NETDMA && size && sock_flag(sk, SOCK_ZEROCOPY)) {
> > > +               zc = sk->sk_route_caps & NETIF_F_SG;
> > > +               if (!zc) {
> > > +                       err = -EFAULT;
> > > +                       goto out_err;
> > > +               }
> > > +       }
> > >
> >
> > Sorry, no, we can not allow adding yet another branch into TCP fast
> > path for yet another variant of zero copy.
>
> I'm not in disagreement with that statement, but the existing zerocopy
> work makes some assumptions that aren't suitable.  I take it that you'd
> rather have things folded together so the old/new code works together?

Exact.  Forcing users to use MSG_NETDMA, yet reusing SOCK_ZEROCOPY is silly.

SOCK_ZEROCOPY has been added to that user space and kernel would agree
on MSG_ZEROCOPY being not a nop (as it was on old kernels)

>
> Allocating an extra structure for every skbuff isn't ideal in my book.
>

We do not allocate a structure for every skbuff. Please look again.


>
> > Overall, I think your patch series desperately tries to add changes in
> > TCP stack, while there is yet no proof
> > that you have to use TCP transport between the peers.
>
> The goal is having a reliable transport without resorting to RDMA.

And why should it be TCP ?

Are you dealing with lost packets, retransmits, timers, and al  ?
