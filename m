Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA2E340E82
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhCRTlZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Mar 2021 15:41:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60662 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232938AbhCRTlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:41:06 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IJXWfk024033
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:41:06 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37c697tt7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:41:05 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 12:41:04 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A3A382ED2588; Thu, 18 Mar 2021 12:41:01 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH v4 bpf-next 09/12] bpftool: add `gen object` command to perform BPF static linking
Date:   Thu, 18 Mar 2021 12:40:33 -0700
Message-ID: <20210318194036.3521577-10-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318194036.3521577-1-andrii@kernel.org>
References: <20210318194036.3521577-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_12:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add `bpftool gen object <output-file> <input_file>...` command to statically
link multiple BPF ELF object files into a single output BPF ELF object file.

This patch also updates bash completions and man page. Man page gets a short
section on `gen object` command, but also updates the skeleton example to show
off workflow for BPF application with two .bpf.c files, compiled individually
with Clang, then resulting object files are linked together with `gen object`,
and then final object file is used to generate usable BPF skeleton. This
should help new users understand realistic workflow w.r.t. compiling
mutli-file BPF application.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../bpf/bpftool/Documentation/bpftool-gen.rst | 65 +++++++++++++++----
 tools/bpf/bpftool/bash-completion/bpftool     |  6 +-
 tools/bpf/bpftool/gen.c                       | 45 ++++++++++++-
 3 files changed, 100 insertions(+), 16 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index d4e7338e22e7..7cd6681137f3 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -14,16 +14,37 @@ SYNOPSIS
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] }
 
-	*COMMAND* := { **skeleton** | **help** }
+	*COMMAND* := { **object** | **skeleton** | **help** }
 
 GEN COMMANDS
 =============
 
+|	**bpftool** **gen object** *OUTPUT_FILE* *INPUT_FILE* [*INPUT_FILE*...]
 |	**bpftool** **gen skeleton** *FILE* [**name** *OBJECT_NAME*]
 |	**bpftool** **gen help**
 
 DESCRIPTION
 ===========
+	**bpftool gen object** *OUTPUT_FILE* *INPUT_FILE* [*INPUT_FILE*...]
+		  Statically link (combine) together one or more *INPUT_FILE*'s
+		  into a single resulting *OUTPUT_FILE*. All the files involved
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
 
@@ -133,26 +154,19 @@ OPTIONS
 
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
@@ -164,6 +178,21 @@ EXAMPLES
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
@@ -173,9 +202,17 @@ EXAMPLES
   }
 
 This is example BPF application with two BPF programs and a mix of BPF maps
-and global variables.
+and global variables. Source code is split across two source code files.
 
-**$ bpftool gen skeleton example.o**
+**$ clang -target bpf -g example1.bpf.c -o example1.bpf.o**
+**$ clang -target bpf -g example2.bpf.c -o example2.bpf.o**
+**$ bpftool gen object example.bpf.o example1.bpf.o example2.bpf.o**
+
+This set of commands compiles *example1.bpf.c* and *example2.bpf.c*
+individually and then statically links respective object files into the final
+BPF ELF object file *example.bpf.o*.
+
+**$ bpftool gen skeleton example.bpf.o name example | tee example.skel.h**
 
 ::
 
@@ -230,7 +267,7 @@ and global variables.
 
   #endif /* __EXAMPLE_SKEL_H__ */
 
-**$ cat example_user.c**
+**$ cat example.c**
 
 ::
 
@@ -273,7 +310,7 @@ and global variables.
   	return err;
   }
 
-**# ./example_user**
+**# ./example**
 
 ::
 
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index bf7b4bdbb23a..d67518bcbd44 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -981,6 +981,10 @@ _bpftool()
             ;;
         gen)
             case $command in
+                object)
+                    _filedir
+                    return 0
+                    ;;
                 skeleton)
                     case $prev in
                         $command)
@@ -995,7 +999,7 @@ _bpftool()
                     ;;
                 *)
                     [[ $prev == $object ]] && \
-                        COMPREPLY=( $( compgen -W 'skeleton help' -- "$cur" ) )
+                        COMPREPLY=( $( compgen -W 'object skeleton help' -- "$cur" ) )
                     ;;
             esac
             ;;
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 9bff89a66835..31ade77f5ef8 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -614,6 +614,47 @@ static int do_skeleton(int argc, char **argv)
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
@@ -622,7 +663,8 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %1$s %2$s skeleton FILE [name OBJECT_NAME]\n"
+		"Usage: %1$s %2$s object OUTPUT_FILE INPUT_FILE [INPUT_FILE...]\n"
+		"       %1$s %2$s skeleton FILE [name OBJECT_NAME]\n"
 		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_OPTIONS "\n"
@@ -633,6 +675,7 @@ static int do_help(int argc, char **argv)
 }
 
 static const struct cmd cmds[] = {
+	{ "object",	do_object },
 	{ "skeleton",	do_skeleton },
 	{ "help",	do_help },
 	{ 0 }
-- 
2.30.2

