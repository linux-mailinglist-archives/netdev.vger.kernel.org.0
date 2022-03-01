Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D9E4C97BF
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 22:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbiCAV0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbiCAV0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:26:21 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17245D5C3;
        Tue,  1 Mar 2022 13:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QnD/sPU9Got8d7z6bMYumQ8h8SNKmNz8BVeywKDdy3I=; b=qjGyftkiAcw/sWeETuB8EPoxmE
        6swUoE/NACmgP1pYRVGR672Osfm8yXOruDQydZE/IRU+R08nXJYFg1gXi70P4f87+wnTx6sv1lLji
        bt8MaXzAbBsmU4NFLxKakziJVRIhSEUwXh8Jdo/XTPl3w08ObVp81PtcvA4N+JYIooRZzUCoSCI8Y
        3P5DZAfn7quUPB/a92/SkpBTemgM07simC7i3GArU25WqhI6D/HqBejwVrqVq6th5JNnO1W0HUFCk
        4jld3kUos7CXC4RnTdYrygqk8LvO60yoO2EfG3mTez71kLGpvITsE84j92cd94m2Ub4MhJ6ZSap74
        3IiLdfuA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nP9zg-000cax-7Q; Tue, 01 Mar 2022 21:25:16 +0000
Date:   Tue, 1 Mar 2022 13:25:16 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        NeilBrown <neilb@suse.de>, Vasily Averin <vvs@virtuozzo.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Linux MM <linux-mm@kvack.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org
Subject: Re: [PATCH RFC] net: memcg accounting for veth devices
Message-ID: <Yh6PPPqgPxJy+Jvx@bombadil.infradead.org>
References: <a5e09e93-106d-0527-5b1e-48dbf3b48b4e@virtuozzo.com>
 <YhzeCkXEvga7+o/A@bombadil.infradead.org>
 <20220301180917.tkibx7zpcz2faoxy@google.com>
 <Yh5lyr8dJXmEoFG6@bombadil.infradead.org>
 <87wnhdwg75.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnhdwg75.fsf@email.froward.int.ebiederm.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 02:50:06PM -0600, Eric W. Biederman wrote:
> Luis Chamberlain <mcgrof@kernel.org> writes:
> 
> > On Tue, Mar 01, 2022 at 10:09:17AM -0800, Shakeel Butt wrote:
> >> On Mon, Feb 28, 2022 at 06:36:58AM -0800, Luis Chamberlain wrote:
> >> > On Mon, Feb 28, 2022 at 10:17:16AM +0300, Vasily Averin wrote:
> >> > > Following one-liner running inside memcg-limited container consumes
> >> > > huge number of host memory and can trigger global OOM.
> >> > >
> >> > > for i in `seq 1 xxx` ; do ip l a v$i type veth peer name vp$i ; done
> >> > >
> >> > > Patch accounts most part of these allocations and can protect host.
> >> > > ---[cut]---
> >> > > It is not polished, and perhaps should be splitted.
> >> > > obviously it affects other kind of netdevices too.
> >> > > Unfortunately I'm not sure that I will have enough time to handle it
> >> > properly
> >> > > and decided to publish current patch version as is.
> >> > > OpenVz workaround it by using per-container limit for number of
> >> > > available netdevices, but upstream does not have any kind of
> >> > > per-container configuration.
> >> > > ------
> >> 
> >> > Should this just be a new ucount limit on kernel/ucount.c and have veth
> >> > use something like inc_ucount(current_user_ns(), current_euid(),
> >> > UCOUNT_VETH)?
> >> 
> >> > This might be abusing ucounts though, not sure, Eric?
> >> 
> >> 
> >> For admins of systems running multiple workloads, there is no easy way
> >> to set such limits for each workload.
> >
> > That's why defaults would exist. Today's ulimits IMHO are insane and
> > some are arbitrarily large.
> 
> My perspective is that we have two basic kinds of limits.
> 
> Limits to catch programs that go out of control hopefully before they
> bring down the entire system.  This is the purpose I see of rlimits and
> ucounts.  Such limits should be set by default so large that no one has
> to care unless their program is broken.
> 
> Limits to contain programs and keep them from having a negative impact
> on other programs.  Generally this is the role I see the cgroups
> playing.  This limits must be much more tightly managed.
> 
> The problem with veth that was reported was that the memory cgroup
> limits fails to contain veth's allocations and veth manages to affect
> process outside the memory cgroup where the veth ``lives''.  The effect
> is an OOM but the problem is that it is affecting processes out of the
> memory control group.

Given no upper bound was used in the commit log, it seems to have
presented a use case where both types of limits might need to be
considered though.

> Part of the reason for the recent ucount work is so that ordinary users
> can create user namespaces and root in that user namespace won't be able
> to exceed the limits that were set when the user namespace was created
> by creating additional users.

Got it.

> Part of the reason for my ucount work is my frustration that cgroups
> would up something completely different than what was originally
> proposed and solve a rather problem set.  Originally the proposal was
> that cgroups would be the user interface for the bean-counter patches.
> (Roughly counts like the ucounts are now).  Except for maybe the pid
> controller you mention below cgroups look nothing like that today.
> So I went and I solved the original problem because it was still not
> solved.

I see...

> The network stack should already have packet limits to prevent a global
> OOM so I am a bit curious why those limits aren't preventing a global
> OOM in for the veth device.

No packets are used in the demo / commit log, it is just creating
tons of veths that OOMs.

