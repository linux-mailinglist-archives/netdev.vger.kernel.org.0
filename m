Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49A411232D
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 08:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfLDHAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 02:00:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7916 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727244AbfLDHAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 02:00:47 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xB46xHjM026678
        for <netdev@vger.kernel.org>; Tue, 3 Dec 2019 23:00:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=6lBWJK4UZiuVxdFPE9DkCNX77Ec/s85HMWRA/PLSa1Y=;
 b=aBDH+XHZ+yM9coDYYgByPm5TdZCrp4U3c8NGCX3P662XbXXWmV+ZuURbAB6A6hyMOz0K
 LefV85WCLhjsqHqoJdmgA/9U65pavBJz9WwgPgjh9lv/UiVasXYXx2d82pmDnAE5tfQ+
 Rxm5yCBwIkckVAgKJRzJ5RJPin9WYU3W+94= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2wp7q4g2p0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 23:00:45 -0800
Received: from 2401:db00:30:6012:face:0:17:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 3 Dec 2019 23:00:43 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A104F2EC1853; Tue,  3 Dec 2019 23:00:42 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 11/16] bpftool: add skeleton codegen command
Date:   Tue, 3 Dec 2019 23:00:10 -0800
Message-ID: <20191204070015.3523523-12-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191204070015.3523523-1-andriin@fb.com>
References: <20191204070015.3523523-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_01:2019-12-04,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=25
 impostorscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912040051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add `bpftool gen skeleton` command, which takes in compiled BPF .o object file
and dumps a BPF skeleton struct and related code to work with that skeleton.
Skeleton itself is tailored to a specific structure of provided BPF object
file, containing accessors (just plain struct fields) for every map and
program, as well as dedicated space for bpf_links. If BPF program is using
global variables, corresponding structure definitions of compatible memory
layout are emitted as well, making it possible to initialize and subsequently
read/update global variables values using simple and clear C syntax for
accessing fields. This skeleton majorly improves usability of
opening/loading/attaching of BPF object, as well as interacting with it
throughout the lifetime of loaded BPF object.

Generated skeleton struct has the following structure:

struct <object-name> {
	/* used by libbpf's skeleton API */
	struct bpf_object_skeleton *skeleton;
	/* bpf_object for libbpf APIs */
	struct bpf_object *obj;
	struct {
		/* for every defined map in BPF object: */
		struct bpf_map *<map-name>;
	} maps;
	struct {
		/* for every program in BPF object: */
		struct bpf_program *<program-name>;
	} progs;
	struct {
		/* for every program in BPF object: */
		struct bpf_link *<program-name>;
	} links;
	/* for every present global data section: */
	struct <object-name>__<one of bss, data, or rodata> {
		/* memory layout of corresponding data section,
		 * with every defined variable represented as a struct field
		 * with exactly the same type, but without const/volatile
		 * modifiers, e.g.:
		 */
		 int *my_var_1;
		 ...
	} *<one of bss, data, or rodata>;
};

This provides great usability improvements:
- no need to look up maps and programs by name, instead just
  my_obj->maps.my_map or my_obj->progs.my_prog would give necessary
  bpf_map/bpf_program pointers, which user can pass to existing libbpf APIs;
- pre-defined places for bpf_links, which will be automatically populated for
  program types that libbpf knows how to attach automatically (currently
  tracepoints, kprobe/kretprobe, raw tracepoint and tracing programs). On
  tearing down skeleton, all active bpf_links will be destroyed (meaning BPF
  programs will be detached, if they are attached). For cases in which libbpf
  doesn't know how to auto-attach BPF program, user can manually create link
  after loading skeleton and they will be auto-detached on skeleton
  destruction:

	my_obj->links.my_fancy_prog = bpf_program__attach_cgroup_whatever(
		my_obj->progs.my_fancy_prog, <whatever extra param);

- it's extremely easy and convenient to work with global data from userspace
  now. Both for read-only and read/write variables, it's possible to
  pre-initialize them before skeleton is loaded:

	skel = my_obj__open(raw_embed_data);
	my_obj->rodata->my_var = 123;
	my_obj__load(skel); /* 123 will be initialization value for my_var */

  After load, if kernel supports mmap() for BPF arrays, user can still read
  (and write for .bss and .data) variables values, but at that point it will
  be directly mmap()-ed to BPF array, backing global variables. This allows to
  seamlessly exchange data with BPF side. From userspace program's POV, all
  the pointers and memory contents stay the same, but mapped kernel memory
  changes to point to created map.
  If kernel doesn't yet support mmap() for BPF arrays, it's still possible to
  use those data section structs to pre-initialize .bss, .data, and .rodata,
  but after load their pointers will be reset to NULL, allowing user code to
  gracefully handle this condition, if necessary.

