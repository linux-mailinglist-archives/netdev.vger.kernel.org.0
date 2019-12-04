Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5E511231E
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 08:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfLDHAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 02:00:35 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42744 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727184AbfLDHAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 02:00:34 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB46xOpf029995
        for <netdev@vger.kernel.org>; Tue, 3 Dec 2019 23:00:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=PGnBYs0RBjCCuJ/sYGPxTaAd4goN73bG7MRJLKaOaXw=;
 b=P7klcLwa9WeDmarCoNySchbgasOz2XOWN1dOWJ1IfZTXziMxGGyIy/H6zd+d2E0iGMPt
 NUvV7VfLMCWA3nmq66kGdb8g85rZSbslwod4cidE/CF2HWnrGuznlBEGS3hlbr5kkBBv
 jNza6iG6RmiZ22owXj1C9Sgg7jfreVCdiCM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wnsmcv8u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 23:00:32 -0800
Received: from 2401:db00:2050:5076:face:0:7:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 3 Dec 2019 23:00:31 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7B5752EC1853; Tue,  3 Dec 2019 23:00:31 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 06/16] libbpf: expose BPF program's function name
Date:   Tue, 3 Dec 2019 23:00:05 -0800
Message-ID: <20191204070015.3523523-7-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191204070015.3523523-1-andriin@fb.com>
References: <20191204070015.3523523-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_01:2019-12-04,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 spamscore=0 suspectscore=8 malwarescore=0 phishscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912040051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add APIs to get BPF program function name, as opposed to bpf_program__title(),
which returns BPF program function's section name. Function name has a benefit
of being a valid C identifier and uniquely identifies a specific BPF program,
while section name can be duplicated across multiple independent BPF programs.

Add also bpf_object__find_program_by_name(), similar to
bpf_object__find_program_by_title(), to facilitate looking up BPF programs by
their C function names.

Convert one of selftests to new API for look up.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c                        | 28 +++++++++++++++----
 tools/lib/bpf/libbpf.h                        |  9 ++++--
 tools/lib/bpf/libbpf.map                      |  2 ++
 .../selftests/bpf/prog_tests/rdonly_maps.c    | 11 +++-----
 4 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index edfe1cf1e940..f13752c4d271 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -209,8 +209,8 @@ static const char * const libbpf_type_to_btf_name[] = {
 };
 
 struct bpf_map {
-	int fd;
 	char *name;
+	int fd;
 	int sec_idx;
 	size_t sec_offset;
 	int map_ifindex;
@@ -1384,7 +1384,7 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
 }
 
 static int bpf_object__init_maps(struct bpf_object *obj,
-				 struct bpf_object_open_opts *opts)
+				 const struct bpf_object_open_opts *opts)
 {
 	const char *pin_root_path = OPTS_GET(opts, pin_root_path, NULL);
 	bool strict = !OPTS_GET(opts, relaxed_maps, false);
@@ -1748,6 +1748,19 @@ bpf_object__find_program_by_title(const struct bpf_object *obj,
 	return NULL;
 }
 
+struct bpf_program *
+bpf_object__find_program_by_name(const struct bpf_object *obj,
+				 const char *name)
+{
+	struct bpf_program *prog;
+
+	bpf_object__for_each_program(prog, obj) {
+		if (!strcmp(prog->name, name))
+			return prog;
+	}
+	return NULL;
+}
+
 static bool bpf_object__shndx_is_data(const struct bpf_object *obj,
 				      int shndx)
 {
@@ -3893,7 +3906,7 @@ static int libbpf_find_attach_btf_id(const char *name,
 				     __u32 attach_prog_fd);
 static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
-		   struct bpf_object_open_opts *opts)
+		   const struct bpf_object_open_opts *opts)
 {
 	struct bpf_program *prog;
 	struct bpf_object *obj;
@@ -4002,7 +4015,7 @@ struct bpf_object *bpf_object__open(const char *path)
 }
 
 struct bpf_object *
-bpf_object__open_file(const char *path, struct bpf_object_open_opts *opts)
+bpf_object__open_file(const char *path, const struct bpf_object_open_opts *opts)
 {
 	if (!path)
 		return ERR_PTR(-EINVAL);
@@ -4014,7 +4027,7 @@ bpf_object__open_file(const char *path, struct bpf_object_open_opts *opts)
 
 struct bpf_object *
 bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
-		     struct bpf_object_open_opts *opts)
+		     const struct bpf_object_open_opts *opts)
 {
 	if (!obj_buf || obj_buf_sz == 0)
 		return ERR_PTR(-EINVAL);
@@ -4819,6 +4832,11 @@ void bpf_program__set_ifindex(struct bpf_program *prog, __u32 ifindex)
 	prog->prog_ifindex = ifindex;
 }
 
