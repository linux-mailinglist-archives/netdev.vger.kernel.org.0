Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE564409B4
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 16:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhJ3Osz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbhJ3Osy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 10:48:54 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D657BC061714;
        Sat, 30 Oct 2021 07:46:24 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n23so2102557pgh.8;
        Sat, 30 Oct 2021 07:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YyYFm5Tomuqv/g/CrPvf3UBGFMsvww/nAZqEewvU2+E=;
        b=QbH0CzUSptfrPUivo73LhZehDwopYqUdPCDLjn/o3CQreXcNxq2kb/rU8jk67izvju
         yeE66oNPS74bEAbUCt1f3TIH112r1EGD6JCDmngQel9lpgEVIQC70TL0kLHLC3VAa6aa
         sFIqyBW0feEwt7qUwJtsxeNwZKkitWtwmFR2mElMyNb0gvW3P7Wexs1N48UZ2GHRQ9Zx
         Pt//1Q/MLCZ2L/qUEfzFG/ihoEaUZvrLMn2ySboQpgZ4qsSzCp7Kv9b/8aDRMBNUXI61
         uxagKwy8VoXC58ddt0jZ5BJBHFaC0XtXOukIm8qiSse7lnivW6kleS0g7GrrnN6/hzYY
         MhSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YyYFm5Tomuqv/g/CrPvf3UBGFMsvww/nAZqEewvU2+E=;
        b=WZmC14FcfjG+rW4r0h5y+YdeXvdHBlbGdsb06iBShG7MOGAvVrqrYv8eTcjLOaYcQs
         HNOrT2sh7+bDKsG9qlsw/uO1zJE5wIDXTc4WP9ofXGlzgUVzOjPVhffec4miF7rXYNa0
         8GwU4+IDwX0KUKiqQl7ru9E0toriSoEvRVGiaAIV+zl/qVpLsDwGqM+1716VEL99mLQ/
         KAu5vhPVAplr7PXAyvEulUAatghv0MRmSLEfONhi1ne4kVKZFrC8NJUVEKqVndvfGGYU
         i2/f3jGUa74CY9UhUoe0rBcma/ol+6uVZTE5MvuQna3B8UeynC5dMbJWK/oOgA2kdGpz
         mxAA==
X-Gm-Message-State: AOAM532NZF23DB2tthIpzbpw5z07S6i+9o7T9LZ9S0+tY+yD/w9IxOy7
        SSVz/Oo93wDDh9serB83Fu/8glhGjjtBLg==
X-Google-Smtp-Source: ABdhPJzK/BLLA0Z6itUHyT9KmVPlpemsuU7QWtwkW1biP9tn7R+wxm1NOlYugpI1S4/UDdreLg7PGg==
X-Received: by 2002:a05:6a00:114c:b0:47b:b98b:2210 with SMTP id b12-20020a056a00114c00b0047bb98b2210mr17670174pfm.75.1635605184126;
        Sat, 30 Oct 2021 07:46:24 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id o13sm11726972pfu.90.2021.10.30.07.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 07:46:23 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH RFC bpf-next v1 4/6] bpf: Add reference tracking support to kfunc returned PTR_TO_BTF_ID
