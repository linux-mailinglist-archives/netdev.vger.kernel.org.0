Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C99AF2760
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfKGFrx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Nov 2019 00:47:53 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44610 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbfKGFrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:47:53 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA75j9kx001044
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 21:47:52 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41ue3fwa-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 21:47:52 -0800
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 21:47:13 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id C79DA760BC0; Wed,  6 Nov 2019 21:47:10 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 13/17] bpf: Compare BTF types of functions arguments with actual types
Date:   Wed, 6 Nov 2019 21:46:40 -0800
Message-ID: <20191107054644.1285697-14-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107054644.1285697-1-ast@kernel.org>
References: <20191107054644.1285697-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1034 malwarescore=0 mlxlogscore=919 suspectscore=3 adultscore=0
 mlxscore=0 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070060
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the verifier check that BTF types of function arguments match actual types
passed into top-level BPF program and into BPF-to-BPF calls. If types match
such BPF programs and sub-programs will have full support of BPF trampoline. If
types mismatch the trampoline has to be conservative. It would have to preserve
all 5 BPF arguments and assume 64-bit scalars as arguments.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h          |  3 ++
 include/linux/bpf_verifier.h |  2 +
 kernel/bpf/btf.c             | 78 ++++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c        | 21 ++++++++--
 4 files changed, 100 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c287dfce2a17..ef9c954021e4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -487,6 +487,7 @@ struct bpf_prog_aux {
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
 	bool offload_requested;
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
+	bool func_proto_unreliable;
 	enum bpf_tramp_prog_type trampoline_prog_type;
 	struct bpf_trampoline *trampoline;
 	struct hlist_node tramp_hlist;
@@ -883,6 +884,8 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 			   const char *func_name,
 			   struct btf_func_model *m);
 
+int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog);
+
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 6e7284ea1468..9d4b2103479d 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -343,9 +343,11 @@ static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
 #define BPF_MAX_SUBPROGS 256
 
 struct bpf_subprog_info {
+	/* 'start' has to be the first field otherwise find_subprog() won't work */
 	u32 start; /* insn idx of function entry point */
 	u32 linfo_idx; /* The idx to the main_prog->aux->linfo */
 	u16 stack_depth; /* max. stack depth used by this function */
+	bool func_proto_unreliable;
 };
 
 /* single container for all structs
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7155787a0b13..050ec34bdd73 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3748,6 +3748,84 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 	return 0;
 }
 
+int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog)
+{
+	struct bpf_verifier_state *st = env->cur_state;
+	struct bpf_func_state *func = st->frame[st->curframe];
+	struct bpf_reg_state *reg = func->regs;
+	struct bpf_verifier_log *log = &env->log;
+	struct bpf_prog *prog = env->prog;
+	struct btf *btf = prog->aux->btf;
+	const struct btf_param *args;
+	const struct btf_type *t;
+	u32 i, nargs, btf_id;
+	const char *tname;
+
+	if (!prog->aux->func_info)
+		return 0;
+
+	btf_id = prog->aux->func_info[subprog].type_id;
+	if (!btf_id)
+		return 0;
+
+	if (env->subprog_info[subprog].func_proto_unreliable)
+		return 0;
+
+	t = btf_type_by_id(btf, btf_id);
+	if (!t || !btf_type_is_func(t)) {
+		bpf_log(log, "BTF of subprog %d doesn't point to KIND_FUNC\n",
+			subprog);
+		return -EINVAL;
+	}
+	tname = btf_name_by_offset(btf, t->name_off);
+
+	t = btf_type_by_id(btf, t->type);
+	if (!t || !btf_type_is_func_proto(t)) {
+		bpf_log(log, "Invalid type of func %s\n", tname);
+		return -EINVAL;
+	}
+	args = (const struct btf_param *)(t + 1);
+	nargs = btf_type_vlen(t);
+	if (nargs > 5) {
+		bpf_log(log, "Function %s has %d > 5 args\n", tname, nargs);
+		goto out;
+	}
+	/* check that BTF function arguments match actual types that the
+	 * verifier sees.
+	 */
+	for (i = 0; i < nargs; i++) {
+		t = btf_type_by_id(btf, args[i].type);
+		while (btf_type_is_modifier(t))
+			t = btf_type_by_id(btf_vmlinux, t->type);
+		if (btf_type_is_int(t) || btf_type_is_enum(t)) {
+			if (reg[i + 1].type == SCALAR_VALUE)
+				continue;
+			bpf_log(log,
+				"R%d is not a scalar\n",
+				i + 1);
+			goto out;
+		}
+		if (btf_type_is_ptr(t)) {
+			if (reg[i + 1].type == SCALAR_VALUE) {
+				bpf_log(log,
+					"R%d is not a pointer\n",
+					i + 1);
+				goto out;
+			}
+			continue;
+		}
+		bpf_log(log, "Unrecognized argument type %s\n",
+			btf_kind_str[BTF_INFO_KIND(t->info)]);
+		goto out;
+	}
+	return 0;
+out:
+	bpf_log(log,
+		"Type info disagrees with actual arguments due to compiler optimizations\n");
+	env->subprog_info[subprog].func_proto_unreliable = true;
+	return 0;
+}
+
 void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
 		       struct seq_file *m)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c4fd11a27d81..e5ccd9afb1e7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3970,6 +3970,9 @@ static int check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	/* only increment it after check_reg_arg() finished */
 	state->curframe++;
 
+	if (btf_check_func_arg_match(env, subprog))
+		return -EINVAL;
+
 	/* and go analyze first insn of the callee */
 	*insn_idx = target_insn;
 
@@ -6646,7 +6649,6 @@ static int check_btf_func(struct bpf_verifier_env *env,
 			ret = -EINVAL;
 			goto err_free;
 		}
-
 		prev_offset = krecord[i].insn_off;
 		urecord += urec_size;
 	}
@@ -6662,13 +6664,21 @@ static int check_btf_func(struct bpf_verifier_env *env,
 
 static void adjust_btf_func(struct bpf_verifier_env *env)
 {
+	struct bpf_prog_aux *aux = env->prog->aux;
 	int i;
 
-	if (!env->prog->aux->func_info)
+	if (!aux->func_info)
 		return;
 
-	for (i = 0; i < env->subprog_cnt; i++)
-		env->prog->aux->func_info[i].insn_off = env->subprog_info[i].start;
+	for (i = 0; i < env->subprog_cnt; i++) {
+		aux->func_info[i].insn_off = env->subprog_info[i].start;
+		if (env->subprog_info[i].func_proto_unreliable) {
+			if (i == 0)
+				aux->func_proto_unreliable = true;
+			else
+				aux->func[i]->aux->func_proto_unreliable = true;
+		}
+	}
 }
 
 #define MIN_BPF_LINEINFO_SIZE	(offsetof(struct bpf_line_info, line_col) + \
@@ -7649,6 +7659,9 @@ static int do_check(struct bpf_verifier_env *env)
 			0 /* frameno */,
 			0 /* subprogno, zero == main subprog */);
 
+	if (btf_check_func_arg_match(env, 0))
+		return -EINVAL;
+
 	for (;;) {
 		struct bpf_insn *insn;
 		u8 class;
-- 
2.23.0

