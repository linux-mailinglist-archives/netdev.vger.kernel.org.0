Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C564711EDD9
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 23:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLMWch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 17:32:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51098 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbfLMWce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 17:32:34 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDMVqpD029796
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 14:32:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=tSa8bTY/BnZjhGWz9cweXFpD+nG1kdI4BJJpvXuc68A=;
 b=Z4Rny1DNzlwujCOpPeo13UNjTVj4rA9ey74osrrl/k7vmSBzkf0etsHLLI509Yzv9J+L
 rGVeSvbNYb/3EMr9J492rWZjOo5qsfFd/s4EI4rQTcP0E7gnUUuv9MUVi9sUT4FconUP
 6nNHI8RRs/v758Y2kb4eXMFaZ+DOGifE09c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvev5scpy-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 14:32:34 -0800
Received: from intmgw002.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 14:32:32 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 49E8D2EC1C8E; Fri, 13 Dec 2019 14:32:32 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 07/17] libbpf: expose BTF-to-C type declaration emitting API
Date:   Fri, 13 Dec 2019 14:32:04 -0800
Message-ID: <20191213223214.2791885-8-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191213223214.2791885-1-andriin@fb.com>
References: <20191213223214.2791885-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_08:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=25 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose API that allows to emit type declaration and field/variable definition
(if optional field name is specified) in valid C syntax for any provided BTF
type. This is going to be used by bpftool when emitting data section layout as
a struct. As part of making this API useful in a stand-alone fashion, move
initialization of some of the internal btf_dump state to earlier phase.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.h      | 22 ++++++++++++++
 tools/lib/bpf/btf_dump.c | 62 +++++++++++++++++++++++-----------------
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 59 insertions(+), 26 deletions(-)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index a114c8ef4f08..1f9625946ead 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -126,6 +126,28 @@ LIBBPF_API void btf_dump__free(struct btf_dump *d);
 
 LIBBPF_API int btf_dump__dump_type(struct btf_dump *d, __u32 id);
 
+struct btf_dump_emit_type_decl_opts {
+	/* size of this struct, for forward/backward compatiblity */
+	size_t sz;
+	/* optional field name for type declaration, e.g.:
+	 * - struct my_struct <FNAME>
+	 * - void (*<FNAME>)(int)
+	 * - char (*<FNAME>)[123]
+	 */
+	const char *field_name;
+	/* extra indentation level (in number of tabs) to emit for multi-line
+	 * type declarations (e.g., anonymous struct); applies for lines
+	 * starting from the second one (first line is assumed to have
+	 * necessary indentation already
+	 */
+	int indent_level;
+};
+#define btf_dump_emit_type_decl_opts__last_field attach_prog_fd
+
+LIBBPF_API void
+btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
+			 const struct btf_dump_emit_type_decl_opts *opts);
+
 /*
  * A set of helpers for easier BTF types handling
  */
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 53393026d085..b7a7a2ef785a 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -116,6 +116,8 @@ static void btf_dump_printf(const struct btf_dump *d, const char *fmt, ...)
 	va_end(args);
 }
 
+static int btf_dump_mark_referenced(struct btf_dump *d);
+
 struct btf_dump *btf_dump__new(const struct btf *btf,
 			       const struct btf_ext *btf_ext,
 			       const struct btf_dump_opts *opts,
@@ -137,18 +139,39 @@ struct btf_dump *btf_dump__new(const struct btf *btf,
 	if (IS_ERR(d->type_names)) {
 		err = PTR_ERR(d->type_names);
 		d->type_names = NULL;
-		btf_dump__free(d);
-		return ERR_PTR(err);
 	}
 	d->ident_names = hashmap__new(str_hash_fn, str_equal_fn, NULL);
 	if (IS_ERR(d->ident_names)) {
 		err = PTR_ERR(d->ident_names);
 		d->ident_names = NULL;
-		btf_dump__free(d);
-		return ERR_PTR(err);
+		goto err;
+	}
+	d->type_states = calloc(1 + btf__get_nr_types(d->btf),
+				sizeof(d->type_states[0]));
+	if (!d->type_states) {
+		err = -ENOMEM;
+		goto err;
+	}
+	d->cached_names = calloc(1 + btf__get_nr_types(d->btf),
+				 sizeof(d->cached_names[0]));
+	if (!d->cached_names) {
+		err = -ENOMEM;
+		goto err;
 	}
 
+	/* VOID is special */
+	d->type_states[0].order_state = ORDERED;
+	d->type_states[0].emit_state = EMITTED;
+
+	/* eagerly determine referenced types for anon enums */
+	err = btf_dump_mark_referenced(d);
+	if (err)
+		goto err;
+
 	return d;
+err:
+	btf_dump__free(d);
+	return ERR_PTR(err);
 }
 
 void btf_dump__free(struct btf_dump *d)
@@ -175,7 +198,6 @@ void btf_dump__free(struct btf_dump *d)
 	free(d);
 }
 
-static int btf_dump_mark_referenced(struct btf_dump *d);
 static int btf_dump_order_type(struct btf_dump *d, __u32 id, bool through_ptr);
 static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id);
 
@@ -202,27 +224,6 @@ int btf_dump__dump_type(struct btf_dump *d, __u32 id)
 	if (id > btf__get_nr_types(d->btf))
 		return -EINVAL;
 
-	/* type states are lazily allocated, as they might not be needed */
-	if (!d->type_states) {
-		d->type_states = calloc(1 + btf__get_nr_types(d->btf),
-					sizeof(d->type_states[0]));
-		if (!d->type_states)
-			return -ENOMEM;
-		d->cached_names = calloc(1 + btf__get_nr_types(d->btf),
-					 sizeof(d->cached_names[0]));
-		if (!d->cached_names)
-			return -ENOMEM;
-
-		/* VOID is special */
-		d->type_states[0].order_state = ORDERED;
-		d->type_states[0].emit_state = EMITTED;
-
-		/* eagerly determine referenced types for anon enums */
-		err = btf_dump_mark_referenced(d);
-		if (err)
-			return err;
-	}
-
 	d->emit_queue_cnt = 0;
 	err = btf_dump_order_type(d, id, false);
 	if (err < 0)
@@ -1016,6 +1017,15 @@ static int btf_dump_push_decl_stack_id(struct btf_dump *d, __u32 id)
  * of a stack frame. Some care is required to "pop" stack frames after
  * processing type declaration chain.
  */
+void btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
+			      const struct btf_dump_emit_type_decl_opts *opts)
+{
+	const char *fname = OPTS_GET(opts, field_name, NULL);
+	int lvl = OPTS_GET(opts, indent_level, 0);
+
+	btf_dump_emit_type_decl(d, id, fname, lvl);
+}
+
 static void btf_dump_emit_type_decl(struct btf_dump *d, __u32 id,
 				    const char *fname, int lvl)
 {
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index e7fcca36f186..990c7c0e2d9f 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -211,6 +211,7 @@ LIBBPF_0.0.6 {
 
 LIBBPF_0.0.7 {
 	global:
+		btf_dump__emit_type_decl;
 		bpf_program__attach;
 		btf__align_of;
 } LIBBPF_0.0.6;
-- 
2.17.1

