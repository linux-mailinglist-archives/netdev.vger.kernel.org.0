Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485BE3689DD
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240310AbhDWA2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240226AbhDWA1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:46 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C30CC061342;
        Thu, 22 Apr 2021 17:27:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gq23-20020a17090b1057b0290151869af68bso256653pjb.4;
        Thu, 22 Apr 2021 17:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VejV6uVNVoCTwdzjfq+lV/4+D2gYs/uJUofmrZExUjY=;
        b=iw1W0EcEwFR5PoYYD6lYpb/N/EE4ko8T7RCoypmooNzJ65FhSFVOjYzBlHrJctCbY2
         tXYqc8arnJJP6c7GGcOwNHB3fIvqtde8nlhpiHO6sclSetHTuEE1f2N0PL4Mx47yxjWP
         nR14d1YSZLxtQGgu2Oi+lMvdKkHQrCTIPittbftMNfUXbNVmAXyQnOb02dnbBZ3c8CUT
         HnMatp8QTTmnSWsIq4x1Dp+tiUC+fgUFVIvOKdZD4g8TP7WNa3j9H8Sb4pNXb+d3+yE1
         PNE0mcEvGXVzmsJFve4aPexC0LEoNUnwM7hVkahwT9q9PJjGYTT5pI1/HoylC1HQcZ/x
         84kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VejV6uVNVoCTwdzjfq+lV/4+D2gYs/uJUofmrZExUjY=;
        b=VYUUvJIi+748ULUIQHcPA49P5MuKIqZj40lompMpnpZj4lU5s6czZ88guADPzCKh2o
         cg+D0375iBFq3E3nWgsTvTJ61fwLtSsCM8CZDHm+YIoCCHo73Uq+L5f3L2OF9qOie9oq
         aIHZAjWNDVf7JQwaIYl1UvEzVxKxnc5kd9S++chgF8jcfshsu2pG/B/iwGPjlvhnDnJ6
         1TlHv1Zac6ABmDGMJYShrUcw0L46IVymrGfpH5aD0FnhbX+nAs/znZSauBmiNU6/FsPk
         O+GlsIRVL6j6qu8XrRbS+hzPJFrSUL5cbx1pp/wpM5VG4dP9LuiG/gAbF1zMvtoDUKa4
         QWZQ==
X-Gm-Message-State: AOAM530diKu4aemIgCkfReK40grifF2iBFXRawqsJrCZbgYQoVgWs62C
        hpI+DxZfVv5r7laq8ewquoE=
X-Google-Smtp-Source: ABdhPJykvsK9/y1uJ8Aju4Fxpcx0Cr/mDtLQMvMLxecmW8ExlQNkGEQ3swMVitMMsot/1Ip3Mmq9Lg==
X-Received: by 2002:a17:902:525:b029:e8:e347:b07f with SMTP id 34-20020a1709020525b02900e8e347b07fmr1445373plf.34.1619137629601;
        Thu, 22 Apr 2021 17:27:09 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.27.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:27:08 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 15/16] bpftool: Use syscall/loader program in "prog load" and "gen skeleton" command.
Date:   Thu, 22 Apr 2021 17:26:45 -0700
Message-Id: <20210423002646.35043-16-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
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

An example of fexit_sleep.lskel.h generated from progs/fexit_sleep.c:
struct fexit_sleep {
	struct bpf_loader_ctx ctx;
	struct {
		struct bpf_map_desc bss;
	} maps;
	struct {
		struct bpf_prog_desc nanosleep_fentry;
		struct bpf_prog_desc nanosleep_fexit;
	} progs;
	struct {
		int nanosleep_fentry_fd;
		int nanosleep_fexit_fd;
	} links;
	struct fexit_sleep__bss {
		int pid;
		int fentry_cnt;
		int fexit_cnt;
	} *bss;
};

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/bpf/bpftool/Makefile        |   2 +-
 tools/bpf/bpftool/gen.c           | 313 +++++++++++++++++++++++++++---
 tools/bpf/bpftool/main.c          |   7 +-
 tools/bpf/bpftool/main.h          |   1 +
 tools/bpf/bpftool/prog.c          |  80 ++++++++
 tools/bpf/bpftool/xlated_dumper.c |   3 +
 6 files changed, 382 insertions(+), 24 deletions(-)

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
index 31ade77f5ef8..0e56b8f3e337 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -18,6 +18,7 @@
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <bpf/btf.h>
+#include <bpf/bpf_gen_internal.h>
 
 #include "json_writer.h"
 #include "main.h"
