Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5886D57B7
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 06:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbjDDEux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 00:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbjDDEus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 00:50:48 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286E9199C;
        Mon,  3 Apr 2023 21:50:46 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u10so30175816plz.7;
        Mon, 03 Apr 2023 21:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680583845; x=1683175845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yiJcdfDoc3/0e6NQqry8oM48cRo4ZhqE+pBAZOE85NE=;
        b=EnNRTiX+EpEWm41uLXAMo+kYPeAk9FBGJ9C0Pch9fGfo047VguH2xhxNon8mEYoOV2
         b+g0H6hUj4m1/Ccez6Kw35dIVDurqIx5V6B+k5fK+uH8gkUCveF5Bqz025M03ql0R0vY
         ABhaqNCaYvRNc+sa1W/TK5ReWlFYamz5ozqcDQlWIBVvzLf40OT39o0b5KLDdP8S3/3q
         4iqnC7BlJms0oYn5Na2gcR84s5ADCPYGpTjTWxyDJqvxTcqtGXCQ5Y9zpIe8IQKIrKKb
         vNceiBH1KXTn74bzcaWo8HuTaUtkDcwVkU97TtEfTbpyHZ8GQwOVvTiP9OX0lL0gR0ht
         zuNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680583845; x=1683175845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yiJcdfDoc3/0e6NQqry8oM48cRo4ZhqE+pBAZOE85NE=;
        b=MX+AO6nQWZQVXPyfKCBMOTED9poWPttQmUcD6gMzZYQ1jKGT+xGqrLn9hB8mIFuBR5
         TSugccUu3m3+faMjLI1mGAgvpU4hPpTLx1rlBxVdLUi3tOP63eQsNY4PllEZ0Zav2ZKM
         Ps409zCupoUX93iX2QvB1RFTTVAV0ATO8MmfJtkTEKPTuiVk/+4qojWimxKPVJ3rqEWW
         bfy8TdOTPR4MloUMAYa5lwORCjLmM1eBBKp1KT9mldVVKgeMQ3uDVCIFlt/hPUpqrU5J
         4MAJVaRnJNISnVZWQpxrmgCCxhalpXjWv0uNxIE2oFYpiQ3NuXGGoylj7mQVgqgjWnl1
         uwHw==
X-Gm-Message-State: AAQBX9eUrhGh3midMUx1E8+02hJZTL1KLkXkOxKVaDWSAK7e9HnCGJEz
        FNjdYBHJSmqRBXDjW4AZxlI=
X-Google-Smtp-Source: AKy350Y1kR3ncMinPJvmwLwawEcOTBcY6f14bEp1+HBc1FchVB+n0oAwRiL46+D1+LjVuyRnc4eFCA==
X-Received: by 2002:a17:902:d2ca:b0:1a1:be45:9857 with SMTP id n10-20020a170902d2ca00b001a1be459857mr1462162plc.1.1680583845482;
        Mon, 03 Apr 2023 21:50:45 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:3c8])
        by smtp.gmail.com with ESMTPSA id f19-20020a170902e99300b0019acd3151d0sm7416637plb.114.2023.04.03.21.50.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Apr 2023 21:50:45 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 3/8] bpf: Refactor btf_nested_type_is_trusted().
Date:   Mon,  3 Apr 2023 21:50:24 -0700
Message-Id: <20230404045029.82870-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

