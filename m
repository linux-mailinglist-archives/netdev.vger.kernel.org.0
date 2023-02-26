Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05F66A2EEC
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 09:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjBZIwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 03:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBZIw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 03:52:27 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7925414E98;
        Sun, 26 Feb 2023 00:52:13 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id x34so3232996pjj.0;
        Sun, 26 Feb 2023 00:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6XmAB57B8w1uOg5nRsBG+h5HpUo+xYwgJylCU6buYSU=;
        b=QS6WILk7cFWPflxMQmJQBSXK2jh/BS+HOBd3kEpWRi2jJyTH4UosFsKyfpoQbZoo+T
         E1nbs0ebx0m3ERvSQyt1tcSi9NJob9TXVKDqnyoTMhxUxB7x4YEGNELcxZ+KEfnzWJeK
         PtA3IhbdxvFScdKfNqMa2/QQOkdJW2JIl0TXE14FvhjpboBaO1ihMfPmhqyPvOyu9sHq
         sHqbKHcIZiQZhr/GI2zsvpIQhIQBsUoPqVuA5XvJEJQI+GU2zejMVCkSTrS7iEdQxK/4
         EGwiEFTvfe0kGU+gQ+VxrS4RfyAabjzwK/+Ky/x5nUzezAlKMUaeXHEml8a84M2B69TV
         L5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6XmAB57B8w1uOg5nRsBG+h5HpUo+xYwgJylCU6buYSU=;
        b=AxuIKZLZUA6Y7052x797jgYuuLJAuxzkyNWBrwF/hyToNJsoDLBp7UQw0QlDt8aAkk
         6xtLyuDFUjZeskseSnbTo4XXG6nYdLZQsRwXsLh4H414CpOqyMoNz/+yj9dwIpf8hZuj
         OxC6K/ApJNa2YQ9V/NLhqFlwiE6YtA+AA88vPr0mhw+3TEbHHCcs7kd4sOPiiffNFf+J
         1JEhpdJOns+MR2cpWOHCdwM+YPaaLbn+LdBmRSlqankdSYiiNIG/MAd2zAmEQRt/TFbg
         AFNlCFEoplmL/eVaz06eBCDMV6/ZzNJm9OUDuVgN6QFR5YnSEDt59HAEKTuOGaZ5LZ++
         wfmA==
X-Gm-Message-State: AO0yUKXOkf4HI85yMJRl4XuLLLlgqQTha5pM4iVJH0sUwUK4wu1CwLZv
        z8iCWtuQij5z5Va4bDhF6qha9xPMu4c=
X-Google-Smtp-Source: AK7set9ls8lXG1/NZY3U3AhCbL7YYJXn2HuQm/b8wioCv7tnCGMud3nfAIDyQtmt3uJS2aZYGBrN9w==
X-Received: by 2002:a05:6a20:4b0f:b0:bf:e6c:758b with SMTP id fp15-20020a056a204b0f00b000bf0e6c758bmr12525770pzb.4.1677401532638;
        Sun, 26 Feb 2023 00:52:12 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id s10-20020a62e70a000000b00592591d1634sm2227299pfh.97.2023.02.26.00.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 00:52:12 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v12 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
Date:   Sun, 26 Feb 2023 00:51:19 -0800
Message-Id: <20230226085120.3907863-10-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230226085120.3907863-1-joannelkoong@gmail.com>
References: <20230226085120.3907863-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two new kfuncs are added, bpf_dynptr_slice and bpf_dynptr_slice_rdwr.
The user must pass in a buffer to store the contents of the data slice
if a direct pointer to the data cannot be obtained.

For skb and xdp type dynptrs, these two APIs are the only way to obtain
a data slice. However, for other types of dynptrs, there is no
difference between bpf_dynptr_slice(_rdwr) and bpf_dynptr_data.

For skb type dynptrs, the data is copied into the user provided buffer
if any of the data is not in the linear portion of the skb. For xdp type
dynptrs, the data is copied into the user provided buffer if the data is
between xdp frags.

