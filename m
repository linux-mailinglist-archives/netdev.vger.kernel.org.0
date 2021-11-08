Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409A7449A3D
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241396AbhKHQtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240299AbhKHQtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 11:49:25 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1E6C061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 08:46:40 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id i5so28046128wrb.2
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 08:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kmyJVsfSgKoRoupUW0SBIhUyem76B6jdPmKzH2Fxlco=;
        b=cuLxglrf5J8De3fx49cY5LRxkgnvJoTPgYfP8DSumOqs5WMepRjXIKHlbn7Cx5wkSE
         Lbi1mv5rFN+XPgnv4cHRlp2Brs34ZHIrloB33J682lM/25NFUcPETTkox0Bwg7PrxCZW
         1wd8LOuun3mFX1R39M78haYOjHwK6xMXBpGwBdTFQ/ZIfFykzhDLRBYsd4gKJ0utW8Do
         3HaP9KpLxkyQwUtlT2E2Dip9n6WhScok+v1tSkMsxuwrUE25q5iB5f3+r+JhVYtpy/k0
         aauZ2RRehp4ryGXbDO7H8z2YZLJY9J9/OohrXXvZV+NzilcyHgIgRGYwzdDnEeXhwtiI
         XMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kmyJVsfSgKoRoupUW0SBIhUyem76B6jdPmKzH2Fxlco=;
        b=KORN64LS1jm94OdmJjuS1ADSCiKkI5+gfKvPEOU/ZqggNVLH7jTI1E/3UpJQxzz0e5
         eqt8+HKDhqnDj8N4WYyalqCHJoS+/YFBh2Sv/2emUOsN+vDJEhJ6yKyjWXvJKwvAnmTb
         3VF0CF78FhQ7uz5RHnGkKxyN6lBLq8NTVIfoIydnzwMbZR3WvKsaBapiOHH/dxCqT8W4
         wc8NrsO+D4mOiqsUPhBm3nu/pmU1ACpcN5lJfm9nS1JDAgDOTrW4gk1tw3lzR9ZtwJOP
         6/9cBJd8Z28qjuI4CvY07x7eRo6PkJclS/bfIWWJhvxhGXdEuXRj9KRDCaPG/O3K+2TE
         Gl1g==
X-Gm-Message-State: AOAM531UwIYTbSBq3RykWkzfrepJx6Yka/azT2beG43ymlYcwHpxirR/
        SSIUqkwa1+boy++Pb/p/SNWLaQ==
X-Google-Smtp-Source: ABdhPJx4+zKxnNyimRZYkQknFlQQkIl44RSEMFeDj4+61j+k5Z4j8vNu4ljfbQEt9906uDueK5EJrw==
X-Received: by 2002:a5d:64af:: with SMTP id m15mr578743wrp.267.1636389998922;
        Mon, 08 Nov 2021 08:46:38 -0800 (PST)
Received: from localhost ([91.75.210.37])
        by smtp.gmail.com with ESMTPSA id u20sm17545885wmq.6.2021.11.08.08.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 08:46:38 -0800 (PST)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, rdna@fb.com,
        john.stultz@linaro.org, sboyd@kernel.org, peterz@infradead.org,
        mark.rutland@arm.com, rosted@goodmis.org,
        syzbot+43fd005b5a1b4d10781e@syzkaller.appspotmail.com
Subject: [PATCH bpf 1/2] bpf: Forbid bpf_ktime_get_coarse_ns and bpf_timer_* in tracing progs
Date:   Mon,  8 Nov 2021 20:46:19 +0400
Message-Id: <20211108164620.407305-2-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211108164620.407305-1-me@ubique.spb.ru>
References: <20211108164620.407305-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_ktime_get_coarse_ns() helper uses ktime_get_coarse_ns() time
accessor that isn't safe for any context.
This results in locking issues:

======================================================
WARNING: possible circular locking dependency detected
5.15.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.4/14877 is trying to acquire lock:
ffffffff8cb30008 (tk_core.seq.seqcount){----}-{0:0}, at: ktime_get_coarse_ts64+0x25/0x110 kernel/time/timekeeping.c:2255

