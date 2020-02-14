Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6025015E60E
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394106AbgBNQp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:45:29 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55556 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392974AbgBNQVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:21:33 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2diI-0003OB-VK; Fri, 14 Feb 2020 17:21:11 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id C528C103066;
        Fri, 14 Feb 2020 17:21:06 +0100 (CET)
Message-Id: <20200214161504.431560798@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 14 Feb 2020 14:39:32 +0100
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
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC patch 15/19] bpf: Use migrate_disable() in sys_bpf()
References: <20200214133917.304937432@linutronix.de>
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

Replace the preempt_disable/enable() pairs with migrate_disable/enable()
pairs to prepare BPF to work on PREEMPT_RT enabled kernels. On a non-RT
kernel this maps to preempt_disable/enable(), i.e. no functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/bpf/syscall.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -174,7 +174,7 @@ static int bpf_map_update_value(struct b
 	/* must increment bpf_prog_active to avoid kprobe+bpf triggering from
 	 * inside bpf map update or delete otherwise deadlocks are possible
 	 */
-	preempt_disable();
+	migrate_disable();
 	__this_cpu_inc(bpf_prog_active);
 	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
 	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
@@ -207,7 +207,7 @@ static int bpf_map_update_value(struct b
 		rcu_read_unlock();
 	}
 	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
+	migrate_enable();
 	maybe_wait_bpf_programs(map);
 
 	return err;
@@ -222,7 +222,7 @@ static int bpf_map_copy_value(struct bpf
 	if (bpf_map_is_dev_bound(map))
 		return bpf_map_offload_lookup_elem(map, key, value);
 
-	preempt_disable();
+	migrate_disable();
 	this_cpu_inc(bpf_prog_active);
 	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
 	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
@@ -269,7 +269,7 @@ static int bpf_map_copy_value(struct bpf
 	}
 
 	this_cpu_dec(bpf_prog_active);
-	preempt_enable();
+	migrate_enable();
 	maybe_wait_bpf_programs(map);
 
 	return err;
@@ -1136,13 +1136,13 @@ static int map_delete_elem(union bpf_att
 		goto out;
 	}
 
-	preempt_disable();
+	migrate_disable();
 	__this_cpu_inc(bpf_prog_active);
 	rcu_read_lock();
 	err = map->ops->map_delete_elem(map, key);
 	rcu_read_unlock();
 	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
+	migrate_enable();
 	maybe_wait_bpf_programs(map);
 out:
 	kfree(key);
@@ -1254,13 +1254,13 @@ int generic_map_delete_batch(struct bpf_
 			break;
 		}
 
-		preempt_disable();
+		migrate_disable();
 		__this_cpu_inc(bpf_prog_active);
 		rcu_read_lock();
 		err = map->ops->map_delete_elem(map, key);
 		rcu_read_unlock();
 		__this_cpu_dec(bpf_prog_active);
-		preempt_enable();
+		migrate_enable();
 		maybe_wait_bpf_programs(map);
 		if (err)
 			break;

