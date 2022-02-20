Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD024BCED1
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243917AbiBTNtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:49:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243902AbiBTNtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:49:14 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AD42DD47;
        Sun, 20 Feb 2022 05:48:47 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id g1so6436125pfv.1;
        Sun, 20 Feb 2022 05:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a/IXub8HL5Vl5EcFk4Zp2k+suEKjCBlYWofCgvll/y0=;
        b=niqeh3XsoWw9ifbDiRtbVAkZRkx2ueEvJ73ov7B8x+np+2bkxY0PAnDu8EJ+EWswTg
         6tRnVcoVFGflaQixQ3a90h+FWXXXLMHG+F1FR6ym8k7bqmHCG8NS2lIE0KJqktL+3kZJ
         MgUlKjt0Z1sAhdbH4RcnMnh23RpUoHAXP/i2JmN0ha5ZSBZRk9cHTtIBTPNG+IFddiO9
         wqt+KfB3rPzDGYzppznoGt5gdGLLHzJygNltBDBFAJGXTqSN5wGDUXKJfIp6hoFUGXRJ
         65X4YB7I0w0Cube5dcMEu4bdJ5+JkMXR484qUftjpOIhx3R6eB27uxqGYxyuv0jcNTFE
         /h4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a/IXub8HL5Vl5EcFk4Zp2k+suEKjCBlYWofCgvll/y0=;
        b=ymMXW5SUj4RECQJLuWQElS0HO1YyLHn6XANtzYTJRd6pJZ+hq7c3g7Gw326qei+aZw
         308E9yPtZS4U34rSSx73lSlBBLkczrxO0efUpaACe5Vwtx5+4MZWrCroW7rn/A7D4kst
         ag+0RBA0ifAE9o61+la3x21a7tgGWDHvNQA/9IHbwLkbiI6pgt9PApEp6M10tdvDuLNS
         8jZ4cJfF3k11BGDxq5m7A9vCJUmg8Icc3pjv2XI+zHMFA1ikVKtG2VpSj5opPaQUvo03
         NPlVGAPYTuE/482fx0ZBGrygFhk2SwBvgpgD22G8T19wM/TO1H4yeZvnPdlnMQIN76Qq
         mDWQ==
X-Gm-Message-State: AOAM532lRfnmtzeOhTjkwA559GzZxWmsXkUbM38yUITvax6WX7uroxGn
        ZpwgL18ksbimTgWZ+w6JxMlm3ulvDNo=
X-Google-Smtp-Source: ABdhPJxoHVpP4Y64pz05vEJMo5+WmR8xS0Z16EuIWREKBvX+U+nma9p9FrSCV7EU7Nd44a/uTeGIig==
X-Received: by 2002:a63:571d:0:b0:372:8da2:10e1 with SMTP id l29-20020a63571d000000b003728da210e1mr12880439pgb.271.1645364927086;
        Sun, 20 Feb 2022 05:48:47 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id f11sm2471208pfc.189.2022.02.20.05.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:46 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 10/15] bpf: Wire up freeing of referenced PTR_TO_BTF_ID in map
Date:   Sun, 20 Feb 2022 19:18:08 +0530
Message-Id: <20220220134813.3411982-11-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12831; h=from:subject; bh=QBc8MuC6tBr+XK//lUnaSSR8TuHlQJnqJ8GNMM2b2LA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZYBW7WwJp3BM2RCoair/Htzp08YXfnAmB5SiCP 9wPmTiWJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGWAAKCRBM4MiGSL8RyoBPEA CzNv2utzMs/YR1DnI2pVTQgu5rmaiAMdNbkN2oGFMgKRXiLvnQ1lmNiw5kSZe9htcTAmvgf1AGMAyI L5Xwwx1SRYYLHQij7tzkeKAxOF8mkfgDgxoXjvMTgVvkjWDQpKggg1xfrtEjAWEWNNtoFfWNY0HmlJ PDd1AkNFIauIDYaxUmLwkFwbCAbiNjLR68oof38MOGgpyN9/vG6OgnXz/RYVKLPD60wbdlY6+5TDRl t5asBB4MPszBsSENfz3QYhteBMeR/0kKMIghC4+Xvy9uSYQw9CT4r0/JLREDviuhBgrAIMcZWpYDcM 1gYdxhrdtMJpJzPk853wlqvw7cXBwzrpRZ565VW6xk14AIMKAM1VGg/JkuTC2wFrkZUsUghxj5rRrg KE6jiIARf/gNHXzRTnJFzzlWQ8jhZo5vny2lCV9a2uV+V8+UhIPQyaOVfje1rWSURMfTLw6i+ub7d6 jf3mhzJnVPpZyX8Bov2Y/oLhBjB13hJQ7Xt9g+MsTLSbddDkeCcSlJ+UvNhnXGaPo3zQQphOcyg2na 2XBqg9exDLoolg8lcs96+xgaPe0ApslGfNLvY5qp9W75ZxswCyIKm2OEph0THVkUuwlpHQ2IeKB8Un C/HVKOwS5ZPoFjyFk8DEbiijfA787+ZRUFGtlORjsvDU0pMW04uqNWUKgsNQ==
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

