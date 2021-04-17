Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782C3362D4F
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbhDQDeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbhDQDdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:33:52 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA33C061344;
        Fri, 16 Apr 2021 20:32:47 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n10so3815453plc.0;
        Fri, 16 Apr 2021 20:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=adCT5jnN63wmrGNcLAyATWWHqGSfFZVMxjKZ1XM6+vA=;
        b=MNG+p6wpV4X2i45Jmv+rGZ6uPazAPLNuXU/iglzlM1VaxEfdEYRVqfkoz87ajqgKEL
         D6v6PjO4p7Wk8I5C7VnNTDGvxE/wQK4wTymbnsd7DgROpAkcY3uh3RvIegu+nusE68hx
         D/fYWK/EbGhRdIvOz3TOLlkL5AAA1W4ZrdFSHn8jlCsFNLTsVi62CbNhh+00K1Woe8V4
         G+2DSE7lG7tkFnGEl84sRl6M1rmzHviHabj9rXius12pNTUlVDKVaqzgfzAfP2fqFZKd
         0HbgLjdJnDrDyztZuD+6CYqEO4PA62vmHwIiK8GUw9iqE//1H/o0Oi/fcNx2HOhuGmyj
         UQ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=adCT5jnN63wmrGNcLAyATWWHqGSfFZVMxjKZ1XM6+vA=;
        b=M580rL9FU7UEa5UQZ0flHeGpK5bogCSz83MM6JPNc/HI+p3Jy0iU8qXRdstQoXmkf5
         FZAeDSPQhmHmRp6Sca0jBWbErGDAdsDiYFkPIC7YZUSJIYT97szwW3aGviiohLP5ImWa
         gztAnVbk1SN03SeIqMhyAswglN8MCp7zHUg+w2euqxbrWmqM6zXpMYtVSbujnv90EOOj
         CZ/pUx0a301FezhuEzSTK31RDaTL5M1EgQaDUQT1Yi4o/z8yOIHyMIMmfRqCGwflz0l2
         GoKYqb3rB+dqq/NwuGUfoWpcaYn5hlhgM31bCCyZKjM+CXzblXebWOKuIXtwZJ7QGrM1
         pHIA==
X-Gm-Message-State: AOAM530L65omZoTdLFxtX5hmrJurSDNPNCQOr0djx1ldsfZiCELvRMJG
        rxCqhMpMEC73PrCvWWJsppMU6RLUEmw=
X-Google-Smtp-Source: ABdhPJzQuSkrf971CdEjHHp4h4jUSf32yuBbE6kqmMtYJU0B/cpOvFoARY/oukrj+h5EwDOZijiA0w==
X-Received: by 2002:a17:902:e886:b029:e7:386b:1b30 with SMTP id w6-20020a170902e886b02900e7386b1b30mr12562905plg.42.1618630366968;
        Fri, 16 Apr 2021 20:32:46 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id h1sm6069870pgv.88.2021.04.16.20.32.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Apr 2021 20:32:46 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 14/15] bpftool: Use syscall/loader program in "prog load" and "gen skeleton" command.
Date:   Fri, 16 Apr 2021 20:32:23 -0700
Message-Id: <20210417033224.8063-15-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add -L flag to bpftool to use libbpf gen_trace facility and syscall/loader program
for skeleton generation and program loading.

"bpftool gen skeleton -L" command will generate a "light skeleton" or "loader skeleton"
that is similar to existing skeleton, but has one major difference:
$ bpftool gen skeleton lsm.o > lsm.skel.h
$ bpftool gen skeleton -L lsm.o > lsm.lskel.h
$ diff lsm.skel.h lsm.lskel.h
@@ -5,34 +4,34 @@
 #define __LSM_SKEL_H__

 #include <stdlib.h>
-#include <bpf/libbpf.h>
+#include <bpf/bpf.h>

The light skeleton does not use majority of libbpf infrastructure.
It doesn't need libelf. It doesn't parse .o file.
It only needs few sys_bpf wrappers. All of them are in bpf/bpf.h file.
In future libbpf/bpf.c can be inlined into bpf.h, so not even libbpf.a would be
needed to work with light skeleton.

"bpftool prog load -L file.o" command is introduced for debugging of syscall/loader
program generation. Just like the same command without -L it will try to load
the programs from file.o into the kernel. It won't even try to pin them.

