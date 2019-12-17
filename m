Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B667F123AC5
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbfLQXZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:25:47 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48880 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726072AbfLQXZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:25:44 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHNOPIn008536
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 15:25:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=bDHcyzlZLq5F6XnBJeIhVvZMO15PPwVgRthx/TMcXKc=;
 b=RQAUUHte4yhEoL4jIe+c6mgeIR3m9JDYvaG99WAXWdyL/mhyarwnvAOeBpWZpOSTzjKI
 AEQhnCotnmg0OVcIrptTS/jDmFAjKHZX/TxzzDChoHw/hDVq0pyQ5SPGg9gHZ2AwQ9hQ
 TztokwqzS5bmeS1eFa/yLpkBePX3Hman+O4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxg74pg1q-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 15:25:41 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 17 Dec 2019 15:25:40 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 71CB92EC1C52; Tue, 17 Dec 2019 15:00:46 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/3] bpftool, selftests/bpf: embed object file inside skeleton
Date:   Tue, 17 Dec 2019 15:00:36 -0800
Message-ID: <20191217230038.1562848-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191217230038.1562848-1-andriin@fb.com>
References: <20191217230038.1562848-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_05:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=25 bulkscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912170187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Embed contents of BPF object file used for BPF skeleton generation inside
skeleton itself. This allows to keep BPF object file and its skeleton in sync
at all times, and simpifies skeleton instantiation.

Also switch existing selftests to not require BPF_EMBED_OBJ anymore.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/gen.c                       | 226 +++++++++++-------
 .../selftests/bpf/prog_tests/attach_probe.c   |   4 +-
 .../selftests/bpf/prog_tests/core_extern.c    |   4 +-
 .../selftests/bpf/prog_tests/fentry_fexit.c   |  10 +-
 .../selftests/bpf/prog_tests/fentry_test.c    |   7 +-
 tools/testing/selftests/bpf/prog_tests/mmap.c |   4 +-
 .../selftests/bpf/prog_tests/skeleton.c       |   4 +-
 .../bpf/prog_tests/stacktrace_build_id.c      |   4 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |   4 +-
 9 files changed, 152 insertions(+), 115 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index f70088b4c19b..27dfbd363430 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -16,6 +16,7 @@
 #include <libbpf.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/mman.h>
 #include <unistd.h>
 
 #include "btf.h"
@@ -261,14 +262,16 @@ static int codegen(const char *template, ...)
 static int do_skeleton(int argc, char **argv)
 {
 	char header_guard[MAX_OBJ_NAME_LEN + sizeof("__SKEL_H__")];
-	size_t i, map_cnt = 0, prog_cnt = 0;
-	char obj_name[MAX_OBJ_NAME_LEN];
+	size_t i, map_cnt = 0, prog_cnt = 0, file_sz, mmap_sz;
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts);
+	char obj_name[MAX_OBJ_NAME_LEN], *obj_data;
+	struct bpf_object *obj = NULL;
 	const char *file, *ident;
 	struct bpf_program *prog;
-	struct bpf_object *obj;
+	int fd, len, err = -1;
 	struct bpf_map *map;
 	struct btf *btf;
-	int err = -1;
+	struct stat st;
 
 	if (!REQ_ARGS(1)) {
 		usage();
@@ -281,14 +284,31 @@ static int do_skeleton(int argc, char **argv)
 		return -1;
 	}
 
