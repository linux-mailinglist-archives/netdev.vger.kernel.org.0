Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9053525C1C
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 05:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfEVDRn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 May 2019 23:17:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60656 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728150AbfEVDRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 23:17:43 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4M3EfXr015933
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 20:17:42 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2smkvw2aah-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 20:17:42 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 21 May 2019 20:17:13 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 46EC0760CB3; Tue, 21 May 2019 20:17:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/3] bpf: split explored_states
Date:   Tue, 21 May 2019 20:17:06 -0700
Message-ID: <20190522031707.2834254-3-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190522031707.2834254-1-ast@kernel.org>
References: <20190522031707.2834254-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220021
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
index f8a540b29c12..acf186a8111e 100644
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
 
 /* t, w, e - match pseudo-code above:
@@ -6017,10 +6016,7 @@ static void clean_live_states(struct bpf_verifier_env *env, int insn,
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
@@ -6375,18 +6371,18 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
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
@@ -8144,13 +8140,12 @@ static void free_states(struct bpf_verifier_env *env)
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

