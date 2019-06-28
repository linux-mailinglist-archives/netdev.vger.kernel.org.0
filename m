Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236F15A580
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfF1Tzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:55:37 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36152 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfF1Tzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:55:36 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hgwxy-0006ph-8t; Fri, 28 Jun 2019 15:55:31 -0400
Date:   Fri, 28 Jun 2019 15:54:58 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH net-next] af_packet: convert pending frame counter to
 atomic_t
Message-ID: <20190628195458.GC14635@hmswarspite.think-freely.org>
References: <20190628145206.13871-1-nhorman@tuxdriver.com>
 <CAF=yD-Joh1ne4Y_pwDv8VOcWnKP-2veeXWw=eUBoZKr5___3TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-Joh1ne4Y_pwDv8VOcWnKP-2veeXWw=eUBoZKr5___3TA@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 11:15:09AM -0400, Willem de Bruijn wrote:
> On Fri, Jun 28, 2019 at 10:53 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > The AF_PACKET protocol, when running as a memory mapped socket uses a
> > pending frame counter to track the number of skbs in flight during
> > transmission.  It is incremented during the sendmsg call (via
> > tpacket_snd), and decremented (possibly asynchronously) in the skb
> > desructor during skb_free.
> >
> > The counter is currently implemented as a percpu variable for each open
> > socket, but for reads (via packet_read_pending), we iterate over every
> > cpu variable, accumulating the total pending count.
> >
> > Given that the socket transmit path is an exclusive path (locked via the
> > pg_vec_lock mutex), we do not have the ability to increment this counter
> > on multiple cpus in parallel.  This implementation also seems to have
> > the potential to be broken, in that, should an skb be freed on a cpu
> > other than the one that it was initially transmitted on, we may
> > decrement a counter that was not initially incremented, leading to
> > underflow.
> >
> > As such, adjust the packet socket struct to convert the per-cpu counter
> > to an atomic_t variable (to enforce consistency between the send path
> > and the skb free path).  This saves us some space in the packet_sock
> > structure, prevents the possibility of underflow, and should reduce the
> > run time of packet_read_pending, as we only need to read a single
> > variable, instead of having to loop over every available cpu variable
> > instance.
> >
> > Tested by myself by running a small program which sends frames via
> > AF_PACKET on multiple cpus in parallel, with good results.
> >
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: "David S. Miller" <davem@davemloft.net>
> > CC: Willem de Bruijn <willemb@google.com>
> > ---
> 
> This essentially is a revert of commit b013840810c2 ("packet: use
> percpu mmap tx frame pending refcount"). That has some benchmark
> numbers and also discusses the overflow issue.
> 
Yes it is.  I was looking at it thinking that the accumulation issue was more
serious now that we actually sleep until we get a completion, rather than just
schedule.  I.e if we're freeing frames in parallel, I was thinking it was
possible for the ordering to result in neither instance getting a return value
from packet_read_pending of 0, which would lead to a hang/maximal timeout, but
as I look back, I think I was wrong about that.

As for the performance, you're right.  They're almost the same, but I did some
perf runs, and for 10000 iterations this patch is about 0.1% slower (measuring
system time).  I kind of wonder if it isn't worth the code and data savings, but
faster is faster.  Though thats on a 6 cpu system.  I suppose some more testing
might be warranted on high cpu count systems (i.e. is there a point at which the
looping over the cpu_possible_mask becomes more expensive), though perhaps that
just so small it doesn't matter.

> I think more interesting would be to eschew the counter when
> MSG_DONTWAIT, as it is only used to know when to exit the loop if
> need_wait.
> 
Yeah, that might be interesting.  Though that would mean needing to have
tpacket_destruct_skb be aware of wether or not the frame being free was sent as
part of a WAIT/DONTWAIT flagged call.


> But, IMHO packet sockets are deprecated in favor of AF_XDP and
> should be limited to bug fixes at this point.
> 
I don't see any documentation listing AF_PACKET as deprecated.

People can use AF_XDP to do raw frame sends if they like,
but AF_PACKET will still be around (ostensibly in perpetuity), to support
existing applications.  I see no need to avoid improving it when we can.

Neil


> >  net/packet/af_packet.c | 40 +++++-----------------------------------
> >  net/packet/internal.h  |  2 +-
> >  2 files changed, 6 insertions(+), 36 deletions(-)
> >
> > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > index 8d54f3047768..25ffb486fac9 100644
> > --- a/net/packet/af_packet.c
> > +++ b/net/packet/af_packet.c
> > @@ -1154,43 +1154,17 @@ static void packet_increment_head(struct packet_ring_buffer *buff)
> >
> >  static void packet_inc_pending(struct packet_ring_buffer *rb)
> >  {
> > -       this_cpu_inc(*rb->pending_refcnt);
> > +       atomic_inc(&rb->pending_refcnt);
> >  }
> 
> If making this change, can also remove these helper functions. The
> layer of indirection just hinders readability.
> 