If the skb is cloned and a call to bpf_dynptr_data_rdwr is made, then
the skb will be uncloned (see bpf_unclone_prologue()).

Please note that any bpf_dynptr_write() automatically invalidates any prior
data slices of the skb dynptr. This is because the skb may be cloned or
may need to pull its paged buffer into the head. As such, any
bpf_dynptr_write() will automatically have its prior data slices
invalidated, even if the write is to data in the skb head of an uncloned
skb. Please note as well that any other helper calls that change the
underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
slices of the skb dynptr as well, for the same reasons.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/filter.h         |  14 ++++
 include/uapi/linux/bpf.h       |   5 ++
 kernel/bpf/helpers.c           | 138 +++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c          | 125 ++++++++++++++++++++++++++++-
 net/core/filter.c              |   6 +-
 tools/include/uapi/linux/bpf.h |   5 ++
 6 files changed, 286 insertions(+), 7 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 3f6992261ec5..efa5d4a1677e 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1548,6 +1548,9 @@ int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
 			  u32 len, u64 flags);
 int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u32 len);
 int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u32 len);
+void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len);
+void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
+		      void *buf, unsigned long len, bool flush);
 #else /* CONFIG_NET */
 static inline int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset,
 				       void *to, u32 len)
@@ -1572,6 +1575,17 @@ static inline int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
+{
+	return NULL;
+}
+
+static inline void *bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off, void *buf,
+				     unsigned long len, bool flush)
+{
+	return NULL;
+}
 #endif /* CONFIG_NET */
 
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index faa304c926cf..c9699304aed2 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5329,6 +5329,11 @@ union bpf_attr {
  *		*flags* must be 0 except for skb-type dynptrs.
  *
  *		For skb-type dynptrs:
+ *		    *  All data slices of the dynptr are automatically
+ *		       invalidated after **bpf_dynptr_write**\ (). This is
+ *		       because writing may pull the skb and change the
+ *		       underlying packet buffer.
+ *
  *		    *  For *flags*, please see the flags accepted by
  *		       **bpf_skb_store_bytes**\ ().
  *	Return
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 78fad0e84ca4..33055e4c9e2e 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2194,6 +2194,142 @@ __bpf_kfunc struct task_struct *bpf_task_from_pid(s32 pid)
 	return p;
 }
 
