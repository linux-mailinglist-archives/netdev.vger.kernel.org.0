Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA9116691B
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbgBTU4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:56:45 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44169 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729258AbgBTU4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 15:56:44 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4srn-0007bV-LD; Thu, 20 Feb 2020 21:56:15 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id AD1FC10408C;
        Thu, 20 Feb 2020 21:56:05 +0100 (CET)
Message-Id: <20200220204618.913228118@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 20 Feb 2020 21:45:33 +0100
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
Subject: [patch V2 16/20] bpf: Replace open coded recursion prevention
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
different CPU as these functions end up in places which take either a hash
bucket lock or might trigger a kprobe inside the memory allocator. Both
scenarios can lead to deadlocks. The deadlock prevention is per CPU by
incrementing a per CPU variable which temporarily blocks the invocation of
BPF programs from perf and kprobes.

Replace the open coded preempt_[dis|en]able and __this_cpu_[inc|dec] pairs
with the new helper functions. These functions are already prepared to
make BPF work on PREEMPT_RT enabled kernels.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V2: New patch
---
 kernel/bpf/hashtab.c |   12 ++++--------
 kernel/bpf/syscall.c |   27 ++++++++-------------------
 2 files changed, 12 insertions(+), 27 deletions(-)

--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1319,8 +1319,7 @@ static int
 	}
 
 again:
-	migrate_disable();
-	this_cpu_inc(bpf_prog_active);
+	bpf_disable_instrumentation();
 	rcu_read_lock();
 again_nocopy:
 	dst_key = keys;
@@ -1338,8 +1337,7 @@ static int
 			ret = -ENOSPC;
 		raw_spin_unlock_irqrestore(&b->lock, flags);
 		rcu_read_unlock();
-		this_cpu_dec(bpf_prog_active);
-		migrate_enable();
+		bpf_enable_instrumentation();
 		goto after_loop;
 	}
 
@@ -1347,8 +1345,7 @@ static int
 		bucket_size = bucket_cnt;
 		raw_spin_unlock_irqrestore(&b->lock, flags);
 		rcu_read_unlock();
-		this_cpu_dec(bpf_prog_active);
-		migrate_enable();
+		bpf_enable_instrumentation();
 		kvfree(keys);
 		kvfree(values);
 		goto alloc;
@@ -1397,8 +1394,7 @@ static int
 	}
 
 	rcu_read_unlock();
-	this_cpu_dec(bpf_prog_active);
-	migrate_enable();
+	bpf_enable_instrumentation();
 	if (bucket_cnt && (copy_to_user(ukeys + total * key_size, keys,
 	    key_size * bucket_cnt) ||
 	    copy_to_user(uvalues + total * value_size, values,
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