> I am not saying that the patch is correct (although from 10,000 feet the
> patch sounds like it is solving the reported problem).

From your description, it would like it is indeed a right approach
to correct memory allocations so that cgroup memory limits are respected.

Outside of that, it still begs the question if the ucounts can/should
be used for something like root in a namespace creating tons of veths
and put a cap to that.

> I am answering
> the question of how I understand limits to work.

It does!

> Luis does this explanation of how limits work help?

Yup thanks!

> >> From admin's perspective it is preferred to have minimal
> >> knobs to set and if these objects are charged to memcg then the memcg
> >> limits would limit them. There was similar situation for inotify
> >> instances where fs sysctl inotify/max_user_instances already limits the
> >> inotify instances but we memcg charged them to not worry about setting
> >> such limits. See ac7b79fd190b ("inotify, memcg: account inotify
> >> instances to kmemcg").
> >
> > Yes but we want sensible defaults out of the box. What those should be
> > IMHO might be work which needs to be figured out well.
> >
> > IMHO today's ulimits are a bit over the top today. This is off slightly
> > off topic but for instance play with:
> >
> > git clone https://github.com/ColinIanKing/stress-ng
> > cd stress-ng
> > make -j 8
> > echo 0 > /proc/sys/vm/oom_dump_tasks                                            
> > i=1; while true; do echo "RUNNING TEST $i"; ./stress-ng --unshare 8192 --unshare-ops 10000;  sleep 1; let i=$i+1; done
> >
> > If you see:
> >
> > [  217.798124] cgroup: fork rejected by pids controller in
> > /user.slice/user-1000.slice/session-1.scope
> >                                                                                 
> > Edit /usr/lib/systemd/system/user-.slice.d/10-defaults.conf to be:
> >
> > [Slice]                                                                         
> > TasksMax=MAX_TASKS|infinity
> >
> > Even though we have max_threads set to 61343, things ulimits have a
> > different limit set, and what this means is the above can end up easily
> > creating over 1048576 (17 times max_threads) threads all eagerly doing
> > nothing to just exit, essentially allowing a sort of fork bomb on exit.
> > Your system may or not fall to its knees.
> 
> What max_threads are you talking about here?

Sorry for not being clear, in the kernel this is exposed as max_threads

Which is initialize do kernel/fork.c

root@linus-blktests-block ~ # cat /proc/sys/kernel/threads-max
62157

> The global max_threads
> exposed in /proc/sys/kernel/threads-max?  I don't see how you can get
> around that. 

Yeah I was perplexed and I don't think it's just me.

> Especially since the count is not decremented until the
> process is reaped.
>
> Or is this the pids controller having a low limit and
> /proc/sys/kernel/threads-max having a higher limit?

Not sure, I used defailt debian testing with the above change
to /usr/lib/systemd/system/user-.slice.d/10-defaults.conf to
TasksMax=MAX_TASKS|infinity

> I really have not looked at this pids controller.
> 
> So I am not certain I understand your example here but I hope I have
> answered your question.

During experimentation with the above stress-ng test case, I saw tons
of thread just waiting to do exit:

diff --git a/kernel/exit.c b/kernel/exit.c
index 80c4a67d2770..653ca7ebfb58 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -730,11 +730,24 @@ static void check_stack_usage(void)
 static inline void check_stack_usage(void) {}
 #endif
 
+/* Approx more than twice max_threads */
+#define MAX_EXIT_CONCURRENT (1<<17)
+static atomic_t exit_concurrent_max = ATOMIC_INIT(MAX_EXIT_CONCURRENT);
+static DECLARE_WAIT_QUEUE_HEAD(exit_wq);
+
 void __noreturn do_exit(long code)
 {
 	struct task_struct *tsk = current;
 	int group_dead;
 
+	if (atomic_dec_if_positive(&exit_concurrent_max) < 0) {
+		pr_warn_ratelimited("exit: exit_concurrent_max (%u) close to 0 (max : %u), throttling...",
+				    atomic_read(&exit_concurrent_max),
+				    MAX_EXIT_CONCURRENT);
+		wait_event(exit_wq,
+			   atomic_dec_if_positive(&exit_concurrent_max) >= 0);
+	}
+
 	/*
 	 * We can get here from a kernel oops, sometimes with preemption off.
 	 * Start by checking for critical errors.
@@ -881,6 +894,9 @@ void __noreturn do_exit(long code)
 
 	lockdep_free_task(tsk);
 	do_task_dead();
+
+	atomic_inc(&exit_concurrent_max);
+	wake_up(&exit_wq);
 }
 EXPORT_SYMBOL_GPL(do_exit);
 
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 4f5613dac227..980ffaba1ac5 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -238,6 +238,8 @@ struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid,
 		long max;
 		tns = iter->ns;
 		max = READ_ONCE(tns->ucount_max[type]);
+		if (atomic_long_read(&iter->ucount[type]) > max/16)
+			cond_resched();
 		if (!atomic_long_inc_below(&iter->ucount[type], max))
 			goto fail;
 	}
-- 
2.33.0

In my experimentation I saw we can easily have the above trigger 131072
concurrent exist waiting, which is twice /proc/sys/kernel/threads-max,
and at this point no OOM happens. But in reality I also saw us hitting
even 1048576, anything above 131072 starts causing tons of issues
(depending on the kernel) like OOMs or it being hard to bail on the
above shell loop.

  Luis
