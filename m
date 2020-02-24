Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 127D516A929
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgBXPDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:03:37 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50222 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgBXPDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:03:25 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6FFz-0004za-7t; Mon, 24 Feb 2020 16:02:51 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 0F9B9104099;
        Mon, 24 Feb 2020 16:02:44 +0100 (CET)
Message-Id: <20200224145644.211208533@linutronix.de>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 15:01:48 +0100
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
Subject: [patch V3 17/22] bpf: Use recursion prevention helpers in hashtab code
References: <20200224140131.461979697@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The required protection is that the caller cannot be migrated to a
different CPU as these places take either a hash bucket lock or might
trigger a kprobe inside the memory allocator. Both scenarios can lead to
deadlocks. The deadlock prevention is per CPU by incrementing a per CPU
variable which temporarily blocks the invocation of BPF programs from perf
and kprobes.

Replace the open coded preempt_disable/enable() and this_cpu_inc/dec()
pairs with the new recursion prevention helpers to prepare BPF to work on
PREEMPT_RT enabled kernels. On a non-RT kernel the migrate disable/enable
in the helpers map to preempt_disable/enable(), i.e. no functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V3: Use recursion prevention helpers consistently
---
 kernel/bpf/hashtab.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1333,8 +1333,7 @@ static int
 	}
 
 again:
-	preempt_disable();
-	this_cpu_inc(bpf_prog_active);
+	bpf_disable_instrumentation();
 	rcu_read_lock();
 again_nocopy:
 	dst_key = keys;
@@ -1362,8 +1361,7 @@ static int
 		 */
 		raw_spin_unlock_irqrestore(&b->lock, flags);
 		rcu_read_unlock();
-		this_cpu_dec(bpf_prog_active);
-		preempt_enable();
+		bpf_enable_instrumentation();
 		goto after_loop;
 	}
 
@@ -1374,8 +1372,7 @@ static int
 		 */
 		raw_spin_unlock_irqrestore(&b->lock, flags);
 		rcu_read_unlock();
-		this_cpu_dec(bpf_prog_active);
-		preempt_enable();
+		bpf_enable_instrumentation();
 		kvfree(keys);
 		kvfree(values);
 		goto alloc;
@@ -1445,8 +1442,7 @@ static int
 	}
 
 	rcu_read_unlock();
-	this_cpu_dec(bpf_prog_active);
-	preempt_enable();
+	bpf_enable_instrumentation();
 	if (bucket_cnt && (copy_to_user(ukeys + total * key_size, keys,
 	    key_size * bucket_cnt) ||
 	    copy_to_user(uvalues + total * value_size, values,

