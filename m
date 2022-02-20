Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4C84BCECB
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243916AbiBTNtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:49:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbiBTNtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:49:15 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD45A5372F;
        Sun, 20 Feb 2022 05:48:50 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id ay3so2025175plb.1;
        Sun, 20 Feb 2022 05:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Q14rygOKMclDll68ZrHDbgA4+wt3Mqwy9mZaIvZEmI=;
        b=M5z9ctX8K6E3UiaA41YI1MdPb2rdzWRXOnf8QI81KHSF5MzCDG8GNO4QwSyGSomDmN
         ajNjpwKARTL+3jMlL+KA+FihFUIHIsGqO4gUWTycUkpgA+sBvraenlHBPS45eIlnQlts
         BDmPUxwiXXzh+WDiLAfS6ReI3V3y+eqbgKXUKrZSAH4yGYE80IKsaaqMOb0LS2J4jDqB
         J8BUQN19VDlJT55G2l6u/PjcK2PBiv4Gou+vsh0Au6c/EXjbqKv4mhtxSFG8CWigdVth
         fCu3urU//cXmwvpHOyLPGTVRVx6fRp16bi+RjWvSqQc4aQaUid3r2/VRArYb2O0LFlx9
         Z4JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Q14rygOKMclDll68ZrHDbgA4+wt3Mqwy9mZaIvZEmI=;
        b=2OJ2foVVRrFObra9r8tZE3SBNH4H1Xcl5Ek2hsaQSFGXd7jeX89t4DspSCOhpJJMNp
         p4SR/BCByArwQzb9qo4MQe2773S8xsH50lZs5cznz/owHK2+uNgpbPK49dKj00jqt3iU
         AzLhcky4ntpNRdJkAQ89pZxraRoagfTH0in18Gl9zt2BtxcTMo/ZMEhBOJza5UlWYf6B
         hAp93uKWFVL3Cnje4YQ1szjLqeiu5K5/snhuupFtKakT7dWZv1ePVc8mZz+o6Uvgdd5O
         ktLn4OQemcMimfSM4gI7iscnwBEQzEK0W7ocj2XLtsfuiMjzCfSP79pdOf9IZPCVp92p
         M7aw==
X-Gm-Message-State: AOAM532EmVP53zevxKfJmwcrKxsGZPjGOTu9R3Ix1Me9j07q7nRCAtbW
        JCRTgCx3+6VmZksCqE9BdwnDKcX/24s=
X-Google-Smtp-Source: ABdhPJwdurat6QWsciAeBP7Ynt5zJUf36065WRGFBlph0iLcgl2YxnuGMSqANoWi6L4NUnWU3lZ3fA==
X-Received: by 2002:a17:902:db0f:b0:14d:d55b:672b with SMTP id m15-20020a170902db0f00b0014dd55b672bmr14942500plx.133.1645364930094;
        Sun, 20 Feb 2022 05:48:50 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id g5sm9448829pfv.22.2022.02.20.05.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:49 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 11/15] bpf: Teach verifier about kptr_get style kfunc helpers
