Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E83469EEB6
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 07:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjBVGTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 01:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjBVGTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 01:19:50 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28783302A4
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 22:19:47 -0800 (PST)
Received: by devvm20151.prn0.facebook.com (Postfix, from userid 115148)
        id C9993F67D30; Tue, 21 Feb 2023 22:08:28 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com, toke@kernel.org,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v11 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
Date:   Tue, 21 Feb 2023 22:07:46 -0800
Message-Id: <20230222060747.2562549-10-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230222060747.2562549-1-joannelkoong@gmail.com>
References: <20230222060747.2562549-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,HELO_MISC_IP,NML_ADSP_CUSTOM_MED,
        RDNS_DYNAMIC,SPF_HELO_PASS,SPF_SOFTFAIL,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
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

Please note that any bpf_dynptr_write() automatically invalidates any pri=
or
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
 kernel/bpf/verifier.c          |  91 +++++++++++++++++++++-
 net/core/filter.c              |   6 +-
 tools/include/uapi/linux/bpf.h |   5 ++
 6 files changed, 253 insertions(+), 6 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 3f6992261ec5..efa5d4a1677e 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1548,6 +1548,9 @@ int __bpf_skb_store_bytes(struct sk_buff *skb, u32 =
offset, const void *from,
 			  u32 len, u64 flags);
 int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u3=
2 len);
 int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u=
32 len);
+void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len);
+void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
+		      void *buf, unsigned long len, bool flush);
 #else /* CONFIG_NET */
 static inline int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 of=
fset,
 				       void *to, u32 len)
@@ -1572,6 +1575,17 @@ static inline int __bpf_xdp_store_bytes(struct xdp=
_buff *xdp, u32 offset,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u3=
2 len)
+{
+	return NULL;
+}
+
+static inline void *bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long=
 off, void *buf,
+				     unsigned long len, bool flush)
+{
+	return NULL;
+}
 #endif /* CONFIG_NET */
=20
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
index 989be97b0f81..2e7f99801a0e 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2177,6 +2177,142 @@ __bpf_kfunc struct task_struct *bpf_task_from_pid=
(s32 pid)
 	return p;
 }
