Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D5C49FBC4
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349259AbiA1Odc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349301AbiA1OdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:33:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2CDC061747;
        Fri, 28 Jan 2022 06:33:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC3D961E10;
        Fri, 28 Jan 2022 14:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F95C340E6;
        Fri, 28 Jan 2022 14:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643380401;
        bh=OcpA1U0L5UOHRnjD5F0+bImvT/uUO+KvKcYaPpGNVi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fN7UzOt57hC53yyZ/D8RxU8+8Z/Gzw8ij//xGMZbzZ6EBNmSU6+dPj0RnPD6DCGks
         E9se861OygNQzh6lSUyouyUPDuDkl1XgaZqk5cYHxyF+sfUsTfylRO3psa+4KowqRJ
         OJtIB7H1O0PCPQtkpXpSGByTF6ctLgKWdsJHfDrIvos8NeqTmx2FGMaqSa7nQvw0A4
         hf2HK8JFPQTCKKcEtuKFeubFFTT7zrHQO0qvqj9bxHyHlsG4HU1Zu4cqvih4D6IlSL
         1joGLmpN3XPQvQvO54Cvzd6ZoZJ5OBy2gDvWPBfuPpek6nxDb5BINfE/kfSWCDY3jM
         ATG30g0wp/cSw==
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
Subject: [PATCH v6 07/10] fprobe: Add exit_handler support
Date:   Fri, 28 Jan 2022 23:33:15 +0900
Message-Id: <164338039561.2429999.13188362820100127912.stgit@devnote2>
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

Add exit_handler to fprobe. fprobe + rethook allows us to hook the kernel
function return. The rethook will be enabled only if the
fprobe::exit_handler is set.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v6:
  - Update according to the fprobe update.
 Changes in v5:
  - Add dependency for HAVE_RETHOOK.
 Changes in v4:
  - Check fprobe is disabled in the exit handler.
 Changes in v3:
  - Make sure to clear rethook->data before free.
  - Handler checks the data is not NULL.
  - Free rethook only if the rethook is using.
---
 include/linux/fprobe.h |    6 ++
 kernel/trace/Kconfig   |    2 +
 kernel/trace/fprobe.c  |  127 +++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 123 insertions(+), 12 deletions(-)

diff --git a/include/linux/fprobe.h b/include/linux/fprobe.h
index b920dc1b2969..acfdcc37acf6 100644
--- a/include/linux/fprobe.h
+++ b/include/linux/fprobe.h
@@ -5,19 +5,25 @@
 
 #include <linux/compiler.h>
 #include <linux/ftrace.h>