Date:   Sun, 20 Feb 2022 19:18:09 +0530
Message-Id: <20220220134813.3411982-12-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6273; h=from:subject; bh=C1Xbvo2hE9/7Vk7v/zS8Ww0BWodVX2dWBBWQaiWPd0s=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZYPCub+KJBJZqjtTBGAAbbHFVkGbQhUubZG0Sa CHycgfGJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGWAAKCRBM4MiGSL8Rym7pD/ 9S+gKDCU+FaLesksSvbW9eyhWrFDsLG57y1lykUkptQIJZRA9zhED5D2fQb4DwZPDb/SX2ecnDK86G lR4aZsxewx9OUGY6QhthsCN5BLX0pTMYzLREHSePmKATZ9OopwOjugxvolEuSMPxdKUnoZf2pZzbFg aFpxyvN93RHqKln7hDWDjGCc1+txFnfKur1HcTwbB+No5NCon2zIRB6MW6/IGj4wBD/YX3t5o0igZR 968qIlRzIUhDLG65LiTnVcEYyOFWkXFfM58LbP9YE1FxKcio/6zrlcjK2HGeCXQhUCj/SMXgYwshh5 etx1ZlLXKE2WO+qWslQkbgaxcp2A83a+wf/zJaOBCXwxWuPErRhlBK8Y2+ngtHFO3LSKqDpvMzfH7G YkVs78j1KPt1aTgXoY1mCTGk29jmGRK0+gsiyongP/+l0+gu+endv6ojwGg+Z649N7tCnxeZO0X8g9 QgkwANOYM11zfMKFtTNiq0Ai9ToatEy0hJD7tt/UZISg/1ectuBJRUvKmXpD8kiIz3VANld6hXuPeP XroB4SLFZqy2zXe4+ev8jV1F78T8MXKoizbyDD6ajd0NPWUB/VWD6fq86JX8EoCt+jUWiXAw1W0rPP 8Af9JhvjR4cwimy7+eNUsMdOapPcfEpKoNiM9cCNyo6T59PiU1/f+M3AX26Q==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We introduce a new style of kfunc helpers, namely *_kptr_get, where they
take pointer to the map value which points to a referenced kernel
pointer contained in the map. Since this is referenced, only BPF_XCHG
from kernel and BPF side is allowed to change the current value, and
each pointer that resides in that location would be referenced, and RCU
protected (must be kept in mind while adding kernel types embeddable as
reference kptr in BPF maps).

This means that if do the load of the pointer value in an RCU read
section, and find a live pointer, then as long as we hold RCU read lock,
it won't be freed by a parallel xchg + release operation. This allows us
to implement a safe refcount increment scheme. Hence, enforce that first
argument of all such kfunc is a proper PTR_TO_MAP_VALUE pointing at the
right offset to referenced pointer.

For the rest of the arguments, they are subjected to typical kfunc
argument checks, hence allowing some flexibility in passing more intent
into how the reference should be taken.

For instance, in case of struct nf_conn, it is not freed until all RCU
grace period ends, but can still be reused for another tuple once
refcount has dropped to zero. Hence, a bpf_ct_kptr_get helper not only
needs to call refcount_inc_not_zero, but also do a tuple match after
incrementing the reference, and when it fails to match it, put the
reference again and return NULL.

This can be implemented easily if we allow passing additional parameters
to the bpf_ct_kptr_get kfunc, like a struct bpf_sock_tuple * and a
tuple__sz pair.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h   |  2 ++
 kernel/bpf/btf.c      | 48 +++++++++++++++++++++++++++++++++++++++++--
 kernel/bpf/verifier.c |  9 ++++----
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index c7e75be9637f..10918ac0e55f 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -17,6 +17,7 @@ enum btf_kfunc_type {
 	BTF_KFUNC_TYPE_ACQUIRE,
 	BTF_KFUNC_TYPE_RELEASE,
 	BTF_KFUNC_TYPE_RET_NULL,
+	BTF_KFUNC_TYPE_KPTR_ACQUIRE,
 	BTF_KFUNC_TYPE_MAX,
 };
 
@@ -36,6 +37,7 @@ struct btf_kfunc_id_set {
 			struct btf_id_set *acquire_set;
 			struct btf_id_set *release_set;
 			struct btf_id_set *ret_null_set;
+			struct btf_id_set *kptr_acquire_set;
 		};
 		struct btf_id_set *sets[BTF_KFUNC_TYPE_MAX];
 	};
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index f322967da54b..1d112db4c124 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6034,11 +6034,11 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 	struct bpf_verifier_log *log = &env->log;
 	u32 i, nargs, ref_id, ref_obj_id = 0;
 	bool is_kfunc = btf_is_kernel(btf);