Date:   Sat, 30 Oct 2021 20:16:07 +0530
Message-Id: <20211030144609.263572-5-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211030144609.263572-1-memxor@gmail.com>
References: <20211030144609.263572-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=15333; h=from:subject; bh=FqdTHN3WxXSP4SooidhCnqXwA3YrFpC9k8/cgcMBE64=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhfVoRTzHYuT4gXQaTu0Fun8CRrgtUXDU7D0CrKmcr 6R6chbqJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYX1aEQAKCRBM4MiGSL8Ryt66D/ 0esQSUVcd7yf+FkFnui+45G+yiwOSctI2BgXZCqWDzXxLugmnsTyLww/EHKWiXn3ohB1hZGHFQqHWI NjmnCyIlYsEzd+oYJesTsxKTWNQkpgzK7PVmhp5MVh7PVbC5bBgjgT/wwp368gJaCyvsWf1ibrsjbW EsTtddjZZT8ZlHJ6uttLOVK+UvYvc24czURqP57rENHNnxhjUBQjAyUPu7hyk0IpaK5heKvt5Jnqwa Bu16jQvN8fvA0T8uhU0DSjYm53367HnwG7UfeZ+T2f5lG50xgLH6i5HkMGcg277No5JVL+pjg/aOBr 9AvE2MAh7roEBcfhaEqRA5ecga7q5as3ndjdtqWcaHM6baq1e6yQ4w0sP9FY2Rp9qX3FMd55/JyPwm CdJATZTXvlBENlgQQnQ0zY6qksCLJm6BpNXZi+rAblWJ27seEHw0G474nw+2SDT/e/dJBzPjKL7bKr 1fJc+Uxz3vvH897VlsNu19hwci2ZnMWyZZu+jZmxLW2/YFfFBpjxq63df2mXi84ryMsmeBReA86l95 j86RAQrs4RDggaVt4X6hLc/EB3XCioibcllDC0P0ppZi2P/JaqCOgc/9kL0hudDiSf15W5ANze726h CFxee7hxlMpsZb/qjcIA1LOUhG3bZLJf3ZvHIObqyG+gZYKR6dyAo5VFoY4Q==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds verifier support for PTR_TO_BTF_ID return type of kfunc
to be a reference, by reusing acquire_reference/release_reference
support for existing in-kernel bpf helpers.

A callback in the module kfunc_btf_id_set is added so that they can
report to the verifier whether a given kfunc_id, module pair is an
acquire/release kfunc, and track state of returned PTR_TO_BTF_ID
accordingly.

For now, we also add get_kfunc_return_type, since we don't need the
entire bpf_func_proto. The enforcement is only done in case a valid
return type is returned. __BPF_RET_TYPE_MAX is used by default to 'skip'
the check when it isn't needed by the kfunc.

The following restrictions exist for acquire function currently:
Only PTR_TO_BTF_ID or PTR_TO_BTF_ID_OR_NULL can be the return value.

The following restrictions exist for release function currently:
Only one PTR_TO_BTF_ID may be referenced.

An error is returned from verifier if they are broken. Later tests
ensure reference needs to be released if obtained using an acquire
kfunc. Right now, PTR_TO_BTF_ID is not passed to any existing built-in
relase helpers. Once this changes, an additional check for the
reg->btf_id is needed to ensure it is the right BTF ID that is being
released. If the same BTF ID's PTR_TO_BTF_ID may be passed to different
release functions in the future, additional state needs to be tracked
for the register so that it can be paired with the correct release
function.

For now, we can rely on the btf_struct_ids_match check to ensure we get
the pointer to the expected struct type.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h   |  4 ++
 include/linux/btf.h   | 49 ++++++++++++++++++++++
 kernel/bpf/btf.c      | 95 +++++++++++++++++++++++++++++++++++++++++-
 kernel/bpf/verifier.c | 97 ++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 238 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f8be80f748fc..6fb34f0a2758 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -359,6 +359,7 @@ enum bpf_return_type {
 	RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL, /* returns a pointer to a valid memory or a btf_id or NULL */
 	RET_PTR_TO_MEM_OR_BTF_ID,	/* returns a pointer to a valid memory or a btf_id */
 	RET_PTR_TO_BTF_ID,		/* returns a pointer to a btf_id */
+	__BPF_RET_TYPE_MAX,
 };
 
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
@@ -515,6 +516,9 @@ struct bpf_verifier_ops {
 				 enum bpf_access_type atype,
 				 u32 *next_btf_id);
 	bool (*check_kfunc_call)(u32 kfunc_btf_id, struct module *owner);