"bpftool prog load -L -d file.o" command will provide additional debug messages
on how syscall/loader program was generated.
Also the execution of syscall/loader program will use bpf_trace_printk() for
each step of loading BTF, creating maps, and loading programs.
The user can do "cat /.../trace_pipe" for further debug.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/bpf/bpftool/Makefile        |   2 +-
 tools/bpf/bpftool/gen.c           | 263 +++++++++++++++++++++++++++---
 tools/bpf/bpftool/main.c          |   7 +-
 tools/bpf/bpftool/main.h          |   1 +
 tools/bpf/bpftool/prog.c          |  78 +++++++++
 tools/bpf/bpftool/xlated_dumper.c |   3 +
 6 files changed, 330 insertions(+), 24 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index b3073ae84018..d16d289ade7a 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -136,7 +136,7 @@ endif
 
 BPFTOOL_BOOTSTRAP := $(BOOTSTRAP_OUTPUT)bpftool
 
-BOOTSTRAP_OBJS = $(addprefix $(BOOTSTRAP_OUTPUT),main.o common.o json_writer.o gen.o btf.o)
+BOOTSTRAP_OBJS = $(addprefix $(BOOTSTRAP_OUTPUT),main.o common.o json_writer.o gen.o btf.o xlated_dumper.o btf_dumper.o) $(OUTPUT)disasm.o
 OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
 
 VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 31ade77f5ef8..470110c1e95f 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -18,6 +18,7 @@
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <bpf/btf.h>
+#include <bpf/bpf_gen_internal.h>
 
 #include "json_writer.h"
 #include "main.h"
@@ -268,6 +269,204 @@ static void codegen(const char *template, ...)
 	free(s);
 }
 