-	obj = bpf_object__open_file(file, NULL);
-	if (IS_ERR(obj)) {
-		p_err("failed to open BPF object file: %ld", PTR_ERR(obj));
+	if (stat(file, &st)) {
+		p_err("failed to stat() %s: %s", file, strerror(errno));
 		return -1;
 	}
-
+	file_sz = st.st_size;
+	mmap_sz = roundup(file_sz, sysconf(_SC_PAGE_SIZE));
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		p_err("failed to open() %s: %s", file, strerror(errno));
+		return -1;
+	}
+	obj_data = mmap(NULL, mmap_sz, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (obj_data == MAP_FAILED) {
+		obj_data = NULL;
+		p_err("failed to mmap() %s: %s", file, strerror(errno));
+		goto out;
+	}
 	get_obj_name(obj_name, file);
-	get_header_guard(header_guard, obj_name);
+	opts.object_name = obj_name;
+	obj = bpf_object__open_mem(obj_data, file_sz, &opts);
+	if (IS_ERR(obj)) {
+		obj = NULL;
+		p_err("failed to open BPF object file: %ld", PTR_ERR(obj));
+		goto out;
+	}
 
 	bpf_object__for_each_map(map, obj) {
 		ident = get_map_ident(map);
@@ -303,8 +323,11 @@ static int do_skeleton(int argc, char **argv)
 		prog_cnt++;
 	}
 
+	get_header_guard(header_guard, obj_name);
 	codegen("\
 		\n\
+		/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */   \n\
+									    \n\
 		/* THIS FILE IS AUTOGENERATED! */			    \n\
 		#ifndef %2$s						    \n\
 		#define %2$s						    \n\
@@ -356,8 +379,88 @@ static int do_skeleton(int argc, char **argv)
 		\n\
 		};							    \n\
 									    \n\
+		static void						    \n\
+		%1$s__destroy(struct %1$s *obj)				    \n\
+		{							    \n\
+			if (!obj)					    \n\
+				return;					    \n\
+			if (obj->skeleton)				    \n\
+				bpf_object__destroy_skeleton(obj->skeleton);\n\
+			free(obj);					    \n\
+		}							    \n\
+									    \n\
 		static inline struct bpf_object_skeleton *		    \n\
-		%1$s__create_skeleton(struct %1$s *obj, struct bpf_embed_data *embed)\n\
+		%1$s__create_skeleton(struct %1$s *obj);		    \n\
+									    \n\
+		static inline struct %1$s *				    \n\
+		%1$s__open_opts(const struct bpf_object_open_opts *opts)    \n\
+		{							    \n\
+			struct %1$s *obj;				    \n\
+									    \n\
+			obj = calloc(1, sizeof(*obj));			    \n\
+			if (!obj)					    \n\
+				return NULL;				    \n\
+									    \n\
+			obj->skeleton = %1$s__create_skeleton(obj);	    \n\
+			if (!obj->skeleton)				    \n\
+				goto err;				    \n\
+									    \n\
+			if (bpf_object__open_skeleton(obj->skeleton, opts)) \n\
+				goto err;				    \n\
+									    \n\
+			return obj;					    \n\
+		err:							    \n\
+			%1$s__destroy(obj);				    \n\
+			return NULL;					    \n\
+		}							    \n\
+									    \n\
+		static inline struct %1$s *				    \n\
+		%1$s__open()						    \n\
+		{							    \n\
+			return %1$s__open_opts(NULL);			    \n\
+		}							    \n\
+									    \n\
+		static inline int					    \n\
+		%1$s__load(struct %1$s *obj)				    \n\
+		{							    \n\
+			return bpf_object__load_skeleton(obj->skeleton);    \n\
+		}							    \n\
+									    \n\
+		static inline struct %1$s *				    \n\
+		%1$s__open_and_load()					    \n\
+		{							    \n\
+			struct %1$s *obj;				    \n\
+									    \n\
+			obj = %1$s__open();				    \n\
+			if (!obj)					    \n\
+				return NULL;				    \n\
+			if (%1$s__load(obj)) {				    \n\
+				%1$s__destroy(obj);			    \n\
+				return NULL;				    \n\
+			}						    \n\
+			return obj;					    \n\
+		}							    \n\
+									    \n\
+		static inline int					    \n\
+		%1$s__attach(struct %1$s *obj)				    \n\
+		{							    \n\
+			return bpf_object__attach_skeleton(obj->skeleton);  \n\
+		}							    \n\
+									    \n\
+		static inline void					    \n\
+		%1$s__detach(struct %1$s *obj)				    \n\
+		{							    \n\
+			return bpf_object__detach_skeleton(obj->skeleton);  \n\
+		}							    \n\
+		",
+		obj_name
+	);
+
+	codegen("\
+		\n\
+									    \n\
+		static inline struct bpf_object_skeleton *		    \n\
+		%1$s__create_skeleton(struct %1$s *obj)			    \n\
 		{							    \n\
 			struct bpf_object_skeleton *s;			    \n\
 									    \n\
@@ -367,8 +470,6 @@ static int do_skeleton(int argc, char **argv)
 									    \n\
 			s->sz = sizeof(*s);				    \n\
 			s->name = \"%1$s\";				    \n\
-			s->data = embed->data;				    \n\
-			s->data_sz = embed->size;			    \n\
 			s->obj = &obj->obj;				    \n\
 		",
 		obj_name
@@ -438,90 +539,45 @@ static int do_skeleton(int argc, char **argv)
 	codegen("\
 		\n\
 									    \n\
+			s->data_sz = %d;				    \n\
+			s->data = \"\\					    \n\
+		",
+		file_sz);
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
+
+	codegen("\
+		\n\
+		\";							    \n\
+									    \n\
 			return s;					    \n\
 		err:							    \n\
 			bpf_object__destroy_skeleton(s);		    \n\
 			return NULL;					    \n\
 		}							    \n\
 									    \n\
-		static void						    \n\
-		%1$s__destroy(struct %1$s *obj)				    \n\
-		{							    \n\
-			if (!obj)					    \n\
-				return;					    \n\
-			if (obj->skeleton)				    \n\
-				bpf_object__destroy_skeleton(obj->skeleton);\n\
-			free(obj);					    \n\
-		}							    \n\
-									    \n\
-		static inline struct %1$s *				    \n\
-		%1$s__open_opts(struct bpf_embed_data *embed, const struct bpf_object_open_opts *opts)\n\
-		{							    \n\
-			struct %1$s *obj;				    \n\
-									    \n\
-			obj = calloc(1, sizeof(*obj));			    \n\
-			if (!obj)					    \n\
-				return NULL;				    \n\
-									    \n\
-			obj->skeleton = %1$s__create_skeleton(obj, embed);  \n\
-			if (!obj->skeleton)				    \n\
-				goto err;				    \n\
-									    \n\
-			if (bpf_object__open_skeleton(obj->skeleton, opts)) \n\
-				goto err;				    \n\
-									    \n\
-			return obj;					    \n\
-		err:							    \n\
-			%1$s__destroy(obj);				    \n\
-			return NULL;					    \n\
-		}							    \n\
-									    \n\
-		static inline struct %1$s *				    \n\
-		%1$s__open(struct bpf_embed_data *embed)		    \n\
-		{							    \n\
-			return %1$s__open_opts(embed, NULL);		    \n\
-		}							    \n\
-									    \n\
-		static inline int					    \n\
-		%1$s__load(struct %1$s *obj)				    \n\
-		{							    \n\
-			return bpf_object__load_skeleton(obj->skeleton);    \n\
-		}							    \n\
-									    \n\
-		static inline struct %1$s *				    \n\
-		%1$s__open_and_load(struct bpf_embed_data *embed)	    \n\
-		{							    \n\
-			struct %1$s *obj;				    \n\
-									    \n\
-			obj = %1$s__open(embed);			    \n\
-			if (!obj)					    \n\
-				return NULL;				    \n\
-			if (%1$s__load(obj)) {				    \n\
-				%1$s__destroy(obj);			    \n\
-				return NULL;				    \n\
-			}						    \n\
-			return obj;					    \n\
-		}							    \n\
-									    \n\
-		static inline int					    \n\
-		%1$s__attach(struct %1$s *obj)				    \n\
-		{							    \n\
-			return bpf_object__attach_skeleton(obj->skeleton);  \n\
-		}							    \n\
-									    \n\
-		static inline void					    \n\
-		%1$s__detach(struct %1$s *obj)				    \n\
-		{							    \n\
-			return bpf_object__detach_skeleton(obj->skeleton);  \n\
-		}							    \n\
-									    \n\
 		#endif /* %2$s */					    \n\
 		",
-		obj_name, header_guard
-	);
+		obj_name, header_guard);
 	err = 0;
 out:
 	bpf_object__close(obj);
