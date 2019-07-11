Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C89A65212
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 08:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfGKGxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 02:53:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65288 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727479AbfGKGxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 02:53:25 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6B6mN34030520
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 23:53:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=8g/ZKbn1t6UvC9fMywEcxIMTy7d4PMsi3D5oeRhKtIQ=;
 b=qr/jY+h2RBAhKxvdwMTBo/tPf6UmqtCHAnI7EZ622asPg+reswPdzEWUtqhJ5vWt+bt/
 3FMOHrPchsaBlr/rUow/h928YWpTOqCRIksdJxTzKNEBP4VUdqh/PhhfszhFUjqlLO35
 CgypNUNsCPlbs16h58Gy3E0PFHq+HYDMQt8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tnws68c2q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 23:53:23 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 10 Jul 2019 23:53:22 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 113ED861661; Wed, 10 Jul 2019 23:53:21 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 1/3] bpf: fix BTF verifier size resolution logic
Date:   Wed, 10 Jul 2019 23:53:05 -0700
Message-ID: <20190711065307.2425636-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190711065307.2425636-1-andriin@fb.com>
References: <20190711065307.2425636-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110079
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTF verifier has a size resolution bug which in some circumstances leads to
invalid size resolution for, e.g., TYPEDEF modifier.  This happens if we have
[1] PTR -> [2] TYPEDEF -> [3] ARRAY, in which case due to being in pointer
context ARRAY size won't be resolved (because for pointer it doesn't matter, so
it's a sink in pointer context), but it will be permanently remembered as zero
for TYPEDEF and TYPEDEF will be marked as RESOLVED. Eventually ARRAY size will
be resolved correctly, but TYPEDEF resolved_size won't be updated anymore.
This, subsequently, will lead to erroneous map creation failure, if that
TYPEDEF is specified as either key or value, as key_size/value_size won't
correspond to resolved size of TYPEDEF (kernel will believe it's zero).

Note, that if BTF was ordered as [1] ARRAY <- [2] TYPEDEF <- [3] PTR, this
won't be a problem, as by the time we get to TYPEDEF, ARRAY's size is already
calculated and stored.

This bug manifests itself in rejecting BTF-defined maps that use array
typedef as a value type:

typedef int array_t[16];

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(value, array_t); /* i.e., array_t *value; */
} test_map SEC(".maps");

The fix consists on not relying on modifier's resolved_size and instead using
modifier's resolved_id (type ID for "concrete" type to which modifier
eventually resolves) and doing size determination for that resolved type. This
allow to preserve existing "early DFS termination" logic for PTR or
STRUCT_OR_ARRAY contexts, but still do correct size determination for modifier
types.

Fixes: eb3f595dab40 ("bpf: btf: Validate type reference")
Cc: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/btf.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index cad09858a5f2..22fe8b155e51 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1073,11 +1073,18 @@ const struct btf_type *btf_type_id_size(const struct btf *btf,
 				 !btf_type_is_var(size_type)))
 			return NULL;
 
-		size = btf->resolved_sizes[size_type_id];
 		size_type_id = btf->resolved_ids[size_type_id];
 		size_type = btf_type_by_id(btf, size_type_id);
 		if (btf_type_nosize_or_null(size_type))
 			return NULL;
+		else if (btf_type_has_size(size_type))
+			size = size_type->size;
+		else if (btf_type_is_array(size_type))
+			size = btf->resolved_sizes[size_type_id];
+		else if (btf_type_is_ptr(size_type))
+			size = sizeof(void *);
+		else
+			return NULL;
 	}
 
 	*type_id = size_type_id;
@@ -1602,7 +1609,6 @@ static int btf_modifier_resolve(struct btf_verifier_env *env,
 	const struct btf_type *next_type;
 	u32 next_type_id = t->type;
 	struct btf *btf = env->btf;
-	u32 next_type_size = 0;
 
 	next_type = btf_type_by_id(btf, next_type_id);
 	if (!next_type || btf_type_is_resolve_source_only(next_type)) {
@@ -1620,7 +1626,7 @@ static int btf_modifier_resolve(struct btf_verifier_env *env,
 	 * save us a few type-following when we use it later (e.g. in
 	 * pretty print).
 	 */
-	if (!btf_type_id_size(btf, &next_type_id, &next_type_size)) {
+	if (!btf_type_id_size(btf, &next_type_id, NULL)) {
 		if (env_type_is_resolved(env, next_type_id))
 			next_type = btf_type_id_resolve(btf, &next_type_id);
 
@@ -1633,7 +1639,7 @@ static int btf_modifier_resolve(struct btf_verifier_env *env,
 		}
 	}
 
-	env_stack_pop_resolved(env, next_type_id, next_type_size);
+	env_stack_pop_resolved(env, next_type_id, 0);
 
 	return 0;
 }
-- 
2.17.1

