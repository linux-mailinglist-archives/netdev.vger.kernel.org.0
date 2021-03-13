Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D4533A08F
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 20:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbhCMTgS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 13 Mar 2021 14:36:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18002 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234493AbhCMTgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 14:36:06 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12DJW0En003278
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 11:36:05 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 378skh9t1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 11:36:05 -0800
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 13 Mar 2021 11:36:05 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0E0FC2ED20BF; Sat, 13 Mar 2021 11:35:57 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 08/11] bpftool: add `gen object` command to perform BPF static linking
Date:   Sat, 13 Mar 2021 11:35:34 -0800
Message-ID: <20210313193537.1548766-9-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210313193537.1548766-1-andrii@kernel.org>
References: <20210313193537.1548766-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-13_07:2021-03-12,2021-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=999 adultscore=0 clxscore=1034 bulkscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103130151
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add `bpftool gen object <output-file> <input_file>...` command to statically
link multiple BPF ELF object files into a single output BPF ELF object file.

Similarly to existing '*.o' convention, bpftool is establishing a '*.bpfo'
convention for statically-linked BPF object files. Both .o and .bpfo suffixes
will be stripped out during BPF skeleton generation to infer BPF object name.

This patch also updates bash completions and man page. Man page gets a short
section on `gen object` command, but also updates the skeleton example to show
off workflow for BPF application with two .bpf.c files, compiled individually
with Clang, then resulting object files are linked together with `gen object`,
and then final object file is used to generate usable BPF skeleton. This
should help new users understand realistic workflow w.r.t. compiling
mutli-file BPF application.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../bpf/bpftool/Documentation/bpftool-gen.rst | 65 +++++++++++++++----
 tools/bpf/bpftool/bash-completion/bpftool     |  2 +-
 tools/bpf/bpftool/gen.c                       | 49 +++++++++++++-
 3 files changed, 99 insertions(+), 17 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index 84cf0639696f..4cdce187c393 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -14,16 +14,37 @@ SYNOPSIS
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] }
 
-	*COMMAND* := { **skeleton** | **help** }
+	*COMMAND* := { **object** | **skeleton** | **help** }
 
 GEN COMMANDS
 =============
 
+|	**bpftool** **gen object** *OUTPUT_FILE* *INPUT_FILE* [*INPUT_FILE*...]
 |	**bpftool** **gen skeleton** *FILE*
 |	**bpftool** **gen help**
 
 DESCRIPTION
 ===========
+	**bpftool gen object** *OUTPUT_FILE* *INPUT_FILE* [*INPUT_FILE*...]
+		  Statically link (combine) together one or more *INPUT_FILE*'s
+		  into a single resulting *OUTPUT_FILE*. All the files involed
+		  are BPF ELF object files.
+
+		  The rules of BPF static linking are mostly the same as for
+		  user-space object files, but in addition to combining data
+		  and instruction sections, .BTF and .BTF.ext (if present in
+		  any of the input files) data are combined together. .BTF
+		  data is deduplicated, so all the common types across
+		  *INPUT_FILE*'s will only be represented once in the resulting
+		  BTF information.
+
+		  BPF static linking allows to partition BPF source code into
+		  individually compiled files that are then linked into
+		  a single resulting BPF object file, which can be used to
+		  generated BPF skeleton (with **gen skeleton** command) or
+		  passed directly into **libbpf** (using **bpf_object__open()**
+		  family of APIs).
+
 	**bpftool gen skeleton** *FILE*
 		  Generate BPF skeleton C header file for a given *FILE*.
 
@@ -130,26 +151,19 @@ OPTIONS
 
 EXAMPLES
 ========
-**$ cat example.c**
+**$ cat example1.bpf.c**
 
 ::
 
   #include <stdbool.h>
   #include <linux/ptrace.h>
   #include <linux/bpf.h>
-  #include "bpf_helpers.h"
+  #include <bpf/bpf_helpers.h>
 
   const volatile int param1 = 42;
   bool global_flag = true;
   struct { int x; } data = {};
 
-  struct {
-  	__uint(type, BPF_MAP_TYPE_HASH);
-  	__uint(max_entries, 128);
-  	__type(key, int);
-  	__type(value, long);
-  } my_map SEC(".maps");
-
   SEC("raw_tp/sys_enter")
   int handle_sys_enter(struct pt_regs *ctx)
   {
@@ -161,6 +175,21 @@ EXAMPLES
   	return 0;
   }
 
