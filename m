Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFAF49B398
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 13:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359686AbiAYMOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 07:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381740AbiAYMMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 07:12:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099F7C06175E;
        Tue, 25 Jan 2022 04:12:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B70761045;
        Tue, 25 Jan 2022 12:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEBAC340E0;
        Tue, 25 Jan 2022 12:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643112724;
        bh=m7ibbKHpWVQBu/3gr81hx7eQv/D+ctWUXEn5hMAkDq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OA2CCf801DVTj7PD6EicqzuKdrIpqpAsuGCNj3RYkVegE+KqFXBbSh9XqMlxoBdzt
         Hhegx6ZHU4BC55mOVB3OoWGapcEys+ehV3bap+1ivJWs9qt5W2oJe7Ut7yL5h3CL/C
         5Ztl3/ni21K8AF7MCxqE5DyT9rCWvmFzljc/DsUxYcKPxFMCVy4ezrOuXJBCvH+I1c
         D2EXc2r4tpjG49cNsNhD1S6L4yXAVeJoFrrE4+HtZ9tQBuyIauzFbH//hmIEG/umKu
         Haud+Waac6TyTHdo7X8TV0i6xnmPhp7g3eSV6nfrjWdDrtvhWhozh4KlzeidqwSE5M
         oP+UoipmzuJ/g==
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
Subject: [PATCH v5 2/9] fprobe: Add ftrace based probe APIs
Date:   Tue, 25 Jan 2022 21:11:57 +0900
Message-Id: <164311271777.1933078.9066058105807126444.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164311269435.1933078.6963769885544050138.stgit@devnote2>
References: <164311269435.1933078.6963769885544050138.stgit@devnote2>
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

CAUTION: if user entry handler changes registers including
ip address, it will be applied when returns from the
entry handler. So user handler must recover it.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v4:
  - Fix a memory leak when symbol lookup failed.
  - Use ftrace location address instead of symbol address.
  - Convert the given symbol address to ftrace location automatically.
  - Rename fprobe::ftrace to fprobe::ops.
  - Update the Kconfig description.
---
 include/linux/fprobe.h |   80 ++++++++++++++++++++++++++++
 kernel/trace/Kconfig   |   12 ++++
 kernel/trace/Makefile  |    1 
 kernel/trace/fprobe.c  |  135 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 228 insertions(+)
 create mode 100644 include/linux/fprobe.h
 create mode 100644 kernel/trace/fprobe.c

