Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1860516A94F
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgBXPEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:04:51 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50207 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgBXPDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:03:23 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6FFp-0004sK-Tv; Mon, 24 Feb 2020 16:02:42 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 9B151FFB71;
        Mon, 24 Feb 2020 16:02:41 +0100 (CET)
Message-Id: <20200224145643.059995527@linutronix.de>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 15:01:37 +0100
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
Subject: [patch V3 06/22] bpf/trace: Remove redundant preempt_disable from trace_call_bpf()
References: <20200224140131.461979697@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to __bpf_trace_run this is redundant because __bpf_trace_run() is
invoked from a trace point via __DO_TRACE() which already disables
preemption _before_ invoking any of the functions which are attached to a
trace point.

Remove it and add a cant_sleep() check.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V3: New patch. Replaces the previous one which converted this to migrate_disable() 
---
 kernel/trace/bpf_trace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -83,7 +83,7 @@ unsigned int trace_call_bpf(struct trace
 	if (in_nmi()) /* not supported yet */
 		return 1;
 
-	preempt_disable();
+	cant_sleep();
 
 	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
 		/*
@@ -115,7 +115,6 @@ unsigned int trace_call_bpf(struct trace
 
  out:
 	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
 
 	return ret;
 }

