Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B4E16695F
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgBTU6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:58:25 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44152 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729166AbgBTU4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 15:56:38 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4srb-0007T4-0y; Thu, 20 Feb 2020 21:56:03 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 5E63810408B;
        Thu, 20 Feb 2020 21:56:02 +0100 (CET)
Message-Id: <20200220204617.532391069@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 20 Feb 2020 21:45:19 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [patch V2 02/20] bpf: Update locking comment in hashtab code
References: <20200220204517.863202864@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comment where the bucket lock is acquired says:

  /* bpf_map_update_elem() can be called in_irq() */

which is not really helpful and aside of that it does not explain the
subtle details of the hash bucket locks expecially in the context of BPF
and perf, kprobes and tracing.

Add a comment at the top of the file which explains the protection scopes
and the details how potential deadlocks are prevented.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/bpf/hashtab.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -27,6 +27,26 @@
 	.map_delete_batch =			\
 	generic_map_delete_batch
 
+/*
+ * The bucket lock has two protection scopes:
+ *
+ * 1) Serializing concurrent operations from BPF programs on differrent
+ *    CPUs
+ *
+ * 2) Serializing concurrent operations from BPF programs and sys_bpf()
+ *
+ * BPF programs can execute in any context including perf, kprobes and
+ * tracing. As there are almost no limits where perf, kprobes and tracing
+ * can be invoked from the lock operations need to be protected against
+ * deadlocks. Deadlocks can be caused by recursion and by an invocation in
+ * the lock held section when functions which acquire this lock are invoked
+ * from sys_bpf(). BPF recursion is prevented by incrementing the per CPU
+ * variable bpf_prog_active, which prevents BPF programs attached to perf
+ * events, kprobes and tracing to be invoked before the prior invocation
+ * from one of these contexts completed. sys_bpf() uses the same mechanism
+ * by pinning the task to the current CPU and incrementing the recursion
+ * protection accross the map operation.
+ */
 struct bucket {
 	struct hlist_nulls_head head;
 	raw_spinlock_t lock;
@@ -872,7 +892,6 @@ static int htab_map_update_elem(struct b
 		 */
 	}
 
-	/* bpf_map_update_elem() can be called in_irq() */
 	raw_spin_lock_irqsave(&b->lock, flags);
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
@@ -952,7 +971,6 @@ static int htab_lru_map_update_elem(stru
 		return -ENOMEM;
 	memcpy(l_new->key + round_up(map->key_size, 8), value, map->value_size);
 
-	/* bpf_map_update_elem() can be called in_irq() */
 	raw_spin_lock_irqsave(&b->lock, flags);
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
@@ -1007,7 +1025,6 @@ static int __htab_percpu_map_update_elem
 	b = __select_bucket(htab, hash);
 	head = &b->head;
 
-	/* bpf_map_update_elem() can be called in_irq() */
 	raw_spin_lock_irqsave(&b->lock, flags);
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
@@ -1071,7 +1088,6 @@ static int __htab_lru_percpu_map_update_
 			return -ENOMEM;
 	}
 
-	/* bpf_map_update_elem() can be called in_irq() */
 	raw_spin_lock_irqsave(&b->lock, flags);
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);