diff --git a/include/linux/fprobe.h b/include/linux/fprobe.h
new file mode 100644
index 000000000000..f7de332b08c2
--- /dev/null
+++ b/include/linux/fprobe.h
@@ -0,0 +1,80 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Simple ftrace probe wrapper */
+#ifndef _LINUX_FPROBE_H
+#define _LINUX_FPROBE_H
+
+#include <linux/compiler.h>
+#include <linux/ftrace.h>
+
+/**
+ * struct fprobe - ftrace based probe.
+ * @syms: The array of symbols to probe.
+ * @addrs: The array of ftrace address of the symbols.
+ * @nentry: The number of entries of @syms or @addrs.
+ * @ops: The ftrace_ops.
+ * @nmissed: The counter for missing events.
+ * @flags: The status flag.
+ * @entry_handler: The callback function for function entry.
+ *
+ * User must set either @syms or @addrs, but not both. If user sets
+ * only @syms, the @addrs are generated when registering the fprobe.
+ * That auto-generated @addrs will be freed when unregistering.
+ */
+struct fprobe {
+	const char		**syms;
+	unsigned long		*addrs;
+	unsigned int		nentry;
+
+	struct ftrace_ops	ops;
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
+/**
+ * disable_fprobe() - Disable fprobe
+ * @fp: The fprobe to be disabled.
+ *
+ * This will soft-disable @fp. Note that this doesn't remove the ftrace
+ * hooks from the function entry.
+ */
+static inline void disable_fprobe(struct fprobe *fp)
+{
+	if (fp)
+		fp->flags |= FPROBE_FL_DISABLED;
+}
+
+/**
+ * enable_fprobe() - Enable fprobe
+ * @fp: The fprobe to be enabled.
+ *
+ * This will soft-enable @fp.
+ */
+static inline void enable_fprobe(struct fprobe *fp)
+{
+	if (fp)
+		fp->flags &= ~FPROBE_FL_DISABLED;
+}
+
+#endif
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 420ff4bc67fd..23483dd474b0 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -223,6 +223,18 @@ config DYNAMIC_FTRACE_WITH_ARGS
 	depends on DYNAMIC_FTRACE
 	depends on HAVE_DYNAMIC_FTRACE_WITH_ARGS
 
+config FPROBE
+	bool "Kernel Function Probe (fprobe)"
+	depends on FUNCTION_TRACER
+	depends on DYNAMIC_FTRACE_WITH_REGS
+	default n
+	help
+	  This option enables kernel function probe (fprobe) based on ftrace,
+	  which is similar to kprobes, but probes only for kernel function
+	  entries and it can probe multiple functions by one fprobe.
+
+	  If unsure, say N.
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
index 000000000000..748cc34765c1
--- /dev/null
+++ b/kernel/trace/fprobe.c
@@ -0,0 +1,135 @@
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
+	fp = container_of(ops, struct fprobe, ops);
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
+/* Convert ftrace location address from symbols */
+static int convert_func_addresses(struct fprobe *fp)
+{
+	unsigned long addr, size;
+	unsigned int i;
+
+	/* Convert symbols to symbol address */
+	if (fp->syms) {
+		fp->addrs = kcalloc(fp->nentry, sizeof(*fp->addrs), GFP_KERNEL);
+		if (!fp->addrs)
+			return -ENOMEM;
+
+		for (i = 0; i < fp->nentry; i++) {
+			fp->addrs[i] = kallsyms_lookup_name(fp->syms[i]);
+			if (!fp->addrs[i])	/* Maybe wrong symbol */
+				goto error;
+		}
+	}
+
+	/* Convert symbol address to ftrace location. */
+	for (i = 0; i < fp->nentry; i++) {
+		if (!kallsyms_lookup_size_offset(fp->addrs[i], &size, NULL))
+			size = MCOUNT_INSN_SIZE;
+		addr = ftrace_location_range(fp->addrs[i], fp->addrs[i] + size);
+		if (!addr) /* No dynamic ftrace there. */
+			goto error;
+		fp->addrs[i] = addr;
+	}
+
+	return 0;
+
+error:
+	kfree(fp->addrs);
+	fp->addrs = NULL;
+	return -ENOENT;
+}
+
+/**
+ * register_fprobe() - Register fprobe to ftrace
+ * @fp: A fprobe data structure to be registered.
+ *
+ * This expects the user set @fp::entry_handler, @fp::syms or @fp:addrs,
+ * and @fp::nentry. If @fp::addrs are set, that will be updated to point
+ * the ftrace location. If @fp::addrs are NULL, this will generate it
+ * from @fp::syms.
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
+	fp->ops.func = fprobe_handler;
+	fp->ops.flags = FTRACE_OPS_FL_SAVE_REGS;
+
+	ret = ftrace_set_filter_ips(&fp->ops, fp->addrs, fp->nentry, 0, 0);
+	if (!ret)
+		ret = register_ftrace_function(&fp->ops);
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
+ * unregister_fprobe() - Unregister fprobe from ftrace
+ * @fp: A fprobe data structure to be unregistered.
+ *
+ * Unregister fprobe (and remove ftrace hooks from the function entries).
+ * If the @fp::addrs are generated by register_fprobe(), it will be removed
+ * automatically.
+ */
+int unregister_fprobe(struct fprobe *fp)
+{
+	int ret;
+
+	if (!fp || !fp->nentry || !fp->addrs)
+		return -EINVAL;
+
+	ret = unregister_ftrace_function(&fp->ops);
+
+	if (!ret && fp->syms) {
+		kfree(fp->addrs);
+		fp->addrs = NULL;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(unregister_fprobe);

