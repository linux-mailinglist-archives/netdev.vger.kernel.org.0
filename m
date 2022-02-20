Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11264BCECD
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243881AbiBTNs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:48:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243855AbiBTNsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:48:51 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD71A2D1E8;
        Sun, 20 Feb 2022 05:48:29 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso16509817pjt.4;
        Sun, 20 Feb 2022 05:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u553XL18yly1/cCm3ekwYOyq08NaxGCEKxwUe2SELgg=;
        b=Kqmh7FesAY7zCexo1xKseWmIO7Umn7hcZPO9WhTV/zokXk3BXMhUOnYKZ3aFkJARF+
         MUaJcmkJAUZdklrZ61bBLg5kgr6x+lsJzzJJqa/sSzkFPjPXEcj4xQ1dxk6S4zzev9TA
         vGsje+A4Rh6iWk4+JB1o1lKLhKZDnj2/fFm4n5JFFwBxajwSyNwqu97dUmU1nmJ3QnMj
         Grfn+sKqEIht8uRsWC/c4P2A0utNKVeuywslZynWP84Vsx6g/o7zfioFeLPv8sbsnm17
         mYyk4WnOWoqCexr8YZZlwFyVAVPJGXawdc4TFW9I8UWljus6R3DCNGdiwvWobfzupym4
         emlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u553XL18yly1/cCm3ekwYOyq08NaxGCEKxwUe2SELgg=;
        b=25yY5y0tQjYtOC9d53515HtfKa+rMbssntnrKW2QrPxEawZoRuMNoqxZ2K2xkyiYtZ
         UMY1MYE7rqZrcNLsnlkFMi6skgQdf2ftBAx3Amuvvd/3UjirVetmMp70cuxOevPUNQNk
         IJOfe/R/atEDIWwxdwJ0J3LOLq4bjIzWb0QHnmAosO0voSZJ2lDookpUn3mVEFVPcCRb
         o5EdK7NOHB5gwVhVx1DVOMQgyhnAMJ6ZwqpRXsjUdy9SoO3Y0PMRR6+bNZtS++ZvApb+
         mPYroyjZBb3J47BH0rfCkRQw9S/8OpjrFmXVC8v8xo/LikpHl/Wej8bDQRUEbTMYjF+a
         tC+w==
X-Gm-Message-State: AOAM531+qWtdyfQTBRANw1d5fx/hldvBgDYhE6EOxMDWGT/9PP+w3ZUO
        33Z4WoXhhJucJIIWnDxsWfcuTaMOl18=
X-Google-Smtp-Source: ABdhPJyKVuhjcQR/fifASHAAq8Ew9Nt/fQs2IXtaHvLobSmnSU7rgQ9sDSkwpOjNlZGorzyP0JXnUQ==
X-Received: by 2002:a17:903:228a:b0:14d:aa04:2278 with SMTP id b10-20020a170903228a00b0014daa042278mr15397892plh.58.1645364908891;
        Sun, 20 Feb 2022 05:48:28 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id k4sm9620741pff.39.2022.02.20.05.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:28 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 04/15] bpf: Allow storing referenced PTR_TO_BTF_ID in map