+static void print_hex(const char *obj_data, int file_sz)
+{
+	int i, len;
+
+	/* embed contents of BPF object file */
+	for (i = 0, len = 0; i < file_sz; i++) {
+		int w = obj_data[i] ? 4 : 2;
+
+		len += w;
+		if (len > 78) {
+			printf("\\\n");
+			len = w;
+		}
+		if (!obj_data[i])
+			printf("\\0");
+		else
+			printf("\\x%02x", (unsigned char)obj_data[i]);
+	}
+}
+
+static size_t bpf_map_mmap_sz(const struct bpf_map *map)
+{
+	long page_sz = sysconf(_SC_PAGE_SIZE);
+	size_t map_sz;
+
+	map_sz = (size_t)roundup(bpf_map__value_size(map), 8) * bpf_map__max_entries(map);
+	map_sz = roundup(map_sz, page_sz);
+	return map_sz;
+}
+
+static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *header_guard)
+{
+	struct bpf_object_load_attr load_attr = {};
+	struct bpf_program *prog;
+	struct bpf_gen gen = {};
+	int data_sz, insns_sz;
+	struct bpf_map *map;
+	char *data, *insns;
+	int err = 0;
+
+	bpf_object__set_gen_trace(obj, &gen);
+
+	load_attr.obj = obj;
+	if (verifier_logs)
+		/* log_level1 + log_level2 + stats, but not stable UAPI */
+		load_attr.log_level = 1 + 2 + 4;
+
+	err = bpf_object__load_xattr(&load_attr);
+	if (err) {
+		p_err("failed to load object file");
+		goto out;
+	}
+	data = gen.data_start;
+	data_sz = gen.data_cur - gen.data_start;
+	insns = gen.insn_start;
+	insns_sz = gen.insn_cur - gen.insn_start;
+
+	/* finish 'struct skel' */
+	codegen("\
+		\n\
+		};							    \n\
+		", obj_name);
+
+	codegen("\
+		\n\
+									    \n\
+		static inline int					    \n\
+		%1$s__attach(struct %1$s *skel)				    \n\
+		{							    \n\
+		", obj_name);
+
+	bpf_object__for_each_program(prog, obj) {
+		printf("\tskel->links.%1$s_fd =\n"
+		       "\t\tbpf_raw_tracepoint_open(NULL, skel->progs.%1$s.prog_fd);\n",
+		       bpf_program__name(prog));
+	}
+
+	codegen("\
+		\n\
+			return 0;					    \n\
+		}							    \n\
+									    \n\
+		static inline void					    \n\
+		%1$s__detach(struct %1$s *skel)				    \n\
+		{							    \n\
+		", obj_name);
+	bpf_object__for_each_program(prog, obj) {
+		printf("\tclose(skel->links.%1$s_fd);\n",
+		       bpf_program__name(prog));
+	}
+	codegen("\
+		\n\
+		}							    \n\
+		");
+
+	codegen("\
+		\n\
+		static void						    \n\
+		%1$s__destroy(struct %1$s *skel)			    \n\
+		{							    \n\
+			if (!skel)					    \n\
+				return;					    \n\
+			%1$s__detach(skel);				    \n\
+			free(skel);					    \n\
+		}							    \n\
+									    \n\
+		static inline struct %1$s *				    \n\
+		%1$s__open(void)					    \n\
+		{							    \n\
+			struct %1$s *skel;				    \n\
+									    \n\
+			skel = calloc(sizeof(*skel), 1);		    \n\
+			if (!skel)					    \n\
+				return NULL;				    \n\
+			skel->ctx.sz = (void *)&skel->links - (void *)skel; \n\
+			return skel;					    \n\
+		}							    \n\
+									    \n\
+		static inline int					    \n\
+		%1$s__load(struct %1$s *skel)				    \n\
+		{							    \n\
+			struct bpf_load_opts opts = {};			    \n\
+			int err;					    \n\
+									    \n\
+			opts.sz = sizeof(opts);				    \n\
+			opts.ctx = (struct bpf_loader_ctx *)skel;	    \n\
+			opts.data_sz = %2$d;				    \n\
+			opts.data = (void *)\"\\			    \n\
+		",
+		obj_name, data_sz);
+	print_hex(data, data_sz);
+	codegen("\
+		\n\
+		\";							    \n\
+		");
+
+	codegen("\
+		\n\
+			opts.insns_sz = %d;				    \n\
+			opts.insns = (void *)\"\\			    \n\
+		",
+		insns_sz);
+	print_hex(insns, insns_sz);
+	codegen("\
+		\n\
+		\";							    \n\
+			err = bpf_load(&opts);				    \n\
+			if (err < 0)					    \n\
+				return err;				    \n\
+		", obj_name);
+	bpf_object__for_each_map(map, obj) {
+		const char * ident;
+
+		ident = get_map_ident(map);
+		if (!ident)
+			continue;
+
+		if (!bpf_map__is_internal(map) ||
+		    !(bpf_map__def(map)->map_flags & BPF_F_MMAPABLE))
+			continue;
+
+		printf("\tskel->%1$s =\n"
+		       "\t\tmmap(NULL, %2$zd, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED,\n"
+		       "\t\t\tskel->maps.%1$s.map_fd, 0);\n",
+		       ident, bpf_map_mmap_sz(map));
+	}
+	codegen("\
+		\n\
+			return 0;					    \n\
+		}							    \n\
+									    \n\
+		static inline struct %1$s *				    \n\
+		%1$s__open_and_load(void)				    \n\
+		{							    \n\
+			struct %1$s *skel;				    \n\
+									    \n\
+			skel = %1$s__open();				    \n\
+			if (!skel)					    \n\
+				return NULL;				    \n\
+			if (%1$s__load(skel)) {				    \n\
+				%1$s__destroy(skel);			    \n\
+				return NULL;				    \n\
+			}						    \n\
+			return skel;					    \n\
+		}							    \n\
+		", obj_name);
+
+	codegen("\
+		\n\
+									    \n\
+		#endif /* %s */						    \n\
+		",
+		header_guard);
+	err = 0;
+out:
+	return err;
+}
+
 static int do_skeleton(int argc, char **argv)
 {
 	char header_guard[MAX_OBJ_NAME_LEN + sizeof("__SKEL_H__")];
@@ -277,7 +476,7 @@ static int do_skeleton(int argc, char **argv)
 	struct bpf_object *obj = NULL;
 	const char *file, *ident;
 	struct bpf_program *prog;
-	int fd, len, err = -1;
+	int fd, err = -1;
 	struct bpf_map *map;
 	struct btf *btf;
 	struct stat st;
@@ -359,7 +558,25 @@ static int do_skeleton(int argc, char **argv)
 	}
 
 	get_header_guard(header_guard, obj_name);
