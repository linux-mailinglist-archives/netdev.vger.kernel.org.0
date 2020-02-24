Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8910D16A93E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgBXPEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:04:11 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50220 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbgBXPDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:03:24 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6FG1-000547-JW; Mon, 24 Feb 2020 16:02:53 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id E769610409D;
        Mon, 24 Feb 2020 16:02:44 +0100 (CET)
Message-Id: <20200224145644.602129531@linutronix.de>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 15:01:52 +0100
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
Subject: [patch V3 21/22] bpf, lpm: Make locking RT friendly
References: <20200224140131.461979697@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LPM trie map cannot be used in contexts like perf, kprobes and tracing
as this map type dynamically allocates memory.

The memory allocation happens with a raw spinlock held which is a truly
spinning lock on a PREEMPT RT enabled kernel which disables preemption and
interrupts.

As RT does not allow memory allocation from such a section for various
reasons, convert the raw spinlock to a regular spinlock.

On a RT enabled kernel these locks are substituted by 'sleeping' spinlocks
which provide the proper protection but keep the code preemptible.

On a non-RT kernel regular spinlocks map to raw spinlocks, i.e. this does
not cause any functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/bpf/lpm_trie.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -34,7 +34,7 @@ struct lpm_trie {
 	size_t				n_entries;
 	size_t				max_prefixlen;
 	size_t				data_size;
-	raw_spinlock_t			lock;
+	spinlock_t			lock;
 };
 
 /* This trie implements a longest prefix match algorithm that can be used to
@@ -315,7 +315,7 @@ static int trie_update_elem(struct bpf_m
 	if (key->prefixlen > trie->max_prefixlen)
 		return -EINVAL;
 
-	raw_spin_lock_irqsave(&trie->lock, irq_flags);
+	spin_lock_irqsave(&trie->lock, irq_flags);
 
 	/* Allocate and fill a new node */
 
@@ -422,7 +422,7 @@ static int trie_update_elem(struct bpf_m
 		kfree(im_node);
 	}
 
-	raw_spin_unlock_irqrestore(&trie->lock, irq_flags);
+	spin_unlock_irqrestore(&trie->lock, irq_flags);
 
 	return ret;
 }
@@ -442,7 +442,7 @@ static int trie_delete_elem(struct bpf_m
 	if (key->prefixlen > trie->max_prefixlen)
 		return -EINVAL;
 
-	raw_spin_lock_irqsave(&trie->lock, irq_flags);
+	spin_lock_irqsave(&trie->lock, irq_flags);
 
 	/* Walk the tree looking for an exact key/length match and keeping
 	 * track of the path we traverse.  We will need to know the node
@@ -518,7 +518,7 @@ static int trie_delete_elem(struct bpf_m
 	kfree_rcu(node, rcu);
 
 out:
-	raw_spin_unlock_irqrestore(&trie->lock, irq_flags);
+	spin_unlock_irqrestore(&trie->lock, irq_flags);
 
 	return ret;
 }
@@ -575,7 +575,7 @@ static struct bpf_map *trie_alloc(union
 	if (ret)
 		goto out_err;
 
-	raw_spin_lock_init(&trie->lock);
+	spin_lock_init(&trie->lock);
 
 	return &trie->map;
 out_err:

