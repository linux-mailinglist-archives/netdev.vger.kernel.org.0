Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F0E4EFCD
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 22:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfFUUGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 16:06:50 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42388 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfFUUGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 16:06:49 -0400
Received: by mail-ed1-f68.google.com with SMTP id z25so11683884edq.9
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 13:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uuKV5Gg8+vzTZPWP9sxIqRgQh1zet2wqqLUyd8FPzwM=;
        b=NhymUM4+8QJBCZBuFoIy5zc2oWHFDChSNiyIegM2vGgrDgn+7biAM4LqsJ6gRjfCyO
         XPOYgm2LBtacV2xprNbfaDWlL2DZXgTfzzz29WVrp/FPrp9X0uhiN06iSZpApme0ke7K
         sYSX7hY6EULYvU080fXKwSXrXtRm5aCjWbKxqluqjjxoXpZL/0ADQa+YO4x1ZWaFf/6c
         LHFgO9EBUIc0KCHf5596vM0/iom3FGGowoxp2u4B+uNwL57awK0myZT5cFHWz7Cn9zHw
         0XoyJbQcjdQPKi9dW+umKyGrHaBHGvBqouPT8TzNhJ0A5mKrBIPE3MHri+8FrZY91AIA
         nnyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uuKV5Gg8+vzTZPWP9sxIqRgQh1zet2wqqLUyd8FPzwM=;
        b=X55r566c/YTfcslj0BNuWpkoOZIcHViCv1wZq6PixY16TqwsNmhqH3F9XfKHdyI4KH
         ulWB9cvsHZtKUCLhGO+w1X3ys15hJWqJEPKvMeu6BFTVO89DhAZsA3MQI2KK23P4fAwF
         TIdOM31OQzyHZBuloa/Nh1t1vdlYVPvZSIF8N4ICi/7bdNK1QjonSqEIAu7isg3lZ85q
         2WHZrjT/Y5jPNCWPnaz7LVmzn80zAcSmPb1Hq/O3HSHYtpkwfLnx56b5EHbNWzO4WoeK
         NqcvICVJpZhDkj2urR1ygUN/qAaoKUDZpjoPbTEnfSjB5TY8Ec1reXxORgSkD4qukXFJ
         M3Fg==
X-Gm-Message-State: APjAAAUTOXbIuLI0ZejSHYqs/YofjkGZlu2U8F+XzvCng5i959haW9VA
        +Ql7ldpFhbPI6iU/jhP1bPOga/ix/wgCb8hNzq10zQ==
X-Google-Smtp-Source: APXvYqwPULHbpUVCYowzDF0zm7GUIkFNkt5s2LBih+FptWmt6LxR5y1fsy5I0PCBxQaUznHQw57nVyOcGz6P5IuQiU8=
X-Received: by 2002:a50:a3ec:: with SMTP id t41mr90006654edb.43.1561147606556;
 Fri, 21 Jun 2019 13:06:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190619202533.4856-1-nhorman@tuxdriver.com> <CA+FuTSe=kJSSvcYwCE9-omRF5Snd9AyesZac61PYyAHDStPt=A@mail.gmail.com>
 <20190620142354.GB18890@hmswarspite.think-freely.org> <CAF=yD-KFZBS7PpvvBkHS5jQdjRr4tWpeHmb7=9QPmvD-RTcpYw@mail.gmail.com>
 <20190621164156.GB21895@hmswarspite.think-freely.org> <CAF=yD-+MA398hTu7qCxfRhAMYrpeYp-+znc7bKNbupLYRRv5ug@mail.gmail.com>
 <20190621191823.GD21895@hmswarspite.think-freely.org>
