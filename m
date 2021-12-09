Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E6C46F114
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbhLIRN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242557AbhLIRNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:13:25 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CBEC0617A1;
        Thu,  9 Dec 2021 09:09:51 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso5356571pjl.3;
        Thu, 09 Dec 2021 09:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4r5vRiQCUtnsrEXpXgVTZrt19aPResKG4UO9WSgK6HU=;
        b=KlkRBtU5z5Kq3tl0hljoQjB6jnHZIySU1deQk5yhRa62N5gYr+zQJWeLOkFV62pHr/
         fHCVtCvnUWmVoSaCBvV3oRTO/hc3t37pFCfbe4ZIL56Cx0mo+mWAqBLL8lYvA9/Fw3Ar
         G5+pckkulaw1nccJxQqo6sEcDSyTgpRX40p7FO5OBhQ1xx4yJ9Mw68R65MSIt3goTAdy
         pJjJ7sOWJnV4QYrNnG7mpMnEynzz+IfVp+xKpv02unvq06HdSe2a9RjszQBv96PvlEWD
         ou4upZjhg2+YOTcYgFJkroBgjTjiPJpDb8fvrHkxAO95QpwBXvD5seG5afsGUhrEVY82
         DzFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4r5vRiQCUtnsrEXpXgVTZrt19aPResKG4UO9WSgK6HU=;
        b=IrJNCAdO8TI4/YNZEEa3iTM1NQNmgZ9tNL6mKGcPlOW7HeZYWUU2lTPR+ebk9HOgYI
         nvRrYruJuSpP18KzFqa+o+gBDwg1PIVcqUa5B8n72rwEx25IZAPMZnOwD4YtMF8X+yPb
         FRP0f4NWgt1z/5l1xR9tpCfqqn8ey2yH2DZqjzGNOCj/e7RNvuRDnchsSrbM/kQpxaRW
         SgvBfH2+Z0dcxkHgM3196xTKeMjwffLZtak3htFf/FKEOikfh4dIgul5GU3raphn9sD2
         GwGNMZHRqGsf0YW8Gg1OLWTsHegzIL6BeCh0Ww0AHqM9l4+R/nzjqOlLV+SdoEBzBzwj
         OpFw==
X-Gm-Message-State: AOAM530LF5sOYFGPKlvQBqPVsbGaduN81/Y+48s1+NG8TCCukgvoQQtU
        SkT4pL4mFN1/98LRVd5NL0FQK9E/DK4=
X-Google-Smtp-Source: ABdhPJwXO/EViMeiOnjTocSrpEsGECDOimIJwcPXPeBQq0jn9mrESQY8YXpzN+RUCdfgKjBbFAGa3w==
X-Received: by 2002:a17:90b:3717:: with SMTP id mg23mr17282626pjb.107.1639069791083;
        Thu, 09 Dec 2021 09:09:51 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id u22sm253941pfi.187.2021.12.09.09.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 09:09:50 -0800 (PST)
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
Subject: [PATCH bpf-next v2 6/9] bpf: Track provenance for pointers formed from referenced PTR_TO_BTF_ID
Date:   Thu,  9 Dec 2021 22:39:26 +0530
Message-Id: <20211209170929.3485242-7-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209170929.3485242-1-memxor@gmail.com>
References: <20211209170929.3485242-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7715; h=from:subject; bh=kDtn7PcefhwZyc4eaTzQBYsjRewCAc7PSsotdlO4r0k=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhsjgHvvOEPKmdf4ZXkRH+ZRv5QvWeaAHDi+xinDBY WCSa7C+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbI4BwAKCRBM4MiGSL8RyhR+EA CFREqweWeUi6ZfGCjocHryxJytvCGD5XcdhH7VyMz0GNpwhpRB0YMwaY5foJfLT1R620Rn7Cb+rE5g gAD0yN33o1SRdUd8VEgvnNo0qV7vocMTwR6VXMdJht6kzO/Be/UFm9MBDiC28Ue7qxYJiIpYxr2QM8 CDIf9y6qwb6RWcsuLZpP0LlQ7l8qHlQnx9OlML02ZZLXhTeMI+wyI818BLUfdMfzsa91m4Tg7e3nm7 cg65D/DCsRn6unmVSElLXhnPhBij3qhraTWqK1MmbPKxsyIrqNcmFhHP4nybxJGZ/SGpJ9ieZIrXdN 27iOXtBZC+Z5efjdiXWhRLucub5Y717mZmk43DdxCt6Aub5JJ0uZpg2PwJrKqJBo9KGVCo1jaO1E10 EQDPBxGTtGle69P6f+0PyqOdYjWPjD0aYS8GhUEvKdHk+KHg5aJOQvtSK3ZmQb/JbLdXxUguSzeSJm RcbD6dCZKEH2ugQ8qcoilngpY4fo0SRPSw+lnJePYxuEEwE/I2uU7R1PRC42EatVQp1aQ2fqU391Oo KX74UYhDn0DncZ9TyRxX96L65TJvrXfrCAeLNg3WByRG2K9ahCq+sP7guZ0knvbdWUbKmWtZEcLjBc FbN4xRpkWl+XUSaaVU6ZcPdwMjtYbpA6ZP9PlW1utROAsUMKAPGIBFgWnF4g==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the previous commit, we implemented support in the verifier for
working with referenced PTR_TO_BTF_ID registers. These are invalidated
when their corresponding release function is called.

