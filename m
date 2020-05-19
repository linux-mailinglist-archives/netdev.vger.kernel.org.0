Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7B51DA478
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgESWYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgESWYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:24:11 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241C6C061A0F;
        Tue, 19 May 2020 15:24:11 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jbAeL-0003PM-CF; Wed, 20 May 2020 00:23:49 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id B8CC0100606; Wed, 20 May 2020 00:23:48 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of a seqcount
In-Reply-To: <20200519150159.4d91af93@hermes.lan>
References: <20200519214547.352050-1-a.darwish@linutronix.de> <20200519214547.352050-2-a.darwish@linutronix.de> <20200519150159.4d91af93@hermes.lan>
Date:   Wed, 20 May 2020 00:23:48 +0200
Message-ID: <87v9kr5zt7.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Hemminger <stephen@networkplumber.org> writes:
> On Tue, 19 May 2020 23:45:23 +0200
> "Ahmed S. Darwish" <a.darwish@linutronix.de> wrote:
>
>> Sequence counters write paths are critical sections that must never be
>> preempted, and blocking, even for CONFIG_PREEMPTION=n, is not allowed.
>> 
>> Commit 5dbe7c178d3f ("net: fix kernel deadlock with interface rename and
>> netdev name retrieval.") handled a deadlock, observed with
>> CONFIG_PREEMPTION=n, where the devnet_rename seqcount read side was
>> infinitely spinning: it got scheduled after the seqcount write side
>> blocked inside its own critical section.
>> 
>> To fix that deadlock, among other issues, the commit added a
>> cond_resched() inside the read side section. While this will get the
>> non-preemptible kernel eventually unstuck, the seqcount reader is fully
>> exhausting its slice just spinning -- until TIF_NEED_RESCHED is set.
>> 
>> The fix is also still broken: if the seqcount reader belongs to a
>> real-time scheduling policy, it can spin forever and the kernel will
>> livelock.
>> 
>> Disabling preemption over the seqcount write side critical section will
>> not work: inside it are a number of GFP_KERNEL allocations and mutex
>> locking through the drivers/base/ :: device_rename() call chain.
>> 
>> From all the above, replace the seqcount with a rwsem.
>> 
>> Fixes: 5dbe7c178d3f (net: fix kernel deadlock with interface rename and netdev name retrieval.)
>> Fixes: 30e6c9fa93cf (net: devnet_rename_seq should be a seqcount)
>> Fixes: c91f6df2db49 (sockopt: Change getsockopt() of SO_BINDTODEVICE to return an interface name)
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
>> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>
> Have your performance tested this with 1000's of network devices?

No. We did not. -ENOTESTCASE

> The reason seqcount logic is was done here was to achieve scaleablity
> and a semaphore does not scale as well.

That still does not make the livelock magically going away. Just make a
reader with real-time priority preempt the writer and the system stops
dead. The net result is perfomance <= 0.

This was observed on RT kernels without a special 1000's of network
devices test case.

Just for the record: This is not a RT specific problem. You can
reproduce that w/o an RT kernel as well. Just run the reader with
real-time scheduling policy.

As much as you hate it from a performance POV the only sane rule of
programming is: Correctness first.

And this code clearly violates that rule.

Thanks,

        tglx
