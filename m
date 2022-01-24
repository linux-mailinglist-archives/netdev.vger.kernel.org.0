Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E71498460
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbiAXQK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243608AbiAXQKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:10:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5879DC061401;
        Mon, 24 Jan 2022 08:10:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1770DB81107;
        Mon, 24 Jan 2022 16:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6E2C340E7;
        Mon, 24 Jan 2022 16:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643040647;
        bh=11/kJnOtCwBoXChX/EWMmORNzbQfTp3ibbJwLHtdEWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxNYydKGI9BtGPEjFQ21jgUtM9VaHM6AC7+uE7MCUmdI2zJwA7g2h5RZmdP4dZv6o
         J49P/xqcTQ6eWIiUWzizqQL4jU2VMpVTzbDKGYgEw7eBvWvSLwE6mUXc4eNLRN7qDw
         ENz5Q+aJ2PwSDQfR15mh1k/zqnCgdpKF6LAVMG76Ef0naB81cYQmAWUxg35jWry2Jn
         n81Oj3rke+PMzx+Fxktei+zsNQvJ1EP60qamTSpOYahSXh7bmisxjA/4OS7/G0ZVel
         AY6L7I3cLGCdyhRBcmXUNXDLEWfLo9pdid8/fbvLKZ1Sz02mp6yj+sN5dMd9AVdRcU
         wW4I5iKOe+WHA==
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
Subject: [PATCH v4 7/9] fprobe: Add exit_handler support
Date:   Tue, 25 Jan 2022 01:10:42 +0900
Message-Id: <164304064202.1680787.6047106759284410381.stgit@devnote2>
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
 Changes in v4:
  - Check fprobe is disabled in the exit handler.
 Changes in v3:
  - Make sure to clear rethook->data before free.
  - Handler checks the data is not NULL.
  - Free rethook only if the rethook is using.
---
 include/linux/fprobe.h |    6 ++++
 kernel/trace/Kconfig   |    1 +
 kernel/trace/fprobe.c  |   65 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/include/linux/fprobe.h b/include/linux/fprobe.h
index f7de332b08c2..4692089b9118 100644
--- a/include/linux/fprobe.h
+++ b/include/linux/fprobe.h
@@ -5,6 +5,7 @@
 
 #include <linux/compiler.h>
 #include <linux/ftrace.h>
+#include <linux/rethook.h>
 
 /**
  * struct fprobe - ftrace based probe.
@@ -14,7 +15,9 @@
  * @ops: The ftrace_ops.
  * @nmissed: The counter for missing events.
  * @flags: The status flag.
+ * @rethook: The rethook data structure. (internal data)
  * @entry_handler: The callback function for function entry.
+ * @exit_handler: The callback function for function exit.
  *
  * User must set either @syms or @addrs, but not both. If user sets
  * only @syms, the @addrs are generated when registering the fprobe.
@@ -28,7 +31,10 @@ struct fprobe {
 	struct ftrace_ops	ops;
 	unsigned long		nmissed;
 	unsigned int		flags;
+	struct rethook		*rethook;
+
 	void (*entry_handler)(struct fprobe *fp, unsigned long entry_ip, struct pt_regs *regs);
+	void (*exit_handler)(struct fprobe *fp, unsigned long entry_ip, struct pt_regs *regs);
 };
 
 #define FPROBE_FL_DISABLED	1
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 4d27e56c6e76..6176904c4741 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -238,6 +238,7 @@ config FPROBE
 	bool "Kernel Function Probe (fprobe)"
 	depends on FUNCTION_TRACER
 	depends on DYNAMIC_FTRACE_WITH_REGS
+	select RETHOOK
 	default n
 	help
 	  This option enables kernel function probe (fprobe) based on ftrace,
diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 748cc34765c1..4d089dda89c2 100644
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
+	if (!fp || fprobe_disabled(fp))
+		return;
+
+	fpr = container_of(rh, struct fprobe_rethook_node, node);
+
+	fp->exit_handler(fp, fpr->entry_ip, regs);
+}
+NOKPROBE_SYMBOL(fprobe_exit_handler);
+
 /* Convert ftrace location address from symbols */
 static int convert_func_addresses(struct fprobe *fp)
 {
@@ -82,6 +117,7 @@ static int convert_func_addresses(struct fprobe *fp)
  */
 int register_fprobe(struct fprobe *fp)
 {
+	unsigned int i, size;
 	int ret;
 
 	if (!fp || !fp->nentry || (!fp->syms && !fp->addrs) ||
@@ -96,10 +132,29 @@ int register_fprobe(struct fprobe *fp)
 	fp->ops.func = fprobe_handler;
 	fp->ops.flags = FTRACE_OPS_FL_SAVE_REGS;
 
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
 	ret = ftrace_set_filter_ips(&fp->ops, fp->addrs, fp->nentry, 0, 0);
 	if (!ret)
 		ret = register_ftrace_function(&fp->ops);
 
+out:
 	if (ret < 0 && fp->syms) {
 		kfree(fp->addrs);
 		fp->addrs = NULL;
@@ -125,8 +180,16 @@ int unregister_fprobe(struct fprobe *fp)
 		return -EINVAL;
 
 	ret = unregister_ftrace_function(&fp->ops);
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

