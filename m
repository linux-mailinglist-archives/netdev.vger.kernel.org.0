Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9297FDFDA
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 11:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfD2Jww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 05:52:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33822 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727673AbfD2Jwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 05:52:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id v16so12654560wrp.1
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 02:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=25REN8nnRmWaUdI8wv+Zrk5AvtB1lx48Ct8ZVtHTToI=;
        b=IeYIBdBMvtGjukbhI/tu1LdZcaOEyjyRvlnjdC++xMAUfjnWZyAPDL2Z+khju9Fl0h
         9v8Nzj6rffZvY/8cA5OgGbxhzKtfj7k2ARX83gojM3psQbBoWeHFn0OLjuXwjfwZ4tnF
         IVq+q/gnr+XELun1pIxeuIgfxl2eOwRkcQpfeMuV/kCJ4x+0gRO7K4SlHDBeciNuBUuT
         9NVh749HQKcve8N/hIP0NmwjPVSiuPLnK1gGDKcg+XftZA3bvHZbb9jzmcAKphn3Iz5R
         BwblSChN8/cET6Npw9apzTmBPkSe93BQ09fNIRaCay6Z8k/8vZTXaN0D2aGUhww0C9yu
         ux7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=25REN8nnRmWaUdI8wv+Zrk5AvtB1lx48Ct8ZVtHTToI=;
        b=bClRHGgM6E/1eQs6EqJ1zeDNF6lgmxxGSu+/pevwuJ6Ysaeb+mgrXARiiReEg+sabL
         wtph6KJ/pcMecxetWGrjElIJINDfnLh2saazPoFHf0b+oh61yxOmBxQdERyHDt7x28tq
         6VYnU9oZfudI1cG7GE55Mw+BvyaPdMQK5+lM0YTapNLF17C+TFtXdUUA8KcuNWUTSx1+
         C96U1/wPSHpzES5kJ0GvOT27UGh5H9n09c4LqCy008ZEqMfIB6fmPpcXvIB8rD33ip6j
         0QBzT2fZjs2NJIyz21dstd2vjVnJzmGJ76CL/8k92Yex9UhJavKCAmWNpuOrLqCHhcrI
         EhNg==
X-Gm-Message-State: APjAAAXjfY2IfIQzdVt7K+SBbMAwYPmkurGqD8CPklh9b3grlNSqndE0
        gnc7Exc++/wC+91tH/cshjvIWg==
X-Google-Smtp-Source: APXvYqwQ23KDuuKWfXPWPf+NwULK4N0n5rvzS0kdZa8eu3nI6SxP+Hu/5ifqT7hLRCnd5Xsl/PNNjA==
X-Received: by 2002:adf:b611:: with SMTP id f17mr16335439wre.162.1556531567406;
        Mon, 29 Apr 2019 02:52:47 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id x20sm11241535wrg.29.2019.04.29.02.52.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 02:52:46 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next 6/6] tools: bpftool: add --log-verifier option to print kernel debug logs
Date:   Mon, 29 Apr 2019 10:52:27 +0100
Message-Id: <20190429095227.9745-7-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190429095227.9745-1-quentin.monnet@netronome.com>
References: <20190429095227.9745-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new --log-verifier option to set the log level for the kernel
verifier, even in case the program loads successfully. This can be used
to print verifier statistics, for example.

The mandatory argument is a comma-separated list of values, which can be
"level1", "level2", or "stats". The default behaviour for libbpf
consists in ignoring the verifier logs, unless the program fails to
load, in which case "level1" is used.

Example usage:

        # bpftool --log-verifier level1,stats --log-libbpf debug \
                prog load ...

Note that because of the way libbpf prints verifier output, the log
level for libbpf MUST include "debug" for output from the verifier to be
printed when the program loads successfully.

The "--log-all" option is updated to set all log level flags for the
verifier as well.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../bpftool/Documentation/bpftool-prog.rst    | 14 ++++-
 tools/bpf/bpftool/bash-completion/bpftool     |  8 ++-
 tools/bpf/bpftool/main.c                      | 55 ++++++++++++++++---
 tools/bpf/bpftool/main.h                      |  1 +
 tools/bpf/bpftool/prog.c                      | 24 ++++----
 5 files changed, 79 insertions(+), 23 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 0525275f79f1..9c1fe14e607f 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -174,15 +174,25 @@ OPTIONS
 		  Do not automatically attempt to mount any virtual file system
 		  (such as tracefs or BPF virtual file system) when necessary.
 
