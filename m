Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577E3224EA8
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 04:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgGSCRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 22:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgGSCRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 22:17:03 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B499C0619D2;
        Sat, 18 Jul 2020 19:17:03 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id l6so7077331plt.7;
        Sat, 18 Jul 2020 19:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DDjkruDZZiGuO+G4uGfQWxOYHUq1vj3yKKda7hKMhwc=;
        b=sUh8rRPhAmf8OutYt/BHJG13s9KA8uRNsqFyjyJz/7Yh/Y7BbVuVKPk/Pt1FLSzi9X
         xm66I9JrTallWYHWskBcOH1tB9T1NAuD/+Vi9G6hA3/1Sc4jpdKTVzkN+G8kj5CIinxh
         G2Y6TLfZmgvsZT7R2LMk1eRJ8HNBpHfNn/AbwXvv97eVJYl7SqBsbsswjWECFSGd0the
         kUi+PWWD3hTage2lAs7zlvsE+cRDlI7nAnHXLoRnBcqnCasO2TuIgxMyQdA4nDeQcz3h
         nwrEVd/e18B0GtZvKaE6bySlF+sR3I0UDIeilLQaYS9xAGVTXZWdxjQ/b4YfWAC0vtqD
         kJRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DDjkruDZZiGuO+G4uGfQWxOYHUq1vj3yKKda7hKMhwc=;
        b=ekTpisN8gB2M/86ZnRR+Xh5NSNuO5HXvsOgE3rpvbkSSifjYdlb9guSCGaHpryWqHw
         hM4f7Ml7VMT/0ypv4ChV7zFdww/dNyca0ooN7guY2xgAtoyfVMFvx3+Vv6RGwCaVMhec
         T5+1QG9+c6rsu7oQ/8sw+DM5BeUqf+qohK9Yb28Klp3Chgr4fXCjgAOmCEx3/HyRbTT0
         h+DiWVwPYYcnJsEebT5rtS8ZZvwGN6U5ZpFLpEhHLtA4VQ+Z5ynHLwtStXYvnqSKcfd5
         urxNuPanRJJnklTPpZCYg083EO4xAexTqiLwKYV36PDzX1sdJDP8Ip0PcBFARUqPA3gD
         6S3A==
X-Gm-Message-State: AOAM533RaWTkY/YUBoBjnWk0bnR3HOr6yr5OY6Huw2LSKgN2s3VWpNaX
        zEz5pkJxFxgjLG6OuGsdfhI=
X-Google-Smtp-Source: ABdhPJxmljm8zDhaLPjcvSwj4FLShwRug5hPC3m746l57iWWBN7Pxoltt6WHUz8jkfNkm7UaNsp3ag==
X-Received: by 2002:a17:902:fe0d:: with SMTP id g13mr13465637plj.326.1595125022614;
        Sat, 18 Jul 2020 19:17:02 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:400:e00:19b7:f650:7bbe:a7fb])
        by smtp.gmail.com with ESMTPSA id a68sm6891159pje.35.2020.07.18.19.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 19:17:02 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 2/3] xtensa: add seccomp support
Date:   Sat, 18 Jul 2020 19:16:53 -0700
Message-Id: <20200719021654.25922-3-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200719021654.25922-1-jcmvbkbc@gmail.com>
References: <20200719021654.25922-1-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add SECCOMP to xtensa Kconfig, select HAVE_ARCH_SECCOMP_FILTER, add
TIF_SECCOMP and call secure_computing from do_syscall_trace_enter.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 .../seccomp/seccomp-filter/arch-support.txt       |  2 +-
 arch/xtensa/Kconfig                               | 15 +++++++++++++++
 arch/xtensa/include/asm/Kbuild                    |  1 +
 arch/xtensa/include/asm/thread_info.h             |  5 ++++-
 arch/xtensa/kernel/ptrace.c                       |  4 +++-
 5 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/Documentation/features/seccomp/seccomp-filter/arch-support.txt b/Documentation/features/seccomp/seccomp-filter/arch-support.txt
index c7b837f735b1..7b3ec8ea174a 100644
--- a/Documentation/features/seccomp/seccomp-filter/arch-support.txt
+++ b/Documentation/features/seccomp/seccomp-filter/arch-support.txt
@@ -30,5 +30,5 @@
     |          um: |  ok  |
     |   unicore32: | TODO |
     |         x86: |  ok  |
-    |      xtensa: | TODO |
+    |      xtensa: |  ok  |
     -----------------------
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index a7def0991a01..a461ee051e73 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -24,6 +24,7 @@ config XTENSA
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
 	select HAVE_ARCH_KASAN if MMU && !XIP_KERNEL
+	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_COPY_THREAD_TLS
 	select HAVE_DEBUG_KMEMLEAK
@@ -217,6 +218,20 @@ config HOTPLUG_CPU
 
 	  Say N if you want to disable CPU hotplug.
 
+config SECCOMP
+	bool
+	prompt "Enable seccomp to safely compute untrusted bytecode"
+	help
+	  This kernel feature is useful for number crunching applications
+	  that may need to compute untrusted bytecode during their
+	  execution. By using pipes or other transports made available to
+	  the process as file descriptors supporting the read/write
+	  syscalls, it's possible to isolate those applications in
+	  their own address space using seccomp. Once seccomp is
+	  enabled via prctl(PR_SET_SECCOMP), it cannot be disabled
+	  and the task is only allowed to execute a few safe syscalls
+	  defined by each seccomp mode.
+
 config FAST_SYSCALL_XTENSA
 	bool "Enable fast atomic syscalls"
 	default n
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index 9718e9593564..c59c42a1221a 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -7,4 +7,5 @@ generic-y += mcs_spinlock.h
 generic-y += param.h
 generic-y += qrwlock.h
 generic-y += qspinlock.h
+generic-y += seccomp.h
 generic-y += user.h
diff --git a/arch/xtensa/include/asm/thread_info.h b/arch/xtensa/include/asm/thread_info.h
index c49cc4a1f39a..8918f0f20c53 100644
--- a/arch/xtensa/include/asm/thread_info.h
+++ b/arch/xtensa/include/asm/thread_info.h
@@ -112,6 +112,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NOTIFY_RESUME	7	/* callback before returning to user */
 #define TIF_DB_DISABLED		8	/* debug trap disabled for syscall */
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing active */
+#define TIF_SECCOMP		10	/* secure computing */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -119,9 +120,11 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
+#define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 
 #define _TIF_WORK_MASK		(_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP | \
-				 _TIF_SYSCALL_TRACEPOINT | _TIF_SYSCALL_AUDIT)
+				 _TIF_SYSCALL_TRACEPOINT | \
+				 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP)
 
 #define THREAD_SIZE KERNEL_STACK_SIZE
 #define THREAD_SIZE_ORDER (KERNEL_STACK_SHIFT - PAGE_SHIFT)
diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index 437b4297948d..ce4a32bd2294 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/regset.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
+#include <linux/seccomp.h>
 #include <linux/security.h>
 #include <linux/signal.h>
 #include <linux/smp.h>
@@ -559,7 +560,8 @@ int do_syscall_trace_enter(struct pt_regs *regs)
 		return 0;
 	}
 
-	if (regs->syscall == NO_SYSCALL) {
+	if (regs->syscall == NO_SYSCALL ||
+	    secure_computing() == -1) {
 		do_syscall_trace_leave(regs);
 		return 0;
 	}
-- 
2.20.1