+const char *bpf_program__name(const struct bpf_program *prog)
+{
+	return prog->name;
+}
+
 const char *bpf_program__title(const struct bpf_program *prog, bool needs_copy)
 {
 	const char *title;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index fa803dde1f46..7fa583ebe56f 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -114,10 +114,10 @@ struct bpf_object_open_opts {
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
-bpf_object__open_file(const char *path, struct bpf_object_open_opts *opts);
+bpf_object__open_file(const char *path, const struct bpf_object_open_opts *opts);
 LIBBPF_API struct bpf_object *
 bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
-		     struct bpf_object_open_opts *opts);
+		     const struct bpf_object_open_opts *opts);
 
 /* deprecated bpf_object__open variants */
 LIBBPF_API struct bpf_object *
@@ -156,6 +156,7 @@ struct bpf_object_load_attr {
 LIBBPF_API int bpf_object__load(struct bpf_object *obj);
 LIBBPF_API int bpf_object__load_xattr(struct bpf_object_load_attr *attr);
 LIBBPF_API int bpf_object__unload(struct bpf_object *obj);
+
 LIBBPF_API const char *bpf_object__name(const struct bpf_object *obj);
 LIBBPF_API unsigned int bpf_object__kversion(const struct bpf_object *obj);
 
@@ -166,6 +167,9 @@ LIBBPF_API int bpf_object__btf_fd(const struct bpf_object *obj);
 LIBBPF_API struct bpf_program *
 bpf_object__find_program_by_title(const struct bpf_object *obj,
 				  const char *title);
+LIBBPF_API struct bpf_program *
+bpf_object__find_program_by_name(const struct bpf_object *obj,
+				 const char *name);
 
 LIBBPF_API struct bpf_object *bpf_object__next(struct bpf_object *prev);
 #define bpf_object__for_each_safe(pos, tmp)			\
@@ -209,6 +213,7 @@ LIBBPF_API void *bpf_program__priv(const struct bpf_program *prog);
 LIBBPF_API void bpf_program__set_ifindex(struct bpf_program *prog,
 					 __u32 ifindex);
 
+LIBBPF_API const char *bpf_program__name(const struct bpf_program *prog);
 LIBBPF_API const char *bpf_program__title(const struct bpf_program *prog,
 					  bool needs_copy);
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 757a88f64b5a..f2b2fa0f5c2a 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -211,5 +211,7 @@ LIBBPF_0.0.6 {
 
 LIBBPF_0.0.7 {
 	global:
+		bpf_object__find_program_by_name;
 		bpf_program__attach;
+		bpf_program__name;
 } LIBBPF_0.0.6;
diff --git a/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c b/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
index d90acc13d1ec..563e12120e77 100644
--- a/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
+++ b/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
@@ -16,14 +16,11 @@ struct rdonly_map_subtest {
 
 void test_rdonly_maps(void)
 {
-	const char *prog_name_skip_loop = "raw_tracepoint/sys_enter:skip_loop";
-	const char *prog_name_part_loop = "raw_tracepoint/sys_enter:part_loop";
-	const char *prog_name_full_loop = "raw_tracepoint/sys_enter:full_loop";
 	const char *file = "test_rdonly_maps.o";
 	struct rdonly_map_subtest subtests[] = {
-		{ "skip loop", prog_name_skip_loop, 0, 0 },
-		{ "part loop", prog_name_part_loop, 3, 2 + 3 + 4 },
-		{ "full loop", prog_name_full_loop, 4, 2 + 3 + 4 + 5 },
+		{ "skip loop", "skip_loop", 0, 0 },
+		{ "part loop", "part_loop", 3, 2 + 3 + 4 },
+		{ "full loop", "full_loop", 4, 2 + 3 + 4 + 5 },
 	};
 	int i, err, zero = 0, duration = 0;
 	struct bpf_link *link = NULL;
@@ -50,7 +47,7 @@ void test_rdonly_maps(void)
 		if (!test__start_subtest(t->subtest_name))
 			continue;
 
-		prog = bpf_object__find_program_by_title(obj, t->prog_name);
+		prog = bpf_object__find_program_by_name(obj, t->prog_name);
 		if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
 			  t->prog_name))
 			goto cleanup;
-- 
2.17.1

