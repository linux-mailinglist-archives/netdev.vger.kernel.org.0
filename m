Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF12E47827E
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhLQBu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbhLQBux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:50:53 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94179C06173E;
        Thu, 16 Dec 2021 17:50:52 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id a23so691602pgm.4;
        Thu, 16 Dec 2021 17:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WtYJG19mc0JgruN9NeS6qHOk4QX+mcSO2R6/BRwX0zM=;
        b=E8fEVjFL+sly+pgcUJZQqPzZLfarsAXbMQagKA40Lyrkip6OxQ9At0piyCTzs0Tbqo
         vQY84FD91R+oGoj5mbuZ+Jz/iNHXUecywObt6mzk2m8o93ItYlNWKmNT7o3rs7qE8JS9
         AE+ku37UFH4p3Znl2N8+u8bY8KizCxHlbO/mT9txOt2D7ijwksL7Q9dn37ih4ehFxQti
         BbVCO/RtYoP8tedD45shx7D4Cpp5mGZvasmibr9lb5uXHIgWeWxq2xxkHbtGu9XdGSxt
         CTnnVUWUcRm+mfhH3nFCt4b47YlxBd2VUqsZccvSjZsdVbn9kb/2zSM9xA5CAR2LXRea
         heJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WtYJG19mc0JgruN9NeS6qHOk4QX+mcSO2R6/BRwX0zM=;
        b=HyVOxHz0FwJVX0/uWoCe1Ke4i5dumFCpPx/UsrGE6PmiVwTJ8uXtkW1yU3D5myNawE
         BeLUG8aEbe70HTB8hzP7Ly/6lsBpmCZMrGbyIzGn2nYpO3FU5BKtAhV68nMHuhh+2D6y
         kMTJ6PVZ9VRVFdasmL7z56+tYcMkQ88YPT3I7HLlfvpkeXATRaLvj/Qh5Vc8rs8Q8Yoi
         nElzIoG2YTm2xnK53zAvrZG5yniKYIOT4cnlEiOdEl6M7qEFpENfWp0B7+3IlqMANZ8h
         Lk+j8pjo9+dW2VJ0MEpVnhty4fYzzjruRdkOBjVgh9bletU1M8OsG0HBJWXAjQUbp83w
         lTyw==
X-Gm-Message-State: AOAM533EPTxr8EjogpGNeQF/hMmebtv3zMaynmY577Q/QWkE3BJsmHrt
        7ZKvrpFIRZoT7Kw5HgcZDcQQfKKyHPQ=
X-Google-Smtp-Source: ABdhPJyHkrWOwG8bEoc+Uhj/qGS6NxfhW2c63UYlbGSqegL1OYw6zT35Lz4XikpugSE2VXym6PEbyw==
X-Received: by 2002:a63:5a18:: with SMTP id o24mr842633pgb.459.1639705851909;
        Thu, 16 Dec 2021 17:50:51 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id m13sm6383154pgt.22.2021.12.16.17.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 17:50:51 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 06/10] bpf: Track provenance for pointers formed from referenced PTR_TO_BTF_ID
Date:   Fri, 17 Dec 2021 07:20:27 +0530
Message-Id: <20211217015031.1278167-7-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217015031.1278167-1-memxor@gmail.com>
References: <20211217015031.1278167-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7655; h=from:subject; bh=kFW0ViRJH3ErtMooou+C7VKnriqhRlxsfZGUQlHwAcU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhu+vFXd2DJ6b3uIqk0+o4pIjs6PWTQKEBoepfzyxg zAs+YNaJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbvrxQAKCRBM4MiGSL8Ryj/lEA C1YeufLIr0ZYOyld0BslzzWgMNgxfvTTrZtQ6XT8X9qKqjzG2xYb4HmcjsI9iCRozemehO0HeechJV A6vqQ8qaxbddQGBe+TDkpXxDctsE0KRy45jRR5Qacvk6Xl/tPEVGhZzfLFNBM/mbE/OADrcCKa7mif HWwR3ujRs2IzXn2F9+VGNrR6d0pZKYAG5MTRwsV7sj21CLQsDrSbYgtTReSu8f619Q1TGInYjLqe4b upkBk15zisMFimpXdCue8sTu1XKY5DffPN5nLkrIy1Q86+Xu7mnhPi+UCxzPS5K2HjL8AVW5wcPBWt tby1GSWCMHfLiNJXqYD4GnC3kgWNPSWbWx5irPFvRh56Yqii38G6XWqu6sGIt0SgPdglffGM5V0RiV q8z7JGmh4sJSafY+O95WJvMthMKC/rCm4lWvDWSPE6IP/ntAJWbM6pzCfYrsf76NY5ciB29nv/V6kf 7apooGUG9/p/4BiypIVWbb5fRXBg7rUmGtJUD2QbQ4piJqfP4ToUWL5ICRcFA4dGPYrVXhgjIMOkoa Liutwl0wR+IlQ4zIVtDtdTiiEVv3VYIUKJy5Ta013GG1c4SgLUvRCoXajY+ak0zRNiqKf0ALcaAblg MOGgVM5pWNJG/qEE41wrNaIAYfMu3lJnqsi8REmKVhiuXujJlVLVSvfTfJXQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of this commit is to enable invalidation of pointers formed
from walking a referenced PTR_TO_BTF_ID. Currently, mark_btf_ld_reg can
either change the destination register to be SCALAR_VALUE or
PTR_TO_BTF_ID, but with the code until previous commit any such
PTR_TO_BTF_ID will remain valid after we release the referenced pointer
from which it was formed.