btf_nested_type_is_trusted() tries to find a struct member at corresponding offset.
It works for flat structures and falls apart in more complex structs with nested structs.
The offset->member search is already performed by btf_struct_walk() including nested structs.
Reuse this work and pass {field name, field btf id} into btf_nested_type_is_trusted()
instead of offset to make BTF_TYPE_SAFE*() logic more robust.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h   |  7 ++++---
 kernel/bpf/btf.c      | 44 +++++++++++++++++--------------------------
 kernel/bpf/verifier.c | 23 +++++++++++-----------
 3 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4f689dda748f..002a811b6b90 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2263,7 +2263,7 @@ static inline bool bpf_tracing_btf_ctx_access(int off, int size,
 int btf_struct_access(struct bpf_verifier_log *log,
 		      const struct bpf_reg_state *reg,
 		      int off, int size, enum bpf_access_type atype,
-		      u32 *next_btf_id, enum bpf_type_flag *flag);
+		      u32 *next_btf_id, enum bpf_type_flag *flag, const char **field_name);
 bool btf_struct_ids_match(struct bpf_verifier_log *log,
 			  const struct btf *btf, u32 id, int off,
 			  const struct btf *need_btf, u32 need_type_id,
@@ -2302,7 +2302,7 @@ struct bpf_core_ctx {
 
 bool btf_nested_type_is_trusted(struct bpf_verifier_log *log,
 				const struct bpf_reg_state *reg,
-				int off, const char *suffix);
+				const char *field_name, u32 btf_id, const char *suffix);
 
 bool btf_type_ids_nocast_alias(struct bpf_verifier_log *log,
 			       const struct btf *reg_btf, u32 reg_id,
@@ -2517,7 +2517,8 @@ static inline struct bpf_prog *bpf_prog_by_id(u32 id)
 static inline int btf_struct_access(struct bpf_verifier_log *log,
 				    const struct bpf_reg_state *reg,
 				    int off, int size, enum bpf_access_type atype,
-				    u32 *next_btf_id, enum bpf_type_flag *flag)
+				    u32 *next_btf_id, enum bpf_type_flag *flag,
+				    const char **field_name)
 {
 	return -EACCES;
 }
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index b7e5a5510b91..593c45a294d0 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6166,7 +6166,8 @@ enum bpf_struct_walk_result {
 
 static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 			   const struct btf_type *t, int off, int size,
-			   u32 *next_btf_id, enum bpf_type_flag *flag)
+			   u32 *next_btf_id, enum bpf_type_flag *flag,
+			   const char **field_name)
 {
 	u32 i, moff, mtrue_end, msize = 0, total_nelems = 0;
 	const struct btf_type *mtype, *elem_type = NULL;
@@ -6395,6 +6396,8 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 			if (btf_type_is_struct(stype)) {
 				*next_btf_id = id;
 				*flag |= tmp_flag;
+				if (field_name)
+					*field_name = mname;
 				return WALK_PTR;
 			}
 		}
@@ -6421,7 +6424,8 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 int btf_struct_access(struct bpf_verifier_log *log,
 		      const struct bpf_reg_state *reg,
 		      int off, int size, enum bpf_access_type atype __maybe_unused,
-		      u32 *next_btf_id, enum bpf_type_flag *flag)
+		      u32 *next_btf_id, enum bpf_type_flag *flag,
+		      const char **field_name)
 {
 	const struct btf *btf = reg->btf;
 	enum bpf_type_flag tmp_flag = 0;
@@ -6453,7 +6457,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 
 	t = btf_type_by_id(btf, id);
 	do {
-		err = btf_struct_walk(log, btf, t, off, size, &id, &tmp_flag);
+		err = btf_struct_walk(log, btf, t, off, size, &id, &tmp_flag, field_name);
 
 		switch (err) {
 		case WALK_PTR:
@@ -6528,7 +6532,7 @@ bool btf_struct_ids_match(struct bpf_verifier_log *log,
 	type = btf_type_by_id(btf, id);
 	if (!type)
 		return false;
-	err = btf_struct_walk(log, btf, type, off, 1, &id, &flag);
+	err = btf_struct_walk(log, btf, type, off, 1, &id, &flag, NULL);
 	if (err != WALK_STRUCT)
 		return false;
 
@@ -8488,16 +8492,15 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const struct bpf_core_relo *relo,
 
 bool btf_nested_type_is_trusted(struct bpf_verifier_log *log,
 				const struct bpf_reg_state *reg,
-				int off, const char *suffix)
+				const char *field_name, u32 btf_id, const char *suffix)
 {
 	struct btf *btf = reg->btf;
 	const struct btf_type *walk_type, *safe_type;
 	const char *tname;
 	char safe_tname[64];
 	long ret, safe_id;
-	const struct btf_member *member, *m_walk = NULL;
+	const struct btf_member *member;
 	u32 i;
-	const char *walk_name;
 
 	walk_type = btf_type_by_id(btf, reg->btf_id);
 	if (!walk_type)
@@ -8517,30 +8520,17 @@ bool btf_nested_type_is_trusted(struct bpf_verifier_log *log,
 	if (!safe_type)
 		return false;
 
-	for_each_member(i, walk_type, member) {
-		u32 moff;
-
-		/* We're looking for the PTR_TO_BTF_ID member in the struct
-		 * type we're walking which matches the specified offset.
-		 * Below, we'll iterate over the fields in the safe variant of
-		 * the struct and see if any of them has a matching type /
-		 * name.
-		 */
-		moff = __btf_member_bit_offset(walk_type, member) / 8;
-		if (off == moff) {
-			m_walk = member;
-			break;
-		}
-	}
-	if (m_walk == NULL)
-		return false;
-
-	walk_name = __btf_name_by_offset(btf, m_walk->name_off);
 	for_each_member(i, safe_type, member) {
 		const char *m_name = __btf_name_by_offset(btf, member->name_off);
+		const struct btf_type *mtype = btf_type_by_id(btf, member->type);
+		u32 id;
+
+		if (!btf_type_is_ptr(mtype))
+			continue;
 
+		btf_type_skip_modifiers(btf, mtype->type, &id);
 		/* If we match on both type and name, the field is considered trusted. */
-		if (m_walk->type == member->type && !strcmp(walk_name, m_name))
+		if (btf_id == id && !strcmp(field_name, m_name))
 			return true;
 	}
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5ca520e5eddf..2cd2e0b725cd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5400,12 +5400,12 @@ BTF_TYPE_SAFE_RCU(struct css_set) {
 
 /* full trusted: these fields are trusted even outside of RCU CS and never NULL */
 BTF_TYPE_SAFE_TRUSTED(struct bpf_iter_meta) {
-	__bpf_md_ptr(struct seq_file *, seq);
+	struct seq_file *seq;
 };
 
 BTF_TYPE_SAFE_TRUSTED(struct bpf_iter__task) {
-	__bpf_md_ptr(struct bpf_iter_meta *, meta);
-	__bpf_md_ptr(struct task_struct *, task);
+	struct bpf_iter_meta *meta;
+	struct task_struct *task;
 };
 
 BTF_TYPE_SAFE_TRUSTED(struct linux_binprm) {
@@ -5427,17 +5427,17 @@ BTF_TYPE_SAFE_TRUSTED(struct socket) {
 
 static bool type_is_rcu(struct bpf_verifier_env *env,
 			struct bpf_reg_state *reg,
-			int off)
+			const char *field_name, u32 btf_id)
 {
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_RCU(struct task_struct));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_RCU(struct css_set));
 
-	return btf_nested_type_is_trusted(&env->log, reg, off, "__safe_rcu");
+	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id, "__safe_rcu");
 }
 
 static bool type_is_trusted(struct bpf_verifier_env *env,
 			    struct bpf_reg_state *reg,
-			    int off)
+			    const char *field_name, u32 btf_id)
 {
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct bpf_iter_meta));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct bpf_iter__task));
@@ -5446,7 +5446,7 @@ static bool type_is_trusted(struct bpf_verifier_env *env,
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct dentry));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct socket));
 
