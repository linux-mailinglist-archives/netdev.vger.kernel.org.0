Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED20756F6C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 19:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfFZROz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 13:14:55 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36944 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFZROy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 13:14:54 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hgBVM-0001Bb-VE; Wed, 26 Jun 2019 13:14:52 -0400
Date:   Wed, 26 Jun 2019 13:14:39 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
Message-ID: <20190626171439.GB31355@hmswarspite.think-freely.org>
References: <20190619202533.4856-1-nhorman@tuxdriver.com>
 <20190625215749.22840-1-nhorman@tuxdriver.com>
 <CAF=yD-+fCNGQyoRNAZngof3=_gGbHn9aSCQA_hNvFSsSZtZQxA@mail.gmail.com>
 <20190626105403.GA31355@hmswarspite.think-freely.org>
 <CAF=yD-+_khMRCK0gE2q7nAi8fAtwvZ2FerHZKo1U1M-=991+Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-+_khMRCK0gE2q7nAi8fAtwvZ2FerHZKo1U1M-=991+Zg@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 11:05:39AM -0400, Willem de Bruijn wrote:
> On Wed, Jun 26, 2019 at 6:54 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Tue, Jun 25, 2019 at 06:30:08PM -0400, Willem de Bruijn wrote:
> > > > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > > > index a29d66da7394..a7ca6a003ebe 100644
> > > > --- a/net/packet/af_packet.c
> > > > +++ b/net/packet/af_packet.c
> > > > @@ -2401,6 +2401,9 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
> > > >
> > > >                 ts = __packet_set_timestamp(po, ph, skb);
> > > >                 __packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
> > > > +
> > > > +               if (!packet_read_pending(&po->tx_ring))
> > > > +                       complete(&po->skb_completion);
> > > >         }
> > > >
> > > >         sock_wfree(skb);
> > > > @@ -2585,7 +2588,7 @@ static int tpacket_parse_header(struct packet_sock *po, void *frame,
> > > >
> > > >  static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > > >  {
> > > > -       struct sk_buff *skb;
> > > > +       struct sk_buff *skb = NULL;
> > > >         struct net_device *dev;
> > > >         struct virtio_net_hdr *vnet_hdr = NULL;
> > > >         struct sockcm_cookie sockc;
> > > > @@ -2600,6 +2603,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > > >         int len_sum = 0;
> > > >         int status = TP_STATUS_AVAILABLE;
> > > >         int hlen, tlen, copylen = 0;
> > > > +       long timeo = 0;
> > > >
> > > >         mutex_lock(&po->pg_vec_lock);
> > > >
> > > > @@ -2646,12 +2650,21 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > > >         if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
> > > >                 size_max = dev->mtu + reserve + VLAN_HLEN;
> > > >
> > > > +       reinit_completion(&po->skb_completion);
> > > > +
> > > >         do {
> > > >                 ph = packet_current_frame(po, &po->tx_ring,
> > > >                                           TP_STATUS_SEND_REQUEST);
> > > >                 if (unlikely(ph == NULL)) {
> > > > -                       if (need_wait && need_resched())
> > > > -                               schedule();
> > > > +                       if (need_wait && skb) {
> > > > +                               timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
> > > > +                               timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
> > >
> > > This looks really nice.
> > >
> > > But isn't it still susceptible to the race where tpacket_destruct_skb
> > > is called in between po->xmit and this
> > > wait_for_completion_interruptible_timeout?
> > >
> > Thats not an issue, since the complete is only gated on packet_read_pending
> > reaching 0 in tpacket_destuct_skb.  Previously it was gated on my
> > wait_on_complete flag being non-zero, so we had to set that prior to calling
> > po->xmit, or the complete call might never get made, resulting in a hang.  Now,
> > we will always call complete, and the completion api allows for arbitrary
> > ordering of complete/wait_for_complete (since its internal done variable gets
> > incremented), making a call to wait_for_complete effectively a fall through if
> > complete gets called first.
> 
> Perfect! I was not aware that it handles that internally. Hadn't read
> do_wait_for_common closely before.
> 
> > There is an odd path here though.  If an application calls sendmsg on a packet
> > socket here with MSG_DONTWAIT set, then need_wait will be zero, and we will
> > eventually exit this loop without ever having called wait_for_complete, but
> > tpacket_destruct_skb will still have called complete when all the frames
> > complete transmission.  In and of itself, thats fine, but it leave the
> > completion structure in a state where its done variable will have been
> > incremented at least once (specifically it will be set to N, where N is the
> > number of frames transmitted during the call where MSG_DONTWAIT is set).  If the
> > application then calls sendmsg on this socket with MSG_DONTWAIT clear, we will
> > call wait_for_complete, but immediately return from it (due to the previously
> > made calls to complete).  I've corrected this however, but adding that call to
> > reinit_completion prior to the loop entry, so that we are always guaranteed to
> > have the completion variable set properly to wait for only the frames being sent
> > in this particular instance of the sendmsg call.
> 
> Yep, understood.
> 
> >
> > > The test for skb is shorthand for packet_read_pending  != 0, right?
> > >
> > Sort of.  gating on skb guarantees for us that we have sent at least one frame
> > in this call to tpacket_snd.  If we didn't do that, then it would be possible
> > for an application to call sendmsg without setting any frames in the buffer to
> > TP_STATUS_SEND_REQUEST, which would cause us to wait for a completion without
> > having sent any frames, meaning we would block waiting for an event
> > (tpacket_destruct_skb), that will never happen.  The check for skb ensures that
> > tpacket_snd_skb will get called, and that we will get a wakeup from a call to
> > wait_for_complete.  It does suggest that packet_read_pending != 0, but thats not
> > guaranteed, because tpacket_destruct_skb may already have been called (see the
> > above explination regarding ordering of complete/wait_for_complete).
> 
> But the inverse is true: if gating sleeping on packet_read_pending,
> the process only ever waits if a packet is still to be acknowledged.
> Then both the wait and wake clearly depend on the same state.
> 
> Either way works, I think. So this is definitely fine.
> 
Yeah, we could do that.  Its basically a pick your poison situation, in the case
you stipulate, we could gate the wait_on_complete on read_pending being
non-zero, but if a frame frees quickly and decrements the pending count, we
still leave the loop with a completion struct that needs to be reset.  Either
way we have to re-init the completion.  And as for calling wait_on_complete when
we don't have to, your proposal does solve that prolbem but requires that we
call packet_read_pending an extra time for iteration on every loop.
Packet_read_pending accumulates the sum of all the per-cpu pointer pending
counts (which is a separate problem, I'm not sure why we're using per-cpu
counters there).  Regardless, I looked at that and (anecdotally), decided that
periodically calling wait_for_complete which takes a spin lock would be more
performant than accessing a per-cpu variable on each available cpu every
iteration of the loop (based on the comments at the bottom of the loop).

> One possible refinement would be to keep po->wait_on_complete (but
> rename as po->wake_om_complete), set it before entering the loop and
> clear it before function return (both within the pg_vec_lock critical
> section). And test that in tpacket_destruct_skb to avoid calling
> complete if MSG_DONTWAIT. But I don't think it's worth the complexity.
> 
I agree, we could use a socket variable to communicate to tpacket_destruct_skb
that we need to call complete, in conjunction with the pending count, but I
don't think the added complexity buys us anything.

> One rare edge case is a MSG_DONTWAIT send followed by a !MSG_DONTWAIT.
> It is then possible for a tpacket_destruct_skb to be run as a result
> from the first call, during the second call, after the call to
> reinit_completion. That would cause the next wait to return before
> *its* packets have been sent. But due to the packet_read_pending test
> in the while () condition it will loop again and return to wait. So that's fine.
> 
yup, exactly.

> Thanks for bearing with me.
> 
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> 
