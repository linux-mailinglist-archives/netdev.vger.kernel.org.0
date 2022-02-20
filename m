Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4318E4BCED2
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243869AbiBTNsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:48:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbiBTNst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:48:49 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1A721813;
        Sun, 20 Feb 2022 05:48:26 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id 4so2246438pll.6;
        Sun, 20 Feb 2022 05:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wlBIsnH0cG6LQh9cPjAUVPWs/qbSZZzGZWdz+JWcGgs=;
        b=R5HVDARgtEwOYoUsLzS0LJJgYPBdFFz50uE2VhghE7ZnNGkQN7+VdP58Jh2irNM6q1
         rdgdQWR5okhIOnp6lZboesGRWVVzaNhBpFombMTzuRc9Z7FUHe53oafNWCTxCvtUyeWC
         B1OZjHS6ds0noBUUYTzY8G2rNkzf6FDh3JXQ5IIrYBXT1PIscrgW2jzVU/EYisK05/eK
         RXQ+jBIAnDFPrtRovmDx5KRhwQwsUL5ZRqzHL04vggp2CMxKh7UiwBi6ZKNfe468b6AH
         NXco8h2ILRMTLpXwnc44TcyqPAVAYj/d1AqAiJ4SLf4R3L8YkyUJ1PFnTI4EtjEKMu6a
         p+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wlBIsnH0cG6LQh9cPjAUVPWs/qbSZZzGZWdz+JWcGgs=;
        b=SPtNeK7u0nlXsGB8pzvOdttZRJV3HZYTSQnTRsyfvHWCY2nMWDNd/ALzvnav0YYzHP
         dwk/fK6g89CGZdHjLTnUQLjEBo9TZX/MoCaiB+uWtCE6oyncOYaY9bReLq447HQ+STT1
         AoEe0xZM/fR4TXs5YL4hLOQatAldEuLj8IOzWyWTqOYCOM9ks+l9Y+m8rW2cKOHmahHr
         FHKS1MbtIqeWFuIKSI+FL9pwSRTUsfy5teSDG0G3UZFLmKP2LV6YSaMgHV7MEpx4P2DA
         GUT4PqpfSIQU6jry5L/dG/azXGkB3wTUHvL7cMIFnUwxK8ud5wOhcDr5W+j3OzYVghh6
         oeww==
X-Gm-Message-State: AOAM532l7pubDYjbs5FX+jXvGFF3U51VJuAbCVLVGuwZNuklpycvvWwj
        /fePmOl4sworYx1OVXZV70w+9mDyOJQ=
X-Google-Smtp-Source: ABdhPJweIPU5lrBHjH2fVoa9iVnlb0wr7l5BlsktMwnVLLYOth0b1H03rowUEBlxB+Pie4poW5H6IQ==
X-Received: by 2002:a17:902:f550:b0:14f:acf1:c729 with SMTP id h16-20020a170902f55000b0014facf1c729mr2709329plf.82.1645364905776;
        Sun, 20 Feb 2022 05:48:25 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id s40sm9912412pfg.145.2022.02.20.05.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:25 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 03/15] bpf: Allow storing PTR_TO_BTF_ID in map
