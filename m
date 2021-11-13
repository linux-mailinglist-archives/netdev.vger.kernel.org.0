Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9486F44F3A8
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 15:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhKMOZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 09:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbhKMOZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 09:25:39 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222B5C061766
        for <netdev@vger.kernel.org>; Sat, 13 Nov 2021 06:22:46 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id v11so50007240edc.9
        for <netdev@vger.kernel.org>; Sat, 13 Nov 2021 06:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yYxA56i5MJ6bpYu6+oD5IjKfwzZmQrd7riFqM9IsT1I=;
        b=HB5NQlRqrA/lQsRBqZEuxT5IBmnVS32pTYahRDaSWg+U9MW5qhv/XD7pfhUiP9BmtY
         qEAi1eQ/m2+ls77MLjPf+WNtQtrU0j6pSa9DMq6YfCm9vC4gDOCci8fV3TkTFf8E09ML
         Y5ESMQVc++uh9XqnKvNIAmiQg9viJAifEyhVMo4tmu+X0qpVC7bNwIVqdKTQLAI9J5lt
         o1r6u/M3sYRY4n9lIwhT1iCfQ1oHAGTemT1LSuJho5J65DtOVXHsG1bAkwAXC0cijBfC
         pZy+dTepUZviFvu8HQ4pOb68nLfgUM4kizezI7AFBN6+gzWj3OJMotn3nt+VeQbN+X6B
         Vnbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yYxA56i5MJ6bpYu6+oD5IjKfwzZmQrd7riFqM9IsT1I=;
        b=bx6pAfSt1eN/AhRA2DqZHO1fkp0WdVsSSdw8Bpbmz21NZvcO7/T9Uqh8YLIqJQ7paS
         qInaPhEQF+zlkrh7cdGFXHk7H9nBf5p/wkmQEGvbMzD8l+Yx+fQ4UneD85tLbX8gtGQ4
         1nwrTRrkh7hpR4ZS0kI4nfaDy8wN25YXfHHlHuuBrB7zhT6+VG5TzTZ+LGioaG2yfczh
         aHaCiEfZ7xFbwkjnhj4tiWqgGK38R57TYCAgOlUFQyRENnB67XdPog4ddyzZKFC7oeaJ
         j+XBOZNZpcRWFMUcIrLYm0skhvj1PJFTE39ihCWcnSukf9YwWGzjmgDo5DJL7bLUr5+V
         TqlA==
X-Gm-Message-State: AOAM530TLiYMR3zSaxtiNnRyRVz9M6AsjbatPq4qP18bV7EPaIWqZ2Wj
        VSiHPSVQNoNRblYUNBSAuMTnaw==
X-Google-Smtp-Source: ABdhPJxkkbSbP5cM4ejBVR2cZLMWKd7yWCh8JN5mzLw38Fg6B3jn2HAn4CqC6YiUliDXoa7MEWlaww==
X-Received: by 2002:a50:e0c3:: with SMTP id j3mr33141753edl.97.1636813364693;
        Sat, 13 Nov 2021 06:22:44 -0800 (PST)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id jx10sm498445ejc.102.2021.11.13.06.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 06:22:44 -0800 (PST)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, tglx@linutronix.de,
        rdna@fb.com, syzbot+43fd005b5a1b4d10781e@syzkaller.appspotmail.com
Subject: [PATCH bpf v2 1/2] bpf: Forbid bpf_ktime_get_coarse_ns and bpf_timer_* in tracing progs
Date:   Sat, 13 Nov 2021 18:22:26 +0400
Message-Id: <20211113142227.566439-2-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211113142227.566439-1-me@ubique.spb.ru>
References: <20211113142227.566439-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use of bpf_ktime_get_coarse_ns() and bpf_timer_* helpers in tracing
progs may result in locking issues.

bpf_ktime_get_coarse_ns() uses ktime_get_coarse_ns() time accessor that
isn't safe for any context:
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