+/**
+ * bpf_dynptr_slice - Obtain a read-only pointer to the dynptr data.
+ *
+ * For non-skb and non-xdp type dynptrs, there is no difference between
+ * bpf_dynptr_slice and bpf_dynptr_data.
+ *
+ * If the intention is to write to the data slice, please use
+ * bpf_dynptr_slice_rdwr.
+ *
+ * The user must check that the returned pointer is not null before using it.
+ *
+ * Please note that in the case of skb and xdp dynptrs, bpf_dynptr_slice
+ * does not change the underlying packet data pointers, so a call to
+ * bpf_dynptr_slice will not invalidate any ctx->data/data_end pointers in
+ * the bpf program.
+ *
+ * @ptr: The dynptr whose data slice to retrieve
+ * @offset: Offset into the dynptr
+ * @buffer: User-provided buffer to copy contents into
+ * @buffer__szk: Size (in bytes) of the buffer. This is the length of the
+ * requested slice. This must be a constant.
+ *
+ * @returns: NULL if the call failed (eg invalid dynptr), pointer to a read-only
+ * data slice (can be either direct pointer to the data or a pointer to the user
+ * provided buffer, with its contents containing the data, if unable to obtain
+ * direct pointer)
+ */
+__bpf_kfunc void *bpf_dynptr_slice(const struct bpf_dynptr_kern *ptr, u32 offset,
+				   void *buffer, u32 buffer__szk)
+{
+	enum bpf_dynptr_type type;
+	u32 len = buffer__szk;
+	int err;
+
+	if (!ptr->data)
+		return 0;
+
+	err = bpf_dynptr_check_off_len(ptr, offset, len);
+	if (err)
+		return 0;
+
+	type = bpf_dynptr_get_type(ptr);
+
+	switch (type) {
+	case BPF_DYNPTR_TYPE_LOCAL:
+	case BPF_DYNPTR_TYPE_RINGBUF:
+		return ptr->data + ptr->offset + offset;
+	case BPF_DYNPTR_TYPE_SKB:
+		return skb_header_pointer(ptr->data, ptr->offset + offset, len, buffer);
+	case BPF_DYNPTR_TYPE_XDP:
+	{
+		void *xdp_ptr = bpf_xdp_pointer(ptr->data, ptr->offset + offset, len);
+		if (xdp_ptr)
+			return xdp_ptr;
+
+		bpf_xdp_copy_buf(ptr->data, ptr->offset + offset, buffer, len, false);
+		return buffer;
+	}
+	default:
+		WARN_ONCE(true, "unknown dynptr type %d\n", type);
+		return 0;
+	}
+}
+
+/**
+ * bpf_dynptr_slice_rdwr - Obtain a writable pointer to the dynptr data.
+ *
+ * For non-skb and non-xdp type dynptrs, there is no difference between
+ * bpf_dynptr_slice and bpf_dynptr_data.
+ *
+ * The returned pointer is writable and may point to either directly the dynptr
+ * data at the requested offset or to the buffer if unable to obtain a direct
+ * data pointer to (example: the requested slice is to the paged area of an skb
+ * packet). In the case where the returned pointer is to the buffer, the user
+ * is responsible for persisting writes through calling bpf_dynptr_write(). This
+ * usually looks something like this pattern:
+ *
+ * struct eth_hdr *eth = bpf_dynptr_slice_rdwr(&dynptr, 0, buffer, sizeof(buffer));
+ * if (!eth)
+ *	return TC_ACT_SHOT;
+ *
+ * // mutate eth header //
+ *
+ * if (eth == buffer)
+ *	bpf_dynptr_write(&ptr, 0, buffer, sizeof(buffer), 0);
+ *
+ * Please note that, as in the example above, the user must check that the
+ * returned pointer is not null before using it.
+ *
+ * Please also note that in the case of skb and xdp dynptrs, bpf_dynptr_slice_rdwr
+ * does not change the underlying packet data pointers, so a call to
+ * bpf_dynptr_slice_rdwr will not invalidate any ctx->data/data_end pointers in
+ * the bpf program.
+ *
+ * @ptr: The dynptr whose data slice to retrieve
+ * @offset: Offset into the dynptr
+ * @buffer: User-provided buffer to copy contents into
+ * @buffer__szk: Size (in bytes) of the buffer. This is the length of the
+ * requested slice. This must be a constant.
+ *
+ * @returns: NULL if the call failed (eg invalid dynptr), pointer to a
+ * data slice (can be either direct pointer to the data or a pointer to the user
+ * provided buffer, with its contents containing the data, if unable to obtain
+ * direct pointer)
+ */
+__bpf_kfunc void *bpf_dynptr_slice_rdwr(const struct bpf_dynptr_kern *ptr, u32 offset,
+					void *buffer, u32 buffer__szk)
+{
+	if (!ptr->data || bpf_dynptr_is_rdonly(ptr))
+		return 0;
+
+	/* bpf_dynptr_slice_rdwr is the same logic as bpf_dynptr_slice.
+	 *
+	 * For skb-type dynptrs, it is safe to write into the returned pointer
+	 * if the bpf program allows skb data writes. There are two possiblities
+	 * that may occur when calling bpf_dynptr_slice_rdwr:
+	 *
+	 * 1) The requested slice is in the head of the skb. In this case, the
+	 * returned pointer is directly to skb data, and if the skb is cloned, the
+	 * verifier will have uncloned it (see bpf_unclone_prologue()) already.
+	 * The pointer can be directly written into.
+	 *
+	 * 2) Some portion of the requested slice is in the paged buffer area.
+	 * In this case, the requested data will be copied out into the buffer
+	 * and the returned pointer will be a pointer to the buffer. The skb
+	 * will not be pulled. To persist the write, the user will need to call
+	 * bpf_dynptr_write(), which will pull the skb and commit the write.
+	 *
+	 * Similarly for xdp programs, if the requested slice is not across xdp
+	 * fragments, then a direct pointer will be returned, otherwise the data
+	 * will be copied out into the buffer and the user will need to call
+	 * bpf_dynptr_write() to commit changes.
+	 */
+	return bpf_dynptr_slice(ptr, offset, buffer, buffer__szk);
+}
+
 __bpf_kfunc void *bpf_cast_to_kern_ctx(void *obj)
 {
 	return obj;
@@ -2263,6 +2399,8 @@ BTF_ID_FLAGS(func, bpf_cast_to_kern_ctx)
 BTF_ID_FLAGS(func, bpf_rdonly_cast)
 BTF_ID_FLAGS(func, bpf_rcu_read_lock)
 BTF_ID_FLAGS(func, bpf_rcu_read_unlock)
+BTF_ID_FLAGS(func, bpf_dynptr_slice, KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_dynptr_slice_rdwr, KF_RET_NULL)
 BTF_SET8_END(common_btf_ids)
 
 static const struct btf_kfunc_id_set common_kfunc_set = {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index cbb8c0178372..a9e806545c0f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -759,6 +759,22 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum bpf_arg_type arg_type)
 	}
 }
 
