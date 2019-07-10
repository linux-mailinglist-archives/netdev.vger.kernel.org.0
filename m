Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 168D56435A
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 10:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfGJIIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 04:08:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64794 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726275AbfGJIIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 04:08:53 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6A88Wu3026568
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 01:08:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=PDY+EhkXjha7DMzrL7RSVazSHo0QDYayuvq4vc2hvvM=;
 b=GaChb78XG+JhNSVybUnusvZr5jgnjE4YbnbIlFyULSiWfz1bBUxDZQKocRWS6L2e6dfc
 YYZulKj53qCNePslegMkDRUPKq7qFcqK8wFD7lNcYFilRSsyXVZjejjS3v0Tt5EEwGuG
 Wo/yx0UChkF0GH3tTBr2XUFB8qNcdc8mNIc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2tn3husdc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 01:08:51 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 10 Jul 2019 01:08:49 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id E43B88616EE; Wed, 10 Jul 2019 01:08:48 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf] bpf: fix BTF verifier size resolution logic
Date:   Wed, 10 Jul 2019 01:08:40 -0700
Message-ID: <20190710080840.2613160-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=680 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100099
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTF verifier has Different logic depending on whether we are following
a PTR or STRUCT/ARRAY (or something else). This is an optimization to
stop early in DFS traversal while resolving BTF types. But it also
results in a size resolution bug, when there is a chain, e.g., of PTR ->
TYPEDEF -> ARRAY, in which case due to being in pointer context ARRAY
size won't be resolved, as it is considered to be a sink for pointer,
leading to TYPEDEF being in RESOLVED state with zero size, which is
completely wrong.

Optimization is doubtful, though, as btf_check_all_types() will iterate
over all BTF types anyways, so the only saving is a potentially slightly
shorter stack. But correctness is more important that tiny savings.

This bug manifests itself in rejecting BTF-defined maps that use array
typedef as a value type:

typedef int array_t[16];

struct {
	__uint(type, BPF_MAP_TYPE_ARRAY);
	__type(value, array_t); /* i.e., array_t *value; */
} test_map SEC(".maps");

Fixes: eb3f595dab40 ("bpf: btf: Validate type reference")
Cc: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/btf.c | 42 +++---------------------------------------
 1 file changed, 3 insertions(+), 39 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index cad09858a5f2..c68c7e73b0d1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -231,14 +231,6 @@ enum visit_state {
 	RESOLVED,
 };
 
-enum resolve_mode {
-	RESOLVE_TBD,	/* To Be Determined */
-	RESOLVE_PTR,	/* Resolving for Pointer */
-	RESOLVE_STRUCT_OR_ARRAY,	/* Resolving for struct/union
-					 * or array
-					 */
-};
-
 #define MAX_RESOLVE_DEPTH 32
 
 struct btf_sec_info {
@@ -254,7 +246,6 @@ struct btf_verifier_env {
 	u32 log_type_id;
 	u32 top_stack;
 	enum verifier_phase phase;
-	enum resolve_mode resolve_mode;
 };
 
 static const char * const btf_kind_str[NR_BTF_KINDS] = {
@@ -964,26 +955,7 @@ static void btf_verifier_env_free(struct btf_verifier_env *env)
 static bool env_type_is_resolve_sink(const struct btf_verifier_env *env,
 				     const struct btf_type *next_type)
 {
-	switch (env->resolve_mode) {
-	case RESOLVE_TBD:
-		/* int, enum or void is a sink */
-		return !btf_type_needs_resolve(next_type);
-	case RESOLVE_PTR:
-		/* int, enum, void, struct, array, func or func_proto is a sink
-		 * for ptr
-		 */
-		return !btf_type_is_modifier(next_type) &&
-			!btf_type_is_ptr(next_type);
-	case RESOLVE_STRUCT_OR_ARRAY:
-		/* int, enum, void, ptr, func or func_proto is a sink
-		 * for struct and array
-		 */
-		return !btf_type_is_modifier(next_type) &&
-			!btf_type_is_array(next_type) &&
-			!btf_type_is_struct(next_type);
-	default:
-		BUG();
-	}
+	return !btf_type_needs_resolve(next_type);
 }
 
 static bool env_type_is_resolved(const struct btf_verifier_env *env,
@@ -1010,13 +982,6 @@ static int env_stack_push(struct btf_verifier_env *env,
 	v->type_id = type_id;
 	v->next_member = 0;
 
-	if (env->resolve_mode == RESOLVE_TBD) {
-		if (btf_type_is_ptr(t))
-			env->resolve_mode = RESOLVE_PTR;
-		else if (btf_type_is_struct(t) || btf_type_is_array(t))
-			env->resolve_mode = RESOLVE_STRUCT_OR_ARRAY;
-	}
-
 	return 0;
 }
 
@@ -1038,7 +1003,7 @@ static void env_stack_pop_resolved(struct btf_verifier_env *env,
 	env->visit_states[type_id] = RESOLVED;
 }
 
-static const struct resolve_vertex *env_stack_peak(struct btf_verifier_env *env)
+static const struct resolve_vertex *env_stack_peek(struct btf_verifier_env *env)
 {
 	return env->top_stack ? &env->stack[env->top_stack - 1] : NULL;
 }
@@ -3030,9 +2995,8 @@ static int btf_resolve(struct btf_verifier_env *env,
 	const struct resolve_vertex *v;
 	int err = 0;
 
-	env->resolve_mode = RESOLVE_TBD;
 	env_stack_push(env, t, type_id);
-	while (!err && (v = env_stack_peak(env))) {
+	while (!err && (v = env_stack_peek(env))) {
 		env->log_type_id = v->type_id;
 		err = btf_type_ops(v->t)->resolve(env, v);
 	}
-- 
2.17.1

