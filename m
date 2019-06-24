Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A89F251D63
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbfFXVwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:52:00 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43210 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfFXVwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:52:00 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hfWsO-0007Sr-Iu; Mon, 24 Jun 2019 17:51:57 -0400
Date:   Mon, 24 Jun 2019 17:51:42 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
Message-ID: <20190624215142.GA8181@hmswarspite.think-freely.org>
References: <20190619202533.4856-1-nhorman@tuxdriver.com>
 <20190624004604.25607-1-nhorman@tuxdriver.com>
 <CAF=yD-JE9DEbmh6hJEN=DEdc+SCz_5Lv74mngPBuv=4nNH=zxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-JE9DEbmh6hJEN=DEdc+SCz_5Lv74mngPBuv=4nNH=zxQ@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 02:08:43PM -0400, Willem de Bruijn wrote:
> On Sun, Jun 23, 2019 at 8:46 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > When an application is run that:
> > a) Sets its scheduler to be SCHED_FIFO
> > and
> > b) Opens a memory mapped AF_PACKET socket, and sends frames with the
> > MSG_DONTWAIT flag cleared, its possible for the application to hang
> > forever in the kernel.  This occurs because when waiting, the code in
> > tpacket_snd calls schedule, which under normal circumstances allows
> > other tasks to run, including ksoftirqd, which in some cases is
> > responsible for freeing the transmitted skb (which in AF_PACKET calls a
> > destructor that flips the status bit of the transmitted frame back to
> > available, allowing the transmitting task to complete).
> >
> > However, when the calling application is SCHED_FIFO, its priority is
> > such that the schedule call immediately places the task back on the cpu,
> > preventing ksoftirqd from freeing the skb, which in turn prevents the
> > transmitting task from detecting that the transmission is complete.
> >
> > We can fix this by converting the schedule call to a completion
> > mechanism.  By using a completion queue, we force the calling task, when
> > it detects there are no more frames to send, to schedule itself off the
> > cpu until such time as the last transmitted skb is freed, allowing
> > forward progress to be made.
> >
> > Tested by myself and the reporter, with good results
> >
> > Appies to the net tree
> >
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > Reported-by: Matteo Croce <mcroce@redhat.com>
> > CC: "David S. Miller" <davem@davemloft.net>
> > CC: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> >
> > Change Notes:
> >
> > V1->V2:
> >         Enhance the sleep logic to support being interruptible and
> > allowing for honoring to SK_SNDTIMEO (Willem de Bruijn)
> >
> > V2->V3:
> >         Rearrage the point at which we wait for the completion queue, to
> > avoid needing to check for ph/skb being null at the end of the loop.
> > Also move the complete call to the skb destructor to avoid needing to
> > modify __packet_set_status.  Also gate calling complete on
> > packet_read_pending returning zero to avoid multiple calls to complete.
> > (Willem de Bruijn)
> >
> >         Move timeo computation within loop, to re-fetch the socket
> > timeout since we also use the timeo variable to record the return code
> > from the wait_for_complete call (Neil Horman)
> > ---
> >  net/packet/af_packet.c | 59 +++++++++++++++++++++++++++++++++++++-----
> >  net/packet/internal.h  |  2 ++
> >  2 files changed, 55 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > index a29d66da7394..5c48bb7a4fa5 100644
> > --- a/net/packet/af_packet.c
> > +++ b/net/packet/af_packet.c
> > @@ -380,7 +380,6 @@ static void __packet_set_status(struct packet_sock *po, void *frame, int status)
> >                 WARN(1, "TPACKET version not supported.\n");
> >                 BUG();
> >         }
> > -
> 
> Unrelated to this feature
> 
Agreed.

> >         smp_wmb();
><snip>

