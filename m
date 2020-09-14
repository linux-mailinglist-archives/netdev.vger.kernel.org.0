Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4259269935
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 00:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgINWro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 18:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgINWrm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 18:47:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77D6D20732;
        Mon, 14 Sep 2020 22:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600123661;
        bh=cIop9C6BjBgivQD3cpfsI52tOmHiKoe8BHAhWW82ptY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UJaFlSVe6ta1AnPjXQprQvZR02HgWMtsFhbgD6I8bpOsYt1DUW0mNa6T5w1IdHWTE
         hzfQTCk+3dyjRzitAQjDTdrgU1WMw9tE8uRGt3CfgG350n6KtK6UGBlqDLDvh7mO4g
         2BQim3HX0X1CWYwxoPNxzsaMNRiNnlN0mu4Xdv4U=
Date:   Mon, 14 Sep 2020 15:47:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     nikolay@cumulusnetworks.com, davem@davemloft.net,
        netdev@vger.kernel.org, paulmck@kernel.org, josh@joshtriplett.org,
        peterz@infradead.org, christian.brauner@ubuntu.com,
        rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, roopa@nvidia.com
Subject: Re: [PATCH net-next] rcu: prevent RCU_LOCKDEP_WARN() from
 swallowing the condition
Message-ID: <20200914154738.3f4b980a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914202122.GC2579423@google.com>
References: <20200908090049.7e528e7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200908173624.160024-1-kuba@kernel.org>
        <5ABC15D5-3709-4CA4-A747-6A7812BB12DD@cumulusnetworks.com>
        <20200908172751.4da35d60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200914202122.GC2579423@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 16:21:22 -0400 Joel Fernandes wrote:
> On Tue, Sep 08, 2020 at 05:27:51PM -0700, Jakub Kicinski wrote:
> > On Tue, 08 Sep 2020 21:15:56 +0300 nikolay@cumulusnetworks.com wrote:  
> > > Ah, you want to solve it for all. :) 
> > > Looks and sounds good to me, 
> > > Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>  
> > 
> > Actually, I give up, lockdep_is_held() is not defined without
> > CONFIG_LOCKDEP, let's just go with your patch..  
> 
> Care to send a patch just for the RCU macro then? Not sure what Dave is
> applying but if the net-next tree is not taking the RCU macro change, then
> send another one with my tag:

Seems like quite a few places depend on the macro disappearing its
argument. I was concerned that it's going to be had to pick out whether
!LOCKDEP builds should return true or false from LOCKDEP helpers, but
perhaps relying on the linker errors even more is not such poor taste?

Does the patch below look acceptable to you?

--->8------------

rcu: prevent RCU_LOCKDEP_WARN() from swallowing the condition

We run into a unused variable warning in bridge code when
variable is only used inside the condition of
rcu_dereference_protected().

 #define mlock_dereference(X, br) \
	rcu_dereference_protected(X, lockdep_is_held(&br->multicast_lock))

Since on builds with CONFIG_PROVE_RCU=n rcu_dereference_protected()
compiles to nothing the compiler doesn't see the variable use.

Prevent the warning by adding the condition as dead code.
We need to un-hide the declaration of lockdep_tasklist_lock_is_held(),
lockdep_sock_is_held(), RCU lock maps and remove some declarations
in net/sched header, because they have a wrong type.

Add forward declarations of lockdep_is_held(), lock_is_held() which
will cause a linker errors if actually used with !LOCKDEP.
At least RCU expects some locks _not_ to be held so it's hard to
pick true/false for a dummy implementation.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/lockdep.h        |  6 ++++++
 include/linux/rcupdate.h       | 11 ++++++-----
 include/linux/rcupdate_trace.h |  4 ++--
 include/linux/sched/task.h     |  2 --
 include/net/sch_generic.h      | 12 ------------
 include/net/sock.h             |  2 --
 6 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 6a584b3e5c74..c4b6225ee320 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -371,6 +371,12 @@ static inline void lockdep_unregister_key(struct lock_class_key *key)
 
 #define lockdep_depth(tsk)	(0)
 
+/*
+ * Dummy forward declarations, allow users to write less ifdef-y code
+ * and depend on dead code elimination.
+ */
+int lock_is_held(const void *);
+int lockdep_is_held(const void *);
 #define lockdep_is_held_type(l, r)		(1)
 
 #define lockdep_assert_held(l)			do { (void)(l); } while (0)
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d15d46db61f7..50d45781fa99 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -234,6 +234,11 @@ bool rcu_lockdep_current_cpu_online(void);
 static inline bool rcu_lockdep_current_cpu_online(void) { return true; }
 #endif /* #else #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
 