Given a lot of surface area, skeleton is kept as an experimental non-public
API for now, until more feedback and real-world experience is collected.

runqslower example and selftests further help to demonstrate usability
benefits of this approach.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/gen.c  | 482 +++++++++++++++++++++++++++++++++++++++
 tools/bpf/bpftool/main.c |   1 +
 tools/bpf/bpftool/main.h |   1 +
 3 files changed, 484 insertions(+)
 create mode 100644 tools/bpf/bpftool/gen.c

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
new file mode 100644
index 000000000000..640f6452eea0
--- /dev/null
+++ b/tools/bpf/bpftool/gen.c
@@ -0,0 +1,482 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2019 Facebook */
+
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <ctype.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/err.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <bpf.h>
+#include <libbpf.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "btf.h"
+#include "libbpf_internal.h"
+#include "json_writer.h"
+#include "main.h"
+
+
+#define MAX_OBJ_NAME_LEN 64
+
+static void sanitize_identifier(char *name)
+{
+	int i;
+
+	for (i = 0; name[i]; i++)
+		if (!isalnum(name[i]) && name[i] != '_')
+			name[i] = '_';
+}
+
+static bool str_has_suffix(const char *str, const char *suffix)
+{
+	size_t i, n1 = strlen(str), n2 = strlen(suffix);
+
+	if (n1 < n2)
+		return false;
+
+	for (i = 0; i < n2; i++) {
+		if (str[n1 - i - 1] != suffix[n2 - i - 1])
+			return false;
+	}
+
+	return true;
+}
+
+static void get_obj_name(char *name, const char *file)
+{
+	/* Using basename() GNU version which doesn't modify arg. */
+	strncpy(name, basename(file), MAX_OBJ_NAME_LEN - 1);
+	name[MAX_OBJ_NAME_LEN - 1] = '\0';
+	if (str_has_suffix(name, ".o"))
+		name[strlen(name) - 2] = '\0';
+	sanitize_identifier(name);
+}
+
+static void get_header_guard(char *guard, const char *obj_name)
+{
+	int i;
+
+	sprintf(guard, "__%s_EMBED_H__", obj_name);
+	for (i = 0; guard[i]; i++)
+		guard[i] = toupper(guard[i]);
+}
+
+static const char *get_map_ident(const struct bpf_map *map)
+{
+	const char *name = bpf_map__name(map);
+
+	if (!bpf_map__is_internal(map))
+		return name;
+
+	if (str_has_suffix(name, ".data"))
+		return "data";
+	else if (str_has_suffix(name, ".rodata"))
+		return "rodata";
+	else if (str_has_suffix(name, ".bss"))
+		return "bss";
+	else
+		return NULL;
+}
+
+static void codegen_btf_dump_printf(void *ct, const char *fmt, va_list args)
+{
+	vprintf(fmt, args);
+}
+
+static int codegen_datasec_def(struct bpf_object *obj,
+			       struct btf *btf,
+			       struct btf_dump *d,
+			       const struct btf_type *sec,
+			       const char *obj_name)
+{
+	const char *sec_name = btf__name_by_offset(btf, sec->name_off);
+	const struct btf_var_secinfo* sec_var = btf_var_secinfos(sec);
+	const char *sec_ident;
+	int i, off = 0, pad_cnt = 0, vlen = btf_vlen(sec);
+
+	if (strcmp(sec_name, ".data") == 0) {
+		sec_ident = "data";
+	} else if (strcmp(sec_name, ".bss") == 0) {
+		sec_ident = "bss";
+	} else if (strcmp(sec_name, ".rodata") == 0) {
+		sec_ident = "rodata";
+	} else {
+		return 0;
+	}
+
+	printf("	struct %s__%s {\n", obj_name, sec_ident);
+	for (i = 0; i < vlen; i++, sec_var++) {
+		const struct btf_type *var = btf__type_by_id(btf, sec_var->type);
+		const char *var_name = btf__name_by_offset(btf, var->name_off);
+		int align = btf_align_of(btf, var->type);
+		int need_off = sec_var->offset;
+		int align_off;
+		__u32 var_type_id = var->type;
+		const struct btf_type *t = btf__type_by_id(btf, var_type_id);
+
+		while (btf_is_mod(t)) {
+			var_type_id = t->type;
+			t = btf__type_by_id(btf, var_type_id);
+		}
+
+		if (off > need_off) {
+			p_err("Something is wrong for %s's variable #%d: need offset %d, already at %d.\n",
+			      sec_name, i, need_off, off);
+			return -1;
+		}
+
+		align_off = (off + align - 1) / align * align;
+		if (align_off != need_off) {
+			printf("\t\tchar __pad%d[%d];\n",
+			       pad_cnt, need_off - off);
+			pad_cnt++;
+		}
+
+		printf("\t\t");
+		btf_dump_emit_type_decl(d, var_type_id, var_name, 2);
+		printf(";\n");
+
+		off = sec_var->offset + sec_var->size;
+	}
+	printf("	} *%s;\n", sec_ident);
+	return 0;
+}
+
+static int codegen_datasecs(struct bpf_object *obj, const char *obj_name)
+{
+	struct btf_dump *d;
+	struct btf *btf = bpf_object__btf(obj);
+	int i, err = 0, n = btf__get_nr_types(btf);
+
+	d = btf_dump__new(btf, NULL, NULL, codegen_btf_dump_printf);
+	if (IS_ERR(d))
+		return PTR_ERR(d);
+
+
+	for (i = 1; i <= n; i++) {
+		const struct btf_type *t = btf__type_by_id(btf, i);
+
+		if (!btf_is_datasec(t))
+			continue;
+
+		err = codegen_datasec_def(obj, btf, d, t, obj_name);
+		if (err)
+			goto out;
+	}
+out:
+	btf_dump__free(d);
+	return err;
+}
+
+static int do_skeleton(int argc, char **argv)
+{
+	char header_guard[MAX_OBJ_NAME_LEN + sizeof("__EMBED_H__")];
+	size_t i, map_cnt = 0, prog_cnt = 0;
+	char obj_name[MAX_OBJ_NAME_LEN];
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	struct bpf_map *map;
+	const char *file;
+	struct btf *btf;
+	int err = -1;
+
+	if (!REQ_ARGS(1)) {
+		usage();
+		return -1;
+	}
+	file = GET_ARG();
+
+	if (argc) {
+		p_err("extra unknown arguments");
+		return -1;
+	}
+
+	obj = bpf_object__open_file(file, NULL);
+	if (IS_ERR(obj)) {
+		p_err("failed to open BPF object file: %ld", PTR_ERR(obj));
+		return -1;
+	}
+
+	get_obj_name(obj_name, file);
+	get_header_guard(header_guard, obj_name);
+
+	bpf_object__for_each_map(map, obj) {
+		map_cnt++;
+	}
+	bpf_object__for_each_program(prog, obj) {
+		prog_cnt++;
+	}
+
+	printf(
+		"/* THIS FILE IS AUTOGENERATED! */\n"
+		"#ifndef %2$s\n"
+		"#define %2$s\n"
+		"\n"
+		"#include <stdlib.h>\n"
+		"#include <libbpf.h>\n"
+		"#include <libbpf_internal.h>\n"
+		"\n"
+		"struct %1$s {\n"
+		"	struct bpf_object_skeleton *skeleton;\n"
+		"	struct bpf_object *obj;\n",
+		obj_name, header_guard
+	);
+
+	if (map_cnt) {
+		printf("\tstruct {\n");
+		bpf_object__for_each_map(map, obj) {
+			const char *name = get_map_ident(map);
+
+			if (!name) {
+				p_err("unrecognized internal map '%s'",
+				      bpf_map__name(map));
+				goto out;
+			}
+			printf("\t\tstruct bpf_map *%s;\n", name);
+		}
+		printf("\t} maps;\n");
+	}
+
+	if (prog_cnt) {
+		printf("\tstruct {\n");
+		bpf_object__for_each_program(prog, obj) {
+			printf("\t\tstruct bpf_program *%s;\n",
+			       bpf_program__name(prog));
+		}
+		printf("\t} progs;\n");
+		printf("\tstruct {\n");
+		bpf_object__for_each_program(prog, obj) {
+			printf("\t\tstruct bpf_link *%s;\n",
+			       bpf_program__name(prog));
+		}
+		printf("\t} links;\n");
+	}
+	
+	btf = bpf_object__btf(obj);
+	if (btf) {
+		err = codegen_datasecs(obj, obj_name);
+		if (err)
+			goto out;
+	}
+
+	printf(
+		"};\n"
+		"\n"
+		"static inline struct bpf_object_skeleton *\n"
+		"%1$s__create_skeleton(struct %1$s *obj, struct bpf_embed_data *embed)\n"
+		"{\n"
+		"	struct bpf_object_skeleton *s;\n"
+		"\n"
+		"	s = calloc(1, sizeof(*s));\n"
+		"	if (!s)\n"
+		"		return NULL;\n"
+		"\n"
+		"	s->sz = sizeof(*s);\n"
+		"	s->name = \"%1$s\";\n"
+		"	s->data = embed->data;\n"
+		"	s->data_sz = embed->size;\n"
+		"	s->obj = &obj->obj;\n",
+		obj_name
+	);
+	if (map_cnt) {
+		printf(
+			"\n"
+			"	/* maps */\n"
+			"	s->map_cnt = %zu;\n"
+			"	s->map_skel_sz = sizeof(*s->maps);\n"
+			"	s->maps = calloc(s->map_cnt, s->map_skel_sz);\n"
+			"	if (!s->maps)\n"
+			"		goto err;\n",
+			map_cnt
+		);
+		i = 0;
+		bpf_object__for_each_map(map, obj) {
+			printf("\ts->maps[%zu].name = \"%s\";\n",
+			       i, bpf_map__name(map));
+			printf("\ts->maps[%zu].map = &obj->maps.%s;\n",
+			       i, get_map_ident(map));
+			/* memory-mapped internal maps */
+			if (bpf_map__is_internal(map) &&
+			    (bpf_map__def(map)->map_flags & BPF_F_MMAPABLE)) {
+				const char *ident = get_map_ident(map);
+
+				if (!ident) {
+					err = -EINVAL;
+					p_err("unrecognized internal map '%s'\n",
+					      bpf_map__name(map));
+					goto out;
+				}
+				printf("\ts->maps[%zu].mmaped = (void **)&obj->%s;\n",
+				       i, ident);
+			}
+			i++;
+		}
+	}
+	if (prog_cnt) {
+		printf(
+			"\n"
+			"	/* programs */\n"
+			"	s->prog_cnt = %zu;\n"
+			"	s->prog_skel_sz = sizeof(*s->progs);\n"
+			"	s->progs = calloc(s->prog_cnt, s->prog_skel_sz);\n"
+			"	if (!s->progs)\n"
+			"		goto err;\n",
+			prog_cnt
+		);
+		i = 0;
+		bpf_object__for_each_program(prog, obj) {
+			printf("\ts->progs[%zu].name = \"%s\";\n",
+			       i, bpf_program__name(prog));
+			printf("\ts->progs[%zu].prog = &obj->progs.%s;\n",
+			       i, bpf_program__name(prog));
+			printf("\ts->progs[%zu].link = &obj->links.%s;\n",
+			       i, bpf_program__name(prog));
+			i++;
+		}
+	}
+	printf(
+		"\n"
+		"	return s;\n"
+		"err:\n"
+		"	bpf_object__destroy_skeleton(s);\n"
+		"	return NULL;\n"
+		"}\n"
+		"static void\n"
+		"%1$s__destroy(struct %1$s *obj)\n"
+		"{\n"
+		"	if (!obj)\n"
+		"		return;\n"
+		"	if (obj->skeleton)\n"
+		"		bpf_object__destroy_skeleton(obj->skeleton);\n"
+		"	free(obj);\n"
+		"}\n"
+		"\n"
+		"static inline struct %1$s *\n"
+		"%1$s__open_opts(struct bpf_embed_data *embed, const struct bpf_object_open_opts *opts)\n"
+		"{\n"
+		"	struct %1$s *obj;\n"
+		"\n"
+		"	obj = calloc(1, sizeof(*obj));\n"
+		"	if (!obj)\n"
+		"		return NULL;\n"
+		"\n"
+		"	obj->skeleton = %1$s__create_skeleton(obj, embed);\n"
+		"	if (!obj->skeleton)\n"
+		"		goto err;\n"
+		"\n"
+		"	if (bpf_object__open_skeleton(obj->skeleton, opts))\n"
+		"		goto err;\n"
+		"\n"
+		"	return obj;\n"
+		"err:\n"
+		"	%1$s__destroy(obj);\n"
+		"	return NULL;\n"
+		"}\n"
+		"\n"
+		"static inline struct %1$s *\n"
+		"%1$s__open(struct bpf_embed_data *embed)\n"
+		"{\n"
+		"	return %1$s__open_opts(embed, NULL);\n"
+		"}\n"
+		"\n"
+		"static inline int\n"
+		"%1$s__load_opts(struct %1$s *obj, const void *opts)\n"
+		"{\n"
+		"	return bpf_object__load_skeleton(obj->skeleton, opts);\n"
+		"}\n"
+		"\n"
+		"static inline int\n"
+		"%1$s__load(struct %1$s *obj)\n"
+		"{\n"
+		"	return %1$s__load_opts(obj, NULL);\n"
+		"}\n"
+		"\n"
+		"static inline struct %1$s *\n"
+		"%1$s__open_and_load_opts(\n"
+		"		struct bpf_embed_data *embed,\n"
+		"		const struct bpf_object_open_opts *open_opts,\n"
+		"		const void *load_opts)\n"
+		"{\n"
+		"	struct %1$s *obj;\n"
+		"\n"
+		"	obj = %1$s__open_opts(embed, open_opts);\n"
+		"	if (!obj)\n"
+		"		return NULL;\n"
+		"\n"
+		"	if (%1$s__load_opts(obj, load_opts)) {\n"
+		"		%1$s__destroy(obj);\n"
+		"		return NULL;\n"
+		"	}\n"
+		"\n"
+		"	return obj;\n"
+		"}\n"
+		"\n"
+		"static inline struct %1$s *\n"
+		"%1$s__open_and_load(struct bpf_embed_data *embed)\n"
+		"{\n"
+		"	return %1$s__open_and_load_opts(embed, NULL, NULL);\n"
+		"}\n"
+		"\n"
+		"static inline int\n"
+		"%1$s__attach_opts(struct %1$s *obj, const void *opts)\n"
+		"{\n"
+		"	return bpf_object__attach_skeleton(obj->skeleton, opts);\n"
+		"}\n"
+		"\n"
+		"static inline int\n"
+		"%1$s__attach(struct %1$s *obj)\n"
+		"{\n"
+		"	return %1$s__attach_opts(obj, NULL);\n"
+		"}\n"
+		"\n"
+		"static inline void\n"
+		"%1$s__detach(struct %1$s *obj)\n"
+		"{\n"
+		"	return bpf_object__detach_skeleton(obj->skeleton);\n"
+		"}\n"
+		"\n"
+		"#endif /* %2$s */\n",
+		obj_name, header_guard
+	);
+	err = 0;
+out:
+	bpf_object__close(obj);
+	return err;
+}
+
+static int do_help(int argc, char **argv)
+{
+	if (json_output) {
+		jsonw_null(json_wtr);
+		return 0;
+	}
+
+	fprintf(stderr,
+		"Usage: %1$s gen skeleton FILE\n"
+		"       %1$s gen help\n"
+		"\n"
+		"       " HELP_SPEC_OPTIONS "\n"
+		"",
+		bin_name);
+
+	return 0;
+}
+
+static const struct cmd cmds[] = {
+	{ "skeleton",	do_skeleton },
+	{ "help",	do_help },
+	{ 0 }
+};
+
+int do_gen(int argc, char **argv)
+{
+	return cmd_select(cmds, argc, argv, do_help);
+}
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 4764581ff9ea..758b294e8a7d 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -227,6 +227,7 @@ static const struct cmd cmds[] = {
 	{ "net",	do_net },
 	{ "feature",	do_feature },
 	{ "btf",	do_btf },
+	{ "gen",	do_gen },
 	{ "version",	do_version },
 	{ 0 }
 };
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 2899095f8254..7f49571bf6ce 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -155,6 +155,7 @@ int do_net(int argc, char **arg);
 int do_tracelog(int argc, char **arg);
 int do_feature(int argc, char **argv);
 int do_btf(int argc, char **argv);
+int do_gen(int argc, char **argv);
 
 int parse_u32_arg(int *argc, char ***argv, __u32 *val, const char *what);
 int prog_parse_fd(int *argc, char ***argv);
-- 
2.17.1

