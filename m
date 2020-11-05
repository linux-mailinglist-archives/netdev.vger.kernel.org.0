Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DA92A7681
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbgKEEed convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Nov 2020 23:34:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46000 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731618AbgKEEe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:34:29 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A54Y0Bs003246
        for <netdev@vger.kernel.org>; Wed, 4 Nov 2020 20:34:28 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34kf5c7r8m-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 20:34:28 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 20:34:27 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 637E02EC8E04; Wed,  4 Nov 2020 20:34:23 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 09/11] libbpf: accomodate DWARF/compiler bug with duplicated identical arrays
Date:   Wed, 4 Nov 2020 20:33:59 -0800
Message-ID: <20201105043402.2530976-10-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105043402.2530976-1-andrii@kernel.org>
References: <20201105043402.2530976-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_01:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 clxscore=1015 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=643
 suspectscore=8 priorityscore=1501 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases compiler seems to generate distinct DWARF types for identical
arrays within the same CU. That seems like a bug, but it's already out there
and breaks type graph equivalence checks, so accommodate it anyway by checking
for identical arrays, regardless of their type ID.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 8d04d9becb67..2d0d064c6d31 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -3785,6 +3785,19 @@ static inline __u16 btf_fwd_kind(struct btf_type *t)
 	return btf_kflag(t) ? BTF_KIND_UNION : BTF_KIND_STRUCT;
 }
 
+/* Check if given two types are identical ARRAY definitions */
+static int btf_dedup_identical_arrays(struct btf_dedup *d, __u32 id1, __u32 id2)
+{
+	struct btf_type *t1, *t2;
+
+	t1 = btf_type_by_id(d->btf, id1);
+	t2 = btf_type_by_id(d->btf, id2);
+	if (!btf_is_array(t1) || !btf_is_array(t2))
+		return 0;
+
+	return btf_equal_array(t1, t2);
+}
+
 /*
  * Check equivalence of BTF type graph formed by candidate struct/union (we'll
  * call it "candidate graph" in this description for brevity) to a type graph
@@ -3895,8 +3908,18 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
 	canon_id = resolve_fwd_id(d, canon_id);
 
 	hypot_type_id = d->hypot_map[canon_id];
-	if (hypot_type_id <= BTF_MAX_NR_TYPES)
-		return hypot_type_id == cand_id;
+	if (hypot_type_id <= BTF_MAX_NR_TYPES) {
+		/* In some cases compiler will generate different DWARF types
+		 * for *identical* array type definitions and use them for
+		 * different fields within the *same* struct. This breaks type
+		 * equivalence check, which makes an assumption that candidate
+		 * types sub-graph has a consistent and deduped-by-compiler
+		 * types within a single CU. So work around that by explicitly
+		 * allowing identical array types here.
+		 */
+		return hypot_type_id == cand_id ||
+		       btf_dedup_identical_arrays(d, hypot_type_id, cand_id);
+	}
 
 	if (btf_dedup_hypot_map_add(d, canon_id, cand_id))
 		return -ENOMEM;
-- 
2.24.1