However, PTR_TO_BTF_ID is a bit special, in that distinct PTR_TO_BTF_ID
can be formed by walking pointers in the struct represented by the BTF
ID. mark_btf_ld_reg will copy the relevant register state to the
destination register.

However, we cannot simply copy ref_obj_id (such that
release_reg_references will match and invalidate all pointers formed by
pointer walking), as we obtain the same BTF ID in the destination
register, leading to confusion during release. An example is show below:

For a type like so:
struct foo { struct foo *next; };

r1 = acquire(...); // BTF ID of struct foo
if (r1) {
	r2 = r1->next; // BTF ID of struct foo, and we copied ref_obj_id in
		       // mark_btf_ld_reg.
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
index b8685fb7ff15..16e30d7f631b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -654,7 +654,8 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 				verbose(env, "%s", kernel_type_name(reg->btf, reg->btf_id));
 			verbose(env, "(id=%d", reg->id);
 			if (reg_type_may_be_refcounted_or_null(t))
-				verbose(env, ",ref_obj_id=%d", reg->ref_obj_id);
+				verbose(env, ",%sref_obj_id=%d", reg->ref_obj_id ? "" : "parent_",
+					reg->ref_obj_id ?: reg->parent_ref_obj_id);
 			if (t != SCALAR_VALUE)
 				verbose(env, ",off=%d", reg->off);
 			if (type_is_pkt_pointer(t))
@@ -1500,7 +1501,8 @@ static void mark_reg_not_init(struct bpf_verifier_env *env,
 static void mark_btf_ld_reg(struct bpf_verifier_env *env,
 			    struct bpf_reg_state *regs, u32 regno,
 			    enum bpf_reg_type reg_type,
-			    struct btf *btf, u32 btf_id)
+			    struct btf *btf, u32 btf_id,
+			    u32 parent_ref_obj_id)
 {
 	if (reg_type == SCALAR_VALUE) {
 		mark_reg_unknown(env, regs, regno);
@@ -1509,6 +1511,7 @@ static void mark_btf_ld_reg(struct bpf_verifier_env *env,
 	mark_reg_known_zero(env, regs, regno);
 	regs[regno].type = PTR_TO_BTF_ID;
 	regs[regno].btf = btf;
+	regs[regno].parent_ref_obj_id = parent_ref_obj_id;
 	regs[regno].btf_id = btf_id;
 }
 
@@ -4136,8 +4139,14 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
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
@@ -4191,8 +4200,14 @@ static int check_ptr_to_map_access(struct bpf_verifier_env *env,
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
@@ -5865,23 +5880,35 @@ static void mark_pkt_end(struct bpf_verifier_state *vstate, int regn, bool range
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
@@ -5898,8 +5925,11 @@ static int release_reference(struct bpf_verifier_env *env,
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