-	return btf_nested_type_is_trusted(&env->log, reg, off, "__safe_trusted");
+	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id, "__safe_trusted");
 }
 
 static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
@@ -5458,6 +5458,7 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 	struct bpf_reg_state *reg = regs + regno;
 	const struct btf_type *t = btf_type_by_id(reg->btf, reg->btf_id);
 	const char *tname = btf_name_by_offset(reg->btf, t->name_off);
+	const char *field_name = NULL;
 	enum bpf_type_flag flag = 0;
 	u32 btf_id = 0;
 	int ret;
@@ -5526,7 +5527,7 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 			return -EFAULT;
 		}
 
-		ret = btf_struct_access(&env->log, reg, off, size, atype, &btf_id, &flag);
+		ret = btf_struct_access(&env->log, reg, off, size, atype, &btf_id, &flag, &field_name);
 	}
 
 	if (ret < 0)
@@ -5554,10 +5555,10 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 		 * A regular RCU-protected pointer with __rcu tag can also be deemed
 		 * trusted if we are in an RCU CS. Such pointer can be NULL.
 		 */
-		if (type_is_trusted(env, reg, off)) {
+		if (type_is_trusted(env, reg, field_name, btf_id)) {
 			flag |= PTR_TRUSTED;
 		} else if (in_rcu_cs(env) && !type_may_be_null(reg->type)) {
-			if (type_is_rcu(env, reg, off)) {
+			if (type_is_rcu(env, reg, field_name, btf_id)) {
 				/* ignore __rcu tag and mark it MEM_RCU */
 				flag |= MEM_RCU;
 			} else if (flag & MEM_RCU) {
@@ -5640,7 +5641,7 @@ static int check_ptr_to_map_access(struct bpf_verifier_env *env,
 	/* Simulate access to a PTR_TO_BTF_ID */
 	memset(&map_reg, 0, sizeof(map_reg));
 	mark_btf_ld_reg(env, &map_reg, 0, PTR_TO_BTF_ID, btf_vmlinux, *map->ops->map_btf_id, 0);
-	ret = btf_struct_access(&env->log, &map_reg, off, size, atype, &btf_id, &flag);
+	ret = btf_struct_access(&env->log, &map_reg, off, size, atype, &btf_id, &flag, NULL);
 	if (ret < 0)
 		return ret;
 
-- 
2.34.1

