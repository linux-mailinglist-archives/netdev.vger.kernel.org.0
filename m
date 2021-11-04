Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7F34456B5
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 17:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhKDQFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 12:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbhKDQFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 12:05:52 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE5BC06127A
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 09:03:14 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id v63-20020a632f42000000b002cc65837088so4084641pgv.1
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 09:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OaTSiZCVwbk0WOSrCQSuGoj/xjNhXzJAkvT491kaM2A=;
        b=p+bwUuEfehbqSFmtzgJRXpT+IMugkHLrVVma79oLvWHdM4/fPPX+y3kMMSv+5V2APX
         ehCS4sopRsH2Brfv+Je3DDEL4HLseI6CNdtRxg7/1S2c1UtRwXZM3SL7nf4c8TfhMqXH
         gYX1w/QKKyXde/ORLtR2pkGu6I7G6Ac9ZBRVLCLJGVgoe+TZGF/pnWTbEnJcaLTMx3bF
         arhU0Qo3lFlDMtDfLQi+H25zTR2rz9qcAqSzBbnOfsIqI/2i3d++xlT/SCLKnjmGxOxH
         mGzv20HlxLbyg8KEYl8G10cYD2jxWqPDMM7vu8JsUvYXz12JQIYwkzl1KJaf+rOaYPHs
         Nw3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OaTSiZCVwbk0WOSrCQSuGoj/xjNhXzJAkvT491kaM2A=;
        b=SKxzuIXilmAQoDPqT2IYzuL9VU14S4hduH/AnvS0enVwyJJaZRSOhG9v8zGcXhbipl
         CbVrPXMwlrPqrRvnJpwoCXM34GmgDJSWD2mMAdTxXA0uNLzgnMg2cCXKZYLQ/Xco7rac
         7oPGor0NZ7BBJ5N+08HDuQs5DqLt/Ngy5C7hAG1Fyf2AjJPer1RyN9mkOHqSxQ41mgPl
         MwZ932tWicZowS5buXN8D9ZTmcxkRzcNsaaOnZhgKVSMpBXxg4PYg9RWmSaQ6aN72MY4
         XMdeCsrKX2VJ41jFxX8jAm61rlXOb1lFmzlYZJCQ8yR+yHI267MSYt0/g6B3e4+Uk07k
         cYlA==
X-Gm-Message-State: AOAM532h5h6kDKmKglzx/S/aqaHa4kWEOySTxTJSAeaznHsXdzr/gpMK
        Rpo7IMMjKJquucNEd3wSeddbTVKY03LJStnyWPvCI74/5mGm/1Og4xWqX87QNC5tQMZ6IcMTTgK
        DFlCWR70ix7uG+15vxbpvHHiy+3CpIZ3Hny+IY+4vB4vJTQlky3NtLA==
X-Google-Smtp-Source: ABdhPJwEXkNxwdm2AuElxlEO4vHwEV1EHs4ZSDj2P1ThmjSnp+mt27F1FVJe0zkJqylv/vukjey/0t8=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:268c:cb2d:5cc8:ad4])
 (user=sdf job=sendgmr) by 2002:a05:6a00:1816:b0:481:1010:c0f with SMTP id
 y22-20020a056a00181600b0048110100c0fmr29151759pfa.67.1636041793882; Thu, 04
 Nov 2021 09:03:13 -0700 (PDT)
Date:   Thu,  4 Nov 2021 09:03:11 -0700
Message-Id: <20211104160311.4028188-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH bpf-next] bpftool: add option to enable libbpf's strict mode
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise, attaching with bpftool doesn't work with strict section names.

Also:

- by default, don't append / to the section name; in strict
  mode it's relevant only for a small subset of prog types
- print a deprecation warning when requested to pin all programs

+ bpftool prog loadall tools/testing/selftests/bpf/test_probe_user.o /sys/fs/bpf/kprobe type kprobe
Warning: pinning by section name is deprecated, use --strict to pin by function name.
See: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#pinning-path-differences

+ bpftool prog loadall tools/testing/selftests/bpf/xdp_dummy.o /sys/fs/bpf/xdp type xdp
Warning: pinning by section name is deprecated, use --strict to pin by function name.
See: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#pinning-path-differences

+ bpftool --strict prog loadall tools/testing/selftests/bpf/test_probe_user.o /sys/fs/bpf/kprobe type kprobe
+ bpftool --strict prog loadall tools/testing/selftests/bpf/xdp_dummy.o /sys/fs/bpf/xdp type xdp

Cc: Quentin Monnet <quentin@isovalent.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../bpftool/Documentation/common_options.rst  |  6 +++
 tools/bpf/bpftool/main.c                      | 13 +++++-
 tools/bpf/bpftool/main.h                      |  1 +
 tools/bpf/bpftool/prog.c                      | 40 +++++++++++--------
 4 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/common_options.rst b/tools/bpf/bpftool/Documentation/common_options.rst
