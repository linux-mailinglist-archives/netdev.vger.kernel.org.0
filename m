Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40CA15E1F6
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392970AbgBNQVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:21:31 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55535 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392946AbgBNQV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:21:29 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2diE-0003IO-0z; Fri, 14 Feb 2020 17:21:06 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id B2903101DF7;
        Fri, 14 Feb 2020 17:21:05 +0100 (CET)
Message-Id: <20200214161503.911098862@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 14 Feb 2020 14:39:27 +0100
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
Subject: [RFC patch 10/19] trace/bpf: Use migrate disable in trace_call_bpf()
References: <20200214133917.304937432@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF does not require preemption disable. It only requires to stay on the
same CPU while running a program. Reflect this by replacing
preempt_disable/enable() with migrate_disable/enable() pairs.

On a non-RT kernel this maps to preempt_disable/enable().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/trace/bpf_trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -83,7 +83,7 @@ unsigned int trace_call_bpf(struct trace
 	if (in_nmi()) /* not supported yet */
 		return 1;
 
-	preempt_disable();
+	migrate_disable();
 
 	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
 		/*
@@ -115,7 +115,7 @@ unsigned int trace_call_bpf(struct trace
 
  out:
 	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
+	migrate_enable();
 
 	return ret;
 }