Date:   Sun, 20 Feb 2022 19:18:02 +0530
Message-Id: <20220220134813.3411982-5-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=17467; h=from:subject; bh=eyWdpQxuVOys9KdWZkDYB65kBnBE5WEaZrsN5VgWjY4=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZXYKi7Qa/9mPx6fXKfGyg53rEu0MeITQLXkD3T a9ftsTCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGVwAKCRBM4MiGSL8RymzpEA CIGRKmAVSYEhzVr1RzollinmCl08tjkSdzv9zrqgh4G8hC+SRCMHRSDnLp5bgeB3uGo44VphuIAD5j CuHr1ylrGAWr+jHelGr2Gk8Dy5eR99EGaXaHGDQxsTA2oG88g/+bl6fCN9pjRjD/b3n/lMmuzoy4Bk /54xCDkObSFi288JZTBpyfesRz5MK2FNeLYjsu3wbO20LZoRNWxLyozMpnOqF0LpwQHmruBNKUVQKf dQlBKyJP8n6o9kEFL/WAFaW+aZ6KiJyojiiDykV1P7ZoMbW/gogRlBXkyIMlGY7RDfDfDcuATnFilF 9ArwFoKB2M+PQ6x1bsEwXolWI5th1FxHawUT8U0sWZwWuDItcQyYv/CdUaLcdqVSMf1mSeAhYqRjAx C68KkWvnupKFFLC3cUett5Rym5nWrUqfZ2pukPVDUpXWihe0wkXMByd+9el+dx9ygaAUcwigiOKJa4 eXmSx/1UrdBVJmUmklnX2QCVJ/wYzsiBCGk8PugwrRs9/e9cMbH9FqrrBnIfJ7Vy+FfLyVwOe7UF30 sUXF92Sd9KVK9LhUeVglHWaCBr79Uc2OfG0k7Wk/XzgfYtuEFDnr0HZNkb0ignEWESNsDyJhCl3u/f UMEZLnv+wQBLlt8Tw8N9T3BsHtxmMmR1syY9LkOYzutljP5TY3OH86RyIyxQ==
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

This commit enables storing referenced PTR_TO_BTF_ID pointers in maps,
with some restrictions to ensure the value of the pointer remains
consistent, as it needs to be eventuall freed using a release function,
either by the BPF program itself in a later invocation, or by the map's
free path.

Such a pointer must be tagged using both 'btf_id' and 'ref' type tags on
the type being pointed to by the pointer, in the map value's BTF. The
verifier will only permit updating such pointers using BPF_XCHG
instruction.

There are valid reasons to enforce this restriction:
- The pointer value must be consistent in face of concurrent
  modification, and any prior values contained in the map must also be
  released before a new one is moved into the map. To ensure proper
  transfer of this ownership, BPF_XCHG returns the old value, which the
  verifier would require the user to either free or move into another
  map, and released the reference held for the pointer being moved in.

  Hence, after a BPF_XCHG on a map value, the user releases the
  reference for the pointer they are moving in, and acquires a reference
  for the old pointer returned by the exchange instruction (in src_reg).

  In case of unreferenced PTR_TO_BTF_ID in maps, losing the old value by
  a store had no adverse effect. The only thing we need to ensure is
  that the actual word sized pointer is written and read concurrently
  using word sized instructions on the actual architecture, even if BPF
  ABI has 64-bit pointers, the underlying pointer value on 32-bit
  systems will be 32-bit, so emitting a load and store as two 32-bit
  sized loads and stores would still be valid, however doing the same on
  a 64-bit system would be wrong, as the pointer value being read can be
  inconsistent.

  This is because while pointer dereference inside a BPF program is
  concerned, the verifier patches loads to PROBE_MEM loads, which
  support exception handling of faulting loads, but PTR_TO_BTF_ID can
  also be passed into BPF helpers and kernel functions, which do not
  have the same liberty.

- This also ensures that BPF programs executing concurrently never end
  up in a state where a certain pointer value was lost due to
  manipulations of the map value, thus leaking the reference that was
  moved in.

  There is always an entity which releases the reference eventually, it
  will either be the map's free path (which will detect and release live
  pointers in the map), or the BPF program itself, which can exchange a
  referenced pointer with NULL and free the old reference.

