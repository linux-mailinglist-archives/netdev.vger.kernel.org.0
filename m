Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF6BA18C94B
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 09:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgCTI4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 04:56:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:43382 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgCTI4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 04:56:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 21A8FAEE2;
        Fri, 20 Mar 2020 08:56:44 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     tglx@linutronix.de
Cc:     arnd@arndb.de, balbi@kernel.org, bhelgaas@google.com,
        bigeasy@linutronix.de, dave@stgolabs.net, davem@davemloft.net,
        gregkh@linuxfoundation.org, joel@joelfernandes.org,
        kurt.schwemmer@microsemi.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, logang@deltatee.com,
        mingo@kernel.org, mpe@ellerman.id.au, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 18/15] kvm: Replace vcpu->swait with rcuwait
Date:   Fri, 20 Mar 2020 01:55:26 -0700
Message-Id: <20200320085527.23861-3-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200320085527.23861-1-dave@stgolabs.net>
References: <20200318204302.693307984@linutronix.de>
 <20200320085527.23861-1-dave@stgolabs.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The use of any sort of waitqueue (simple or regular) for
wait/waking vcpus has always been an overkill and semantically
wrong. Because this is per-vcpu (which is blocked) there is
only ever a single waiting vcpu, thus no need for any sort of
queue.

As such, make use of the rcuwait primitive, with the following
considerations:

  - rcuwait already provides the proper barriers that serialize
  concurrent waiter and waker.

  - Task wakeup is done in rcu read critical region, with a
  stable task pointer.

  - Because there is no concurrency among waiters, we need
  not worry about rcuwait_wait_event() calls corrupting
  the wait->task. As a consequence, this saves the locking
  done in swait when adding to the queue.

The x86-tscdeadline_latency test mentioned in 8577370fb0cb
("KVM: Use simple waitqueue for vcpu->wq") shows that, on avg,
latency is reduced by around 15% with this change.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---

