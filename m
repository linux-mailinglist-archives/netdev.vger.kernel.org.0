Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE0B55455
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 18:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfFYQUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 12:20:44 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52707 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfFYQUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 12:20:44 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hfoBN-0002OH-Qj; Tue, 25 Jun 2019 12:20:42 -0400
Date:   Tue, 25 Jun 2019 12:20:28 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
Message-ID: <20190625162028.GC29902@hmswarspite.think-freely.org>
References: <20190619202533.4856-1-nhorman@tuxdriver.com>
 <20190624004604.25607-1-nhorman@tuxdriver.com>
 <CAF=yD-JE9DEbmh6hJEN=DEdc+SCz_5Lv74mngPBuv=4nNH=zxQ@mail.gmail.com>
 <20190624215142.GA8181@hmswarspite.think-freely.org>
 <CAF=yD-L2dgypSCTDwdEXa7EUYyWTcD_hLwW_kuUkk0tA_iggDw@mail.gmail.com>
 <20190625110247.GA29902@hmswarspite.think-freely.org>
 <CAF=yD-KEZBds_SRDFnOjqvidW30E=NG-2X=hBdcGx_--PAmjew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-KEZBds_SRDFnOjqvidW30E=NG-2X=hBdcGx_--PAmjew@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 09:37:17AM -0400, Willem de Bruijn wrote:
> On Tue, Jun 25, 2019 at 7:03 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Mon, Jun 24, 2019 at 06:15:29PM -0400, Willem de Bruijn wrote:
> > > > > > +               if (need_wait && !packet_next_frame(po, &po->tx_ring, TP_STATUS_SEND_REQUEST)) {
> > > > > > +                       po->wait_on_complete = 1;
> > > > > > +                       timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
> > > > >
> > > > > This resets timeout on every loop. should only set above the loop once.
> > > > >
> > > > I explained exactly why I did that in the change log.  Its because I reuse the
> > > > timeout variable to get the return value of the wait_for_complete call.
> > > > Otherwise I need to add additional data to the stack, which I don't want to do.
> > > > Sock_sndtimeo is an inline function and really doesn't add any overhead to this
> > > > path, so I see no reason not to reuse the variable.
> > >
> > > The issue isn't the reuse. It is that timeo is reset to sk_sndtimeo
> > > each time. Whereas wait_for_common and its variants return the
> > > number of jiffies left in case the loop needs to sleep again later.
> > >
> > > Reading sock_sndtimeo once and passing it to wait_.. repeatedly is a
> > > common pattern across the stack.
> > >
> > But those patterns are unique to those situations.  For instance, in
> > tcp_sendmsg_locked, we aquire the value of the socket timeout, and use that to
> > wait for the entire message send operation to complete, which consists of
> > potentially several blocking operations (waiting for the tcp connection to be
> > established, waiting for socket memory, etc).  In that situation we want to wait
> > for all of those operations to complete to send a single message, and fail if
> > they exceed the timeout in aggregate.  The semantics are different with
> > AF_PACKET.  In this use case, the message is in effect empty, and just used to
> > pass some control information.  tpacket_snd, sends as many frames from the
> > memory mapped buffer as possible, and on each iteration we want to wait for the
> > specified timeout for those frames to complete sending.  I think resetting the
> > timeout on each wait instance is the right way to go here.
> 
> I disagree. If a SO_SNDTIMEO of a given time is set, the thread should
> not wait beyond that. Else what is the point of passing a specific
> duration in the syscall?
> 
I can appreciate that, but you said yourself that you wanted to minimize this
change.  The current behavior of AF_PACKET is to:
a) check for their being no more packets ready to send
b) if (a) is false we schedule() (nominally allowing other tasks to run)
c) when (b) is complete, check for additional frames to send, and exit if there
are not, otherwise, continue sending and waiting

In that model, a single task calling sendmsg can run in the kernel indefinately,
if userspace continues to fill the memory mapped buffer

Given that model, resetting the timeout on each call to wait_for_completion
keeps that behavior.  In fact, if we allow the timeout value to get continuously
decremented, it will be possible for a call to sendmsg in this protocol to
_always_ return -ETIMEDOUT (if we keep the buffer full in userspace long enough,
then the sending task will eventually decrement timeo to zero, and force an
-ETIMEDOUT call).

I'm convinced that resetting the timeout here is the right way to go.

> Btw, we can always drop the timeo and go back to unconditional (bar
> signals) waiting.
> 
We could, but it would be nice to implement the timeout feature here if
possible.