+	bool (*is_acquire_kfunc)(u32 kfunc_btf_id, struct module *owner);
+	bool (*is_release_kfunc)(u32 kfunc_btf_id, struct module *owner);
+	enum bpf_return_type (*get_kfunc_return_type)(u32 kfunc_btf_id, struct module *owner);
 };
 
 struct bpf_prog_offload_ops {
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 1da108e35042..464f22bf7d5f 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -4,6 +4,7 @@
 #ifndef _LINUX_BTF_H
 #define _LINUX_BTF_H 1
 
+#include <linux/bpf.h>
 #include <linux/types.h>
 #include <linux/bpfptr.h>
 #include <uapi/linux/btf.h>
@@ -243,6 +244,15 @@ struct kfunc_btf_id_set {
 	struct list_head list;
 	struct btf_id_set *set;
 	struct module *owner;
+
+	bool (*is_acquire_kfunc)(u32 kfunc_id);
+	bool (*is_release_kfunc)(u32 kfunc_id);
+	enum bpf_return_type (*get_kfunc_return_type)(u32 kfunc_id);
+	int  (*btf_struct_access)(struct bpf_verifier_log *log,
+				  const struct btf *btf,
+				  const struct btf_type *t, int off,
+				  int size, enum bpf_access_type atype,
+				  u32 *next_btf_id);
 };
 
 struct kfunc_btf_id_list;
@@ -254,6 +264,19 @@ void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 				 struct kfunc_btf_id_set *s);
 bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 			      struct module *owner);
+bool bpf_is_mod_acquire_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner);
+bool bpf_is_mod_release_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner);
+enum bpf_return_type bpf_get_mod_kfunc_return_type(struct kfunc_btf_id_list *klist,
+						   u32 kfunc_btf_id, struct module *owner);
+int bpf_btf_mod_struct_access(struct kfunc_btf_id_list *klist,
+			      struct module *owner,
+			      struct bpf_verifier_log *log,
+			      const struct btf *btf,
+			      const struct btf_type *t, int off,
+			      int size, enum bpf_access_type atype,
+			      u32 *next_btf_id);
 #else
 static inline void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 					     struct kfunc_btf_id_set *s)
@@ -268,6 +291,32 @@ static inline bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist,
 {
 	return false;
 }
+static inline bool bpf_is_mod_acquire_kfunc(struct kfunc_btf_id_list *klist,
+					    u32 kfunc_id, struct module *owner)
+{
+	return false;
+}
+static inline bool bpf_is_mod_release_kfunc(struct kfunc_btf_id_list *klist,
+					    u32 kfunc_id, struct module *owner)
+{
+	return false;
+}
+static inline enum bpf_return_type
+bpf_get_mod_kfunc_return_type(struct kfunc_btf_id_list *klist, u32 kfunc_btf_id,
+			      struct module *owner);
+{
+	return __BPF_RET_TYPE_MAX;
+}
+static inline int bpf_btf_mod_struct_access(struct kfunc_btf_id_list *klist,
+					    struct module *owner,
+					    struct bpf_verifier_log *log,
+					    const struct btf *btf,
+					    const struct btf_type *t, int off,
+					    int size, enum bpf_access_type atype,
+					    u32 *next_btf_id)
+{
+	return __BPF_REG_TYPE_MAX;
+}
 #endif
 
 extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 9099ef64b077..8b3c15f4359d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5570,10 +5570,12 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    struct module *btf_mod)
 {
 	struct bpf_verifier_log *log = &env->log;
+	u32 i, nargs, ref_id, ref_obj_id = 0;
 	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
 	const struct btf_param *args;
-	u32 i, nargs, ref_id;
+	int ref_regno = 0;
+	bool rel = false;
 
 	t = btf_type_by_id(btf, func_id);
 	if (!t || !btf_type_is_func(t)) {
@@ -5646,6 +5648,17 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
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
+					/* Allow passing referenced PTR_TO_BTF_ID to acquire function */
+					ref_regno = regno;
+					ref_obj_id = reg->ref_obj_id;
+				}
 			} else if (reg2btf_ids[reg->type]) {
 				reg_btf = btf_vmlinux;
 				reg_ref_id = *reg2btf_ids[reg->type];
@@ -5691,7 +5704,24 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		}
 	}
 