=20
+/**
+ * bpf_dynptr_slice - Obtain a read-only pointer to the dynptr data.
+ *
+ * For non-skb and non-xdp type dynptrs, there is no difference between
+ * bpf_dynptr_slice and bpf_dynptr_data.
+ *
+ * If the intention is to write to the data slice, please use
+ * bpf_dynptr_slice_rdwr.
+ *
+ * The user must check that the returned pointer is not null before usin=
g it.
+ *
+ * Please note that in the case of skb and xdp dynptrs, bpf_dynptr_slice
+ * does not change the underlying packet data pointers, so a call to
+ * bpf_dynptr_slice will not invalidate any ctx->data/data_end pointers =
in
+ * the bpf program.
+ *
+ * @ptr: The dynptr whose data slice to retrieve
+ * @offset: Offset into the dynptr
+ * @buffer: User-provided buffer to copy contents into
+ * @buffer__sz: Size (in bytes) of the buffer. This is the length of the
+ * requested slice
+ *
+ * @returns: NULL if the call failed (eg invalid dynptr), pointer to a r=
ead-only
+ * data slice (can be either direct pointer to the data or a pointer to =
the user
+ * provided buffer, with its contents containing the data, if unable to =
obtain
+ * direct pointer)
+ */
+__bpf_kfunc void *bpf_dynptr_slice(const struct bpf_dynptr_kern *ptr, u3=
2 offset,
+				   void *buffer, u32 buffer__sz)
+{
+	enum bpf_dynptr_type type;
+	u32 len =3D buffer__sz;
+	int err;
+
+	if (!ptr->data)
+		return 0;
+
+	err =3D bpf_dynptr_check_off_len(ptr, offset, len);
+	if (err)
+		return 0;
+
+	type =3D bpf_dynptr_get_type(ptr);
+
+	switch (type) {
+	case BPF_DYNPTR_TYPE_LOCAL:
+	case BPF_DYNPTR_TYPE_RINGBUF:
+		return ptr->data + ptr->offset + offset;
+	case BPF_DYNPTR_TYPE_SKB:
+		return skb_header_pointer(ptr->data, ptr->offset + offset, len, buffer=
);
+	case BPF_DYNPTR_TYPE_XDP:
+	{
+		void *xdp_ptr =3D bpf_xdp_pointer(ptr->data, ptr->offset + offset, len=
);
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
+ * The returned pointer is writable and may point to either directly the=
 dynptr
+ * data at the requested offset or to the buffer if unable to obtain a d=
irect
+ * data pointer to (example: the requested slice is to the paged area of=
 an skb
+ * packet). In the case where the returned pointer is to the buffer, the=
 user
+ * is responsible for persisting writes through calling bpf_dynptr_write=
(). This
+ * usually looks something like this pattern:
+ *
+ * struct eth_hdr *eth =3D bpf_dynptr_slice_rdwr(&dynptr, 0, buffer, siz=
eof(buffer));
+ * if (!eth)
+ *	return TC_ACT_SHOT;
+ *
+ * // mutate eth header //
+ *
+ * if (eth =3D=3D buffer)
+ *	bpf_dynptr_write(&ptr, 0, buffer, sizeof(buffer), 0);
+ *
+ * Please note that, as in the example above, the user must check that t=
he
+ * returned pointer is not null before using it.
+ *
+ * Please also note that in the case of skb and xdp dynptrs, bpf_dynptr_=
slice_rdwr
+ * does not change the underlying packet data pointers, so a call to
+ * bpf_dynptr_slice_rdwr will not invalidate any ctx->data/data_end poin=
ters in
+ * the bpf program.
+ *
+ * @ptr: The dynptr whose data slice to retrieve
+ * @offset: Offset into the dynptr
+ * @buffer: User-provided buffer to copy contents into
+ * @buffer__sz: Size (in bytes) of the buffer. This is the length of the
+ * requested slice
+ *
+ * @returns: NULL if the call failed (eg invalid dynptr), pointer to a
+ * data slice (can be either direct pointer to the data or a pointer to =
the user
+ * provided buffer, with its contents containing the data, if unable to =
obtain
+ * direct pointer)
+ */
+__bpf_kfunc void *bpf_dynptr_slice_rdwr(const struct bpf_dynptr_kern *pt=
r, u32 offset,
+					void *buffer, u32 buffer__sz)
+{
+	if (!ptr->data || bpf_dynptr_is_rdonly(ptr))
+		return 0;
+
+	/* bpf_dynptr_slice_rdwr is the same logic as bpf_dynptr_slice.
+	 *
+	 * For skb-type dynptrs, it is safe to write into the returned pointer
+	 * if the bpf program allows skb data writes. There are two possiblitie=
s
+	 * that may occur when calling bpf_dynptr_slice_rdwr:
+	 *
+	 * 1) The requested slice is in the head of the skb. In this case, the
+	 * returned pointer is directly to skb data, and if the skb is cloned, =
the
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
+	 * fragments, then a direct pointer will be returned, otherwise the dat=
a
+	 * will be copied out into the buffer and the user will need to call
+	 * bpf_dynptr_write() to commit changes.
+	 */
+	return bpf_dynptr_slice(ptr, offset, buffer, buffer__sz);
+}
+
 __bpf_kfunc void *bpf_cast_to_kern_ctx(void *obj)
 {
 	return obj;
@@ -2245,6 +2381,8 @@ BTF_ID_FLAGS(func, bpf_cast_to_kern_ctx)
 BTF_ID_FLAGS(func, bpf_rdonly_cast)
 BTF_ID_FLAGS(func, bpf_rcu_read_lock)
 BTF_ID_FLAGS(func, bpf_rcu_read_unlock)
+BTF_ID_FLAGS(func, bpf_dynptr_slice, KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_dynptr_slice_rdwr, KF_RET_NULL)
 BTF_SET8_END(common_btf_ids)
=20
 static const struct btf_kfunc_id_set common_kfunc_set =3D {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 90007cb19e92..0bad14347a12 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -759,6 +759,22 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum =
bpf_arg_type arg_type)
 	}
 }
=20
+static enum bpf_type_flag get_dynptr_type_flag(enum bpf_dynptr_type type=
)
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
 	return type =3D=3D BPF_DYNPTR_TYPE_RINGBUF;
@@ -1677,6 +1693,12 @@ static bool reg_is_pkt_pointer_any(const struct bp=
f_reg_state *reg)
 	       reg->type =3D=3D PTR_TO_PACKET_END;
 }
=20
+static bool reg_is_dynptr_slice_pkt(const struct bpf_reg_state *reg)
+{
+	return base_type(reg->type) =3D=3D PTR_TO_MEM &&
+		(reg->type & DYNPTR_TYPE_SKB || reg->type & DYNPTR_TYPE_XDP);
+}
+
 /* Unmodified PTR_TO_PACKET[_META,_END] register from ctx access. */
 static bool reg_is_init_pkt_pointer(const struct bpf_reg_state *reg,
 				    enum bpf_reg_type which)
@@ -7404,6 +7426,9 @@ static int check_func_proto(const struct bpf_func_p=
roto *fn, int func_id)
=20
 /* Packet data might have moved, any old PTR_TO_PACKET[_META,_END]
  * are now invalid, so turn them into unknown SCALAR_VALUE.
+ *
+ * This also applies to dynptr slices belonging to skb and xdp dynptrs,
+ * since these slices point to packet data.
  */
 static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
 {
@@ -7411,7 +7436,7 @@ static void clear_all_pkt_pointers(struct bpf_verif=
ier_env *env)
 	struct bpf_reg_state *reg;
=20
 	bpf_for_each_reg_in_vstate(env->cur_state, state, reg, ({
-		if (reg_is_pkt_pointer_any(reg))
+		if (reg_is_pkt_pointer_any(reg) || reg_is_dynptr_slice_pkt(reg))
 			__mark_reg_unknown(env, reg);
 	}));
 }
@@ -8667,6 +8692,11 @@ struct bpf_kfunc_call_arg_meta {
 	struct {
 		struct btf_field *field;
 	} arg_rbtree_root;
+	struct {
+		enum bpf_dynptr_type type;
+		u32 id;
+	} initialized_dynptr;
+	u64 mem_size;
 };
=20
 static bool is_kfunc_acquire(struct bpf_kfunc_call_arg_meta *meta)
@@ -8928,6 +8958,8 @@ enum special_kfunc_type {
 	KF_bpf_rbtree_first,
 	KF_bpf_dynptr_from_skb,
 	KF_bpf_dynptr_from_xdp,
+	KF_bpf_dynptr_slice,
+	KF_bpf_dynptr_slice_rdwr,
 };
=20
 BTF_SET_START(special_kfunc_set)
@@ -8944,6 +8976,8 @@ BTF_ID(func, bpf_rbtree_add)
 BTF_ID(func, bpf_rbtree_first)
 BTF_ID(func, bpf_dynptr_from_skb)
 BTF_ID(func, bpf_dynptr_from_xdp)
+BTF_ID(func, bpf_dynptr_slice)
+BTF_ID(func, bpf_dynptr_slice_rdwr)
 BTF_SET_END(special_kfunc_set)
=20
 BTF_ID_LIST(special_kfunc_list)
@@ -8962,6 +8996,8 @@ BTF_ID(func, bpf_rbtree_add)
 BTF_ID(func, bpf_rbtree_first)
 BTF_ID(func, bpf_dynptr_from_skb)
 BTF_ID(func, bpf_dynptr_from_xdp)
+BTF_ID(func, bpf_dynptr_slice)
+BTF_ID(func, bpf_dynptr_slice_rdwr)
=20
 static bool is_kfunc_bpf_rcu_read_lock(struct bpf_kfunc_call_arg_meta *m=
eta)
 {
@@ -9725,6 +9761,18 @@ static int check_kfunc_args(struct bpf_verifier_en=
v *env, struct bpf_kfunc_call_
 			ret =3D process_dynptr_func(env, regno, insn_idx, dynptr_arg_type);
 			if (ret < 0)
 				return ret;
+
+			if (!(dynptr_arg_type & MEM_UNINIT)) {
+				int id =3D dynptr_id(env, reg);
+
+				if (id < 0) {
+					verbose(env, "verifier internal error: failed to obtain dynptr id\n=
");
+					return id;
+				}
+				meta->initialized_dynptr.id =3D id;
+				meta->initialized_dynptr.type =3D dynptr_get_type(env, reg);
+			}
+
 			break;
 		}
 		case KF_ARG_PTR_TO_LIST_HEAD:
@@ -9975,8 +10023,7 @@ static int check_kfunc_call(struct bpf_verifier_en=
v *env, struct bpf_insn *insn,
 		}
 	}
=20
-	for (i =3D 0; i < CALLER_SAVED_REGS; i++)
-		mark_reg_not_init(env, regs, caller_saved[i]);
+	mark_reg_not_init(env, regs, caller_saved[BPF_REG_0]);
=20
 	/* Check return type */
 	t =3D btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
@@ -10062,6 +10109,41 @@ static int check_kfunc_call(struct bpf_verifier_=
env *env, struct bpf_insn *insn,
 				regs[BPF_REG_0].type =3D PTR_TO_BTF_ID | PTR_UNTRUSTED;
 				regs[BPF_REG_0].btf =3D desc_btf;
 				regs[BPF_REG_0].btf_id =3D meta.arg_constant.value;
+			} else if (meta.func_id =3D=3D special_kfunc_list[KF_bpf_dynptr_slice=
] ||
+				   meta.func_id =3D=3D special_kfunc_list[KF_bpf_dynptr_slice_rdwr])=
 {
+				enum bpf_type_flag type_flag =3D get_dynptr_type_flag(meta.initializ=
ed_dynptr.type);
+
+				mark_reg_known_zero(env, regs, BPF_REG_0);
+
+				if (!tnum_is_const(regs[BPF_REG_4].var_off)) {
+					verbose(env, "mem_size must be a constant\n");
+					return -EINVAL;
+				}
+				regs[BPF_REG_0].mem_size =3D regs[BPF_REG_4].var_off.value;
+
+				/* PTR_MAYBE_NULL will be added when is_kfunc_ret_null is checked */
+				regs[BPF_REG_0].type =3D PTR_TO_MEM | type_flag;
+
+				if (meta.func_id =3D=3D special_kfunc_list[KF_bpf_dynptr_slice]) {
+					regs[BPF_REG_0].type |=3D MEM_RDONLY;
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
+				regs[BPF_REG_0].dynptr_id =3D meta.initialized_dynptr.id;
+
+				/* we don't need to set BPF_REG_0's ref obj id
+				 * because packet slices are not refcounted (see
+				 * dynptr_type_refcounted)
+				 */
 			} else {
 				verbose(env, "kernel function %s unhandled dynamic return type\n",
 					meta.func_name);
@@ -10121,6 +10203,9 @@ static int check_kfunc_call(struct bpf_verifier_e=
nv *env, struct bpf_insn *insn,
 			regs[BPF_REG_0].id =3D ++env->id_gen;
 	} /* else { add_kfunc_call() ensures it is btf_type_is_void(t) } */
=20
+	for (i =3D BPF_REG_1; i < CALLER_SAVED_REGS; i++)
+		mark_reg_not_init(env, regs, caller_saved[i]);
+
 	nargs =3D btf_type_vlen(func_proto);
 	args =3D (const struct btf_param *)(func_proto + 1);
 	for (i =3D 0; i < nargs; i++) {
diff --git a/net/core/filter.c b/net/core/filter.c
index c692046fa7f6..8f3124e06133 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3894,8 +3894,8 @@ static const struct bpf_func_proto bpf_xdp_adjust_h=
ead_proto =3D {
 	.arg2_type	=3D ARG_ANYTHING,
 };
=20
-static void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
-			     void *buf, unsigned long len, bool flush)
+void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
+		      void *buf, unsigned long len, bool flush)
 {
 	unsigned long ptr_len, ptr_off =3D 0;
 	skb_frag_t *next_frag, *end_frag;
@@ -3941,7 +3941,7 @@ static void bpf_xdp_copy_buf(struct xdp_buff *xdp, =
unsigned long off,
 	}
 }
=20
-static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
+void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
 {
 	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
 	u32 size =3D xdp->data_end - xdp->data;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
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
--=20
2.30.2

