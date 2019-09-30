Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5262CC2558
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732349AbfI3QnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:43:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28194 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727767AbfI3QnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:43:12 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8UGdu5p006243
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 09:43:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=Jam5MSBMV0iKo02Z+Pai+DC4qAEz8qkJ5uU7TaJzPg4=;
 b=nL/3T2yvFBu9J/PktkIkItwF/34paKAJwge5pAg8HswP3yFyzZfhT3Dqjlt39vo1hC4v
 bn5iz6XUy6gJ5nv/aeiJpEwcNb21srM1bxWIGhqyFjuKHVmSd7Z2I9ZN+rCvgPQQVq+O
 KBqqBF4xLgkNxDiV0Ap3QGx4X7XlC/MUBcQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vaq9pea9m-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 09:43:11 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 30 Sep 2019 09:42:56 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id AAAF1861847; Mon, 30 Sep 2019 09:42:55 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <toke@redhat.com>, <kpsingh@chromium.org>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [RFC][PATCH bpf-next] libbpf: add bpf_object__open_{file,mem} w/ sized opts
Date:   Mon, 30 Sep 2019 09:42:39 -0700
Message-ID: <20190930164239.3697916-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_10:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=8 spamscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909300160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new set of bpf_object__open APIs using new approach to optional
parameters extensibility allowing simpler ABI compatibility approach.

This patch demonstrates an approach to implementing libbpf APIs that
makes it easy to extend existing APIs with extra optional parameters in
such a way, that ABI compatibility is preserved without having to do
symbol versioning and generating lots of boilerplate code to handle it.
To facilitate succinct code for working with options, add OPTS_VALID,
OPTS_HAS, and OPTS_GET macros that hide all the NULL and size checks.

Additionally, newly added libbpf APIs are encouraged to follow similar
pattern of having all mandatory parameters as formal function parameters
and always have optional (NULL-able) xxx_opts struct, which should
always have real struct size as a first field and the rest would be
optional parameters added over time, which tune the behavior of existing
API, if specified by user.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c          | 56 ++++++++++++++++++++++++++-------
 tools/lib/bpf/libbpf.h          | 33 ++++++++++++++++---
 tools/lib/bpf/libbpf.map        |  6 ++++
 tools/lib/bpf/libbpf_internal.h |  6 ++++
 4 files changed, 85 insertions(+), 16 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e0276520171b..bb8f4a6e4e6b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -255,7 +255,7 @@ struct bpf_object {
 	 */
 	struct {
 		int fd;
-		void *obj_buf;
+		const void *obj_buf;
 		size_t obj_buf_sz;
 		Elf *elf;
 		GElf_Ehdr ehdr;
@@ -492,7 +492,7 @@ bpf_object__init_prog_names(struct bpf_object *obj)
 }
 
 static struct bpf_object *bpf_object__new(const char *path,
-					  void *obj_buf,
+					  const void *obj_buf,
 					  size_t obj_buf_sz)
 {
 	struct bpf_object *obj;
@@ -569,7 +569,7 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 		 * obj_buf should have been validated by
 		 * bpf_object__open_buffer().
 		 */
-		obj->efile.elf = elf_memory(obj->efile.obj_buf,
+		obj->efile.elf = elf_memory((char *)obj->efile.obj_buf,
 					    obj->efile.obj_buf_sz);
 	} else {
 		obj->efile.fd = open(obj->path, O_RDONLY);
@@ -3597,7 +3597,7 @@ static int bpf_object__validate(struct bpf_object *obj, bool needs_kver)
 }
 
 static struct bpf_object *
-__bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
+__bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   bool needs_kver, int flags)
 {
 	struct bpf_object *obj;
@@ -3655,25 +3655,59 @@ struct bpf_object *bpf_object__open(const char *path)
 	return bpf_object__open_xattr(&attr);
 }
 
-struct bpf_object *bpf_object__open_buffer(void *obj_buf,
-					   size_t obj_buf_sz,
-					   const char *name)
+struct bpf_object *
+bpf_object__open_file(const char *path, struct bpf_object_open_opts *opts)
+{
+	if (!OPTS_VALID(opts) || !path)
+		return ERR_PTR(-EINVAL);
+
+	pr_debug("loading %s\n", path);
+
+	return __bpf_object__open(path, NULL, 0, false, 0);
+}
+
+static struct bpf_object *
+__bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
+		       struct bpf_object_open_opts *opts, bool enforce_kver)
 {
 	char tmp_name[64];
+	const char *name;
 
-	/* param validation */
-	if (!obj_buf || obj_buf_sz <= 0)
-		return NULL;
+	if (!OPTS_VALID(opts) || !obj_buf || obj_buf_sz == 0)
+		return ERR_PTR(-EINVAL);
 
+	name = OPTS_GET(opts, object_name, NULL);
 	if (!name) {
 		snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
 			 (unsigned long)obj_buf,
 			 (unsigned long)obj_buf_sz);
 		name = tmp_name;
 	}