but task is already holding lock:
ffffffff90dbf200 (&obj_hash[i].lock){-.-.}-{2:2}, at: debug_object_deactivate+0x61/0x400 lib/debugobjects.c:735

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&obj_hash[i].lock){-.-.}-{2:2}:
       lock_acquire+0x19f/0x4d0 kernel/locking/lockdep.c:5625
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0xd1/0x120 kernel/locking/spinlock.c:162
       __debug_object_init+0xd9/0x1860 lib/debugobjects.c:569
       debug_hrtimer_init kernel/time/hrtimer.c:414 [inline]
       debug_init kernel/time/hrtimer.c:468 [inline]
       hrtimer_init+0x20/0x40 kernel/time/hrtimer.c:1592
       ntp_init_cmos_sync kernel/time/ntp.c:676 [inline]
       ntp_init+0xa1/0xad kernel/time/ntp.c:1095
       timekeeping_init+0x512/0x6bf kernel/time/timekeeping.c:1639
       start_kernel+0x267/0x56e init/main.c:1030
       secondary_startup_64_no_verify+0xb1/0xbb

-> #0 (tk_core.seq.seqcount){----}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain+0x1dfb/0x8240 kernel/locking/lockdep.c:3789
       __lock_acquire+0x1382/0x2b00 kernel/locking/lockdep.c:5015
       lock_acquire+0x19f/0x4d0 kernel/locking/lockdep.c:5625
       seqcount_lockdep_reader_access+0xfe/0x230 include/linux/seqlock.h:103
       ktime_get_coarse_ts64+0x25/0x110 kernel/time/timekeeping.c:2255
       ktime_get_coarse include/linux/timekeeping.h:120 [inline]
       ktime_get_coarse_ns include/linux/timekeeping.h:126 [inline]
       ____bpf_ktime_get_coarse_ns kernel/bpf/helpers.c:173 [inline]
       bpf_ktime_get_coarse_ns+0x7e/0x130 kernel/bpf/helpers.c:171
       bpf_prog_a99735ebafdda2f1+0x10/0xb50
       bpf_dispatcher_nop_func include/linux/bpf.h:721 [inline]
       __bpf_prog_run include/linux/filter.h:626 [inline]
       bpf_prog_run include/linux/filter.h:633 [inline]
       BPF_PROG_RUN_ARRAY include/linux/bpf.h:1294 [inline]
       trace_call_bpf+0x2cf/0x5d0 kernel/trace/bpf_trace.c:127
       perf_trace_run_bpf_submit+0x7b/0x1d0 kernel/events/core.c:9708
       perf_trace_lock+0x37c/0x440 include/trace/events/lock.h:39
       trace_lock_release+0x128/0x150 include/trace/events/lock.h:58
       lock_release+0x82/0x810 kernel/locking/lockdep.c:5636
       __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:149 [inline]
       _raw_spin_unlock_irqrestore+0x75/0x130 kernel/locking/spinlock.c:194
       debug_hrtimer_deactivate kernel/time/hrtimer.c:425 [inline]
       debug_deactivate kernel/time/hrtimer.c:481 [inline]
       __run_hrtimer kernel/time/hrtimer.c:1653 [inline]
       __hrtimer_run_queues+0x2f9/0xa60 kernel/time/hrtimer.c:1749
       hrtimer_interrupt+0x3b3/0x1040 kernel/time/hrtimer.c:1811
       local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
       __sysvec_apic_timer_interrupt+0xf9/0x270 arch/x86/kernel/apic/apic.c:1103
       sysvec_apic_timer_interrupt+0x8c/0xb0 arch/x86/kernel/apic/apic.c:1097
       asm_sysvec_apic_timer_interrupt+0x12/0x20
       __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
       _raw_spin_unlock_irqrestore+0xd4/0x130 kernel/locking/spinlock.c:194
       try_to_wake_up+0x702/0xd20 kernel/sched/core.c:4118
       wake_up_process kernel/sched/core.c:4200 [inline]
       wake_up_q+0x9a/0xf0 kernel/sched/core.c:953
       futex_wake+0x50f/0x5b0 kernel/futex/waitwake.c:184
       do_futex+0x367/0x560 kernel/futex/syscalls.c:127
       __do_sys_futex kernel/futex/syscalls.c:199 [inline]
       __se_sys_futex+0x401/0x4b0 kernel/futex/syscalls.c:180
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

