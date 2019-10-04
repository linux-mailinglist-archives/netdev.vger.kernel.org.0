Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E721CCB430
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 07:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388122AbfJDFcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 01:32:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21878 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726525AbfJDFcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 01:32:47 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x945UCsO006361
        for <netdev@vger.kernel.org>; Thu, 3 Oct 2019 22:32:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=swMHPyshYmOUbRdtaYJZMc39y4OkayYkTiSj2mZ1AHk=;
 b=OKsByp2rRTuk6ghD3CWrp0r8uVnWopuFVoEg7lFpS1nfK8rB/CVLaYqvgXx2I9hsvfKf
 QbQl6R1+9YLm6H2g85YmPIT0vzk/LeV2+nWuHiaMjn/VjZOCx/hHAYCRXZXrH4IMxlbZ
 6N9TVGnVsc8td/TD6w1lIAi9/ZBEJUGAYk0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vdmh9au7r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 22:32:46 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 3 Oct 2019 22:32:45 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 15E26861885; Thu,  3 Oct 2019 22:32:43 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 2/3] libbpf: add bpf_object__open_{file,mem} w/ extensible opts
Date:   Thu, 3 Oct 2019 22:32:34 -0700
Message-ID: <20191004053235.2710592-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191004053235.2710592-1-andriin@fb.com>
References: <20191004053235.2710592-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-04_03:2019-10-03,2019-10-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 adultscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910040048
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
 tools/lib/bpf/libbpf.c          | 51 ++++++++++++++++++++++++++++-----
 tools/lib/bpf/libbpf.h          | 36 +++++++++++++++++++++--
 tools/lib/bpf/libbpf.map        |  3 ++
 tools/lib/bpf/libbpf_internal.h | 32 +++++++++++++++++++++
 4 files changed, 112 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 056769ce4fd0..503fba903e99 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3620,16 +3620,33 @@ struct bpf_object *bpf_object__open(const char *path)
 	return bpf_object__open_xattr(&attr);
 }
 
-struct bpf_object *bpf_object__open_buffer(void *obj_buf,
-					   size_t obj_buf_sz,
-					   const char *name)
+struct bpf_object *
+bpf_object__open_file(const char *path, struct bpf_object_open_opts *opts)
+{
+	if (!OPTS_VALID(opts, bpf_object_open_opts))
+		return ERR_PTR(-EINVAL);
+	if (!path)
+		return ERR_PTR(-EINVAL);
+
+	pr_debug("loading %s\n", path);
+
+	return __bpf_object__open(path, NULL, 0, 0);
+}
+
+struct bpf_object *
+bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
+		     struct bpf_object_open_opts *opts)
 {
 	char tmp_name[64];
+	const char *name;
+	bool relaxed_maps;
 
-	/* param validation */
-	if (!obj_buf || obj_buf_sz <= 0)
-		return NULL;
+	if (!OPTS_VALID(opts, bpf_object_open_opts))
+		return ERR_PTR(-EINVAL);
+	if (!obj_buf || obj_buf_sz == 0)
+		return ERR_PTR(-EINVAL);
 
+	name = OPTS_GET(opts, object_name, NULL);
 	if (!name) {
 		snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
 			 (unsigned long)obj_buf,
@@ -3638,7 +3655,27 @@ struct bpf_object *bpf_object__open_buffer(void *obj_buf,
 	}
 	pr_debug("loading object '%s' from buffer\n", name);
 
-	return __bpf_object__open(name, obj_buf, obj_buf_sz, true);
+	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
+
+	return __bpf_object__open(name, obj_buf, obj_buf_sz,
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
+
+	return bpf_object__open_mem(obj_buf, obj_buf_sz, &opts);
 }
 
 int bpf_object__unload(struct bpf_object *obj)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 2905dffd70b2..3c0b76537339 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -67,12 +67,42 @@ struct bpf_object_open_attr {
 	enum bpf_prog_type prog_type;
 };
 
+/* Helper macro to declare and initialize libbpf options struct */
+#define LIBBPF_OPTS(TYPE, NAME, ...)					    \
+	struct TYPE NAME = {						    \
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