A destructor kfunc can be defined as void func(type *), where type may
be void or any other pointer type as per convenience. The kfunc doesn't
have to take care about the map side pointer width, as it will be passed
a pointer after converting the u64 address embedded in the map.

In this patch, we ensure that the type is sane and capture the function
pointer into off_desc of ptr_off_tab for the specific pointer offset,
with the invariant that the dtor pointer is always set when 'ref' tag is
applied to the pointer's pointee type, which is indicated by the flag
BPF_MAP_VALUE_OFF_F_REF.

Note that only BTF IDs whose destructor kfunc is registered, thus become
the allowed BTF IDs for embedding as referenced PTR_TO_BTF_ID. Hence
btf_find_dtor_kfunc serves the purpose of finding dtor kfunc BTF ID, as
well acting as a check against the whitelist of allowed BTF IDs for this
purpose.

Finally, wire up the actual freeing of the referenced pointer if any at
all available offsets, so that no references are leaked after the BPF
map goes away and the BPF program previously moved the ownership a
referenced pointer into it.

The behavior is similar to BPF timers, where bpf_map_{update,delete}_elem
will free any existing referenced PTR_TO_BTF_ID. The same case is with
LRU map's bpf_lru_push_free/htab_lru_push_free functions, which are
extended to reset and free referenced pointers.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h   |  3 ++
 include/linux/btf.h   |  2 ++
 kernel/bpf/arraymap.c | 13 ++++++--
 kernel/bpf/btf.c      | 72 ++++++++++++++++++++++++++++++++++++++++++-
 kernel/bpf/hashtab.c  | 27 ++++++++++------
 kernel/bpf/syscall.c  | 37 ++++++++++++++++++++--
 6 files changed, 139 insertions(+), 15 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5d845ca02eba..744f1886cf91 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/percpu-refcount.h>
 #include <linux/bpfptr.h>
+#include <linux/btf.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -171,6 +172,7 @@ struct bpf_map_value_off_desc {
 	u32 btf_id;
 	struct btf *btf;
 	struct module *module;
+	btf_dtor_kfunc_t dtor; /* only set when flags & BPF_MAP_VALUE_OFF_F_REF is true */
 	int flags;
 };
 
@@ -1568,6 +1570,7 @@ struct bpf_map_value_off_desc *bpf_map_ptr_off_contains(struct bpf_map *map, u32
 void bpf_map_free_ptr_off_tab(struct bpf_map *map);
 struct bpf_map_value_off *bpf_map_copy_ptr_off_tab(const struct bpf_map *map);
 bool bpf_map_equal_ptr_off_tab(const struct bpf_map *map_a, const struct bpf_map *map_b);
+void bpf_map_free_ptr_to_btf_id(struct bpf_map *map, void *map_value);
 
 struct bpf_map *bpf_map_get(u32 ufd);
 struct bpf_map *bpf_map_get_with_uref(u32 ufd);
diff --git a/include/linux/btf.h b/include/linux/btf.h
index a304a1ea39d9..c7e75be9637f 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -46,6 +46,8 @@ struct btf_id_dtor_kfunc {
 	u32 kfunc_btf_id;
 };
 
+typedef void (*btf_dtor_kfunc_t)(void *);
+
 extern const struct file_operations btf_fops;
 
 void btf_get(struct btf *btf);
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 7f145aefbff8..de4baca3edd7 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -287,10 +287,12 @@ static int array_map_get_next_key(struct bpf_map *map, void *key, void *next_key
 	return 0;
 }
 
-static void check_and_free_timer_in_array(struct bpf_array *arr, void *val)
+static void check_and_free_timer_and_ptr_in_array(struct bpf_array *arr, void *val)
 {
 	if (unlikely(map_value_has_timer(&arr->map)))
 		bpf_timer_cancel_and_free(val + arr->map.timer_off);
+	if (unlikely(map_value_has_ptr_to_btf_id(&arr->map)))
+		bpf_map_free_ptr_to_btf_id(&arr->map, val);
 }
 
 /* Called from syscall or from eBPF program */
@@ -327,7 +329,7 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
 			copy_map_value_locked(map, val, value, false);
 		else
 			copy_map_value(map, val, value);
-		check_and_free_timer_in_array(array, val);
+		check_and_free_timer_and_ptr_in_array(array, val);
 	}
 	return 0;
 }
@@ -398,6 +400,13 @@ static void array_map_free_timers(struct bpf_map *map)
 static void array_map_free(struct bpf_map *map)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
