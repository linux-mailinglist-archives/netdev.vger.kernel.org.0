Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BADB4FDD8
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 21:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfFWTVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 15:21:39 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59139 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfFWTVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 15:21:39 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hf83O-0002Hg-IC; Sun, 23 Jun 2019 15:21:33 -0400
Date:   Sun, 23 Jun 2019 15:21:23 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
Message-ID: <20190623192123.GA32287@hmswarspite.think-freely.org>
References: <20190619202533.4856-1-nhorman@tuxdriver.com>
 <20190622174154.14473-1-nhorman@tuxdriver.com>
 <CAF=yD-JC_r1vjitN1ccyvQ3DXiP9BNCwq9iiWU11cXznmhAY8Q@mail.gmail.com>
 <CAF=yD-+8NDiL0dxM+eOFyiwi1ZhCW29dW--+VeEkssUaJqedWg@mail.gmail.com>
 <20190623114021.GB10908@hmswarspite.think-freely.org>
 <CAF=yD-L5Lu6L4Ji=OZgAkDb28zL=BVsM5HgqWMxMTiJ1YUZJDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-L5Lu6L4Ji=OZgAkDb28zL=BVsM5HgqWMxMTiJ1YUZJDw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 10:39:12AM -0400, Willem de Bruijn wrote:
> On Sun, Jun 23, 2019 at 7:40 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Sat, Jun 22, 2019 at 10:21:31PM -0400, Willem de Bruijn wrote:
> > > > > -static void __packet_set_status(struct packet_sock *po, void *frame, int status)
> > > > > +static void __packet_set_status(struct packet_sock *po, void *frame, int status,
> > > > > +                               bool call_complete)
> > > > >  {
> > > > >         union tpacket_uhdr h;
> > > > >
> > > > > @@ -381,6 +382,8 @@ static void __packet_set_status(struct packet_sock *po, void *frame, int status)
> > > > >                 BUG();
> > > > >         }
> > > > >
> > > > > +       if (po->wait_on_complete && call_complete)
> > > > > +               complete(&po->skb_completion);
> > > >
> > > > This wake need not happen before the barrier. Only one caller of
> > > > __packet_set_status passes call_complete (tpacket_destruct_skb).
> > > > Moving this branch to the caller avoids a lot of code churn.
> > > >
> > > > Also, multiple packets may be released before the process is awoken.
> > > > The process will block until packet_read_pending drops to zero. Can
> > > > defer the wait_on_complete to that one instance.
> > >
> > > Eh no. The point of having this sleep in the send loop is that
> > > additional slots may be released for transmission (flipped to
> > > TP_STATUS_SEND_REQUEST) from another thread while this thread is
> > > waiting.
> > >
> > Thats incorrect.  The entirety of tpacket_snd is protected by a mutex. No other
> > thread can alter the state of the frames in the vector from the kernel send path
> > while this thread is waiting.
> 
> I meant another user thread updating the memory mapped ring contents.
> 
Yes, thats true, and if that happens, we will loop through this path again (the
do..while section, picking up the next frame for transmit)

> > > Else, it would have been much simpler to move the wait below the send
> > > loop: send as many packets as possible, then wait for all of them
> > > having been released. Much clearer control flow.
> > >
> > Thats (almost) what happens now.  The only difference is that with this
> > implementation, the waiting thread has the opportunity to see if userspace has
> > queued more frames for transmission during the wait period.  We could
> > potentially change that, but thats outside the scope of this fix.
> 
> Agreed. I think the current, more complex, behavior was intentional.
> We could still restructure to move it out of the loop and jump back.
> But, yes, definitely out of scope for a fix.
> 
Yes, it was, though based on your comments I've moved the wait_for_completion
call to the bottom of the loop, so its only checked after we are guaranteed to
have sent at least one frame.  I think that makes the code a bit more legible.

> > > Where to set and clear the wait_on_complete boolean remains. Integer
> > > assignment is fragile, as the compiler and processor may optimize or
> > > move simple seemingly independent operations. As complete() takes a
> > > spinlock, avoiding that in the DONTWAIT case is worthwhile. But probably
> > > still preferable to set when beginning waiting and clear when calling
> > > complete.
> > We avoid any call to wait_for_complete or complete already, based on the gating
> > of the need_wait variable in tpacket_snd.  If the transmitting thread doesn't
> > set MSG_DONTWAIT in the flags of the msg structure, we will never set
> > wait_for_complete, and so we will never manipulate the completion queue.
> 
> But we don't know the state of this at tpacket_destruct_skb time without
> wait_for_completion?
> 
Sure we do, wait_for_complete is stored in the packet_sock structure, which is
available and stable at the time tpacket_destruct_skb is called.
po->wait_for_complete is set in tpacket_snd iff:
1) The MSG_DONTWAIT flag is clear
and
2) We have detected that the next frame in the memory mapped buffer does not
have its status set to TP_STATUS_SEND_REQUEST.

If those two conditions are true, we set po->wait_for_complete to 1, which
indicates that tpacket_destruct_skb should call complete, when all the frames
we've sent to the physical layer have been freed (i.e. when packet_read_pending
is zero).

If wait_for_complete is non-zero, we also can be confident that the
calling task is either:
a) Already blocking on wait_for_completion_interruptible_timeout
or
b) Will be waiting on it shortly

In case (a) the blocking/transmitting task will be woken up, and continue on its
way

In case (b) the transmitting task will call
wait_for_completion_interruptible_timeout, see that the completion has already
been called (based on the completion structs done variable being positive), and
return immediately.

I've made a slight update to the logic/comments in my next version to make that a little
more clear

Neil

