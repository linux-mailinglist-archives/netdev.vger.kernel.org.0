Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D3348B023
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 16:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243510AbiAKPBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 10:01:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57810 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243491AbiAKPBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 10:01:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01DC9B81B34;
        Tue, 11 Jan 2022 15:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE168C36AE3;
        Tue, 11 Jan 2022 15:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641913266;
        bh=0SFUgokXnTa6zxw26ArkFug0LnrLNaFy5O6fChALoI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5cZHTrM5KGqt/PwGZXCmXWs2jWfIc+T/kQjckmrwkOMxx9XJznYX5W+pjrXuW4Dn
         mqa6tB1gnx/+EO5A4l0JCNFsfyk2TVfJ8rtT6EaQ+v2tlFr5b4PLyflq+SHs9eFVRr
         rxMNKUr5oF2n4/ZA6zpJyEvrydx+SKHtn5SOEg60wgTP2RaUIs3AqBizuXELzWkYEG
         A7mvFpJr7krjhxMMgjGgJr/0V6XhvAVPY79wnk5Yh+v7TCJjz9LMrHtWzT0nXPmR6E
         8e0FixvwoUy3oaKARSKPe92Ir9X1OqoXbbuRjGeBi7dKgfuc/LKDfZgtedVQRiU88/
         2CeQAI3PIGx5A==
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
Subject: [RFC PATCH 4/6] fprobe: Add exit_handler support
Date:   Wed, 12 Jan 2022 00:01:02 +0900
Message-Id: <164191326189.806991.3684466615191467367.stgit@devnote2>
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
 include/linux/fprobes.h |    4 +++
 kernel/trace/Kconfig    |    1 +
 kernel/trace/fprobes.c  |   59 +++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/include/linux/fprobes.h b/include/linux/fprobes.h
index fa85a2fc3ad1..d2eb064c5b79 100644
--- a/include/linux/fprobes.h
+++ b/include/linux/fprobes.h
@@ -5,6 +5,7 @@
 
 #include <linux/compiler.h>
 #include <linux/ftrace.h>
+#include <linux/rethook.h>
 
 /*
  * fprobe_entry - function entry for fprobe
@@ -27,7 +28,10 @@ struct fprobe {
 	struct ftrace_ops	ftrace;
 	unsigned long		nmissed;
 	unsigned int		flags;
+	struct rethook		*rethook;
+
 	void (*entry_handler) (struct fprobe *, unsigned long, struct pt_regs *);
+	void (*exit_handler) (struct fprobe *, unsigned long, struct pt_regs *);
 };
 
 #define FPROBE_FL_DISABLED	1
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 9328724258dc..59e227ade0b7 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -238,6 +238,7 @@ config FPROBES
 	bool "Kernel Function Probe (fprobe)"
 	depends on FUNCTION_TRACER
 	depends on DYNAMIC_FTRACE_WITH_REGS
+	select RETHOOK
 	default n
 	help
 	  This option enables kernel function probe feature, which is
diff --git a/kernel/trace/fprobes.c b/kernel/trace/fprobes.c
index 0a609093d48c..1e8202a19e3d 100644
--- a/kernel/trace/fprobes.c
+++ b/kernel/trace/fprobes.c
@@ -5,12 +5,20 @@
 #include <linux/fprobes.h>
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
 
@@ -27,10 +35,34 @@ static void fprobe_handler(unsigned long ip, unsigned long parent_ip,
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
+		rethook_hook_current(rh, ftrace_get_regs(fregs));
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
+	fpr = container_of(rh, struct fprobe_rethook_node, node);
+
+	fp->exit_handler(fp, fpr->entry_ip, regs);
+}
+NOKPROBE_SYMBOL(fprobe_exit_handler);
+
 static int convert_func_addresses(struct fprobe *fp)
 {
 	unsigned int i;
@@ -88,7 +120,7 @@ static int fprobe_comp_func(const void *a, const void *b)
  */
 int register_fprobe(struct fprobe *fp)
 {
-	unsigned int i;
+	unsigned int i, size;
 	int ret;
 
 	if (!fp || !fp->nentry || !fp->entries)
@@ -114,6 +146,23 @@ int register_fprobe(struct fprobe *fp)
 			return ret;
 	}
 
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
+				return -ENOMEM;
+			}
+			rethook_add_node(fp->rethook, node);
+		}
+	} else
+		fp->rethook = NULL;
+
 	return register_ftrace_function(&fp->ftrace);
 }
 EXPORT_SYMBOL_GPL(register_fprobe);
@@ -124,9 +173,15 @@ EXPORT_SYMBOL_GPL(register_fprobe);
  */
 int unregister_fprobe(struct fprobe *fp)
 {
+	int ret;
+
 	if (!fp || !fp->nentry || !fp->entries)
 		return -EINVAL;
 
-	return unregister_ftrace_function(&fp->ftrace);
+	ret = unregister_ftrace_function(&fp->ftrace);
+	if (!ret)
+		rethook_free(fp->rethook);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(unregister_fprobe);