In-Reply-To: <20190621191823.GD21895@hmswarspite.think-freely.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 21 Jun 2019 16:06:09 -0400
Message-ID: <CAF=yD-JdmguAAtS-qBTQ5f0PVspea0f-Es+Lv9wEEkiHP-k-oA@mail.gmail.com>
Subject: Re: [PATCH net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 3:18 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Fri, Jun 21, 2019 at 02:31:17PM -0400, Willem de Bruijn wrote:
> > On Fri, Jun 21, 2019 at 12:42 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > >
> > > On Thu, Jun 20, 2019 at 11:16:13AM -0400, Willem de Bruijn wrote:
> > > > On Thu, Jun 20, 2019 at 10:24 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > > >
> > > > > On Thu, Jun 20, 2019 at 09:41:30AM -0400, Willem de Bruijn wrote:
> > > > > > On Wed, Jun 19, 2019 at 4:26 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > > > > >
> > > > > > > When an application is run that:
> > > > > > > a) Sets its scheduler to be SCHED_FIFO
> > > > > > > and
> > > > > > > b) Opens a memory mapped AF_PACKET socket, and sends frames with the
> > > > > > > MSG_DONTWAIT flag cleared, its possible for the application to hang
> > > > > > > forever in the kernel.  This occurs because when waiting, the code in
> > > > > > > tpacket_snd calls schedule, which under normal circumstances allows
> > > > > > > other tasks to run, including ksoftirqd, which in some cases is
> > > > > > > responsible for freeing the transmitted skb (which in AF_PACKET calls a
> > > > > > > destructor that flips the status bit of the transmitted frame back to
> > > > > > > available, allowing the transmitting task to complete).
> > > > > > >
> > > > > > > However, when the calling application is SCHED_FIFO, its priority is
> > > > > > > such that the schedule call immediately places the task back on the cpu,
> > > > > > > preventing ksoftirqd from freeing the skb, which in turn prevents the
> > > > > > > transmitting task from detecting that the transmission is complete.
> > > > > > >
> > > > > > > We can fix this by converting the schedule call to a completion
> > > > > > > mechanism.  By using a completion queue, we force the calling task, when
> > > > > > > it detects there are no more frames to send, to schedule itself off the
> > > > > > > cpu until such time as the last transmitted skb is freed, allowing
> > > > > > > forward progress to be made.
> > > > > > >
> > > > > > > Tested by myself and the reporter, with good results
> > > > > > >
> > > > > > > Appies to the net tree
> > > > > > >
> > > > > > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > > > > > Reported-by: Matteo Croce <mcroce@redhat.com>
> > > > > > > CC: "David S. Miller" <davem@davemloft.net>
> > > > > > > ---
> > > > > >
> > > > > > This is a complex change for a narrow configuration. Isn't a
> > > > > > SCHED_FIFO process preempting ksoftirqd a potential problem for other
> > > > > > networking workloads as well? And the right configuration to always
> > > > > > increase ksoftirqd priority when increasing another process's
> > > > > > priority? Also, even when ksoftirqd kicks in, isn't some progress
> > > > > > still made on the local_bh_enable reached from schedule()?
> > > > > >
> > > > >
> > > > > A few questions here to answer:
> > > >
> > > > Thanks for the detailed explanation.
> > > >
> > > > > Regarding other protocols having this problem, thats not the case, because non
> > > > > packet sockets honor the SK_SNDTIMEO option here (i.e. they sleep for a period
> > > > > of time specified by the SNDTIMEO option if MSG_DONTWAIT isn't set.  We could
> > > > > certainly do that, but the current implementation doesn't (opting instead to
> > > > > wait indefinately until the respective packet(s) have transmitted or errored
> > > > > out), and I wanted to maintain that behavior.  If there is consensus that packet
> > > > > sockets should honor SNDTIMEO, then I can certainly do that.
> > > > >
> > > > > As for progress made by calling local_bh_enable, My read of the code doesn't
> > > > > have the scheduler calling local_bh_enable at all.  Instead schedule uses
> > > > > preempt_disable/preempt_enable_no_resched() to gain exlcusive access to the cpu,
> > > > > which ignores pending softirqs on re-enablement.
> > > >
> > > > Ah, I'm mistaken there, then.
> > > >
> > > > >  Perhaps that needs to change,
> > > > > but I'm averse to making scheduler changes for this (the aforementioned concern
> > > > > about complex changes for a narrow use case)
> > > > >
> > > > > Regarding raising the priority of ksoftirqd, that could be a solution, but the
> > > > > priority would need to be raised to a high priority SCHED_FIFO parameter, and
> > > > > that gets back to making complex changes for a narrow problem domain
> > > > >
> > > > > As for the comlexity of the of the solution, I think this is, given your
> > > > > comments the least complex and intrusive change to solve the given problem.
> > > >
> > > > Could it be simpler to ensure do_softirq() gets run here? That would
> > > > allow progress for this case.
> > > >
> > > > >  We
> > > > > need to find a way to force the calling task off the cpu while the asynchronous
> > > > > operations in the transmit path complete, and we can do that this way, or by
> > > > > honoring SK_SNDTIMEO.  I'm fine with doing the latter, but I didn't want to
> > > > > alter the current protocol behavior without consensus on that.
> > > >
> > > > In general SCHED_FIFO is dangerous with regard to stalling other
> > > > progress, incl. ksoftirqd. But it does appear that this packet socket
> > > > case is special inside networking in calling schedule() directly here.
> > > >
> > > > If converting that, should it convert to logic more akin to other
> > > > sockets, like sock_wait_for_wmem? I haven't had a chance to read up on
> > > > the pros and cons of completion here yet, sorry. Didn't want to delay
> > > > responding until after I get a chance.
> > > >
> > > So, I started looking at implementing SOCK_SNDTIMEO for this patch, and
> > > something occured to me....We still need a mechanism to block in tpacket_snd.
> > > That is to say, other protocol use SK_SNDTIMEO to wait for socket memory to
> > > become available, and that requirement doesn't exist for memory mapped sockets
> > > in AF_PACKET (which tpacket_snd implements the kernel side for).  We have memory
> > > mapped frame buffers, which we marshall with an otherwise empty skb, and just
> > > send that (i.e. no waiting on socket memory, we just product an error if we
> > > don't have enough ram to allocate an sk_buff).  Given that, we only ever need to
> > > wait for a frame to complete transmission, or get freed in an error path further
> > > down the stack.  This probably explains why SK_SNDTIMEO doesn't exist for
> > > AF_PACKET.
> >
> > SNDTIMEO behavior would still be useful: to wait for frame slot to
> > become available, but only up to a timeout?
> >
> Ok, thats fair.  To be clear, memory_mapped packets aren't waiting here for a
> frame to become available for sending (thats done in userspace, where the
> application checks a specific memory location for the TP_AVAILABLE status to be
> set, so a new frame can be written).  tpacket_snd is wating for the transmission
> of a specific frame to complete the transmit action, which is a different thing.

Right. Until this report I was actually not even aware of this
behavior without MSG_DONTWAIT.

Though the wait is not for a specific frame, right? Wait as long as
the pending_refcnt, which is incremented on every loop.

> Still, I suppose theres no reason we couldn't contrain that wait on a timeout
> set by SK_SNDTIMEO
>
> > To be clear, adding that is not a prerequisite for fixing this
> > specific issue, of course. It would just be nice if the one happens to
> > be fixed by adding the other.
> >
> > My main question is wrt the implementation details of struct
> > completion. Without dynamic memory allocation,
> > sock_wait_for_wmem/sk_stream_write_space obviously does not make
> > sense. But should we still use sk_wq and more importantly does this
> > need the same wait semantics (TASK_INTERRUPTIBLE) and does struct
> > completion give those?
> >
> I suppose we could overload its use here, but I would be worried that such an
> overload would be confusing.  Nominally, sk_wq is used, as you note, to block
> sockets whose allocated send space is full, until such time as enough frames
> have been sent to make space for the next write.  In this scenario, we already
> know we have space to send a frame (by virtue of the fact that we are executing
> in tpakcet_snd, which is only called after userspace has written a frame to the
> memory mapped buffer already allocated for frame transmission).  In this case we
> are simply waiting for the last frame that we have sent to complete
> transmission, at which point we can look to see if more frames are available to
> send, or return from the system call.  I'm happy to take an alternate consensus
> into account, but for the sake of clarity I think I would rather use the
> completion queue, as it makes clear the correlation between the waiter and the
> event we are waiting on.

That will be less likely to have unexpected side-effects. Agreed.
Thanks for the explanation.

Only last question, does it have the right wait behavior? Should this
be wait_for_completion_interruptible?
