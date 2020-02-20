Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DE716696A
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgBTU6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:58:23 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44153 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729167AbgBTU4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 15:56:38 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4srh-0007TM-FO; Thu, 20 Feb 2020 21:56:09 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id C6D01104085;
        Thu, 20 Feb 2020 21:56:03 +0100 (CET)
Message-Id: <20200220204618.135607169@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 20 Feb 2020 21:45:25 +0100
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
Subject: [patch V2 08/20] bpf: Replace cant_sleep() with cant_migrate()
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

