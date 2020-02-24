Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 247D216A925
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgBXPDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:03:25 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50205 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbgBXPDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:03:22 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6FFs-0004sW-6V; Mon, 24 Feb 2020 16:02:44 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id B2A2E104092;
        Mon, 24 Feb 2020 16:02:42 +0100 (CET)
Message-Id: <20200224145643.583038889@linutronix.de>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 15:01:42 +0100
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
Subject: [patch V3 11/22] bpf: Replace cant_sleep() with cant_migrate()
References: <20200224140131.461979697@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As already discussed in the previous change which introduced
BPF_RUN_PROG_PIN_ON_CPU() BPF only requires to disable migration to
guarantee per CPUness.

If RT substitutes the preempt disable based migration protection then the
cant_sleep() check will obviously trigger as preemption is not disabled.

Replace it by cant_migrate() which maps to cant_sleep() on a non RT kernel
and will verify that migration is disabled on a full RT kernel.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/filter.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -561,7 +561,7 @@ DECLARE_STATIC_KEY_FALSE(bpf_stats_enabl
 
 #define __BPF_PROG_RUN(prog, ctx, dfunc)	({			\
 	u32 ret;							\
-	cant_sleep();							\
+	cant_migrate();							\
 	if (static_branch_unlikely(&bpf_stats_enabled_key)) {		\
 		struct bpf_prog_stats *stats;				\
 		u64 start = sched_clock();				\

