Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429E8340E81
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhCRTlY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Mar 2021 15:41:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13658 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232924AbhCRTkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:40:55 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IJT2B3011937
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:40:55 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37bek0tbq2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:40:55 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 12:40:54 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C6DD82ED2588; Thu, 18 Mar 2021 12:40:52 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v4 bpf-next 05/12] libbpf: add generic BTF type shallow copy API
Date:   Thu, 18 Mar 2021 12:40:29 -0700
Message-ID: <20210318194036.3521577-6-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318194036.3521577-1-andrii@kernel.org>
References: <20210318194036.3521577-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_12:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add btf__add_type() API that performs shallow copy of a given BTF type from
the source BTF into the destination BTF. All the information and type IDs are
preserved, but all the strings encountered are added into the destination BTF
and corresponding offsets are rewritten. BTF type IDs are assumed to be
correct or such that will be (somehow) modified afterwards.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c      | 48 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/btf.h      |  2 ++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 51 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index fe087592ad35..d30e67e7e1e5 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1629,6 +1629,54 @@ static int btf_commit_type(struct btf *btf, int data_sz)
 	return btf->start_id + btf->nr_types - 1;
 }
 
+struct btf_pipe {
+	const struct btf *src;
+	struct btf *dst;
+};
+
+static int btf_rewrite_str(__u32 *str_off, void *ctx)
+{
+	struct btf_pipe *p = ctx;
+	int off;
+
+	if (!*str_off) /* nothing to do for empty strings */
+		return 0;
+
+	off = btf__add_str(p->dst, btf__str_by_offset(p->src, *str_off));
+	if (off < 0)
+		return off;
+
+	*str_off = off;
+	return 0;
+}
+
+int btf__add_type(struct btf *btf, const struct btf *src_btf, const struct btf_type *src_type)
+{
+	struct btf_pipe p = { .src = src_btf, .dst = btf };
+	struct btf_type *t;
+	int sz, err;
+
+	sz = btf_type_size(src_type);
+	if (sz < 0)
+		return sz;
+
+	/* deconstruct BTF, if necessary, and invalidate raw_data */
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	t = btf_add_type_mem(btf, sz);
+	if (!t)
+		return -ENOMEM;
+
+	memcpy(t, src_type, sz);
+
+	err = btf_type_visit_str_offs(t, btf_rewrite_str, &p);
+	if (err)
+		return err;
+
+	return btf_commit_type(btf, sz);
+}
+
 /*
  * Append new BTF_KIND_INT type with:
  *   - *name* - non-empty, non-NULL type name;
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 029a9cfc8c2d..3b0b17ba94a1 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -93,6 +93,8 @@ LIBBPF_API struct btf *libbpf_find_kernel_btf(void);
 
 LIBBPF_API int btf__find_str(struct btf *btf, const char *s);
 LIBBPF_API int btf__add_str(struct btf *btf, const char *s);
+LIBBPF_API int btf__add_type(struct btf *btf, const struct btf *src_btf,
+			     const struct btf_type *src_type);
 
 LIBBPF_API int btf__add_int(struct btf *btf, const char *name, size_t byte_sz, int encoding);
 LIBBPF_API int btf__add_float(struct btf *btf, const char *name, size_t byte_sz);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index ec898f464ab9..d31d8c968097 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -354,4 +354,5 @@ LIBBPF_0.3.0 {
 LIBBPF_0.4.0 {
 	global:
 		btf__add_float;
+		btf__add_type;
 } LIBBPF_0.3.0;
-- 
2.30.2

