Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6818A518CD4
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 21:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239747AbiECTH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 15:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiECTHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 15:07:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC233B3F8;
        Tue,  3 May 2022 12:04:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3420B81D9D;
        Tue,  3 May 2022 19:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A07BC385A9;
        Tue,  3 May 2022 19:04:17 +0000 (UTC)
Date:   Tue, 3 May 2022 15:04:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org
Subject: : [PATCH] ftrace/x86: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding
 weak functions
Message-ID: <20220503150410.2d9e88aa@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If an unused weak function was traced, it's call to fentry will still
exist, which gets added into the __mcount_loc table. Ftrace will use
kallsyms to retrieve the name for each location in __mcount_loc to display
it in the available_filter_functions and used to enable functions via the
name matching in set_ftrace_filter/notrace. Enabling these functions do
nothing but enable an unused call to ftrace_caller. If a traced weak
function is overridden, the symbol of the function would be used for it,
which will either created duplicate names, or if the previous function was
not traced, it would be incorrectly listed in available_filter_functions
as a function that can be traced.

This became an issue with BPF[1] as there are tooling that enables the
direct callers via ftrace but then checks to see if the functions were
actually enabled. The case of one function that was marked notrace, but
was followed by an unused weak function that was traced. The unused
function's call to fentry was added to the __mcount_loc section, and
kallsyms retrieved the untraced function's symbol as the weak function was
overridden. Since the untraced function would not get traced, the BPF
check would detect this and fail.

The real fix would be to fix kallsyms to not show address of weak
functions as the function before it. But that would require adding code in
the build to add function size to kallsyms so that it can know when the
function ends instead of just using the start of the next known symbol.

In the mean time, this is a work around. Add a FTRACE_MCOUNT_MAX_OFFSET
macro that if defined, ftrace will ignore any function that has its call
to fentry/mcount that has an offset from the symbol that is greater than
FTRACE_MCOUNT_MAX_OFFSET.

If CONFIG_HAVE_FENTRY is defined for x86, define FTRACE_MCOUNT_MAX_OFFSET
to zero, which will have ftrace ignore all locations that are not at the
start of the function.

[1] https://lore.kernel.org/all/20220412094923.0abe90955e5db486b7bca279@kernel.org/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h |  5 ++++
 kernel/trace/ftrace.c         | 50 +++++++++++++++++++++++++++++++++--
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 024d9797646e..70c88d49bf45 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -9,6 +9,11 @@
 # define MCOUNT_ADDR		((unsigned long)(__fentry__))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
+/* Ignore unused weak functions which will have non zero offsets */
+#ifdef CONFIG_HAVE_FENTRY
+# define FTRACE_MCOUNT_MAX_OFFSET	0
+#endif
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 #define ARCH_SUPPORTS_FTRACE_OPS 1
 #endif
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5c465e70d146..3529c44ab9db 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3665,6 +3665,31 @@ static void add_trampoline_func(struct seq_file *m, struct ftrace_ops *ops,
 		seq_printf(m, " ->%pS", ptr);
 }
 
+#ifdef FTRACE_MCOUNT_MAX_OFFSET
+static int print_rec(struct seq_file *m, unsigned long ip)
+{
+	unsigned long offset;
+	char str[KSYM_SYMBOL_LEN];
+	char *modname;
+	int ret;
+
+	ret = kallsyms_lookup(ip, NULL, &offset, &modname, str);
+	if (!ret || offset > FTRACE_MCOUNT_MAX_OFFSET)
+		return -1;
+
+	seq_puts(m, str);
+	if (modname)
+		seq_printf(m, " [%s]", modname);
+	return 0;
+}
+#else
+static int print_rec(struct seq_file *m, unsigned long ip)
+{
+	seq_printf(m, "%ps", (void *)ip);
+	return 0;
+}
+#endif
+
 static int t_show(struct seq_file *m, void *v)
 {
 	struct ftrace_iterator *iter = m->private;
@@ -3689,7 +3714,9 @@ static int t_show(struct seq_file *m, void *v)
 	if (!rec)
 		return 0;
 
-	seq_printf(m, "%ps", (void *)rec->ip);
+	if (print_rec(m, rec->ip))
+		return 0;
+
 	if (iter->flags & FTRACE_ITER_ENABLED) {
 		struct ftrace_ops *ops;
 
@@ -4007,6 +4034,24 @@ add_rec_by_index(struct ftrace_hash *hash, struct ftrace_glob *func_g,
 	return 0;
 }
 
+#ifdef FTRACE_MCOUNT_MAX_OFFSET
+static int lookup_ip(unsigned long ip, char **modname, char *str)
+{
+	unsigned long offset;
+
+	kallsyms_lookup(ip, NULL, &offset, modname, str);
+	if (offset > FTRACE_MCOUNT_MAX_OFFSET)
+		return -1;
+	return 0;
+}
+#else
+static int lookup_ip(unsigned long ip, char **modname, char *str)
+{
+	kallsyms_lookup(ip, NULL, NULL, modname, str);
+	return 0;
+}
+#endif
+
 static int
 ftrace_match_record(struct dyn_ftrace *rec, struct ftrace_glob *func_g,
 		struct ftrace_glob *mod_g, int exclude_mod)
@@ -4014,7 +4059,8 @@ ftrace_match_record(struct dyn_ftrace *rec, struct ftrace_glob *func_g,
 	char str[KSYM_SYMBOL_LEN];
 	char *modname;
 
-	kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
+	if (lookup_ip(rec->ip, &modname, str))
+		return 0;
 
 	if (mod_g) {
 		int mod_matches = (modname) ? ftrace_match(modname, mod_g) : 0;
-- 
2.35.1