@@ -268,6 +269,254 @@ static void codegen(const char *template, ...)
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
+static void codegen_attach_detach(struct bpf_object *obj, const char *obj_name)
+{
+	struct bpf_program *prog;
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
+		       "\t\tbpf_raw_tracepoint_open(",
+		       bpf_program__name(prog));
+
+		switch (bpf_program__get_type(prog)) {
+		case BPF_PROG_TYPE_RAW_TRACEPOINT:
+			putchar('"');
+			fputs(strchr(bpf_program__section_name(prog), '/') + 1, stdout);
+			putchar('"');
+			break;
+		default:
+			fputs("NULL", stdout);
+			break;
+		}
+		printf(", skel->progs.%1$s.prog_fd);\n",
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
+}
+
+static void codegen_destroy(struct bpf_object *obj, const char *obj_name)
+{
+	struct bpf_program *prog;
+	struct bpf_map *map;
+
+	codegen("\
+		\n\
+		static void						    \n\
+		%1$s__destroy(struct %1$s *skel)			    \n\
+		{							    \n\
+			if (!skel)					    \n\
+				return;					    \n\
+			%1$s__detach(skel);				    \n\
+		",
+		obj_name);
+	bpf_object__for_each_program(prog, obj) {
+		printf("\tclose(skel->progs.%1$s.prog_fd);\n",
+		       bpf_program__name(prog));
+	}
+	bpf_object__for_each_map(map, obj) {
+		const char * ident;
+
+		ident = get_map_ident(map);
+		if (!ident)
+			continue;
+		if (bpf_map__is_internal(map) &&
+		    (bpf_map__def(map)->map_flags & BPF_F_MMAPABLE))
+			printf("\tmunmap(skel->%1$s, %2$zd);\n",
+			       ident, bpf_map_mmap_sz(map));
+		printf("\tclose(skel->maps.%1$s.map_fd);\n", ident);
+	}
+	codegen("\
+		\n\
+			free(skel);					    \n\
+		}							    \n\
+		",
+		obj_name);
+}
+
+static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *header_guard)
+{
+	struct bpf_object_load_attr load_attr = {};
+	DECLARE_LIBBPF_OPTS(gen_loader_opts, opts);
+	struct bpf_map *map;
+	int err = 0;
+
+	err = bpf_object__gen_loader(obj, &opts);
+	if (err)
+		return err;
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
+	/* If there was no error during load then gen_loader_opts
+	 * are populated with the loader program.
+	 */
+
+	/* finish generating 'struct skel' */
+	codegen("\
+		\n\
+		};							    \n\
+		", obj_name);
+
+
+	codegen_attach_detach(obj, obj_name);
+
+	codegen_destroy(obj, obj_name);
+
+	codegen("\
+		\n\
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
+			struct bpf_load_and_run_opts opts = {};		    \n\
+			int err;					    \n\
+									    \n\
+			opts.ctx = (struct bpf_loader_ctx *)skel;	    \n\
+			opts.data_sz = %2$d;				    \n\
+			opts.data = (void *)\"\\			    \n\
+		",
+		obj_name, opts.data_sz);
+	print_hex(opts.data, opts.data_sz);
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
+		opts.insns_sz);
+	print_hex(opts.insns, opts.insns_sz);
+	codegen("\
+		\n\
+		\";							    \n\
+			err = bpf_load_and_run(&opts);			    \n\
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
@@ -277,7 +526,7 @@ static int do_skeleton(int argc, char **argv)
 	struct bpf_object *obj = NULL;
 	const char *file, *ident;
 	struct bpf_program *prog;
-	int fd, len, err = -1;
+	int fd, err = -1;
 	struct bpf_map *map;
 	struct btf *btf;
 	struct stat st;
@@ -359,7 +608,25 @@ static int do_skeleton(int argc, char **argv)
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
+		#include <bpf/bpf.h>					    \n\
+		#include <bpf/skel_internal.h>				    \n\
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
@@ -375,7 +642,7 @@ static int do_skeleton(int argc, char **argv)
 			struct bpf_object *obj;				    \n\
 		",
 		obj_name, header_guard
-	);
+		);
 
 	if (map_cnt) {
 		printf("\tstruct {\n");
@@ -383,7 +650,10 @@ static int do_skeleton(int argc, char **argv)
 			ident = get_map_ident(map);
 			if (!ident)
 				continue;
-			printf("\t\tstruct bpf_map *%s;\n", ident);
+			if (use_loader)
+				printf("\t\tstruct bpf_map_desc %s;\n", ident);
+			else
+				printf("\t\tstruct bpf_map *%s;\n", ident);
 		}
 		printf("\t} maps;\n");
 	}
