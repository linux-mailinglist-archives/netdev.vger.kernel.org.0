Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4AD6CE33
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 14:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389994AbfGRMk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 08:40:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57685 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727692AbfGRMkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 08:40:55 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1ho5iL-0003ai-Pv; Thu, 18 Jul 2019 14:40:49 +0200
Date:   Thu, 18 Jul 2019 14:40:49 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression with napi/softirq ?
In-Reply-To: <CADVatmN6xNO1iMQ4ihsT5OqV2cuj2ajq+v00NrtUyOHkiKPo-Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1907181439430.1984@nanos.tec.linutronix.de>
References: <20190717201925.fur57qfs2x3ha6aq@debian> <alpine.DEB.2.21.1907172238490.1778@nanos.tec.linutronix.de> <CADVatmO_m-NYotb9Htd7gS0d2-o0DeEWeDJ1uYKE+oj_HjoN0Q@mail.gmail.com> <alpine.DEB.2.21.1907172345360.1778@nanos.tec.linutronix.de>
 <052e43b6-26f8-3e46-784e-dc3c6a82bdf0@gmail.com> <CADVatmN6xNO1iMQ4ihsT5OqV2cuj2ajq+v00NrtUyOHkiKPo-Q@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jul 2019, Sudip Mukherjee wrote:
> On Thu, Jul 18, 2019 at 7:58 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > ksoftirqd might be spuriously scheduled from tx path, when
> > __qdisc_run() also reacts to need_resched().
> >
> > By raising NET_TX while we are processing NET_RX (say we send a TCP ACK packet
> > in response to incoming packet), we force __do_softirq() to perform
> > another loop, but before doing an other round, it will also check need_resched()
> > and eventually call wakeup_softirqd()
> >
> > I wonder if following patch makes any difference.
> >
> > diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> > index 11c03cf4aa74b44663c74e0e3284140b0c75d9c4..ab736e974396394ae6ba409868aaea56a50ad57b 100644
> > --- a/net/sched/sch_generic.c
> > +++ b/net/sched/sch_generic.c
> > @@ -377,6 +377,8 @@ void __qdisc_run(struct Qdisc *q)
> >         int packets;
> >
> >         while (qdisc_restart(q, &packets)) {
> > +               if (qdisc_is_empty(q))
> > +                       break;
> 
> unfortunately its v4.14.55 and qdisc_is_empty() is not yet introduced.
> And I can not backport 28cff537ef2e ("net: sched: add empty status
> flag for NOLOCK qdisc")
> also as TCQ_F_NOLOCK is there. :(

Then please run the test on a current kernel. Backports can be discussed
once the problem is understood.

Thanks,

	tglx
