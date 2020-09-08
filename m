Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98AC261789
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbgIHRhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731792AbgIHRgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 13:36:38 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74EA020738;
        Tue,  8 Sep 2020 17:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599586597;
        bh=humf0A3eNdO8QjtSSneT0F+BBfk0pmqd3HPslVbaHBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DciE04eFKvHvjJ7XF6N0n3Si+qtHP9qGXwdngsUmp+sAPCiJpzZ0Lnf1LlQXuixLU
         emhBnuqX8+n90KJXCys2P5uVNRbfcN4s/r3deI31XhIjzLFcN65eCf2g5Kd1KJfo3b
         lRUvkTrPdssWJQMoaqD/rHGw2DbZC5peMFgsd3kc=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, paulmck@kernel.org, joel@joelfernandes.org,
        josh@joshtriplett.org, peterz@infradead.org,
        christian.brauner@ubuntu.com, rcu@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikolay@cumulusnetworks.com,
        sfr@canb.auug.org.au, roopa@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] rcu: prevent RCU_LOCKDEP_WARN() from swallowing the condition
Date:   Tue,  8 Sep 2020 10:36:24 -0700
Message-Id: <20200908173624.160024-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908090049.7e528e7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200908090049.7e528e7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We run into a unused variable warning in bridge code when
variable is only used inside the condition of
rcu_dereference_protected().

 #define mlock_dereference(X, br) \
	rcu_dereference_protected(X, lockdep_is_held(&br->multicast_lock))

Since on builds with CONFIG_PROVE_RCU=n rcu_dereference_protected()
compiles to nothing the compiler doesn't see the variable use.

Prevent the warning by adding the condition as dead code.
We need to un-hide the declaration of lockdep_tasklist_lock_is_held()
and fix a bug the crept into a net/sched header.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/rcupdate.h   | 2 +-
 include/linux/sched/task.h | 2 --
 include/net/sch_generic.h  | 2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d15d46db61f7..cf3d3ba3f3e4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -320,7 +320,7 @@ static inline void rcu_preempt_sleep_check(void) { }
 
 #else /* #ifdef CONFIG_PROVE_RCU */
 
-#define RCU_LOCKDEP_WARN(c, s) do { } while (0)
+#define RCU_LOCKDEP_WARN(c, s) do { } while (0 && (c))
 #define rcu_sleep_check() do { } while (0)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
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
index d60e7c39d60c..eb68cc6e4e79 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -443,7 +443,7 @@ static inline bool lockdep_tcf_proto_is_locked(struct tcf_proto *tp)
 	return lockdep_is_held(&tp->lock);
 }
 #else
-static inline bool lockdep_tcf_chain_is_locked(struct tcf_block *chain)
+static inline bool lockdep_tcf_chain_is_locked(struct tcf_chain *chain)
 {
 	return true;
 }
-- 
2.24.1

