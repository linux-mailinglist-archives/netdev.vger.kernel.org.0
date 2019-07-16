Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472286A71E
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 13:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387637AbfGPLN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 07:13:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39071 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387539AbfGPLN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 07:13:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so9282389pgi.6
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 04:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E2i/udg2w3wrGveXxZ0CfGzob3tFFx0rfm+JzVT0Ufc=;
        b=jHKzaY6922Yu28T9Bff5NZORO93a7cXFLmiZuwi4qLfbemKA5hga13MQN3haCO8ena
         q/ri2Qg7dE7VL8A1Kl2QztmGDv+YCLGTjyZpEIFPN9KWjOxdu5RE9PZMsFjxXTV5ds8V
         NN/qh4zAHXZCvvb17yStTthsdlNay9Z2Kstc4El8pGQcaPZ5aSDbtMG/j1GQJp8vuIU5
         4hP+vogcQvMmDhOSAmBxXLAPCOCXH2gIuKG8Aq1pRi9aYQC6LcbpNS/drPm6r1XW3T9e
         VUR3ZRnPGlAfN/jbriW+1ll6DXsv5rVCEXrNEz7ww2hwuKQXLbY3wow52xMceZB0oK7W
         Y3ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E2i/udg2w3wrGveXxZ0CfGzob3tFFx0rfm+JzVT0Ufc=;
        b=IF/hE+7x7f/IMIcY69ePHoY5kS5RF8Qnf7ZhqXjuH8P7h3LkE901CJLnvkvIYPgZZm
         QuZqUzzfhZNwHw1/IZR9fX7J24v3KCk7b/AkMEoD2XOmq0ZikJAnf9w6jQUGw4WalpQR
         uhprhOceXoU6HhpQ+hm8GVwbri2M5eH7IEbalsJUtxBlbj1sK2Eie46rr4OaD0YXUaMX
         gCe+52AvNwLiXhCBfvDjdySnElds/bD/qucIwj0TL4jFGYnSxxEzc56s8+wmuj8wKIXF
         it4Vv2GSfhBB001aTVToBFW+BCZYBjGO8DS3H1RpUDfyGu/nAnUsZK0ACN9XAbittmgh
         4gAg==
X-Gm-Message-State: APjAAAXYeAQxM68jkPtwA8QVq9n07t866hKI2f9Cn3Jj+RMyNXlJb476
        1EPwKmm473CZfggrWnclA6ruIA==
X-Google-Smtp-Source: APXvYqxH/LGB+HIDp3yR3h8D9gmqijBTeEMxlQPvdHS35dIb8U6g8YLCFVj2tj/OrIFeqjNGQFTSsA==
X-Received: by 2002:a63:d315:: with SMTP id b21mr8418386pgg.326.1563275605529;
        Tue, 16 Jul 2019 04:13:25 -0700 (PDT)
Received: from localhost.localdomain (li1433-81.members.linode.com. [45.33.106.81])
        by smtp.gmail.com with ESMTPSA id 21sm19324907pjh.25.2019.07.16.04.13.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 04:13:25 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Russell King <linux@armlinux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Justin He <Justin.He@arm.com>
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH 1/2] arm64: Add support for function error injection
Date:   Tue, 16 Jul 2019 19:13:00 +0800
Message-Id: <20190716111301.1855-2-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190716111301.1855-1-leo.yan@linaro.org>
References: <20190716111301.1855-1-leo.yan@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implement regs_set_return_value() and
override_function_with_return() to support function error injection
for arm64.

In the exception flow, arm64's general register x30 contains the value
for the link register; so we can just update pt_regs::pc with it rather
than redirecting execution to a dummy function that returns.

This patch is heavily inspired by the commit 7cd01b08d35f ("powerpc:
Add support for function error injection").

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 arch/arm64/Kconfig                       |  1 +
 arch/arm64/include/asm/error-injection.h | 13 +++++++++++++
 arch/arm64/include/asm/ptrace.h          |  5 +++++
 arch/arm64/lib/Makefile                  |  2 ++
 arch/arm64/lib/error-inject.c            | 19 +++++++++++++++++++
 5 files changed, 40 insertions(+)
 create mode 100644 arch/arm64/include/asm/error-injection.h
 create mode 100644 arch/arm64/lib/error-inject.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 697ea0510729..a6d9e622977d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -142,6 +142,7 @@ config ARM64
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_TRACER
+	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
diff --git a/arch/arm64/include/asm/error-injection.h b/arch/arm64/include/asm/error-injection.h
new file mode 100644
index 000000000000..da057e8ed224
--- /dev/null
+++ b/arch/arm64/include/asm/error-injection.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef __ASM_ERROR_INJECTION_H_
+#define __ASM_ERROR_INJECTION_H_
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <asm/ptrace.h>
+#include <asm-generic/error-injection.h>
+
+void override_function_with_return(struct pt_regs *regs);
+
+#endif /* __ASM_ERROR_INJECTION_H_ */
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index dad858b6adc6..3aafbbe218a2 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -294,6 +294,11 @@ static inline unsigned long regs_return_value(struct pt_regs *regs)
 	return regs->regs[0];
 }
 
+static inline void regs_set_return_value(struct pt_regs *regs, unsigned long rc)
+{
+	regs->regs[0] = rc;
+}
+
 /**
  * regs_get_kernel_argument() - get Nth function argument in kernel
  * @regs:	pt_regs of that context
diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index 33c2a4abda04..f182ccb0438e 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -33,3 +33,5 @@ UBSAN_SANITIZE_atomic_ll_sc.o	:= n
 lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
 
 obj-$(CONFIG_CRC32) += crc32.o
+
+obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
diff --git a/arch/arm64/lib/error-inject.c b/arch/arm64/lib/error-inject.c
new file mode 100644
index 000000000000..35661c2de4b0
--- /dev/null
+++ b/arch/arm64/lib/error-inject.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/error-injection.h>
+#include <linux/kprobes.h>
+
+void override_function_with_return(struct pt_regs *regs)
+{
+	/*
+	 * 'regs' represents the state on entry of a predefined function in
+	 * the kernel/module and which is captured on a kprobe.
+	 *
+	 * 'regs->regs[30]' contains the the link register for the probed
+	 * function and assign it to 'regs->pc', so when kprobe returns
+	 * back from exception it will override the end of probed function
+	 * and drirectly return to the predefined function's caller.
+	 */
+	regs->pc = regs->regs[30];
+}
+NOKPROBE_SYMBOL(override_function_with_return);
-- 
2.17.1

