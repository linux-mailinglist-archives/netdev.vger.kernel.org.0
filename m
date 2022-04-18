Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D24F505596
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 15:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241310AbiDRNLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 09:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242700AbiDRNJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 09:09:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683202CC84;
        Mon, 18 Apr 2022 05:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61FBB61257;
        Mon, 18 Apr 2022 12:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF1BC385A7;
        Mon, 18 Apr 2022 12:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650286128;
        bh=OETyOZf1v9T/pfPCssjXE8D9IRePA6pQEc/6z6FIKLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJeUqePvZsT4JyX4gmvU+xloiRRxrwfEpWSeSrwznw7ga/B8nNxaCVfSLmdNFnUpM
         8JyvGJVYkzl6SKsHBgFS61roqedQarqWuNFovWUxUYtxGba9MbXAymGU+g28Smpm1b
         W0iql5q6poRioRSg5Rv8Mjvp9TuSTxJtSiOF4zZbJ/JLfG7vEN9nV0JVyQ/kGiYSxC
         H9bBsQlCqckJ8YzUK45oOHGtC0opGm2/rbtI9SBWvnBGWn4csATKrKyvhUk6I1e1xb
         ZnJ+64JW0r+WC4R0gaTKfxoKXdQGkxxTtwyDDnfm6Q3DUKvPAFwm79sSxcSN29ymzP
         6zTNH7tNHtpPQ==
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
        KP Singh <kpsingh@chromium.org>
Subject: [PATCHv2 bpf-next 1/4] kallsyms: Add kallsyms_lookup_names function
Date:   Mon, 18 Apr 2022 14:48:31 +0200
Message-Id: <20220418124834.829064-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220418124834.829064-1-jolsa@kernel.org>
References: <20220418124834.829064-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding kallsyms_lookup_names function that resolves array of symbols
with single pass over kallsyms.

The user provides array of string pointers with count and pointer to
allocated array for resolved values.

  int kallsyms_lookup_names(const char **syms, size_t cnt,
                            unsigned long *addrs)

It iterates all kalsyms symbols and tries to loop up each in provided
symbols array with bsearch. The symbols array needs to be sorted by
name for this reason.

We also check each symbol to pass ftrace_location, because this API
will be used for fprobe symbols resolving. This can be optional in
future if there's a need.

We need kallsyms_on_each_symbol function, so enabling it and also
the new function for CONFIG_FPROBE option.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/kallsyms.h |  6 ++++
 kernel/kallsyms.c        | 70 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index ce1bd2fbf23e..7c82fa7445d4 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -72,6 +72,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 #ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
+int kallsyms_lookup_names(const char **syms, size_t cnt, unsigned long *addrs);
 
 extern int kallsyms_lookup_size_offset(unsigned long addr,
 				  unsigned long *symbolsize,
@@ -103,6 +104,11 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
 	return 0;
 }
 
+static inline int kallsyms_lookup_names(const char **syms, size_t cnt, unsigned long *addrs)
+{
+	return -ERANGE;
+}
+
 static inline int kallsyms_lookup_size_offset(unsigned long addr,
 					      unsigned long *symbolsize,
 					      unsigned long *offset)
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 79f2eb617a62..ef940b25f3fc 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -29,6 +29,7 @@
 #include <linux/compiler.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/bsearch.h>
 
 /*
  * These will be re-linked against their real values
@@ -228,7 +229,7 @@ unsigned long kallsyms_lookup_name(const char *name)
 	return module_kallsyms_lookup_name(name);
 }
 
-#ifdef CONFIG_LIVEPATCH
+#if defined(CONFIG_LIVEPATCH) || defined(CONFIG_FPROBE)
 /*
  * Iterate over all symbols in vmlinux.  For symbols from modules use
  * module_kallsyms_on_each_symbol instead.
@@ -572,6 +573,73 @@ int sprint_backtrace_build_id(char *buffer, unsigned long address)
 	return __sprint_symbol(buffer, address, -1, 1, 1);
 }
 
+#ifdef CONFIG_FPROBE
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
+ * kallsyms_lookup_names - Lookup addresses for array of symbols
+ *
+ * @syms: array of symbols pointers symbols to resolve, must be
+ * alphabetically sorted
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
+int kallsyms_lookup_names(const char **syms, size_t cnt, unsigned long *addrs)
+{
+	struct kallsyms_data args;
+
+	args.addrs = addrs;
+	args.syms = syms;
+	args.cnt = cnt;
+	args.found = 0;
+	kallsyms_on_each_symbol(kallsyms_callback, &args);
+
+	return args.found == args.cnt ? 0 : -ESRCH;
+}
+#else
+int kallsyms_lookup_names(const char **syms, size_t cnt, unsigned long *addrs)
+{
+	return -ERANGE;
+}
+#endif /* CONFIG_FPROBE */
+
 /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
 struct kallsym_iter {
 	loff_t pos;
-- 
2.35.1