+static enum bpf_type_flag get_dynptr_type_flag(enum bpf_dynptr_type type)
+{
+	switch (type) {
+	case BPF_DYNPTR_TYPE_LOCAL:
+		return DYNPTR_TYPE_LOCAL;
+	case BPF_DYNPTR_TYPE_RINGBUF:
+		return DYNPTR_TYPE_RINGBUF;
+	case BPF_DYNPTR_TYPE_SKB:
+		return DYNPTR_TYPE_SKB;
+	case BPF_DYNPTR_TYPE_XDP:
+		return DYNPTR_TYPE_XDP;
+	default:
+		return 0;
+	}
+}
+
 static bool dynptr_type_refcounted(enum bpf_dynptr_type type)
 {
 	return type == BPF_DYNPTR_TYPE_RINGBUF;
@@ -1681,6 +1697,12 @@ static bool reg_is_pkt_pointer_any(const struct bpf_reg_state *reg)
 	       reg->type == PTR_TO_PACKET_END;
 }
 
+static bool reg_is_dynptr_slice_pkt(const struct bpf_reg_state *reg)
+{
+	return base_type(reg->type) == PTR_TO_MEM &&
+		(reg->type & DYNPTR_TYPE_SKB || reg->type & DYNPTR_TYPE_XDP);
+}
+
 /* Unmodified PTR_TO_PACKET[_META,_END] register from ctx access. */
 static bool reg_is_init_pkt_pointer(const struct bpf_reg_state *reg,
 				    enum bpf_reg_type which)
@@ -7429,6 +7451,9 @@ static int check_func_proto(const struct bpf_func_proto *fn, int func_id)
 
 /* Packet data might have moved, any old PTR_TO_PACKET[_META,_END]
  * are now invalid, so turn them into unknown SCALAR_VALUE.
+ *
+ * This also applies to dynptr slices belonging to skb and xdp dynptrs,
+ * since these slices point to packet data.
  */
 static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
 {
@@ -7436,7 +7461,7 @@ static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
 	struct bpf_reg_state *reg;
 
 	bpf_for_each_reg_in_vstate(env->cur_state, state, reg, ({
-		if (reg_is_pkt_pointer_any(reg))
+		if (reg_is_pkt_pointer_any(reg) || reg_is_dynptr_slice_pkt(reg))
 			mark_reg_invalid(env, reg);
 	}));
 }
@@ -8688,6 +8713,11 @@ struct bpf_kfunc_call_arg_meta {
 	struct {
 		struct btf_field *field;
 	} arg_rbtree_root;
+	struct {
+		enum bpf_dynptr_type type;
+		u32 id;
+	} initialized_dynptr;
+	u64 mem_size;
 };
 
 static bool is_kfunc_acquire(struct bpf_kfunc_call_arg_meta *meta)