-	codegen("\
+	if (use_loader)
+		codegen("\
+		\n\
+		/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */   \n\
+		/* THIS FILE IS AUTOGENERATED! */			    \n\
+		#ifndef %2$s						    \n\
+		#define %2$s						    \n\
+									    \n\
+		#include <stdlib.h>					    \n\
+		#include <sys/mman.h>					    \n\
+		#include <bpf/bpf.h>					    \n\
+									    \n\
+		struct %1$s {						    \n\
+			struct bpf_loader_ctx ctx;			    \n\
+		",
+		obj_name, header_guard
+		);
+	else
+		codegen("\
 		\n\
 		/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */   \n\
 									    \n\
@@ -375,7 +592,7 @@ static int do_skeleton(int argc, char **argv)
 			struct bpf_object *obj;				    \n\
 		",
 		obj_name, header_guard
-	);
+		);
 
 	if (map_cnt) {
 		printf("\tstruct {\n");
@@ -383,7 +600,10 @@ static int do_skeleton(int argc, char **argv)
 			ident = get_map_ident(map);
 			if (!ident)
 				continue;
-			printf("\t\tstruct bpf_map *%s;\n", ident);
+			if (use_loader)
+				printf("\t\tunion bpf_map_prog_desc %s;\n", ident);
+			else
+				printf("\t\tstruct bpf_map *%s;\n", ident);
 		}
 		printf("\t} maps;\n");
 	}
@@ -391,14 +611,22 @@ static int do_skeleton(int argc, char **argv)
 	if (prog_cnt) {
 		printf("\tstruct {\n");
 		bpf_object__for_each_program(prog, obj) {
-			printf("\t\tstruct bpf_program *%s;\n",
-			       bpf_program__name(prog));
+			if (use_loader)
+				printf("\t\tunion bpf_map_prog_desc %s;\n",
+				       bpf_program__name(prog));
+			else
+				printf("\t\tstruct bpf_program *%s;\n",
+				       bpf_program__name(prog));
 		}
 		printf("\t} progs;\n");
 		printf("\tstruct {\n");
 		bpf_object__for_each_program(prog, obj) {
-			printf("\t\tstruct bpf_link *%s;\n",
-			       bpf_program__name(prog));
+			if (use_loader)
+				printf("\t\tint %s_fd;\n",
+				       bpf_program__name(prog));
+			else
+				printf("\t\tstruct bpf_link *%s;\n",
+				       bpf_program__name(prog));
 		}
 		printf("\t} links;\n");
 	}
@@ -409,6 +637,10 @@ static int do_skeleton(int argc, char **argv)
 		if (err)
 			goto out;
 	}
+	if (use_loader) {
+		err = gen_trace(obj, obj_name, header_guard);
+		goto out;
+	}
 
 	codegen("\
 		\n\
@@ -577,20 +809,7 @@ static int do_skeleton(int argc, char **argv)
 		",
 		file_sz);
 
-	/* embed contents of BPF object file */
-	for (i = 0, len = 0; i < file_sz; i++) {
-		int w = obj_data[i] ? 4 : 2;
-
-		len += w;
-		if (len > 78) {
-			printf("\\\n");
-			len = w;
-		}
-		if (!obj_data[i])
-			printf("\\0");
-		else
-			printf("\\x%02x", (unsigned char)obj_data[i]);
-	}
+	print_hex(obj_data, file_sz);
 
 	codegen("\
 		\n\
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index d9afb730136a..7f2817d97079 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -29,6 +29,7 @@ bool show_pinned;
 bool block_mount;
 bool verifier_logs;
 bool relaxed_maps;
+bool use_loader;
 struct btf *base_btf;
 struct pinned_obj_table prog_table;
 struct pinned_obj_table map_table;
@@ -392,6 +393,7 @@ int main(int argc, char **argv)
 		{ "mapcompat",	no_argument,	NULL,	'm' },
 		{ "nomount",	no_argument,	NULL,	'n' },
 		{ "debug",	no_argument,	NULL,	'd' },
+		{ "use-loader",	no_argument,	NULL,	'L' },
 		{ "base-btf",	required_argument, NULL, 'B' },
 		{ 0 }
 	};
@@ -409,7 +411,7 @@ int main(int argc, char **argv)
 	hash_init(link_table.table);
 
 	opterr = 0;
