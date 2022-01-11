Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5200D48B026
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 16:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243853AbiAKPB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 10:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243600AbiAKPBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 10:01:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FF2C06173F;
        Tue, 11 Jan 2022 07:01:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3880616A9;
        Tue, 11 Jan 2022 15:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5437DC36AEB;
        Tue, 11 Jan 2022 15:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641913277;
        bh=1j0gb5NnOtQmmflNztpId+8+T/swnj4qKPrK5FKZCfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HsLhBP1RT/X3aJ5bZ2VFbSBMWPbl21dw0S8GPr8UhAz0jcQ6N32cKRP96FIOAtLGD
         7d5dBL1FEBIW3uraf9HGu6gJdG95sf4CoZi/Aq/bZ40wAl0UldmJ1AmAHhVFpWSOx4
         N9eVREpZ38JYs2Dco+4ald6TSK83z7p+xkmPBQd0fsNm7r2rOcjYzpdlTqeNgX8Q+H
         LkI+p7Q1xNVBVS1NSOjAjMIv1G92E3ore0gj4M2lpqjexLWHHkreq3t+LLsKg+jN6r
         ZvErG2xmE7ZldMhemIustK8g00WJKPVW7OUOzkhNwPh0217mblxLAk811uVctDW/EC
         oYdyUU11T8UDA==
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
Subject: [RFC PATCH 5/6] fprobe: Add sample program for fprobe
Date:   Wed, 12 Jan 2022 00:01:12 +0900
Message-Id: <164191327207.806991.15842602939159094192.stgit@devnote2>
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

Add a sample program for the fprobe.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 samples/Kconfig                 |    6 ++
 samples/Makefile                |    1 
 samples/fprobe/Makefile         |    3 +
 samples/fprobe/fprobe_example.c |  103 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 113 insertions(+)
 create mode 100644 samples/fprobe/Makefile
 create mode 100644 samples/fprobe/fprobe_example.c

diff --git a/samples/Kconfig b/samples/Kconfig
index 43d2e9aa557f..487b5d17f722 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -73,6 +73,12 @@ config SAMPLE_HW_BREAKPOINT
 	help
 	  This builds kernel hardware breakpoint example modules.
 
+config SAMPLE_FPROBE
+	tristate "Build fprobe examples -- loadable modules only"
+	depends on FPROBES && m
+	help
+	  This build several fprobe example modules.
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
index 000000000000..8ea335cfe916
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
+#include <linux/fprobes.h>
+#include <linux/slab.h>
+
+#define MAX_SYMBOL_LEN 4096
+struct fprobe sample_probe;
+static char symbol[MAX_SYMBOL_LEN] = "kernel_clone";
+module_param_string(symbol, symbol, sizeof(symbol), 0644);
+
+static void sample_entry_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
+{
+	const char *sym = "<no-sym>";
+	struct fprobe_entry *ent;
+
+	ent = fprobe_find_entry(fp, ip);
+	if (ent)
+		sym = ent->sym;
+
+	pr_info("Enter <%s> ip = 0x%p (%pS)\n", sym, (void *)ip, (void *)ip);
+}
+
+static void sample_exit_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
+{
+	unsigned long rip = instruction_pointer(regs);
+	const char *sym = "<no-sym>";
+	struct fprobe_entry *ent;
+
+	ent = fprobe_find_entry(fp, ip);
+	if (ent)
+		sym = ent->sym;
+
+	pr_info("Return from <%s> ip = 0x%p to rip = 0x%p (%pS)\n", sym, (void *)ip,
+		(void *)rip, (void *)rip);
+}
+
+static int __init fprobe_init(void)
+{
+	struct fprobe_entry *ents;
+	char *tmp, *p;
+	int ret, count, i;
+
+	sample_probe.entry_handler = sample_entry_handler;
+	sample_probe.exit_handler = sample_exit_handler;
+
+	if (strchr(symbol, ',')) {
+		tmp = kstrdup(symbol, GFP_KERNEL);
+		if (!tmp)
+			return -ENOMEM;
+		p = tmp;
+		count = 1;
+		while ((p = strchr(p, ',')) != NULL)
+			count++;
+	} else {
+		count = 1;
+		tmp = symbol;
+	}
+
+	ents = kzalloc(count * sizeof(*ents), GFP_KERNEL);
+	if (!ents) {
+		if (tmp != symbol)
+			kfree(tmp);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < count; i++)
+		ents[i].sym = strsep(&tmp, ",");
+
+	sample_probe.entries = ents;
+	sample_probe.nentry = count;
+
+	ret = register_fprobe(&sample_probe);
+	if (ret < 0) {
+		pr_err("register_fprobe failed, returned %d\n", ret);
+		return ret;
+	}
+	pr_info("Planted fprobe at %s\n", symbol);
+	return 0;
+}
+
+static void __exit fprobe_exit(void)
+{
+	unregister_fprobe(&sample_probe);
+	pr_info("fprobe at %s unregistered\n", symbol);
+}
+
+module_init(fprobe_init)
+module_exit(fprobe_exit)
+MODULE_LICENSE("GPL");

