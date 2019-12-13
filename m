Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA1C11EDD8
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 23:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfLMWch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 17:32:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5556 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726813AbfLMWcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 17:32:32 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDMTu4j025292
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 14:32:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=cQgeeXbyiIZkT4g3VYta4xZNV49Al/mlcbRJ21wjcOA=;
 b=qmYvunzNW+mwt+MKLVactWKBSPfaubXT1d0oeW3TSmHyFqAjR1LTz2XgX966Ttd0PjlU
 2F1u84XLAfz7DKl2365+b5Z93/PfbMyKmdkKDksDnDTJ222oR8dfrimZgbcGwYIsY0li
 I/vSI0HqWJqfaLboEySeUjTdc4BJP3O5xJw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvd4v9vs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 14:32:31 -0800
Received: from intmgw002.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 14:32:30 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 176452EC1C8E; Fri, 13 Dec 2019 14:32:30 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 06/17] libbpf: expose btf__align_of() API
Date:   Fri, 13 Dec 2019 14:32:03 -0800
Message-ID: <20191213223214.2791885-7-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191213223214.2791885-1-andriin@fb.com>
References: <20191213223214.2791885-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_08:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=743
 suspectscore=8 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose BTF API that calculates type alignment requirements.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c      | 39 +++++++++++++++++++++++++++++++++
 tools/lib/bpf/btf.h      |  1 +
 tools/lib/bpf/btf_dump.c | 47 +++++-----------------------------------
 tools/lib/bpf/libbpf.map |  1 +
 4 files changed, 47 insertions(+), 41 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 88efa2bb7137..84fe82f27bef 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -278,6 +278,45 @@ __s64 btf__resolve_size(const struct btf *btf, __u32 type_id)
 	return nelems * size;
 }
 
+int btf__align_of(const struct btf *btf, __u32 id)
+{
+	const struct btf_type *t = btf__type_by_id(btf, id);
+	__u16 kind = btf_kind(t);
+
+	switch (kind) {
+	case BTF_KIND_INT:
+	case BTF_KIND_ENUM:
+		return min(sizeof(void *), t->size);
+	case BTF_KIND_PTR:
+		return sizeof(void *);
+	case BTF_KIND_TYPEDEF:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_CONST:
+	case BTF_KIND_RESTRICT:
+		return btf__align_of(btf, t->type);
+	case BTF_KIND_ARRAY:
+		return btf__align_of(btf, btf_array(t)->type);
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION: {
+		const struct btf_member *m = btf_members(t);
+		__u16 vlen = btf_vlen(t);
+		int i, align = 1, t;
+
+		for (i = 0; i < vlen; i++, m++) {
+			t = btf__align_of(btf, m->type);
+			if (t <= 0)
+				return t;
+			align = max(align, t);
+		}
+
+		return align;
+	}
+	default:
+		pr_warn("unsupported BTF_KIND:%u\n", btf_kind(t));
+		return 0;
+	}
+}
+
 int btf__resolve_type(const struct btf *btf, __u32 type_id)
 {
 	const struct btf_type *t;
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 5fc23b988deb..a114c8ef4f08 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -77,6 +77,7 @@ LIBBPF_API const struct btf_type *btf__type_by_id(const struct btf *btf,
 						  __u32 id);
 LIBBPF_API __s64 btf__resolve_size(const struct btf *btf, __u32 type_id);
 LIBBPF_API int btf__resolve_type(const struct btf *btf, __u32 type_id);
+LIBBPF_API int btf__align_of(const struct btf *btf, __u32 id);
 LIBBPF_API int btf__fd(const struct btf *btf);
 LIBBPF_API const void *btf__get_raw_data(const struct btf *btf, __u32 *size);
 LIBBPF_API const char *btf__name_by_offset(const struct btf *btf, __u32 offset);
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index cb126d8fcf75..53393026d085 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -752,41 +752,6 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
 	}
 }
 
-static int btf_align_of(const struct btf *btf, __u32 id)
-{
-	const struct btf_type *t = btf__type_by_id(btf, id);
-	__u16 kind = btf_kind(t);
-
-	switch (kind) {
-	case BTF_KIND_INT:
-	case BTF_KIND_ENUM:
-		return min(sizeof(void *), t->size);
-	case BTF_KIND_PTR:
-		return sizeof(void *);
-	case BTF_KIND_TYPEDEF:
-	case BTF_KIND_VOLATILE:
-	case BTF_KIND_CONST:
-	case BTF_KIND_RESTRICT:
-		return btf_align_of(btf, t->type);
-	case BTF_KIND_ARRAY:
-		return btf_align_of(btf, btf_array(t)->type);
-	case BTF_KIND_STRUCT:
-	case BTF_KIND_UNION: {
-		const struct btf_member *m = btf_members(t);
-		__u16 vlen = btf_vlen(t);
-		int i, align = 1;
-
-		for (i = 0; i < vlen; i++, m++)
-			align = max(align, btf_align_of(btf, m->type));
-
-		return align;
-	}
-	default:
-		pr_warn("unsupported BTF_KIND:%u\n", btf_kind(t));
-		return 1;
-	}
-}
-
 static bool btf_is_struct_packed(const struct btf *btf, __u32 id,
 				 const struct btf_type *t)
 {
@@ -794,18 +759,18 @@ static bool btf_is_struct_packed(const struct btf *btf, __u32 id,
 	int align, i, bit_sz;
 	__u16 vlen;
 
-	align = btf_align_of(btf, id);
+	align = btf__align_of(btf, id);
 	/* size of a non-packed struct has to be a multiple of its alignment*/
-	if (t->size % align)
+	if (align && t->size % align)
 		return true;
 
 	m = btf_members(t);
 	vlen = btf_vlen(t);
 	/* all non-bitfield fields have to be naturally aligned */
 	for (i = 0; i < vlen; i++, m++) {
-		align = btf_align_of(btf, m->type);
+		align = btf__align_of(btf, m->type);
 		bit_sz = btf_member_bitfield_size(t, i);
-		if (bit_sz == 0 && m->offset % (8 * align) != 0)
+		if (align && bit_sz == 0 && m->offset % (8 * align) != 0)
 			return true;
 	}
 
@@ -889,7 +854,7 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 		fname = btf_name_of(d, m->name_off);
 		m_sz = btf_member_bitfield_size(t, i);
 		m_off = btf_member_bit_offset(t, i);
-		align = packed ? 1 : btf_align_of(d->btf, m->type);
+		align = packed ? 1 : btf__align_of(d->btf, m->type);
 
 		btf_dump_emit_bit_padding(d, off, m_off, m_sz, align, lvl + 1);
 		btf_dump_printf(d, "\n%s", pfx(lvl + 1));
@@ -907,7 +872,7 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 
 	/* pad at the end, if necessary */
 	if (is_struct) {
-		align = packed ? 1 : btf_align_of(d->btf, id);
+		align = packed ? 1 : btf__align_of(d->btf, id);
 		btf_dump_emit_bit_padding(d, off, t->size * 8, 0, align,
 					  lvl + 1);
 	}
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 757a88f64b5a..e7fcca36f186 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -212,4 +212,5 @@ LIBBPF_0.0.6 {
 LIBBPF_0.0.7 {
 	global:
 		bpf_program__attach;
+		btf__align_of;
 } LIBBPF_0.0.6;
-- 
2.17.1

