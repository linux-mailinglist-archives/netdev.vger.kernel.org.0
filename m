Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB21844AD78
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 13:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242182AbhKIMZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 07:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241497AbhKIMZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 07:25:26 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A78BC0613F5
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 04:22:40 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id i5so32699093wrb.2
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 04:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jGGxV5hRcr0wdAm1Axn32TXl8p4NQnFAiW+DU8mCDhk=;
        b=CVuj3yd4LZaAVrvocsGXAK3VqK2hgBR2j1Ok6AuNnXyeCSB92d3ccpQbXIxmAuNc/d
         36xjh2fO7SszLqc5+Dgph1KVcm5HA+RhE14Bq/YGF1woju9mJSYWAHhKHlBvGKpR1seD
         Z8CwnIzkHbkf0W7rLv1gV7qzYtXmTQ5qMon/AUh0XknPyOtwjslFM/20c06dD8S9CEu8
         Dbrv7YqoG2zG0++/FRZO0m/aHBzkm/MQfz6nJ/K0PanroUdF76z9o/Za7TUMj79CVpuX
         VZCM++NhOmcOfwVsgcXUql+mFEMi7KlCBeHCqereJDtAgdMyotpz/n4qmLbir/hmWQEr
         cqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jGGxV5hRcr0wdAm1Axn32TXl8p4NQnFAiW+DU8mCDhk=;
        b=QM8jnHfWfZQ2zcjd4UxToNIEm1r2TyaLs79yXjZe5siu4kmd128rBcNVMc/fmZUuuG
         CUFVAZLoDAxCuEEkC4qbGkCKL8ByWkvQQaZqJ+w1WUOPith+lMm3zykhcY18+31JL3tz
         IfMfH/PGC338bXaI7yFefBpkxSZHxLw2307j5oLs26fqU2pfPjeAPghFt4+hoSeslO3T
         K73VJPO7HsKW7BxgKjOG6gbJW6DLCvwwDtdp9g9BDJG4mAucFKDYLUuCslM+UL0GUAwY
         WLe+rxib/idzGe5Zd1hoR7Itp7wCjm/rEDUcnGMmQoaqSZgrIKq3tNyk5zrZcwx8uJUv
         PIYA==
X-Gm-Message-State: AOAM532F7a84bfgJMBxJFj0PVcgcDuqtZa8/vVHzIilLPyMk7kwwEUgC
        pAtUtQLUIkIO6XutLLsHMlw0RQ==
X-Google-Smtp-Source: ABdhPJwVncvyWqpMtaGBtNmQxzHu9oM0ibXss97hRjSlw6b9nJhCbhm44df/U9FQj98N7elyEUzKwg==
X-Received: by 2002:a5d:550c:: with SMTP id b12mr8817289wrv.427.1636460558780;
        Tue, 09 Nov 2021 04:22:38 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:15:13:d20d:9fab:cbe:339])
        by smtp.gmail.com with ESMTPSA id n32sm2815777wms.1.2021.11.09.04.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 04:22:38 -0800 (PST)
Date:   Tue, 9 Nov 2021 13:22:32 +0100
From:   Marco Elver <elver@google.com>
To:     peterz@infradead.org, mingo@redhat.com, mark.rutland@arm.com,
        namhyung@kernel.org, acme@kernel.org,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com
Cc:     syzbot <syzbot+23843634c323e144fd0b@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: [PATCH] perf: Ignore sigtrap for tracepoints destined for other tasks
Message-ID: <YYpoCOBmC/kJWfmI@elver.google.com>
References: <00000000000053692705d05a17c1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000053692705d05a17c1@google.com>
User-Agent: Mutt/2.0.5 (2021-01-21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported that the warning in perf_sigtrap() fires, saying that
the event's task does not match current:

 | WARNING: CPU: 0 PID: 9090 at kernel/events/core.c:6446 perf_pending_event+0x40d/0x4b0 kernel/events/core.c:6513
 | Modules linked in:
 | CPU: 0 PID: 9090 Comm: syz-executor.1 Not tainted 5.15.0-syzkaller #0
 | Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
 | RIP: 0010:perf_sigtrap kernel/events/core.c:6446 [inline]
 | RIP: 0010:perf_pending_event_disable kernel/events/core.c:6470 [inline]
 | RIP: 0010:perf_pending_event+0x40d/0x4b0 kernel/events/core.c:6513
 | ...
 | Call Trace:
 |  <IRQ>
 |  irq_work_single+0x106/0x220 kernel/irq_work.c:211
 |  irq_work_run_list+0x6a/0x90 kernel/irq_work.c:242
 |  irq_work_run+0x4f/0xd0 kernel/irq_work.c:251
 |  __sysvec_irq_work+0x95/0x3d0 arch/x86/kernel/irq_work.c:22
 |  sysvec_irq_work+0x8e/0xc0 arch/x86/kernel/irq_work.c:17
 |  </IRQ>
 |  <TASK>
 |  asm_sysvec_irq_work+0x12/0x20 arch/x86/include/asm/idtentry.h:664
 | RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
 | RIP: 0010:_raw_spin_unlock_irqrestore+0x38/0x70 kernel/locking/spinlock.c:194
 | ...
 |  coredump_task_exit kernel/exit.c:371 [inline]
 |  do_exit+0x1865/0x25c0 kernel/exit.c:771
 |  do_group_exit+0xe7/0x290 kernel/exit.c:929
 |  get_signal+0x3b0/0x1ce0 kernel/signal.c:2820
 |  arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 |  handle_signal_work kernel/entry/common.c:148 [inline]
 |  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 |  exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 |  __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 |  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 |  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 |  entry_SYSCALL_64_after_hwframe+0x44/0xae

On x86 this shouldn't happen, which has arch_irq_work_raise().

The test program sets up a perf event with sigtrap set to fire on the
'sched_wakeup' tracepoint, which fired in ttwu_do_wakeup().

This happened because the 'sched_wakeup' tracepoint also takes a task
argument passed on to perf_tp_event(), which is used to deliver the
event to that other task.

Since we cannot deliver synchronous signals to other tasks, skip an event if
perf_tp_event() is targeted at another task and perf_event_attr::sigtrap is
set, which will avoid ever entering perf_sigtrap() for such events.

Fixes: 97ba62b27867 ("perf: Add support for SIGTRAP on perf events")
Reported-by: syzbot+663359e32ce6f1a305ad@syzkaller.appspotmail.com
Signed-off-by: Marco Elver <elver@google.com>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f23ca260307f..91653c6e41a7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9729,6 +9729,9 @@ void perf_tp_event(u16 event_type, u64 count, void *record, int entry_size,
 				continue;
 			if (event->attr.config != entry->type)
 				continue;
+			/* Cannot deliver synchronous signal to other task. */
+			if (event->attr.sigtrap)
+				continue;
 			if (perf_tp_event_match(event, &data, regs))
 				perf_swevent_event(event, count, &data, regs);
 		}
-- 
2.34.0.rc0.344.g81b53c2807-goog