+**$ cat example2.bpf.c**
+
+::
+
+  #include <linux/ptrace.h>
+  #include <linux/bpf.h>
+  #include <bpf/bpf_helpers.h>
+
+  struct {
+  	__uint(type, BPF_MAP_TYPE_HASH);
+  	__uint(max_entries, 128);
+  	__type(key, int);
+  	__type(value, long);
+  } my_map SEC(".maps");
+
   SEC("raw_tp/sys_exit")
   int handle_sys_exit(struct pt_regs *ctx)
   {
@@ -170,9 +199,17 @@ EXAMPLES
   }
 
 This is example BPF application with two BPF programs and a mix of BPF maps
-and global variables.
+and global variables. Source code is split across two source code files.
 
-**$ bpftool gen skeleton example.o**
+**$ clang -target bpf -g example1.bpf.c -o example1.bpf.o**
+**$ clang -target bpf -g example2.bpf.c -o example2.bpf.o**
+**$ bpftool gen object example.bpfo example1.bpf.o example2.bpf.o**
+
+This set of commands compiles *example1.bpf.c* and *example2.bpf.c*
+individually and then statically links respective object files into the final
+BPF ELF object file *example.bpfo*.
+
+**$ bpftool gen skeleton example.bpfo**
 
 ::
 
@@ -227,7 +264,7 @@ and global variables.
 
   #endif /* __EXAMPLE_SKEL_H__ */
 
-**$ cat example_user.c**
+**$ cat example.c**
 
 ::
 
@@ -270,7 +307,7 @@ and global variables.
   	return err;
   }
 
-**# ./example_user**
+**# ./example**
 
 ::
 
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index fdffbc64c65c..7ca23c58f2c0 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -981,7 +981,7 @@ _bpftool()
             ;;
         gen)
             case $command in
-                skeleton)
+                object|skeleton)
                     _filedir
                     ;;
                 *)
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 4033c46d83e7..123cca7b400b 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -54,7 +54,9 @@ static void get_obj_name(char *name, const char *file)
 	strncpy(name, basename(file), MAX_OBJ_NAME_LEN - 1);
 	name[MAX_OBJ_NAME_LEN - 1] = '\0';
 	if (str_has_suffix(name, ".o"))
-		name[strlen(name) - 2] = '\0';
+		name[strlen(name) - sizeof(".o") + 1] = '\0';
+	else if (str_has_suffix(name, ".bpfo"))
+		name[strlen(name) - sizeof(".bpfo") + 1] = '\0';
 	sanitize_identifier(name);
 }
 
@@ -591,6 +593,47 @@ static int do_skeleton(int argc, char **argv)
 	return err;
 }
 
+static int do_object(int argc, char **argv)
+{
+	struct bpf_linker *linker;
+	const char *output_file, *file;
+	int err = 0;
+
+	if (!REQ_ARGS(2)) {
+		usage();
+		return -1;
+	}
+
+	output_file = GET_ARG();
+
+	linker = bpf_linker__new(output_file, NULL);
+	if (!linker) {
+		p_err("failed to create BPF linker instance");
+		return -1;
+	}
+
+	while (argc) {
+		file = GET_ARG();
+
+		err = bpf_linker__add_file(linker, file);
+		if (err) {
+			p_err("failed to link '%s': %s (%d)", file, strerror(err), err);
+			goto out;
+		}
+	}
+
+	err = bpf_linker__finalize(linker);
+	if (err) {
+		p_err("failed to finalize ELF file: %s (%d)", strerror(err), err);
+		goto out;
+	}
+
+	err = 0;
+out:
+	bpf_linker__free(linker);
+	return err;
+}
+
 static int do_help(int argc, char **argv)
 {
 	if (json_output) {
@@ -599,7 +642,8 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %1$s %2$s skeleton FILE\n"
+		"Usage: %1$s %2$s object OUTPUT_FILE INPUT_FILE [INPUT_FILE...]\n"
+		"       %1$s %2$s skeleton FILE\n"
 		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_OPTIONS "\n"
@@ -610,6 +654,7 @@ static int do_help(int argc, char **argv)
 }
 
 static const struct cmd cmds[] = {
+	{ "object",	do_object },
 	{ "skeleton",	do_skeleton },
 	{ "help",	do_help },
 	{ 0 }
-- 
2.24.1

