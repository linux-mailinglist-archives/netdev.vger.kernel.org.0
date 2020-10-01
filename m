Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444762809E8
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 00:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733131AbgJAWMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 18:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgJAWMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 18:12:34 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE57C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 15:12:32 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k25so175653ioh.7
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 15:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Apr1Mlsynbtc1thNfgqJW8WOK7Dg4Mrmswctp9uIGUg=;
        b=tYW4JiXtD/IKQMEIuy9yKyV3T5/PKONc9lOscUhWEeB9euQBSPIwsp7pBRMKEiVaGy
         a17osqruxqt+crUWDhpvpYON+JQfdSMrs6GPj43xN9Uu1AhR7ZaDXCddD/So39V0akO6
         6FdZr+3JY9atmR/LxnDp1Y4gCx/XEkuhUJg+UGIgoRJx4ZhVidcTJYhl0zdGGonEyTYl
         Bdu+BG2KWMsrjbqg+AhdYJMD5vRRPB179qaVpPVEX7fA9Yu+QXGnB5U6ioEOT4T1XdW/
         p2fDWA3PcHELqXQxXekBQ7IIwpK+MtfjqMIOBDxVBu+Vj/H5R20HXeJoebHwCsUZHgjG
         7Y3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Apr1Mlsynbtc1thNfgqJW8WOK7Dg4Mrmswctp9uIGUg=;
        b=oNO5AQrLl+SotO/iIAHCINYpBTtvMm2I8+p2xnAY4qnZ1bB6XGWycInI6jCUKqpWqN
         d4/7l0Orsw/BX51VN7mO43lD+/D9rfTEqPmM2BEG+6tu/K1QeqJ/SoLUvafhlynw23na
         YkwUpaUjBOvUmGiLs0I1K/W7D027GYhD8XLpesPI7jmubyvUVBb7QT3WtbLFOPwCb0Oi
         t4VlLm6iGH388ivGTB0c2qrSRJe6htH806V/1VTGw1C+N74M4bFAfqtuAIW/n0Yokw8j
         1XFHVsxwQlnpYBpLgorcTgivSLHwDls/KdEAg+hqMPrJTqYnOmwbrV3I8Bkdh8J0DjHx
         UGUQ==
X-Gm-Message-State: AOAM531o/2FVNB+aL21DnAMGfLrcn79xdIYQCLLseZ0ryWUEG2kf6An1
        6eM1ZqtMI6580l235WivMG0cy3QJZaHTuSkQkuLT/w==
X-Google-Smtp-Source: ABdhPJwBfLr3d3Vg2AYYieVS1Tjo7IJR2wXYKhmT34HThmXFZRZi55S7trscu9UTbht7GhG1k3mjZ0x8Coe/S+4f3L8=
X-Received: by 2002:a05:6602:154e:: with SMTP id h14mr7264649iow.17.1601590351532;
 Thu, 01 Oct 2020 15:12:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com> <20200930130839.427eafa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iK2-Wu8HMkWiD8U3pdRbwj2tjng-4-fJ81zVw_a3R6OqQ@mail.gmail.com> <20201001132607.21bcaa17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201001132607.21bcaa17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Thu, 1 Oct 2020 15:12:20 -0700
Message-ID: <CAEA6p_DukokJByTLp4QeGRrbNgC-hb9P6YX5Qh=UswPubrEnVA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] implement kthread based napi poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 1, 2020 at 1:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 1 Oct 2020 09:52:45 +0200 Eric Dumazet wrote:
> > On Wed, Sep 30, 2020 at 10:08 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed, 30 Sep 2020 12:21:35 -0700 Wei Wang wrote:
> > > > With napi poll moved to kthread, scheduler is in charge of scheduling both
> > > > the kthreads handling network load, and the user threads, and is able to
> > > > make better decisions. In the previous benchmark, if we do this and we
> > > > pin the kthreads processing napi poll to specific CPUs, scheduler is
> > > > able to schedule user threads away from these CPUs automatically.
> > > >
> > > > And the reason we prefer 1 kthread per napi, instead of 1 workqueue
> > > > entity per host, is that kthread is more configurable than workqueue,
> > > > and we could leverage existing tuning tools for threads, like taskset,
> > > > chrt, etc to tune scheduling class and cpu set, etc. Another reason is
> > > > if we eventually want to provide busy poll feature using kernel threads
> > > > for napi poll, kthread seems to be more suitable than workqueue.
> > >
> > > As I said in my reply to the RFC I see better performance with the
> > > workqueue implementation, so I would hold off until we have more
> > > conclusive results there, as this set adds fairly strong uAPI that
> > > we'll have to support for ever.
> >
> > We can make incremental changes, the kthread implementation looks much
> > nicer to us.
>
> Having done two implementation of something more wq-like now
> I can say with some confidence that it's quite likely not a
> simple extension of this model. And since we'll likely need
> to support switching at runtime there will be a fast-path
> synchronization overhead.
>
> > The unique work queue is a problem on server class platforms, with
> > NUMA placement.
> > We now have servers with NIC on different NUMA nodes.
>
> Are you saying that the wq code is less NUMA friendly than unpinned
> threads?
>
> > We can not introduce a new model that will make all workload better
> > without any tuning.
> > If you really think you can do that, think again.
>
> Has Wei tested the wq implementation with real workloads?
>
> All the cover letter has is some basic netperf runs and a vague
> sentence saying "real workload also improved".
>

Yes. I did a round of testing with workqueue as well. The "real
workload" I mentioned is a google internal application benchmark which
involves networking  as well as disk ops.
There are 2 types of tests there.
1 is sustained tests, where the ops/s is being pushed to very high,
and keeps the overall cpu usage to > 80%, with various sizes of
payload.
In this type of test case, I see a better result with the kthread
model compared to workqueue in the latency metrics, and similar CPU
savings, with some tuning of the kthreads. (e.g., we limit the
kthreads to a pool of CPUs to run on, to avoid mixture with
application threads. I did the same for workqueue as well to be fair.)
The other is trace based tests, where the load is based on the actual
trace taken from the real servers. This kind of test has less load and
ops/s overall. (~25% total cpu usage on the host)
In this test case, I observe a similar amount of latency savings with
both kthread and workqueue, but workqueue seems to have better cpu
saving here, possibly due to less # of threads woken up to process the
load.

And one reason we would like to push forward with 1 kthread per NAPI,
is we are also trying to do busy polling with the kthread. And it
seems a good model to have 1 kthread dedicated to 1 NAPI to begin
with.

> I think it's possible to get something that will be a better default
> for 90% of workloads. Our current model predates SMP by two decades.
> It's pretty bad.
>
> I'm talking about upstream defaults, obviously, maybe you're starting
> from a different baseline configuration than the rest of the world..
>
> > Even the old ' fix'  (commit 4cd13c21b207e80ddb1144c576500098f2d5f882
> > "softirq: Let ksoftirqd do its job" )
> > had severe issues for latency sensitive jobs.
> >
> > We need to be able to opt-in to threads, and let process scheduler
> > take decisions.
> > If we believe the process scheduler takes bad decision, it should be
> > reported to scheduler experts.
>
> I wouldn't expect that the scheduler will learn all by itself how to
> group processes that run identical code for cache efficiency, and how
> to schedule at 10us scale. I hope I'm wrong.
>
> > I fully support this implementation, I do not want to wait for yet
> > another 'work queue' model or scheduler classes.
>
> I can't sympathize. I don't understand why you're trying to rush this.
> And you're not giving me enough info about your target config to be able
> to understand your thinking.