+extern struct lockdep_map rcu_lock_map;
+extern struct lockdep_map rcu_bh_lock_map;
+extern struct lockdep_map rcu_sched_lock_map;
+extern struct lockdep_map rcu_callback_map;
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 static inline void rcu_lock_acquire(struct lockdep_map *map)
@@ -246,10 +251,6 @@ static inline void rcu_lock_release(struct lockdep_map *map)
 	lock_release(map, _THIS_IP_);
 }
 
-extern struct lockdep_map rcu_lock_map;
-extern struct lockdep_map rcu_bh_lock_map;
-extern struct lockdep_map rcu_sched_lock_map;
-extern struct lockdep_map rcu_callback_map;
 int debug_lockdep_rcu_enabled(void);
 int rcu_read_lock_held(void);
 int rcu_read_lock_bh_held(void);
@@ -320,7 +321,7 @@ static inline void rcu_preempt_sleep_check(void) { }
 
 #else /* #ifdef CONFIG_PROVE_RCU */
 
-#define RCU_LOCKDEP_WARN(c, s) do { } while (0)
+#define RCU_LOCKDEP_WARN(c, s) do { } while (0 && (c))
 #define rcu_sleep_check() do { } while (0)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
diff --git a/include/linux/rcupdate_trace.h b/include/linux/rcupdate_trace.h
index aaaac8ac927c..25cdef506cae 100644
--- a/include/linux/rcupdate_trace.h
+++ b/include/linux/rcupdate_trace.h
@@ -11,10 +11,10 @@
 #include <linux/sched.h>
 #include <linux/rcupdate.h>
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-
 extern struct lockdep_map rcu_trace_lock_map;
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
 static inline int rcu_read_lock_trace_held(void)
 {
 	return lock_is_held(&rcu_trace_lock_map);
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index a98965007eef..9f943c391df9 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -47,9 +47,7 @@ extern spinlock_t mmlist_lock;
 extern union thread_union init_thread_union;
 extern struct task_struct init_task;
 
-#ifdef CONFIG_PROVE_RCU
 extern int lockdep_tasklist_lock_is_held(void);
-#endif /* #ifdef CONFIG_PROVE_RCU */
 
 extern asmlinkage void schedule_tail(struct task_struct *prev);
 extern void init_idle(struct task_struct *idle, int cpu);
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d60e7c39d60c..1aaa9e3d2e9c 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -432,7 +432,6 @@ struct tcf_block {
 	struct mutex proto_destroy_lock; /* Lock for proto_destroy hashtable. */
 };
 
-#ifdef CONFIG_PROVE_LOCKING
 static inline bool lockdep_tcf_chain_is_locked(struct tcf_chain *chain)
 {
 	return lockdep_is_held(&chain->filter_chain_lock);
@@ -442,17 +441,6 @@ static inline bool lockdep_tcf_proto_is_locked(struct tcf_proto *tp)
 {
 	return lockdep_is_held(&tp->lock);
 }
-#else
-static inline bool lockdep_tcf_chain_is_locked(struct tcf_block *chain)
-{
-	return true;
-}
-
-static inline bool lockdep_tcf_proto_is_locked(struct tcf_proto *tp)
-{
-	return true;
-}
-#endif /* #ifdef CONFIG_PROVE_LOCKING */
 
 #define tcf_chain_dereference(p, chain)					\
 	rcu_dereference_protected(p, lockdep_tcf_chain_is_locked(chain))
diff --git a/include/net/sock.h b/include/net/sock.h
index eaa5cac5e836..1c67b1297a72 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1566,13 +1566,11 @@ do {									\
 	lockdep_init_map(&(sk)->sk_lock.dep_map, (name), (key), 0);	\
 } while (0)
 
-#ifdef CONFIG_LOCKDEP
 static inline bool lockdep_sock_is_held(const struct sock *sk)
 {
 	return lockdep_is_held(&sk->sk_lock) ||
 	       lockdep_is_held(&sk->sk_lock.slock);
 }
-#endif
 
 void lock_sock_nested(struct sock *sk, int subclass);
 
-- 
2.24.1

