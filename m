Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E51948B018
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 16:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243213AbiAKPAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 10:00:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57552 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243159AbiAKPAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 10:00:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A500B81B35;
        Tue, 11 Jan 2022 15:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AADC36AEB;
        Tue, 11 Jan 2022 15:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641913235;
        bh=CPGGc6dq/couLDlKjtLJltKyuODKvJvMhk+enUJpnGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pt42SuOCrLWTA8x192pPS9eP/2QifxvtsEHlHeg8mE/fX+SLdiEx9JHFsqSgfq2lX
         vydCB4rPzt+aEUYJm4/wZfL3h3b+ENOT/uVV7e0sUMLu0UgY1EiT0nSC4W/WGPxM6a
         532oubRPwBvBcCoZGvGmcUOfWmGzpw0hR9BXfP8eB/s7qokuvSn4G2+9KYHriR6got
         IeO8wrB9DJcMUIahZXY/39fKQhdCf7E1N7Hc32s1SO6FQl0PyrxZ/SoBTM8Hf6hv0m
         QsG5+ijszPv89qTzEWd2UTXh1XbdMGMe/YeYl2c7orMGMXr/1N31pfsQgCsfjIozxz
         527CztXfUAojg==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Subject: [RFC PATCH 1/6] fprobe: Add ftrace based probe APIs
Date:   Wed, 12 Jan 2022 00:00:30 +0900
Message-Id: <164191322984.806991.3666707512798363619.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164191321766.806991.7930388561276940676.stgit@devnote2>
References: <164191321766.806991.7930388561276940676.stgit@devnote2>
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
fprobe::entries[].syms, the number of syms by fprobe::nentry,
and the user handler by fprobe::entry_handler.

struct fprobe fp = { 0 };
struct fprobe_entry targets[] =
	{{.sym = "func1"}, {.sym = "func2"}, {.sym = "func3"}};

fp.handler = user_handler;
fp.nentry = ARRAY_SIZE(targets);

fp.entries = targets;

ret = register_fprobe(&fp);


Note that the fp::entries will be sorted by the converted
function address.


Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 include/linux/fprobes.h |   71 +++++++++++++++++++++++++
 kernel/trace/Kconfig    |   10 ++++
 kernel/trace/Makefile   |    1 
 kernel/trace/fprobes.c  |  132 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 214 insertions(+)
 create mode 100644 include/linux/fprobes.h
 create mode 100644 kernel/trace/fprobes.c

