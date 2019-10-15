Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE311D7F01
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 20:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbfJOS25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 14:28:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14206 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727826AbfJOS24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 14:28:56 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9FISANP030971
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 11:28:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=AH3Z0w271wAHfmkaAPEaZmherZtxPlxXbU+2Uzuqjc8=;
 b=kDz0Tr0jLaqTu5+swJsqjBgE6+MeDp61ZRHsP/n9i34RrJrhqRdBxy3ksNWh2ag3aPzH
 vHnb1wEOGc85yqOJZB9LRbJ/trjxbF2Iir7g3MHTU3UemJQjbIWM57P3tE/DN/b3w5q2
 ZCVJ0Gt7kH+HBx0zGQR4+F/YMrIkF7UYHGs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vna13trbu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 11:28:55 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 11:28:54 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 5ECC5861983; Tue, 15 Oct 2019 11:28:52 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 1/5] libbpf: update BTF reloc support to latest Clang format
Date:   Tue, 15 Oct 2019 11:28:45 -0700
Message-ID: <20191015182849.3922287-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191015182849.3922287-1-andriin@fb.com>
References: <20191015182849.3922287-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-15_06:2019-10-15,2019-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=2 clxscore=1015 impostorscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910150157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTF offset reloc was generalized in recent Clang into field relocation,
capturing extra u32 field, specifying what aspect of captured field
needs to be relocated. This changes .BTF.ext's record size for this
relocation from 12 bytes to 16 bytes. Given these format changes
happened in Clang before official released version, it's ok to not
support outdated 12-byte record size w/o breaking ABI.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c             | 16 ++++++++--------
 tools/lib/bpf/btf.h             |  4 ++--
 tools/lib/bpf/libbpf.c          | 24 ++++++++++++------------
 tools/lib/bpf/libbpf_internal.h | 25 ++++++++++++++++++-------
 4 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 1aa189a9112a..3eae8d1addfa 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -888,14 +888,14 @@ static int btf_ext_setup_line_info(struct btf_ext *btf_ext)
 	return btf_ext_setup_info(btf_ext, &param);
 }
 
-static int btf_ext_setup_offset_reloc(struct btf_ext *btf_ext)
+static int btf_ext_setup_field_reloc(struct btf_ext *btf_ext)
 {
 	struct btf_ext_sec_setup_param param = {
-		.off = btf_ext->hdr->offset_reloc_off,
-		.len = btf_ext->hdr->offset_reloc_len,
-		.min_rec_size = sizeof(struct bpf_offset_reloc),
-		.ext_info = &btf_ext->offset_reloc_info,
-		.desc = "offset_reloc",
+		.off = btf_ext->hdr->field_reloc_off,
+		.len = btf_ext->hdr->field_reloc_len,
+		.min_rec_size = sizeof(struct bpf_field_reloc),
+		.ext_info = &btf_ext->field_reloc_info,
+		.desc = "field_reloc",
 	};
 
 	return btf_ext_setup_info(btf_ext, &param);
@@ -975,9 +975,9 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 size)
 		goto done;
 
 	if (btf_ext->hdr->hdr_len <
-	    offsetofend(struct btf_ext_header, offset_reloc_len))
+	    offsetofend(struct btf_ext_header, field_reloc_len))
 		goto done;
-	err = btf_ext_setup_offset_reloc(btf_ext);
+	err = btf_ext_setup_field_reloc(btf_ext);
 	if (err)
 		goto done;
 
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 9cb44b4fbf60..b18994116a44 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -60,8 +60,8 @@ struct btf_ext_header {
 	__u32	line_info_len;
 
 	/* optional part of .BTF.ext header */
-	__u32	offset_reloc_off;
-	__u32	offset_reloc_len;
+	__u32	field_reloc_off;
+	__u32	field_reloc_len;
 };
 
 LIBBPF_API void btf__free(struct btf *btf);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a02cdedc4e3f..d6c7699de405 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2326,7 +2326,7 @@ static bool str_is_empty(const char *s)
 }
 
 /*
- * Turn bpf_offset_reloc into a low- and high-level spec representation,
+ * Turn bpf_field_reloc into a low- and high-level spec representation,
  * validating correctness along the way, as well as calculating resulting
  * field offset (in bytes), specified by accessor string. Low-level spec
  * captures every single level of nestedness, including traversing anonymous
@@ -2977,7 +2977,7 @@ static void *u32_as_hash_key(__u32 x)
  *    types should be compatible (see bpf_core_fields_are_compat for details).
  * 3. It is supported and expected that there might be multiple flavors
  *    matching the spec. As long as all the specs resolve to the same set of
- *    offsets across all candidates, there is not error. If there is any
+ *    offsets across all candidates, there is no error. If there is any
  *    ambiguity, CO-RE relocation will fail. This is necessary to accomodate
  *    imprefection of BTF deduplication, which can cause slight duplication of
  *    the same BTF type, if some directly or indirectly referenced (by
@@ -2992,12 +2992,12 @@ static void *u32_as_hash_key(__u32 x)
  *    CPU-wise compared to prebuilding a map from all local type names to
  *    a list of candidate type names. It's also sped up by caching resolved
  *    list of matching candidates per each local "root" type ID, that has at
- *    least one bpf_offset_reloc associated with it. This list is shared
+ *    least one bpf_field_reloc associated with it. This list is shared
  *    between multiple relocations for the same type ID and is updated as some
  *    of the candidates are pruned due to structural incompatibility.
  */
