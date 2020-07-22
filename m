Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8244229001
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 07:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgGVFnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 01:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgGVFnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 01:43:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A1CC0619DB
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 22:43:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n141so1162580yba.13
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 22:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RH1b8CqfaUtf0lENEBZXL4UmvaK8XhlmPiXzra6AL6E=;
        b=h/SIt0W6GnYy7DzEnHllHEnhs7frlpA4jxCt8DwR1Ea2yfiC4axjAF2isQx7VI0+To
         kA7M8Fdp+rB9YiJv0dm41DdfxlMOQn5/Vh5jZryiVTZ+Lqzhv4SR4xNPH7E/Q0y/H819
         tIT8cKWIMpW7+aNHXEt9fiSOLmxK/5WKruVPBSgTfcGm7sphMTNt6ByaLg/t76kQQMzG
         buWFadRLTERIqimYceYsuA7Ixg6O9B+QPko8VcjeKwCIvbForvNb0J3tRoNulYT2/b8b
         de+8nvyEflAVJHLwV1/uukN4DReOXethUBjD39wqjTP07cPnfnojq83ngUCe8CVHtX6i
         HsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RH1b8CqfaUtf0lENEBZXL4UmvaK8XhlmPiXzra6AL6E=;
        b=GJkAECUGSBhiufvFhAKwQPmnBtILjgrWps2cYXFhjqsVBMsOJpE4b4FIWGSHL3CkO5
         OCiUiaqDsAGq86eKOPreS/K5zoFMAvhf39XblQ09M+dS9/w+mmttmqYHDguMVPRdCD1C
         h2w6Ex4q3wCyPvCU32WsJD70m2JYx+9P7fO/tXUjC6HDOSjDLFBz4+V1VsA9uiWOuZCn
         5ztz5LTVhU5/Rh3yjmFtUEoQZCF6fuQdCR3N0cpDyOx4VsbBxmvIVhQk9AWKGBdHsFzn
         pbxH0CtgRuvMdhjU3mo6YADr/emyAmvPVY+w7RRbrb0Q5PiRwuXVYjf96/LvunTi+3wG
         Q01Q==
X-Gm-Message-State: AOAM533LiJDEYrCU1l8SPkwSS1E0c9SaqeXN944Tr48Mwj0d7aTT925S
        kHVoxagH1fOMClDDQI+aw9yT5ilv6iFg
X-Google-Smtp-Source: ABdhPJzgpysByI+Klyxrvc3KRFzpECTww/sm5FBXvRkap/u7ghFv0EuUocQzv0aODK8ZgTxZL1dk1Wib8xjE
X-Received: by 2002:a25:a089:: with SMTP id y9mr51593597ybh.106.1595396600840;
 Tue, 21 Jul 2020 22:43:20 -0700 (PDT)
Date:   Tue, 21 Jul 2020 22:43:14 -0700
Message-Id: <20200722054314.2103880-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [RFC PATCH] bpftool btf: Add prefix option to dump C
From:   Ian Rogers <irogers@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        "=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?=" <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When bpftool dumps types and enum members into a header file for
inclusion the names match those in the original source. If the same
header file needs to be included in the original source and the bpf
program, the names of structs, unions, typedefs and enum members will
have naming collisions.

To avoid these collisions an approach is to redeclare the header file
types and enum members, which leads to duplication and possible
inconsistencies. Another approach is to use preprocessor macros
to rename conflicting names, but this can be cumbersome if there are
many conflicts.

This patch adds a prefix option for the dumped names. Use of this option
can avoid name conflicts and compile time errors.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 .../bpf/bpftool/Documentation/bpftool-btf.rst |  7 ++++++-
 tools/bpf/bpftool/btf.c                       | 18 ++++++++++++++---
 tools/lib/bpf/btf.h                           |  1 +
 tools/lib/bpf/btf_dump.c                      | 20 +++++++++++++------
 4 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 896f4c6c2870..85d66bc69634 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -20,7 +20,7 @@ BTF COMMANDS
 =============
 
 |	**bpftool** **btf** { **show** | **list** } [**id** *BTF_ID*]
-|	**bpftool** **btf dump** *BTF_SRC* [**format** *FORMAT*]
+|	**bpftool** **btf dump** *BTF_SRC* [**format** *FORMAT*] [**prefix** *PREFIX*]
 |	**bpftool** **btf help**
 |
 |	*BTF_SRC* := { **id** *BTF_ID* | **prog** *PROG* | **map** *MAP* [{**key** | **value** | **kv** | **all**}] | **file** *FILE* }
@@ -66,6 +66,11 @@ DESCRIPTION
 		  output format. Raw (**raw**) or C-syntax (**c**) output
 		  formats are supported.
 
+		  With the C-syntax format the **prefix** option can
+                  be used to prefix all identifiers and enum members
+                  with *PREFIX*. This is useful to avoid naming
+                  collisions.
+
 	**bpftool btf help**
 		  Print short help message.
 
diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index fc9bc7a23db6..6a428636fa6f 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -379,12 +379,15 @@ static void __printf(2, 0) btf_dump_printf(void *ctx,
 }
 
 static int dump_btf_c(const struct btf *btf,
-		      __u32 *root_type_ids, int root_type_cnt)
+		      __u32 *root_type_ids, int root_type_cnt, const char *name_prefix)
 {
 	struct btf_dump *d;
 	int err = 0, i;
+	struct btf_dump_opts opts = {
+		.name_prefix = name_prefix,
+	};
 
-	d = btf_dump__new(btf, NULL, NULL, btf_dump_printf);
+	d = btf_dump__new(btf, NULL, &opts, btf_dump_printf);
 	if (IS_ERR(d))
 		return PTR_ERR(d);
 
@@ -478,6 +481,7 @@ static int do_dump(int argc, char **argv)
 	bool dump_c = false;
 	__u32 btf_id = -1;
 	const char *src;
+	const char *c_prefix = NULL;
 	int fd = -1;
 	int err;
 
@@ -583,6 +587,14 @@ static int do_dump(int argc, char **argv)
 				goto done;
 			}
 			NEXT_ARG();
+		} else if (is_prefix(*argv, "prefix")) {
+			NEXT_ARG();
+			if (argc < 1 || !*argv) {
+				p_err("expecting value for 'prefix' option\n");
+				goto done;
+			}
+			c_prefix = *argv;
+			NEXT_ARG();
 		} else {
 			p_err("unrecognized option: '%s'", *argv);
 			goto done;
@@ -608,7 +620,7 @@ static int do_dump(int argc, char **argv)
 			err = -ENOTSUP;
 			goto done;
 		}
-		err = dump_btf_c(btf, root_type_ids, root_type_cnt);
+		err = dump_btf_c(btf, root_type_ids, root_type_cnt, c_prefix);
 	} else {
 		err = dump_btf_raw(btf, root_type_ids, root_type_cnt);
 	}
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 491c7b41ffdc..fea4baab00bd 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -117,6 +117,7 @@ struct btf_dump;
 
 struct btf_dump_opts {
 	void *ctx;
+	const char *name_prefix;
 };
 
 typedef void (*btf_dump_printf_fn_t)(void *ctx, const char *fmt, va_list args);
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index e1c344504cae..baf2b4d82e1e 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -138,6 +138,7 @@ struct btf_dump *btf_dump__new(const struct btf *btf,
 	d->btf_ext = btf_ext;
 	d->printf_fn = printf_fn;
 	d->opts.ctx = opts ? opts->ctx : NULL;
+	d->opts.name_prefix = opts ? opts->name_prefix : NULL;
 
 	d->type_names = hashmap__new(str_hash_fn, str_equal_fn, NULL);
 	if (IS_ERR(d->type_names)) {
@@ -903,6 +904,7 @@ static void btf_dump_emit_enum_def(struct btf_dump *d, __u32 id,
 	const struct btf_enum *v = btf_enum(t);
 	__u16 vlen = btf_vlen(t);
 	const char *name;
+	const char *name_prefix = d->opts.name_prefix;
 	size_t dup_cnt;
 	int i;
 
@@ -912,17 +914,19 @@ static void btf_dump_emit_enum_def(struct btf_dump *d, __u32 id,
 
 	if (vlen) {
 		btf_dump_printf(d, " {");
+		if (!name_prefix)
+			name_prefix = "";
 		for (i = 0; i < vlen; i++, v++) {
 			name = btf_name_of(d, v->name_off);
 			/* enumerators share namespace with typedef idents */
 			dup_cnt = btf_dump_name_dups(d, d->ident_names, name);
 			if (dup_cnt > 1) {
-				btf_dump_printf(d, "\n%s%s___%zu = %u,",
-						pfx(lvl + 1), name, dup_cnt,
+				btf_dump_printf(d, "\n%s%s%s___%zu = %u,",
+						pfx(lvl + 1), name_prefix, name, dup_cnt,
 						(__u32)v->val);
 			} else {
-				btf_dump_printf(d, "\n%s%s = %u,",
-						pfx(lvl + 1), name,
+				btf_dump_printf(d, "\n%s%s%s = %u,",
+						pfx(lvl + 1), name_prefix, name,
 						(__u32)v->val);
 			}
 		}
@@ -1360,6 +1364,7 @@ static const char *btf_dump_resolve_name(struct btf_dump *d, __u32 id,
 	const struct btf_type *t = btf__type_by_id(d->btf, id);
 	const char *orig_name = btf_name_of(d, t->name_off);
 	const char **cached_name = &d->cached_names[id];
+	const char *prefix = d->opts.name_prefix;
 	size_t dup_cnt;
 
 	if (t->name_off == 0)
@@ -1369,11 +1374,14 @@ static const char *btf_dump_resolve_name(struct btf_dump *d, __u32 id,
 		return *cached_name ? *cached_name : orig_name;
 
 	dup_cnt = btf_dump_name_dups(d, name_map, orig_name);
-	if (dup_cnt > 1) {
+	if (dup_cnt > 1 || prefix) {
 		const size_t max_len = 256;
 		char new_name[max_len];
 
-		snprintf(new_name, max_len, "%s___%zu", orig_name, dup_cnt);
+		if (dup_cnt > 1)
+			snprintf(new_name, max_len, "%s%s___%zu", prefix, orig_name, dup_cnt);
+		else
+			snprintf(new_name, max_len, "%s%s", prefix, orig_name);
 		*cached_name = strdup(new_name);
 	}
 
-- 
2.28.0.rc0.105.gf9edc3c819-goog