+#include <linux/rethook.h>
 
 /**
  * struct fprobe - ftrace based probe.
  * @ops: The ftrace_ops.
  * @nmissed: The counter for missing events.
  * @flags: The status flag.
+ * @rethook: The rethook data structure. (internal data)
  * @entry_handler: The callback function for function entry.
+ * @exit_handler: The callback function for function exit.
  */
 struct fprobe {
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
index 9e66fd29d94e..3c1f808969f1 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -245,6 +245,8 @@ config FPROBE
 	bool "Kernel Function Probe (fprobe)"
 	depends on FUNCTION_TRACER
 	depends on DYNAMIC_FTRACE_WITH_REGS
+	depends on HAVE_RETHOOK
+	select RETHOOK
 	default n
 	help
 	  This option enables kernel function probe (fprobe) based on ftrace,
diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 081aef6bf531..408dcb6503fe 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -8,12 +8,22 @@
 #include <linux/fprobe.h>
 #include <linux/kallsyms.h>
 #include <linux/kprobes.h>
+#include <linux/rethook.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
 
+#include "trace.h"
+
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
 
@@ -30,10 +40,37 @@ static void fprobe_handler(unsigned long ip, unsigned long parent_ip,
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
 static unsigned long *get_ftrace_locations(const char **syms, int num)
 {
@@ -76,6 +113,48 @@ static void fprobe_init(struct fprobe *fp)
 	fp->ops.flags |= FTRACE_OPS_FL_SAVE_REGS;
 }
 
+static int fprobe_init_rethook(struct fprobe *fp, int num)
+{
+	int i, size;
+
+	if (num < 0)
+		return -EINVAL;
+
+	if (!fp->exit_handler) {
+		fp->rethook = NULL;
+		return 0;
+	}
+
+	/* Initialize rethook if needed */
+	size = num * num_possible_cpus() * 2;
+	if (size < 0)
+		return -E2BIG;
+
+	fp->rethook = rethook_alloc((void *)fp, fprobe_exit_handler);
+	for (i = 0; i < size; i++) {
+		struct rethook_node *node;
+
+		node = kzalloc(sizeof(struct fprobe_rethook_node), GFP_KERNEL);
+		if (!node) {
+			rethook_free(fp->rethook);
+			fp->rethook = NULL;
+			return -ENOMEM;
+		}
+		rethook_add_node(fp->rethook, node);
+	}
+	return 0;
+}
+
+static void fprobe_fail_cleanup(struct fprobe *fp)
+{
+	if (fp->rethook) {
+		/* Don't need to cleanup rethook->handler because this is not used. */
+		rethook_free(fp->rethook);
+		fp->rethook = NULL;
+	}
+	ftrace_free_filter(&fp->ops);
+}
+
 /**
  * register_fprobe() - Register fprobe to ftrace by pattern.
  * @fp: A fprobe data structure to be registered.
@@ -89,6 +168,7 @@ static void fprobe_init(struct fprobe *fp)
  */
 int register_fprobe(struct fprobe *fp, const char *filter, const char *notfilter)
 {
+	struct ftrace_hash *hash;
 	unsigned char *str;
 	int ret, len;
 
@@ -113,10 +193,21 @@ int register_fprobe(struct fprobe *fp, const char *filter, const char *notfilter
 			goto out;
 	}
 
-	ret = register_ftrace_function(&fp->ops);
+	/* TODO:
+	 * correctly calculate the total number of filtered symbols
+	 * from both filter and notfilter.
+	 */
+	hash = fp->ops.local_hash.filter_hash;
+	if (WARN_ON_ONCE(!hash))
+		goto out;
+
+	ret = fprobe_init_rethook(fp, (int)hash->count);
+	if (!ret)
+		ret = register_ftrace_function(&fp->ops);
+
 out:
 	if (ret)
-		ftrace_free_filter(&fp->ops);
+		fprobe_fail_cleanup(fp);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_fprobe);
@@ -144,12 +235,15 @@ int register_fprobe_ips(struct fprobe *fp, unsigned long *addrs, int num)
 	fprobe_init(fp);
 
 	ret = ftrace_set_filter_ips(&fp->ops, addrs, num, 0, 0);
+	if (ret)
+		return ret;
+
+	ret = fprobe_init_rethook(fp, num);
 	if (!ret)
 		ret = register_ftrace_function(&fp->ops);
 
 	if (ret)
-		ftrace_free_filter(&fp->ops);
-
+		fprobe_fail_cleanup(fp);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_fprobe_ips);
@@ -179,14 +273,16 @@ int register_fprobe_syms(struct fprobe *fp, const char **syms, int num)
 		return PTR_ERR(addrs);
 
 	ret = ftrace_set_filter_ips(&fp->ops, addrs, num, 0, 0);
+	kfree(addrs);
 	if (ret)
-		goto out;
-	ret = register_ftrace_function(&fp->ops);
-	if (ret)
-		ftrace_free_filter(&fp->ops);
+		return ret;
 
-out:
-	kfree(addrs);
+	ret = fprobe_init_rethook(fp, num);
+	if (!ret)
+		ret = register_ftrace_function(&fp->ops);
+
+	if (ret)
+		fprobe_fail_cleanup(fp);
 
 	return ret;
 }
@@ -210,9 +306,16 @@ int unregister_fprobe(struct fprobe *fp)
 		return -EINVAL;
 
 	ret = unregister_ftrace_function(&fp->ops);
+	if (ret < 0)
+		return ret;
 
-	if (!ret)
-		ftrace_free_filter(&fp->ops);
+	if (fp->rethook) {
+		/* Make sure to clear rethook->data before freeing. */
+		WRITE_ONCE(fp->rethook->data, NULL);
+		barrier();
+		rethook_free(fp->rethook);
+	}
+	ftrace_free_filter(&fp->ops);
 
 	return ret;
 }

