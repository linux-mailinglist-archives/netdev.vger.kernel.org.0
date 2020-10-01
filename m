Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8296828086F
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 22:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732912AbgJAU00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 16:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgJAU0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 16:26:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7485D2074B;
        Thu,  1 Oct 2020 20:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601583969;
        bh=JX/Yv/jTmgeTSDJ1O4VkJ4HninfeFDT2uLsRhZ55fD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JBTMWZnFgDky54abAOcjgoyh6eYKHGRo3lA6mqpCdaEwGTSv3mR6og/ImsjEf+7EH
         9dP6F7aygJBeVt5CoJC4peECrc+srSmjG4fQ/rRbYXXVHO4F+bGpAEajVqmDFA3bGL
         BNNA12P+txxdWl7dFPNQrUSV2OcMd5v9acyElh3k=
Date:   Thu, 1 Oct 2020 13:26:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 0/5] implement kthread based napi poll
Message-ID: <20201001132607.21bcaa17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iK2-Wu8HMkWiD8U3pdRbwj2tjng-4-fJ81zVw_a3R6OqQ@mail.gmail.com>
References: <20200930192140.4192859-1-weiwan@google.com>
        <20200930130839.427eafa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iK2-Wu8HMkWiD8U3pdRbwj2tjng-4-fJ81zVw_a3R6OqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Oct 2020 09:52:45 +0200 Eric Dumazet wrote:
> On Wed, Sep 30, 2020 at 10:08 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 30 Sep 2020 12:21:35 -0700 Wei Wang wrote:  
> > > With napi poll moved to kthread, scheduler is in charge of scheduling both
> > > the kthreads handling network load, and the user threads, and is able to
> > > make better decisions. In the previous benchmark, if we do this and we
> > > pin the kthreads processing napi poll to specific CPUs, scheduler is
> > > able to schedule user threads away from these CPUs automatically.
> > >
> > > And the reason we prefer 1 kthread per napi, instead of 1 workqueue
> > > entity per host, is that kthread is more configurable than workqueue,
> > > and we could leverage existing tuning tools for threads, like taskset,
> > > chrt, etc to tune scheduling class and cpu set, etc. Another reason is
> > > if we eventually want to provide busy poll feature using kernel threads
> > > for napi poll, kthread seems to be more suitable than workqueue.  
> >
> > As I said in my reply to the RFC I see better performance with the
> > workqueue implementation, so I would hold off until we have more
> > conclusive results there, as this set adds fairly strong uAPI that
> > we'll have to support for ever.  
> 
> We can make incremental changes, the kthread implementation looks much
> nicer to us.

Having done two implementation of something more wq-like now 
I can say with some confidence that it's quite likely not a 
simple extension of this model. And since we'll likely need
to support switching at runtime there will be a fast-path
synchronization overhead.

> The unique work queue is a problem on server class platforms, with
> NUMA placement.
> We now have servers with NIC on different NUMA nodes.

Are you saying that the wq code is less NUMA friendly than unpinned
threads?

> We can not introduce a new model that will make all workload better
> without any tuning.
> If you really think you can do that, think again.

Has Wei tested the wq implementation with real workloads?

All the cover letter has is some basic netperf runs and a vague
sentence saying "real workload also improved".

I think it's possible to get something that will be a better default
for 90% of workloads. Our current model predates SMP by two decades.
It's pretty bad.

I'm talking about upstream defaults, obviously, maybe you're starting
from a different baseline configuration than the rest of the world..

> Even the old ' fix'  (commit 4cd13c21b207e80ddb1144c576500098f2d5f882
> "softirq: Let ksoftirqd do its job" )
> had severe issues for latency sensitive jobs.
> 
> We need to be able to opt-in to threads, and let process scheduler
> take decisions.
> If we believe the process scheduler takes bad decision, it should be
> reported to scheduler experts.

I wouldn't expect that the scheduler will learn all by itself how to
group processes that run identical code for cache efficiency, and how
to schedule at 10us scale. I hope I'm wrong.

> I fully support this implementation, I do not want to wait for yet
> another 'work queue' model or scheduler classes.

I can't sympathize. I don't understand why you're trying to rush this.
And you're not giving me enough info about your target config to be able
to understand your thinking.