- In case of multiple such pointers, doing many BPF_XCHG can be a bit
  costly, especially if those pointers are already protected by a BPF
  spin lock against concurrent modification. In the future, this support
  can be extended so that a single spin lock protects multiple such
  pointers and this move operation can be enforced using a helper, while
  also ensuring linearizability of the pointer move operations. This
  will amortize the cost of each individual BPF_XCHG that would be
  needed otherwise using a spin lock. However, this is work that has
  been left as an exercise for a future patch.

  This mechanism would also require the user to indicate to the verifier
  which members of the map value are protected by the BPF spin lock, by
  using annotation in map's BTF.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h   |   5 ++
 kernel/bpf/btf.c      |  22 +++++++-
 kernel/bpf/verifier.c | 117 ++++++++++++++++++++++++++++++++++++------
 3 files changed, 126 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ce45ffb79f82..923b9f36c275 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -160,11 +160,16 @@ enum {
 	BPF_MAP_VALUE_OFF_MAX = 8,
 };
 
+enum {
+	BPF_MAP_VALUE_OFF_F_REF = (1U << 0),
+};
+
 struct bpf_map_value_off_desc {
 	u32 offset;
 	u32 btf_id;
 	struct btf *btf;
 	struct module *module;
+	int flags;
 };
 
 struct bpf_map_value_off {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 1edb5710e155..20124f4a421c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3146,10 +3146,10 @@ static s32 btf_find_by_name_kind_all(const char *name, u32 kind, struct btf **bt
 static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 			       u32 off, int sz, void *data)
 {
+	bool btf_id_tag = false, ref_tag = false;
 	struct bpf_map_value_off *tab;
 	struct bpf_map *map = data;
 	struct module *mod = NULL;
-	bool btf_id_tag = false;
 	struct btf *kernel_btf;
 	int nr_off, ret;
 	s32 id;
@@ -3167,6 +3167,13 @@ static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 				goto end;
 			}
 			btf_id_tag = true;
+		} else if (!strcmp("kernel.bpf.ref", __btf_name_by_offset(btf, t->name_off))) {
+			/* repeated tag */
+			if (ref_tag) {
+				ret = -EINVAL;
+				goto end;
+			}
+			ref_tag = true;
 		} else if (!strncmp("kernel.", __btf_name_by_offset(btf, t->name_off),
 			   sizeof("kernel.") - 1)) {
 			/* TODO: Should we reject these when loading BTF? */
@@ -3177,8 +3184,14 @@ static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 		/* Look for next tag */
 		t = btf_type_by_id(btf, t->type);
 	}
-	if (!btf_id_tag)
+	if (!btf_id_tag) {
+		/* 'ref' tag must be specified together with 'btf_id' tag */
+		if (ref_tag) {
+			ret = -EINVAL;
+			goto end;
+		}
 		return 0;
+	}
 
 	/* Get the base type */
 	if (btf_type_is_modifier(t))
@@ -3215,6 +3228,10 @@ static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 
 	/* We take reference to make sure valid pointers into module data don't
 	 * become invalid across program invocation.
+	 *
+	 * We also need to hold a reference to the module, which corresponds to
+	 * the referenced type, as it has the destructor function we need to
+	 * call when map goes away and a live pointer exists at offset.
 	 */
 	if (btf_is_module(kernel_btf)) {
 		mod = btf_try_get_module(kernel_btf);
@@ -3228,6 +3245,7 @@ static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 	tab->off[nr_off].btf_id = id;
 	tab->off[nr_off].btf    = kernel_btf;
 	tab->off[nr_off].module = mod;
+	tab->off[nr_off].flags  = ref_tag ? BPF_MAP_VALUE_OFF_F_REF : 0;
 	tab->nr_off++;
 
 	return 0;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1ffefddebaea..a9d8c0d3c919 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -521,6 +521,13 @@ static bool is_ptr_cast_function(enum bpf_func_id func_id)
 		func_id == BPF_FUNC_skc_to_tcp_request_sock;
 }
 
