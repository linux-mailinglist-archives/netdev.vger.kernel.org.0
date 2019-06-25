Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3506754D1C
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbfFYLDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:03:04 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49308 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfFYLDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 07:03:04 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hfjDx-0007HH-HQ; Tue, 25 Jun 2019 07:03:00 -0400
Date:   Tue, 25 Jun 2019 07:02:48 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
Message-ID: <20190625110247.GA29902@hmswarspite.think-freely.org>
References: <20190619202533.4856-1-nhorman@tuxdriver.com>
 <20190624004604.25607-1-nhorman@tuxdriver.com>
 <CAF=yD-JE9DEbmh6hJEN=DEdc+SCz_5Lv74mngPBuv=4nNH=zxQ@mail.gmail.com>
 <20190624215142.GA8181@hmswarspite.think-freely.org>
 <CAF=yD-L2dgypSCTDwdEXa7EUYyWTcD_hLwW_kuUkk0tA_iggDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-L2dgypSCTDwdEXa7EUYyWTcD_hLwW_kuUkk0tA_iggDw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 06:15:29PM -0400, Willem de Bruijn wrote:
> > > > +               if (need_wait && !packet_next_frame(po, &po->tx_ring, TP_STATUS_SEND_REQUEST)) {
> > > > +                       po->wait_on_complete = 1;
> > > > +                       timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
> > >
> > > This resets timeout on every loop. should only set above the loop once.
> > >
> > I explained exactly why I did that in the change log.  Its because I reuse the
> > timeout variable to get the return value of the wait_for_complete call.
> > Otherwise I need to add additional data to the stack, which I don't want to do.
> > Sock_sndtimeo is an inline function and really doesn't add any overhead to this
> > path, so I see no reason not to reuse the variable.
> 
> The issue isn't the reuse. It is that timeo is reset to sk_sndtimeo
> each time. Whereas wait_for_common and its variants return the
> number of jiffies left in case the loop needs to sleep again later.
> 
> Reading sock_sndtimeo once and passing it to wait_.. repeatedly is a
> common pattern across the stack.
> 
But those patterns are unique to those situations.  For instance, in
tcp_sendmsg_locked, we aquire the value of the socket timeout, and use that to
wait for the entire message send operation to complete, which consists of
potentially several blocking operations (waiting for the tcp connection to be
established, waiting for socket memory, etc).  In that situation we want to wait
for all of those operations to complete to send a single message, and fail if
they exceed the timeout in aggregate.  The semantics are different with
AF_PACKET.  In this use case, the message is in effect empty, and just used to
pass some control information.  tpacket_snd, sends as many frames from the
memory mapped buffer as possible, and on each iteration we want to wait for the
specified timeout for those frames to complete sending.  I think resetting the
timeout on each wait instance is the right way to go here.

> > > > @@ -2728,6 +2755,11 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > > >                         err = net_xmit_errno(err);
> > > >                         if (err && __packet_get_status(po, ph) ==
> > > >                                    TP_STATUS_AVAILABLE) {
> > > > +                               /* re-init completion queue to avoid subsequent fallthrough
> > > > +                                * on a future thread calling wait_on_complete_interruptible_timeout
> > > > +                                */
> > > > +                               po->wait_on_complete = 0;
> > >
> > > If setting where sleeping, no need for resetting if a failure happens
> > > between those blocks.
> > >
> > > > +                               init_completion(&po->skb_completion);
> > >
> > > no need to reinit between each use?
> > >
> > I explained exactly why I did this in the comment above.  We have to set
> > wait_for_complete prior to calling transmit, so as to ensure that we call
> > wait_for_completion before we exit the loop. However, in this error case, we
> > exit the loop prior to calling wait_for_complete, so we need to reset the
> > completion variable and the wait_for_complete flag.  Otherwise we will be in a
> > case where, on the next entrace to this loop we will have a completion variable
> > with completion->done > 0, meaning the next wait will be a fall through case,
> > which we don't want.
> 
> By moving back to the point where schedule() is called, hopefully this
> complexity automatically goes away. Same as my comment to the line
> immediately above.
> 
Its going to change what the complexity is, actually.  I was looking at this
last night, and I realized that your assertion that we could remove
packet_next_frame came at a cost.  This is because we need to determine if we
have to wait before we call po->xmit, but we need to actually do the wait after
po->xmit (to ensure that wait_on_complete is set properly when the desructor is
called).  By moving the wait to the top of the loop and getting rid of
packet_next_frame we now have a race condition in which we might call
tpacket_destruct_skb with wait_on_complete set to false, causing us to wait for
the maximum timeout erroneously.  So I'm going to have to find a new way to
signal the need to call complete, which I think will introduce a different level
of complexity.

> > > > @@ -2740,6 +2772,20 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > > >                 }
> > > >                 packet_increment_head(&po->tx_ring);
> > > >                 len_sum += tp_len;
> > > > +
> > > > +               if (po->wait_on_complete) {
> > > > +                       timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
> > > > +                       po->wait_on_complete = 0;
> > >
> > > I was going to argue for clearing in tpacket_destruct_skb. But then we
> > > would have to separate clear on timeout instead of signal, too.
> > >
> > >   po->wait_on_complete = 1;
> > >   timeo = wait_for_completion...
> > >   po->wait_on_complete = 0;
> > >
> > Also, we would have a race condition, since the destructor may be called from
> > softirq context (the first cause of the bug I'm fixing here), and so if the
> > packet is freed prior to us checking wait_for_complete in tpacket_snd, we will
> > be in the above situation again, exiting the loop with a completion variable in
> > an improper state.
> 
> Good point.
> 
> The common pattern is to clear in tpacket_destruct_skb. Then
> we do need to handle the case where the wait is interrupted or
> times out and reset it in those cases.
> 
As noted above, if we restore the original control flow, the wait_on_complete
flag is not useable, as its state needs to be determined prior to actually
sending the frame to the driver via po->xmit.

I'm going to try some logic in which both tpacket_snd and tpacket_destruct_skb
key off of packet_read_pending.  I think this will require a re-initalization of
the completion queue on each entry to tpacket_snd, but perhaps thats more
pallatable.

> > > This is basically replacing a busy-wait with schedule() with sleeping
> > > using wait_for_completion_interruptible_timeout. My main question is
> > > does this really need to move control flow around and add
> > > packet_next_frame? If not, especially for net, the shortest, simplest
> > > change is preferable.
> > >
> > Its not replacing a busy wait at all, its replacing a non-blocking schedule with
> > a blocking schedule (via completion queues).  As for control flow, Im not sure I
> > why you are bound to the existing control flow, and given that we already have
> > packet_previous_frame, I didn't see anything egregious about adding
> > packet_next_frame as well, but since you've seen a way to eliminate it, I'm ok
> > with it.
> 
> The benefit of keeping to the existing control flow is that that is a
> smaller change, so easier to verify.
> 
I don't think it will really, because its going to introduce different
complexities, but we'll see for certain when I finish getting it rewritten
again.

> I understand the benefit of moving the wait outside the loop. Before
> this report, I was not even aware of that behavior on !MSG_DONTWAIT,
> because it is so co-located.
> 
> But moving it elsewhere in the loop does not have the same benefit,
> imho. Either way, I think we better leave any such code improvements
> to net-next and focus on the minimal , least risky, patch for net.
> 
Ok.
