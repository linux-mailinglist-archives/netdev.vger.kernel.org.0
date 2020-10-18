Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B896B291E3F
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388214AbgJRTve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729306AbgJRTVQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A237222E7;
        Sun, 18 Oct 2020 19:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048875;
        bh=rEgEmrRM35eoBqfZs7DdD6giuzYoi6c0bGNFCpKWva4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1UGwsFSCVSGQEcJ+eAHmSht0JKOT/q9xLqpDkDJGpOPI9RsUN7lWKKnbbSIQ2x/6
         2sGpCwscgDE5P/rMG5CSiWaLcTYrWJWksJh98I5KJ3mgN2udi8WcCAHDpqbk7feN81
         nI1t6UuxBcn4Q6SuEF+fnDf7Z9Jft3BoqbgZ8a3s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 039/101] bpf: Use raw_spin_trylock() for pcpu_freelist_push/pop in NMI
Date:   Sun, 18 Oct 2020 15:19:24 -0400
Message-Id: <20201018192026.4053674-39-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

[ Upstream commit 39d8f0d1026a990604770a658708f5845f7dbec0 ]

Recent improvements in LOCKDEP highlighted a potential A-A deadlock with
pcpu_freelist in NMI:

./tools/testing/selftests/bpf/test_progs -t stacktrace_build_id_nmi

[   18.984807] ================================
[   18.984807] WARNING: inconsistent lock state
[   18.984808] 5.9.0-rc6-01771-g1466de1330e1 #2967 Not tainted
[   18.984809] --------------------------------
[   18.984809] inconsistent {INITIAL USE} -> {IN-NMI} usage.
[   18.984810] test_progs/1990 [HC2[2]:SC0[0]:HE0:SE1] takes:
[   18.984810] ffffe8ffffc219c0 (&head->lock){....}-{2:2}, at: __pcpu_freelist_pop+0xe3/0x180
[   18.984813] {INITIAL USE} state was registered at:
[   18.984814]   lock_acquire+0x175/0x7c0
[   18.984814]   _raw_spin_lock+0x2c/0x40
[   18.984815]   __pcpu_freelist_pop+0xe3/0x180
[   18.984815]   pcpu_freelist_pop+0x31/0x40
[   18.984816]   htab_map_alloc+0xbbf/0xf40
[   18.984816]   __do_sys_bpf+0x5aa/0x3ed0
[   18.984817]   do_syscall_64+0x2d/0x40
[   18.984818]   entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   18.984818] irq event stamp: 12
[...]
[   18.984822] other info that might help us debug this:
[   18.984823]  Possible unsafe locking scenario:
[   18.984823]
[   18.984824]        CPU0
[   18.984824]        ----
[   18.984824]   lock(&head->lock);
[   18.984826]   <Interrupt>
[   18.984826]     lock(&head->lock);
[   18.984827]
[   18.984828]  *** DEADLOCK ***
[   18.984828]
[   18.984829] 2 locks held by test_progs/1990:
[...]
[   18.984838]  <NMI>
[   18.984838]  dump_stack+0x9a/0xd0
[   18.984839]  lock_acquire+0x5c9/0x7c0
[   18.984839]  ? lock_release+0x6f0/0x6f0
[   18.984840]  ? __pcpu_freelist_pop+0xe3/0x180
[   18.984840]  _raw_spin_lock+0x2c/0x40
[   18.984841]  ? __pcpu_freelist_pop+0xe3/0x180
[   18.984841]  __pcpu_freelist_pop+0xe3/0x180
[   18.984842]  pcpu_freelist_pop+0x17/0x40
[   18.984842]  ? lock_release+0x6f0/0x6f0
[   18.984843]  __bpf_get_stackid+0x534/0xaf0
[   18.984843]  bpf_prog_1fd9e30e1438d3c5_oncpu+0x73/0x350
[   18.984844]  bpf_overflow_handler+0x12f/0x3f0

This is because pcpu_freelist_head.lock is accessed in both NMI and
non-NMI context. Fix this issue by using raw_spin_trylock() in NMI.

Since NMI interrupts non-NMI context, when NMI context tries to lock the
raw_spinlock, non-NMI context of the same CPU may already have locked a
lock and is blocked from unlocking the lock. For a system with N CPUs,
there could be N NMIs at the same time, and they may block N non-NMI
raw_spinlocks. This is tricky for pcpu_freelist_push(), where unlike
_pop(), failing _push() means leaking memory. This issue is more likely to
trigger in non-SMP system.

Fix this issue with an extra list, pcpu_freelist.extralist. The extralist
is primarily used to take _push() when raw_spin_trylock() failed on all
the per CPU lists. It should be empty most of the time. The following
table summarizes the behavior of pcpu_freelist in NMI and non-NMI:

non-NMI pop(): 	use _lock(); check per CPU lists first;
                if all per CPU lists are empty, check extralist;
                if extralist is empty, return NULL.

non-NMI push(): use _lock(); only push to per CPU lists.

NMI pop():    use _trylock(); check per CPU lists first;
              if all per CPU lists are locked or empty, check extralist;
              if extralist is locked or empty, return NULL.

NMI push():   use _trylock(); check per CPU lists first;
              if all per CPU lists are locked; try push to extralist;
              if extralist is also locked, keep trying on per CPU lists.

Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20201005165838.3735218-1-songliubraving@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/percpu_freelist.c | 101 +++++++++++++++++++++++++++++++++--
 kernel/bpf/percpu_freelist.h |   1 +
 2 files changed, 97 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/percpu_freelist.c b/kernel/bpf/percpu_freelist.c