Date:   Sun, 20 Feb 2022 19:18:01 +0530
Message-Id: <20220220134813.3411982-4-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=23122; h=from:subject; bh=Nb8zX0dVk97u11szAu1GlZRnuc4N89+pLNYcp4j10s4=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZXQMiMs7iuzB4JYSESy0NQTkyUd6JOnePf0E0E W3g6Im+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGVwAKCRBM4MiGSL8RyiHUD/ 9n6kpwLhIHGbeTy8TFGprPpkGWJpHhirh87uKHU1HoinLOQspJ7yuw8xTM5kYISyVVK+ZiOpLvjrnF S/rVBTo+rDzwdH1yR2134bNAeZGaFLmNz0Ya0iY19ZN74UDkEXNKbMLButkeaJUMnEZe6i1JO+vClm E1wcPFMN2rhbrMFcrNY+5PpKfr2+hDBP6h4uipI5pC64uuccnbK5lOE25Kr9a+/ygLuiUjkM95akXg jzrlLRNH8tverRbt/YApGurALEEAqOLhHKs8UZGZW2uxtdy3nJ08B++Yf5V4GaOwuURGPLlXINQpJE FAbGunsJKZ1tW5CVFOUDjHiJdgGcNXRG/vDGIUXFXVFWaeDfySHfSiYaGNrZ/evnTRxCgRoEu3268x vRyQchrgTepdGCQTnXHaWrX4G6NSeZzxWgD8CkxZA22E1pd9uL/dgA6vmFrWFrTx+0XC9EYEQvIE+t sqCLe+/ntURIx0+wK1r2sA8NE6U4Pmbem64w8zCB2Fmb3iRbQW7QMNEmLe5f2BzY/NZh2D0u6Q+OqU ruc/I4uC/x68EzHrugLzER0fYxRnNDrI+JCr3TUZDK1bmN/KyNAROjzhi7LIpc2RGg37zyoJqS9ff8 K/3ohuV9+JtSjjqQ/xY1cIFo4DSDytPQY1i71GUnC/hZGZ8rOeHDVeTHiLaw==
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

This patch allows user to embed PTR_TO_BTF_ID in map value, such that
loading it marks the destination register as having the appropriate
register type and such a pointer can be dereferenced like usual
PTR_TO_BTF_ID and be passed to various BPF helpers.

This feature can be useful to store an object in a map for a long time,
and then inspect it later. Since PTR_TO_BTF_ID is safe against invalid
access, verifier doesn't need to perform any complex lifetime checks. It
can be useful in cases where user already knows pointer will remain
valid, so any dereference at a later time (possibly in entirely
different BPF program invocation) will yield correct results as far the
data read from kernel memory is concerned.

Note that it is quite possible such BTF ID pointer is invalid, in this
case the verifier's built-in exception handling mechanism where it
converts loads into PTR_TO_BTF_ID into PROBE_MEM loads, would handle the
invalid case. Next patch which adds referenced PTR_TO_BTF_ID would need
to take more care in ensuring a correct value is stored in the BPF map.

The user indicates that a certain pointer must be treated as
PTR_TO_BTF_ID by using a BTF type tag 'btf_id' on the pointed to type of
the pointer. Then, this information is recorded in the object BTF which
will be passed into the kernel by way of map's BTF information.

The kernel then records the type, and offset of all such pointers, and
finds their corresponding built-in kernel type by the name and BTF kind.

Later, during verification this information is used that access to such
pointers is sized correctly, and done at a proper offset into the map
value. Only BPF_LDX, BPF_STX, and BPF_ST with 0 (to denote NULL) are
allowed instructions that can access such a pointer. On BPF_LDX, the
destination register is updated to be a PTR_TO_BTF_ID, and on BPF_STX,
it is checked whether the source register type is same PTR_TO_BTF_ID,
and whether the BTF ID (reg->btf and reg->btf_id) matches the type
specified in the map value's definition.

Hence, the verifier allows flexible access to kernel data across program
invocations in a type safe manner, without compromising on the runtime
safety of the kernel.

Next patch will extend this support to referenced PTR_TO_BTF_ID.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h     |  30 +++++++-
 include/linux/btf.h     |   3 +
 kernel/bpf/btf.c        | 127 ++++++++++++++++++++++++++++++++++
 kernel/bpf/map_in_map.c |   5 +-
 kernel/bpf/syscall.c    | 137 ++++++++++++++++++++++++++++++++++++-
 kernel/bpf/verifier.c   | 148 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 446 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f19abc59b6cd..ce45ffb79f82 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -155,6 +155,23 @@ struct bpf_map_ops {
 	const struct bpf_iter_seq_info *iter_seq_info;
 };
 
