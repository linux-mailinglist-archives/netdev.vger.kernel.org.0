Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50C75FEE8B
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 15:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiJNNYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 09:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiJNNYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 09:24:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4831ACAB4;
        Fri, 14 Oct 2022 06:24:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7F52B82348;
        Fri, 14 Oct 2022 13:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ADAC433C1;
        Fri, 14 Oct 2022 13:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665753853;
        bh=NfzJJPpEsYap5JTJGXnZeaDdhJ0bdRKWtWvmBYKS3zo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g5CITQgarWLijG6POvZrQD5wZCL25BseYlqoihIEYobWTPFBeCW+bDosWRlaBGd5c
         K+xYXzfCH2z91xlf5lPPaM1iar4vkVQxYCLGSkOZGuN7oy7wBtQMkX1KfB9pL8hWPx
         D5WI7849B5oqjZKNW+SLcWm4CMymr5kKreyZe7OkWOWvJWjZAPcgeJpFcbezR9eHf8
         60OZ67ilAHd98sz7pJxcrQEeGrBON0YLQ+k/8dz6BTNQtByKHtIiZqiPCMAP/HKM2E
         r230vHve15orY4ljb2GUc509QIuljcUvKThMODqhmaZFStgBECst8mYrTK05cgwTyN
         7uaDs5YlLJpOw==
Date:   Fri, 14 Oct 2022 15:24:10 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Leonardo Bras <leobras@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        fweisbec@gmail.com
Subject: Re: [PATCH v2 3/4] sched/isolation: Add HK_TYPE_WQ to isolcpus=domain
Message-ID: <20221014132410.GA1108603@lothringen>
References: <20221013184028.129486-1-leobras@redhat.com>
 <20221013184028.129486-4-leobras@redhat.com>
 <Y0kfgypRPdJYrvM3@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0kfgypRPdJYrvM3@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 10:36:19AM +0200, Peter Zijlstra wrote:
> 
> + Frederic; who actually does most of this code
> 
> On Thu, Oct 13, 2022 at 03:40:28PM -0300, Leonardo Bras wrote:
> > Housekeeping code keeps multiple cpumasks in order to keep track of which
> > cpus can perform given housekeeping category.
> > 
> > Every time the HK_TYPE_WQ cpumask is checked before queueing work at a cpu
> > WQ it also happens to check for HK_TYPE_DOMAIN. So It can be assumed that
> > the Domain isolation also ends up isolating work queues.
> > 
> > Delegating current HK_TYPE_DOMAIN's work queue isolation to HK_TYPE_WQ
> > makes it simpler to check if a cpu can run a task into an work queue, since
> > code just need to go through a single HK_TYPE_* cpumask.
> > 
> > Make isolcpus=domain aggregate both HK_TYPE_DOMAIN and HK_TYPE_WQ, and
> > remove a lot of cpumask_and calls.
> > 
> > Also, remove a unnecessary '|=' at housekeeping_isolcpus_setup() since we
> > are sure that 'flags == 0' here.
> > 
> > Signed-off-by: Leonardo Bras <leobras@redhat.com>
> 
> I've long maintained that having all these separate masks is daft;
> Frederic do we really need that?

Indeed. In my queue for the cpuset interface to nohz_full, I have the following
patch (but note DOMAIN and WQ have to stay seperate flags because workqueue
affinity can be modified seperately from isolcpus)

---
From: Frederic Weisbecker <frederic@kernel.org>
Date: Tue, 26 Jul 2022 17:03:30 +0200
Subject: [PATCH] sched/isolation: Gather nohz_full related isolation features
 into common flag

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 arch/x86/kvm/x86.c              |  2 +-
 drivers/pci/pci-driver.c        |  2 +-
 include/linux/sched/isolation.h |  7 +------
 kernel/cpu.c                    |  4 ++--
 kernel/kthread.c                |  4 ++--
 kernel/rcu/tasks.h              |  2 +-
 kernel/rcu/tree_plugin.h        |  6 +++---
 kernel/sched/core.c             | 10 +++++-----
 kernel/sched/fair.c             |  6 +++---
 kernel/sched/isolation.c        | 25 +++++++------------------
 kernel/watchdog.c               |  2 +-
 kernel/workqueue.c              |  2 +-
 net/core/net-sysfs.c            |  2 +-
 13 files changed, 29 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1910e1e78b15..d0b73fcf4a1c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9009,7 +9009,7 @@ int kvm_arch_init(void *opaque)
 	}
 
 	if (pi_inject_timer == -1)