index b367430e611c7..3d897de890612 100644
--- a/kernel/bpf/percpu_freelist.c
+++ b/kernel/bpf/percpu_freelist.c
@@ -17,6 +17,8 @@ int pcpu_freelist_init(struct pcpu_freelist *s)
 		raw_spin_lock_init(&head->lock);
 		head->first = NULL;
 	}
+	raw_spin_lock_init(&s->extralist.lock);
+	s->extralist.first = NULL;
 	return 0;
 }
 
@@ -40,12 +42,50 @@ static inline void ___pcpu_freelist_push(struct pcpu_freelist_head *head,
 	raw_spin_unlock(&head->lock);
 }
 
+static inline bool pcpu_freelist_try_push_extra(struct pcpu_freelist *s,
+						struct pcpu_freelist_node *node)
+{
+	if (!raw_spin_trylock(&s->extralist.lock))
+		return false;
+
+	pcpu_freelist_push_node(&s->extralist, node);
+	raw_spin_unlock(&s->extralist.lock);
+	return true;
+}
+
+static inline void ___pcpu_freelist_push_nmi(struct pcpu_freelist *s,
+					     struct pcpu_freelist_node *node)
+{
+	int cpu, orig_cpu;
+
+	orig_cpu = cpu = raw_smp_processor_id();
+	while (1) {
+		struct pcpu_freelist_head *head;
+
+		head = per_cpu_ptr(s->freelist, cpu);
+		if (raw_spin_trylock(&head->lock)) {
+			pcpu_freelist_push_node(head, node);
+			raw_spin_unlock(&head->lock);
+			return;
+		}
+		cpu = cpumask_next(cpu, cpu_possible_mask);
+		if (cpu >= nr_cpu_ids)
+			cpu = 0;
+
+		/* cannot lock any per cpu lock, try extralist */
+		if (cpu == orig_cpu &&
+		    pcpu_freelist_try_push_extra(s, node))
+			return;
+	}
+}
+
 void __pcpu_freelist_push(struct pcpu_freelist *s,
 			struct pcpu_freelist_node *node)
 {
-	struct pcpu_freelist_head *head = this_cpu_ptr(s->freelist);
-
-	___pcpu_freelist_push(head, node);
+	if (in_nmi())
+		___pcpu_freelist_push_nmi(s, node);
+	else
+		___pcpu_freelist_push(this_cpu_ptr(s->freelist), node);
 }
 
 void pcpu_freelist_push(struct pcpu_freelist *s,
@@ -81,7 +121,7 @@ void pcpu_freelist_populate(struct pcpu_freelist *s, void *buf, u32 elem_size,
 	}
 }
 
-struct pcpu_freelist_node *__pcpu_freelist_pop(struct pcpu_freelist *s)
+static struct pcpu_freelist_node *___pcpu_freelist_pop(struct pcpu_freelist *s)
 {
 	struct pcpu_freelist_head *head;
 	struct pcpu_freelist_node *node;
@@ -102,8 +142,59 @@ struct pcpu_freelist_node *__pcpu_freelist_pop(struct pcpu_freelist *s)
 		if (cpu >= nr_cpu_ids)
 			cpu = 0;
 		if (cpu == orig_cpu)
-			return NULL;
+			break;
+	}
+
+	/* per cpu lists are all empty, try extralist */
+	raw_spin_lock(&s->extralist.lock);
+	node = s->extralist.first;
+	if (node)
+		s->extralist.first = node->next;
+	raw_spin_unlock(&s->extralist.lock);
+	return node;
+}
+
+static struct pcpu_freelist_node *
+___pcpu_freelist_pop_nmi(struct pcpu_freelist *s)
+{
+	struct pcpu_freelist_head *head;
+	struct pcpu_freelist_node *node;
+	int orig_cpu, cpu;
+
+	orig_cpu = cpu = raw_smp_processor_id();
+	while (1) {
+		head = per_cpu_ptr(s->freelist, cpu);
+		if (raw_spin_trylock(&head->lock)) {
+			node = head->first;
+			if (node) {
+				head->first = node->next;
+				raw_spin_unlock(&head->lock);
+				return node;
+			}
+			raw_spin_unlock(&head->lock);
+		}
+		cpu = cpumask_next(cpu, cpu_possible_mask);
+		if (cpu >= nr_cpu_ids)
+			cpu = 0;
+		if (cpu == orig_cpu)
+			break;
 	}
+
+	/* cannot pop from per cpu lists, try extralist */
+	if (!raw_spin_trylock(&s->extralist.lock))
+		return NULL;
+	node = s->extralist.first;
+	if (node)
+		s->extralist.first = node->next;
+	raw_spin_unlock(&s->extralist.lock);
+	return node;
+}
+
+struct pcpu_freelist_node *__pcpu_freelist_pop(struct pcpu_freelist *s)
+{
+	if (in_nmi())
+		return ___pcpu_freelist_pop_nmi(s);
+	return ___pcpu_freelist_pop(s);
 }
 
 struct pcpu_freelist_node *pcpu_freelist_pop(struct pcpu_freelist *s)
diff --git a/kernel/bpf/percpu_freelist.h b/kernel/bpf/percpu_freelist.h
index fbf8a8a289791..3c76553cfe571 100644
--- a/kernel/bpf/percpu_freelist.h
+++ b/kernel/bpf/percpu_freelist.h
@@ -13,6 +13,7 @@ struct pcpu_freelist_head {
 
 struct pcpu_freelist {
 	struct pcpu_freelist_head __percpu *freelist;
+	struct pcpu_freelist_head extralist;
 };
 
 struct pcpu_freelist_node {
-- 
2.25.1

