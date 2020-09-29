Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A022327DAFF
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgI2Vsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729237AbgI2Vsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 17:48:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBC1C20774;
        Tue, 29 Sep 2020 21:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601416130;
        bh=AaD5HXF5lAx6IkOUFo1pBDHQCOHa95teKIQtmq1t86I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KzknnuOVUyMP+ZUKHKs60K/C8oD7Rprw4Y0pEcNc/3XZqC4s6X6OZitkXsKw4jNWm
         Vj9Dl6OgGVj35qsABxB2yqL+nwrHdX3HGO1taunMnCmLQWAArReRbjrVjAULOCSv+z
         Ta2/5CQlM+0WES/bCYdoqqSaATZ3qmtu5nNPJZ10=
Date:   Tue, 29 Sep 2020 14:48:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
Message-ID: <20200929144847.05f3dcf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_BPT591fqFRqsM=k4urVXQ1sqL-31rMWjhvKQZm9-Lksg@mail.gmail.com>
References: <20200914172453.1833883-1-weiwan@google.com>
        <CANn89iJDM97U15Znrx4k4bOFKunQp7dwJ9mtPwvMmB4S+rSSbA@mail.gmail.com>
        <20200929121902.7ee1c700@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_BPT591fqFRqsM=k4urVXQ1sqL-31rMWjhvKQZm9-Lksg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020 13:16:59 -0700 Wei Wang wrote:
> On Tue, Sep 29, 2020 at 12:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 28 Sep 2020 19:43:36 +0200 Eric Dumazet wrote:  
> > > Wei, this is a very nice work.
> > >
> > > Please re-send it without the RFC tag, so that we can hopefully merge it ASAP.  
> >
> > The problem is for the application I'm testing with this implementation
> > is significantly slower (in terms of RPS) than Felix's code:
> >
> >               |        L  A  T  E  N  C  Y       |  App   |     C P U     |
> >        |  RPS |   AVG  |  P50  |   P99  |   P999 | Overld |  busy |  PSI  |
> > thread | 1.1% | -15.6% | -0.3% | -42.5% |  -8.1% | -83.4% | -2.3% | 60.6% |
> > work q | 4.3% | -13.1% |  0.1% | -44.4% |  -1.1% |   2.3% | -1.2% | 90.1% |
> > TAPI   | 4.4% | -17.1% | -1.4% | -43.8% | -11.0% | -60.2% | -2.3% | 46.7% |
> >
> > thread is this code, "work q" is Felix's code, TAPI is my hacks.
> >
> > The numbers are comparing performance to normal NAPI.
> >
> > In all cases (but not the baseline) I configured timer-based polling
> > (defer_hard_irqs), with around 100us timeout. Without deferring hard
> > IRQs threaded NAPI is actually slower for this app. Also I'm not
> > modifying niceness, this again causes application performance
> > regression here.
> >  
> 
> If I remember correctly, Felix's workqueue code uses HIGHPRIO flag
> which by default uses -20 as the nice value for the workqueue threads.
> But the kthread implementation leaves nice level as 20 by default.
> This could be 1 difference.

FWIW this is the data based on which I concluded the nice -20 actually
makes things worse here:

      threded: -1.50%
 threded p-20: -5.67%
     thr poll:  2.93%
thr poll p-20:  2.22%

Annoyingly relative performance change varies day to day and this test
was run a while back (over the weekend I was getting < 2% improvement
with this set).

> I am not sure what the benchmark is doing

Not a benchmark, real workload :)

> but one thing to try is to limit the CPUs that run the kthreads to a
> smaller # of CPUs. This could bring up the kernel cpu usage to a
> higher %, e.g. > 80%, so the scheduler is less likely to schedule
> user threads on these CPUs, thus providing isolations between
> kthreads and the user threads, and reducing the scheduling overhead.

Yeah... If I do pinning or isolation I can get to 15% RPS improvement
for this application.. no threaded NAPI needed. The point for me is to
not have to do such tuning per app x platform x workload of the day.

> This could help if the throughput drop is caused by higher scheduling
> latency for the user threads. Another thing to try is to raise the
> scheduling class of the kthread from SCHED_OTHER to SCHED_FIFO. This
> could help if the throughput drop is caused by the kthreads
> experiencing higher scheduling latency.

Isn't the fundamental problem that scheduler works at ms scale while
where we're talking about 100us at most? And AFAICT scheduler doesn't
have a knob to adjust migration cost per process? :(

I just reached out to the kernel experts @FB for their input.

Also let me re-run with a normal prio WQ.

> > 1 NUMA node. 18 NAPI instances each is around 25% of a single CPU.
> >
> > I was initially hoping that TAPI would fit nicely as an extension
> > of this code, but I don't think that will be the case.
> >
> > Are there any assumptions you're making about the configuration that
> > I should try to replicate?  
