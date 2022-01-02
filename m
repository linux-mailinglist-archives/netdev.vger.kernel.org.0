Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F7B482BFF
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiABQVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbiABQVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:21:38 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD212C0617A0;
        Sun,  2 Jan 2022 08:21:36 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id v13-20020a17090a088d00b001b0e3a74cf7so19747565pjc.1;
        Sun, 02 Jan 2022 08:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=67igwO3AvPuCCyKg8OmpBm8+inp9C/h5Ug+RAcYXu5k=;
        b=BLBYG8IVg2hO2t0S0/X2FqINwOSC0oSyQEy2bxpxQpa+AmfD9tohAtk0ZFdztWdc8F
         i5FTaOck8253F6ycBlmO8B4lvxiSJi/cIXunO5RzcIVwX2TKscI7l5zLgyxCyBZB1gny
         OD7x9iodbcsA1OocQaZ5NCuDRAR/YEytBQ1IZorR3CQUbWcur0NKxpUOwiDhDDRqtz+K
         GiTMCcdIqIh5UkEcPhQPylbgIW1p4KKcSsqDBdXRJtOsvHlZyXrKu7oTtpwsoq1+zNnB
         XDBuXffAwaEG1LTDbXHK/F2YhUlG6Gp+Qd42kGY9sFm2u8OCZzWXqaFG28dRA+ZS+cn+
         e9IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=67igwO3AvPuCCyKg8OmpBm8+inp9C/h5Ug+RAcYXu5k=;
        b=2DY93OAQNM88sOe7QdS02EI/AaNV34bQhSieiBI6mxNMgC7bras1e9AT1QyBAuAYkD
         I3Q+liuiGFojVLIum3RzrKyb0/z29KWQOYbh4YltREn+DUsvpHZ7gwhi83OKA0+ub1++
         XYmxg8Ryty/jvZXQ4TD20knDU+ZNB+toZwzlgGoNPbp9dObAu2Js8h65URsVyS1+XZhq
         cHk/PXxX/7rsGr2FYOWVSr/VG/mpkpBcfOE835cHCgV9vWkLgc8RgT7MFDAXi3HRcxnP
         2evFPWCCL1pVzF4FHjOFym4grVQa2j2h/gZWBBXLfuYLyp+3QIMTJ3zbbXSNmpjOcPhL
         QrQg==
X-Gm-Message-State: AOAM5310jmPabMahXYxsnYy9nh61kQqwtX4LEqFI1JxrhbOX0EE4AxQv
        7Aez+M0szjlJnBIiDo/K7BW2GlTJ0Oc=
X-Google-Smtp-Source: ABdhPJxj4LeAGBo+xchNnulf/bWy6oovm9glbFETXDtACDR4rsKGNHAqEeBsPEU2pdcppVtUZSWwDg==
X-Received: by 2002:a17:902:aa92:b0:149:6e0b:18d0 with SMTP id d18-20020a170902aa9200b001496e0b18d0mr34267913plr.34.1641140496074;
        Sun, 02 Jan 2022 08:21:36 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id i4sm19052551pjj.30.2022.01.02.08.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 08:21:35 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v6 06/11] bpf: Add reference tracking support to kfunc