-	--log-libbpf *LOG_LEVEL*
+	--log-libbpf   *LOG_LEVEL*
 		  Set the log level for libbpf output when attempting to load
 		  programs. *LOG_LEVEL* must be a comma-separated list of the
 		  levels of information to print, which can be **warn**,
 		  **info** or **debug**. The default is **warn,info**.
 
+	--log-verifier *LOG_LEVEL*
+		  Set the log level for the kernel verifier when attempting to
+		  load programs. *LOG_LEVEL* must be a comma-separated list of
+		  the levels of information to print, which can be **level1**,
+		  **level2** or **stats**. Note that to print this information
+		  on a successful load, the log level for libbpf must also
+		  include **debug**. Default behavior, defined by how libbpf
+		  loads the programs, is to print nothing on success, and
+		  **level1** if the program fails to load.
+
 	-l, --log-all
 		  Print all possible log information. This is a shortcut for
-		  **--log-libbpf warn,info,debug**.
+		  **--log-libbpf warn,info,debug --log-verifier level1,level2,stats**.
 
 EXAMPLES
 ========
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index f4ad75c6b243..f02a607f12ff 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -210,7 +210,7 @@ _bpftool()
     # Deal with options
     if [[ ${words[cword]} == -* ]]; then
         local c='--version --json --pretty --bpffs --mapcompat \
-            --log-libbpf --log-all'
+            --log-libbpf --log-verifier --log-all'
         COMPREPLY=( $( compgen -W "$c" -- "$cur" ) )
         return 0
     fi
@@ -236,6 +236,10 @@ _bpftool()
             _bpftool_cslist 'warn info debug'
             return 0
             ;;
+        --log-verifier)
+            _bpftool_cslist 'level1 level2 stats'
+            return 0
+            ;;
     esac
 
     # Remove all options so completions don't have to deal with them.
@@ -244,7 +248,7 @@ _bpftool()
         if [[ ${words[i]::1} == - ]]; then
             # Remove arguments for options, if necessary
             case ${words[i]} in
-                --log-libbpf)
+                --log-libbpf|--log-verifier)
                     words=( "${words[@]:0:i+1}" "${words[@]:i+2}" )
                     [[ $i -le $cword ]] && cword=$(( cword - 1 ))
                     ;;
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 417cff76c7a1..2a4ea1b25b24 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -28,6 +28,7 @@ bool show_pinned;
 bool block_mount;
 int bpf_flags;
 int log_level_libbpf;
+int log_level_verifier;
 struct pinned_obj_table prog_table;
 struct pinned_obj_table map_table;
 
@@ -119,6 +120,35 @@ static int set_libbpf_loglevel(const char *log_str)
 	return 0;
 }
 
