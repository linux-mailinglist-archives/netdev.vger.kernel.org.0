Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B11B4166930
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgBTU5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:57:04 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44168 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729217AbgBTU4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 15:56:42 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4srh-0007aB-OP; Thu, 20 Feb 2020 21:56:09 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 38DD7104092;
        Thu, 20 Feb 2020 21:56:05 +0100 (CET)
Message-Id: <20200220204618.703606294@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 20 Feb 2020 21:45:31 +0100
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
Subject: [patch V2 14/20] bpf: Use migrate_disable() in hashtab code
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

The required protection is that the caller cannot be migrated to a
different CPU as these places take either a hash bucket lock or might
trigger a kprobe inside the memory allocator. Both scenarios can lead to
deadlocks. The deadlock prevention is per CPU by incrementing a per CPU
variable which temporarily blocks the invocation of BPF programs from perf
and kprobes.

Replace the preempt_disable/enable() pairs with migrate_disable/enable()
pairs to prepare BPF to work on PREEMPT_RT enabled kernels. On a non-RT
kernel this maps to preempt_disable/enable(), i.e. no functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/bpf/hashtab.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1319,7 +1319,7 @@ static int
 	}
 
 again:
-	preempt_disable();
+	migrate_disable();
 	this_cpu_inc(bpf_prog_active);
 	rcu_read_lock();
 again_nocopy:
@@ -1339,7 +1339,7 @@ static int
 		raw_spin_unlock_irqrestore(&b->lock, flags);
 		rcu_read_unlock();
 		this_cpu_dec(bpf_prog_active);
-		preempt_enable();
+		migrate_enable();
 		goto after_loop;
 	}
 
@@ -1348,7 +1348,7 @@ static int
 		raw_spin_unlock_irqrestore(&b->lock, flags);
 		rcu_read_unlock();
 		this_cpu_dec(bpf_prog_active);
-		preempt_enable();
+		migrate_enable();
 		kvfree(keys);
 		kvfree(values);
 		goto alloc;
@@ -1398,7 +1398,7 @@ static int
 
 	rcu_read_unlock();
 	this_cpu_dec(bpf_prog_active);
-	preempt_enable();
+	migrate_enable();
 	if (bucket_cnt && (copy_to_user(ukeys + total * key_size, keys,
 	    key_size * bucket_cnt) ||
 	    copy_to_user(uvalues + total * value_size, values,

