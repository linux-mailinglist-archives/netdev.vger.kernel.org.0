Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED2A493C5A
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355463AbiASO6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:58:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44480 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355402AbiASO5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:57:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C2E5B81A01;
        Wed, 19 Jan 2022 14:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58065C340E1;
        Wed, 19 Jan 2022 14:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642604253;
        bh=mFeUPa7/+CNLowoBLPgevKJwQahq0/H42g/SiDQAY1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PddLg93dCsOoDhQ/wXZmSNJAzPqkBSSUnN3tw3TbnXISMTGhJOM7T8SqtIKzIgQPg
         xsOTbLSJv1Y00/j3poBXD9PCNWkbILkq2I05yZPLSqyYpNOMa+7iA0S0EFPQgpXxEy
         4IZA8Qd6QIIwTenMStuAUCT5y4AflkBp8vctX5cVz2NuKIR5OT52f3VwSRi+JhWKwN
         gT17VdpRMU7tDMLaxOcgXD7izCJi6h3bDKEpSKc9UOUu8ciJgRsAynGVWZ9kcy/y29
         +5tQ9lSFXFBNRknDqTOr2VgOVQJ8O33DE5RnVRaBo9l64gTDjKUJYlHNwE0T79Re6V
         Uihq1zW4ZIxrQ==
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
Subject: [RFC PATCH v3 5/9] fprobe: Add exit_handler support
Date:   Wed, 19 Jan 2022 23:57:28 +0900
Message-Id: <164260424817.657731.18086977161238731328.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164260419349.657731.13913104835063027148.stgit@devnote2>
References: <164260419349.657731.13913104835063027148.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add exit_handler to fprobe. fprobe + rethook allows us
to hook the kernel function return without fgraph tracer.
Eventually, the fgraph tracer will be generic array based
return hooking and fprobe may use it if user requests.
Since both array-based approach and list-based approach
have Pros and Cons, (e.g. memory consumption v.s. less
missing events) it is better to keep both but fprobe
will provide the same exit-handler interface.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v3:
  - Make sure to clear rethook->data before free.
  - Handler checks the data is not NULL.
  - Free rethook only if the rethook is using.
---
 include/linux/fprobe.h |    4 +++
 kernel/trace/Kconfig   |    1 +
 kernel/trace/fprobe.c  |   66 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/include/linux/fprobe.h b/include/linux/fprobe.h
index 2fc487d933e3..dd9d65294552 100644
--- a/include/linux/fprobe.h
+++ b/include/linux/fprobe.h
@@ -5,6 +5,7 @@
 
 #include <linux/compiler.h>
 #include <linux/ftrace.h>
