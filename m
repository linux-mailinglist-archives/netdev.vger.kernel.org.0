Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F2716A93D
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgBXPEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:04:09 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50215 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbgBXPDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:03:24 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6FFp-0004s4-1b; Mon, 24 Feb 2020 16:02:41 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id BA5E010408F;
        Mon, 24 Feb 2020 16:02:40 +0100 (CET)
Message-Id: <20200224145642.648784007@linutronix.de>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 15:01:33 +0100
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
Subject: [patch V3 02/22] bpf: Enforce preallocation for instrumentation programs on RT
References: <20200224140131.461979697@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aside of the general unsafety of run-time map allocation for
instrumentation type programs RT enabled kernels have another constraint:

The instrumentation programs are invoked with preemption disabled, but the
memory allocator spinlocks cannot be acquired in atomic context because
they are converted to 'sleeping' spinlocks on RT.

Therefore enforce map preallocation for these programs types when RT is
enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V3: New patch
---
 kernel/bpf/verifier.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8168,16 +8168,21 @@ static int check_map_prog_compatibility(
 	 * of the memory allocator or at a place where a recursion into the
 	 * memory allocator would see inconsistent state.
 	 *
-	 * For now running such programs is allowed for backwards
-	 * compatibility reasons, but warnings are emitted so developers are
-	 * made aware of the unsafety and can fix their programs before this
-	 * is enforced.
+	 * On RT enabled kernels run-time allocation of all trace type
+	 * programs is strictly prohibited due to lock type constraints. On
+	 * !RT kernels it is allowed for backwards compatibility reasons for
+	 * now, but warnings are emitted so developers are made aware of
+	 * the unsafety and can fix their programs before this is enforced.
 	 */
 	if (is_tracing_prog_type(prog->type) && !is_preallocated_map(map)) {
 		if (prog->type == BPF_PROG_TYPE_PERF_EVENT) {
 			verbose(env, "perf_event programs can only use preallocated hash map\n");
 			return -EINVAL;
 		}
+		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
+			verbose(env, "trace type programs can only use preallocated hash map\n");
+			return -EINVAL;
+		}
 		WARN_ONCE(1, "trace type BPF program uses run-time allocation\n");
 		verbose(env, "trace type programs with run-time allocated hash maps are unsafe. Switch to preallocated hash maps.\n");
 	}

