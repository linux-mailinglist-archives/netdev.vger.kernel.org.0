Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8261FCE49
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfKNS5j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 13:57:39 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46732 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727146AbfKNS5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:57:37 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAEIdRgN001128
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:36 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w90t83hwb-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:35 -0800
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 14 Nov 2019 10:57:32 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 253D476071B; Thu, 14 Nov 2019 10:57:31 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 05/20] libbpf: Introduce btf__find_by_name_kind()
Date:   Thu, 14 Nov 2019 10:57:05 -0800
Message-ID: <20191114185720.1641606-6-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114185720.1641606-1-ast@kernel.org>
References: <20191114185720.1641606-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 mlxlogscore=725 phishscore=0
 spamscore=0 impostorscore=0 clxscore=1015 suspectscore=3
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce btf__find_by_name_kind() helper to search BTF by name and kind, since
name alone can be ambiguous.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c      | 22 ++++++++++++++++++++++
 tools/lib/bpf/btf.h      |  2 ++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 25 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 86a1847e4a9f..88efa2bb7137 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -316,6 +316,28 @@ __s32 btf__find_by_name(const struct btf *btf, const char *type_name)
 	return -ENOENT;
 }
 
+__s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
+			     __u32 kind)
+{
+	__u32 i;
+
+	if (kind == BTF_KIND_UNKN || !strcmp(type_name, "void"))
+		return 0;
+
+	for (i = 1; i <= btf->nr_types; i++) {
+		const struct btf_type *t = btf->types[i];
+		const char *name;
+
+		if (btf_kind(t) != kind)
+			continue;
+		name = btf__name_by_offset(btf, t->name_off);
+		if (name && !strcmp(type_name, name))
+			return i;
+	}
+
+	return -ENOENT;
+}
+
 void btf__free(struct btf *btf)
 {
 	if (!btf)
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index b18994116a44..d9ac73a02cde 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -72,6 +72,8 @@ LIBBPF_API int btf__finalize_data(struct bpf_object *obj, struct btf *btf);
 LIBBPF_API int btf__load(struct btf *btf);
 LIBBPF_API __s32 btf__find_by_name(const struct btf *btf,
 				   const char *type_name);
+LIBBPF_API __s32 btf__find_by_name_kind(const struct btf *btf,
+					const char *type_name, __u32 kind);
 LIBBPF_API __u32 btf__get_nr_types(const struct btf *btf);
 LIBBPF_API const struct btf_type *btf__type_by_id(const struct btf *btf,
 						  __u32 id);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 9f39ee06b2d4..420e69bfe699 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -204,4 +204,5 @@ LIBBPF_0.0.6 {
 		bpf_program__is_tracing;
 		bpf_program__set_tracing;
 		bpf_program__size;
+		btf__find_by_name_kind;
 } LIBBPF_0.0.5;
-- 
2.23.0

