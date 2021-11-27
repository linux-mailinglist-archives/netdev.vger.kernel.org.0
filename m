Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B71460034
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 17:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240196AbhK0Qhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 11:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbhK0Qfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 11:35:38 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89C2C06173E;
        Sat, 27 Nov 2021 08:32:23 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638030741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZziicXtqyO0B1KjTH77YkvbnDEecY2obLG7HtYzb1SY=;
        b=hQLvnZpMzyKSpFQ5LnjbT9f1Pki19gYjPW2dTBSuPW232ieENBmNInCWC69yth7cZQ5TH+
        xEO5WtlpQlbEnEhRNGbfU/f0c3pGJH5jG1l8R+f1FzMrVBUXYA+vSXk53l3VDZKQ1hH+ZR
        FHHkQn0NdbBoObW2Ef2IQpti1hI1O/oV79tT7ROGArPkUyP2sskHj0Q1bD8It5efb4yeK/
        KyWxm1PsOjOZMNg9D9se4qNelILynGAqfJDPwLvfdJpCVXOpCfvRGne2RydiJll4z1yj0U
        oqnQZiKpHch/g+KwvoUDkkUEVAWMQUhNKtN7f/WCNGUa+ecWI1zB4MA5Cme2EQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638030741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZziicXtqyO0B1KjTH77YkvbnDEecY2obLG7HtYzb1SY=;
        b=kVfiGYqOJTslUWrnjsePn8Edrd/RDdXZkr2q0Aei7HCG/0EFPS2Bo8atcEM3f7ZTtu7pZp
        WUbs254BtCYoGhBg==
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net 2/2] bpf: Make sure bpf_disable_instrumentation() is safe vs preemption.
Date:   Sat, 27 Nov 2021 17:32:00 +0100
Message-Id: <20211127163200.10466-3-bigeasy@linutronix.de>
In-Reply-To: <20211127163200.10466-1-bigeasy@linutronix.de>
References: <20211127163200.10466-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The initial implementation of migrate_disable() for mainline was a
wrapper around preempt_disable(). RT kernels substituted this with
a real migrate disable implementation.

Later on mainline gained true migrate disable support, but neither
documentation nor affected code were updated.

Remove stale comments claiming that migrate_disable() is PREEMPT_RT
only.
Don't use __this_cpu_inc() in the !PREEMPT_RT path because preemption is
not disabled and the RMW operation can be preempted.

Fixes: 74d862b682f51 ("sched: Make migrate_disable/enable() independent of =
RT")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/bpf.h    | 16 ++--------------
 include/linux/filter.h |  3 ---
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e7a163a3146b6..327a2bec06ca0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1352,28 +1352,16 @@ extern struct mutex bpf_stats_enabled_mutex;
  * kprobes, tracepoints) to prevent deadlocks on map operations as any of
  * these events can happen inside a region which holds a map bucket lock
  * and can deadlock on it.
- *
- * Use the preemption safe inc/dec variants on RT because migrate disable
- * is preemptible on RT and preemption in the middle of the RMW operation
- * might lead to inconsistent state. Use the raw variants for non RT
- * kernels as migrate_disable() maps to preempt_disable() so the slightly
- * more expensive save operation can be avoided.
  */
 static inline void bpf_disable_instrumentation(void)
 {
 	migrate_disable();
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		this_cpu_inc(bpf_prog_active);
-	else
-		__this_cpu_inc(bpf_prog_active);
+	this_cpu_inc(bpf_prog_active);
 }
=20
 static inline void bpf_enable_instrumentation(void)
 {
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		this_cpu_dec(bpf_prog_active);
-	else
-		__this_cpu_dec(bpf_prog_active);
+	this_cpu_dec(bpf_prog_active);
 	migrate_enable();
 }
=20
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 24b7ed2677afd..534f678ca50fa 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -640,9 +640,6 @@ static __always_inline u32 bpf_prog_run(const struct bp=
f_prog *prog, const void
  * This uses migrate_disable/enable() explicitly to document that the
  * invocation of a BPF program does not require reentrancy protection
  * against a BPF program which is invoked from a preempting task.
- *
- * For non RT enabled kernels migrate_disable/enable() maps to
- * preempt_disable/enable(), i.e. it disables also preemption.
  */
 static inline u32 bpf_prog_run_pin_on_cpu(const struct bpf_prog *prog,
 					  const void *ctx)
--=20
2.34.0