+	bool rel = false, kptr_get = false;
 	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
 	const struct btf_param *args;
 	int ref_regno = 0;
-	bool rel = false;
 
 	t = btf_type_by_id(btf, func_id);
 	if (!t || !btf_type_is_func(t)) {
@@ -6064,6 +6064,9 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		return -EINVAL;
 	}
 
+	if (is_kfunc)
+		kptr_get = btf_kfunc_id_set_contains(btf, resolve_prog_type(env->prog),
+						     BTF_KFUNC_TYPE_KPTR_ACQUIRE, func_id);
 	/* check that BTF function arguments match actual types that the
 	 * verifier sees.
 	 */
@@ -6087,7 +6090,48 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 
 		ref_t = btf_type_skip_modifiers(btf, t->type, &ref_id);
 		ref_tname = btf_name_by_offset(btf, ref_t->name_off);
-		if (btf_get_prog_ctx_type(log, btf, t,
+		if (i == 0 && is_kfunc && kptr_get) {
+			struct bpf_map_value_off_desc *off_desc;
+
+			if (reg->type != PTR_TO_MAP_VALUE) {
+				bpf_log(log, "arg#0 expected pointer to map value, but got %s\n",
+					btf_type_str(t));
+				return -EINVAL;
+			}
+
+			if (!tnum_is_const(reg->var_off)) {
+				bpf_log(log, "arg#0 cannot have variable offset\n");
+				return -EINVAL;
+			}
+
+			off_desc = bpf_map_ptr_off_contains(reg->map_ptr, reg->off + reg->var_off.value);
+			if (!off_desc || !(off_desc->flags & BPF_MAP_VALUE_OFF_F_REF)) {
+				bpf_log(log, "arg#0 no referenced pointer at map value offset=%llu\n",
+					reg->off + reg->var_off.value);
+				return -EINVAL;
+			}
+
+			if (!btf_type_is_ptr(ref_t)) {
+				bpf_log(log, "arg#0 type must be a double pointer\n");
+				return -EINVAL;
+			}
+
+			ref_t = btf_type_skip_modifiers(btf, ref_t->type, &ref_id);
+			ref_tname = btf_name_by_offset(btf, ref_t->name_off);
+
+			if (!btf_type_is_struct(ref_t)) {
+				bpf_log(log, "kernel function %s args#%d pointer type %s %s is not supported\n",
+					func_name, i, btf_type_str(ref_t), ref_tname);
+				return -EINVAL;
+			}
+			if (!btf_struct_ids_match(log, btf, ref_id, 0, off_desc->btf, off_desc->btf_id)) {
+				bpf_log(log, "kernel function %s args#%d expected pointer to %s %s\n",
+					func_name, i, btf_type_str(ref_t), ref_tname);
+				return -EINVAL;
+			}
+
+			/* rest of the arguments can be anything, like normal kfunc */
+		} else if (btf_get_prog_ctx_type(log, btf, t,
 					  env->prog->type, i)) {
 			/* If function expects ctx type in BTF check that caller
 			 * is passing PTR_TO_CTX.
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0a2cd21d9ec1..a4ff951ea46f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3657,11 +3657,12 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 	} else if (insn_class == BPF_LDX) {
 		if (WARN_ON_ONCE(value_regno < 0))
 			return -EFAULT;
+		/* We allow loading referenced pointer, but mark it as
+		 * untrusted. User needs to use a kptr_get helper to obtain a
+		 * trusted refcounted PTR_TO_BTF_ID by passing in the map
+		 * value pointing to the referenced pointer.
+		 */
 		val_reg = reg_state(env, value_regno);
-		if (ref_ptr) {
-			verbose(env, "referenced btf_id pointer can only be accessed using BPF_XCHG\n");
-			return -EACCES;
-		}
 		/* We can simply mark the value_regno receiving the pointer
 		 * value from map as PTR_TO_BTF_ID, with the correct type.
 		 */
-- 
2.35.1