+#include <linux/rethook.h>
 
 /**
  * struct fprobe - ftrace based probe.
@@ -28,7 +29,10 @@ struct fprobe {
 	struct ftrace_ops	ftrace;
 	unsigned long		nmissed;
 	unsigned int		flags;
+	struct rethook		*rethook;
+
 	void (*entry_handler)(struct fprobe *fp, unsigned long entry_ip, struct pt_regs *regs);
+	void (*exit_handler)(struct fprobe *fp, unsigned long entry_ip, struct pt_regs *regs);
 };
 
 #define FPROBE_FL_DISABLED	1
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 44c473ad9021..00bdd2a2f417 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -238,6 +238,7 @@ config FPROBE
 	bool "Kernel Function Probe (fprobe)"
 	depends on FUNCTION_TRACER
 	depends on DYNAMIC_FTRACE_WITH_REGS
+	select RETHOOK
 	default n
 	help
 	  This option enables kernel function probe feature, which is
diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 8b068deadc48..7d98ca026c72 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -7,12 +7,20 @@
 #include <linux/fprobe.h>
 #include <linux/kallsyms.h>
 #include <linux/kprobes.h>
+#include <linux/rethook.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
 
+struct fprobe_rethook_node {
+	struct rethook_node node;
+	unsigned long entry_ip;
+};
+
 static void fprobe_handler(unsigned long ip, unsigned long parent_ip,
 			   struct ftrace_ops *ops, struct ftrace_regs *fregs)
 {
+	struct fprobe_rethook_node *fpr;
+	struct rethook_node *rh;
 	struct fprobe *fp;
 	int bit;
 
@@ -29,10 +37,37 @@ static void fprobe_handler(unsigned long ip, unsigned long parent_ip,
 	if (fp->entry_handler)
 		fp->entry_handler(fp, ip, ftrace_get_regs(fregs));
 
+	if (fp->exit_handler) {
+		rh = rethook_try_get(fp->rethook);
+		if (!rh) {
+			fp->nmissed++;
+			goto out;
+		}
+		fpr = container_of(rh, struct fprobe_rethook_node, node);
+		fpr->entry_ip = ip;
+		rethook_hook(rh, ftrace_get_regs(fregs));
+	}
+
+out:
 	ftrace_test_recursion_unlock(bit);
 }
 NOKPROBE_SYMBOL(fprobe_handler);
 
+static void fprobe_exit_handler(struct rethook_node *rh, void *data,
+				struct pt_regs *regs)
+{
+	struct fprobe *fp = (struct fprobe *)data;
+	struct fprobe_rethook_node *fpr;
+
+	if (!data)
+		return;
+
+	fpr = container_of(rh, struct fprobe_rethook_node, node);
+
+	fp->exit_handler(fp, fpr->entry_ip, regs);
+}
+NOKPROBE_SYMBOL(fprobe_exit_handler);
+
 static int convert_func_addresses(struct fprobe *fp)
 {
 	unsigned int i;
@@ -45,7 +80,6 @@ static int convert_func_addresses(struct fprobe *fp)
 		return -ENOMEM;
 
 	for (i = 0; i < fp->nentry; i++) {
-
 		fp->addrs[i] = kallsyms_lookup_name(fp->syms[i]);
 		if (!fp->addrs[i])
 			return -ENOENT;
@@ -64,6 +98,7 @@ static int convert_func_addresses(struct fprobe *fp)
  */
 int register_fprobe(struct fprobe *fp)
 {
+	unsigned int i, size;
 	int ret;
 
 	if (!fp || !fp->nentry || (!fp->syms && !fp->addrs) ||
@@ -78,10 +113,29 @@ int register_fprobe(struct fprobe *fp)
 	fp->ftrace.func = fprobe_handler;
 	fp->ftrace.flags = FTRACE_OPS_FL_SAVE_REGS;
 
+	/* Initialize rethook if needed */
+	if (fp->exit_handler) {
+		size = fp->nentry * num_possible_cpus() * 2;
+		fp->rethook = rethook_alloc((void *)fp, fprobe_exit_handler);
+		for (i = 0; i < size; i++) {
+			struct rethook_node *node;
+
+			node = kzalloc(sizeof(struct fprobe_rethook_node), GFP_KERNEL);
+			if (!node) {
+				rethook_free(fp->rethook);
+				ret = -ENOMEM;
+				goto out;
+			}
+			rethook_add_node(fp->rethook, node);
+		}
+	} else
+		fp->rethook = NULL;
+
 	ret = ftrace_set_filter_ips(&fp->ftrace, fp->addrs, fp->nentry, 0, 0);
 	if (!ret)
 		ret = register_ftrace_function(&fp->ftrace);
 
+out:
 	if (ret < 0 && fp->syms) {
 		kfree(fp->addrs);
 		fp->addrs = NULL;
@@ -107,8 +161,16 @@ int unregister_fprobe(struct fprobe *fp)
 		return -EINVAL;
 
 	ret = unregister_ftrace_function(&fp->ftrace);
+	if (ret < 0)
+		return ret;
 
-	if (!ret && fp->syms) {
+	if (fp->rethook) {
+		/* Make sure to clear rethook->data before freeing. */
+		WRITE_ONCE(fp->rethook->data, NULL);
+		barrier();
+		rethook_free(fp->rethook);
+	}
+	if (fp->syms) {
 		kfree(fp->addrs);
 		fp->addrs = NULL;
 	}

