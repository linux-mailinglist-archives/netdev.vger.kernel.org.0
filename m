Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF754BFFC0
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiBVRIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234585AbiBVRI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:08:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABB27ED95;
        Tue, 22 Feb 2022 09:07:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B9150CE13B8;
        Tue, 22 Feb 2022 17:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FA3C340E8;
        Tue, 22 Feb 2022 17:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645549676;
        bh=K75SB/lhbqVVIwcxlRrolz61Tn5bMuPkyGH7ZhtRhPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brQhUfZa3ayqpbAxlgnWE7BPrBvoIDk9XfiCGlwA9sDd2Z4mIzXJc8KVRyXkHZ9wt
         X84qAJJy5fzCgodojz5f7F2rDHt4LvvElpM/lFnCSrRbhZGaXRJMl7FgqvJVX82q1d
         Zv3gOCPJfmGx9Gur9RSjX4XxG+k/V3K562O735v0/zLb0Y08vrVfG3HK6lF+uP0Jhc
         PlqneINQGt+bwi7URen26Mce53STrKWVapKUNfWFdA8b4o3VS5mebc263qgx4BVLw8
         ci95sE1oMRcByuvlGLjiBGwmDPprtCsIiDtlvu1K62CaTsO122k62W8PHtOdd2IZEZ
         q7O+wEw9TcrfA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@redhat.com>,
        Yucong Sun <fallentree@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 08/10] libbpf: Add bpf_program__attach_kprobe_opts support for multi kprobes
Date:   Tue, 22 Feb 2022 18:05:58 +0100
Message-Id: <20220222170600.611515-9-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220222170600.611515-1-jolsa@kernel.org>
References: <20220222170600.611515-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to bpf_program__attach_kprobe_opts to attach kprobes
to multiple functions.

If the kprobe program has BPF_TRACE_KPROBE_MULTI as expected_attach_type
it will use the new kprobe_multi link to attach the program. In this case
it will use 'func_name' as pattern for functions to attach.

Adding also new section types 'kprobe.multi' and kretprobe.multi'
that allows to specify wildcards (*?) for functions, like:

  SEC("kprobe.multi/bpf_fentry_test*")
  SEC("kretprobe.multi/bpf_fentry_test?")

This will set kprobe's expected_attach_type to BPF_TRACE_KPROBE_MULTI,
and attach it to functions provided by the function pattern.

Using glob_match from selftests/bpf/test_progs.c and adding support to
match '?' based on original perf code.

Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Yucong Sun <fallentree@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c | 130 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 125 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index fb530b004a0d..9bee2d70b99d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8622,6 +8622,8 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("uprobe/",		KPROBE,	0, SEC_NONE),
 	SEC_DEF("kretprobe/",		KPROBE, 0, SEC_NONE, attach_kprobe),
 	SEC_DEF("uretprobe/",		KPROBE, 0, SEC_NONE),
+	SEC_DEF("kprobe.multi/",	KPROBE,	BPF_TRACE_KPROBE_MULTI, SEC_NONE, attach_kprobe),
+	SEC_DEF("kretprobe.multi/",	KPROBE,	BPF_TRACE_KPROBE_MULTI, SEC_NONE, attach_kprobe),
 	SEC_DEF("tc",			SCHED_CLS, 0, SEC_NONE),
 	SEC_DEF("classifier",		SCHED_CLS, 0, SEC_NONE | SEC_SLOPPY_PFX | SEC_DEPRECATED),
 	SEC_DEF("action",		SCHED_ACT, 0, SEC_NONE | SEC_SLOPPY_PFX),
@@ -10038,6 +10040,113 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
 	return pfd;
 }
 