+
 	pr_debug("loading object '%s' from buffer\n", name);
 
-	return __bpf_object__open(name, obj_buf, obj_buf_sz, true, true);
+	return __bpf_object__open(name, obj_buf, obj_buf_sz, enforce_kver, 0);
+}
+
+struct bpf_object *
+bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
+		     struct bpf_object_open_opts *opts)
+{
+	return __bpf_object__open_mem(obj_buf, obj_buf_sz, opts, false);
+}
+
+struct bpf_object *
+bpf_object__open_buffer(const void *obj_buf, size_t obj_buf_sz, const char *name)
+{
+	struct bpf_object_open_opts opts = {
+		.sz = sizeof(struct bpf_object_open_opts),
+		.object_name = name,
+	};
+
+	if (!obj_buf || obj_buf_sz == 0)
+		return NULL;
+
+	return __bpf_object__open_mem(obj_buf, obj_buf_sz, &opts, true);
 }
 
 int bpf_object__unload(struct bpf_object *obj)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index e8f70977d137..987db195c5a0 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -67,14 +67,37 @@ struct bpf_object_open_attr {
 	enum bpf_prog_type prog_type;
 };
 
+struct bpf_object_open_opts {
+	/* size of this struct, for forward and backward compatiblity */
+	size_t sz;
+	/* object name override, if provided:
+	 * - for object open from file, this will override setting object
+	 *   name from file path's base name;
+	 * - for object open from memory buffer, this will specify an object
+	 *   name and will override default "<addr>-<buf-size>" name;
+	 */
+	const char *object_name;
+	/* program type to use if determination based on program name doesn't
+	 * work */
+	enum bpf_prog_type fallback_prog_type;
+};
+
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
+bpf_object__open_file(const char *path, struct bpf_object_open_opts *opts);
+LIBBPF_API struct bpf_object *
+bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
+		     struct bpf_object_open_opts *opts);
+
+/* deprecated bpf_object__open variants */
+LIBBPF_API struct bpf_object *
+bpf_object__open_buffer(const void *obj_buf, size_t obj_buf_sz,
+			const char *name);
+LIBBPF_API struct bpf_object *
 bpf_object__open_xattr(struct bpf_object_open_attr *attr);
-struct bpf_object *__bpf_object__open_xattr(struct bpf_object_open_attr *attr,
-					    int flags);
-LIBBPF_API struct bpf_object *bpf_object__open_buffer(void *obj_buf,
-						      size_t obj_buf_sz,
-						      const char *name);
+struct bpf_object *
+__bpf_object__open_xattr(struct bpf_object_open_attr *attr, int flags);
+
 int bpf_object__section_size(const struct bpf_object *obj, const char *name,
 			     __u32 *size);
 int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index d04c7cb623ed..4d241fd92dd4 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -190,3 +190,9 @@ LIBBPF_0.0.5 {
 	global:
 		bpf_btf_get_next_id;
 } LIBBPF_0.0.4;
+
+LIBBPF_0.0.6 {
+	global:
+		bpf_object__open_file;
+		bpf_object__open_mem;
+} LIBBPF_0.0.5;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 2e83a34f8c79..1cf2cf8d80f3 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -47,6 +47,12 @@ do {				\
 #define pr_info(fmt, ...)	__pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
 #define pr_debug(fmt, ...)	__pr(LIBBPF_DEBUG, fmt, ##__VA_ARGS__)
 
+#define OPTS_VALID(opts) (!(opts) || (opts)->sz >= sizeof((opts)->sz))
+#define OPTS_HAS(opts, field) \
+	((opts) && opts->sz >= offsetofend(typeof(*(opts)), field))
+#define OPTS_GET(opts, field, fallback_value) \
+	(OPTS_HAS(opts, field) ? (opts)->field : fallback_value)
+
 int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
 			 const char *str_sec, size_t str_len);
 
-- 
2.17.1