@@ -8761,6 +8791,19 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
 	return __kfunc_param_match_suffix(btf, arg, "__sz");
 }
 
+static bool is_kfunc_arg_const_mem_size(const struct btf *btf,
+					const struct btf_param *arg,
+					const struct bpf_reg_state *reg)
+{
+	const struct btf_type *t;
+
+	t = btf_type_skip_modifiers(btf, arg->type, NULL);
+	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
+		return false;
+
+	return __kfunc_param_match_suffix(btf, arg, "__szk");
+}
+
 static bool is_kfunc_arg_constant(const struct btf *btf, const struct btf_param *arg)
 {
 	return __kfunc_param_match_suffix(btf, arg, "__k");
@@ -8949,6 +8992,8 @@ enum special_kfunc_type {
 	KF_bpf_rbtree_first,
 	KF_bpf_dynptr_from_skb,
 	KF_bpf_dynptr_from_xdp,
+	KF_bpf_dynptr_slice,
+	KF_bpf_dynptr_slice_rdwr,
 };
 
 BTF_SET_START(special_kfunc_set)
@@ -8965,6 +9010,8 @@ BTF_ID(func, bpf_rbtree_add)
 BTF_ID(func, bpf_rbtree_first)
 BTF_ID(func, bpf_dynptr_from_skb)
 BTF_ID(func, bpf_dynptr_from_xdp)
+BTF_ID(func, bpf_dynptr_slice)
+BTF_ID(func, bpf_dynptr_slice_rdwr)
 BTF_SET_END(special_kfunc_set)
 
 BTF_ID_LIST(special_kfunc_list)
@@ -8983,6 +9030,8 @@ BTF_ID(func, bpf_rbtree_add)
 BTF_ID(func, bpf_rbtree_first)
 BTF_ID(func, bpf_dynptr_from_skb)
 BTF_ID(func, bpf_dynptr_from_xdp)
+BTF_ID(func, bpf_dynptr_slice)
+BTF_ID(func, bpf_dynptr_slice_rdwr)
 
 static bool is_kfunc_bpf_rcu_read_lock(struct bpf_kfunc_call_arg_meta *meta)
 {
@@ -9062,7 +9111,10 @@ get_kfunc_ptr_arg_type(struct bpf_verifier_env *env,
 	if (is_kfunc_arg_callback(env, meta->btf, &args[argno]))
 		return KF_ARG_PTR_TO_CALLBACK;
 
-	if (argno + 1 < nargs && is_kfunc_arg_mem_size(meta->btf, &args[argno + 1], &regs[regno + 1]))
+
+	if (argno + 1 < nargs &&
+	    (is_kfunc_arg_mem_size(meta->btf, &args[argno + 1], &regs[regno + 1]) ||
+	     is_kfunc_arg_const_mem_size(meta->btf, &args[argno + 1], &regs[regno + 1])))
 		arg_mem_size = true;
 
 	/* This is the catch all argument type of register types supported by
@@ -9745,6 +9797,18 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 			ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type);
 			if (ret < 0)
 				return ret;
+
+			if (!(dynptr_arg_type & MEM_UNINIT)) {
+				int id = dynptr_id(env, reg);
+
+				if (id < 0) {
+					verbose(env, "verifier internal error: failed to obtain dynptr id\n");
+					return id;
+				}
+				meta->initialized_dynptr.id = id;
+				meta->initialized_dynptr.type = dynptr_get_type(env, reg);
+			}
+
 			break;
 		}
 		case KF_ARG_PTR_TO_LIST_HEAD:
@@ -9840,12 +9904,29 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 				return ret;
 			break;
 		case KF_ARG_PTR_TO_MEM_SIZE:
-			ret = check_kfunc_mem_size_reg(env, &regs[regno + 1], regno + 1);
+			struct bpf_reg_state *size_reg = &regs[regno + 1];
+			const struct btf_param *size_arg = &args[i + 1];
+
+			ret = check_kfunc_mem_size_reg(env, size_reg, regno + 1);
 			if (ret < 0) {
 				verbose(env, "arg#%d arg#%d memory, len pair leads to invalid memory access\n", i, i + 1);
 				return ret;
 			}
-			/* Skip next '__sz' argument */
+
+			if (is_kfunc_arg_const_mem_size(meta->btf, size_arg, size_reg)) {
+				if (meta->arg_constant.found) {
+					verbose(env, "verifier internal error: only one constant argument permitted\n");
+					return -EFAULT;
+				}
+				if (!tnum_is_const(size_reg->var_off)) {
+					verbose(env, "R%d must be a known constant\n", regno + 1);
+					return -EINVAL;
+				}
+				meta->arg_constant.found = true;
+				meta->arg_constant.value = size_reg->var_off.value;
+			}
+
+			/* Skip next '__sz' or '__szk' argument */
 			i++;
 			break;
 		case KF_ARG_PTR_TO_CALLBACK:
@@ -10082,6 +10163,42 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 				regs[BPF_REG_0].type = PTR_TO_BTF_ID | PTR_UNTRUSTED;
 				regs[BPF_REG_0].btf = desc_btf;
 				regs[BPF_REG_0].btf_id = meta.arg_constant.value;
+			} else if (meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice] ||
+				   meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice_rdwr]) {
+				enum bpf_type_flag type_flag = get_dynptr_type_flag(meta.initialized_dynptr.type);
+
+				mark_reg_known_zero(env, regs, BPF_REG_0);
+
+				if (!meta.arg_constant.found) {
+					verbose(env, "verifier internal error: bpf_dynptr_slice(_rdwr) no constant size\n");
+					return -EFAULT;
+				}
+
+				regs[BPF_REG_0].mem_size = meta.arg_constant.value;
+
+				/* PTR_MAYBE_NULL will be added when is_kfunc_ret_null is checked */
+				regs[BPF_REG_0].type = PTR_TO_MEM | type_flag;
+
+				if (meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice]) {
+					regs[BPF_REG_0].type |= MEM_RDONLY;
+				} else {
+					/* this will set env->seen_direct_write to true */
+					if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE)) {
+						verbose(env, "the prog does not allow writes to packet data\n");
+						return -EINVAL;
+					}
+				}
+
+				if (!meta.initialized_dynptr.id) {
+					verbose(env, "verifier internal error: no dynptr id\n");
+					return -EFAULT;
+				}
+				regs[BPF_REG_0].dynptr_id = meta.initialized_dynptr.id;
+
+				/* we don't need to set BPF_REG_0's ref obj id
+				 * because packet slices are not refcounted (see
+				 * dynptr_type_refcounted)
+				 */
 			} else {
 				verbose(env, "kernel function %s unhandled dynamic return type\n",
 					meta.func_name);
diff --git a/net/core/filter.c b/net/core/filter.c
index c692046fa7f6..8f3124e06133 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3894,8 +3894,8 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
-static void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
-			     void *buf, unsigned long len, bool flush)
+void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
+		      void *buf, unsigned long len, bool flush)
 {
 	unsigned long ptr_len, ptr_off = 0;
 	skb_frag_t *next_frag, *end_frag;
@@ -3941,7 +3941,7 @@ static void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
 	}
 }
 
-static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
+void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	u32 size = xdp->data_end - xdp->data;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index faa304c926cf..c9699304aed2 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5329,6 +5329,11 @@ union bpf_attr {
  *		*flags* must be 0 except for skb-type dynptrs.
  *
  *		For skb-type dynptrs:
+ *		    *  All data slices of the dynptr are automatically
+ *		       invalidated after **bpf_dynptr_write**\ (). This is
+ *		       because writing may pull the skb and change the
+ *		       underlying packet buffer.
+ *
  *		    *  For *flags*, please see the flags accepted by
  *		       **bpf_skb_store_bytes**\ ().
  *	Return
-- 
2.34.1

