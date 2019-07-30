Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D90357B39B
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 21:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfG3Tyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 15:54:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45204 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbfG3Tyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 15:54:43 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6UJseEN011498
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 12:54:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=n9og0f0sEIT4UxF22gsbLwB9LvqzIXBOGkEOUz9sYU0=;
 b=YJflIZiOuTicTHlrBWICya4NZrMxQeVrGUew2NRnVBd1b6E5VDSjaAq4lhfTBpX/32CI
 4tPbzd1qgyK5+HT+RH4iGQt9wCfkxP/IJ2g6AE/LMF5ZhygTK6rumq6kfHuBBYX2Vgd+
 xZQ8slfTOICCVsy5R8NlGa6h8WImLCUCbVA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2pwm1dan-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 12:54:41 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 12:54:14 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 6B9F9861655; Tue, 30 Jul 2019 12:54:13 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 01/12] libbpf: add .BTF.ext offset relocation section loading
Date:   Tue, 30 Jul 2019 12:53:57 -0700
Message-ID: <20190730195408.670063-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190730195408.670063-1-andriin@fb.com>
References: <20190730195408.670063-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300202
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for BPF CO-RE offset relocations. Add section/record
iteration macros for .BTF.ext. These macro are useful for iterating over
each .BTF.ext record, either for dumping out contents or later for BPF
CO-RE relocation handling.

To enable other parts of libbpf to work with .BTF.ext contents, moved
a bunch of type definitions into libbpf_internal.h.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c             |  69 ++++++++-------------
 tools/lib/bpf/btf.h             |   4 ++
 tools/lib/bpf/libbpf_internal.h | 105 ++++++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+), 42 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 467224feb43b..f2a3c356b388 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -42,47 +42,6 @@ struct btf {
 	int fd;
 };
 