-		pi_inject_timer = housekeeping_enabled(HK_TYPE_TIMER);
+		pi_inject_timer = housekeeping_enabled(HK_TYPE_NOHZ_FULL);
 #ifdef CONFIG_X86_64
 	pvclock_gtod_register_notifier(&pvclock_gtod_notifier);
 
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 49238ddd39ee..af3494a39921 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -378,7 +378,7 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 			goto out;
 		}
 		cpumask_and(wq_domain_mask,
-			    housekeeping_cpumask(HK_TYPE_WQ),
+			    housekeeping_cpumask(HK_TYPE_NOHZ_FULL),
 			    housekeeping_cpumask(HK_TYPE_DOMAIN));
 
 		cpu = cpumask_any_and(cpumask_of_node(node),
diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 8c15abd67aed..7ca34e04abe7 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -6,15 +6,10 @@
 #include <linux/tick.h>
 
 enum hk_type {
-	HK_TYPE_TIMER,
-	HK_TYPE_RCU,
-	HK_TYPE_MISC,
+	HK_TYPE_NOHZ_FULL,
 	HK_TYPE_SCHED,
-	HK_TYPE_TICK,
 	HK_TYPE_DOMAIN,
-	HK_TYPE_WQ,
 	HK_TYPE_MANAGED_IRQ,
-	HK_TYPE_KTHREAD,
 	HK_TYPE_MAX
 };
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index bbad5e375d3b..573f14d75a2e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1500,8 +1500,8 @@ int freeze_secondary_cpus(int primary)
 	cpu_maps_update_begin();
 	if (primary == -1) {
 		primary = cpumask_first(cpu_online_mask);
-		if (!housekeeping_cpu(primary, HK_TYPE_TIMER))
-			primary = housekeeping_any_cpu(HK_TYPE_TIMER);
+		if (!housekeeping_cpu(primary, HK_TYPE_NOHZ_FULL))
+			primary = housekeeping_any_cpu(HK_TYPE_NOHZ_FULL);
 	} else {
 		if (!cpu_online(primary))
 			primary = cpumask_first(cpu_online_mask);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 544fd4097406..0719035feba0 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -355,7 +355,7 @@ static int kthread(void *_create)
 	 * back to default in case they have been changed.
 	 */
 	sched_setscheduler_nocheck(current, SCHED_NORMAL, &param);
-	set_cpus_allowed_ptr(current, housekeeping_cpumask(HK_TYPE_KTHREAD));
+	set_cpus_allowed_ptr(current, housekeeping_cpumask(HK_TYPE_NOHZ_FULL));
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
@@ -721,7 +721,7 @@ int kthreadd(void *unused)
 	/* Setup a clean context for our children to inherit. */
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
-	set_cpus_allowed_ptr(tsk, housekeeping_cpumask(HK_TYPE_KTHREAD));
+	set_cpus_allowed_ptr(tsk, housekeeping_cpumask(HK_TYPE_NOHZ_FULL));
 	set_mems_allowed(node_states[N_MEMORY]);
 
 	current->flags |= PF_NOFREEZE;
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index f5bf6fb430da..b99f79625b26 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -537,7 +537,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 	struct rcu_tasks *rtp = arg;
 
 	/* Run on housekeeping CPUs by default.  Sysadm can move if desired. */
-	housekeeping_affine(current, HK_TYPE_RCU);
+	housekeeping_affine(current, HK_TYPE_NOHZ_FULL);
 	WRITE_ONCE(rtp->kthread_ptr, current); // Let GPs start!
 
 	/*
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index b2219577fbe2..4935b06c3caf 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1237,9 +1237,9 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 		if ((mask & leaf_node_cpu_bit(rnp, cpu)) &&
 		    cpu != outgoingcpu)
 			cpumask_set_cpu(cpu, cm);
-	cpumask_and(cm, cm, housekeeping_cpumask(HK_TYPE_RCU));
+	cpumask_and(cm, cm, housekeeping_cpumask(HK_TYPE_NOHZ_FULL));
 	if (cpumask_empty(cm))
-		cpumask_copy(cm, housekeeping_cpumask(HK_TYPE_RCU));
+		cpumask_copy(cm, housekeeping_cpumask(HK_TYPE_NOHZ_FULL));
 	set_cpus_allowed_ptr(t, cm);
 	mutex_unlock(&rnp->boost_kthread_mutex);
 	free_cpumask_var(cm);
@@ -1294,5 +1294,5 @@ static void rcu_bind_gp_kthread(void)
 {
 	if (!tick_nohz_full_enabled())
 		return;
-	housekeeping_affine(current, HK_TYPE_RCU);
+	housekeeping_affine(current, HK_TYPE_NOHZ_FULL);
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f53c0096860b..5ff205f39197 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1079,13 +1079,13 @@ int get_nohz_timer_target(void)
 	struct sched_domain *sd;
 	const struct cpumask *hk_mask;
 
-	if (housekeeping_cpu(cpu, HK_TYPE_TIMER)) {
+	if (housekeeping_cpu(cpu, HK_TYPE_NOHZ_FULL)) {
 		if (!idle_cpu(cpu))
 			return cpu;
 		default_cpu = cpu;
 	}
 
-	hk_mask = housekeeping_cpumask(HK_TYPE_TIMER);
+	hk_mask = housekeeping_cpumask(HK_TYPE_NOHZ_FULL);
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
@@ -1101,7 +1101,7 @@ int get_nohz_timer_target(void)
 	}
 
 	if (default_cpu == -1)
-		default_cpu = housekeeping_any_cpu(HK_TYPE_TIMER);
+		default_cpu = housekeeping_any_cpu(HK_TYPE_NOHZ_FULL);
 	cpu = default_cpu;
 unlock:
 	rcu_read_unlock();
@@ -5562,7 +5562,7 @@ static void sched_tick_start(int cpu)
 	int os;
 	struct tick_work *twork;
 
-	if (housekeeping_cpu(cpu, HK_TYPE_TICK))
+	if (housekeeping_cpu(cpu, HK_TYPE_NOHZ_FULL))
 		return;
 
 	WARN_ON_ONCE(!tick_work_cpu);
@@ -5583,7 +5583,7 @@ static void sched_tick_stop(int cpu)
 	struct tick_work *twork;
 	int os;
 
-	if (housekeeping_cpu(cpu, HK_TYPE_TICK))
+	if (housekeeping_cpu(cpu, HK_TYPE_NOHZ_FULL))
 		return;
 
 	WARN_ON_ONCE(!tick_work_cpu);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 77b2048a9326..ac3b33e00451 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10375,7 +10375,7 @@ static inline int on_null_domain(struct rq *rq)
  * - When one of the busy CPUs notice that there may be an idle rebalancing
  *   needed, they will kick the idle load balancer, which then does idle
  *   load balancing for all the idle CPUs.
- * - HK_TYPE_MISC CPUs are used for this task, because HK_TYPE_SCHED not set
+ * - HK_TYPE_NOHZ_FULL CPUs are used for this task, because HK_TYPE_SCHED not set
  *   anywhere yet.
  */
 
@@ -10384,7 +10384,7 @@ static inline int find_new_ilb(void)
 	int ilb;
 	const struct cpumask *hk_mask;
 
-	hk_mask = housekeeping_cpumask(HK_TYPE_MISC);
+	hk_mask = housekeeping_cpumask(HK_TYPE_NOHZ_FULL);
 
 	for_each_cpu_and(ilb, nohz.idle_cpus_mask, hk_mask) {
 
@@ -10400,7 +10400,7 @@ static inline int find_new_ilb(void)
 
 /*
  * Kick a CPU to do the nohz balancing, if it is time for it. We pick any
- * idle CPU in the HK_TYPE_MISC housekeeping set (if there is one).
+ * idle CPU in the HK_TYPE_NOHZ_FULL housekeeping set (if there is one).
  */
 static void kick_ilb(unsigned int flags)
 {
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 4087718ee5b4..443f1ce83e32 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -4,20 +4,15 @@
  *  any CPU: unbound workqueues, timers, kthreads and any offloadable work.
  *
  * Copyright (C) 2017 Red Hat, Inc., Frederic Weisbecker
- * Copyright (C) 2017-2018 SUSE, Frederic Weisbecker
+ * Copyright (C) 2017-2022 SUSE, Frederic Weisbecker
  *
  */
 
 enum hk_flags {
-	HK_FLAG_TIMER		= BIT(HK_TYPE_TIMER),
-	HK_FLAG_RCU		= BIT(HK_TYPE_RCU),
-	HK_FLAG_MISC		= BIT(HK_TYPE_MISC),
+	HK_FLAG_NOHZ_FULL	= BIT(HK_TYPE_NOHZ_FULL),
 	HK_FLAG_SCHED		= BIT(HK_TYPE_SCHED),
-	HK_FLAG_TICK		= BIT(HK_TYPE_TICK),
 	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
-	HK_FLAG_WQ		= BIT(HK_TYPE_WQ),
 	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
-	HK_FLAG_KTHREAD		= BIT(HK_TYPE_KTHREAD),
 };
 
 DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
@@ -88,7 +83,7 @@ void __init housekeeping_init(void)
 
 	static_branch_enable(&housekeeping_overridden);
 
-	if (housekeeping.flags & HK_FLAG_TICK)
+	if (housekeeping.flags & HK_FLAG_NOHZ_FULL)
 		sched_tick_offload_init();
 
 	for_each_set_bit(type, &housekeeping.flags, HK_TYPE_MAX) {
@@ -111,7 +106,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 	cpumask_var_t non_housekeeping_mask, housekeeping_staging;
 	int err = 0;
 
-	if ((flags & HK_FLAG_TICK) && !(housekeeping.flags & HK_FLAG_TICK)) {
+	if ((flags & HK_FLAG_NOHZ_FULL) && !(housekeeping.flags & HK_FLAG_NOHZ_FULL)) {
 		if (!IS_ENABLED(CONFIG_NO_HZ_FULL)) {
 			pr_warn("Housekeeping: nohz unsupported."
 				" Build with CONFIG_NO_HZ_FULL\n");
@@ -163,7 +158,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 			housekeeping_setup_type(type, housekeeping_staging);
 	}
 
-	if ((flags & HK_FLAG_TICK) && !(housekeeping.flags & HK_FLAG_TICK))
+	if ((flags & HK_FLAG_NOHZ_FULL) && !(housekeeping.flags & HK_FLAG_NOHZ_FULL))
 		tick_nohz_full_setup(non_housekeeping_mask);
 
 	housekeeping.flags |= flags;
@@ -179,12 +174,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 
 static int __init housekeeping_nohz_full_setup(char *str)
 {
-	unsigned long flags;
-
-	flags = HK_FLAG_TICK | HK_FLAG_WQ | HK_FLAG_TIMER | HK_FLAG_RCU |
-		HK_FLAG_MISC | HK_FLAG_KTHREAD;
-
-	return housekeeping_setup(str, flags);
+	return housekeeping_setup(str, HK_FLAG_NOHZ_FULL);
 }
 __setup("nohz_full=", housekeeping_nohz_full_setup);
 
@@ -198,8 +188,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
 	while (isalpha(*str)) {
 		if (!strncmp(str, "nohz,", 5)) {
 			str += 5;
-			flags |= HK_FLAG_TICK | HK_FLAG_WQ | HK_FLAG_TIMER |
-				HK_FLAG_RCU | HK_FLAG_MISC | HK_FLAG_KTHREAD;
+			flags |= HK_FLAG_NOHZ_FULL;
 			continue;
 		}
 
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 20a7a55e62b6..3e9636f4bac6 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -852,7 +852,7 @@ void __init lockup_detector_init(void)
 		pr_info("Disabling watchdog on nohz_full cores by default\n");
 
 	cpumask_copy(&watchdog_cpumask,
-		     housekeeping_cpumask(HK_TYPE_TIMER));
+		     housekeeping_cpumask(HK_TYPE_NOHZ_FULL));
 
 	if (!watchdog_nmi_probe())
 		nmi_watchdog_available = true;
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1ea50f6be843..3eb283d76d81 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5993,7 +5993,7 @@ void __init workqueue_init_early(void)
 	BUILD_BUG_ON(__alignof__(struct pool_workqueue) < __alignof__(long long));
 
 	BUG_ON(!alloc_cpumask_var(&wq_unbound_cpumask, GFP_KERNEL));
-	cpumask_copy(wq_unbound_cpumask, housekeeping_cpumask(HK_TYPE_WQ));
+	cpumask_copy(wq_unbound_cpumask, housekeeping_cpumask(HK_TYPE_NOHZ_FULL));
 	cpumask_and(wq_unbound_cpumask, wq_unbound_cpumask, housekeeping_cpumask(HK_TYPE_DOMAIN));
 
 	pwq_cache = KMEM_CACHE(pool_workqueue, SLAB_PANIC);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index e319e242dddf..6dddf359b754 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -852,7 +852,7 @@ static ssize_t store_rps_map(struct netdev_rx_queue *queue,
 
 	if (!cpumask_empty(mask)) {
 		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_DOMAIN));
-		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_WQ));
+		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_NOHZ_FULL));
 		if (cpumask_empty(mask)) {
 			free_cpumask_var(mask);
 			return -EINVAL;
-- 
2.25.1