-	return 0;
+	if (btf_is_kernel(btf)) {
+		rel = env->ops->is_release_kfunc &&
+			env->ops->is_release_kfunc(func_id, btf_mod);
+
+		/* We make sure ref_obj_id is only set if only one reg->type == PTR_TO_BTF_ID */
+		if (rel && !ref_obj_id) {
+			bpf_log(log, "release kernel function %s expects refcounted PTR_TO_BTF_ID\n",
+				func_name);
+			return -EINVAL;
+		}
+		if (!rel && ref_obj_id) {
+			bpf_log(log, "refcounted PTR_TO_BTF_ID passed to non-release kernel function %s\n",
+				func_name);
+			return -EINVAL;
+		}
+	}
+	/* returns argument register number > 0 in case of reference release kfunc */
+	return ref_regno;
 }
 
 /* Compare BTF of a function with given bpf_reg_state.
@@ -6402,6 +6432,67 @@ bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 	return ret;
 }
 
+bool bpf_is_mod_acquire_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	struct kfunc_btf_id_set *s;
+	bool ret = false;
+
+	s = __get_kfunc_btf_id_set(klist, owner);
+	if (s) {
+		ret = s->is_acquire_kfunc &&
+		      s->is_acquire_kfunc(kfunc_id);
+	}
+	return ret;
+}
+
+bool bpf_is_mod_release_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	struct kfunc_btf_id_set *s;
+	bool ret = false;
+
+	s = __get_kfunc_btf_id_set(klist, owner);
+	if (s) {
+		ret = s->is_release_kfunc &&
+		      s->is_release_kfunc(kfunc_id);
+	}
+	return ret;
+}
+
+enum bpf_return_type bpf_get_mod_kfunc_return_type(struct kfunc_btf_id_list *klist,
+						   u32 kfunc_id, struct module *owner)
+{
+	enum bpf_return_type ret_type = __BPF_RET_TYPE_MAX;
+	struct kfunc_btf_id_set *s;
+
+	s = __get_kfunc_btf_id_set(klist, owner);
+	if (s) {
+		if (s->get_kfunc_return_type)
+			ret_type = s->get_kfunc_return_type(kfunc_id);
+	}
+	return ret_type;
+}
+
+int bpf_btf_mod_struct_access(struct kfunc_btf_id_list *klist,
+			      struct module *owner,
+			      struct bpf_verifier_log *log,
+			      const struct btf *btf,
+			      const struct btf_type *t, int off,
+			      int size, enum bpf_access_type atype,
+			      u32 *next_btf_id)
+{
+	struct kfunc_btf_id_set *s;
+
+	s = __get_kfunc_btf_id_set(klist, owner);
+	if (s) {
+		if (s->btf_struct_access)
+			return s->btf_struct_access(log, btf, t, off, size, atype,
+						    next_btf_id);
+	}
+	return __BPF_REG_TYPE_MAX;
+}
+
 #endif
 
 #define DEFINE_KFUNC_BTF_ID_LIST(name)                                         \
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ca4627f81b75..4ac091a946c2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5789,6 +5789,28 @@ static int check_func_proto(const struct bpf_func_proto *fn, int func_id)
 	       check_refcount_ok(fn, func_id) ? 0 : -EINVAL;
 }
 
+static int check_kfunc_proto(struct bpf_verifier_env *env,
+			     enum bpf_return_type ret_type, u32 kfunc_id,
+			     bool acquire)
+{
+	switch (ret_type) {
+	case RET_VOID:
+	case RET_INTEGER:
+	case RET_PTR_TO_BTF_ID:
+	case RET_PTR_TO_BTF_ID_OR_NULL:
+	case __BPF_RET_TYPE_MAX:
+		break;
+	default:
+		verbose(env, "kfunc %u unsupported return type %d\n", kfunc_id,
+			ret_type);
+		return -EINVAL;
+	}
+	/* refcount_ok check is done later in bpf_check_kfunc_arg_match,
+	 * as only PTR_TO_BTF_ID can be refcounted
+	 */
+	return 0;
+}
+
 /* Packet data might have moved, any old PTR_TO_PACKET[_META,_END]
  * are now invalid, so turn them into unknown SCALAR_VALUE.
  */
@@ -6681,16 +6703,19 @@ static void mark_btf_func_reg_size(struct bpf_verifier_env *env, u32 regno,
 	}
 }
 
