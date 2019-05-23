Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054EE27B24
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 12:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbfEWKyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 06:54:46 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37671 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730318AbfEWKyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 06:54:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id 7so5289323wmo.2
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 03:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fUwJHI9sVqnaGnCWZooowg6nUP9siefbX2fmhZBZPYY=;
        b=JYKjHUYAoGPGajlnvzas1CrlX37peYxC2B0G74el0iJZ9CbHrZicdGGtX/sT5gaVis
         Iu6nkdiZIP3rxw6CElAUyVU2rhi9G60mxd0zjD2VAA/fxKJhwQTLRS1H/0l3c7hcGqAM
         /4CZ1mSj8+wl89X1FxRNYkZ5yZlTpyC2l5jnQYRC9CfsHAp5sM5CJkjio1hEHuUR7sIF
         y19j7AASkbTSuNqGakJdaQ8+pJuTPgV752Zzge3Aen97Eb/45EEneEnTUYImeLafSDjU
         nV+g53v5SxDkYC4dwOqqkZ5tDSZZapYdh0NTrvngi8lV9hZMcE1NWajtZEZc6rfF3K+2
         m0Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fUwJHI9sVqnaGnCWZooowg6nUP9siefbX2fmhZBZPYY=;
        b=hygO2zVGUf3JVDiiRMOBlEruQG5PVKdA8jGEFjcf1xG0lAsrNVcVagXCos31ILsAR7
         1FlzZ61HGY/gsSXXZ8vKlotKgXDvCEU50wkiVp4hcfQFlitrI7m5ben5GFywqppLLhXg
         dH5T9TdKlhHOudnqpEe4IbvewYQZQmuoJcWouYdigetD7yJ5C/TLKfFNP6DluHyqZ40X
         KNSopj3lAxRPVi36fm/lQbQWtWK8llk7Lr0YkCjbZ4MUr0MUcnmZzmjI9AJm2j3ndc7k
         e6YWZhj3aEb0KDkB/MBa0ygzjRaMQPxEoNh/i5JdGTN16uiixQ2WCkR0/Bt0mo+N5h0k
         6YPA==
X-Gm-Message-State: APjAAAUR0YUxs0MRksDzp4U1/pNT1vKFoDRixwrRxYBxhhhCfgzhaBkc
        J/VlJ/8pxChTKNchFRv+JoeQdw==
X-Google-Smtp-Source: APXvYqykdFzX1faeciXJgeAeFwierJLHl7bhWPdQeat704Wle3GkqIKt4Pslom8Qyhig7gre2qFlMQ==
X-Received: by 2002:a1c:1f95:: with SMTP id f143mr11973561wmf.16.1558608879831;
        Thu, 23 May 2019 03:54:39 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id p8sm21285740wro.0.2019.05.23.03.54.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 03:54:39 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v2 3/3] tools: bpftool: make -d option print debug output from verifier
Date:   Thu, 23 May 2019 11:54:26 +0100
Message-Id: <20190523105426.3938-4-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523105426.3938-1-quentin.monnet@netronome.com>
References: <20190523105426.3938-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "-d" option is used to require all logs available for bpftool. So
far it meant telling libbpf to print even debug-level information. But
there is another source of info that can be made more verbose: when we
attemt to load programs with bpftool, we can pass a log_level parameter
to the verifier in order to control the amount of information that is
printed to the console.

Reuse the "-d" option to print all information the verifier can tell. At
this time, this means logs related to BPF_LOG_LEVEL1, BPF_LOG_LEVEL2 and
BPF_LOG_STATS. As mentioned in the discussion on the first version of
this set, these macros are internal to the kernel
(include/linux/bpf_verifier.h) and are not meant to be part of the
stable user API, therefore we simply use the related constants to print
whatever we can at this time, without trying to tell users what is
log_level1 or what is statistics.

Verifier logs are only used when loading programs for now (in the
future: for loading BTF objects with bpftool?), so bpftool.rst and
bpftool-prog.rst are the only man pages to get the update.

v2:
- Remove the possibility to select the log levels to use (v1 offered a
  combination of "log_level1", "log_level2" and "stats").
- The macros from kernel header bpf_verifier.h are not used (and
  therefore not moved to UAPI header).
- In v1 this was a distinct option, but is now merged in the only "-d"
  switch to activate libbpf and verifier debug-level logs all at the
  same time.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../bpftool/Documentation/bpftool-prog.rst    |  5 ++--
 tools/bpf/bpftool/Documentation/bpftool.rst   |  5 ++--
 tools/bpf/bpftool/main.c                      |  2 ++
 tools/bpf/bpftool/main.h                      |  1 +
 tools/bpf/bpftool/prog.c                      | 27 ++++++++++++-------
 5 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 9a92614569e6..228a5c863cc7 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -175,8 +175,9 @@ OPTIONS
 		  (such as tracefs or BPF virtual file system) when necessary.
 
 	-d, --debug
-		  Print all logs available from libbpf, including debug-level
-		  information.
+		  Print all logs available, even debug-level information. This
+		  includes logs from libbpf as well as from the verifier, when
+		  attempting to load programs.
 
 EXAMPLES
 ========
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index 43dba0717953..6a9c52ef84a9 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -67,8 +67,9 @@ OPTIONS
 		  (such as tracefs or BPF virtual file system) when necessary.
 
 	-d, --debug
-		  Print all logs available from libbpf, including debug-level
-		  information.
+		  Print all logs available, even debug-level information. This
+		  includes logs from libbpf as well as from the verifier, when
+		  attempting to load programs.
 
 SEE ALSO
 ========
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index d74293938a05..4879f6395c7e 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -26,6 +26,7 @@ bool pretty_output;
 bool json_output;
 bool show_pinned;
 bool block_mount;
+bool verifier_logs;
 int bpf_flags;
 struct pinned_obj_table prog_table;
 struct pinned_obj_table map_table;
@@ -373,6 +374,7 @@ int main(int argc, char **argv)
 			break;
 		case 'd':
 			libbpf_set_print(print_all_levels);
+			verifier_logs = true;
 			break;
 		default:
 			p_err("unrecognized option '%s'", argv[optind - 1]);
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 3d63feb7f852..28a2a5857e14 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -91,6 +91,7 @@ extern json_writer_t *json_wtr;
 extern bool json_output;
 extern bool show_pinned;
 extern bool block_mount;
+extern bool verifier_logs;
 extern int bpf_flags;
 extern struct pinned_obj_table prog_table;
 extern struct pinned_obj_table map_table;
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 26336bad0442..1f209c80d906 100644
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
@@ -881,16 +883,16 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 
 	set_max_rlimit();
 
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
@@ -960,7 +962,12 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		goto err_close_obj;
 	}
 
-	err = bpf_object__load(obj);
+	load_attr.obj = obj;
+	if (verifier_logs)
+		/* log_level1 + log_level2 + stats, but not stable UAPI */
+		load_attr.log_level = 1 + 2 + 4;
+
+	err = bpf_object__load_xattr(&load_attr);
 	if (err) {
 		p_err("failed to load object file");
 		goto err_close_obj;
-- 
2.17.1

