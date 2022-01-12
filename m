Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3A248C57A
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242266AbiALODa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353895AbiALODX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:03:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF5BC061759;
        Wed, 12 Jan 2022 06:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4103560C03;
        Wed, 12 Jan 2022 14:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B141FC36AE5;
        Wed, 12 Jan 2022 14:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641996196;
        bh=p7jQZb2SjvJICJ40fF0z8P2smX9k+bKbPIwO6eKJTos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sz5diZg2YG+Qm7gIUBqEUa8I2Xv/wABYjKFsqxnamV8b9Psxi7wtodDTryuHA2COo
         upKfSPDCP4RE9Ozbm2cfjjOt6EDrfKXqF3WB+P/dclCUV6PfDvfCQzv3KFhXw1qO8Q
         OLWoHkUxgw9Z2mboHdG7UERtqCmb9iUDLZdLdVDRNpvgdpwveQ7+cE32BKegmcMv+a
         FWzomW+0aSRh+LlVB9+LX5gFdAcxNEIQgOT6ntyAPMqBYqTOIXIWc3EuNlZ3ZIGtZc
         KoSlj/QwO22CIs9e4WgW+MDD2SzzJLJtHbAiWohCw2VE/TkZtScpFNmyq6MbB0WKrJ
         0gKGYAy2XpZIg==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [RFC PATCH v2 2/8] fprobe: Add ftrace based probe APIs
Date:   Wed, 12 Jan 2022 23:03:10 +0900
Message-Id: <164199619000.1247129.1034324609530250036.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164199616622.1247129.783024987490980883.stgit@devnote2>
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fprobe is a wrapper API for ftrace function tracer.
Unlike kprobes, this probes only supports the function entry, but
it can probe multiple functions by one fprobe. The usage is almost
same as the kprobe, user will specify the function names by
fprobe::syms, the number of syms by fprobe::nentry,
and the user handler by fprobe::entry_handler.

struct fprobe fp = { 0 };
const char *targets[] = { "func1", "func2", "func3"};

fp.handler = user_handler;
fp.nentry = ARRAY_SIZE(targets);
fp.syms = targets;

ret = register_fprobe(&fp);

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v2:
  - Remove fprobe_entry.
  - Do not sort the address array since there is no user private data.
  - Since there is only "fprobe", make filename and config name "fprobe".
  - Use ftrace_set_filter_ips()
  - Fix style warnings.
---
 include/linux/fprobe.h |   53 +++++++++++++++++++++++
 kernel/trace/Kconfig   |   10 ++++
 kernel/trace/Makefile  |    1 
 kernel/trace/fprobe.c  |  113 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 177 insertions(+)
 create mode 100644 include/linux/fprobe.h
 create mode 100644 kernel/trace/fprobe.c

diff --git a/include/linux/fprobe.h b/include/linux/fprobe.h
new file mode 100644
index 000000000000..614d28d5828b
--- /dev/null
+++ b/include/linux/fprobe.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Simple ftrace probe wrapper */
+#ifndef _LINUX_FPROBE_H
+#define _LINUX_FPROBE_H
+
+#include <linux/compiler.h>
+#include <linux/ftrace.h>
+
+struct fprobe {
+	const char		**syms;
+	unsigned long		*addrs;
+	unsigned int		nentry;
+
+	struct ftrace_ops	ftrace;
+	unsigned long		nmissed;
+	unsigned int		flags;
+	void (*entry_handler)(struct fprobe *fp, unsigned long entry_ip, struct pt_regs *regs);
+};
+
+#define FPROBE_FL_DISABLED	1
+
+static inline bool fprobe_disabled(struct fprobe *fp)
+{
+	return (fp) ? fp->flags & FPROBE_FL_DISABLED : false;
+}
+
+#ifdef CONFIG_FPROBE
+int register_fprobe(struct fprobe *fp);
+int unregister_fprobe(struct fprobe *fp);
+#else
+static inline int register_fprobe(struct fprobe *fp)
+{
+	return -EOPNOTSUPP;
+}
+static inline int unregister_fprobe(struct fprobe *fp)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+static inline void disable_fprobe(struct fprobe *fp)
+{
+	if (fp)
+		fp->flags |= FPROBE_FL_DISABLED;
+}
+
+static inline void enable_fprobe(struct fprobe *fp)
+{
+	if (fp)
+		fp->flags &= ~FPROBE_FL_DISABLED;
+}
+
+#endif
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 420ff4bc67fd..6834b0272798 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -223,6 +223,16 @@ config DYNAMIC_FTRACE_WITH_ARGS
 	depends on DYNAMIC_FTRACE
 	depends on HAVE_DYNAMIC_FTRACE_WITH_ARGS
 