+static bool is_xchg_insn(const struct bpf_insn *insn)
+{
+	return BPF_CLASS(insn->code) == BPF_STX &&
+	       BPF_MODE(insn->code) == BPF_ATOMIC &&
+	       insn->imm == BPF_XCHG;
+}
+
 static bool is_cmpxchg_insn(const struct bpf_insn *insn)
 {
 	return BPF_CLASS(insn->code) == BPF_STX &&
@@ -3467,7 +3474,8 @@ static int check_mem_region_access(struct bpf_verifier_env *env, u32 regno,
 
 static int map_ptr_to_btf_id_match_type(struct bpf_verifier_env *env,
 					struct bpf_map_value_off_desc *off_desc,
-					struct bpf_reg_state *reg, u32 regno)
+					struct bpf_reg_state *reg, u32 regno,
+					bool ref_ptr)
 {
 	const char *targ_name = kernel_type_name(off_desc->btf, off_desc->btf_id);
 	const char *reg_name = "";
@@ -3498,6 +3506,20 @@ static int map_ptr_to_btf_id_match_type(struct bpf_verifier_env *env,
 			regno, reg_name, reg->off, tn_buf);
 		return -EINVAL;
 	}
+	/* reg->off can be used to store pointer to a certain type formed by
+	 * incrementing pointer of a parent structure the object is embedded in,
+	 * e.g. map may expect unreferenced struct path *, and user should be
+	 * allowed a store using &file->f_path. However, in the case of
+	 * referenced pointer, we cannot do this, because the reference is only
+	 * for the parent structure, not its embedded object(s), and because
+	 * the transfer of ownership happens for the original pointer to and
+	 * from the map (before its eventual release).
+	 */
+	if (reg->off && ref_ptr) {
+		verbose(env, "R%d stored to referenced btf_id pointer cannot have non-zero offset\n",
+			regno);
+		return -EINVAL;
+	}
 
 	if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, reg->off,
 				  off_desc->btf, off_desc->btf_id))
@@ -3510,17 +3532,23 @@ static int map_ptr_to_btf_id_match_type(struct bpf_verifier_env *env,
 	return -EINVAL;
 }
 
+static int release_reference(struct bpf_verifier_env *env, int ref_obj_id);
+
 /* Returns an error, or 0 if ignoring the access, or 1 if register state was
  * updated, in which case later updates must be skipped.
  */
 static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int off, int size,
