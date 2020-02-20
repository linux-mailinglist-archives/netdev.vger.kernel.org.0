Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7508016695D
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbgBTU6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:58:24 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44145 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbgBTU4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 15:56:38 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4sra-0007T2-OQ; Thu, 20 Feb 2020 21:56:02 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 24B2110408A;
        Thu, 20 Feb 2020 21:56:02 +0100 (CET)
Message-Id: <20200220204617.440152945@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 20 Feb 2020 21:45:18 +0100
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
Subject: [patch V2 01/20] bpf: Enforce preallocation for all instrumentation programs
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
    obj = percpu_slab_first();
     kprobe()
      BPF()
       update_elem()
        lock(bucket)
         kmalloc()
          local_irq_save();
           ...
            obj = percpu_slab_first(); <- Same object as above ...

So preallocation _must_ be enforced for all variants of intrusive
instrumentation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V2: New patch
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
+	 * Make sure that trace type programs only use preallocated hash
+	 * maps. Perf programs obviously can't do memory allocation in NMI
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