-static int bpf_core_reloc_offset(struct bpf_program *prog,
-				 const struct bpf_offset_reloc *relo,
+static int bpf_core_reloc_field(struct bpf_program *prog,
+				 const struct bpf_field_reloc *relo,
 				 int relo_idx,
 				 const struct btf *local_btf,
 				 const struct btf *targ_btf,
@@ -3106,10 +3106,10 @@ static int bpf_core_reloc_offset(struct bpf_program *prog,
 }
 
 static int
-bpf_core_reloc_offsets(struct bpf_object *obj, const char *targ_btf_path)
+bpf_core_reloc_fields(struct bpf_object *obj, const char *targ_btf_path)
 {
 	const struct btf_ext_info_sec *sec;
-	const struct bpf_offset_reloc *rec;
+	const struct bpf_field_reloc *rec;
 	const struct btf_ext_info *seg;
 	struct hashmap_entry *entry;
 	struct hashmap *cand_cache = NULL;
@@ -3134,7 +3134,7 @@ bpf_core_reloc_offsets(struct bpf_object *obj, const char *targ_btf_path)
 		goto out;
 	}
 
-	seg = &obj->btf_ext->offset_reloc_info;
+	seg = &obj->btf_ext->field_reloc_info;
 	for_each_btf_ext_sec(seg, sec) {
 		sec_name = btf__name_by_offset(obj->btf, sec->sec_name_off);
 		if (str_is_empty(sec_name)) {
@@ -3153,8 +3153,8 @@ bpf_core_reloc_offsets(struct bpf_object *obj, const char *targ_btf_path)
 			 sec_name, sec->num_info);
 
 		for_each_btf_ext_rec(seg, sec, i, rec) {
-			err = bpf_core_reloc_offset(prog, rec, i, obj->btf,
-						    targ_btf, cand_cache);
+			err = bpf_core_reloc_field(prog, rec, i, obj->btf,
+						   targ_btf, cand_cache);
 			if (err) {
 				pr_warning("prog '%s': relo #%d: failed to relocate: %d\n",
 					   sec_name, i, err);
@@ -3179,8 +3179,8 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 {
 	int err = 0;
 
-	if (obj->btf_ext->offset_reloc_info.len)
-		err = bpf_core_reloc_offsets(obj, targ_btf_path);
+	if (obj->btf_ext->field_reloc_info.len)
+		err = bpf_core_reloc_fields(obj, targ_btf_path);
 
 	return err;
 }
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index f51444fc7eb7..5bfe85d4f8aa 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -110,7 +110,7 @@ struct btf_ext {
 	};
 	struct btf_ext_info func_info;
 	struct btf_ext_info line_info;
-	struct btf_ext_info offset_reloc_info;
+	struct btf_ext_info field_reloc_info;
 	__u32 data_size;
 };
 
@@ -135,13 +135,23 @@ struct bpf_line_info_min {
 	__u32	line_col;
 };
 
-/* The minimum bpf_offset_reloc checked by the loader
+/* bpf_field_info_kind encodes which aspect of captured field has to be
+ * adjusted by relocations. Currently supported values are:
+ *   - BPF_FIELD_BYTE_OFFSET: field offset (in bytes);
+ *   - BPF_FIELD_EXISTS: field existence (1, if field exists; 0, otherwise);
+ */
+enum bpf_field_info_kind {
+	BPF_FIELD_BYTE_OFFSET = 0,	/* field byte offset */
+	BPF_FIELD_EXISTS = 2,		/* field existence in target kernel */
+};
+
+/* The minimum bpf_field_reloc checked by the loader
  *
- * Offset relocation captures the following data:
+ * Field relocation captures the following data:
  * - insn_off - instruction offset (in bytes) within a BPF program that needs
- *   its insn->imm field to be relocated with actual offset;
+ *   its insn->imm field to be relocated with actual field info;
  * - type_id - BTF type ID of the "root" (containing) entity of a relocatable
- *   offset;
+ *   field;
  * - access_str_off - offset into corresponding .BTF string section. String
  *   itself encodes an accessed field using a sequence of field and array
  *   indicies, separated by colon (:). It's conceptually very close to LLVM's
@@ -172,15 +182,16 @@ struct bpf_line_info_min {
  * bpf_probe_read(&dst, sizeof(dst),
  *		  __builtin_preserve_access_index(&src->a.b.c));
  *
- * In this case Clang will emit offset relocation recording necessary data to
+ * In this case Clang will emit field relocation recording necessary data to
  * be able to find offset of embedded `a.b.c` field within `src` struct.
  *
  *   [0] https://llvm.org/docs/LangRef.html#getelementptr-instruction
  */
-struct bpf_offset_reloc {
+struct bpf_field_reloc {
 	__u32   insn_off;
 	__u32   type_id;
 	__u32   access_str_off;
+	enum bpf_field_info_kind kind;
 };
 
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
-- 
2.17.1