index 05d06c74dcaa..28710f9005be 100644
--- a/tools/bpf/bpftool/Documentation/common_options.rst
+++ b/tools/bpf/bpftool/Documentation/common_options.rst
@@ -20,3 +20,9 @@
 	  Print all logs available, even debug-level information. This includes
 	  logs from libbpf as well as from the verifier, when attempting to
 	  load programs.
+
+-S, --strict
+	  Use strict (aka v1.0) libbpf mode which has more stringent section
+	  name requirements.
+	  See https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#pinning-path-differences
+	  for details.
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 28237d7cef67..10c72089e599 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -31,6 +31,7 @@ bool block_mount;
 bool verifier_logs;
 bool relaxed_maps;
 bool use_loader;
+bool strict_libbpf;
 struct btf *base_btf;
 struct hashmap *refs_table;
 
@@ -396,6 +397,7 @@ int main(int argc, char **argv)
 		{ "debug",	no_argument,	NULL,	'd' },
 		{ "use-loader",	no_argument,	NULL,	'L' },
 		{ "base-btf",	required_argument, NULL, 'B' },
+		{ "strict",	no_argument,	NULL,	'S' },
 		{ 0 }
 	};
 	int opt, ret;
@@ -408,7 +410,7 @@ int main(int argc, char **argv)
 	bin_name = argv[0];
 
 	opterr = 0;
-	while ((opt = getopt_long(argc, argv, "VhpjfLmndB:",
+	while ((opt = getopt_long(argc, argv, "VhpjfLmndB:S",
 				  options, NULL)) >= 0) {
 		switch (opt) {
 		case 'V':
@@ -454,6 +456,9 @@ int main(int argc, char **argv)
 		case 'L':
 			use_loader = true;
 			break;
+		case 'S':
+			strict_libbpf = true;
+			break;
 		default:
 			p_err("unrecognized option '%s'", argv[optind - 1]);
 			if (json_output)
@@ -463,6 +468,12 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (strict_libbpf) {
+		ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+		if (ret)
+			p_err("failed to enable libbpf strict mode: %d", ret);
+	}
+
 	argc -= optind;
 	argv += optind;
 	if (argc < 0)
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 383835c2604d..b67fa8d8532d 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -90,6 +90,7 @@ extern bool block_mount;
 extern bool verifier_logs;
 extern bool relaxed_maps;
 extern bool use_loader;
+extern bool strict_libbpf;
 extern struct btf *base_btf;
 extern struct hashmap *refs_table;
 
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index dea7a49ec26e..47b321d32b82 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1483,8 +1483,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 
 	while (argc) {
 		if (is_prefix(*argv, "type")) {
-			char *type;
-
 			NEXT_ARG();
 
 			if (common_prog_type != BPF_PROG_TYPE_UNSPEC) {
@@ -1494,21 +1492,26 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 			if (!REQ_ARGS(1))
 				goto err_free_reuse_maps;
 
-			/* Put a '/' at the end of type to appease libbpf */
-			type = malloc(strlen(*argv) + 2);
-			if (!type) {
-				p_err("mem alloc failed");
-				goto err_free_reuse_maps;
-			}
-			*type = 0;
-			strcat(type, *argv);
-			strcat(type, "/");
+			err = libbpf_prog_type_by_name(*argv, &common_prog_type,
+						       &expected_attach_type);
+			if (err < 0) {
+				/* Put a '/' at the end of type to appease libbpf */
+				char *type = malloc(strlen(*argv) + 2);
 
-			err = get_prog_type_by_name(type, &common_prog_type,
-						    &expected_attach_type);
-			free(type);
-			if (err < 0)
-				goto err_free_reuse_maps;
+				if (!type) {
+					p_err("mem alloc failed");
+					goto err_free_reuse_maps;
+				}
+				*type = 0;
+				strcat(type, *argv);
+				strcat(type, "/");
+
+				err = get_prog_type_by_name(type, &common_prog_type,
+							    &expected_attach_type);
+				free(type);
+				if (err < 0)
+					goto err_free_reuse_maps;
+			}
 
 			NEXT_ARG();
 		} else if (is_prefix(*argv, "map")) {
@@ -1700,6 +1703,11 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 			goto err_close_obj;
 		}
 	} else {
+		if (!strict_libbpf) {
+			p_info("Warning: pinning by section name is deprecated, use --strict to pin by function name.\n"
+			       "See: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#pinning-path-differences\n");
+		}
+
 		err = bpf_object__pin_programs(obj, pinfile);
 		if (err) {
 			p_err("failed to pin all programs");
-- 
2.33.1.1089.g2158813163f-goog