+static int set_verifier_loglevel(const char *log_str)
+{
+	char *log_str_cpy, *token;
+
+	log_str_cpy = strdup(log_str);
+	if (!log_str_cpy) {
+		p_err("mem alloc failed");
+		return -1;
+	}
+
+	token = strtok(log_str_cpy, ",");
+	while (token) {
+		if (is_prefix(token, "level1"))
+			log_level_verifier |= BPF_LOG_LEVEL1;
+		else if (is_prefix(token, "level2"))
+			log_level_verifier |= BPF_LOG_LEVEL2;
+		else if (is_prefix(token, "stats"))
+			log_level_verifier |= BPF_LOG_STATS;
+		else
+			p_info("unrecognized log level for verifier: %s",
+			       token);
+
+		token = strtok(NULL, ",");
+	}
+	free(log_str_cpy);
+
+	return 0;
+}
+
 int cmd_select(const struct cmd *cmds, int argc, char **argv,
 	       int (*help)(int argc, char **argv))
 {
@@ -352,15 +382,16 @@ static int do_batch(int argc, char **argv)
 int main(int argc, char **argv)
 {
 	static const struct option options[] = {
-		{ "json",	no_argument,		NULL,	'j' },
-		{ "help",	no_argument,		NULL,	'h' },
-		{ "pretty",	no_argument,		NULL,	'p' },
-		{ "version",	no_argument,		NULL,	'V' },
-		{ "bpffs",	no_argument,		NULL,	'f' },
-		{ "mapcompat",	no_argument,		NULL,	'm' },
-		{ "nomount",	no_argument,		NULL,	'n' },
-		{ "log-libbpf",	required_argument,	NULL,	'd' },
-		{ "log-all",	no_argument,		NULL,	'l' },
+		{ "json",		no_argument,		NULL,	'j' },
+		{ "help",		no_argument,		NULL,	'h' },
+		{ "pretty",		no_argument,		NULL,	'p' },
+		{ "version",		no_argument,		NULL,	'V' },
+		{ "bpffs",		no_argument,		NULL,	'f' },
+		{ "mapcompat",		no_argument,		NULL,	'm' },
+		{ "nomount",		no_argument,		NULL,	'n' },
+		{ "log-libbpf",		required_argument,	NULL,	'd' },
+		{ "log-verifier",	required_argument,	NULL,	'D' },
+		{ "log-all",		no_argument,		NULL,	'l' },
 		{ 0 }
 	};
 	int opt, ret;
@@ -410,9 +441,15 @@ int main(int argc, char **argv)
 			if (set_libbpf_loglevel(optarg))
 				return -1;
 			break;
+		case 'D':
+			if (set_verifier_loglevel(optarg))
+				return -1;
+			break;
 		case 'l':
 			if (set_libbpf_loglevel("warn,info,debug"))
 				return -1;
+			if (set_verifier_loglevel("level1,level2,stats"))
+				return -1;
 			break;
 		default:
 			p_err("unrecognized option '%s'", argv[optind - 1]);
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 3d63feb7f852..4dbfedbbbfab 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -92,6 +92,7 @@ extern bool json_output;
 extern bool show_pinned;
 extern bool block_mount;
 extern int bpf_flags;
+extern int log_level_verifier;
 extern struct pinned_obj_table prog_table;
 extern struct pinned_obj_table map_table;
 
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index fc495b27f0fc..bebece3b1fbf 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -750,10 +750,11 @@ static int do_detach(int argc, char **argv)
 
 static int load_with_options(int argc, char **argv, bool first_prog_only)
 {
-	enum bpf_attach_type expected_attach_type;
-	struct bpf_object_open_attr attr = {
-		.prog_type	= BPF_PROG_TYPE_UNSPEC,
+	struct bpf_object_load_attr load_attr = { 0 };
+	struct bpf_object_open_attr open_attr = {
+		.prog_type = BPF_PROG_TYPE_UNSPEC,
 	};
+	enum bpf_attach_type expected_attach_type;
 	struct map_replace *map_replace = NULL;
 	struct bpf_program *prog = NULL, *pos;
 	unsigned int old_map_fds = 0;
@@ -767,7 +768,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 
 	if (!REQ_ARGS(2))
 		return -1;
-	attr.file = GET_ARG();
+	open_attr.file = GET_ARG();
 	pinfile = GET_ARG();
 
 	while (argc) {
@@ -776,7 +777,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 
 			NEXT_ARG();
 
-			if (attr.prog_type != BPF_PROG_TYPE_UNSPEC) {
+			if (open_attr.prog_type != BPF_PROG_TYPE_UNSPEC) {
 				p_err("program type already specified");
 				goto err_free_reuse_maps;
 			}
@@ -793,7 +794,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 			strcat(type, *argv);
 			strcat(type, "/");
 
-			err = libbpf_prog_type_by_name(type, &attr.prog_type,
+			err = libbpf_prog_type_by_name(type,
+						       &open_attr.prog_type,
 						       &expected_attach_type);
 			free(type);
 			if (err < 0)
@@ -879,16 +881,16 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		}
 	}
 
-	obj = __bpf_object__open_xattr(&attr, bpf_flags);
+	obj = __bpf_object__open_xattr(&open_attr, bpf_flags);
 	if (IS_ERR_OR_NULL(obj)) {
 		p_err("failed to open object file");
 		goto err_free_reuse_maps;
 	}
 
 	bpf_object__for_each_program(pos, obj) {
-		enum bpf_prog_type prog_type = attr.prog_type;
+		enum bpf_prog_type prog_type = open_attr.prog_type;
 
-		if (attr.prog_type == BPF_PROG_TYPE_UNSPEC) {
+		if (open_attr.prog_type == BPF_PROG_TYPE_UNSPEC) {
 			const char *sec_name = bpf_program__title(pos, false);
 
 			err = libbpf_prog_type_by_name(sec_name, &prog_type,
@@ -960,7 +962,9 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 
 	set_max_rlimit();
 
-	err = bpf_object__load(obj);
+	load_attr.obj = obj;
+	load_attr.log_level = log_level_verifier;
+	err = bpf_object__load_xattr(&load_attr);
 	if (err) {
 		p_err("failed to load object file");
 		goto err_close_obj;
-- 
2.17.1

