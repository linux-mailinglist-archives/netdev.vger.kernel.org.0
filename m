Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D9915E641
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394139AbgBNQqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:46:11 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55548 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392961AbgBNQVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:21:31 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2diC-0003IB-WC; Fri, 14 Feb 2020 17:21:05 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 9FF87101DF6;
        Fri, 14 Feb 2020 17:21:04 +0100 (CET)
Message-Id: <20200214161503.382318072@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 14 Feb 2020 14:39:22 +0100
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
Subject: [RFC patch 05/19] perf/bpf: Remove preempt disable around BPF invocation
References: <20200214133917.304937432@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF invocation from the perf event overflow handler does not require to
disable preemption because this is called from NMI or at least hard
interrupt context which is already non-preemptible.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/events/core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9206,7 +9206,6 @@ static void bpf_overflow_handler(struct
 	int ret = 0;
 
 	ctx.regs = perf_arch_bpf_user_pt_regs(regs);
-	preempt_disable();
 	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1))
 		goto out;
 	rcu_read_lock();
@@ -9214,7 +9213,6 @@ static void bpf_overflow_handler(struct
 	rcu_read_unlock();
 out:
 	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
 	if (!ret)
 		return;
 

