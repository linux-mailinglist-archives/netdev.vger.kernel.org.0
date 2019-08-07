Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCA5843BB
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 07:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfHGFiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 01:38:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16656 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725972AbfHGFiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 01:38:15 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x775c5md003972
        for <netdev@vger.kernel.org>; Tue, 6 Aug 2019 22:38:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=wzvdywExQXfhOuipF+mU2x3qqZUEr2ujpdiTapcoce0=;
 b=dI3cQkfzK2p1vfZ9KcuHmmLWYn5E/ypYnuNscsS43JQCASnszTZrA0cP4JBOStpTBIxH
 B9O857vrfRzBy1yVJ1BwFIwMn64S9TC+h+4KN9lqG2YeDPtczyirucnsSIGV1nIRgTfO
 bLuns0sBsV+V4SDevWvNcxwpjTBsNLUnDcA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2u7jemgywt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 22:38:14 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 6 Aug 2019 22:38:13 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 210DF861698; Tue,  6 Aug 2019 22:38:12 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 01/14] libbpf: add helpers for working with BTF types
Date:   Tue, 6 Aug 2019 22:37:53 -0700
Message-ID: <20190807053806.1534571-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190807053806.1534571-1-andriin@fb.com>
References: <20190807053806.1534571-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=25 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070060
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add lots of frequently used helpers that simplify working with BTF
types.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.h | 176 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 176 insertions(+)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 88a52ae56fc6..63c939b71efe 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -5,6 +5,7 @@
 #define __LIBBPF_BTF_H
 
 #include <stdarg.h>
+#include <linux/btf.h>
 #include <linux/types.h>
 
 #ifdef __cplusplus
@@ -120,6 +121,181 @@ LIBBPF_API void btf_dump__free(struct btf_dump *d);
 
 LIBBPF_API int btf_dump__dump_type(struct btf_dump *d, __u32 id);
 
+/*
+ * A set of helpers for easier BTF types handling
+ */
+static inline __u16 btf_kind(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info);
+}
+
+static inline __u16 btf_vlen(const struct btf_type *t)
+{
+	return BTF_INFO_VLEN(t->info);
+}
+
+static inline bool btf_kflag(const struct btf_type *t)
+{
+	return BTF_INFO_KFLAG(t->info);
+}
+
+static inline bool btf_is_int(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_INT;
+}
+
+static inline bool btf_is_ptr(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_PTR;
+}
+
+static inline bool btf_is_array(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_ARRAY;
+}
+
+static inline bool btf_is_struct(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_STRUCT;
+}
+
+static inline bool btf_is_union(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_UNION;
+}
+
+static inline bool btf_is_composite(const struct btf_type *t)
+{
+	__u16 kind = btf_kind(t);
+
+	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
+}
+
+static inline bool btf_is_enum(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_ENUM;
+}
+
+static inline bool btf_is_fwd(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_FWD;
+}
+
+static inline bool btf_is_typedef(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_TYPEDEF;
+}
+
+static inline bool btf_is_volatile(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_VOLATILE;
+}
+
+static inline bool btf_is_const(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_CONST;
+}
+
+static inline bool btf_is_restrict(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_RESTRICT;
+}
+
+static inline bool btf_is_mod(const struct btf_type *t)
+{
+	__u16 kind = btf_kind(t);
+
+	return kind == BTF_KIND_VOLATILE ||
+	       kind == BTF_KIND_CONST ||
+	       kind == BTF_KIND_RESTRICT;
+}
+
+static inline bool btf_is_func(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_FUNC;
+}
+
+static inline bool btf_is_func_proto(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_FUNC_PROTO;
+}
+
+static inline bool btf_is_var(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_VAR;
+}
+
+static inline bool btf_is_datasec(const struct btf_type *t)
+{
+	return btf_kind(t) == BTF_KIND_DATASEC;
+}
+
+static inline __u8 btf_int_encoding(const struct btf_type *t)
+{
+	return BTF_INT_ENCODING(*(__u32 *)(t + 1));
+}
+
+static inline __u8 btf_int_offset(const struct btf_type *t)
+{
+	return BTF_INT_OFFSET(*(__u32 *)(t + 1));
+}
+
+static inline __u8 btf_int_bits(const struct btf_type *t)
+{
+	return BTF_INT_BITS(*(__u32 *)(t + 1));
+}
+
+static inline const struct btf_array *btf_array(const struct btf_type *t)
+{
+	return (const struct btf_array *)(t + 1);
+}
+
+static inline const struct btf_enum *btf_enum(const struct btf_type *t)
+{
+	return (const struct btf_enum *)(t + 1);
+}
+
+static inline const struct btf_member *btf_members(const struct btf_type *t)
+{
+	return (const struct btf_member *)(t + 1);
+}
+
+/* get bit offset of a member with specified index */
+static inline const __u32 btf_member_bit_offset(const struct btf_type *t,
+					        __u32 member_idx)
+{
+	const struct btf_member *m = btf_members(t) + member_idx;
+	bool kflag = btf_kflag(t);
+
+	return kflag ? BTF_MEMBER_BIT_OFFSET(m->offset) : m->offset;
+}
+/* get bitfield size of a member, assuming t is BTF_KIND_STRUCT or
+ * BTF_KIND_UNION. If member is not a bitfield, zero is returned. */
+static inline const __u32 btf_member_bitfield_size(const struct btf_type *t,
+						   __u32 member_idx)
+{
+	const struct btf_member *m = btf_members(t) + member_idx;
+	bool kflag = btf_kflag(t);
+
+	return kflag ? BTF_MEMBER_BITFIELD_SIZE(m->offset) : 0;
+}
+
+static inline const struct btf_param *btf_params(const struct btf_type *t)
+{
+	return (const struct btf_param *)(t + 1);
+}
+
+static inline const struct btf_var *btf_var(const struct btf_type *t)
+{
+	return (const struct btf_var *)(t + 1);
+}
+
+static inline const struct btf_var_secinfo *
+btf_var_secinfos(const struct btf_type *t)
+{
+	return (const struct btf_var_secinfo *)(t + 1);
+}
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
-- 
2.17.1

