Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E6E381B1E
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 22:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbhEOUyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 16:54:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44496 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhEOUyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 16:54:43 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621112009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=20Hw+TFKWUeeing3YBFehjeWi00clpvEhJGIjm1XtDc=;
        b=w4nKqKLHEXhZkimR8UxhHXtO+U7U1K4C7sgXiAoTJkwPJqhuhHuIkRMt50gebF2/Gc7CQp
        lHzCeMdItrS1FfbiNvcqJDpcMIbFmH/4aroAsv+h+Ogf1uxW9rlh3jbMcA6VQFxQIlj2jC
        I1HOd5rgk9VW89tEXJFnZQkFP6ED7LFSHOMfL4HRwt80KtzaE//o5BrjTBqkwzFru0GGn5
        vqb/z6Nkn0ZEKdzt1CkqxwXxR9A7GDkYTU4DORaXGca8chyk9R6R1cCLaUhToUunZgRiyv
        3cyvDb7XkivmVabbmtB/3KnqXC3o4aqxsIj8g1uRpBlTe67YV6vWrjMHS0dK6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621112009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=20Hw+TFKWUeeing3YBFehjeWi00clpvEhJGIjm1XtDc=;
        b=J0tUp3sDG4jt2p5EySqFlYQJDPzorS8tve4mzIdlL9SVJUqcFNxVxX4Gc9KmCqa5PZ3rk1
        3wZFMvz2nyrOu3Cw==
To:     Jakub Kicinski <kuba@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, simon.horman@netronome.com,
        oss-drivers@netronome.com, Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH net-next 1/2] net: add a napi variant for RT-well-behaved drivers
In-Reply-To: <20210515133104.491fc691@kicinski-fedora-PC1C0HJN>
References: <20210514222402.295157-1-kuba@kernel.org> <20210515110740.lwt6wlw6wq73ifat@linutronix.de> <20210515133104.491fc691@kicinski-fedora-PC1C0HJN>
Date:   Sat, 15 May 2021 22:53:28 +0200
Message-ID: <87cztr1zxz.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15 2021 at 13:31, Jakub Kicinski wrote:
> On Sat, 15 May 2021 13:07:40 +0200 Sebastian Andrzej Siewior wrote:
>> Now assume another interrupt comes in which wakes a force-threaded
>> handler (while ksoftirqd is preempted). Before the forced-threaded
>> handler is invoked, BH is disabled via local_bh_disable(). Since
>> ksoftirqd is preempted with BH disabled, disabling BH forces the
>> ksoftirqd thread to the priority of the interrupt thread (SCHED_FIFO,
>> prio 50 by default) due to the priority inheritance protocol. The
>> threaded handler will run once ksoftirqd is done which has now been
>> accelerated.
>
> Thanks for the explanation. I'm not married to the patch, if you prefer
> we can keep the status quo.
>
> I'd think, however, that always deferring to ksoftirqd is conceptually
> easier to comprehend. For power users who need networking there is
> prefer-busy-poll (which allows application to ask the kernel to service
> queues when it wants to, with some minimal poll frequency guarantees)
> and threaded NAPI - which some RT users already started to adapt.
>
> Your call.
>
>> Part of the problem from RT perspective is the heavy use of softirq and
>> the BH disabled regions which act as a BKL. I *think* having the network
>> driver running in a thread would be better (in terms of prioritisation).
>> I know, davem explained the benefits of NAPI/softirq when it comes to
>> routing/forwarding (incl. NET_RX/TX priority) and part where NAPI kicks
>> in during a heavy load (say a packet flood) and system is still
>> responsible.
>
> Right, although with modern multi-core systems where only a subset 
> of cores process network Rx things look different.

Bah, I completely forgot about that aspect. Thanks Sebastian for
bringing it up. I was too focussed on the other questions and there is
obviously the onset of alzheimer.

Anyway it's a touch choice to make. There are too many options to chose
from nowadays. 10 years ago running the softirq at the back of the
threaded irq handler which just scheduled NAPI was definitely a win, but
with threaded NAPI, zero copy and other things it's not that important
anymore IMO. But I might be missing something obviously.

I've cc'ed a few RT folks @RHT who might give some insight.

Thanks,

        tglx
