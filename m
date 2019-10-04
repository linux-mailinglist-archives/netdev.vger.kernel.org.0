Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 627B1CC5FB
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 00:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfJDWkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 18:40:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43622 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728812AbfJDWks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 18:40:48 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x94MdEAh024851
        for <netdev@vger.kernel.org>; Fri, 4 Oct 2019 15:40:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=QrB+Lzm1lvx9PMFJFQniZYy0gxPbnSENfL6ouvOfL4k=;
 b=cGvVidilzDBYtwqn6eL6XAaNC4+GNnNL3wYFhGsebapnCbJRZhJt45DEpmPsNSoT+D1I
 YDxaQYoD1+TxMnT6u97qh8FsGYzQZmQnbrFcCIScC6QzIHsGyObuZV+LioXN5Pp1qitT
 eT38w70DdG/vx1SwM6ZXPUG34ts4yPW5ZQM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ve79tac2r-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 15:40:46 -0700
Received: from 2401:db00:30:6012:face:0:17:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Oct 2019 15:40:45 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 6FF228617D0; Fri,  4 Oct 2019 15:40:43 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 2/4] libbpf: add bpf_object__open_{file,mem} w/ extensible opts
Date:   Fri, 4 Oct 2019 15:40:35 -0700
Message-ID: <20191004224037.1625049-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191004224037.1625049-1-andriin@fb.com>
References: <20191004224037.1625049-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-04_13:2019-10-03,2019-10-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 impostorscore=0 phishscore=0 suspectscore=8 spamscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910040191
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
OPTS_HAS, and OPTS_GET macros that hide all the NULL, size, and zero
checks.

Additionally, newly added libbpf APIs are encouraged to follow similar
pattern of having all mandatory parameters as formal function parameters
and always have optional (NULL-able) xxx_opts struct, which should
always have real struct size as a first field and the rest would be
optional parameters added over time, which tune the behavior of existing
API, if specified by user.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c          | 87 ++++++++++++++++++++++++++-------
 tools/lib/bpf/libbpf.h          | 46 +++++++++++++++--
 tools/lib/bpf/libbpf.map        |  3 ++
 tools/lib/bpf/libbpf_internal.h | 32 ++++++++++++
 4 files changed, 146 insertions(+), 22 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 024334b29b54..d471d33400ae 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -505,7 +505,8 @@ static __u32 get_kernel_version(void)
 
 static struct bpf_object *bpf_object__new(const char *path,
 					  const void *obj_buf,
-					  size_t obj_buf_sz)
+					  size_t obj_buf_sz,
+					  const char *obj_name)
 {
 	struct bpf_object *obj;
 	char *end;
@@ -517,11 +518,17 @@ static struct bpf_object *bpf_object__new(const char *path,
 	}
 
 	strcpy(obj->path, path);
-	/* Using basename() GNU version which doesn't modify arg. */
-	strncpy(obj->name, basename((void *)path), sizeof(obj->name) - 1);
-	end = strchr(obj->name, '.');
-	if (end)
-		*end = 0;
+	if (obj_name) {
+		strncpy(obj->name, obj_name, sizeof(obj->name) - 1);
+		obj->name[sizeof(obj->name) - 1] = 0;
+	} else {
+		/* Using basename() GNU version which doesn't modify arg. */
+		strncpy(obj->name, basename((void *)path),
+			sizeof(obj->name) - 1);
+		end = strchr(obj->name, '.');
+		if (end)
+			*end = 0;
+	}
 
 	obj->efile.fd = -1;
 	/*
@@ -3547,7 +3554,7 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 
 static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
-		   int flags)
+		   const char *obj_name, int flags)
 {
 	struct bpf_object *obj;
 	int err;
@@ -3557,7 +3564,7 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		return ERR_PTR(-LIBBPF_ERRNO__LIBELF);
 	}
 
-	obj = bpf_object__new(path, obj_buf, obj_buf_sz);
+	obj = bpf_object__new(path, obj_buf, obj_buf_sz, obj_name);
 	if (IS_ERR(obj))
 		return obj;
 
@@ -3583,7 +3590,7 @@ __bpf_object__open_xattr(struct bpf_object_open_attr *attr, int flags)
 
 	pr_debug("loading %s\n", attr->file);
 
-	return __bpf_object__open(attr->file, NULL, 0, flags);
+	return __bpf_object__open(attr->file, NULL, 0, NULL, flags);
 }
 
 struct bpf_object *bpf_object__open_xattr(struct bpf_object_open_attr *attr)
@@ -3601,25 +3608,67 @@ struct bpf_object *bpf_object__open(const char *path)
 	return bpf_object__open_xattr(&attr);
 }
 
-struct bpf_object *bpf_object__open_buffer(void *obj_buf,
-					   size_t obj_buf_sz,
-					   const char *name)
+struct bpf_object *
+bpf_object__open_file(const char *path, struct bpf_object_open_opts *opts)
+{
+	const char *obj_name;
+	bool relaxed_maps;
+
+	if (!OPTS_VALID(opts, bpf_object_open_opts))
+		return ERR_PTR(-EINVAL);
+	if (!path)
+		return ERR_PTR(-EINVAL);
+
+	pr_debug("loading %s\n", path);
+
+	obj_name = OPTS_GET(opts, object_name, path);
+	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
+	return __bpf_object__open(path, NULL, 0, obj_name,
+				  relaxed_maps ? MAPS_RELAX_COMPAT : 0);
+}
+
+struct bpf_object *
+bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
+		     struct bpf_object_open_opts *opts)
 {
 	char tmp_name[64];
+	const char *obj_name;
+	bool relaxed_maps;
 
-	/* param validation */
-	if (!obj_buf || obj_buf_sz <= 0)
-		return NULL;
+	if (!OPTS_VALID(opts, bpf_object_open_opts))
+		return ERR_PTR(-EINVAL);
+	if (!obj_buf || obj_buf_sz == 0)
+		return ERR_PTR(-EINVAL);
 
-	if (!name) {
+	obj_name = OPTS_GET(opts, object_name, NULL);
+	if (!obj_name) {
 		snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
 			 (unsigned long)obj_buf,
 			 (unsigned long)obj_buf_sz);
-		name = tmp_name;
+		obj_name = tmp_name;
 	}
-	pr_debug("loading object '%s' from buffer\n", name);
+	pr_debug("loading object '%s' from buffer\n", obj_name);
+
+	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
+	return __bpf_object__open(obj_name, obj_buf, obj_buf_sz, obj_name,
+				  relaxed_maps ? MAPS_RELAX_COMPAT : 0);
+}
+
+struct bpf_object *
+bpf_object__open_buffer(const void *obj_buf, size_t obj_buf_sz,
+			const char *name)
+{
+	LIBBPF_OPTS(bpf_object_open_opts, opts,
+		.object_name = name,
+		/* wrong default, but backwards-compatible */
+		.relaxed_maps = true,
+	);
+
+	/* returning NULL is wrong, but backwards-compatible */
+	if (!obj_buf || obj_buf_sz == 0)
+		return NULL;
 
-	return __bpf_object__open(name, obj_buf, obj_buf_sz, true);
+	return bpf_object__open_mem(obj_buf, obj_buf_sz, &opts);
 }
 
 int bpf_object__unload(struct bpf_object *obj)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 2905dffd70b2..667e6853e51f 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -67,12 +67,52 @@ struct bpf_object_open_attr {
 	enum bpf_prog_type prog_type;
 };
 
