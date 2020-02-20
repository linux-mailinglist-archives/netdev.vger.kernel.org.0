Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE32C166945
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgBTU4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:56:39 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44150 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgBTU4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 15:56:38 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4srb-0007TG-QM; Thu, 20 Feb 2020 21:56:03 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 5458C10408B;
        Thu, 20 Feb 2020 21:56:03 +0100 (CET)
Message-Id: <20200220204617.935490356@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 20 Feb 2020 21:45:23 +0100
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
Subject: [patch V2 06/20] bpf: Dont iterate over possible CPUs with interrupts disabled
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

pcpu_freelist_populate() is disabling interrupts and then iterates over the
possible CPUs. The reason why this disables interrupts is to silence
lockdep because the invoked ___pcpu_freelist_push() takes spin locks.

Neither the interrupt disabling nor the locking are required in this
function because it's called during initialization and the resulting map is
not yet visible to anything.

Split out the actual push assignement into an inline, call it from the loop
and remove the interrupt disable.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/bpf/percpu_freelist.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/kernel/bpf/percpu_freelist.c
+++ b/kernel/bpf/percpu_freelist.c
@@ -25,12 +25,18 @@ void pcpu_freelist_destroy(struct pcpu_f
 	free_percpu(s->freelist);
 }
 
+static inline void pcpu_freelist_push_node(struct pcpu_freelist_head *head,
+					   struct pcpu_freelist_node *node)
+{
+	node->next = head->first;
+	head->first = node;
+}
+
 static inline void ___pcpu_freelist_push(struct pcpu_freelist_head *head,
 					 struct pcpu_freelist_node *node)
 {
 	raw_spin_lock(&head->lock);
-	node->next = head->first;
-	head->first = node;
+	pcpu_freelist_push_node(head, node);
 	raw_spin_unlock(&head->lock);
 }
 
@@ -56,21 +62,16 @@ void pcpu_freelist_populate(struct pcpu_
 			    u32 nr_elems)
 {
 	struct pcpu_freelist_head *head;
-	unsigned long flags;
 	int i, cpu, pcpu_entries;
 
 	pcpu_entries = nr_elems / num_possible_cpus() + 1;
 	i = 0;
 
-	/* disable irq to workaround lockdep false positive
-	 * in bpf usage pcpu_freelist_populate() will never race
-	 * with pcpu_freelist_push()
-	 */
-	local_irq_save(flags);
 	for_each_possible_cpu(cpu) {
 again:
 		head = per_cpu_ptr(s->freelist, cpu);
-		___pcpu_freelist_push(head, buf);
+		/* No locking required as this is not visible yet. */
+		pcpu_freelist_push_node(head, buf);
 		i++;
 		buf += elem_size;
 		if (i == nr_elems)
@@ -78,7 +79,6 @@ void pcpu_freelist_populate(struct pcpu_
 		if (i % pcpu_entries)
 			goto again;
 	}
-	local_irq_restore(flags);
 }
 
 struct pcpu_freelist_node *__pcpu_freelist_pop(struct pcpu_freelist *s)