-static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
+static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
+			    int *insn_idx_p)
 {
 	const struct btf_type *t, *func, *func_proto, *ptr_type;
+	enum bpf_return_type ret_type = __BPF_RET_TYPE_MAX;
 	struct bpf_reg_state *regs = cur_regs(env);
 	const char *func_name, *ptr_type_name;
 	u32 i, nargs, func_id, ptr_type_id;
+	int err, insn_idx = *insn_idx_p;
 	struct module *btf_mod = NULL;
 	const struct btf_param *args;
+	bool acq, ret = false;
 	struct btf *desc_btf;
-	int err;
 
 	/* skip for now, but return error when we find this in fixup_kfunc_call */
 	if (!insn->imm)
@@ -6712,17 +6737,51 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		return -EACCES;
 	}
 
+	acq = env->ops->is_acquire_kfunc &&
+		env->ops->is_acquire_kfunc(func_id, btf_mod);
+
+	if (env->ops->get_kfunc_return_type) {
+		ret_type = env->ops->get_kfunc_return_type(func_id, btf_mod);
+		err = check_kfunc_proto(env, ret_type, func_id, acq);
+		if (err)
+			return err;
+		/* Skip check if not specified */
+		ret = ret_type != __BPF_RET_TYPE_MAX;
+	}
+
 	/* Check the arguments */
 	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs, btf_mod);
 	if (err < 0)
 		return err;
+	/* In case of release function, we get register number of refcounted
+	 * PTR_TO_BTF_ID back from kfunc_arg_match, do the release now
+	 */
+	if (err > 0) {
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
+	/* allow helper to return refcounted PTR_TO_BTF_ID */
+	if (acq && !btf_type_is_ptr(t)) {
+		verbose(env, "acquire kernel function returns non-PTR_TO_BTF_ID\n");
+		return -EINVAL;
+	}
+
 	if (btf_type_is_scalar(t)) {
+		if (ret && ret_type != RET_INTEGER) {
+			verbose(env, "kfunc %s#%d func_proto ret type mismatch\n",
+				func_name, func_id);
+			return -EINVAL;
+		}
 		mark_reg_unknown(env, regs, BPF_REG_0);
 		mark_btf_func_reg_size(env, BPF_REG_0, t->size);
 	} else if (btf_type_is_ptr(t)) {
@@ -6736,12 +6795,40 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 				ptr_type_name);
 			return -EINVAL;
 		}
+		if (ret && ret_type != RET_PTR_TO_BTF_ID_OR_NULL &&
+		    ret_type != RET_PTR_TO_BTF_ID) {
+			verbose(env, "kfunc %s#%d func_proto ret type mismatch\n",
+				func_name, func_id);
+			return -EINVAL;
+		}
+
+		if (ret && ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
+			regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
+			/* When more return types support _OR_NULL, move this
+			 * under a generic reg_type_may_be_null check.
+			 */
+			regs[BPF_REG_0].id = ++env->id_gen;
+		} else {
+			regs[BPF_REG_0].type = PTR_TO_BTF_ID;
+		}
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].btf = desc_btf;
-		regs[BPF_REG_0].type = PTR_TO_BTF_ID;
 		regs[BPF_REG_0].btf_id = ptr_type_id;
 		mark_btf_func_reg_size(env, BPF_REG_0, sizeof(void *));
-	} /* else { add_kfunc_call() ensures it is btf_type_is_void(t) } */
+		if (acq) {
+			int id = acquire_reference_state(env, insn_idx);
+
+			if (id < 0)
+				return id;
+			regs[BPF_REG_0].id = id;
+			regs[BPF_REG_0].ref_obj_id = id;
+		}
+	} else if (ret && ret_type != RET_VOID) {
+		/* add_kfunc_call() ensures it is btf_type_is_void(t) */
+		verbose(env, "kfunc %s#%d func_proto ret type mismatch\n",
+			func_name, func_id);
+		return -EINVAL;
+	}
 
 	nargs = btf_type_vlen(func_proto);
 	args = (const struct btf_param *)(func_proto + 1);
@@ -11308,7 +11395,7 @@ static int do_check(struct bpf_verifier_env *env)
 				if (insn->src_reg == BPF_PSEUDO_CALL)
 					err = check_func_call(env, insn, &env->insn_idx);
 				else if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL)
-					err = check_kfunc_call(env, insn);
+					err = check_kfunc_call(env, insn, &env->insn_idx);
 				else
 					err = check_helper_call(env, insn, &env->insn_idx);
 				if (err)
-- 
2.33.1