However, we cannot simply copy ref_obj_id (such that release_reference
will match and invalidate all pointers formed by pointer walking), as we
can obtain the same BTF ID in the destination register, leading to
confusion during release. An example is shown below:

For a type like so:
struct foo { struct foo *next; };

r1 = acquire(...); // BTF ID of struct foo
if (r1) {
	r2 = r1->next; // BTF ID of struct foo, and we copied ref_obj_id
		       // in mark_btf_ld_reg.
	release(r2);
}

With this logic, the above snippet succeeds. Hence we need to
distinguish the canonical reference and pointers formed from it.

We introduce a 'parent_ref_obj_id' member in bpf_reg_state, for a
referenced register, only one of ref_obj_id or parent_ref_obj_id may be
set, i.e. either a register holds a canonical reference, or it is
related to a canonical reference for invalidation purposes (contains an
edge pointing to it by way of having the same ref_obj_id in
parent_ref_obj_id, in the graph of objects).

When releasing reference, we ensure that both are not set at once, and
then release if either of them match the requested ref_obj_id to be
released. This ensures that the example given above will not succeed.
A test to this end has been added in later patches.

Typically, kernel objects have a nested object lifetime (where the
parent object 'owns' the objects it holds references to). However, this
is not always true. For now, we don't need support to hold on to
references to objects obtained from a refcounted PTR_TO_BTF_ID after its
release, but this can be relaxed on a case by case basis (i.e. based on
the BTF ID and program type/attach type) in the future.

