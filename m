Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A800049FBB5
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349214AbiA1Oca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349173AbiA1Oc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:32:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BA8C061714;
        Fri, 28 Jan 2022 06:32:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E594B825E2;
        Fri, 28 Jan 2022 14:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CE7C340E0;
        Fri, 28 Jan 2022 14:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643380345;
        bh=LzjfyYITlL5c8457AaPXwj5HT+7bR1gg4cDQJKko9ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPAhBALsCKyj9Xje40Q5eW1Wg9rPPfIz1cXwASkfW9iYT9Dgj3SR7Q9Asj/Uge7C9
         N2Ym7ROpeH23g7NxIgiErVey/CAhx5arl8QqmMyRkDKN6dxHtwII+2kAeBk9ltVeuc
         TI8w/5tRllv6owpt58XEJnqPnPr6GAlyP+CVxmNx36SwctnNUEY/++MQi+LbEOGvaw
         pSmQ3be1b9OtQFWQb2H/zLd8mxqf7B1II+QCl7Tw9+u9eJhPV7X+/xyeReG0joRu1P
         ZzJTDBR103ZE4MwlAciectbCLH96lqYUQNYXJvw+f40xPJoof9hc6yGofEy4c8GkFc
         CzByIIGUKHvwA==
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
Subject: [PATCH v6 02/10] fprobe: Add ftrace based probe APIs
Date:   Fri, 28 Jan 2022 23:32:20 +0900
Message-Id: <164338033976.2429999.2190780967800082410.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164338031590.2429999.6203979005944292576.stgit@devnote2>
References: <164338031590.2429999.6203979005944292576.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fprobe is a wrapper API for ftrace function tracer.
Unlike kprobes, this probes only supports the function entry, but this
can probe multiple functions by one fprobe. The usage is similar, user
will set their callback to fprobe::entry_handler and call
register_fprobe*() with probed functions.
There are 3 registration interfaces,

 - register_fprobe() takes filtering patterns of the functin names.
 - register_fprobe_ips() takes an array of ftrace-location addresses.
 - register_fprobe_syms() takes an array of function names.

The registered fprobes can be unregistered with unregister_fprobe().
e.g.

struct fprobe fp = { .entry_handler = user_handler };
const char *targets[] = { "func1", "func2", "func3"};
...

ret = register_fprobe_syms(&fp, targets, ARRAY_SIZE(targets));

...

unregister_fprobe(&fp);

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v6:
  - Remove syms, addrs, and nentry fields from struct fprobe.
  - Introduce 3 variants of registration functions.
  - Call ftrace_free_filter() at unregistration.

 Changes in v4:
  - Fix a memory leak when symbol lookup failed.
  - Use ftrace location address instead of symbol address.
  - Convert the given symbol address to ftrace location automatically.
  - Rename fprobe::ftrace to fprobe::ops.
  - Update the Kconfig description.
---
 include/linux/fprobe.h |   79 +++++++++++++++++
 kernel/trace/Kconfig   |   12 +++
 kernel/trace/Makefile  |    1 
 kernel/trace/fprobe.c  |  219 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 311 insertions(+)
 create mode 100644 include/linux/fprobe.h
 create mode 100644 kernel/trace/fprobe.c

