Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D59716A963
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgBXPFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:05:18 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50177 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgBXPDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:03:20 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6FFo-0004s2-S2; Mon, 24 Feb 2020 16:02:40 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 85B9410408E;
        Mon, 24 Feb 2020 16:02:40 +0100 (CET)
Message-Id: <20200224145642.540542802@linutronix.de>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 15:01:32 +0100
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
Subject: [patch V3 01/22] bpf: Tighten the requirements for preallocated hash maps
References: <20200224140131.461979697@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The assumption that only programs attached to perf NMI events can deadlock
on memory allocators is wrong. Assume the following simplified callchain:

 kmalloc() from regular non BPF context
  cache empty
   freelist empty
    lock(zone->lock);
     tracepoint or kprobe
      BPF()
       update_elem()
        lock(bucket)
          kmalloc()
           cache empty
            freelist empty
             lock(zone->lock);  <- DEADLOCK

There are other ways which do not involve locking to create wreckage:

 kmalloc() from regular non BPF context
  local_irq_save();
   ...
    obj = slab_first();
     kprobe()
      BPF()
       update_elem()
        lock(bucket)
         kmalloc()
          local_irq_save();
           ...
            obj = slab_first(); <- Same object as above ...

So preallocation _must_ be enforced for all variants of intrusive
instrumentation.

Unfortunately immediate enforcement would break backwards compatibility, so
for now such programs still are allowed to run, but a one time warning is
emitted in dmesg and the verifier emits a warning in the verifier log as
well so developers are made aware about this and can fix their programs
before the enforcement becomes mandatory.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V3: Still allow run-time allocation for !RT. Emit warnings. Split
    out the RT part as this really should be backported to stable
    kernels.
V2: New patch
---
 kernel/bpf/verifier.c |   39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8143,26 +8143,43 @@ static bool is_tracing_prog_type(enum bp
 	}
 }
 
+static bool is_preallocated_map(struct bpf_map *map)
+{
+	if (!check_map_prealloc(map))
+		return false;
+	if (map->inner_map_meta && !check_map_prealloc(map->inner_map_meta))
+		return false;
+	return true;
+}
+
 static int check_map_prog_compatibility(struct bpf_verifier_env *env,
 					struct bpf_map *map,
 					struct bpf_prog *prog)
 
 {
-	/* Make sure that BPF_PROG_TYPE_PERF_EVENT programs only use
-	 * preallocated hash maps, since doing memory allocation
-	 * in overflow_handler can crash depending on where nmi got
-	 * triggered.
+	/*
+	 * Validate that trace type programs use preallocated hash maps.
+	 *
+	 * For programs attached to PERF events this is mandatory as the
+	 * perf NMI can hit any arbitrary code sequence.
+	 *
+	 * All other trace types using preallocated hash maps are unsafe as
+	 * well because tracepoint or kprobes can be inside locked regions
+	 * of the memory allocator or at a place where a recursion into the
+	 * memory allocator would see inconsistent state.
+	 *
+	 * For now running such programs is allowed for backwards
+	 * compatibility reasons, but warnings are emitted so developers are
+	 * made aware of the unsafety and can fix their programs before this
+	 * is enforced.
 	 */
-	if (prog->type == BPF_PROG_TYPE_PERF_EVENT) {
-		if (!check_map_prealloc(map)) {
+	if (is_tracing_prog_type(prog->type) && !is_preallocated_map(map)) {
+		if (prog->type == BPF_PROG_TYPE_PERF_EVENT) {
 			verbose(env, "perf_event programs can only use preallocated hash map\n");
 			return -EINVAL;
 		}
-		if (map->inner_map_meta &&
-		    !check_map_prealloc(map->inner_map_meta)) {
-			verbose(env, "perf_event programs can only use preallocated inner hash map\n");
-			return -EINVAL;
-		}
+		WARN_ONCE(1, "trace type BPF program uses run-time allocation\n");
+		verbose(env, "trace type programs with run-time allocated hash maps are unsafe. Switch to preallocated hash maps.\n");
 	}
 
 	if ((is_tracing_prog_type(prog->type) ||

