Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 090FE25AA3
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 01:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfEUXGn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 May 2019 19:06:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52710 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727015AbfEUXGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 19:06:43 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4LMuOol011115
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:06:41 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2smb4mk92w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:06:41 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 May 2019 16:06:40 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id B1836760B85; Tue, 21 May 2019 16:06:39 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/3] bpf: split explored_states
Date:   Tue, 21 May 2019 16:06:34 -0700
Message-ID: <20190521230635.2142522-3-ast@kernel.org>
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
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905210143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

split explored_states into prune_point boolean mark
and link list of explored states.
This removes STATE_LIST_MARK hack and allows marks to be separate from states.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/verifier.c        | 31 +++++++++++++------------------
 2 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 1305ccbd8fe6..02bba09a0ea1 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -233,6 +233,7 @@ struct bpf_insn_aux_data {
 	int sanitize_stack_off; /* stack slot to be cleared */
 	bool seen; /* this insn was processed by the verifier */
 	u8 alu_state; /* used in combination with alu_limit */
+	bool prune_point;
 	unsigned int orig_idx; /* original instruction index */
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a171b2940382..89097a4b1bf3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5435,7 +5435,6 @@ enum {
 	BRANCH = 2,
 };
 
-#define STATE_LIST_MARK ((struct bpf_verifier_state_list *) -1L)
 static struct bpf_verifier_state_list **explored_state(
 					struct bpf_verifier_env *env,
 					int idx)
@@ -5445,7 +5444,7 @@ static struct bpf_verifier_state_list **explored_state(
 
 static void init_explored_state(struct bpf_verifier_env *env, int idx)
 {
-	env->explored_states[idx] = STATE_LIST_MARK;
+	env->insn_aux_data[idx].prune_point = true;
 }
 
 
@@ -6018,10 +6017,7 @@ static void clean_live_states(struct bpf_verifier_env *env, int insn,
 	int i;
 
 	sl = *explored_state(env, insn);
-	if (!sl)
-		return;
-
-	while (sl != STATE_LIST_MARK) {
+	while (sl) {
 		if (sl->state.curframe != cur->curframe)
 			goto next;
 		for (i = 0; i <= cur->curframe; i++)
@@ -6376,18 +6372,18 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 	struct bpf_verifier_state *cur = env->cur_state, *new;
 	int i, j, err, states_cnt = 0;
 
-	pprev = explored_state(env, insn_idx);
-	sl = *pprev;
-
-	if (!sl)
+	if (!env->insn_aux_data[insn_idx].prune_point)
 		/* this 'insn_idx' instruction wasn't marked, so we will not
 		 * be doing state search here
 		 */
 		return 0;
 
+	pprev = explored_state(env, insn_idx);
+	sl = *pprev;
+
 	clean_live_states(env, insn_idx, cur);
 
-	while (sl != STATE_LIST_MARK) {
+	while (sl) {
 		if (states_equal(env, &sl->state, cur)) {
 			sl->hit_cnt++;
 			/* reached equivalent register/stack state,
@@ -8145,13 +8141,12 @@ static void free_states(struct bpf_verifier_env *env)
 	for (i = 0; i < env->prog->len; i++) {
 		sl = env->explored_states[i];
 
-		if (sl)
-			while (sl != STATE_LIST_MARK) {
-				sln = sl->next;
-				free_verifier_state(&sl->state, false);
-				kfree(sl);
-				sl = sln;
-			}
+		while (sl) {
+			sln = sl->next;
+			free_verifier_state(&sl->state, false);
+			kfree(sl);
+			sl = sln;
+		}
 	}
 
 	kvfree(env->explored_states);
-- 
2.20.0