+/* Helper macro to declare and initialize libbpf options struct
+ *
+ * This dance with uninitialized declaration, followed by memset to zero,
+ * followed by assignment using compound literal syntax is done to preserve
+ * ability to use a nice struct field initialization syntax and **hopefully**
+ * have all the padding bytes initialized to zero. It's not guaranteed though,
+ * when copying literal, that compiler won't copy garbage in literal's padding
+ * bytes, but that's the best way I've found and it seems to work in practice.
+ */
+#define LIBBPF_OPTS(TYPE, NAME, ...)					    \
+	struct TYPE NAME;						    \
+	memset(&NAME, 0, sizeof(struct TYPE));				    \
+	NAME = (struct TYPE) {						    \
+		.sz = sizeof(struct TYPE),				    \
+		__VA_ARGS__						    \
+	}
+
+struct bpf_object_open_opts {
+	/* size of this struct, for forward/backward compatiblity */
+	size_t sz;
+	/* object name override, if provided:
+	 * - for object open from file, this will override setting object
+	 *   name from file path's base name;
+	 * - for object open from memory buffer, this will specify an object
+	 *   name and will override default "<addr>-<buf-size>" name;
+	 */
+	const char *object_name;
+	/* parse map definitions non-strictly, allowing extra attributes/data */
+	bool relaxed_maps;
+};
+#define bpf_object_open_opts__last_field relaxed_maps
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
-LIBBPF_API struct bpf_object *bpf_object__open_buffer(void *obj_buf,
-						      size_t obj_buf_sz,
-						      const char *name);
+
 int bpf_object__section_size(const struct bpf_object *obj, const char *name,
 			     __u32 *size);
 int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 8d10ca03d78d..4d241fd92dd4 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -192,4 +192,7 @@ LIBBPF_0.0.5 {
 } LIBBPF_0.0.4;
 
 LIBBPF_0.0.6 {
+	global:
+		bpf_object__open_file;
+		bpf_object__open_mem;
 } LIBBPF_0.0.5;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 2e83a34f8c79..f51444fc7eb7 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -47,6 +47,38 @@ do {				\
 #define pr_info(fmt, ...)	__pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
 #define pr_debug(fmt, ...)	__pr(LIBBPF_DEBUG, fmt, ##__VA_ARGS__)
 
+static inline bool libbpf_validate_opts(const char *opts,
+					size_t opts_sz, size_t user_sz,
+					const char *type_name)
+{
+	if (user_sz < sizeof(size_t)) {
+		pr_warning("%s size (%zu) is too small\n", type_name, user_sz);
+		return false;
+	}
+	if (user_sz > opts_sz) {
+		size_t i;
+
+		for (i = opts_sz; i < user_sz; i++) {
+			if (opts[i]) {
+				pr_warning("%s has non-zero extra bytes",
+					   type_name);
+				return false;
+			}
+		}
+	}
+	return true;
+}
+
+#define OPTS_VALID(opts, type)						      \
+	(!(opts) || libbpf_validate_opts((const char *)opts,		      \
+					 offsetofend(struct type,	      \
+						     type##__last_field),     \
+					 (opts)->sz, #type))
+#define OPTS_HAS(opts, field) \
+	((opts) && opts->sz >= offsetofend(typeof(*(opts)), field))
+#define OPTS_GET(opts, field, fallback_value) \
+	(OPTS_HAS(opts, field) ? (opts)->field : fallback_value)
+
 int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
 			 const char *str_sec, size_t str_len);
 
-- 
2.17.1

