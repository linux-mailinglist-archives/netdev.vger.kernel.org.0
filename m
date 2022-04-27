Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B2B51243C
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 23:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbiD0VH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 17:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236944AbiD0VHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 17:07:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111B73B55E;
        Wed, 27 Apr 2022 14:04:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0E2E61D96;
        Wed, 27 Apr 2022 21:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2999CC385A7;
        Wed, 27 Apr 2022 21:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651093452;
        bh=NbaQaqK6bK4LYN0yFT8k61hz2Mc7Pqy8ccZi9IehvmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zjo0L2p9Y7strrXZIHom4dECd+ItvA7YpRMkD5upN/8TYaVa5jwn+XOOpMJp75nSS
         9LSPxb+N6M7OAv3qbWjOO0Oc6yATFMCs2F8DSaDBlJmelRmo/CjDHjMgt0nwp7fsDo
         3JSuBQxwWbLiX8UfEyVgzFCDjB3sdsqKQPQn+PA3+e5RT3WSddQ1WE3ib3tfaOHt+b
         QEEBCiC6EZ2vUxViZpoWaF62dv4bw0JthSf7yGNKvEKmeYttaOVS01V+yG62UthCsp
         YU0VSydr1amRF6uaB14VrLiFS6b6Z3uXf8XIoFephx0g0pVu1uevvTIJC09ngoUN5/
         SMgma+JmjwcrA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv3 bpf-next 2/5] ftrace: Add ftrace_lookup_symbols function
Date:   Wed, 27 Apr 2022 23:03:42 +0200
Message-Id: <20220427210345.455611-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427210345.455611-1-jolsa@kernel.org>
References: <20220427210345.455611-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding ftrace_lookup_symbols function that resolves array of symbols
with single pass over kallsyms.

The user provides array of string pointers with count and pointer to
allocated array for resolved values.

  int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt,
                            unsigned long *addrs)

It iterates all kalsyms symbols and tries to loop up each in provided
symbols array with bsearch. The symbols array needs to be sorted by
name for this reason.

We also check each symbol to pass ftrace_location, because this API
will be used for fprobe symbols resolving.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/ftrace.h |  6 ++++
 kernel/kallsyms.c      |  1 +
 kernel/trace/ftrace.c  | 62 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 4816b7e11047..820500430eae 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -303,6 +303,8 @@ int unregister_ftrace_function(struct ftrace_ops *ops);
 extern void ftrace_stub(unsigned long a0, unsigned long a1,
 			struct ftrace_ops *op, struct ftrace_regs *fregs);
 
+
+int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs);
 #else /* !CONFIG_FUNCTION_TRACER */
 /*
  * (un)register_ftrace_function must be a macro since the ops parameter
@@ -313,6 +315,10 @@ extern void ftrace_stub(unsigned long a0, unsigned long a1,
 static inline void ftrace_kill(void) { }
 static inline void ftrace_free_init_mem(void) { }
 static inline void ftrace_free_mem(struct module *mod, void *start, void *end) { }
+static inline int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_FUNCTION_TRACER */
 
 struct ftrace_func_entry {
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index fdfd308bebc4..fbdf8d3279ac 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -29,6 +29,7 @@
 #include <linux/compiler.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/bsearch.h>
 
 /*
  * These will be re-linked against their real values
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4f1d2f5e7263..07d87c7a525d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7964,3 +7964,65 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 	mutex_unlock(&ftrace_lock);
 	return ret;
 }
+
+static int symbols_cmp(const void *a, const void *b)
+{
+	const char **str_a = (const char **) a;
+	const char **str_b = (const char **) b;
+
+	return strcmp(*str_a, *str_b);
+}
+
+struct kallsyms_data {
+	unsigned long *addrs;
+	const char **syms;
+	size_t cnt;
+	size_t found;
+};
+
+static int kallsyms_callback(void *data, const char *name,
+			     struct module *mod, unsigned long addr)
+{
+	struct kallsyms_data *args = data;
+
+	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
+		return 0;
+
+	addr = ftrace_location(addr);
+	if (!addr)
+		return 0;
+
+	args->addrs[args->found++] = addr;
+	return args->found == args->cnt ? 1 : 0;
+}
+
+/**
+ * ftrace_lookup_symbols - Lookup addresses for array of symbols
+ *
+ * @sorted_syms: array of symbols pointers symbols to resolve,
+ * must be alphabetically sorted
+ * @cnt: number of symbols/addresses in @syms/@addrs arrays
+ * @addrs: array for storing resulting addresses
+ *
+ * This function looks up addresses for array of symbols provided in
+ * @syms array (must be alphabetically sorted) and stores them in
+ * @addrs array, which needs to be big enough to store at least @cnt
+ * addresses.
+ *
+ * This function returns 0 if all provided symbols are found,
+ * -ESRCH otherwise.
+ */
+int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs)
+{
+	struct kallsyms_data args;
+	int err;
+
+	args.addrs = addrs;
+	args.syms = sorted_syms;
+	args.cnt = cnt;
+	args.found = 0;
+	err = kallsyms_on_each_symbol(kallsyms_callback, &args);
+	if (err < 0)
+		return err;
+	return args.found == args.cnt ? 0 : -ESRCH;
+}
-- 
2.35.1

