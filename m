Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EBF4DAFB6
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355714AbiCPM1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355726AbiCPM1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:27:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F3C66209;
        Wed, 16 Mar 2022 05:26:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EC10B81AE4;
        Wed, 16 Mar 2022 12:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03ABC340E9;
        Wed, 16 Mar 2022 12:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433573;
        bh=28H8vEvBCKD8KJe6uDw+X4he4Z2/cTVbxXH/1j9pOxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJ5wfu4GGGe5SHTOKgHLtW7oVosx1La68zqTwNXVVermaRiQZUPKoIrThHhDaCAyK
         5MkIA504BF/Pvjby0HjwHsYrUzwLlJmbQZs/aCUVCbddFJC+O5BtOapYUquOWbr1Tz
         dGKrLdI0iRfCbrXVFzadE2RxSeGgo+fMnwKmvbn5+S2t+476av+/bxbGHDNANHG7l4
         p1XzU2nVHEjnYAhriGDTht4/OcDs3K2AO2xRTYs3q3x2BygXfM3WakNoHgZ9IV/6Rv
         VoZIdhyppZkmU3LaOzPXLODjogmT+vU8AokQFCKmYuPgqWrto9vhNvS9W2aQt3I89w
         voxSyFUH7zF6w==
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
Subject: [PATCHv3 bpf-next 09/13] libbpf: Add bpf_program__attach_kprobe_multi_opts function
Date:   Wed, 16 Mar 2022 13:24:15 +0100
Message-Id: <20220316122419.933957-10-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316122419.933957-1-jolsa@kernel.org>
References: <20220316122419.933957-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding bpf_program__attach_kprobe_multi_opts function for attaching
kprobe program to multiple functions.

  struct bpf_link *
  bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
                                        const char *pattern,
                                        const struct bpf_kprobe_multi_opts *opts);