There is a possible deadlock with bpf_timer_* set of helpers:
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
and BPF_PROG_TYPE_RAW_TRACEPOINT prog types.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Fixes: d05512618056 ("bpf: Add bpf_ktime_get_coarse_ns helper")
Fixes: b00628b1c7d5 ("bpf: Introduce bpf timers.")
Reported-by: syzbot+43fd005b5a1b4d10781e@syzkaller.appspotmail.com
---
 include/uapi/linux/bpf.h       | 6 ++++++
 kernel/bpf/cgroup.c            | 2 ++
 kernel/bpf/helpers.c           | 2 --
 kernel/bpf/verifier.c          | 7 +++++++
 kernel/trace/bpf_trace.c       | 2 --
 net/core/filter.c              | 6 ++++++
 net/ipv4/bpf_tcp_ca.c          | 2 ++
 tools/include/uapi/linux/bpf.h | 6 ++++++
 8 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ba5af15e25f5..243100d7a764 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4632,6 +4632,9 @@ union bpf_attr {
  * 		system boot, in nanoseconds. Does not include time the system
  * 		was suspended.
  *
+ *		Tracing programs cannot use **bpf_ktime_get_coarse_ns**\() (but
+ *		this may change in the future).
+ *
  * 		See: **clock_gettime**\ (**CLOCK_MONOTONIC_COARSE**)
  * 	Return
  * 		Current *ktime*.
@@ -4804,6 +4807,9 @@ union bpf_attr {
  *		All other bits of *flags* are reserved.
  *		The verifier will reject the program if *timer* is not from
  *		the same *map*.
+ *
+ *		Tracing programs cannot use **bpf_timer_init**\() (but this may
+ *		change in the future).
  *	Return
  *		0 on success.
  *		**-EBUSY** if *timer* is already initialized.
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 2ca643af9a54..43eb3501721b 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1809,6 +1809,8 @@ sysctl_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sysctl_get_new_value_proto;
 	case BPF_FUNC_sysctl_set_new_value:
 		return &bpf_sysctl_set_new_value_proto;
+	case BPF_FUNC_ktime_get_coarse_ns:
+		return &bpf_ktime_get_coarse_ns_proto;
 	default:
 		return cgroup_base_func_proto(func_id, prog);
 	}
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 1ffd469c217f..649f07623df6 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1364,8 +1364,6 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
-	case BPF_FUNC_ktime_get_coarse_ns:
-		return &bpf_ktime_get_coarse_ns_proto;
 	case BPF_FUNC_ringbuf_output:
 		return &bpf_ringbuf_output_proto;
 	case BPF_FUNC_ringbuf_reserve:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index aab7482ed1c3..65d2f93b7030 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11632,6 +11632,13 @@ static int check_map_prog_compatibility(struct bpf_verifier_env *env,
 		}
 	}
 
+	if (map_value_has_timer(map)) {
+		if (is_tracing_prog_type(prog_type)) {
+			verbose(env, "tracing progs cannot use bpf_timer yet\n");
+			return -EINVAL;
+		}
+	}
+
 	if ((bpf_prog_is_dev_bound(prog->aux) || bpf_map_is_dev_bound(map)) &&
 	    !bpf_offload_prog_map_match(prog, map)) {
 		verbose(env, "offload device mismatch between prog and map\n");
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7396488793ff..ae9755037b7e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1111,8 +1111,6 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
-	case BPF_FUNC_ktime_get_coarse_ns:
-		return &bpf_ktime_get_coarse_ns_proto;
 	case BPF_FUNC_tail_call:
 		return &bpf_tail_call_proto;
 	case BPF_FUNC_get_current_pid_tgid:
diff --git a/net/core/filter.c b/net/core/filter.c
index e471c9b09670..6102f093d59a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7162,6 +7162,8 @@ sock_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #endif
 	case BPF_FUNC_sk_storage_get:
 		return &bpf_sk_storage_get_cg_sock_proto;
+	case BPF_FUNC_ktime_get_coarse_ns:
+		return &bpf_ktime_get_coarse_ns_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -10327,6 +10329,8 @@ sk_reuseport_func_proto(enum bpf_func_id func_id,
 		return &sk_reuseport_load_bytes_relative_proto;
 	case BPF_FUNC_get_socket_cookie:
 		return &bpf_get_socket_ptr_cookie_proto;
+	case BPF_FUNC_ktime_get_coarse_ns:
+		return &bpf_ktime_get_coarse_ns_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -10833,6 +10837,8 @@ bpf_sk_base_func_proto(enum bpf_func_id func_id)
 	case BPF_FUNC_skc_to_unix_sock:
 		func = &bpf_skc_to_unix_sock_proto;
 		break;
+	case BPF_FUNC_ktime_get_coarse_ns:
+		return &bpf_ktime_get_coarse_ns_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 2cf02b4d77fb..4bb9401b0a3f 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -205,6 +205,8 @@ bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
 		    offsetof(struct tcp_congestion_ops, release))
 			return &bpf_sk_getsockopt_proto;
 		return NULL;
+	case BPF_FUNC_ktime_get_coarse_ns:
+		return &bpf_ktime_get_coarse_ns_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ba5af15e25f5..243100d7a764 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4632,6 +4632,9 @@ union bpf_attr {
  * 		system boot, in nanoseconds. Does not include time the system
  * 		was suspended.
  *
+ *		Tracing programs cannot use **bpf_ktime_get_coarse_ns**\() (but
+ *		this may change in the future).
+ *
  * 		See: **clock_gettime**\ (**CLOCK_MONOTONIC_COARSE**)
  * 	Return
  * 		Current *ktime*.
@@ -4804,6 +4807,9 @@ union bpf_attr {
  *		All other bits of *flags* are reserved.
  *		The verifier will reject the program if *timer* is not from
  *		the same *map*.
+ *
+ *		Tracing programs cannot use **bpf_timer_init**\() (but this may
+ *		change in the future).
  *	Return
  *		0 on success.
  *		**-EBUSY** if *timer* is already initialized.
-- 
2.25.1