Date:   Sun,  2 Jan 2022 21:51:10 +0530
Message-Id: <20220102162115.1506833-7-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220102162115.1506833-1-memxor@gmail.com>
References: <20220102162115.1506833-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9960; h=from:subject; bh=0PynmyFCb9TW+CQOznb0qSlhoo7NLASfBANrZBnnnxQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh0dCK3LS6zQnNy62DhBtNsh50JYDfDL0ZZAr7TJ3Y VzDypT6JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYdHQigAKCRBM4MiGSL8Ryn1oEA CJ2tK0rcmG0dToEJP6DNDnIUSaBpqyM/hltrtLpcZnm/ayRd1s7995E0ElZzRAC2atJhkomC+nOM2B ohocabCJpgjCK0z0Qhx6T0fFy4gLbI5D2hjgovZ+SJK6V07h+y6rciZmWzmC20CsW2e7htTlTxSXqJ kjHKfkWP/LAMHkje6toX53wM7oegB81FWz/4Pl2LBccZ5LleuIt+whmv/oM7uR9RJYVO/y/WVFce/u PKldmg7T/CUwRBl9ZluhV91O+1lrSn1xuv8o6dyJSxNbgY0K/9UAsX576zCqW0SBiVc+fPx8U9Fv8T zQdUhQIZ9Qn9e2jc1wWsKVg/REMTK9krXIINM/idW0z8y+BjbXkOxeU+nXV9C818jjyfozNcJ1BnN2 zTEs8e/2sGG8jRsC29KWKcI1OddFC5ezlqaI0ueu8C4CIZu8KUfCx0A/JMsiQJClAC5MkT9D3NM7QB yj5TV7LczMlvRa3cpuNKcimHwzjCv1Mr1yYWMB9j6Q33K3hTpDoIjWbYuarIyPH/dldKMa5xPVIHCz SI4JI/pvtqRfwy/vxwd4fZ4KWOPKjqLWvFf/mWUhIHwSW7wyEFofnSCpGnMky8b/+xMjizMKa9pRXv hgW9rfknh1WHI8FtDCKzACH+Xnapq+mxmt3dcCH5ey98lTZv+xOsVmChXtUw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds verifier support for PTR_TO_BTF_ID return type of kfunc
to be a reference, by reusing acquire_reference_state/release_reference
support for existing in-kernel bpf helpers.

We make use of the three kfunc types:

- BTF_KFUNC_TYPE_ACQUIRE
  Return true if kfunc_btf_id is an acquire kfunc.  This will
  acquire_reference_state for the returned PTR_TO_BTF_ID (this is the
  only allow return value). Note that acquire kfunc must always return a
  PTR_TO_BTF_ID{_OR_NULL}, otherwise the program is rejected.

- BTF_KFUNC_TYPE_RELEASE
  Return true if kfunc_btf_id is a release kfunc.  This will release the
  reference to the passed in PTR_TO_BTF_ID which has a reference state
  (from earlier acquire kfunc).
  The btf_check_func_arg_match returns the regno (of argument register,
  hence > 0) if the kfunc is a release kfunc, and a proper referenced
  PTR_TO_BTF_ID is being passed to it.
  This is similar to how helper call check uses bpf_call_arg_meta to
  store the ref_obj_id that is later used to release the reference.
  Similar to in-kernel helper, we only allow passing one referenced
  PTR_TO_BTF_ID as an argument. It can also be passed in to normal
  kfunc, but in case of release kfunc there must always be one
  PTR_TO_BTF_ID argument that is referenced.

- BTF_KFUNC_TYPE_RET_NULL
  For kfunc returning PTR_TO_BTF_ID, tells if it can be NULL, hence
  force caller to mark the pointer not null (using check) before
  accessing it. Note that taking into account the case fixed by commit
  93c230e3f5bd ("bpf: Enforce id generation for all may-be-null register type")
  we assign a non-zero id for mark_ptr_or_null_reg logic. Later, if more
  return types are supported by kfunc, which have a _OR_NULL variant, it
  might be better to move this id generation under a common
  reg_type_may_be_null check, similar to the case in the commit.

Referenced PTR_TO_BTF_ID is currently only limited to kfunc, but can be
extended in the future to other BPF helpers as well.  For now, we can
rely on the btf_struct_ids_match check to ensure we get the pointer to
the expected struct type. In the future, care needs to be taken to avoid
ambiguity for reference PTR_TO_BTF_ID passed to release function, in
case multiple candidates can release same BTF ID.

e.g. there might be two release kfuncs (or kfunc and helper):

foo(struct abc *p);
bar(struct abc *p);

