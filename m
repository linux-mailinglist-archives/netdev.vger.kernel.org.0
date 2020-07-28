Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A928C22FFEC
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 05:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgG1DIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 23:08:38 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:47871 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgG1DIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 23:08:38 -0400
Received: (qmail 53227 invoked by uid 89); 28 Jul 2020 03:08:36 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 28 Jul 2020 03:08:36 -0000
Date:   Mon, 27 Jul 2020 20:08:31 -0700
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
Message-ID: <20200728030831.vxo6e2ioqkomctuw@bsd-mbp.dhcp.thefacebook.com>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-16-jonathan.lemon@gmail.com>
 <CANn89iJ5vyx0WqdKTB3uHaWJrG-3jNXqXs6r7PacSqg0jRsRKA@mail.gmail.com>
 <20200727155549.gbwosugbugknsneo@bsd-mbp.dhcp.thefacebook.com>
 <CANn89iKY27R=ryQLohFPWa9dr6R9dMgB-hj+9eJO6H4NqfVKVw@mail.gmail.com>
 <20200727173528.tfsrweswpyjxlqv6@bsd-mbp.dhcp.thefacebook.com>
 <CANn89iKStB8=Exyopi1sufuYhA-rZvYVMOEm9LDgKTLBYiqSmA@mail.gmail.com>
 <20200728021130.bjrlcj7tzebfxsz3@bsd-mbp.dhcp.thefacebook.com>
 <CANn89iL=p3pgDpPeWz5rZqGeCdHg=X=hkEPe=mk9TDa=bk7ZRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iL=p3pgDpPeWz5rZqGeCdHg=X=hkEPe=mk9TDa=bk7ZRQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 07:17:51PM -0700, Eric Dumazet wrote:
