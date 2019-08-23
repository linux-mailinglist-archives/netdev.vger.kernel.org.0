Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71AA89A743
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 07:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392169AbfHWFwh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Aug 2019 01:52:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60514 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392082AbfHWFwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 01:52:36 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7N5mPKi023614
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 22:52:35 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ujaafr0b7-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 22:52:35 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 22 Aug 2019 22:52:20 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id C96B8760BEC; Thu, 22 Aug 2019 22:52:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/4] bpf: introduce verifier internal test flag
Date:   Thu, 22 Aug 2019 22:52:12 -0700
Message-ID: <20190823055215.2658669-2-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190823055215.2658669-1-ast@kernel.org>
References: <20190823055215.2658669-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-23_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=936 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908230063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce BPF_F_TEST_STATE_FREQ flag to stress test parentage chain
and state pruning.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf_verifier.h | 1 +
 include/uapi/linux/bpf.h     | 3 +++
 kernel/bpf/syscall.c         | 1 +
 kernel/bpf/verifier.c        | 5 ++++-
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 5fe99f322b1c..26a6d58ca78c 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -355,6 +355,7 @@ struct bpf_verifier_env {
 	struct bpf_verifier_stack_elem *head; /* stack of verifier states to be processed */
 	int stack_size;			/* number of states to be processed */
 	bool strict_alignment;		/* perform strict pointer alignment checks */
+	bool test_state_freq;		/* test verifier with different pruning frequency */
 	struct bpf_verifier_state *cur_state; /* current verifier state */
 	struct bpf_verifier_state_list **explored_states; /* search pruning optimization */
 	struct bpf_verifier_state_list *free_list;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b5889257cc33..5d2fb183ee2d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -285,6 +285,9 @@ enum bpf_attach_type {
  */
 #define BPF_F_TEST_RND_HI32	(1U << 2)
 
+/* The verifier internal test flag. Behavior is undefined */
+#define BPF_F_TEST_STATE_FREQ	(1U << 3)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * two extensions:
  *
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c0f62fd67c6b..ca60eafa6922 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1629,6 +1629,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 
 	if (attr->prog_flags & ~(BPF_F_STRICT_ALIGNMENT |
 				 BPF_F_ANY_ALIGNMENT |
+				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_TEST_RND_HI32))
 		return -EINVAL;
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 16d66bd7af09..3fb50757e812 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7223,7 +7223,7 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 	struct bpf_verifier_state_list *sl, **pprev;
 	struct bpf_verifier_state *cur = env->cur_state, *new;
 	int i, j, err, states_cnt = 0;
-	bool add_new_state = false;
+	bool add_new_state = env->test_state_freq ? true : false;
 
 	cur->last_insn_idx = env->prev_insn_idx;
 	if (!env->insn_aux_data[insn_idx].prune_point)
@@ -9263,6 +9263,9 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 
 	env->allow_ptr_leaks = is_priv;
 
+	if (is_priv)
+		env->test_state_freq = attr->prog_flags & BPF_F_TEST_STATE_FREQ;
+
 	ret = replace_map_fd_with_map_ptr(env);
 	if (ret < 0)
 		goto skip_full_check;
-- 
2.20.0