... such that both release a PTR_TO_BTF_ID with btf_id of struct abc. In
this case we would need to track the acquire function corresponding to
the release function to avoid type confusion, and store this information
in the register state so that an incorrect program can be rejected. This
is not a problem right now, hence it is left as an exercise for the
future patch introducing such a case in the kernel.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf_verifier.h |  5 ++++
 kernel/bpf/btf.c             | 32 ++++++++++++++++++++--
 kernel/bpf/verifier.c        | 52 +++++++++++++++++++++++++++++-------
 3 files changed, 77 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 857fd687bdc2..ac4797155412 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -566,4 +566,9 @@ static inline u32 type_flag(u32 type)
 	return type & ~BPF_BASE_TYPE_MASK;
 }
 
+static inline enum bpf_prog_type resolve_prog_type(struct bpf_prog *prog)
+{
+	return prog->aux->dst_prog ? prog->aux->dst_prog->type : prog->type;
+}
+
 #endif /* _LINUX_BPF_VERIFIER_H */
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 356e6af5b8ba..95ace8f6088c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5672,11 +5672,13 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    bool ptr_to_mem_ok)
 {
 	struct bpf_verifier_log *log = &env->log;
+	u32 i, nargs, ref_id, ref_obj_id = 0;
 	bool is_kfunc = btf_is_kernel(btf);
 	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
 	const struct btf_param *args;
-	u32 i, nargs, ref_id;
+	int ref_regno = 0;
+	bool rel = false;
 
 	t = btf_type_by_id(btf, func_id);
 	if (!t || !btf_type_is_func(t)) {
@@ -5754,6 +5756,16 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			if (reg->type == PTR_TO_BTF_ID) {
 				reg_btf = reg->btf;
 				reg_ref_id = reg->btf_id;
+				/* Ensure only one argument is referenced PTR_TO_BTF_ID */
+				if (reg->ref_obj_id) {
+					if (ref_obj_id) {
+						bpf_log(log, "verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
+							regno, reg->ref_obj_id, ref_obj_id);
+						return -EFAULT;
+					}
+					ref_regno = regno;
+					ref_obj_id = reg->ref_obj_id;
+				}
 			} else {
 				reg_btf = btf_vmlinux;
 				reg_ref_id = *reg2btf_ids[reg->type];
@@ -5824,7 +5836,23 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		}
 	}
 
-	return 0;
+	/* Either both are set, or neither */
+	WARN_ON_ONCE((ref_obj_id && !ref_regno) || (!ref_obj_id && ref_regno));
+	if (is_kfunc) {
+		rel = btf_kfunc_id_set_contains(btf, resolve_prog_type(env->prog),
+						BTF_KFUNC_TYPE_RELEASE, func_id);
+		/* We already made sure ref_obj_id is set only for one argument */
+		if (rel && !ref_obj_id) {
+			bpf_log(log, "release kernel function %s expects refcounted PTR_TO_BTF_ID\n",
+				func_name);
+			return -EINVAL;
+		}
+		/* Allow (!rel && ref_obj_id), so that passing such referenced PTR_TO_BTF_ID to
+		 * other kfuncs works
+		 */
+	}
+	/* returns argument register number > 0 in case of reference release kfunc */
+	return rel ? ref_regno : 0;
 }
 
 /* Compare BTF of a function with given bpf_reg_state.
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 80c9a2c00848..d492d9bc84f4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -452,7 +452,8 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
 {
 	return base_type(type) == PTR_TO_SOCKET ||
 		base_type(type) == PTR_TO_TCP_SOCK ||
-		base_type(type) == PTR_TO_MEM;
+		base_type(type) == PTR_TO_MEM ||
+		base_type(type) == PTR_TO_BTF_ID;
 }
 
 static bool type_is_rdonly_mem(u32 type)
@@ -3492,11 +3493,6 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
 
 #define MAX_PACKET_OFF 0xffff
 
-static enum bpf_prog_type resolve_prog_type(struct bpf_prog *prog)
-{
-	return prog->aux->dst_prog ? prog->aux->dst_prog->type : prog->type;
-}
-
 static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
 				       const struct bpf_call_arg_meta *meta,
 				       enum bpf_access_type t)
@@ -6830,15 +6826,17 @@ static void mark_btf_func_reg_size(struct bpf_verifier_env *env, u32 regno,
 	}
 }
 
-static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
+static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
+			    int *insn_idx_p)
 {
 	const struct btf_type *t, *func, *func_proto, *ptr_type;
 	struct bpf_reg_state *regs = cur_regs(env);
 	const char *func_name, *ptr_type_name;
 	u32 i, nargs, func_id, ptr_type_id;
+	int err, insn_idx = *insn_idx_p;
 	const struct btf_param *args;
 	struct btf *desc_btf;
-	int err;
+	bool acq;
 
 	/* skip for now, but return error when we find this in fixup_kfunc_call */
 	if (!insn->imm)
