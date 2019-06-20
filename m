Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E804D542
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 19:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfFTRcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 13:32:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59060 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFTRcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 13:32:19 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1he0ut-00016k-4L; Thu, 20 Jun 2019 13:32:15 -0400
Date:   Thu, 20 Jun 2019 13:31:54 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
Message-ID: <20190620173154.GF18890@hmswarspite.think-freely.org>
References: <20190619202533.4856-1-nhorman@tuxdriver.com>
 <CA+FuTSe=kJSSvcYwCE9-omRF5Snd9AyesZac61PYyAHDStPt=A@mail.gmail.com>
 <20190620142354.GB18890@hmswarspite.think-freely.org>
 <CAF=yD-KFZBS7PpvvBkHS5jQdjRr4tWpeHmb7=9QPmvD-RTcpYw@mail.gmail.com>
 <20190620161411.GE18890@hmswarspite.think-freely.org>
 <CAF=yD-KtqhHfzRtMVm17f1gfZRuSacB1M-QBSP8dY5Kz_Cn+Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-KtqhHfzRtMVm17f1gfZRuSacB1M-QBSP8dY5Kz_Cn+Yw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 12:18:41PM -0400, Willem de Bruijn wrote:
> On Thu, Jun 20, 2019 at 12:14 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Thu, Jun 20, 2019 at 11:16:13AM -0400, Willem de Bruijn wrote:
> > > On Thu, Jun 20, 2019 at 10:24 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > >
> > > > On Thu, Jun 20, 2019 at 09:41:30AM -0400, Willem de Bruijn wrote:
> > > > > On Wed, Jun 19, 2019 at 4:26 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > > > >
> > > > > > When an application is run that:
> > > > > > a) Sets its scheduler to be SCHED_FIFO
> > > > > > and
> > > > > > b) Opens a memory mapped AF_PACKET socket, and sends frames with the
> > > > > > MSG_DONTWAIT flag cleared, its possible for the application to hang
> > > > > > forever in the kernel.  This occurs because when waiting, the code in
> > > > > > tpacket_snd calls schedule, which under normal circumstances allows
> > > > > > other tasks to run, including ksoftirqd, which in some cases is
> > > > > > responsible for freeing the transmitted skb (which in AF_PACKET calls a
> > > > > > destructor that flips the status bit of the transmitted frame back to
> > > > > > available, allowing the transmitting task to complete).
> > > > > >
> > > > > > However, when the calling application is SCHED_FIFO, its priority is
> > > > > > such that the schedule call immediately places the task back on the cpu,
> > > > > > preventing ksoftirqd from freeing the skb, which in turn prevents the
> > > > > > transmitting task from detecting that the transmission is complete.
> > > > > >
> > > > > > We can fix this by converting the schedule call to a completion
> > > > > > mechanism.  By using a completion queue, we force the calling task, when
> > > > > > it detects there are no more frames to send, to schedule itself off the
> > > > > > cpu until such time as the last transmitted skb is freed, allowing
> > > > > > forward progress to be made.
> > > > > >
> > > > > > Tested by myself and the reporter, with good results
> > > > > >
> > > > > > Appies to the net tree
> > > > > >
> > > > > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > > > > Reported-by: Matteo Croce <mcroce@redhat.com>
> > > > > > CC: "David S. Miller" <davem@davemloft.net>
> > > > > > ---
> > > > >
> > > > > This is a complex change for a narrow configuration. Isn't a
> > > > > SCHED_FIFO process preempting ksoftirqd a potential problem for other
> > > > > networking workloads as well? And the right configuration to always
> > > > > increase ksoftirqd priority when increasing another process's
> > > > > priority? Also, even when ksoftirqd kicks in, isn't some progress
> > > > > still made on the local_bh_enable reached from schedule()?
> > > > >
> > > >
> > > > A few questions here to answer:
> > >
> > > Thanks for the detailed explanation.
> > >
> > Gladly.
> >
> > > > Regarding other protocols having this problem, thats not the case, because non
> > > > packet sockets honor the SK_SNDTIMEO option here (i.e. they sleep for a period
> > > > of time specified by the SNDTIMEO option if MSG_DONTWAIT isn't set.  We could
> > > > certainly do that, but the current implementation doesn't (opting instead to
> > > > wait indefinately until the respective packet(s) have transmitted or errored
> > > > out), and I wanted to maintain that behavior.  If there is consensus that packet
> > > > sockets should honor SNDTIMEO, then I can certainly do that.
> > > >
> > > > As for progress made by calling local_bh_enable, My read of the code doesn't
> > > > have the scheduler calling local_bh_enable at all.  Instead schedule uses
> > > > preempt_disable/preempt_enable_no_resched() to gain exlcusive access to the cpu,
> > > > which ignores pending softirqs on re-enablement.
> > >
> > > Ah, I'm mistaken there, then.
> > >
> > > >  Perhaps that needs to change,
> > > > but I'm averse to making scheduler changes for this (the aforementioned concern
> > > > about complex changes for a narrow use case)
> > > >
> > > > Regarding raising the priority of ksoftirqd, that could be a solution, but the
> > > > priority would need to be raised to a high priority SCHED_FIFO parameter, and
> > > > that gets back to making complex changes for a narrow problem domain
> > > >
> > > > As for the comlexity of the of the solution, I think this is, given your
> > > > comments the least complex and intrusive change to solve the given problem.
> > >
> > > Could it be simpler to ensure do_softirq() gets run here? That would
> > > allow progress for this case.
> > >
> > I'm not sure.  On the surface, we certainly could do it, but inserting a call to
> > do_softirq, either directly, or indirectly through some other mechanism seems
> > like a non-obvious fix, and may lead to confusion down the road.  I'm hesitant
> > to pursue such a soultion without some evidence it would make a better solution.
> >
> > > >  We
> > > > need to find a way to force the calling task off the cpu while the asynchronous
> > > > operations in the transmit path complete, and we can do that this way, or by
> > > > honoring SK_SNDTIMEO.  I'm fine with doing the latter, but I didn't want to
> > > > alter the current protocol behavior without consensus on that.
> > >
> > > In general SCHED_FIFO is dangerous with regard to stalling other
> > > progress, incl. ksoftirqd. But it does appear that this packet socket
> > > case is special inside networking in calling schedule() directly here.
> > >
> > > If converting that, should it convert to logic more akin to other
> > > sockets, like sock_wait_for_wmem? I haven't had a chance to read up on
> > > the pros and cons of completion here yet, sorry. Didn't want to delay
> > > responding until after I get a chance.
> > >
> > That would be the solution described above (i.e. honoring SK_SNDTIMEO.
> > Basically you call sock_send_waittimeo, which returns a timeout value, or 0 if
> > MSG_DONTWAIT is set), then you block for that period of time waiting for
> > transmit completion.
> 
> From an ABI point of view, starting to support SK_SNDTIMEO where it
> currently is not implemented certainly seems fine.
> 
I would agree, I was just thinking since AF_PACKET is something of a unique
protocol (i.e. no real protocol), there may have been reason to ignore that
option, but I agree, it probably makes sense, barring no counter reasoning.

> >  I'm happy to implement that solution, but I'd like to get
> > some clarity as to if there is a reason we don't currently honor that socket
> > option now before I change the behavior that way.
> >
> > Dave, do you have any insight into AF_PACKET history as to why we would ignore
> > the send timeout socket option here?
> 
> On the point of calling schedule(): even if that is rare, there are a lot of
> other cond_resched() calls that may have the same starvation issue
> with SCHED_FIFO and ksoftirqd.
> 
Agreed, but I've not found any yet
Neil

