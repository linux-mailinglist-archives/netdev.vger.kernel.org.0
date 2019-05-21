Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCC9A25AA7
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 01:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfEUXGz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 May 2019 19:06:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40070 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727015AbfEUXGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 19:06:55 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4LMuPmj026944
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:06:54 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2smp0ws2vx-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:06:54 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 21 May 2019 16:06:38 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id A6931760B85; Tue, 21 May 2019 16:06:37 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/3] bpf: cleanup explored_states
Date:   Tue, 21 May 2019 16:06:33 -0700
Message-ID: <20190521230635.2142522-2-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190521230635.2142522-1-ast@kernel.org>
References: <20190521230635.2142522-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-21_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=514 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905210143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clean up explored_states to prep for introduction of hashtable
No functional changes.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 95f9354495ad..a171b2940382 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5436,6 +5436,18 @@ enum {
 };
 
 #define STATE_LIST_MARK ((struct bpf_verifier_state_list *) -1L)
+static struct bpf_verifier_state_list **explored_state(
+					struct bpf_verifier_env *env,
+					int idx)
+{
+	return &env->explored_states[idx];
+}
+
+static void init_explored_state(struct bpf_verifier_env *env, int idx)
+{
+	env->explored_states[idx] = STATE_LIST_MARK;
+}
+
 
 /* t, w, e - match pseudo-code above:
  * t - index of current instruction
@@ -5461,7 +5473,7 @@ static int push_insn(int t, int w, int e, struct bpf_verifier_env *env)
 
 	if (e == BRANCH)
 		/* mark branch target for state pruning */
-		env->explored_states[w] = STATE_LIST_MARK;
+		init_explored_state(env, w);
 
 	if (insn_state[w] == 0) {
 		/* tree-edge */
@@ -5529,9 +5541,9 @@ static int check_cfg(struct bpf_verifier_env *env)
 			else if (ret < 0)
 				goto err_free;
 			if (t + 1 < insn_cnt)
-				env->explored_states[t + 1] = STATE_LIST_MARK;
+				init_explored_state(env, t + 1);
 			if (insns[t].src_reg == BPF_PSEUDO_CALL) {
-				env->explored_states[t] = STATE_LIST_MARK;
+				init_explored_state(env, t);
 				ret = push_insn(t, t + insns[t].imm + 1, BRANCH, env);
 				if (ret == 1)
 					goto peek_stack;
@@ -5554,10 +5566,10 @@ static int check_cfg(struct bpf_verifier_env *env)
 			 * after every call and jump
 			 */
 			if (t + 1 < insn_cnt)
-				env->explored_states[t + 1] = STATE_LIST_MARK;
+				init_explored_state(env, t + 1);
 		} else {
 			/* conditional jump with two edges */
-			env->explored_states[t] = STATE_LIST_MARK;
+			init_explored_state(env, t);
 			ret = push_insn(t, t + 1, FALLTHROUGH, env);
 			if (ret == 1)
 				goto peek_stack;
@@ -6005,7 +6017,7 @@ static void clean_live_states(struct bpf_verifier_env *env, int insn,
 	struct bpf_verifier_state_list *sl;
 	int i;
 
-	sl = env->explored_states[insn];
+	sl = *explored_state(env, insn);
 	if (!sl)
 		return;
 
@@ -6364,7 +6376,7 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 	struct bpf_verifier_state *cur = env->cur_state, *new;
 	int i, j, err, states_cnt = 0;
 
-	pprev = &env->explored_states[insn_idx];
+	pprev = explored_state(env, insn_idx);
 	sl = *pprev;
 
 	if (!sl)
@@ -6451,8 +6463,8 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 		kfree(new_sl);
 		return err;
 	}
-	new_sl->next = env->explored_states[insn_idx];
-	env->explored_states[insn_idx] = new_sl;
+	new_sl->next = *explored_state(env, insn_idx);
+	*explored_state(env, insn_idx) = new_sl;
 	/* connect new state to parentage chain. Current frame needs all
 	 * registers connected. Only r6 - r9 of the callers are alive (pushed
 	 * to the stack implicitly by JITs) so in callers' frames connect just
-- 
2.20.0