diff --git a/include/linux/fprobe.h b/include/linux/fprobe.h
new file mode 100644
index 000000000000..b920dc1b2969
--- /dev/null
+++ b/include/linux/fprobe.h
@@ -0,0 +1,79 @@
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
+ * @ops: The ftrace_ops.
+ * @nmissed: The counter for missing events.
+ * @flags: The status flag.
+ * @entry_handler: The callback function for function entry.
+ */
+struct fprobe {
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
+int register_fprobe(struct fprobe *fp, const char *filter, const char *notfilter);
+int register_fprobe_ips(struct fprobe *fp, unsigned long *addrs, int num);
+int register_fprobe_syms(struct fprobe *fp, const char **syms, int num);
+int unregister_fprobe(struct fprobe *fp);
+#else
+static inline int register_fprobe(struct fprobe *fp, const char *filter, const char *notfilter)
+{
+	return -EOPNOTSUPP;
+}
+static inline int register_fprobe_ips(struct fprobe *fp, unsigned long *addrs, int num)
+{
+	return -EOPNOTSUPP;
+}
+static inline int register_fprobe_syms(struct fprobe *fp, const char **syms, int num)
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
index 752ed89a293b..043c8f6c4075 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -230,6 +230,18 @@ config DYNAMIC_FTRACE_WITH_ARGS
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
index 000000000000..081aef6bf531
--- /dev/null
+++ b/kernel/trace/fprobe.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * fprobe - Simple ftrace probe wrapper for function entry.
+ */
+#define pr_fmt(fmt) "fprobe: " fmt
+
+#include <linux/err.h>
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
+static unsigned long *get_ftrace_locations(const char **syms, int num)
+{
+	unsigned long *addrs, addr, size;
+	int i;
+
+	/* Convert symbols to symbol address */
+	addrs = kcalloc(num, sizeof(*addrs), GFP_KERNEL);
+	if (!addrs)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < num; i++) {
+		addrs[i] = kallsyms_lookup_name(syms[i]);
+		if (!addrs[i])	/* Maybe wrong symbol */
+			goto error;
+	}
+
+	/* Convert symbol address to ftrace location. */
+	for (i = 0; i < num; i++) {
+		if (!kallsyms_lookup_size_offset(addrs[i], &size, NULL))
+			size = MCOUNT_INSN_SIZE;
+		addr = ftrace_location_range(addrs[i], addrs[i] + size - 1);
+		if (!addr) /* No dynamic ftrace there. */
+			goto error;
+		addrs[i] = addr;
+	}
+
+	return addrs;
+
+error:
+	kfree(addrs);
+
+	return ERR_PTR(-ENOENT);
+}
+
+static void fprobe_init(struct fprobe *fp)
+{
+	fp->nmissed = 0;
+	fp->ops.func = fprobe_handler;
+	fp->ops.flags |= FTRACE_OPS_FL_SAVE_REGS;
+}
+
+/**
+ * register_fprobe() - Register fprobe to ftrace by pattern.
+ * @fp: A fprobe data structure to be registered.
+ * @filter: A wildcard pattern of target symbols.
+ * @notfilter: A wildcard pattern of NON target symbols.
+ *
+ * Register @fp to @filter symbols. If @notfilter is not NULL, the symbols
+ * which match the @notfilter is removed from the target.
+ *
+ * Return 0 if @fp is registered successfully, -errno if not.
+ */
+int register_fprobe(struct fprobe *fp, const char *filter, const char *notfilter)
+{
+	unsigned char *str;
+	int ret, len;
+
+	if (!fp || !filter)
+		return -EINVAL;
+
+	fprobe_init(fp);
+
+	len = strlen(filter);
+	str = kstrdup(filter, GFP_KERNEL);
+	ret = ftrace_set_filter(&fp->ops, str, len, 0);
+	kfree(str);
+	if (ret)
+		return ret;
+
+	if (notfilter) {
+		len = strlen(notfilter);
+		str = kstrdup(notfilter, GFP_KERNEL);
+		ret = ftrace_set_notrace(&fp->ops, str, len, 0);
+		kfree(str);
+		if (ret)
+			goto out;
+	}
+
+	ret = register_ftrace_function(&fp->ops);
+out:
+	if (ret)
+		ftrace_free_filter(&fp->ops);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_fprobe);
+
+/**
+ * register_fprobe_ips() - Register fprobe to ftrace by address.
+ * @fp: A fprobe data structure to be registered.
+ * @addrs: An array of target ftrace location addresses.
+ * @num: The number of entries of @addrs.
+ *
+ * Register @fp to the address given by @addrs. The @addrs must be the
+ * addresses of ftrace location address, which may be the symbol address +
+ * arch-dependent offset. If you unsure what this mean, please use other
+ * registration functions.
+ *
+ * Return 0 if @fp is registered successfully, -errno if not.
+ */
+int register_fprobe_ips(struct fprobe *fp, unsigned long *addrs, int num)
+{
+	int ret;
+
+	if (!fp || !addrs || num <= 0)
+		return -EINVAL;
+
+	fprobe_init(fp);
+
+	ret = ftrace_set_filter_ips(&fp->ops, addrs, num, 0, 0);
+	if (!ret)
+		ret = register_ftrace_function(&fp->ops);
+
+	if (ret)
+		ftrace_free_filter(&fp->ops);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_fprobe_ips);
+
+/**
+ * register_fprobe_syms() - Register fprobe to ftrace by symbols.
+ * @fp: A fprobe data structure to be registered.
+ * @syms: An array of target symbols.
+ * @num: The number of entries of @syms.
+ *
+ * Register @fp to the symbols given by @syms.
+ *
+ * Return 0 if @fp is registered successfully, -errno if not.
+ */
+int register_fprobe_syms(struct fprobe *fp, const char **syms, int num)
+{
+	unsigned long *addrs;
+	int ret;
+
+	if (!fp || !syms || num <= 0)
+		return -EINVAL;
+
+	fprobe_init(fp);
+
+	addrs = get_ftrace_locations(syms, num);
+	if (IS_ERR(addrs))
+		return PTR_ERR(addrs);
+
+	ret = ftrace_set_filter_ips(&fp->ops, addrs, num, 0, 0);
+	if (ret)
+		goto out;
+	ret = register_ftrace_function(&fp->ops);
+	if (ret)
+		ftrace_free_filter(&fp->ops);
+
+out:
+	kfree(addrs);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_fprobe_syms);
+
+/**
+ * unregister_fprobe() - Unregister fprobe from ftrace
+ * @fp: A fprobe data structure to be unregistered.
+ *
+ * Unregister fprobe (and remove ftrace hooks from the function entries).
+ * If the @fp::addrs are generated by register_fprobe(), it will be removed
+ * automatically.
+ *
+ * Return 0 if @fp is unregistered successfully, -errno if not.
+ */
+int unregister_fprobe(struct fprobe *fp)
+{
+	int ret;
+
+	if (!fp || fp->ops.func != fprobe_handler)
+		return -EINVAL;
+
+	ret = unregister_ftrace_function(&fp->ops);
+
+	if (!ret)
+		ftrace_free_filter(&fp->ops);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(unregister_fprobe);