+	int i;
+
+	if (unlikely(map_value_has_ptr_to_btf_id(map))) {
+		for (i = 0; i < array->map.max_entries; i++)
+			bpf_map_free_ptr_to_btf_id(map, array->value + array->elem_size * i);
+		bpf_map_free_ptr_off_tab(map);
+	}
 
 	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
 		bpf_array_free_percpu(array);
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 8a6ec1847f17..f322967da54b 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3170,7 +3170,7 @@ static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 	int nr_off, ret, flags = 0;
 	struct module *mod = NULL;
 	struct btf *kernel_btf;
-	s32 id;
+	s32 id, dtor_btf_id;
 
 	/* For PTR, sz is always == 8 */
 	if (!btf_type_is_ptr(t))
@@ -3291,9 +3291,79 @@ static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 	tab->off[nr_off].btf    = kernel_btf;
 	tab->off[nr_off].module = mod;
 	tab->off[nr_off].flags  = flags;
+
+	/* Find and stash the function pointer for the destruction function that
+	 * needs to be eventually invoked from the map free path.
+	 *
+	 * Note that we already took module reference, and the map free path
+	 * always invoked the destructor for BTF ID before freeing ptr_off_tab,
+	 * so calling the function should be safe in that context.
+	 */
+	if (ref_tag) {
+		const struct btf_type *dtor_func, *dtor_func_proto, *t;
+		const struct btf_param *args;
+		const char *dtor_func_name;
+		unsigned long addr;
+		u32 nr_args;
+
+		/* This call also serves as a whitelist of allowed objects that
+		 * can be used as a referenced pointer and be stored in a map at
+		 * the same time.
+		 */
+		dtor_btf_id = btf_find_dtor_kfunc(kernel_btf, id);
+		if (dtor_btf_id < 0) {
+			ret = dtor_btf_id;
+			goto end_mod;
+		}
+
+		dtor_func = btf_type_by_id(kernel_btf, dtor_btf_id);
+		if (!dtor_func || !btf_type_is_func(dtor_func)) {
+			ret = -EINVAL;
+			goto end_mod;
+		}
+
+		dtor_func_proto = btf_type_by_id(kernel_btf, dtor_func->type);
+		if (!dtor_func_proto || !btf_type_is_func_proto(dtor_func_proto)) {
+			ret = -EINVAL;
+			goto end_mod;
+		}
+
+		/* Make sure the prototype of the destructor kfunc is 'void func(type *)' */
+		t = btf_type_by_id(kernel_btf, dtor_func_proto->type);
+		if (!t || !btf_type_is_void(t)) {
+			ret = -EINVAL;
+			goto end_mod;
+		}
+
+		nr_args = btf_type_vlen(dtor_func_proto);
+		args = btf_params(dtor_func_proto);
+
+		t = NULL;
+		if (nr_args)
+			t = btf_type_by_id(kernel_btf, args[0].type);
+		/* Allow any pointer type, as width on targets Linux supports
+		 * will be same for all pointer types (i.e. sizeof(void *))
+		 */
+		if (nr_args != 1 || !t || !btf_type_is_ptr(t)) {
+			ret = -EINVAL;
+			goto end_mod;
+		}
+
+		dtor_func_name = __btf_name_by_offset(kernel_btf, dtor_func->name_off);
+		addr = kallsyms_lookup_name(dtor_func_name);
+		if (!addr) {
+			ret = -EINVAL;
+			goto end_mod;
+		}
+		tab->off[nr_off].dtor = (void *)addr;
+	}
+
 	tab->nr_off++;
 
 	return 0;
+end_mod:
+	if (mod)
+		module_put(mod);
 end_btf:
 	/* Reference is only raised for module BTF */
 	if (btf_is_module(kernel_btf))
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d29af9988f37..3c33b58e8d3e 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -725,12 +725,15 @@ static int htab_lru_map_gen_lookup(struct bpf_map *map,
 	return insn - insn_buf;
 }
 