The safest assumption for the verifier to make in absence of any other
hints, is that all such pointers formed from refcounted PTR_TO_BTF_ID
shall be invalidated.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf_verifier.h | 10 +++++++
 kernel/bpf/verifier.c        | 54 ++++++++++++++++++++++++++++--------
 2 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index b80fe5bf2a02..a6ef11db6823 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -128,6 +128,16 @@ struct bpf_reg_state {
 	 * allowed and has the same effect as bpf_sk_release(sk).
 	 */
 	u32 ref_obj_id;
+	/* This is set for pointers which are derived from referenced
+	 * pointer (e.g. PTR_TO_BTF_ID pointer walking), so that the
+	 * pointers obtained by walking referenced PTR_TO_BTF_ID
+	 * are appropriately invalidated when the lifetime of their
+	 * parent object ends.
+	 *
+	 * Only one of ref_obj_id and parent_ref_obj_id can be set,
+	 * never both at once.
+	 */
+	u32 parent_ref_obj_id;
 	/* For scalar types (SCALAR_VALUE), this represents our knowledge of
 	 * the actual value.
 	 * For pointer types, this represents the variable part of the offset
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3ea98e45889d..b6a460b09166 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -655,7 +655,8 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 				verbose(env, "%s", kernel_type_name(reg->btf, reg->btf_id));
 			verbose(env, "(id=%d", reg->id);
 			if (reg_type_may_be_refcounted_or_null(t))
-				verbose(env, ",ref_obj_id=%d", reg->ref_obj_id);
+				verbose(env, ",%sref_obj_id=%d", reg->ref_obj_id ? "" : "parent_",
+					reg->ref_obj_id ?: reg->parent_ref_obj_id);
 			if (t != SCALAR_VALUE)
 				verbose(env, ",off=%d", reg->off);
 			if (type_is_pkt_pointer(t))
@@ -1502,7 +1503,8 @@ static void mark_reg_not_init(struct bpf_verifier_env *env,
 static void mark_btf_ld_reg(struct bpf_verifier_env *env,
 			    struct bpf_reg_state *regs, u32 regno,
 			    enum bpf_reg_type reg_type,
-			    struct btf *btf, u32 btf_id)
+			    struct btf *btf, u32 btf_id,
+			    u32 parent_ref_obj_id)
 {
 	if (reg_type == SCALAR_VALUE) {
 		mark_reg_unknown(env, regs, regno);
@@ -1511,6 +1513,7 @@ static void mark_btf_ld_reg(struct bpf_verifier_env *env,
 	mark_reg_known_zero(env, regs, regno);
 	regs[regno].type = PTR_TO_BTF_ID;
 	regs[regno].btf = btf;
+	regs[regno].parent_ref_obj_id = parent_ref_obj_id;
 	regs[regno].btf_id = btf_id;
 }
 
@@ -4153,8 +4156,14 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 	if (ret < 0)
 		return ret;
 
-	if (atype == BPF_READ && value_regno >= 0)
-		mark_btf_ld_reg(env, regs, value_regno, ret, reg->btf, btf_id);
+	if (atype == BPF_READ && value_regno >= 0) {
+		if (WARN_ON_ONCE(reg->ref_obj_id && reg->parent_ref_obj_id)) {
+			verbose(env, "verifier internal error: both ref and parent ref set\n");
+			return -EACCES;
+		}
+		mark_btf_ld_reg(env, regs, value_regno, ret, reg->btf, btf_id,
+				reg->ref_obj_id ?: reg->parent_ref_obj_id);
+	}
 
 	return 0;
 }
@@ -4208,8 +4217,14 @@ static int check_ptr_to_map_access(struct bpf_verifier_env *env,
 	if (ret < 0)
 		return ret;
 
-	if (value_regno >= 0)
-		mark_btf_ld_reg(env, regs, value_regno, ret, btf_vmlinux, btf_id);
+	if (value_regno >= 0) {
+		if (WARN_ON_ONCE(reg->ref_obj_id && reg->parent_ref_obj_id)) {
+			verbose(env, "verifier internal error: both ref and parent ref set\n");
+			return -EACCES;
+		}
+		mark_btf_ld_reg(env, regs, value_regno, ret, btf_vmlinux, btf_id,
+				reg->ref_obj_id ?: reg->parent_ref_obj_id);
+	}
 
 	return 0;
 }
@@ -5882,23 +5897,35 @@ static void mark_pkt_end(struct bpf_verifier_state *vstate, int regn, bool range
 		reg->range = AT_PKT_END;
 }
 
-static void release_reg_references(struct bpf_verifier_env *env,
+static int release_reg_references(struct bpf_verifier_env *env,
 				   struct bpf_func_state *state,
 				   int ref_obj_id)
 {
 	struct bpf_reg_state *regs = state->regs, *reg;
 	int i;
 
-	for (i = 0; i < MAX_BPF_REG; i++)
-		if (regs[i].ref_obj_id == ref_obj_id)
+	for (i = 0; i < MAX_BPF_REG; i++) {
+		if (WARN_ON_ONCE(regs[i].ref_obj_id && regs[i].parent_ref_obj_id)) {
+			verbose(env, "verifier internal error: both ref and parent ref set\n");
+			return -EACCES;
+		}
+		if (regs[i].ref_obj_id == ref_obj_id ||
+		    regs[i].parent_ref_obj_id == ref_obj_id)
 			mark_reg_unknown(env, regs, i);
+	}
 
 	bpf_for_each_spilled_reg(i, state, reg) {
 		if (!reg)
 			continue;
-		if (reg->ref_obj_id == ref_obj_id)
+		if (WARN_ON_ONCE(reg->ref_obj_id && reg->parent_ref_obj_id)) {
+			verbose(env, "verifier internal error: both ref and parent ref set\n");
+			return -EACCES;
+		}
+		if (reg->ref_obj_id == ref_obj_id ||
+		    reg->parent_ref_obj_id == ref_obj_id)
 			__mark_reg_unknown(env, reg);
 	}
+	return 0;
 }
 
 /* The pointer with the specified id has released its reference to kernel
@@ -5915,8 +5942,11 @@ static int release_reference(struct bpf_verifier_env *env,
 	if (err)
 		return err;
 
-	for (i = 0; i <= vstate->curframe; i++)
-		release_reg_references(env, vstate->frame[i], ref_obj_id);
+	for (i = 0; i <= vstate->curframe; i++) {
+		err = release_reg_references(env, vstate->frame[i], ref_obj_id);
+		if (err)
+			return err;
+	}
 
 	return 0;
 }
-- 
2.34.1

