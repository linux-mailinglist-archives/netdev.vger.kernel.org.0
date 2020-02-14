Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24DD015E5E5
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393032AbgBNQVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:21:37 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55566 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392998AbgBNQVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:21:34 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2diC-0003I9-Ou; Fri, 14 Feb 2020 17:21:04 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 6B4A1101DF3;
        Fri, 14 Feb 2020 17:21:04 +0100 (CET)
Message-Id: <20200214161503.289763704@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 14 Feb 2020 14:39:21 +0100
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
Subject: [RFC patch 04/19] bpf/tracing: Remove redundant preempt_disable() in __bpf_trace_run()
References: <20200214133917.304937432@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__bpf_trace_run() disables preemption around the BPF_PROG_RUN() invocation.

This is redundant because __bpf_trace_run() is invoked from a trace point
via __DO_TRACE() which already disables preemption _before_ invoking any of
the functions which are attached to a trace point.

Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/trace/bpf_trace.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1476,9 +1476,7 @@ static __always_inline
 void __bpf_trace_run(struct bpf_prog *prog, u64 *args)
 {
 	rcu_read_lock();
-	preempt_disable();
 	(void) BPF_PROG_RUN(prog, args);
-	preempt_enable();
 	rcu_read_unlock();
 }
 