-				   int value_regno, enum bpf_access_type t, int insn_idx)
+				   int value_regno, enum bpf_access_type t, int insn_idx,
+				   struct bpf_reg_state *atomic_load_reg)
 {
 	struct bpf_reg_state *reg = reg_state(env, regno), *val_reg;
 	struct bpf_insn *insn = &env->prog->insnsi[insn_idx];
 	struct bpf_map_value_off_desc *off_desc;
 	int insn_class = BPF_CLASS(insn->code);
 	struct bpf_map *map = reg->map_ptr;
+	bool ref_ptr = false;
+	u32 ref_obj_id = 0;
+	int ret;
 
 	/* Things we already checked for in check_map_access:
 	 *  - Reject cases where variable offset may touch BTF ID pointer
@@ -3533,11 +3561,12 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 	off_desc = bpf_map_ptr_off_contains(map, off + reg->var_off.value);
 	if (!off_desc)
 		return 0;
+	ref_ptr = off_desc->flags & BPF_MAP_VALUE_OFF_F_REF;
 
 	if (WARN_ON_ONCE(size != bpf_size_to_bytes(BPF_DW)))
 		return -EACCES;
 
-	if (BPF_MODE(insn->code) != BPF_MEM)
+	if (BPF_MODE(insn->code) != BPF_MEM && BPF_MODE(insn->code) != BPF_ATOMIC)
 		goto end;
 
 	if (!env->bpf_capable) {
@@ -3545,10 +3574,50 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 		return -EPERM;
 	}
 
-	if (insn_class == BPF_LDX) {
+	if (is_xchg_insn(insn)) {
+		/* We do checks and updates during register fill call for fetch case */
+		if (t != BPF_READ || value_regno < 0)
+			return 1;
+		val_reg = reg_state(env, value_regno);
+		if (!register_is_null(atomic_load_reg) &&
+		    map_ptr_to_btf_id_match_type(env, off_desc, atomic_load_reg, value_regno, ref_ptr))
+			return -EACCES;
+		/* Acquire new reference state for old pointer, and release
+		 * current reference state for exchanged pointer.
+		 */
+		if (ref_ptr) {
+			if (!register_is_null(atomic_load_reg)) {
+				if (!atomic_load_reg->ref_obj_id) {
+					verbose(env, "R%d type=%s%s must be referenced\n",
+						value_regno, reg_type_str(env, atomic_load_reg->type),
+						kernel_type_name(reg->btf, reg->btf_id));
+					return -EACCES;
+				}
+				ret = release_reference(env, atomic_load_reg->ref_obj_id);
+				if (ret < 0)
+					return ret;
+			}
+			ret = acquire_reference_state(env, insn_idx);
+			if (ret < 0)
+				return ret;
+			ref_obj_id = ret;
+		}
+		/* val_reg might be NULL at this point */
+		mark_btf_ld_reg(env, cur_regs(env), value_regno, PTR_TO_BTF_ID, off_desc->btf,
+				off_desc->btf_id, PTR_MAYBE_NULL);
+		/* __mark_ptr_or_null_regs needs ref_obj_id == id to clear
+		 * reference state for ptr == NULL branch.
+		 */
+		val_reg->id = ref_obj_id ?: ++env->id_gen;
+		val_reg->ref_obj_id = ref_obj_id;
+	} else if (insn_class == BPF_LDX) {
 		if (WARN_ON_ONCE(value_regno < 0))
 			return -EFAULT;
 		val_reg = reg_state(env, value_regno);
+		if (ref_ptr) {
+			verbose(env, "referenced btf_id pointer can only be accessed using BPF_XCHG\n");
+			return -EACCES;
+		}
 		/* We can simply mark the value_regno receiving the pointer
 		 * value from map as PTR_TO_BTF_ID, with the correct type.
 		 */
@@ -3559,10 +3628,18 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 		if (WARN_ON_ONCE(value_regno < 0))
 			return -EFAULT;
 		val_reg = reg_state(env, value_regno);
+		if (ref_ptr) {
+			verbose(env, "referenced btf_id pointer can only be accessed using BPF_XCHG\n");
+			return -EACCES;
+		}
 		if (!register_is_null(val_reg) &&
-		    map_ptr_to_btf_id_match_type(env, off_desc, val_reg, value_regno))
+		    map_ptr_to_btf_id_match_type(env, off_desc, val_reg, value_regno, false))
 			return -EACCES;
 	} else if (insn_class == BPF_ST) {
+		if (ref_ptr) {
+			verbose(env, "referenced btf_id pointer can only be accessed using BPF_XCHG\n");
+			return -EACCES;
+		}
 		if (insn->imm) {
 			verbose(env, "BPF_ST imm must be 0 when writing to btf_id pointer at off=%u\n",
 				off_desc->offset);
@@ -3573,7 +3650,7 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 	}
 	return 1;
 end:
-	verbose(env, "btf_id pointer in map can only be accessed using BPF_LDX/BPF_STX/BPF_ST\n");
+	verbose(env, "btf_id pointer in map can only be accessed using BPF_LDX, BPF_STX, BPF_ST, BPF_XCHG\n");
 	return -EACCES;
 }
 