Only compiled and tested on x86.

 arch/powerpc/include/asm/kvm_host.h |  2 +-
 arch/powerpc/kvm/book3s_hv.c        | 10 ++++------
 arch/x86/kvm/lapic.c                |  2 +-
 include/linux/kvm_host.h            | 10 +++++-----
 virt/kvm/arm/arch_timer.c           |  2 +-
 virt/kvm/arm/arm.c                  |  9 +++++----
 virt/kvm/async_pf.c                 |  3 +--
 virt/kvm/kvm_main.c                 | 33 +++++++++++++--------------------
 8 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 6e8b8ffd06ad..e2b4a1e3fb7d 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -752,7 +752,7 @@ struct kvm_vcpu_arch {
 	u8 irq_pending; /* Used by XIVE to signal pending guest irqs */
 	u32 last_inst;
 
-	struct swait_queue_head *wqp;
+	struct rcuwait *waitp;
 	struct kvmppc_vcore *vcore;
 	int ret;
 	int trap;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2cefd071b848..c7cbc4bd06e9 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -231,13 +231,11 @@ static bool kvmppc_ipi_thread(int cpu)
 static void kvmppc_fast_vcpu_kick_hv(struct kvm_vcpu *vcpu)
 {
 	int cpu;
-	struct swait_queue_head *wqp;
+	struct rcuwait *wait;
 
-	wqp = kvm_arch_vcpu_wq(vcpu);
-	if (swq_has_sleeper(wqp)) {
-		swake_up_one(wqp);
+	wait = kvm_arch_vcpu_get_wait(vcpu);
+	if (rcuwait_wake_up(wait))
 		++vcpu->stat.halt_wakeup;
-	}
 
 	cpu = READ_ONCE(vcpu->arch.thread_cpu);
 	if (cpu >= 0 && kvmppc_ipi_thread(cpu))
@@ -4274,7 +4272,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	}
 	user_vrsave = mfspr(SPRN_VRSAVE);
 
-	vcpu->arch.wqp = &vcpu->arch.vcore->wq;
+	vcpu->arch.waitp = &vcpu->arch.vcore->wait;
 	vcpu->arch.pgdir = kvm->mm->pgd;
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e3099c642fec..a4420c26dfbc 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1815,7 +1815,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 	/* If the preempt notifier has already run, it also called apic_timer_expired */
 	if (!apic->lapic_timer.hv_timer_in_use)
 		goto out;
-	WARN_ON(swait_active(&vcpu->wq));
+	WARN_ON(rcu_dereference(vcpu->wait.task));
 	cancel_hv_timer(apic);
 	apic_timer_expired(apic);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bcb9b2ac0791..b5694429aede 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -23,7 +23,7 @@
 #include <linux/irqflags.h>
 #include <linux/context_tracking.h>
 #include <linux/irqbypass.h>
-#include <linux/swait.h>
+#include <linux/rcuwait.h>
 #include <linux/refcount.h>
 #include <linux/nospec.h>
 #include <asm/signal.h>
@@ -277,7 +277,7 @@ struct kvm_vcpu {
 	struct mutex mutex;
 	struct kvm_run *run;
 
-	struct swait_queue_head wq;
+	struct rcuwait wait;
 	struct pid __rcu *pid;
 	int sigset_active;
 	sigset_t sigset;
@@ -952,12 +952,12 @@ static inline bool kvm_arch_has_assigned_device(struct kvm *kvm)
 }
 #endif
 
-static inline struct swait_queue_head *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
+static inline struct rcuwait *kvm_arch_vcpu_get_wait(struct kvm_vcpu *vcpu)
 {
 #ifdef __KVM_HAVE_ARCH_WQP
-	return vcpu->arch.wqp;
+	return vcpu->arch.wait;
 #else
-	return &vcpu->wq;
+	return &vcpu->wait;
 #endif
 }
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 0d9438e9de2a..4be71cb58691 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -593,7 +593,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
-	if (swait_active(kvm_arch_vcpu_wq(vcpu)))
+	if (rcu_dereference(kvm_arch_vpu_get_wait(vcpu)) != NULL)
 		kvm_timer_blocking(vcpu);
 
 	/*
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index eda7b624eab8..4a704866e9b6 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -579,16 +579,17 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		vcpu->arch.pause = false;
-		swake_up_one(kvm_arch_vcpu_wq(vcpu));
+		rcuwait_wake_up(kvm_arch_vcpu_get_wait(vcpu));
 	}
 }
 
 static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 {
-	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
+	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
-	swait_event_interruptible_exclusive(*wq, ((!vcpu->arch.power_off) &&
-				       (!vcpu->arch.pause)));
+	rcuwait_wait_event(*wait,
+			   (!vcpu->arch.power_off) && (!vcpu->arch.pause),
+			   TASK_INTERRUPTIBLE);
 
 	if (vcpu->arch.power_off || vcpu->arch.pause) {
 		/* Awaken to handle a signal, request we sleep again later. */
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 15e5b037f92d..10b533f641a6 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -80,8 +80,7 @@ static void async_pf_execute(struct work_struct *work)
 
 	trace_kvm_async_pf_completed(addr, cr2_or_gpa);
 
-	if (swq_has_sleeper(&vcpu->wq))
-		swake_up_one(&vcpu->wq);
+	rcuwait_wake_up(&vcpu->wait);
 
 	mmput(mm);
 	kvm_put_kvm(vcpu->kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70f03ce0e5c1..6b49dcb321e2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -343,7 +343,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
 	vcpu->pid = NULL;
-	init_swait_queue_head(&vcpu->wq);
+	rcuwait_init(&vcpu->wait);
 	kvm_async_pf_vcpu_init(vcpu);
 
 	vcpu->pre_pcpu = -1;
@@ -2465,9 +2465,8 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
 	ktime_t start, cur;
-	DECLARE_SWAITQUEUE(wait);
-	bool waited = false;
 	u64 block_ns;
+	int block_check = -EINTR;
 
 	kvm_arch_vcpu_blocking(vcpu);
 
@@ -2487,21 +2486,14 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 					++vcpu->stat.halt_poll_invalid;
 				goto out;
 			}
+
 			cur = ktime_get();
 		} while (single_task_running() && ktime_before(cur, stop));
 	}
 
-	for (;;) {
-		prepare_to_swait_exclusive(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
-
-		if (kvm_vcpu_check_block(vcpu) < 0)
-			break;
-
-		waited = true;
-		schedule();
-	}
-
-	finish_swait(&vcpu->wq, &wait);
+	rcuwait_wait_event(&vcpu->wait,
+			   (block_check = kvm_vcpu_check_block(vcpu)) < 0,
+			   TASK_INTERRUPTIBLE);
 	cur = ktime_get();
 out:
 	kvm_arch_vcpu_unblocking(vcpu);
@@ -2525,18 +2517,18 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
+	trace_kvm_vcpu_wakeup(block_ns, block_check < 0 ? false : true,
+			      vcpu_valid_wakeup(vcpu));
 	kvm_arch_vcpu_block_finish(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_block);
 
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 {
-	struct swait_queue_head *wqp;
+	struct rcuwait *wait;
 
-	wqp = kvm_arch_vcpu_wq(vcpu);
-	if (swq_has_sleeper(wqp)) {
-		swake_up_one(wqp);
+	wait = kvm_arch_vcpu_get_wait(vcpu);
+	if (rcuwait_wake_up(wait)) {
 		WRITE_ONCE(vcpu->ready, true);
 		++vcpu->stat.halt_wakeup;
 		return true;
@@ -2678,7 +2670,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			if (vcpu == me)
 				continue;
-			if (swait_active(&vcpu->wq) && !vcpu_dy_runnable(vcpu))
+			if (rcu_dereference(vcpu->wait.task) &&
+			    !vcpu_dy_runnable(vcpu))
 				continue;
 			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
 				!kvm_arch_vcpu_in_kernel(vcpu))
-- 
2.16.4