-struct btf_ext_info {
-	/*
-	 * info points to the individual info section (e.g. func_info and
-	 * line_info) from the .BTF.ext. It does not include the __u32 rec_size.
-	 */
-	void *info;
-	__u32 rec_size;
-	__u32 len;
-};
-
-struct btf_ext {
-	union {
-		struct btf_ext_header *hdr;
-		void *data;
-	};
-	struct btf_ext_info func_info;
-	struct btf_ext_info line_info;
-	__u32 data_size;
-};
-
-struct btf_ext_info_sec {
-	__u32	sec_name_off;
-	__u32	num_info;
-	/* Followed by num_info * record_size number of bytes */
-	__u8	data[0];
-};
-
-/* The minimum bpf_func_info checked by the loader */
-struct bpf_func_info_min {
-	__u32   insn_off;
-	__u32   type_id;
-};
-
-/* The minimum bpf_line_info checked by the loader */
-struct bpf_line_info_min {
-	__u32	insn_off;
-	__u32	file_name_off;
-	__u32	line_off;
-	__u32	line_col;
-};
-
 static inline __u64 ptr_to_u64(const void *ptr)
 {
 	return (__u64) (unsigned long) ptr;
@@ -831,6 +790,9 @@ static int btf_ext_setup_info(struct btf_ext *btf_ext,
 	/* The start of the info sec (including the __u32 record_size). */
 	void *info;
 
+	if (ext_sec->len == 0)
+		return 0;
+
 	if (ext_sec->off & 0x03) {
 		pr_debug(".BTF.ext %s section is not aligned to 4 bytes\n",
 		     ext_sec->desc);
@@ -934,11 +896,24 @@ static int btf_ext_setup_line_info(struct btf_ext *btf_ext)
 	return btf_ext_setup_info(btf_ext, &param);
 }
 
+static int btf_ext_setup_offset_reloc(struct btf_ext *btf_ext)
+{
+	struct btf_ext_sec_setup_param param = {
+		.off = btf_ext->hdr->offset_reloc_off,
+		.len = btf_ext->hdr->offset_reloc_len,
+		.min_rec_size = sizeof(struct bpf_offset_reloc),
+		.ext_info = &btf_ext->offset_reloc_info,
+		.desc = "offset_reloc",
+	};
+
+	return btf_ext_setup_info(btf_ext, &param);
+}
+
 static int btf_ext_parse_hdr(__u8 *data, __u32 data_size)
 {
 	const struct btf_ext_header *hdr = (struct btf_ext_header *)data;
 
-	if (data_size < offsetof(struct btf_ext_header, func_info_off) ||
+	if (data_size < offsetofend(struct btf_ext_header, hdr_len) ||
 	    data_size < hdr->hdr_len) {
 		pr_debug("BTF.ext header not found");
 		return -EINVAL;
@@ -996,6 +971,9 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 size)
 	}
 	memcpy(btf_ext->data, data, size);
 
+	if (btf_ext->hdr->hdr_len <
+	    offsetofend(struct btf_ext_header, line_info_len))
+		goto done;
 	err = btf_ext_setup_func_info(btf_ext);
 	if (err)
 		goto done;
@@ -1004,6 +982,13 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 size)
 	if (err)
 		goto done;
 
+	if (btf_ext->hdr->hdr_len <
+	    offsetofend(struct btf_ext_header, offset_reloc_len))
+		goto done;
+	err = btf_ext_setup_offset_reloc(btf_ext);
+	if (err)
+		goto done;
+
 done:
 	if (err) {
 		btf_ext__free(btf_ext);
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 88a52ae56fc6..287361ee1f6b 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -57,6 +57,10 @@ struct btf_ext_header {
 	__u32	func_info_len;
 	__u32	line_info_off;
 	__u32	line_info_len;
+
+	/* optional part of .BTF.ext header */
+	__u32	offset_reloc_off;
+	__u32	offset_reloc_len;
 };
 
 LIBBPF_API void btf__free(struct btf *btf);
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 2ac29bd36226..2e83a34f8c79 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -29,6 +29,10 @@
 #ifndef max
 # define max(x, y) ((x) < (y) ? (y) : (x))
 #endif
+#ifndef offsetofend
+# define offsetofend(TYPE, FIELD) \
+	(offsetof(TYPE, FIELD) + sizeof(((TYPE *)0)->FIELD))
+#endif
 
 extern void libbpf_print(enum libbpf_print_level level,
 			 const char *format, ...)
@@ -46,4 +50,105 @@ do {				\
 int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
 			 const char *str_sec, size_t str_len);
 
+struct btf_ext_info {
+	/*
+	 * info points to the individual info section (e.g. func_info and
+	 * line_info) from the .BTF.ext. It does not include the __u32 rec_size.
+	 */
+	void *info;
+	__u32 rec_size;
+	__u32 len;
+};
+
+#define for_each_btf_ext_sec(seg, sec)					\
+	for (sec = (seg)->info;						\
+	     (void *)sec < (seg)->info + (seg)->len;			\
+	     sec = (void *)sec + sizeof(struct btf_ext_info_sec) +	\
+		   (seg)->rec_size * sec->num_info)
+
+#define for_each_btf_ext_rec(seg, sec, i, rec)				\
+	for (i = 0, rec = (void *)&(sec)->data;				\
+	     i < (sec)->num_info;					\
+	     i++, rec = (void *)rec + (seg)->rec_size)
+
+struct btf_ext {
+	union {
+		struct btf_ext_header *hdr;
+		void *data;
+	};
+	struct btf_ext_info func_info;
+	struct btf_ext_info line_info;
+	struct btf_ext_info offset_reloc_info;
+	__u32 data_size;
+};
+
+struct btf_ext_info_sec {
+	__u32	sec_name_off;
+	__u32	num_info;
+	/* Followed by num_info * record_size number of bytes */
+	__u8	data[0];
+};
+
+/* The minimum bpf_func_info checked by the loader */
+struct bpf_func_info_min {
+	__u32   insn_off;
+	__u32   type_id;
+};
+
+/* The minimum bpf_line_info checked by the loader */
+struct bpf_line_info_min {
+	__u32	insn_off;
+	__u32	file_name_off;
+	__u32	line_off;
+	__u32	line_col;
+};
+
+/* The minimum bpf_offset_reloc checked by the loader
+ *
+ * Offset relocation captures the following data:
+ * - insn_off - instruction offset (in bytes) within a BPF program that needs
+ *   its insn->imm field to be relocated with actual offset;
+ * - type_id - BTF type ID of the "root" (containing) entity of a relocatable
+ *   offset;
+ * - access_str_off - offset into corresponding .BTF string section. String
+ *   itself encodes an accessed field using a sequence of field and array
+ *   indicies, separated by colon (:). It's conceptually very close to LLVM's
+ *   getelementptr ([0]) instruction's arguments for identifying offset to 
+ *   a field.
+ *
+ * Example to provide a better feel.
+ *
+ *   struct sample {
+ *       int a;
+ *       struct {
+ *           int b[10];
+ *       };
+ *   };
+ *
+ *   struct sample *s = ...;
+ *   int x = &s->a;     // encoded as "0:0" (a is field #0)
+ *   int y = &s->b[5];  // encoded as "0:1:0:5" (anon struct is field #1, 
+ *                      // b is field #0 inside anon struct, accessing elem #5)
+ *   int z = &s[10]->b; // encoded as "10:1" (ptr is used as an array)
+ *
+ * type_id for all relocs in this example  will capture BTF type id of
+ * `struct sample`.
+ *
+ * Such relocation is emitted when using __builtin_preserve_access_index()
+ * Clang built-in, passing expression that captures field address, e.g.:
+ *
+ * bpf_probe_read(&dst, sizeof(dst),
+ *		  __builtin_preserve_access_index(&src->a.b.c));
+ *
+ * In this case Clang will emit offset relocation recording necessary data to
+ * be able to find offset of embedded `a.b.c` field within `src` struct.
+ *
+ *   [0] https://llvm.org/docs/LangRef.html#getelementptr-instruction
+ */
+struct bpf_offset_reloc {
+	__u32   insn_off;
+	__u32   type_id;
+	__u32   access_str_off;
+};
+
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
-- 
2.17.1