@@ -4505,7 +4582,8 @@ static int check_stack_access_within_bounds(
  */
 static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regno,
 			    int off, int bpf_size, enum bpf_access_type t,
-			    int value_regno, bool strict_alignment_once)
+			    int value_regno, bool strict_alignment_once,
+			    struct bpf_reg_state *atomic_load_reg)
 {
 	struct bpf_reg_state *regs = cur_regs(env);
 	struct bpf_reg_state *reg = regs + regno;
@@ -4548,7 +4626,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		err = check_map_access(env, regno, off, size, false);
 		if (!err)
 			err = check_map_ptr_to_btf_id(env, regno, off, size, value_regno,
-						      t, insn_idx);
+						      t, insn_idx, atomic_load_reg);
 		/* if err == 0, check_map_ptr_to_btf_id ignored the access */
 		if (!err && t == BPF_READ && value_regno >= 0) {
 			struct bpf_map *map = reg->map_ptr;
@@ -4743,9 +4821,12 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 
 static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_insn *insn)
 {
+	struct bpf_reg_state atomic_load_reg;
 	int load_reg;
 	int err;
 
+	__mark_reg_unknown(env, &atomic_load_reg);
+
 	switch (insn->imm) {
 	case BPF_ADD:
 	case BPF_ADD | BPF_FETCH:
@@ -4813,6 +4894,7 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
 		else
 			load_reg = insn->src_reg;
 
+		atomic_load_reg = *reg_state(env, load_reg);
 		/* check and record load of old value */
 		err = check_reg_arg(env, load_reg, DST_OP);
 		if (err)
@@ -4825,20 +4907,21 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
 	}
 
 	/* Check whether we can read the memory, with second call for fetch
-	 * case to simulate the register fill.
+	 * case to simulate the register fill, which also triggers checks
+	 * for manipulation of BTF ID pointers embedded in BPF maps.
 	 */
 	err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
-			       BPF_SIZE(insn->code), BPF_READ, -1, true);
+			       BPF_SIZE(insn->code), BPF_READ, -1, true, NULL);
 	if (!err && load_reg >= 0)
 		err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
 				       BPF_SIZE(insn->code), BPF_READ, load_reg,
-				       true);
+				       true, load_reg >= 0 ? &atomic_load_reg : NULL);
 	if (err)
 		return err;
 
 	/* Check whether we can write into the same memory. */
 	err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
-			       BPF_SIZE(insn->code), BPF_WRITE, -1, true);
+			       BPF_SIZE(insn->code), BPF_WRITE, -1, true, NULL);
 	if (err)
 		return err;
 
@@ -6797,7 +6880,7 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 	 */
 	for (i = 0; i < meta.access_size; i++) {
 		err = check_mem_access(env, insn_idx, meta.regno, i, BPF_B,
-				       BPF_WRITE, -1, false);
+				       BPF_WRITE, -1, false, NULL);
 		if (err)
 			return err;
 	}
@@ -11662,7 +11745,8 @@ static int do_check(struct bpf_verifier_env *env)
 			 */
 			err = check_mem_access(env, env->insn_idx, insn->src_reg,
 					       insn->off, BPF_SIZE(insn->code),
-					       BPF_READ, insn->dst_reg, false);
+					       BPF_READ, insn->dst_reg, false,
+					       NULL);
 			if (err)
 				return err;
 
@@ -11717,7 +11801,8 @@ static int do_check(struct bpf_verifier_env *env)
 			/* check that memory (dst_reg + off) is writeable */
 			err = check_mem_access(env, env->insn_idx, insn->dst_reg,
 					       insn->off, BPF_SIZE(insn->code),
-					       BPF_WRITE, insn->src_reg, false);
+					       BPF_WRITE, insn->src_reg, false,
+					       NULL);
 			if (err)
 				return err;
 
@@ -11751,7 +11836,7 @@ static int do_check(struct bpf_verifier_env *env)
 			/* check that memory (dst_reg + off) is writeable */
 			err = check_mem_access(env, env->insn_idx, insn->dst_reg,
 					       insn->off, BPF_SIZE(insn->code),
-					       BPF_WRITE, -1, false);
+					       BPF_WRITE, -1, false, NULL);
 			if (err)
 				return err;
 
-- 
2.35.1