> 
> >                 ph = packet_current_frame(po, &po->tx_ring,
> >                                           TP_STATUS_SEND_REQUEST);
> > -               if (unlikely(ph == NULL)) {
> > -                       if (need_wait && need_resched())
> > -                               schedule();
> > -                       continue;
> 
> Why not keep the test whether the process needs to wait exactly here (A)?
> 
As I said in the changelog, I think it makes the code more readable, to
understand that you are waiting for an event to complete after you send the
frame.

> Then no need for packet_next_frame.
> 
Thats fair.  I still think waiting at the bottom of the loop is more clear, but
it does save a function, so I'll agree to this.

> > -               }
> > +
> > +               if (unlikely(ph == NULL))
> > +                       break;
> >
> >                 skb = NULL;
> >                 tp_len = tpacket_parse_header(po, ph, size_max, &data);
> > +
> 
> Again
> 
> >                 if (tp_len < 0)
> >                         goto tpacket_error;
> >
> > @@ -2720,6 +2732,21 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> >
> >                 skb->destructor = tpacket_destruct_skb;
> >                 __packet_set_status(po, ph, TP_STATUS_SENDING);
> > +
> > +               /*
> > +                * If we need to wait and we've sent the last frame pending
> > +                * transmission in the mmaped buffer, flag that we need to wait
> > +                * on those frames to get freed via tpacket_destruct_skb.  This
> > +                * flag indicates that tpacket_destruct_skb should call complete
> > +                * when the packet_pending count reaches zero, and that we need
> > +                * to call wait_on_complete_interruptible_timeout below, to make
> > +                * sure we pick up the result of that completion
> > +                */
> > +               if (need_wait && !packet_next_frame(po, &po->tx_ring, TP_STATUS_SEND_REQUEST)) {
> > +                       po->wait_on_complete = 1;
> > +                       timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
> 
> This resets timeout on every loop. should only set above the loop once.
> 
I explained exactly why I did that in the change log.  Its because I reuse the
timeout variable to get the return value of the wait_for_complete call.
Otherwise I need to add additional data to the stack, which I don't want to do.
Sock_sndtimeo is an inline function and really doesn't add any overhead to this
path, so I see no reason not to reuse the variable.

> Also, please limit the comments in the code (also below). If every
> patch would add this many lines of comment, the file would be
> enormous. OTOH, it's great to be this explanatory in the git commit,
> which is easily reached for any line with git blame.
> 
> > +               }
> > +
> >                 packet_inc_pending(&po->tx_ring);
> >
> >                 status = TP_STATUS_SEND_REQUEST;
> > @@ -2728,6 +2755,11 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> >                         err = net_xmit_errno(err);
> >                         if (err && __packet_get_status(po, ph) ==
> >                                    TP_STATUS_AVAILABLE) {
> > +                               /* re-init completion queue to avoid subsequent fallthrough
> > +                                * on a future thread calling wait_on_complete_interruptible_timeout
> > +                                */
> > +                               po->wait_on_complete = 0;
> 
> If setting where sleeping, no need for resetting if a failure happens
> between those blocks.
> 
> > +                               init_completion(&po->skb_completion);
> 
> no need to reinit between each use?
> 
I explained exactly why I did this in the comment above.  We have to set
wait_for_complete prior to calling transmit, so as to ensure that we call
wait_for_completion before we exit the loop. However, in this error case, we
exit the loop prior to calling wait_for_complete, so we need to reset the
completion variable and the wait_for_complete flag.  Otherwise we will be in a
case where, on the next entrace to this loop we will have a completion variable
with completion->done > 0, meaning the next wait will be a fall through case,
which we don't want.

> >                                 /* skb was destructed already */
> >                                 skb = NULL;
> >                                 goto out_status;
> > @@ -2740,6 +2772,20 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> >                 }
> >                 packet_increment_head(&po->tx_ring);
> >                 len_sum += tp_len;
> > +
> > +               if (po->wait_on_complete) {
> > +                       timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
> > +                       po->wait_on_complete = 0;
> 
> I was going to argue for clearing in tpacket_destruct_skb. But then we
> would have to separate clear on timeout instead of signal, too.
> 
>   po->wait_on_complete = 1;
>   timeo = wait_for_completion...
>   po->wait_on_complete = 0;
> 
Also, we would have a race condition, since the destructor may be called from
softirq context (the first cause of the bug I'm fixing here), and so if the
packet is freed prior to us checking wait_for_complete in tpacket_snd, we will
be in the above situation again, exiting the loop with a completion variable in
an improper state.

> as the previous version had is fine, as long as the compiler does not
> "optimize" away an assignment. The function call will avoid reordering
> by the cpu, at least. Probably requires WRITE_ONCE/READ_ONCE.
> 
> > +                       if (!timeo) {
> > +                               /* We timed out, break out and notify userspace */
> > +                               err = -ETIMEDOUT;
> > +                               goto out_status;
> 
> goto out_put, there is no active ph or skb here
> 
Yes, good catch.

> > +                       } else if (timeo == -ERESTARTSYS) {
> > +                               err = -ERESTARTSYS;
> > +                               goto out_status;
> > +                       }
> > +               }
> > +
> >         } while (likely((ph != NULL) ||
> >                 /* Note: packet_read_pending() might be slow if we have
> >                  * to call it as it's per_cpu variable, but in fast-path
> > @@ -3207,6 +3253,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
> >         sock_init_data(sock, sk);
> >
> >         po = pkt_sk(sk);
> > +       init_completion(&po->skb_completion);
> >         sk->sk_family = PF_PACKET;
> >         po->num = proto;
> >         po->xmit = dev_queue_xmit;
> 
> This is basically replacing a busy-wait with schedule() with sleeping
> using wait_for_completion_interruptible_timeout. My main question is
> does this really need to move control flow around and add
> packet_next_frame? If not, especially for net, the shortest, simplest
> change is preferable.
> 
Its not replacing a busy wait at all, its replacing a non-blocking schedule with
a blocking schedule (via completion queues).  As for control flow, Im not sure I
why you are bound to the existing control flow, and given that we already have
packet_previous_frame, I didn't see anything egregious about adding
packet_next_frame as well, but since you've seen a way to eliminate it, I'm ok
with it.

Neil
 
