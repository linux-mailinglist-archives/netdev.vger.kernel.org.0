Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC2C498463
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243613AbiAXQLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243353AbiAXQLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:11:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F106C061747;
        Mon, 24 Jan 2022 08:11:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 161F9B80B36;
        Mon, 24 Jan 2022 16:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD8CC340E5;
        Mon, 24 Jan 2022 16:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643040658;
        bh=b5cSC0Voo0MtqAVukvSA69tutmiwlNEMrP3tolpDRq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+tsGi31qRkGqtA2F4liVa/mcrJ+TEpgfkrkzLj34Rx/fTEqzDEPoEt41B6sFHgkR
         oTi6e9DdQjvnEExrltvIZw/dXBkjjFNjoMzVpAzKM1N9EgpJF817JH0SqTxcmeqr+z
         VDVBfIQhpW2UHlM525vGNiO4+bDTBwZq6tbQAB7oPIXLgcXgy6RfugnrqFCUiHAiNY
         Xt4/8bz8zGIWfj4SbFQ3d5CWrGt95H30tKnQc7TZLXNuSdWSqX0751pvJw7khOiQ7W
         CSDidUwtqGoNTzPmgaXJsYZZNKTTE8b31DP0IH/7YXfhYuwigCsIvAgDE/oqsuiiZT
         DSBb1ajYS8LLw==
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
Subject: [PATCH v4 8/9] fprobe: Add sample program for fprobe
Date:   Tue, 25 Jan 2022 01:10:53 +0900
Message-Id: <164304065309.1680787.2638145579299507637.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164304056155.1680787.14081905648619647218.stgit@devnote2>
References: <164304056155.1680787.14081905648619647218.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a sample program for the fprobe.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v2:
  - Fix infinit loop for multiple symbols.
  - Fix memory leaks for copied string and entry array.
  - Update for new fprobe APIs.
  - Fix style issues.
---
 samples/Kconfig                 |    7 +++
 samples/Makefile                |    1 
 samples/fprobe/Makefile         |    3 +
 samples/fprobe/fprobe_example.c |  103 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 114 insertions(+)
 create mode 100644 samples/fprobe/Makefile
 create mode 100644 samples/fprobe/fprobe_example.c

diff --git a/samples/Kconfig b/samples/Kconfig
index 43d2e9aa557f..e010c2c1256c 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -73,6 +73,13 @@ config SAMPLE_HW_BREAKPOINT
 	help
 	  This builds kernel hardware breakpoint example modules.
 
+config SAMPLE_FPROBE
+	tristate "Build fprobe examples -- loadable modules only"
+	depends on FPROBE && m
+	help
+	  This builds a fprobe example module. This module has an option 'symbol'.
+	  You can specify a probed symbol or symbols separated with ','.
+
 config SAMPLE_KFIFO
 	tristate "Build kfifo examples -- loadable modules only"
 	depends on m
diff --git a/samples/Makefile b/samples/Makefile
index 4bcd6b93bffa..4f73fe7aa473 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -32,3 +32,4 @@ obj-$(CONFIG_SAMPLE_INTEL_MEI)		+= mei/
 subdir-$(CONFIG_SAMPLE_WATCHDOG)	+= watchdog
 subdir-$(CONFIG_SAMPLE_WATCH_QUEUE)	+= watch_queue
 obj-$(CONFIG_DEBUG_KMEMLEAK_TEST)	+= kmemleak/
+obj-$(CONFIG_SAMPLE_FPROBE)		+= fprobe/
diff --git a/samples/fprobe/Makefile b/samples/fprobe/Makefile
new file mode 100644
index 000000000000..ecccbfa6e99b
--- /dev/null
+++ b/samples/fprobe/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_SAMPLE_FPROBE) += fprobe_example.o
diff --git a/samples/fprobe/fprobe_example.c b/samples/fprobe/fprobe_example.c
new file mode 100644
index 000000000000..c28320537f98
--- /dev/null
+++ b/samples/fprobe/fprobe_example.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Here's a sample kernel module showing the use of fprobe to dump a
+ * stack trace and selected registers when kernel_clone() is called.
+ *
+ * For more information on theory of operation of kprobes, see
+ * Documentation/trace/kprobes.rst
+ *
+ * You will see the trace data in /var/log/messages and on the console
+ * whenever kernel_clone() is invoked to create a new process.
+ */
+
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/fprobe.h>
+#include <linux/slab.h>
+
+#define MAX_SYMBOL_LEN 4096
+struct fprobe sample_probe;
+static char symbol[MAX_SYMBOL_LEN] = "kernel_clone";
+module_param_string(symbol, symbol, sizeof(symbol), 0644);
+
+static void sample_entry_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
+{
+	pr_info("Enter <%pS> ip = 0x%p\n", (void *)ip, (void *)ip);
+}
+
+static void sample_exit_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
+{
+	unsigned long rip = instruction_pointer(regs);
+
+	pr_info("Return from <%pS> ip = 0x%p to rip = 0x%p (%pS)\n",
+		(void *)ip, (void *)ip, (void *)rip, (void *)rip);
+}
+
+static char *symbuf;
+
+static int __init fprobe_init(void)
+{
+	const char **syms;
+	char *p;
+	int ret, count, i;
+
+	sample_probe.entry_handler = sample_entry_handler;
+	sample_probe.exit_handler = sample_exit_handler;
+
+	if (strchr(symbol, ',')) {
+		symbuf = kstrdup(symbol, GFP_KERNEL);
+		if (!symbuf)
+			return -ENOMEM;
+		p = symbuf;
+		count = 1;
+		while ((p = strchr(++p, ',')) != NULL)
+			count++;
+	} else {
+		count = 1;
+		symbuf = symbol;
+	}
+	pr_info("%d symbols found\n", count);
+
+	syms = kcalloc(count, sizeof(char *), GFP_KERNEL);
+	if (!syms) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	p = symbuf;
+	for (i = 0; i < count; i++)
+		syms[i] = strsep(&p, ",");
+
+	sample_probe.syms = syms;
+	sample_probe.nentry = count;
+
+	ret = register_fprobe(&sample_probe);
+	if (ret < 0) {
+		pr_err("register_fprobe failed, returned %d\n", ret);
+		goto error;
+	}
+	pr_info("Planted fprobe at %s\n", symbol);
+	return 0;
+
+error:
+	if (symbuf != symbol)
+		kfree(symbuf);
+	return ret;
+}
+
+static void __exit fprobe_exit(void)
+{
+	unregister_fprobe(&sample_probe);
+
+	kfree(sample_probe.syms);
+	if (symbuf != symbol)
+		kfree(symbuf);
+
+	pr_info("fprobe at %s unregistered\n", symbol);
+}
+
+module_init(fprobe_init)
+module_exit(fprobe_exit)
+MODULE_LICENSE("GPL");

