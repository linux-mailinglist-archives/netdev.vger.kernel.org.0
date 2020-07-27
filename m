Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D279522F425
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 17:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgG0P4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 11:56:04 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:38440 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgG0P4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 11:56:03 -0400
Received: (qmail 66149 invoked by uid 89); 27 Jul 2020 15:55:55 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 27 Jul 2020 15:55:55 -0000
Date:   Mon, 27 Jul 2020 08:55:49 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
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
Subject: Re: [RFC PATCH v2 15/21] net/tcp: add MSG_NETDMA flag for sendmsg()
Message-ID: <20200727155549.gbwosugbugknsneo@bsd-mbp.dhcp.thefacebook.com>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-16-jonathan.lemon@gmail.com>
 <CANn89iJ5vyx0WqdKTB3uHaWJrG-3jNXqXs6r7PacSqg0jRsRKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJ5vyx0WqdKTB3uHaWJrG-3jNXqXs6r7PacSqg0jRsRKA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 08:19:43AM -0700, Eric Dumazet wrote:
> On Mon, Jul 27, 2020 at 12:51 AM Jonathan Lemon
> <jonathan.lemon@gmail.com> wrote:
> >
> > This flag indicates that the attached data is a zero-copy send,
> > and the pages should be retrieved from the netgpu module.  The
> > socket should should already have been attached to a netgpu queue.
> >
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > ---
> >  include/linux/socket.h | 1 +
> >  net/ipv4/tcp.c         | 8 ++++++++
> >  2 files changed, 9 insertions(+)
> >
> > diff --git a/include/linux/socket.h b/include/linux/socket.h
> > index 04d2bc97f497..63816cc25dee 100644
> > --- a/include/linux/socket.h
> > +++ b/include/linux/socket.h
> > @@ -310,6 +310,7 @@ struct ucred {
> >                                           */
> >
> >  #define MSG_ZEROCOPY   0x4000000       /* Use user data in kernel path */
> > +#define MSG_NETDMA     0x8000000
> >  #define MSG_FASTOPEN   0x20000000      /* Send data in TCP SYN */
> >  #define MSG_CMSG_CLOEXEC 0x40000000    /* Set close_on_exec for file
> >                                            descriptor received through
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 261c28ccc8f6..340ce319edc9 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -1214,6 +1214,14 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
> >                         uarg->zerocopy = 0;
> >         }
> >
> > +       if (flags & MSG_NETDMA && size && sock_flag(sk, SOCK_ZEROCOPY)) {
> > +               zc = sk->sk_route_caps & NETIF_F_SG;
> > +               if (!zc) {
> > +                       err = -EFAULT;
> > +                       goto out_err;
> > +               }
> > +       }
> >
> 
> Sorry, no, we can not allow adding yet another branch into TCP fast
> path for yet another variant of zero copy.

I'm not in disagreement with that statement, but the existing zerocopy
work makes some assumptions that aren't suitable.  I take it that you'd
rather have things folded together so the old/new code works together?

Allocating an extra structure for every skbuff isn't ideal in my book.


> Overall, I think your patch series desperately tries to add changes in
> TCP stack, while there is yet no proof
> that you have to use TCP transport between the peers.

The goal is having a reliable transport without resorting to RDMA.
-- 
Jonathan