> >
> > > > > > @@ -2728,6 +2755,11 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > > > > >                         err = net_xmit_errno(err);
> > > > > >                         if (err && __packet_get_status(po, ph) ==
> > > > > >                                    TP_STATUS_AVAILABLE) {
> > > > > > +                               /* re-init completion queue to avoid subsequent fallthrough
> > > > > > +                                * on a future thread calling wait_on_complete_interruptible_timeout
> > > > > > +                                */
> > > > > > +                               po->wait_on_complete = 0;
> > > > >
> > > > > If setting where sleeping, no need for resetting if a failure happens
> > > > > between those blocks.
> > > > >
> > > > > > +                               init_completion(&po->skb_completion);
> > > > >
> > > > > no need to reinit between each use?
> > > > >
> > > > I explained exactly why I did this in the comment above.  We have to set
> > > > wait_for_complete prior to calling transmit, so as to ensure that we call
> > > > wait_for_completion before we exit the loop. However, in this error case, we
> > > > exit the loop prior to calling wait_for_complete, so we need to reset the
> > > > completion variable and the wait_for_complete flag.  Otherwise we will be in a
> > > > case where, on the next entrace to this loop we will have a completion variable
> > > > with completion->done > 0, meaning the next wait will be a fall through case,
> > > > which we don't want.
> > >
> > > By moving back to the point where schedule() is called, hopefully this
> > > complexity automatically goes away. Same as my comment to the line
> > > immediately above.
> > >
> > Its going to change what the complexity is, actually.  I was looking at this
> > last night, and I realized that your assertion that we could remove
> > packet_next_frame came at a cost.  This is because we need to determine if we
> > have to wait before we call po->xmit, but we need to actually do the wait after
> > po->xmit
> 
> Why? The existing method using schedule() doesn't.
> 
Because the existing method using schedule doesn't have to rely on an
asynchronous event to wake the sending task back up.  Specifically, we need to
set some state that indicates tpacket_destruct_skb should call complete, and
since tpacket_destruct_skb is called asynchronously in a separate execution
context, we need to ensure there is no race condition whereby we execute
tpacket_destruct_skb before we set the state that we also use to determine if we
should call wait_for_complete.  ie:
1) tpacket_send_skb calls po->xmit
2) tpacket_send_skb loops around and checks to see if there are more packets to
send.  If not and if need_wait is set we call wait_for_complete

If tpacket_destruct_skb is called after (2), we're fine.  But if its called
between (1) and (2), then tpacket_destruct_skb won't call complete (because
wait_on_complete isn't set yet), causing a hang.

Because you wanted to remove packet_next_frame, we have no way to determine if
we're done sending frames prior to calling po->xmit, which is the point past
which tpacket_destruct_skb might be called, so now I have to find an alternate
state condition to key off of.
 

> Can we not just loop while sending and sleep immediately when
> __packet_get_status returns !TP_STATUS_AVAILABLE?
> 
> I don't understand the need to probe the next packet to send instead
> of the current.
> 
See above, we can definately check the return of ph at the top of the loop, and
sleep if its NULL, but in so doing we cant use po->wait_on_complete as a gating
variable because we've already called po->xmit.  Once we call that function, if
we haven't already set po->wait_on_complete to true, its possible
tpacket_destruct_skb will already have been called before we get to the point
where we check wait_for_completion.  That means we will wait on a completion
variable that never gets completed, so I need to find a new way to track weather
or not we are waiting.  Its entirely doable, I'm sure, its just not as straight
forward as your making it out to be.

> This seems to be the crux of the disagreement. My guess is that it has
> to do with setting wait_on_complete, but I don't see the problem. It
> can be set immediately before going to sleep.
> 
The reason has to do with the fact that
tpacket_destruct_skb can be called from ksoftirq context (i.e. it will be called
asynchrnously, not from the thread running in tpacket_snd).  Condsider this
flow, assuming we do as you suggest, and just set po->wait_on_complete=1
immediately prior to calling wait_for_complete_interruptible_timeout: 

1) tpacket_snd gets a frame, builds the skb for transmission
2) tpakcket_snd calls po->xmit(skb), sending the frame to the driver
3) tpacket_snd, iterates through back to the top of the loop, and determines
that we need to wait for the previous packet to complete
4) The driver gets a tx completion interrupt, interrupting the cpu on which we
are executing, and calls kfree_skb_irq on the skb we just transmitted
5) the ksoftirq runs on the cpu, calling kfree_skb on our skb
6) (5) calls skb->destruct (which is tpakcet_skb_destruct)
7) tpacket_skb_destruct executes, sees that po->wait_on_completion is zero, and
skips calling complete()
8) the thread running tpacket_snd gets scheduled back on the cpu and now sets
po->wait_on_complete, then calls wait_for_completion_interruptible_timeout, but
since the skb we are waiting to complete has already been freed, we will never
get the completion notification, and so we will wait for the maximal timeout,
which is absolutely not what we want.

Interestingly (Ironically), that control flow will never happen in the use case
I'm trying to fix here, because its SCHED_FIFO, and will run until such time as
we call wait_for_completion_interuptible_timeout, so in this case we're safe.
But in the nominal case, where the sending task is acturally SCHED_OTHER, the
above can aboslutely happen, and thats very broken.

> I don't meant to draw this out, btw, or add to your workload. If you
> prefer, I can take a stab at my (admittedly hand-wavy) suggestion.
> 
No, I have another method in flight that I'm testing now, it removes the
po->wait_on_complete variable entirely, checking instead to make sure that
we've:
a) sent at least one frame
and
b) that we have a positive pending count
and
c) that we need to wait
and
d) that we have no more frames to send

This is why I was saying that your idea can be done, but it trades one form of
complexity for another.

Neil

> > (to ensure that wait_on_complete is set properly when the desructor is
> > called).  By moving the wait to the top of the loop and getting rid of
> > packet_next_frame we now have a race condition in which we might call
> > tpacket_destruct_skb with wait_on_complete set to false, causing us to wait for
> > the maximum timeout erroneously.  So I'm going to have to find a new way to
> > signal the need to call complete, which I think will introduce a different level
> > of complexity.
> 
