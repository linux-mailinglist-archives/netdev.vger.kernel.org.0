Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BB952C4D6
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 23:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242892AbiERU7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242875AbiERU7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:59:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9B6F231CB1
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652907585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5gCJospTTN2t8SEpfo9x05ijIEkJgmfk9aeuVxOhH7U=;
        b=iSync380tqwFhZuZdyWjdiSFE9QDf/pCp9PrHk9YnZE70nrjDSrQ2znhunYBXroZtGtRjh
        NpAo+OL5iWW3tq2Dtw28l+R7CHXMSZi6HEO9dYLB72q9GoiXXjG9WkEYd3pWc0t+3epbyj
        9eTKUTNh1tKkWLIB3LX+lUGKs5z/8Tk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-qwsD7YX3N_Cq1NUwFmM2qw-1; Wed, 18 May 2022 16:59:40 -0400
X-MC-Unique: qwsD7YX3N_Cq1NUwFmM2qw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 903B5800B21;
        Wed, 18 May 2022 20:59:39 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B7F02166B25;
        Wed, 18 May 2022 20:59:35 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v5 02/17] bpf/verifier: allow kfunc to return an allocated mem
Date:   Wed, 18 May 2022 22:59:09 +0200
Message-Id: <20220518205924.399291-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a kfunc is not returning a pointer to a struct but to a plain type,
we can consider it is a valid allocated memory assuming that:
- one of the arguments is called rdonly_buf_size
- or one of the arguments is called rdwr_buf_size
- and this argument is a const from the caller point of view

We can then use this parameter as the size of the allocated memory.

The memory is either read-only or read-write based on the name
of the size parameter.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v5:
- updated PTR_TO_MEM comment in btf.c to match upstream
- make it read-only or read-write based on the name of size

new in v4
---
 include/linux/btf.h   |  7 +++++
 kernel/bpf/btf.c      | 41 +++++++++++++++++++++++-
 kernel/bpf/verifier.c | 72 +++++++++++++++++++++++++++++++++----------
 3 files changed, 102 insertions(+), 18 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 2611cea2c2b6..2a4feafc083e 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -343,6 +343,13 @@ static inline struct btf_param *btf_params(const struct btf_type *t)
 	return (struct btf_param *)(t + 1);
 }
 
+struct bpf_reg_state;
+
+bool btf_is_kfunc_arg_mem_size(const struct btf *btf,
+			       const struct btf_param *arg,
+			       const struct bpf_reg_state *reg,
+			       const char *name);
+
 #ifdef CONFIG_BPF_SYSCALL
 struct bpf_prog;
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7bccaa4646e5..2d11d178807c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6049,6 +6049,31 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
 	return true;
 }
 
+bool btf_is_kfunc_arg_mem_size(const struct btf *btf,
+			       const struct btf_param *arg,
+			       const struct bpf_reg_state *reg,
+			       const char *name)
+{
+	int len, target_len = strlen(name);
+	const struct btf_type *t;
+	const char *param_name;
+
+	t = btf_type_skip_modifiers(btf, arg->type, NULL);
+	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
+		return false;
+
+	param_name = btf_name_by_offset(btf, arg->name_off);
+	if (str_is_empty(param_name))
+		return false;
+	len = strlen(param_name);
+	if (len != target_len)
+		return false;
+	if (strncmp(param_name, name, target_len))
+		return false;
+
+	return true;
+}
+
 static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    const struct btf *btf, u32 func_id,
 				    struct bpf_reg_state *regs,
@@ -6198,7 +6223,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			if (reg->type == PTR_TO_BTF_ID) {
 				reg_btf = reg->btf;
 				reg_ref_id = reg->btf_id;
-				/* Ensure only one argument is referenced PTR_TO_BTF_ID */
+				/* Ensure only one argument is reference PTR_TO_BTF_ID or PTR_TO_MEM */
 				if (reg->ref_obj_id) {
 					if (ref_obj_id) {
 						bpf_log(log, "verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
@@ -6258,6 +6283,20 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 					i++;
 					continue;
 				}
+
+				if (rel && reg->ref_obj_id) {
+					/* Ensure only one argument is referenced PTR_TO_BTF_ID or PTR_TO_MEM */
+					if (ref_obj_id) {
+						bpf_log(log,
+							"verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
+							regno,
+							reg->ref_obj_id,
+							ref_obj_id);
+						return -EFAULT;
+					}
+					ref_regno = regno;
+					ref_obj_id = reg->ref_obj_id;
+				}
 			}
 
 			resolve_ret = btf_resolve_size(btf, ref_t, &type_size);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9b59581026f8..084319073064 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7219,13 +7219,14 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 			    int *insn_idx_p)
 {
 	const struct btf_type *t, *func, *func_proto, *ptr_type;
-	struct bpf_reg_state *regs = cur_regs(env);
+	struct bpf_reg_state *reg, *regs = cur_regs(env);
 	const char *func_name, *ptr_type_name;
-	u32 i, nargs, func_id, ptr_type_id;
+	u32 i, nargs, func_id, ptr_type_id, regno;
 	int err, insn_idx = *insn_idx_p;
 	const struct btf_param *args;
 	struct btf *desc_btf;
 	bool acq;
+	size_t reg_rw_size = 0, reg_ro_size = 0;
 
 	/* skip for now, but return error when we find this in fixup_kfunc_call */
 	if (!insn->imm)
@@ -7266,8 +7267,8 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		}
 	}
 
