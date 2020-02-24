Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9555516A928
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgBXPDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:03:37 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50219 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbgBXPDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:03:25 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6FFw-00051R-NK; Mon, 24 Feb 2020 16:02:48 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 451AB10409A;
        Mon, 24 Feb 2020 16:02:44 +0100 (CET)
Message-Id: <20200224145644.317843926@linutronix.de>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 15:01:49 +0100
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
Subject: [patch V3 18/22] bpf: Replace open coded recursion prevention in sys_bpf()
References: <20200224140131.461979697@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The required protection is that the caller cannot be migrated to a
different CPU as these functions end up in places which take either a hash
bucket lock or might trigger a kprobe inside the memory allocator. Both
scenarios can lead to deadlocks. The deadlock prevention is per CPU by
incrementing a per CPU variable which temporarily blocks the invocation of
BPF programs from perf and kprobes.

Replace the open coded preempt_[dis|en]able and __this_cpu_[inc|dec] pairs
with the new helper functions. These functions are already prepared to make
BPF work on PREEMPT_RT enabled kernels. No functional change for !RT
kernels.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V3: Restrict it to sys_bpf(). Hashtab code is already handled.
---
 kernel/bpf/syscall.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -171,11 +171,7 @@ static int bpf_map_update_value(struct b
 						    flags);
 	}
 
-	/* must increment bpf_prog_active to avoid kprobe+bpf triggering from
-	 * inside bpf map update or delete otherwise deadlocks are possible
-	 */
-	preempt_disable();
-	__this_cpu_inc(bpf_prog_active);
+	bpf_disable_instrumentation();
 	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
 	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
 		err = bpf_percpu_hash_update(map, key, value, flags);
@@ -206,8 +202,7 @@ static int bpf_map_update_value(struct b
 		err = map->ops->map_update_elem(map, key, value, flags);
 		rcu_read_unlock();
 	}
-	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
+	bpf_enable_instrumentation();
 	maybe_wait_bpf_programs(map);
 
 	return err;
@@ -222,8 +217,7 @@ static int bpf_map_copy_value(struct bpf
 	if (bpf_map_is_dev_bound(map))
 		return bpf_map_offload_lookup_elem(map, key, value);
 
-	preempt_disable();
-	this_cpu_inc(bpf_prog_active);
+	bpf_disable_instrumentation();
 	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
 	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
 		err = bpf_percpu_hash_copy(map, key, value);
@@ -268,8 +262,7 @@ static int bpf_map_copy_value(struct bpf
 		rcu_read_unlock();
 	}
 
-	this_cpu_dec(bpf_prog_active);
-	preempt_enable();
+	bpf_enable_instrumentation();
 	maybe_wait_bpf_programs(map);
 
 	return err;
@@ -1136,13 +1129,11 @@ static int map_delete_elem(union bpf_att
 		goto out;
 	}
 
-	preempt_disable();
-	__this_cpu_inc(bpf_prog_active);
+	bpf_disable_instrumentation();
 	rcu_read_lock();
 	err = map->ops->map_delete_elem(map, key);
 	rcu_read_unlock();
-	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
+	bpf_enable_instrumentation();
 	maybe_wait_bpf_programs(map);
 out:
 	kfree(key);
@@ -1254,13 +1245,11 @@ int generic_map_delete_batch(struct bpf_
 			break;
 		}
 
-		preempt_disable();
-		__this_cpu_inc(bpf_prog_active);
+		bpf_disable_instrumentation();
 		rcu_read_lock();
 		err = map->ops->map_delete_elem(map, key);
 		rcu_read_unlock();
-		__this_cpu_dec(bpf_prog_active);
-		preempt_enable();
+		bpf_enable_instrumentation();
 		maybe_wait_bpf_programs(map);
 		if (err)
 			break;