+enum {
+	/* Support at most 8 pointers in a BPF map value */
+	BPF_MAP_VALUE_OFF_MAX = 8,
+};
+
+struct bpf_map_value_off_desc {
+	u32 offset;
+	u32 btf_id;
+	struct btf *btf;
+	struct module *module;
+};
+
+struct bpf_map_value_off {
+	u32 nr_off;
+	struct bpf_map_value_off_desc off[];
+};
+
 struct bpf_map {
 	/* The first two cachelines with read-mostly members of which some
 	 * are also accessed in fast-path (e.g. ops, max_entries).
@@ -171,6 +188,7 @@ struct bpf_map {
 	u64 map_extra; /* any per-map-type extra fields */
 	u32 map_flags;
 	int spin_lock_off; /* >=0 valid offset, <0 error */
+	struct bpf_map_value_off *ptr_off_tab;
 	int timer_off; /* >=0 valid offset, <0 error */
 	u32 id;
 	int numa_node;
@@ -184,7 +202,7 @@ struct bpf_map {
 	char name[BPF_OBJ_NAME_LEN];
 	bool bypass_spec_v1;
 	bool frozen; /* write-once; write-protected by freeze_mutex */
-	/* 14 bytes hole */
+	/* 6 bytes hole */
 
 	/* The 3rd and 4th cacheline with misc members to avoid false sharing
 	 * particularly with refcounting.
@@ -217,6 +235,11 @@ static inline bool map_value_has_timer(const struct bpf_map *map)
 	return map->timer_off >= 0;
 }
 
+static inline bool map_value_has_ptr_to_btf_id(const struct bpf_map *map)
+{
+	return !IS_ERR_OR_NULL(map->ptr_off_tab);
+}
+
 static inline void check_and_init_map_value(struct bpf_map *map, void *dst)
 {
 	if (unlikely(map_value_has_spin_lock(map)))
@@ -1490,6 +1513,11 @@ void bpf_prog_put(struct bpf_prog *prog);
 void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock);
 void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock);
 
+struct bpf_map_value_off_desc *bpf_map_ptr_off_contains(struct bpf_map *map, u32 offset);
+void bpf_map_free_ptr_off_tab(struct bpf_map *map);
+struct bpf_map_value_off *bpf_map_copy_ptr_off_tab(const struct bpf_map *map);
+bool bpf_map_equal_ptr_off_tab(const struct bpf_map *map_a, const struct bpf_map *map_b);
+
 struct bpf_map *bpf_map_get(u32 ufd);
 struct bpf_map *bpf_map_get_with_uref(u32 ufd);
 struct bpf_map *__bpf_map_get(struct fd f);
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 36bc09b8e890..6592183aeb23 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -26,6 +26,7 @@ struct btf_type;
 union bpf_attr;
 struct btf_show;
 struct btf_id_set;
+struct bpf_map;
 
 struct btf_kfunc_id_set {
 	struct module *owner;
@@ -123,6 +124,8 @@ bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
 			   u32 expected_offset, u32 expected_size);
 int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t);
 int btf_find_timer(const struct btf *btf, const struct btf_type *t);
+int btf_find_ptr_to_btf_id(const struct btf *btf, const struct btf_type *t,
+			   struct bpf_map *map);
 bool btf_type_is_void(const struct btf_type *t);
 s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 kind);
 const struct btf_type *btf_type_skip_modifiers(const struct btf *btf,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 55f6ccac3388..1edb5710e155 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3122,6 +3122,7 @@ static void btf_struct_log(struct btf_verifier_env *env,
 enum {
 	BTF_FIELD_SPIN_LOCK,
 	BTF_FIELD_TIMER,
+	BTF_FIELD_KPTR,
 };
 
 static int btf_find_field_struct(const struct btf *btf, const struct btf_type *t,
@@ -3140,6 +3141,106 @@ static int btf_find_field_struct(const struct btf *btf, const struct btf_type *t
 	return 0;
 }
 
+static s32 btf_find_by_name_kind_all(const char *name, u32 kind, struct btf **btfp);
+
+static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
+			       u32 off, int sz, void *data)
+{
+	struct bpf_map_value_off *tab;
+	struct bpf_map *map = data;
+	struct module *mod = NULL;
+	bool btf_id_tag = false;
+	struct btf *kernel_btf;
+	int nr_off, ret;
+	s32 id;
+
+	/* For PTR, sz is always == 8 */
+	if (!btf_type_is_ptr(t))
+		return 0;
+	t = btf_type_by_id(btf, t->type);
+
+	while (btf_type_is_type_tag(t)) {
+		if (!strcmp("kernel.bpf.btf_id", __btf_name_by_offset(btf, t->name_off))) {
+			/* repeated tag */
+			if (btf_id_tag) {
+				ret = -EINVAL;
+				goto end;
+			}
+			btf_id_tag = true;
+		} else if (!strncmp("kernel.", __btf_name_by_offset(btf, t->name_off),
+			   sizeof("kernel.") - 1)) {
+			/* TODO: Should we reject these when loading BTF? */
+			/* Unavailable tag in reserved tag namespace */
+			ret = -EACCES;
+			goto end;
+		}
+		/* Look for next tag */
+		t = btf_type_by_id(btf, t->type);
+	}
+	if (!btf_id_tag)
+		return 0;
+
+	/* Get the base type */
+	if (btf_type_is_modifier(t))
+		t = btf_type_skip_modifiers(btf, t->type, NULL);
+	/* Only pointer to struct is allowed */
+	if (!__btf_type_is_struct(t)) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	id = btf_find_by_name_kind_all(__btf_name_by_offset(btf, t->name_off),
+				       BTF_INFO_KIND(t->info), &kernel_btf);
+	if (id < 0) {
+		ret = id;
+		goto end;
+	}
+
+	nr_off = map->ptr_off_tab ? map->ptr_off_tab->nr_off : 0;
+	if (nr_off == BPF_MAP_VALUE_OFF_MAX) {
+		ret = -E2BIG;
+		goto end_btf;
+	}
+
+	tab = krealloc(map->ptr_off_tab, offsetof(struct bpf_map_value_off, off[nr_off + 1]),
+		       GFP_KERNEL | __GFP_NOWARN);
+	if (!tab) {
+		ret = -ENOMEM;
+		goto end_btf;
+	}
+	/* Initialize nr_off for newly allocated ptr_off_tab */
+	if (!map->ptr_off_tab)
+		tab->nr_off = 0;
+	map->ptr_off_tab = tab;
+
+	/* We take reference to make sure valid pointers into module data don't
+	 * become invalid across program invocation.
+	 */
+	if (btf_is_module(kernel_btf)) {
+		mod = btf_try_get_module(kernel_btf);
+		if (!mod) {
+			ret = -ENXIO;
+			goto end_btf;
+		}
+	}
+
+	tab->off[nr_off].offset = off;
+	tab->off[nr_off].btf_id = id;
+	tab->off[nr_off].btf    = kernel_btf;
+	tab->off[nr_off].module = mod;
+	tab->nr_off++;
+
+	return 0;
+end_btf:
+	/* Reference is only raised for module BTF */
+	if (btf_is_module(kernel_btf))
+		btf_put(kernel_btf);
+end:
+	bpf_map_free_ptr_off_tab(map);
+	map->ptr_off_tab = ERR_PTR(ret);
+	return ret;
+}
+
 static int btf_find_struct_field(const struct btf *btf, const struct btf_type *t,
 				 const char *name, int sz, int align, int field_type,
 				 void *data)
@@ -3170,6 +3271,11 @@ static int btf_find_struct_field(const struct btf *btf, const struct btf_type *t
 			if (ret < 0)
 				return ret;
 			break;
+		case BTF_FIELD_KPTR:
+			ret = btf_find_field_kptr(btf, member_type, off, sz, data);
+			if (ret < 0)
+				return ret;
+			break;
 		default:
 			pr_err("verifier bug: unknown field type requested\n");
 			return -EFAULT;
@@ -3206,6 +3312,11 @@ static int btf_find_datasec_var(const struct btf *btf, const struct btf_type *t,
 			if (ret < 0)
 				return ret;
 			break;
+		case BTF_FIELD_KPTR:
+			ret = btf_find_field_kptr(btf, var_type, off, sz, data);
+			if (ret < 0)
+				return ret;
+			break;
 		default:
 			return -EFAULT;
 		}
@@ -3256,6 +3367,22 @@ int btf_find_timer(const struct btf *btf, const struct btf_type *t)
 	return off;
 }
 
+int btf_find_ptr_to_btf_id(const struct btf *btf, const struct btf_type *t,
+			   struct bpf_map *map)
+{
+	int ret;
+
+	ret = btf_find_field(btf, t, NULL, sizeof(u64), __alignof__(u64),
+			     BTF_FIELD_KPTR, map);
+	/* While btf_find_field_kptr cleans up after itself, later iterations
+	 * can still return error without calling it, so call free function
+	 * again.
+	 */
+	if (ret < 0)
+		bpf_map_free_ptr_off_tab(map);
+	return ret;
+}
+
 static void __btf_struct_show(const struct btf *btf, const struct btf_type *t,
 			      u32 type_id, void *data, u8 bits_offset,
 			      struct btf_show *show)
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 5cd8f5277279..293e41a4f0b3 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -52,6 +52,7 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 	inner_map_meta->max_entries = inner_map->max_entries;
 	inner_map_meta->spin_lock_off = inner_map->spin_lock_off;
 	inner_map_meta->timer_off = inner_map->timer_off;
+	inner_map_meta->ptr_off_tab = bpf_map_copy_ptr_off_tab(inner_map);
 	if (inner_map->btf) {
 		btf_get(inner_map->btf);
 		inner_map_meta->btf = inner_map->btf;
@@ -71,6 +72,7 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 
 void bpf_map_meta_free(struct bpf_map *map_meta)
 {
+	bpf_map_free_ptr_off_tab(map_meta);
 	btf_put(map_meta->btf);
 	kfree(map_meta);
 }
@@ -83,7 +85,8 @@ bool bpf_map_meta_equal(const struct bpf_map *meta0,
 		meta0->key_size == meta1->key_size &&
 		meta0->value_size == meta1->value_size &&
 		meta0->timer_off == meta1->timer_off &&
-		meta0->map_flags == meta1->map_flags;
+		meta0->map_flags == meta1->map_flags &&
+		bpf_map_equal_ptr_off_tab(meta0, meta1);
 }
 
 void *bpf_map_fd_get_ptr(struct bpf_map *map,
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9c7a72b65eee..beb96866f34d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -6,6 +6,7 @@
 #include <linux/bpf_trace.h>
 #include <linux/bpf_lirc.h>
 #include <linux/bpf_verifier.h>
+#include <linux/bsearch.h>
 #include <linux/btf.h>
 #include <linux/syscalls.h>
 #include <linux/slab.h>
@@ -472,12 +473,123 @@ static void bpf_map_release_memcg(struct bpf_map *map)
 }
 #endif
 
+static int bpf_map_ptr_off_cmp(const void *a, const void *b)
+{
+	const struct bpf_map_value_off_desc *off_desc1 = a, *off_desc2 = b;
+
+	if (off_desc1->offset < off_desc2->offset)
+		return -1;
+	else if (off_desc1->offset > off_desc2->offset)
+		return 1;
+	return 0;
+}
+
+struct bpf_map_value_off_desc *bpf_map_ptr_off_contains(struct bpf_map *map, u32 offset)
+{
+	/* Since members are iterated in btf_find_field in increasing order,
+	 * offsets appended to ptr_off_tab are in increasing order, so we can
+	 * do bsearch to find exact match.
+	 */
+	struct bpf_map_value_off *tab;
+
+	if (!map_value_has_ptr_to_btf_id(map))
+		return NULL;
+	tab = map->ptr_off_tab;
+	return bsearch(&offset, tab->off, tab->nr_off, sizeof(tab->off[0]), bpf_map_ptr_off_cmp);
+}
+
+void bpf_map_free_ptr_off_tab(struct bpf_map *map)
+{
+	struct bpf_map_value_off *tab = map->ptr_off_tab;
+	int i;
+
+	if (IS_ERR_OR_NULL(tab))
+		return;
+	for (i = 0; i < tab->nr_off; i++) {
+		struct module *mod = tab->off[i].module;
+		struct btf *btf = tab->off[i].btf;
+
+		/* off[i].btf is obtained from bpf_btf_find_by_name_kind_all,
+		 * which only takes reference for module BTF, not vmlinux BTF.
+		 */
+		if (btf_is_module(btf)) {
+			module_put(mod);
+			btf_put(btf);
+		}
+	}
+	kfree(tab);
+	map->ptr_off_tab = NULL;
+}
+
+struct bpf_map_value_off *bpf_map_copy_ptr_off_tab(const struct bpf_map *map)
+{
+	struct bpf_map_value_off *tab = map->ptr_off_tab, *new_tab;
+	int size, i, ret;
+
+	if (IS_ERR_OR_NULL(tab))
+		return tab;
+	/* Increment references that we have to transfer into the new
+	 * ptr_off_tab.
+	 */
+	for (i = 0; i < tab->nr_off; i++) {
+		struct btf *btf = tab->off[i].btf;
+
+		if (btf_is_module(btf)) {
+			if (!btf_try_get_module(btf)) {
+				ret = -ENXIO;
+				/* No references for off_desc at index 'i' have
+				 * been taken at this point, so the cleanup loop
+				 * at 'end' will start releasing from previous
+				 * index.
+				 */
+				goto end;
+			}
+			btf_get(btf);
+		}
+	}
+
+	size = offsetof(struct bpf_map_value_off, off[tab->nr_off]);
+	new_tab = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
+	if (!new_tab) {
+		ret = -ENOMEM;
+		goto end;
+	}
+	memcpy(new_tab, tab, size);
+	return new_tab;
+end:
+	while (i--) {
+		if (btf_is_module(tab->off[i].btf)) {
+			module_put(tab->off[i].module);
+			btf_put(tab->off[i].btf);
+		}
+	}
+	return ERR_PTR(ret);
+}
+
+bool bpf_map_equal_ptr_off_tab(const struct bpf_map *map_a, const struct bpf_map *map_b)
+{
+	struct bpf_map_value_off *tab_a = map_a->ptr_off_tab, *tab_b = map_b->ptr_off_tab;
+	int size;
+
+	if (IS_ERR(tab_a) || IS_ERR(tab_b))
+		return false;
+	if (!tab_a && !tab_b)
+		return true;
+	if ((!tab_a && tab_b) || (tab_a && !tab_b))
+		return false;
+	if (tab_a->nr_off != tab_b->nr_off)
+		return false;
+	size = offsetof(struct bpf_map_value_off, off[tab_a->nr_off]);
+	return !memcmp(tab_a, tab_b, size);
+}
+
 /* called from workqueue */
 static void bpf_map_free_deferred(struct work_struct *work)
 {
 	struct bpf_map *map = container_of(work, struct bpf_map, work);
 
 	security_bpf_map_free(map);
+	bpf_map_free_ptr_off_tab(map);
 	bpf_map_release_memcg(map);
 	/* implementation dependent freeing */
 	map->ops->map_free(map);
@@ -639,7 +751,7 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
 	int err;
 
 	if (!map->ops->map_mmap || map_value_has_spin_lock(map) ||
-	    map_value_has_timer(map))
+	    map_value_has_timer(map) || map_value_has_ptr_to_btf_id(map))
 		return -ENOTSUPP;
 
 	if (!(vma->vm_flags & VM_SHARED))
@@ -819,9 +931,30 @@ static int map_check_btf(struct bpf_map *map, const struct btf *btf,
 			return -EOPNOTSUPP;
 	}
 
-	if (map->ops->map_check_btf)
+	/* We can ignore the return value */
+	btf_find_ptr_to_btf_id(btf, value_type, map);
+	if (map_value_has_ptr_to_btf_id(map)) {
+		if (map->map_flags & BPF_F_RDONLY_PROG) {
+			ret = -EACCES;
+			goto free_map_tab;
+		}
+		if (map->map_type != BPF_MAP_TYPE_HASH &&
+		    map->map_type != BPF_MAP_TYPE_LRU_HASH &&
+		    map->map_type != BPF_MAP_TYPE_ARRAY) {
+			ret = -EOPNOTSUPP;
+			goto free_map_tab;
+		}
+	}
+
+	if (map->ops->map_check_btf) {
 		ret = map->ops->map_check_btf(map, btf, key_type, value_type);
+		if (ret < 0)
+			goto free_map_tab;
+	}
 
+	return ret;
+free_map_tab:
+	bpf_map_free_ptr_off_tab(map);
 	return ret;
 }
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d7473fee247c..1ffefddebaea 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3465,6 +3465,118 @@ static int check_mem_region_access(struct bpf_verifier_env *env, u32 regno,
 	return 0;
 }
 
+static int map_ptr_to_btf_id_match_type(struct bpf_verifier_env *env,
+					struct bpf_map_value_off_desc *off_desc,
+					struct bpf_reg_state *reg, u32 regno)
+{
+	const char *targ_name = kernel_type_name(off_desc->btf, off_desc->btf_id);
+	const char *reg_name = "";
+
+	if (reg->type != PTR_TO_BTF_ID && reg->type != PTR_TO_BTF_ID_OR_NULL)
+		goto end;
+
+	if (!btf_is_kernel(reg->btf)) {
+		verbose(env, "R%d must point to kernel BTF\n", regno);
+		return -EINVAL;
+	}
+	/* We need to verify reg->type and reg->btf, before accessing reg->btf */
+	reg_name = kernel_type_name(reg->btf, reg->btf_id);
+
+	if (reg->off < 0) {
+		verbose(env,
+			"R%d is ptr_%s invalid negative access: off=%d\n",
+			regno, reg_name, reg->off);
+		return -EINVAL;
+	}
+
+	if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
+		char tn_buf[48];
+
+		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
+		verbose(env,
+			"R%d is ptr_%s invalid variable offset: off=%d, var_off=%s\n",
+			regno, reg_name, reg->off, tn_buf);
+		return -EINVAL;
+	}
+
+	if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, reg->off,
+				  off_desc->btf, off_desc->btf_id))
+		goto end;
+	return 0;
+end:
+	verbose(env, "invalid btf_id pointer access, R%d type=%s%s ", regno,
+		reg_type_str(env, reg->type), reg_name);
+	verbose(env, "expected=%s%s\n", reg_type_str(env, PTR_TO_BTF_ID), targ_name);
+	return -EINVAL;
+}
+
+/* Returns an error, or 0 if ignoring the access, or 1 if register state was
+ * updated, in which case later updates must be skipped.
+ */
+static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int off, int size,
+				   int value_regno, enum bpf_access_type t, int insn_idx)
+{
+	struct bpf_reg_state *reg = reg_state(env, regno), *val_reg;
+	struct bpf_insn *insn = &env->prog->insnsi[insn_idx];
+	struct bpf_map_value_off_desc *off_desc;
+	int insn_class = BPF_CLASS(insn->code);
+	struct bpf_map *map = reg->map_ptr;
+
+	/* Things we already checked for in check_map_access:
+	 *  - Reject cases where variable offset may touch BTF ID pointer
+	 *  - size of access (must be BPF_DW)
+	 *  - off_desc->offset == off + reg->var_off.value
+	 */
+	if (!tnum_is_const(reg->var_off))
+		return 0;
+
+	off_desc = bpf_map_ptr_off_contains(map, off + reg->var_off.value);
+	if (!off_desc)
+		return 0;
+
+	if (WARN_ON_ONCE(size != bpf_size_to_bytes(BPF_DW)))
+		return -EACCES;
+
+	if (BPF_MODE(insn->code) != BPF_MEM)
+		goto end;
+
+	if (!env->bpf_capable) {
+		verbose(env, "btf_id pointer in map only allowed for CAP_BPF and CAP_SYS_ADMIN\n");
+		return -EPERM;
+	}
+
+	if (insn_class == BPF_LDX) {
+		if (WARN_ON_ONCE(value_regno < 0))
+			return -EFAULT;
+		val_reg = reg_state(env, value_regno);
+		/* We can simply mark the value_regno receiving the pointer
+		 * value from map as PTR_TO_BTF_ID, with the correct type.
+		 */
+		mark_btf_ld_reg(env, cur_regs(env), value_regno, PTR_TO_BTF_ID, off_desc->btf,
+				off_desc->btf_id, PTR_MAYBE_NULL);
+		val_reg->id = ++env->id_gen;
+	} else if (insn_class == BPF_STX) {
+		if (WARN_ON_ONCE(value_regno < 0))
+			return -EFAULT;
+		val_reg = reg_state(env, value_regno);
+		if (!register_is_null(val_reg) &&
+		    map_ptr_to_btf_id_match_type(env, off_desc, val_reg, value_regno))
+			return -EACCES;
+	} else if (insn_class == BPF_ST) {
+		if (insn->imm) {
+			verbose(env, "BPF_ST imm must be 0 when writing to btf_id pointer at off=%u\n",
+				off_desc->offset);
+			return -EACCES;
+		}
+	} else {
+		goto end;
+	}
+	return 1;
+end:
+	verbose(env, "btf_id pointer in map can only be accessed using BPF_LDX/BPF_STX/BPF_ST\n");
+	return -EACCES;
+}
+
 /* check read/write into a map element with possible variable offset */
 static int check_map_access(struct bpf_verifier_env *env, u32 regno,
 			    int off, int size, bool zero_size_allowed)