-	while ((opt = getopt_long(argc, argv, "VhpjfmndB:",
+	while ((opt = getopt_long(argc, argv, "VhpjfLmndB:",
 				  options, NULL)) >= 0) {
 		switch (opt) {
 		case 'V':
@@ -452,6 +454,9 @@ int main(int argc, char **argv)
 				return -1;
 			}
 			break;
+		case 'L':
+			use_loader = true;
+			break;
 		default:
 			p_err("unrecognized option '%s'", argv[optind - 1]);
 			if (json_output)
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 76e91641262b..c1cf29798b99 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -90,6 +90,7 @@ extern bool show_pids;
 extern bool block_mount;
 extern bool verifier_logs;
 extern bool relaxed_maps;
+extern bool use_loader;
 extern struct btf *base_btf;
 extern struct pinned_obj_table prog_table;
 extern struct pinned_obj_table map_table;
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 3f067d2d7584..44d602ca1634 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -24,6 +24,7 @@
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
 #include <bpf/libbpf.h>
+#include <bpf/bpf_gen_internal.h>
 
 #include "cfg.h"
 #include "main.h"
@@ -1645,8 +1646,85 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 	return -1;
 }
 
+static int try_loader(struct bpf_gen *gen)
+{
+	DECLARE_LIBBPF_OPTS(bpf_load_opts, opts);
+	struct bpf_loader_ctx *ctx;
+	int ctx_sz = sizeof(*ctx) + 64 * sizeof(union bpf_map_prog_desc);
+	int log_buf_sz = (1u << 24) - 1;
+	char *log_buf;
+	int err;
+
+	ctx = alloca(sizeof(*ctx) + 64 * sizeof(union bpf_map_prog_desc));
+	ctx->sz = ctx_sz;
+	ctx->log_level = 4;
+	ctx->log_size = log_buf_sz;
+	log_buf = malloc(log_buf_sz);
+	if (!log_buf)
+		return ENOMEM;
+	ctx->log_buf = (long)log_buf;
+	opts.ctx = ctx;
+	opts.data = gen->data_start;
+	opts.data_sz = gen->data_cur - gen->data_start;
+	opts.insns = gen->insn_start;
+	opts.insns_sz = gen->insn_cur - gen->insn_start;
+	err = bpf_load(&opts);
+	if (err < 0)
+		fprintf(stderr, "%s", log_buf);
+	free(log_buf);
+	return err;
+}
+
+static int do_loader(int argc, char **argv)
+{
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, open_opts);
+	struct bpf_object_load_attr load_attr = {};
+	struct bpf_object *obj;
+	const char *file;
+	struct bpf_gen gen = {};
+	int err = 0;
+
+	if (!REQ_ARGS(1))
+		return -1;
+	file = GET_ARG();
+
+	obj = bpf_object__open_file(file, &open_opts);
+	if (IS_ERR_OR_NULL(obj)) {
+		p_err("failed to open object file");
+		goto err_close_obj;
+	}
+
+	bpf_object__set_gen_trace(obj, &gen);
+
+	load_attr.obj = obj;
+	if (verifier_logs)
+		/* log_level1 + log_level2 + stats, but not stable UAPI */
+		load_attr.log_level = 1 + 2 + 4;
+
+	err = bpf_object__load_xattr(&load_attr);
+	if (err) {
+		p_err("failed to load object file");
+		goto err_close_obj;
+	}
+
+	if (verifier_logs) {
+		struct dump_data dd = {};
+
+		kernel_syms_load(&dd);
+		dump_xlated_plain(&dd, gen.insn_start,
+				  gen.insn_cur - gen.insn_start, false, false);
+		kernel_syms_destroy(&dd);
+	}
+	err = try_loader(&gen);
+err_close_obj:
+	bpf_object__close(obj);
+	return err;
+}
+
 static int do_load(int argc, char **argv)
 {
+	if (use_loader)
+		return do_loader(argc, argv);
 	return load_with_options(argc, argv, true);
 }
 
diff --git a/tools/bpf/bpftool/xlated_dumper.c b/tools/bpf/bpftool/xlated_dumper.c
index 6fc3e6f7f40c..f1f32e21d5cd 100644
--- a/tools/bpf/bpftool/xlated_dumper.c
+++ b/tools/bpf/bpftool/xlated_dumper.c
@@ -196,6 +196,9 @@ static const char *print_imm(void *private_data,
 	else if (insn->src_reg == BPF_PSEUDO_MAP_VALUE)
 		snprintf(dd->scratch_buff, sizeof(dd->scratch_buff),
 			 "map[id:%u][0]+%u", insn->imm, (insn + 1)->imm);
+	else if (insn->src_reg == BPF_PSEUDO_MAP_IDX_VALUE)
+		snprintf(dd->scratch_buff, sizeof(dd->scratch_buff),
+			 "map[idx:%u]+%u", insn->imm, (insn + 1)->imm);
 	else if (insn->src_reg == BPF_PSEUDO_FUNC)
 		snprintf(dd->scratch_buff, sizeof(dd->scratch_buff),
 			 "subprog[%+d]", insn->imm);
-- 
2.30.2

