Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851C0281EA0
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgJBWt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:49:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJBWt2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 18:49:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E20DA206C9;
        Fri,  2 Oct 2020 22:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601678968;
        bh=VPkO6ENmeMnF9COaO5bw7dqy3midxEPlBeA66r5SBZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O+cYlX+OWRzCHsK9Uxh85kAuMFYPgdx1neNeapE2PI1vY3AhKJbM4WGi6yyMcm40Z
         YCsjQGB30NNEbw4Zt+a2SMUVq9zxNNx0LfGbDl828wqntkGYWKzli97RZ7ZNsM/fXI
         ydGi3uMi0Y+03LaVII8JzGl5D4FQPTdxqZ2bk+WU=
Date:   Fri, 2 Oct 2020 15:49:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 0/5] implement kthread based napi poll
Message-ID: <20201002154926.49af25e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iK30VVUggQn6-ULOhKnLxz4Ogjw8fMZxbqWiOztURdccA@mail.gmail.com>
References: <20200930192140.4192859-1-weiwan@google.com>
        <20200930130839.427eafa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iK2-Wu8HMkWiD8U3pdRbwj2tjng-4-fJ81zVw_a3R6OqQ@mail.gmail.com>
        <20201001132607.21bcaa17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iK30VVUggQn6-ULOhKnLxz4Ogjw8fMZxbqWiOztURdccA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Oct 2020 09:56:31 +0200 Eric Dumazet wrote:
> On Thu, Oct 1, 2020 at 10:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 1 Oct 2020 09:52:45 +0200 Eric Dumazet wrote:  
> 
> > > The unique work queue is a problem on server class platforms, with
> > > NUMA placement.
> > > We now have servers with NIC on different NUMA nodes.  
> >
> > Are you saying that the wq code is less NUMA friendly than unpinned
> > threads?  
> 
> Yes this is what I am saying.
> 
> Using a single and shared wq wont allow you to make sure :
> - work for NIC0 attached on NUMA node#0 will be using CPUS belonging to node#0
> - work for NIC1 attached on NUMA node#1 will be using CPUS belonging to node#1
> 
> 
> The only way you can tune things with a single wq is tweaking a single cpumask,
> that we can change with /sys/devices/virtual/workqueue/{wqname}/cpumask
> The same for the nice value with  /sys/devices/virtual/workqueue/{wqname}/nice.
> 
> In contrast, having kthreads let you tune things independently, if needed.
> 
> Even with a single NIC, you can still need isolation between queues.
> We have queues dedicated to a certain kind of traffic/application.
> 
> The work queue approach would need to be able to create/delete
> independent workqueues.
> But we tested the workqueue with a single NIC and our results gave to
> kthreads a win over the work queue.

Not according to the results Wei posted last night..

> Really, wq concept might be a nice abstraction when each work can be
> running for arbitrary durations,
> and arbitrary numbers of cpus, but with the NAPI model of up to 64
> packets at a time, and a fixed number of queues,

In my experiments the worker threads get stalled sooner or later. 
And unless there is some work stealing going on latency spikes follow.

I would also not discount the variability in processing time. For a
budget of 64 the processing can take 0-500us per round, not counting
outliers.

> we should not add the work queue overhead.

Does this mean you're going to be against the (more fleshed out)
work queue implementation?