@@ -391,14 +661,22 @@ static int do_skeleton(int argc, char **argv)
 	if (prog_cnt) {
 		printf("\tstruct {\n");
 		bpf_object__for_each_program(prog, obj) {
-			printf("\t\tstruct bpf_program *%s;\n",
-			       bpf_program__name(prog));
+			if (use_loader)
+				printf("\t\tstruct bpf_prog_desc %s;\n",
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
@@ -409,6 +687,10 @@ static int do_skeleton(int argc, char **argv)
 		if (err)
 			goto out;
 	}
+	if (use_loader) {
+		err = gen_trace(obj, obj_name, header_guard);
+		goto out;
+	}
 
 	codegen("\
 		\n\
@@ -577,20 +859,7 @@ static int do_skeleton(int argc, char **argv)
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
index 3f067d2d7584..052b16101ab7 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -24,6 +24,8 @@
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
 #include <bpf/libbpf.h>
+#include <bpf/bpf_gen_internal.h>
+#include <bpf/skel_internal.h>
 
 #include "cfg.h"
 #include "main.h"
@@ -1645,8 +1647,86 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 	return -1;
 }
 
+static int try_loader(struct gen_loader_opts *gen)
+{
+	struct bpf_load_and_run_opts opts = {};
+	struct bpf_loader_ctx *ctx;
+	int ctx_sz = sizeof(*ctx) + 64 * max(sizeof(struct bpf_map_desc), sizeof(struct bpf_prog_desc));
+	int log_buf_sz = (1u << 24) - 1;
+	char *log_buf;
+	int err;
+
+	ctx = alloca(ctx_sz);
+	ctx->sz = ctx_sz;
+	ctx->log_level = 1;
+	ctx->log_size = log_buf_sz;
+	log_buf = malloc(log_buf_sz);
+	if (!log_buf)
+		return -ENOMEM;
+	ctx->log_buf = (long) log_buf;
+	opts.ctx = ctx;
+	opts.data = gen->data;
+	opts.data_sz = gen->data_sz;
+	opts.insns = gen->insns;
+	opts.insns_sz = gen->insns_sz;
+	err = bpf_load_and_run(&opts);
+	if (err < 0)
+		fprintf(stderr, "err %d\n%s\n%s", err, opts.errstr, log_buf);
+	free(log_buf);
+	return err;
+}
+
+static int do_loader(int argc, char **argv)
+{
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, open_opts);
+	DECLARE_LIBBPF_OPTS(gen_loader_opts, gen);
+	struct bpf_object_load_attr load_attr = {};
+	struct bpf_object *obj;
+	const char *file;
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
+	err = bpf_object__gen_loader(obj, &gen);
+	if (err)
+		goto err_close_obj;
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
+		dump_xlated_plain(&dd, (void *)gen.insns, gen.insns_sz, false, false);
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

