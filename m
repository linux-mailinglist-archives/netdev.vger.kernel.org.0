Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DDA4EEC8
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 20:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfFUSb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 14:31:58 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:47034 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfFUSb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 14:31:58 -0400
Received: by mail-ed1-f65.google.com with SMTP id d4so11302424edr.13
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 11:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y0vsw3aNxn4er0Ip3Ik7DqA5KY7Xeb7igVONoiy3Hzk=;
        b=vZ0JMXRn7Z1gKLvWj/vwnLn7dSWaRwCeVom0sBQ7PXS8BXweci6I1ecbwo1vOHHbl7
         /p2ZtbOXG6gICJfd5+y+axNB0pRwoh4g/OOwfTIQbWclkdo+oRfRtRPbr4XlCs8nmZgf
         h3HXqwETw3eYVDbCKv/xm00qejKrGBtTy5KY+SeBiitVjIkpONgwVYIURmUyUzPqvwm6
         t1aVOYOCy/Ft6sAqg2nDkbghi7fvbf/hGMFbss0i1lxyKOekPfT6l3A1VM3VNcl0OdUY
         aghXFOd+DJq+O7imhnK50cEZTId+EZGTmosmf8m8rEJiByrTvit+VqoUwipJ0CyLepfj
         /1Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y0vsw3aNxn4er0Ip3Ik7DqA5KY7Xeb7igVONoiy3Hzk=;
        b=QEXeCowLPOEczMPMv0JewJqDjKxfkFX8ivqkUD/fP3pIUPCEAkKD3fqqnktf+kCzYU
         jwrPwMwtAC2Vq89rbexulSm75VclOqt8nMEjSQF8SWbDBk4LQmrhGKPpTuHYW2BOFzGJ
         aLTd2QU42Aumi5yWES20AhyvdYFY5GOZIa4++GrETBRYfjnwPmFc3r21mtFafEULfVmh
         4oC6Up4H5U4d0GJFxWn+b/N3Q0x6eA+gosd6XgLcSXlUQg/SnKfUgwotVlyeHmWKynw7
         NSMjODRNSGPJVmPH+o03nd92COOHSoHhI5jfMatlA6LnG1CXODOBknTQ+B36oYwQOYtY
         Cdzw==
X-Gm-Message-State: APjAAAW779udWAiVcpSK7hSSmV4AptpXy4mskS+tN6qFI7IH3xmkHEkL
        tO+izDrRl6qTI1obAAZNFJouyaq834nd4XxobDs=
X-Google-Smtp-Source: APXvYqzERfPiNd0wD4hDi/mrWQrxnRntwrUJfOTzHhMh5vfQd2STzWGMIUh+sAdKXL02IFHJo0ZxfKoWNOo3Kff/On4=
X-Received: by 2002:a17:906:2acf:: with SMTP id m15mr117984967eje.31.1561141915399;
 Fri, 21 Jun 2019 11:31:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190619202533.4856-1-nhorman@tuxdriver.com> <CA+FuTSe=kJSSvcYwCE9-omRF5Snd9AyesZac61PYyAHDStPt=A@mail.gmail.com>
 <20190620142354.GB18890@hmswarspite.think-freely.org> <CAF=yD-KFZBS7PpvvBkHS5jQdjRr4tWpeHmb7=9QPmvD-RTcpYw@mail.gmail.com>
 <20190621164156.GB21895@hmswarspite.think-freely.org>
In-Reply-To: <20190621164156.GB21895@hmswarspite.think-freely.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 21 Jun 2019 14:31:17 -0400
Message-ID: <CAF=yD-+MA398hTu7qCxfRhAMYrpeYp-+znc7bKNbupLYRRv5ug@mail.gmail.com>
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