-	for (i = 0; i < CALLER_SAVED_REGS; i++)
-		mark_reg_not_init(env, regs, caller_saved[i]);
+	/* reset REG_0 */
+	mark_reg_not_init(env, regs, BPF_REG_0);
 
 	/* Check return type */
 	t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
@@ -7277,6 +7278,9 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		return -EINVAL;
 	}
 
+	nargs = btf_type_vlen(func_proto);
+	args = btf_params(func_proto);
+
 	if (btf_type_is_scalar(t)) {
 		mark_reg_unknown(env, regs, BPF_REG_0);
 		mark_btf_func_reg_size(env, BPF_REG_0, t->size);
@@ -7284,24 +7288,57 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		ptr_type = btf_type_skip_modifiers(desc_btf, t->type,
 						   &ptr_type_id);
 		if (!btf_type_is_struct(ptr_type)) {
-			ptr_type_name = btf_name_by_offset(desc_btf,
-							   ptr_type->name_off);
-			verbose(env, "kernel function %s returns pointer type %s %s is not supported\n",
-				func_name, btf_type_str(ptr_type),
-				ptr_type_name);
-			return -EINVAL;
+			/* if we have an array, look for the arguments */
+			for (i = 0; i < nargs; i++) {
+				regno = i + BPF_REG_1;
+				reg = &regs[regno];
+
+				/* look for any const scalar parameter of name "rdonly_buf_size"
+				 * or "rdwr_buf_size"
+				 */
+				if (!check_reg_arg(env, regno, SRC_OP) &&
+				    tnum_is_const(regs[regno].var_off)) {
+					if (btf_is_kfunc_arg_mem_size(desc_btf, &args[i], reg,
+								      "rdonly_buf_size"))
+						reg_ro_size = regs[regno].var_off.value;
+					else if (btf_is_kfunc_arg_mem_size(desc_btf, &args[i], reg,
+									   "rdwr_buf_size"))
+						reg_rw_size = regs[regno].var_off.value;
+				}
+			}
+
+			if (!reg_rw_size && !reg_ro_size) {
+				ptr_type_name = btf_name_by_offset(desc_btf,
+								   ptr_type->name_off);
+				verbose(env,
+					"kernel function %s returns pointer type %s %s is not supported\n",
+					func_name,
+					btf_type_str(ptr_type),
+					ptr_type_name);
+				return -EINVAL;
+			}
+
+			mark_reg_known_zero(env, regs, BPF_REG_0);
+			regs[BPF_REG_0].type = PTR_TO_MEM;
+			regs[BPF_REG_0].mem_size = reg_ro_size + reg_rw_size;
+
+			if (reg_ro_size)
+				regs[BPF_REG_0].type |= MEM_RDONLY;
+		} else {
+			mark_reg_known_zero(env, regs, BPF_REG_0);
+			regs[BPF_REG_0].type = PTR_TO_BTF_ID;
+			regs[BPF_REG_0].btf = desc_btf;
+			regs[BPF_REG_0].btf_id = ptr_type_id;
+			mark_btf_func_reg_size(env, BPF_REG_0, sizeof(void *));
 		}
-		mark_reg_known_zero(env, regs, BPF_REG_0);
-		regs[BPF_REG_0].btf = desc_btf;
-		regs[BPF_REG_0].type = PTR_TO_BTF_ID;
-		regs[BPF_REG_0].btf_id = ptr_type_id;
+
 		if (btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog),
 					      BTF_KFUNC_TYPE_RET_NULL, func_id)) {
 			regs[BPF_REG_0].type |= PTR_MAYBE_NULL;
 			/* For mark_ptr_or_null_reg, see 93c230e3f5bd6 */
 			regs[BPF_REG_0].id = ++env->id_gen;
 		}
-		mark_btf_func_reg_size(env, BPF_REG_0, sizeof(void *));
+
 		if (acq) {
 			int id = acquire_reference_state(env, insn_idx);
 
@@ -7312,8 +7349,9 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		}
 	} /* else { add_kfunc_call() ensures it is btf_type_is_void(t) } */
 
-	nargs = btf_type_vlen(func_proto);
-	args = (const struct btf_param *)(func_proto + 1);
+	for (i = 1 ; i < CALLER_SAVED_REGS; i++)
+		mark_reg_not_init(env, regs, caller_saved[i]);
+
 	for (i = 0; i < nargs; i++) {
 		u32 regno = i + 1;
 
-- 
2.36.1