+	if (obj_data)
+		munmap(obj_data, mmap_sz);
+	close(fd);
 	return err;
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index 60da1d08daa0..5ed90ede2f1d 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -22,8 +22,6 @@ ssize_t get_base_addr() {
 	return -EINVAL;
 }
 
-BPF_EMBED_OBJ(probe, "test_attach_probe.o");
-
 void test_attach_probe(void)
 {
 	int duration = 0;
@@ -39,7 +37,7 @@ void test_attach_probe(void)
 		return;
 	uprobe_offset = (size_t)&get_base_addr - base_addr;
 
-	skel = test_attach_probe__open_and_load(&probe_embed);
+	skel = test_attach_probe__open_and_load();
 	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
 		return;
 	if (CHECK(!skel->bss, "check_bss", ".bss wasn't mmap()-ed\n"))
diff --git a/tools/testing/selftests/bpf/prog_tests/core_extern.c b/tools/testing/selftests/bpf/prog_tests/core_extern.c
index 30a7972e9012..5f03dc1de29e 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_extern.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_extern.c
@@ -124,8 +124,6 @@ static struct test_case {
 	{ .name = "u64 (max+1)", .fails = 1, .cfg = CFG"CONFIG_ULONG=0x10000000000000000" },
 };
 
-BPF_EMBED_OBJ(core_extern, "test_core_extern.o");
-
 void test_core_extern(void)
 {
 	const uint32_t kern_ver = get_kernel_version();
@@ -159,7 +157,7 @@ void test_core_extern(void)
 			opts.kconfig_path = tmp_cfg_path;
 		}
 
-		skel = test_core_extern__open_opts(&core_extern_embed, &opts);
+		skel = test_core_extern__open_opts(&opts);
 		if (CHECK(!skel, "skel_open", "skeleton open failed\n"))
 			goto cleanup;
 		err = test_core_extern__load(skel);
diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c b/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
index 110fcf053fd0..235ac4f67f5b 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
@@ -5,10 +5,6 @@
 #include "fentry_test.skel.h"
 #include "fexit_test.skel.h"
 
-BPF_EMBED_OBJ(pkt_access, "test_pkt_access.o");
-BPF_EMBED_OBJ(fentry, "fentry_test.o");
-BPF_EMBED_OBJ(fexit, "fexit_test.o");
-
 void test_fentry_fexit(void)
 {
 	struct test_pkt_access *pkt_skel = NULL;
@@ -18,13 +14,13 @@ void test_fentry_fexit(void)
 	__u32 duration = 0, retval;
 	int err, pkt_fd, i;
 
-	pkt_skel = test_pkt_access__open_and_load(&pkt_access_embed);
+	pkt_skel = test_pkt_access__open_and_load();
 	if (CHECK(!pkt_skel, "pkt_skel_load", "pkt_access skeleton failed\n"))
 		return;
-	fentry_skel = fentry_test__open_and_load(&fentry_embed);
+	fentry_skel = fentry_test__open_and_load();
 	if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
 		goto close_prog;
-	fexit_skel = fexit_test__open_and_load(&fexit_embed);
+	fexit_skel = fexit_test__open_and_load();
 	if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
 		goto close_prog;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
index 46a4afdf507a..e1a379f5f7d2 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
@@ -4,9 +4,6 @@
 #include "test_pkt_access.skel.h"
 #include "fentry_test.skel.h"
 
-BPF_EMBED_OBJ_DECLARE(pkt_access);
-BPF_EMBED_OBJ_DECLARE(fentry);
-
 void test_fentry_test(void)
 {
 	struct test_pkt_access *pkt_skel = NULL;
@@ -15,10 +12,10 @@ void test_fentry_test(void)
 	__u32 duration, retval;
 	__u64 *result;
 
-	pkt_skel = test_pkt_access__open_and_load(&pkt_access_embed);
+	pkt_skel = test_pkt_access__open_and_load();
 	if (CHECK(!pkt_skel, "pkt_skel_load", "pkt_access skeleton failed\n"))
 		return;
-	fentry_skel = fentry_test__open_and_load(&fentry_embed);
+	fentry_skel = fentry_test__open_and_load();
 	if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
 		goto cleanup;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testing/selftests/bpf/prog_tests/mmap.c
index 95a44d37ccea..16a814eb4d64 100644
--- a/tools/testing/selftests/bpf/prog_tests/mmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -13,8 +13,6 @@ static size_t roundup_page(size_t sz)
 	return (sz + page_size - 1) / page_size * page_size;
 }
 
-BPF_EMBED_OBJ(test_mmap, "test_mmap.o");
-
 void test_mmap(void)
 {
 	const size_t bss_sz = roundup_page(sizeof(struct test_mmap__bss));
@@ -30,7 +28,7 @@ void test_mmap(void)
 	__u64 val = 0;
 
 
-	skel = test_mmap__open_and_load(&test_mmap_embed);
+	skel = test_mmap__open_and_load();
 	if (CHECK(!skel, "skel_open_and_load", "skeleton open/load failed\n"))
 		return;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/skeleton.c b/tools/testing/selftests/bpf/prog_tests/skeleton.c
index 151cdad3ad0d..ec6f2aec3853 100644
--- a/tools/testing/selftests/bpf/prog_tests/skeleton.c
+++ b/tools/testing/selftests/bpf/prog_tests/skeleton.c
@@ -10,8 +10,6 @@ struct s {
 
 #include "test_skeleton.skel.h"
 
-BPF_EMBED_OBJ(skeleton, "test_skeleton.o");
-
 void test_skeleton(void)
 {
 	int duration = 0, err;
@@ -19,7 +17,7 @@ void test_skeleton(void)
 	struct test_skeleton__bss *bss;
 	struct test_skeleton__externs *exts;
 
-	skel = test_skeleton__open(&skeleton_embed);
+	skel = test_skeleton__open();
 	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
 		return;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
index 4af8b8253f25..e8399ae50e77 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
@@ -2,8 +2,6 @@
 #include <test_progs.h>
 #include "test_stacktrace_build_id.skel.h"
 
-BPF_EMBED_OBJ(stacktrace_build_id, "test_stacktrace_build_id.o");
-
 void test_stacktrace_build_id(void)
 {
 
@@ -18,7 +16,7 @@ void test_stacktrace_build_id(void)
 	int retry = 1;
 
 retry:
-	skel = test_stacktrace_build_id__open_and_load(&stacktrace_build_id_embed);
+	skel = test_stacktrace_build_id__open_and_load();
 	if (CHECK(!skel, "skel_open_and_load", "skeleton open/load failed\n"))
 		return;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index 32fb03881a7b..8974450a4bdb 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -15,8 +15,6 @@ static __u64 read_perf_max_sample_freq(void)
 	return sample_freq;
 }
 
-BPF_EMBED_OBJ_DECLARE(stacktrace_build_id);
-
 void test_stacktrace_build_id_nmi(void)
 {
 	int control_map_fd, stackid_hmap_fd, stackmap_fd;
@@ -37,7 +35,7 @@ void test_stacktrace_build_id_nmi(void)
 	attr.sample_freq = read_perf_max_sample_freq();
 
 retry:
-	skel = test_stacktrace_build_id__open(&stacktrace_build_id_embed);
+	skel = test_stacktrace_build_id__open();
 	if (CHECK(!skel, "skel_open", "skeleton open failed\n"))
 		return;
 
-- 
2.17.1