-static void check_and_free_timer(struct bpf_htab *htab, struct htab_elem *elem)
+static void check_and_free_timer_and_ptr(struct bpf_htab *htab,
+					 struct htab_elem *elem, bool free_ptr)
 {
+	void *map_value = elem->key + round_up(htab->map.key_size, 8);
+
 	if (unlikely(map_value_has_timer(&htab->map)))
-		bpf_timer_cancel_and_free(elem->key +
-					  round_up(htab->map.key_size, 8) +
-					  htab->map.timer_off);
+		bpf_timer_cancel_and_free(map_value + htab->map.timer_off);
+	if (unlikely(map_value_has_ptr_to_btf_id(&htab->map)) && free_ptr)
+		bpf_map_free_ptr_to_btf_id(&htab->map, map_value);
 }
 
 /* It is called from the bpf_lru_list when the LRU needs to delete
@@ -757,7 +760,7 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
 		if (l == tgt_l) {
 			hlist_nulls_del_rcu(&l->hash_node);
-			check_and_free_timer(htab, l);
+			check_and_free_timer_and_ptr(htab, l, true);
 			break;
 		}
 
@@ -829,7 +832,7 @@ static void htab_elem_free(struct bpf_htab *htab, struct htab_elem *l)
 {
 	if (htab->map.map_type == BPF_MAP_TYPE_PERCPU_HASH)
 		free_percpu(htab_elem_get_ptr(l, htab->map.key_size));
-	check_and_free_timer(htab, l);
+	check_and_free_timer_and_ptr(htab, l, true);
 	kfree(l);
 }
 
@@ -857,7 +860,7 @@ static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
 	htab_put_fd_value(htab, l);
 
 	if (htab_is_prealloc(htab)) {
-		check_and_free_timer(htab, l);
+		check_and_free_timer_and_ptr(htab, l, true);
 		__pcpu_freelist_push(&htab->freelist, &l->fnode);
 	} else {
 		atomic_dec(&htab->count);
@@ -1104,7 +1107,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		if (!htab_is_prealloc(htab))
 			free_htab_elem(htab, l_old);
 		else
-			check_and_free_timer(htab, l_old);
+			check_and_free_timer_and_ptr(htab, l_old, true);
 	}
 	ret = 0;
 err:
@@ -1114,7 +1117,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 
 static void htab_lru_push_free(struct bpf_htab *htab, struct htab_elem *elem)
 {
-	check_and_free_timer(htab, elem);
+	check_and_free_timer_and_ptr(htab, elem, true);
 	bpf_lru_push_free(&htab->lru, &elem->lru_node);
 }
 
@@ -1420,7 +1423,10 @@ static void htab_free_malloced_timers(struct bpf_htab *htab)
 		struct htab_elem *l;
 
 		hlist_nulls_for_each_entry(l, n, head, hash_node)
-			check_and_free_timer(htab, l);
+			/* We are called from map_release_uref, so we don't free
+			 * ref'd pointers.
+			 */
+			check_and_free_timer_and_ptr(htab, l, false);
 		cond_resched_rcu();
 	}
 	rcu_read_unlock();
@@ -1458,6 +1464,7 @@ static void htab_map_free(struct bpf_map *map)
 	else
 		prealloc_destroy(htab);
 
+	bpf_map_free_ptr_off_tab(map);
 	free_percpu(htab->extra_elems);
 	bpf_map_area_free(htab->buckets);
 	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 83d71d6912f5..925e8c615ad2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -638,15 +638,48 @@ bool bpf_map_equal_ptr_off_tab(const struct bpf_map *map_a, const struct bpf_map
 	return !memcmp(tab_a, tab_b, size);
 }
 
+/* Caller must ensure map_value_has_ptr_to_btf_id is true. Note that this
+ * function can be called on a map value while the map_value is visible to BPF
+ * programs, as it ensures the correct synchronization, and we already enforce
+ * the same using the verifier on the BPF program side, esp. for referenced
+ * pointers.
+ */
+void bpf_map_free_ptr_to_btf_id(struct bpf_map *map, void *map_value)
+{
+	struct bpf_map_value_off *tab = map->ptr_off_tab;
+	u64 *btf_id_ptr;
+	int i;
+
+	for (i = 0; i < tab->nr_off; i++) {
+		struct bpf_map_value_off_desc *off_desc = &tab->off[i];
+		u64 old_ptr;
+
+		btf_id_ptr = map_value + off_desc->offset;
+		if (!(off_desc->flags & BPF_MAP_VALUE_OFF_F_REF)) {
+			/* On 32-bit platforms, WRITE_ONCE 64-bit store tearing
+			 * into two 32-bit stores is fine for us, as we only
+			 * permit pointer values to be stored at this address,
+			 * which are word sized, so the other half of 64-bit
+			 * value will always be zeroed.
+			 */
+			WRITE_ONCE(*btf_id_ptr, 0);
+			continue;
+		}
+		old_ptr = xchg(btf_id_ptr, 0);
+		off_desc->dtor((void *)old_ptr);
+	}
+}
+
 /* called from workqueue */
 static void bpf_map_free_deferred(struct work_struct *work)
 {
 	struct bpf_map *map = container_of(work, struct bpf_map, work);
 
 	security_bpf_map_free(map);
-	bpf_map_free_ptr_off_tab(map);
 	bpf_map_release_memcg(map);
-	/* implementation dependent freeing */
+	/* implementation dependent freeing, map_free callback also does
+	 * bpf_map_free_ptr_off_tab, if needed.
+	 */
 	map->ops->map_free(map);
 }
 
-- 
2.35.1