+/* Adapted from perf/util/string.c */
+static bool glob_match(const char *str, const char *pat)
+{
+	while (*str && *pat && *pat != '*') {
+		if (*pat == '?') {      /* Matches any single character */
+			str++;
+			pat++;
+			continue;
+		}
+		if (*str != *pat)
+			return false;
+		str++;
+		pat++;
+	}
+	/* Check wild card */
+	if (*pat == '*') {
+		while (*pat == '*')
+			pat++;
+		if (!*pat) /* Tail wild card matches all */
+			return true;
+		while (*str)
+			if (glob_match(str++, pat))
+				return true;
+	}
+	return !*str && !*pat;
+}
+
+struct kprobe_multi_resolve {
+	const char *name;
+	__u64 *addrs;
+	size_t cap;
+	size_t cnt;
+};
+
+static int
+resolve_kprobe_multi_cb(unsigned long long sym_addr, char sym_type,
+			const char *sym_name, void *ctx)
+{
+	struct kprobe_multi_resolve *res = ctx;
+	int err;
+
+	if (!glob_match(sym_name, res->name))
+		return 0;
+
+	err = libbpf_ensure_mem((void **)&res->addrs, &res->cap, sizeof(__u64),
+				res->cnt + 1);
+	if (err)
+		return err;
+
+	res->addrs[res->cnt++] = sym_addr;
+	return 0;
+}
+
+static struct bpf_link *
+attach_kprobe_multi_opts(const struct bpf_program *prog,
+		   const char *func_pattern,
+		   const struct bpf_kprobe_opts *kopts)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	struct kprobe_multi_resolve res = {
+		.name = func_pattern,
+	};
+	struct bpf_link *link = NULL;
+	char errmsg[STRERR_BUFSIZE];
+	int err, link_fd, prog_fd;
+	bool retprobe;
+
+	err = libbpf_kallsyms_parse(resolve_kprobe_multi_cb, &res);
+	if (err)
+		goto error;
+	if (!res.cnt) {
+		err = -ENOENT;
+		goto error;
+	}
+
+	retprobe = OPTS_GET(kopts, retprobe, false);
+
+	opts.kprobe_multi.addrs = ptr_to_u64(res.addrs);
+	opts.kprobe_multi.cnt = res.cnt;
+	opts.flags = retprobe ? BPF_F_KPROBE_MULTI_RETURN : 0;
+
+	link = calloc(1, sizeof(*link));
+	if (!link) {
+		err = -ENOMEM;
+		goto error;
+	}
+	link->detach = &bpf_link__detach_fd;
+
+	prog_fd = bpf_program__fd(prog);
+	link_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_KPROBE_MULTI, &opts);
+	if (link_fd < 0) {
+		err = -errno;
+		pr_warn("prog '%s': failed to attach to %s: %s\n",
+			prog->name, res.name,
+			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		goto error;
+	}
+	link->fd = link_fd;
+	free(res.addrs);
+	return link;
+
+error:
+	free(link);
+	free(res.addrs);
+	return libbpf_err_ptr(err);
+}
+
 struct bpf_link *
 bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
 				const char *func_name,
@@ -10054,6 +10163,9 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
 	if (!OPTS_VALID(opts, bpf_kprobe_opts))
 		return libbpf_err_ptr(-EINVAL);
 
+	if (prog->expected_attach_type == BPF_TRACE_KPROBE_MULTI)
+		return attach_kprobe_multi_opts(prog, func_name, opts);
+
 	retprobe = OPTS_GET(opts, retprobe, false);
 	offset = OPTS_GET(opts, offset, 0);
 	pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);
@@ -10122,19 +10234,27 @@ struct bpf_link *bpf_program__attach_kprobe(const struct bpf_program *prog,
 static struct bpf_link *attach_kprobe(const struct bpf_program *prog, long cookie)
 {
 	DECLARE_LIBBPF_OPTS(bpf_kprobe_opts, opts);
+	const char *func_name = NULL;
 	unsigned long offset = 0;
 	struct bpf_link *link;
-	const char *func_name;
 	char *func;
 	int n, err;
 
-	opts.retprobe = str_has_pfx(prog->sec_name, "kretprobe/");
-	if (opts.retprobe)
+	opts.retprobe = str_has_pfx(prog->sec_name, "kretprobe");
+
+	if (str_has_pfx(prog->sec_name, "kretprobe/"))
 		func_name = prog->sec_name + sizeof("kretprobe/") - 1;
-	else
+	else if (str_has_pfx(prog->sec_name, "kprobe/"))
 		func_name = prog->sec_name + sizeof("kprobe/") - 1;
+	else if (str_has_pfx(prog->sec_name, "kretprobe.multi/"))
+		func_name = prog->sec_name + sizeof("kretprobe.multi/") - 1;
+	else if (str_has_pfx(prog->sec_name, "kprobe.multi/"))
+		func_name = prog->sec_name + sizeof("kprobe.multi/") - 1;
+
+	if (!func_name)
+		return libbpf_err_ptr(-EINVAL);
 
-	n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
+	n = sscanf(func_name, "%m[a-zA-Z0-9_.*?]+%li", &func, &offset);
 	if (n < 1) {
 		err = -EINVAL;
 		pr_warn("kprobe name is invalid: %s\n", func_name);
-- 
2.35.1