Locking issues are also possible with bpf_timer_* set of helpers:

hrtimer_start()
  lock_base();
  trace_hrtimer...()
    perf_event()
      bpf_run()
        bpf_timer_start()
          hrtimer_start()
            lock_base()         <- DEADLOCK

Forbid use of bpf_ktime_get_coarse_ns() and bpf_timer_* helpers in
BPF_PROG_TYPE_KPROBE, BPF_PROG_TYPE_TRACEPOINT, BPF_PROG_TYPE_PERF_EVENT
and BPF_PROG_TYPE_RAW_TRACEPOINT prog types as it may result locking
issues.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Reported-by: syzbot+43fd005b5a1b4d10781e@syzkaller.appspotmail.com
---
 kernel/bpf/helpers.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 1ffd469c217f..3de24928166e 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -18,6 +18,19 @@
 
 #include "../../lib/kstrtox.h"
 
+static bool is_tracing_prog_type(enum bpf_prog_type type)
+{
+	switch (type) {
+	case BPF_PROG_TYPE_KPROBE:
+	case BPF_PROG_TYPE_TRACEPOINT:
+	case BPF_PROG_TYPE_PERF_EVENT:
+	case BPF_PROG_TYPE_RAW_TRACEPOINT:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /* If kernel subsystem is allowing eBPF programs to call this function,
  * inside its own verifier_ops->get_func_proto() callback it should return
  * bpf_map_lookup_elem_proto, so that verifier can properly check the arguments
@@ -173,10 +186,18 @@ BPF_CALL_0(bpf_ktime_get_coarse_ns)
 	return ktime_get_coarse_ns();
 }
 
+static bool bpf_ktime_get_coarse_ns_allowed(const struct bpf_prog *prog)
+{
+	// Forbid prog types that might be non-safe for non-fast variants of time accessors
+
+	return !is_tracing_prog_type(prog->type);
+}
+
 const struct bpf_func_proto bpf_ktime_get_coarse_ns_proto = {
 	.func		= bpf_ktime_get_coarse_ns,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
+	.allowed	= bpf_ktime_get_coarse_ns_allowed,
 };
 
 BPF_CALL_0(bpf_get_current_pid_tgid)
@@ -1140,6 +1161,11 @@ BPF_CALL_3(bpf_timer_init, struct bpf_timer_kern *, timer, struct bpf_map *, map
 	return ret;
 }
 
+static bool bpf_timer_allowed(const struct bpf_prog *prog)
+{
+	return !is_tracing_prog_type(prog->type);
+}
+
 static const struct bpf_func_proto bpf_timer_init_proto = {
 	.func		= bpf_timer_init,
 	.gpl_only	= true,
@@ -1147,6 +1173,7 @@ static const struct bpf_func_proto bpf_timer_init_proto = {
 	.arg1_type	= ARG_PTR_TO_TIMER,
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
+	.allowed	= bpf_timer_allowed,
 };
 
 BPF_CALL_3(bpf_timer_set_callback, struct bpf_timer_kern *, timer, void *, callback_fn,
@@ -1200,6 +1227,7 @@ static const struct bpf_func_proto bpf_timer_set_callback_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_TIMER,
 	.arg2_type	= ARG_PTR_TO_FUNC,
+	.allowed	= bpf_timer_allowed,
 };
 
 BPF_CALL_3(bpf_timer_start, struct bpf_timer_kern *, timer, u64, nsecs, u64, flags)
@@ -1230,6 +1258,7 @@ static const struct bpf_func_proto bpf_timer_start_proto = {
 	.arg1_type	= ARG_PTR_TO_TIMER,
 	.arg2_type	= ARG_ANYTHING,
 	.arg3_type	= ARG_ANYTHING,
+	.allowed	= bpf_timer_allowed,
 };
 
 static void drop_prog_refcnt(struct bpf_hrtimer *t)
@@ -1279,6 +1308,7 @@ static const struct bpf_func_proto bpf_timer_cancel_proto = {
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_TIMER,
+	.allowed	= bpf_timer_allowed,
 };
 
 /* This function is called by map_delete/update_elem for individual element and
-- 
2.25.1