On Fri, Jun 21, 2019 at 12:42 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Thu, Jun 20, 2019 at 11:16:13AM -0400, Willem de Bruijn wrote:
> > On Thu, Jun 20, 2019 at 10:24 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> > >
> > > On Thu, Jun 20, 2019 at 09:41:30AM -0400, Willem de Bruijn wrote:
> > > > On Wed, Jun 19, 2019 at 4:26 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > > >
> > > > > When an application is run that:
> > > > > a) Sets its scheduler to be SCHED_FIFO
> > > > > and
> > > > > b) Opens a memory mapped AF_PACKET socket, and sends frames with the
> > > > > MSG_DONTWAIT flag cleared, its possible for the application to hang
> > > > > forever in the kernel.  This occurs because when waiting, the code in
> > > > > tpacket_snd calls schedule, which under normal circumstances allows
> > > > > other tasks to run, including ksoftirqd, which in some cases is
> > > > > responsible for freeing the transmitted skb (which in AF_PACKET calls a
> > > > > destructor that flips the status bit of the transmitted frame back to
> > > > > available, allowing the transmitting task to complete).
> > > > >
> > > > > However, when the calling application is SCHED_FIFO, its priority is
> > > > > such that the schedule call immediately places the task back on the cpu,
> > > > > preventing ksoftirqd from freeing the skb, which in turn prevents the
> > > > > transmitting task from detecting that the transmission is complete.
> > > > >
> > > > > We can fix this by converting the schedule call to a completion
> > > > > mechanism.  By using a completion queue, we force the calling task, when
> > > > > it detects there are no more frames to send, to schedule itself off the
> > > > > cpu until such time as the last transmitted skb is freed, allowing
> > > > > forward progress to be made.
> > > > >
> > > > > Tested by myself and the reporter, with good results
> > > > >
> > > > > Appies to the net tree
> > > > >
> > > > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > > > Reported-by: Matteo Croce <mcroce@redhat.com>
> > > > > CC: "David S. Miller" <davem@davemloft.net>
> > > > > ---
> > > >
> > > > This is a complex change for a narrow configuration. Isn't a
> > > > SCHED_FIFO process preempting ksoftirqd a potential problem for other
> > > > networking workloads as well? And the right configuration to always
> > > > increase ksoftirqd priority when increasing another process's
> > > > priority? Also, even when ksoftirqd kicks in, isn't some progress
> > > > still made on the local_bh_enable reached from schedule()?
> > > >
> > >
> > > A few questions here to answer:
> >
> > Thanks for the detailed explanation.
> >
> > > Regarding other protocols having this problem, thats not the case, because non
> > > packet sockets honor the SK_SNDTIMEO option here (i.e. they sleep for a period
> > > of time specified by the SNDTIMEO option if MSG_DONTWAIT isn't set.  We could
> > > certainly do that, but the current implementation doesn't (opting instead to
> > > wait indefinately until the respective packet(s) have transmitted or errored
> > > out), and I wanted to maintain that behavior.  If there is consensus that packet
> > > sockets should honor SNDTIMEO, then I can certainly do that.
> > >
> > > As for progress made by calling local_bh_enable, My read of the code doesn't
> > > have the scheduler calling local_bh_enable at all.  Instead schedule uses
> > > preempt_disable/preempt_enable_no_resched() to gain exlcusive access to the cpu,
> > > which ignores pending softirqs on re-enablement.
> >
> > Ah, I'm mistaken there, then.
> >
> > >  Perhaps that needs to change,
> > > but I'm averse to making scheduler changes for this (the aforementioned concern
> > > about complex changes for a narrow use case)
> > >
> > > Regarding raising the priority of ksoftirqd, that could be a solution, but the
> > > priority would need to be raised to a high priority SCHED_FIFO parameter, and
> > > that gets back to making complex changes for a narrow problem domain
> > >
> > > As for the comlexity of the of the solution, I think this is, given your
> > > comments the least complex and intrusive change to solve the given problem.
> >
> > Could it be simpler to ensure do_softirq() gets run here? That would
> > allow progress for this case.
> >
> > >  We
> > > need to find a way to force the calling task off the cpu while the asynchronous
> > > operations in the transmit path complete, and we can do that this way, or by
> > > honoring SK_SNDTIMEO.  I'm fine with doing the latter, but I didn't want to
> > > alter the current protocol behavior without consensus on that.
> >
> > In general SCHED_FIFO is dangerous with regard to stalling other
> > progress, incl. ksoftirqd. But it does appear that this packet socket
> > case is special inside networking in calling schedule() directly here.
> >
> > If converting that, should it convert to logic more akin to other
> > sockets, like sock_wait_for_wmem? I haven't had a chance to read up on
> > the pros and cons of completion here yet, sorry. Didn't want to delay
> > responding until after I get a chance.
> >
> So, I started looking at implementing SOCK_SNDTIMEO for this patch, and
> something occured to me....We still need a mechanism to block in tpacket_snd.
> That is to say, other protocol use SK_SNDTIMEO to wait for socket memory to
> become available, and that requirement doesn't exist for memory mapped sockets
> in AF_PACKET (which tpacket_snd implements the kernel side for).  We have memory
> mapped frame buffers, which we marshall with an otherwise empty skb, and just
> send that (i.e. no waiting on socket memory, we just product an error if we
> don't have enough ram to allocate an sk_buff).  Given that, we only ever need to
> wait for a frame to complete transmission, or get freed in an error path further
> down the stack.  This probably explains why SK_SNDTIMEO doesn't exist for
> AF_PACKET.

SNDTIMEO behavior would still be useful: to wait for frame slot to
become available, but only up to a timeout?

To be clear, adding that is not a prerequisite for fixing this
specific issue, of course. It would just be nice if the one happens to
be fixed by adding the other.

My main question is wrt the implementation details of struct
completion. Without dynamic memory allocation,
sock_wait_for_wmem/sk_stream_write_space obviously does not make
sense. But should we still use sk_wq and more importantly does this
need the same wait semantics (TASK_INTERRUPTIBLE) and does struct
completion give those?

>
> Given that, is it worth implementing (as it will just further complicate this
> patch, for no additional value), or can we move forward with it as it is?
>
> Neil
>