User can specify functions to attach with 'pattern' argument that
allows wildcards (*?' supported) or provide symbols or addresses
directly through opts argument. These 3 options are mutually
exclusive.

When using symbols or addresses, user can also provide cookie value
for each symbol/address that can be retrieved later in bpf program
with bpf_get_attach_cookie helper.

  struct bpf_kprobe_multi_opts {
          size_t sz;
          const char **syms;
          const unsigned long *addrs;
          const __u64 *cookies;
          size_t cnt;
          bool retprobe;
          size_t :0;
  };

Symbols, addresses and cookies are provided through opts object
(syms/addrs/cookies) as array pointers with specified count (cnt).

Each cookie value is paired with provided function address or symbol
with the same array index.

The program can be also attached as return probe if 'retprobe' is set.

For quick usage with NULL opts argument, like:

  bpf_program__attach_kprobe_multi_opts(prog, "ksys_*", NULL)

the 'prog' will be attached as kprobe to 'ksys_*' functions.

Also adding new program sections for automatic attachment:

  kprobe.multi/<symbol_pattern>
  kretprobe.multi/<symbol_pattern>

The symbol_pattern is used as 'pattern' argument in
bpf_program__attach_kprobe_multi_opts function.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c   | 160 +++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  23 ++++++
 tools/lib/bpf/libbpf.map |   1 +
 3 files changed, 184 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1ca520a29fdb..f3a31478e23b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8610,6 +8610,7 @@ static int attach_kprobe(const struct bpf_program *prog, long cookie, struct bpf
 static int attach_tp(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_raw_tp(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_trace(const struct bpf_program *prog, long cookie, struct bpf_link **link);
+static int attach_kprobe_multi(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_lsm(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_iter(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 
@@ -8621,6 +8622,8 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("uprobe/",		KPROBE,	0, SEC_NONE),
 	SEC_DEF("kretprobe/",		KPROBE, 0, SEC_NONE, attach_kprobe),
 	SEC_DEF("uretprobe/",		KPROBE, 0, SEC_NONE),
+	SEC_DEF("kprobe.multi/",	KPROBE,	BPF_TRACE_KPROBE_MULTI, SEC_NONE, attach_kprobe_multi),
+	SEC_DEF("kretprobe.multi/",	KPROBE,	BPF_TRACE_KPROBE_MULTI, SEC_NONE, attach_kprobe_multi),
 	SEC_DEF("tc",			SCHED_CLS, 0, SEC_NONE),
 	SEC_DEF("classifier",		SCHED_CLS, 0, SEC_NONE | SEC_SLOPPY_PFX | SEC_DEPRECATED),
 	SEC_DEF("action",		SCHED_ACT, 0, SEC_NONE | SEC_SLOPPY_PFX),
@@ -10224,6 +10227,139 @@ struct bpf_link *bpf_program__attach_kprobe(const struct bpf_program *prog,
 	return bpf_program__attach_kprobe_opts(prog, func_name, &opts);
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
+	const char *pattern;
+	unsigned long *addrs;
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
+	if (!glob_match(sym_name, res->pattern))
+		return 0;
+
+	err = libbpf_ensure_mem((void **) &res->addrs, &res->cap, sizeof(unsigned long),
+				res->cnt + 1);
+	if (err)
+		return err;
+
+	res->addrs[res->cnt++] = (unsigned long) sym_addr;
+	return 0;
+}
+
+struct bpf_link *
+bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
+				      const char *pattern,
+				      const struct bpf_kprobe_multi_opts *opts)
+{
+	LIBBPF_OPTS(bpf_link_create_opts, lopts);
+	struct kprobe_multi_resolve res = {
+		.pattern = pattern,
+	};
+	struct bpf_link *link = NULL;
+	char errmsg[STRERR_BUFSIZE];
+	const unsigned long *addrs;
+	int err, link_fd, prog_fd;
+	const __u64 *cookies;
+	const char **syms;
+	bool retprobe;
+	size_t cnt;
+
+	if (!OPTS_VALID(opts, bpf_kprobe_multi_opts))
+		return libbpf_err_ptr(-EINVAL);
+
+	syms    = OPTS_GET(opts, syms, false);
+	addrs   = OPTS_GET(opts, addrs, false);
+	cnt     = OPTS_GET(opts, cnt, false);
+	cookies = OPTS_GET(opts, cookies, false);
+
+	if (!pattern && !addrs && !syms)
+		return libbpf_err_ptr(-EINVAL);
+	if (pattern && (addrs || syms || cookies || cnt))
+		return libbpf_err_ptr(-EINVAL);
+	if (!pattern && !cnt)
+		return libbpf_err_ptr(-EINVAL);
+	if (addrs && syms)
+		return libbpf_err_ptr(-EINVAL);
+
+	if (pattern) {
+		err = libbpf_kallsyms_parse(resolve_kprobe_multi_cb, &res);
+		if (err)
+			goto error;
+		if (!res.cnt) {
+			err = -ENOENT;
+			goto error;
+		}
+		addrs = res.addrs;
+		cnt = res.cnt;
+	}
+
+	retprobe = OPTS_GET(opts, retprobe, false);
+
+	lopts.kprobe_multi.syms = syms;
+	lopts.kprobe_multi.addrs = addrs;
+	lopts.kprobe_multi.cookies = cookies;
+	lopts.kprobe_multi.cnt = cnt;
+	lopts.kprobe_multi.flags = retprobe ? BPF_F_KPROBE_MULTI_RETURN : 0;
+
+	link = calloc(1, sizeof(*link));
+	if (!link) {
+		err = -ENOMEM;
+		goto error;
+	}
+	link->detach = &bpf_link__detach_fd;
+
+	prog_fd = bpf_program__fd(prog);
+	link_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_KPROBE_MULTI, &lopts);
+	if (link_fd < 0) {
+		err = -errno;
+		pr_warn("prog '%s': failed to attach: %s\n",
+			prog->name, libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
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
 static int attach_kprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link)
 {
 	DECLARE_LIBBPF_OPTS(bpf_kprobe_opts, opts);
@@ -10255,6 +10391,30 @@ static int attach_kprobe(const struct bpf_program *prog, long cookie, struct bpf
 	return libbpf_get_error(*link);
 }
 
+static int attach_kprobe_multi(const struct bpf_program *prog, long cookie, struct bpf_link **link)
+{
+	LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);
+	const char *spec;
+	char *pattern;
+	int n;
+
+	opts.retprobe = str_has_pfx(prog->sec_name, "kretprobe.multi/");
+	if (opts.retprobe)
+		spec = prog->sec_name + sizeof("kretprobe.multi/") - 1;
+	else
+		spec = prog->sec_name + sizeof("kprobe.multi/") - 1;
+
+	n = sscanf(spec, "%m[a-zA-Z0-9_.*?]", &pattern);
+	if (n < 1) {
+		pr_warn("kprobe multi pattern is invalid: %s\n", pattern);
+		return -EINVAL;
+	}
+
+	*link = bpf_program__attach_kprobe_multi_opts(prog, pattern, &opts);
+	free(pattern);
+	return libbpf_get_error(*link);
+}
+
 static void gen_uprobe_legacy_event_name(char *buf, size_t buf_sz,
 					 const char *binary_path, uint64_t offset)
 {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c1b0c2ef14d8..d5239fb4abdc 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -425,6 +425,29 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
                                 const char *func_name,
                                 const struct bpf_kprobe_opts *opts);
 
+struct bpf_kprobe_multi_opts {
+	/* size of this struct, for forward/backward compatibility */
+	size_t sz;
+	/* array of function symbols to attach */
+	const char **syms;
+	/* array of function addresses to attach */
+	const unsigned long *addrs;
+	/* array of user-provided values fetchable through bpf_get_attach_cookie */
+	const __u64 *cookies;
+	/* number of elements in syms/addrs/cookies arrays */
+	size_t cnt;
+	/* create return kprobes */
+	bool retprobe;
+	size_t :0;
+};
+
+#define bpf_kprobe_multi_opts__last_field retprobe
+
+LIBBPF_API struct bpf_link *
+bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
+				      const char *pattern,
+				      const struct bpf_kprobe_multi_opts *opts);
+
 struct bpf_uprobe_opts {
 	/* size of this struct, for forward/backward compatiblity */
 	size_t sz;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index df1b947792c8..554c56e6e5d3 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -444,4 +444,5 @@ LIBBPF_0.8.0 {
 	global:
 		libbpf_register_prog_handler;
 		libbpf_unregister_prog_handler;
+		bpf_program__attach_kprobe_multi_opts;
 } LIBBPF_0.7.0;
-- 
2.35.1