+config FPROBE
+	bool "Kernel Function Probe (fprobe)"
+	depends on FUNCTION_TRACER
+	depends on DYNAMIC_FTRACE_WITH_REGS
+	default n
+	help
+	  This option enables kernel function probe feature, which is
+	  similar to kprobes, but probes only for kernel function entries
+	  and it can probe multiple functions by one fprobe.
+
 config FUNCTION_PROFILER
 	bool "Kernel function profiler"
 	depends on FUNCTION_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index bedc5caceec7..79255f9de9a4 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -97,6 +97,7 @@ obj-$(CONFIG_PROBE_EVENTS) += trace_probe.o
 obj-$(CONFIG_UPROBE_EVENTS) += trace_uprobe.o
 obj-$(CONFIG_BOOTTIME_TRACING) += trace_boot.o
 obj-$(CONFIG_FTRACE_RECORD_RECURSION) += trace_recursion_record.o
+obj-$(CONFIG_FPROBE) += fprobe.o
 
 obj-$(CONFIG_TRACEPOINT_BENCHMARK) += trace_benchmark.o
 
diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
new file mode 100644
index 000000000000..0247fc7d75e2
--- /dev/null
+++ b/kernel/trace/fprobe.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * fprobe - Simple ftrace probe wrapper for function entry.
+ */
+#define pr_fmt(fmt) "fprobe: " fmt
+
+#include <linux/fprobe.h>
+#include <linux/kallsyms.h>
+#include <linux/kprobes.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+
+static void fprobe_handler(unsigned long ip, unsigned long parent_ip,
+			   struct ftrace_ops *ops, struct ftrace_regs *fregs)
+{
+	struct fprobe *fp;
+	int bit;
+
+	fp = container_of(ops, struct fprobe, ftrace);
+	if (fprobe_disabled(fp))
+		return;
+
+	bit = ftrace_test_recursion_trylock(ip, parent_ip);
+	if (bit < 0) {
+		fp->nmissed++;
+		return;
+	}
+
+	if (fp->entry_handler)
+		fp->entry_handler(fp, ip, ftrace_get_regs(fregs));
+
+	ftrace_test_recursion_unlock(bit);
+}
+NOKPROBE_SYMBOL(fprobe_handler);
+
+static int convert_func_addresses(struct fprobe *fp)
+{
+	unsigned int i;
+
+	if (!fp->syms)
+		return 0;
+
+	fp->addrs = kcalloc(fp->nentry, sizeof(*fp->addrs), GFP_KERNEL);
+	if (!fp->addrs)
+		return -ENOMEM;
+
+	for (i = 0; i < fp->nentry; i++) {
+
+		fp->addrs[i] = kallsyms_lookup_name(fp->syms[i]);
+		if (!fp->addrs[i])
+			return -ENOENT;
+	}
+
+	return 0;
+}
+
+/**
+ * register_fprobe - Register fprobe to ftrace
+ * @fp: A fprobe data structure to be registered.
+ *
+ * This expects the user set @fp::entry_handler, @fp::syms or @fp:addrs,
+ * and @fp::nentry.
+ * Note that you do not set both of @fp::addrs and @fp::syms.
+ */
+int register_fprobe(struct fprobe *fp)
+{
+	int ret;
+
+	if (!fp || !fp->nentry || (!fp->syms && !fp->addrs) ||
+	    (fp->syms && fp->addrs))
+		return -EINVAL;
+
+	ret = convert_func_addresses(fp);
+	if (ret < 0)
+		return ret;
+
+	fp->nmissed = 0;
+	fp->ftrace.func = fprobe_handler;
+	fp->ftrace.flags = FTRACE_OPS_FL_SAVE_REGS;
+
+	ret = ftrace_set_filter_ips(&fp->ftrace, fp->addrs, fp->nentry, 0, 0);
+	if (!ret)
+		ret = register_ftrace_function(&fp->ftrace);
+
+	if (ret < 0 && fp->syms) {
+		kfree(fp->addrs);
+		fp->addrs = NULL;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_fprobe);
+
+/**
+ * unregister_fprobe - Unregister fprobe from ftrace
+ * @fp: A fprobe data structure to be unregistered.
+ */
+int unregister_fprobe(struct fprobe *fp)
+{
+	int ret;
+
+	if (!fp || !fp->nentry || !fp->addrs)
+		return -EINVAL;
+
+	ret = unregister_ftrace_function(&fp->ftrace);
+
+	if (!ret && fp->syms) {
+		kfree(fp->addrs);
+		fp->addrs = NULL;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(unregister_fprobe);