@@ -6860,16 +6858,36 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		return -EACCES;
 	}
 
+	acq = btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog),
+					BTF_KFUNC_TYPE_ACQUIRE, func_id);
+
 	/* Check the arguments */
 	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs);
-	if (err)
+	if (err < 0)
 		return err;
+	/* In case of release function, we get register number of refcounted
+	 * PTR_TO_BTF_ID back from btf_check_kfunc_arg_match, do the release now
+	 */
+	if (err) {
+		err = release_reference(env, regs[err].ref_obj_id);
+		if (err) {
+			verbose(env, "kfunc %s#%d reference has not been acquired before\n",
+				func_name, func_id);
+			return err;
+		}
+	}
 
 	for (i = 0; i < CALLER_SAVED_REGS; i++)
 		mark_reg_not_init(env, regs, caller_saved[i]);
 
 	/* Check return type */
 	t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
+
+	if (acq && !btf_type_is_ptr(t)) {
+		verbose(env, "acquire kernel function does not return PTR_TO_BTF_ID\n");
+		return -EINVAL;
+	}
+
 	if (btf_type_is_scalar(t)) {
 		mark_reg_unknown(env, regs, BPF_REG_0);
 		mark_btf_func_reg_size(env, BPF_REG_0, t->size);
@@ -6888,7 +6906,21 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		regs[BPF_REG_0].btf = desc_btf;
 		regs[BPF_REG_0].type = PTR_TO_BTF_ID;
 		regs[BPF_REG_0].btf_id = ptr_type_id;
+		if (btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog),
+					      BTF_KFUNC_TYPE_RET_NULL, func_id)) {
+			regs[BPF_REG_0].type |= PTR_MAYBE_NULL;
+			/* For mark_ptr_or_null_reg, see 93c230e3f5bd6 */
+			regs[BPF_REG_0].id = ++env->id_gen;
+		}
 		mark_btf_func_reg_size(env, BPF_REG_0, sizeof(void *));
+		if (acq) {
+			int id = acquire_reference_state(env, insn_idx);
+
+			if (id < 0)
+				return id;
+			regs[BPF_REG_0].id = id;
+			regs[BPF_REG_0].ref_obj_id = id;
+		}
 	} /* else { add_kfunc_call() ensures it is btf_type_is_void(t) } */
 
 	nargs = btf_type_vlen(func_proto);
@@ -11529,7 +11561,7 @@ static int do_check(struct bpf_verifier_env *env)
 				if (insn->src_reg == BPF_PSEUDO_CALL)
 					err = check_func_call(env, insn, &env->insn_idx);
 				else if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL)
-					err = check_kfunc_call(env, insn);
+					err = check_kfunc_call(env, insn, &env->insn_idx);
 				else
 					err = check_helper_call(env, insn, &env->insn_idx);
 				if (err)
-- 
2.34.1

