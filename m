Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873D829DF29
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403942AbgJ2A7h convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Oct 2020 20:59:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39990 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403939AbgJ2A7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 20:59:32 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09T0oYP2021540
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 17:59:31 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34f7pjc9vu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 17:59:31 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 28 Oct 2020 17:59:31 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 83D372EC875F; Wed, 28 Oct 2020 17:59:26 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 09/11] libbpf: accomodate DWARF/compiler bug with duplicated identical arrays
Date:   Wed, 28 Oct 2020 17:59:00 -0700
Message-ID: <20201029005902.1706310-10-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201029005902.1706310-1-andrii@kernel.org>
References: <20201029005902.1706310-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_09:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 adultscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 suspectscore=8 spamscore=0 malwarescore=0 mlxlogscore=626 mlxscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010290001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases compiler seems to generate distinct DWARF types for identical
arrays within the same CU. That seems like a bug, but it's already out there
and breaks type graph equivalence checks, so accommodate it anyway by checking
for identical arrays, regardless of their type ID.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index c760a5809d4d..4643b0482686 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -3786,6 +3786,19 @@ static inline __u16 btf_fwd_kind(struct btf_type *t)
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
@@ -3896,8 +3909,18 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
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