diff --git a/include/linux/fprobes.h b/include/linux/fprobes.h
new file mode 100644
index 000000000000..fa85a2fc3ad1
--- /dev/null
+++ b/include/linux/fprobes.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Simple ftrace probe wrapper */
+#ifndef _LINUX_FPROBES_H
+#define _LINUX_FPROBES_H
+
+#include <linux/compiler.h>
+#include <linux/ftrace.h>
+
+/*
+ * fprobe_entry - function entry for fprobe
+ * @sym: The symbol name of the function.
+ * @addr: The address of @sym.
+ * @data: per-entry data
+ *
+ * User must specify either @sym or @addr (not both). @data is optional.
+ */
+struct fprobe_entry {
+	const char	*sym;
+	unsigned long	addr;
+	void		*data;
+};
+
+struct fprobe {
+	struct fprobe_entry	*entries;
+	unsigned int		nentry;
+
+	struct ftrace_ops	ftrace;
+	unsigned long		nmissed;
+	unsigned int		flags;
+	void (*entry_handler) (struct fprobe *, unsigned long, struct pt_regs *);
+};
+
+#define FPROBE_FL_DISABLED	1
+
+static inline bool fprobe_disabled(struct fprobe *fp)
+{
+	return (fp) ? fp->flags & FPROBE_FL_DISABLED : false;
+}
+
+#ifdef CONFIG_FPROBES
+int register_fprobe(struct fprobe *fp);
+int unregister_fprobe(struct fprobe *fp);
+struct fprobe_entry *fprobe_find_entry(struct fprobe *fp, unsigned long addr);
+#else
+static inline int register_fprobe(struct fprobe *fp)
+{
+	return -ENOTSUPP;
+}
+static inline int unregister_fprobe(struct fprobe *fp)
+{
+	return -ENOTSUPP;
+}
+struct fprobe_entry *fprobe_find_entry(struct fprobe *fp, unsigned long addr)
+{
+	return NULL;
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
index 420ff4bc67fd..45a3618a20a7 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -223,6 +223,16 @@ config DYNAMIC_FTRACE_WITH_ARGS
 	depends on DYNAMIC_FTRACE
 	depends on HAVE_DYNAMIC_FTRACE_WITH_ARGS
 
+config FPROBES
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
index bedc5caceec7..47a37a3bb974 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -97,6 +97,7 @@ obj-$(CONFIG_PROBE_EVENTS) += trace_probe.o
 obj-$(CONFIG_UPROBE_EVENTS) += trace_uprobe.o
 obj-$(CONFIG_BOOTTIME_TRACING) += trace_boot.o
 obj-$(CONFIG_FTRACE_RECORD_RECURSION) += trace_recursion_record.o
+obj-$(CONFIG_FPROBES) += fprobes.o
 
 obj-$(CONFIG_TRACEPOINT_BENCHMARK) += trace_benchmark.o
 
diff --git a/kernel/trace/fprobes.c b/kernel/trace/fprobes.c
new file mode 100644
index 000000000000..0a609093d48c
--- /dev/null
+++ b/kernel/trace/fprobes.c
@@ -0,0 +1,132 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt) "fprobes: " fmt
+
+#include <linux/fprobes.h>
+#include <linux/kallsyms.h>
+#include <linux/kprobes.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+
+static void fprobe_handler(unsigned long ip, unsigned long parent_ip,
+			struct ftrace_ops *ops, struct ftrace_regs *fregs)
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
+	struct fprobe_entry *ent = fp->entries;
+
+	for (i = 0; i < fp->nentry; i++) {
+		if ((ent[i].sym && ent[i].addr) ||
+		    (!ent[i].sym && !ent[i].addr))
+			return -EINVAL;
+
+		if (ent[i].addr)
+			continue;
+
+		ent[i].addr = kallsyms_lookup_name(ent[i].sym);
+		if (!ent[i].addr)
+			return -ENOENT;
+	}
+
+	return 0;
+}
+
+/* Since the entry list is sorted, we can search it by bisect */
+struct fprobe_entry *fprobe_find_entry(struct fprobe *fp, unsigned long addr)
+{
+	int d, n;
+
+	d = n = fp->nentry / 2;
+
+	while (fp->entries[n].addr != addr) {
+		d /= 2;
+		if (d == 0)
+			return NULL;
+		if (fp->entries[n].addr < addr)
+			n += d;
+		else
+			n -= d;
+	}
+
+	return fp->entries + n;
+}
+EXPORT_SYMBOL_GPL(fprobe_find_entry);
+
+static int fprobe_comp_func(const void *a, const void *b)
+{
+	return ((struct fprobe_entry *)a)->addr - ((struct fprobe_entry *)b)->addr;
+}
+
+/**
+ * register_fprobe - Register fprobe to ftrace
+ * @fp: A fprobe data structure to be registered.
+ *
+ * This expects the user set @fp::entry_handler, @fp::entries and @fp::nentry.
+ * For each entry of @fp::entries[], user must set 'addr' or 'sym'.
+ * Note that you do not set both of 'addr' and 'sym' of the entry.
+ */
+int register_fprobe(struct fprobe *fp)
+{
+	unsigned int i;
+	int ret;
+
+	if (!fp || !fp->nentry || !fp->entries)
+		return -EINVAL;
+
+	ret = convert_func_addresses(fp);
+	if (ret < 0)
+		return ret;
+	/*
+	 * Sort the addresses so that the handler can find corresponding user data
+	 * immediately.
+	 */
+	sort(fp->entries, fp->nentry, sizeof(*fp->entries),
+	     fprobe_comp_func, NULL);
+
+	fp->nmissed = 0;
+	fp->ftrace.func = fprobe_handler;
+	fp->ftrace.flags = FTRACE_OPS_FL_SAVE_REGS;
+
+	for (i = 0; i < fp->nentry; i++) {
+		ret = ftrace_set_filter_ip(&fp->ftrace, fp->entries[i].addr, 0, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	return register_ftrace_function(&fp->ftrace);
+}
+EXPORT_SYMBOL_GPL(register_fprobe);
+
+/**
+ * unregister_fprobe - Unregister fprobe from ftrace
+ * @fp: A fprobe data structure to be unregistered.
+ */
+int unregister_fprobe(struct fprobe *fp)
+{
+	if (!fp || !fp->nentry || !fp->entries)
+		return -EINVAL;
+
+	return unregister_ftrace_function(&fp->ftrace);
+}
+EXPORT_SYMBOL_GPL(unregister_fprobe);