@@ -3503,6 +3615,36 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
 			return -EACCES;
 		}
 	}
+	if (map_value_has_ptr_to_btf_id(map)) {
+		struct bpf_map_value_off *tab = map->ptr_off_tab;
+		bool known_off = tnum_is_const(reg->var_off);
+		int i;
+
+		for (i = 0; i < tab->nr_off; i++) {
+			u32 p = tab->off[i].offset;
+
+			if (reg->smin_value + off < p + sizeof(u64) &&
+			    p < reg->umax_value + off + size) {
+				if (!known_off) {
+					verbose(env, "btf_id pointer cannot be accessed by variable offset load/store\n");
+					return -EACCES;
+				}
+				if (p != off + reg->var_off.value) {
+					verbose(env, "btf_id pointer offset incorrect\n");
+					return -EACCES;
+				}
+				if (size != sizeof(u64)) {
+					verbose(env, "btf_id pointer load/store size must be 8\n");
+					return -EACCES;
+				}
+				break;
+			}
+		}
+	} else if (IS_ERR(map->ptr_off_tab)) {
+		/* Reject program using map with incorrectly tagged btf_id pointer */
+		verbose(env, "invalid btf_id pointer tagging in map value\n");
+		return PTR_ERR(map->ptr_off_tab);
+	}
 	return err;
 }
 
@@ -4404,6 +4546,10 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		if (err)
 			return err;
 		err = check_map_access(env, regno, off, size, false);
+		if (!err)
+			err = check_map_ptr_to_btf_id(env, regno, off, size, value_regno,
+						      t, insn_idx);
+		/* if err == 0, check_map_ptr_to_btf_id ignored the access */
 		if (!err && t == BPF_READ && value_regno >= 0) {
 			struct bpf_map *map = reg->map_ptr;
 
@@ -4425,6 +4571,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 				mark_reg_unknown(env, regs, value_regno);
 			}
 		}
+		if (err == 1)
+			err = 0;
 	} else if (base_type(reg->type) == PTR_TO_MEM) {
 		bool rdonly_mem = type_is_rdonly_mem(reg->type);
 
-- 
2.35.1

