Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E9616126D
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 13:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgBQM7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 07:59:41 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59593 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728540AbgBQM7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 07:59:41 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j3fzV-0003bS-1A; Mon, 17 Feb 2020 13:59:13 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 93A031039FC; Mon, 17 Feb 2020 13:59:12 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bigeasy@linutronix.de, peterz@infradead.org, williams@redhat.com,
        rostedt@goodmis.org, juri.lelli@redhat.com, mingo@kernel.org
Subject: [PATCH] bpf: Enforce map preallocation for all instrumentation programs
In-Reply-To: <87pneht3re.fsf@nanos.tec.linutronix.de>
References: <87pneht3re.fsf@nanos.tec.linutronix.de>
Date:   Mon, 17 Feb 2020 13:59:12 +0100
Message-ID: <875zg5pdy7.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
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

There are also other ways to create wreckage:

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

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/bpf/verifier.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8144,19 +8144,23 @@ static int check_map_prog_compatibility(
 					struct bpf_prog *prog)
 
 {
-	/* Make sure that BPF_PROG_TYPE_PERF_EVENT programs only use
-	 * preallocated hash maps, since doing memory allocation
-	 * in overflow_handler can crash depending on where nmi got
-	 * triggered.
+	/*
+	 * Make sure that trace type programs use preallocated hash maps.
+	 * Perf programs obviously can't do memory allocation in NMI
+	 * context and all other types can deadlock on a memory allocator
+	 * lock when a tracepoint/kprobe triggers a BPF program inside a
+	 * lock held region or create inconsistent state when the probe is
+	 * within an interrupts disabled critical region in the memory
+	 * allocator.
 	 */
-	if (prog->type == BPF_PROG_TYPE_PERF_EVENT) {
+	if ((is_tracing_prog_type(prog->type)) {
 		if (!check_map_prealloc(map)) {
-			verbose(env, "perf_event programs can only use preallocated hash map\n");
+			verbose(env, "tracing programs can only use preallocated hash map\n");
 			return -EINVAL;
 		}
 		if (map->inner_map_meta &&
 		    !check_map_prealloc(map->inner_map_meta)) {
-			verbose(env, "perf_event programs can only use preallocated inner hash map\n");
+			verbose(env, "tracing programs can only use preallocated inner hash map\n");
 			return -EINVAL;
 		}
 	}