> On Mon, Jul 27, 2020 at 7:11 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > On Mon, Jul 27, 2020 at 10:44:59AM -0700, Eric Dumazet wrote:
> > > On Mon, Jul 27, 2020 at 10:35 AM Jonathan Lemon
> > > <jonathan.lemon@gmail.com> wrote:
> > > >
> > > > On Mon, Jul 27, 2020 at 09:09:48AM -0700, Eric Dumazet wrote:
> > > > > On Mon, Jul 27, 2020 at 8:56 AM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Jul 27, 2020 at 08:19:43AM -0700, Eric Dumazet wrote:
> > > > > > > On Mon, Jul 27, 2020 at 12:51 AM Jonathan Lemon
> > > > > > > <jonathan.lemon@gmail.com> wrote:
> > > > > > > >
> > > > > > > > This flag indicates that the attached data is a zero-copy send,
> > > > > > > > and the pages should be retrieved from the netgpu module.  The
> > > > > > > > socket should should already have been attached to a netgpu queue.
> > > > > > > >
> > > > > > > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > > > > > > > ---
> > > > > > > >  include/linux/socket.h | 1 +
> > > > > > > >  net/ipv4/tcp.c         | 8 ++++++++
> > > > > > > >  2 files changed, 9 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/include/linux/socket.h b/include/linux/socket.h
> > > > > > > > index 04d2bc97f497..63816cc25dee 100644
> > > > > > > > --- a/include/linux/socket.h
> > > > > > > > +++ b/include/linux/socket.h
> > > > > > > > @@ -310,6 +310,7 @@ struct ucred {
> > > > > > > >                                           */
> > > > > > > >
> > > > > > > >  #define MSG_ZEROCOPY   0x4000000       /* Use user data in kernel path */
> > > > > > > > +#define MSG_NETDMA     0x8000000
> > > > > > > >  #define MSG_FASTOPEN   0x20000000      /* Send data in TCP SYN */
> > > > > > > >  #define MSG_CMSG_CLOEXEC 0x40000000    /* Set close_on_exec for file
> > > > > > > >                                            descriptor received through
> > > > > > > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > > > > > > index 261c28ccc8f6..340ce319edc9 100644
> > > > > > > > --- a/net/ipv4/tcp.c
> > > > > > > > +++ b/net/ipv4/tcp.c
> > > > > > > > @@ -1214,6 +1214,14 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
> > > > > > > >                         uarg->zerocopy = 0;
> > > > > > > >         }
> > > > > > > >
> > > > > > > > +       if (flags & MSG_NETDMA && size && sock_flag(sk, SOCK_ZEROCOPY)) {
> > > > > > > > +               zc = sk->sk_route_caps & NETIF_F_SG;
> > > > > > > > +               if (!zc) {
> > > > > > > > +                       err = -EFAULT;
> > > > > > > > +                       goto out_err;
> > > > > > > > +               }
> > > > > > > > +       }
> > > > > > > >
> > > > > > >
> > > > > > > Sorry, no, we can not allow adding yet another branch into TCP fast
> > > > > > > path for yet another variant of zero copy.
> > > > > >
> > > > > > I'm not in disagreement with that statement, but the existing zerocopy
> > > > > > work makes some assumptions that aren't suitable.  I take it that you'd
> > > > > > rather have things folded together so the old/new code works together?
> > > > >
> > > > > Exact.  Forcing users to use MSG_NETDMA, yet reusing SOCK_ZEROCOPY is silly.
> > > > >
> > > > > SOCK_ZEROCOPY has been added to that user space and kernel would agree
> > > > > on MSG_ZEROCOPY being not a nop (as it was on old kernels)
> > > > >
> > > > > >
> > > > > > Allocating an extra structure for every skbuff isn't ideal in my book.
> > > > > >
> > > > >
> > > > > We do not allocate a structure for every skbuff. Please look again.
> > > >
> > > > I'm looking here:
> > > >
> > > >     uarg = sock_zerocopy_realloc(sk, size, skb_zcopy(skb));
> > > >
> > > > Doesn't sock_zerocopy_realloc() allocate a new structure if the skb
> > > > doesn't have one already?
> > > >
> > > >
> > > > > > > Overall, I think your patch series desperately tries to add changes in
> > > > > > > TCP stack, while there is yet no proof
> > > > > > > that you have to use TCP transport between the peers.
> > > > > >
> > > > > > The goal is having a reliable transport without resorting to RDMA.
> > > > >
> > > > > And why should it be TCP ?
> > > > >
> > > > > Are you dealing with lost packets, retransmits, timers, and al  ?
> > > >
> > > > Yes?  If there was a true lossless medium, RDMA would have taken over by
> > > > now.  Or are you suggesting that the transport protocol reliability
> > > > should be performed in userspace?  (not all the world is QUIC yet)
> > > >
> > >
> > > The thing is : this patch series is a monster thing adding stuff that
> > > is going to impact 100% % of TCP flows,
> > > even if not used in this NETDMA context.
> > >
> > > So you need to convince us you are really desperate to get this in
> > > upstream linux.
> > >
> > > I have implemented TCP RX zero copy without adding a single line in
> > > standard TCP code.
> >
> > That's a bit of an exaggeration, as I see skb_zcopy_*() calls scattered
> > around the normal TCP code path.  I also haven't changed the normal TCP
> > path either, other than doing some of the same things as skb_zcopy_*().
> > (ignoring the ugly moron about padding out the TCP header, which I'll
> > put under a static_branch_unlikely).
> 
> You are mixing TX zerocopy and RX zero copy.  Quite different things.
> 
> My claim was about TCP RX zero copy (aka tcp_zerocopy_receive())

I understand that (as I'm implementing both sides).  My equivalent of 
tcp_zerocopy_receive is netgpu_recv_skb().

In my variant, I don't actually have a real page, it's just a
placeholder for GPU memory.  So the device driver must obtain the
destination page [dma address] from the netgpu module, and either
deliver it to the user, or return it back to netgpu.

The zc_netdma special bit is there to handle the case where the skb is
freed back to the system - suppose the socket is closed with buffers
sitting on the RX queue.  The existing zero-copy code does not need this
because the RX buffers came from system memory in the first place.


> > The thing is, the existing zero copy code is zero-copy to /host/ memory,
> > which is not the same thing as zero-copy to other memory areas.
> 
> You have to really explain what difference it makes, and why current
> stuff can not be extended.

For RX, the ability to return the 'pages' back to the originator.  For
TX, making sure the pages are not touched by the host, as this would be
an immediate kernel panic.  For example, skb_copy_ubufs() is verboten.

The netgpu and the existing zerocopy code can likely be merged with some
additional work, but they still have different requirements, and
different user APIs.
-- 
Jonathan
