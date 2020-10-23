Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893B2297615
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 19:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753812AbgJWRs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 13:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S462375AbgJWRs4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 13:48:56 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E2A021582;
        Fri, 23 Oct 2020 17:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603475335;
        bh=yB/s/IuPvxvA/D6puPVcHV6lCpGyQvaLhZjmJ20tayI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k9fHBrAYM+wp3NSCtKkRtPQhXi4dbODGDL1e5+yrI0yvizi07AfTLwsncPus7fsq3
         PgzedNtYAq/z8dABaFdKA5m0OuRfVF24Yw3iSKjqeu+QWxiEWHLtB6J+olk3nzZOzR
         okJSUOlRqfDaLjGwcw8+aGODIQel3BFuv/X1NEiQ=
Date:   Fri, 23 Oct 2020 10:48:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Josh Don <joshdon@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Xi Wang <xii@google.com>
Subject: Re: [PATCH 1/3] sched: better handling for busy polling loops
Message-ID: <20201023104853.55ef1c20@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023032944.399861-1-joshdon@google.com>
References: <20201023032944.399861-1-joshdon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 20:29:42 -0700 Josh Don wrote:
> Busy polling loops in the kernel such as network socket poll and kvm
> halt polling have performance problems related to process scheduler load
> accounting.
> 
> Both of the busy polling examples are opportunistic - they relinquish
> the cpu if another thread is ready to run.

That makes it sound like the busy poll code is trying to behave like an
idle task. I thought need_resched() meant we leave when we run out of
slice, or kernel needs to go through a resched for internal reasons. No?

> This design, however, doesn't
> extend to multiprocessor load balancing very well. The scheduler still
> sees the busy polling cpu as 100% busy and will be less likely to put
> another thread on that cpu. In other words, if all cores are 100%
> utilized and some of them are running real workloads and some others are
> running busy polling loops, newly woken up threads will not prefer the
> busy polling cpus. System wide throughput and latency may suffer.

IDK how well this extends to networking. Busy polling in networking is
a conscious trade-off of CPU for latency, if application chooses to
busy poll (which isn't the default) we should respect that.

Is your use case primarily kvm?
