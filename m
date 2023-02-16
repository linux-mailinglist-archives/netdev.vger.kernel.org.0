Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C974C69A023
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 23:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjBPW4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 17:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjBPW4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 17:56:30 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C991B38EA8
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 14:56:25 -0800 (PST)
Received: by devvm15675.prn0.facebook.com (Postfix, from userid 115148)
        id AE55B6A5C84F; Thu, 16 Feb 2023 14:56:09 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, memxor@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v10 bpf-next 6/9] bpf: Add skb dynptrs
Date:   Thu, 16 Feb 2023 14:55:21 -0800
Message-Id: <20230216225524.1192789-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230216225524.1192789-1-joannelkoong@gmail.com>
References: <20230216225524.1192789-1-joannelkoong@gmail.com>
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

Add skb dynptrs, which are dynptrs whose underlying pointer points
to a skb. The dynptr acts on skb data. skb dynptrs have two main
benefits. One is that they allow operations on sizes that are not
statically known at compile-time (eg variable-sized accesses).
Another is that parsing the packet data through dynptrs (instead of
through direct access of skb->data and skb->data_end) can be more
ergonomic and less brittle (eg does not need manual if checking for
being within bounds of data_end).

For bpf prog types that don't support writes on skb data, the dynptr is
read-only (bpf_dynptr_write() will return an error)

For reads and writes through the bpf_dynptr_read() and bpf_dynptr_write()
interfaces, reading and writing from/to data in the head as well as from/=
to
non-linear paged buffers is supported. Data slices through the
bpf_dynptr_data API are not supported; instead bpf_dynptr_slice() and
bpf_dynptr_slice_rdwr() (added in subsequent commit) should be used.

For examples of how skb dynptrs can be used, please see the attached
selftests.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/bpf.h            | 14 ++++++-
 include/linux/filter.h         | 18 ++++++++
 include/uapi/linux/bpf.h       | 14 ++++++-
 kernel/bpf/btf.c               | 18 ++++++++
 kernel/bpf/helpers.c           | 76 +++++++++++++++++++++++++++-------
 kernel/bpf/verifier.c          | 70 ++++++++++++++++++++++++++++++-
 net/core/filter.c              | 67 ++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 14 ++++++-
 8 files changed, 270 insertions(+), 21 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 296841a31749..3d18be35a5e6 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -607,11 +607,14 @@ enum bpf_type_flag {
 	 */
 	NON_OWN_REF		=3D BIT(14 + BPF_BASE_TYPE_BITS),
=20
+	/* DYNPTR points to sk_buff */
+	DYNPTR_TYPE_SKB		=3D BIT(15 + BPF_BASE_TYPE_BITS),
+
 	__BPF_TYPE_FLAG_MAX,
 	__BPF_TYPE_LAST_FLAG	=3D __BPF_TYPE_FLAG_MAX - 1,
 };
=20
-#define DYNPTR_TYPE_FLAG_MASK	(DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF)
+#define DYNPTR_TYPE_FLAG_MASK	(DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF |=
 DYNPTR_TYPE_SKB)
=20
 /* Max number of base types. */
 #define BPF_BASE_TYPE_LIMIT	(1UL << BPF_BASE_TYPE_BITS)
@@ -1146,6 +1149,8 @@ enum bpf_dynptr_type {
 	BPF_DYNPTR_TYPE_LOCAL,
 	/* Underlying data is a ringbuf record */
 	BPF_DYNPTR_TYPE_RINGBUF,
+	/* Underlying data is a sk_buff */
+	BPF_DYNPTR_TYPE_SKB,
 };
=20
 int bpf_dynptr_check_size(u32 size);
@@ -2846,6 +2851,8 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_typ=
e type,
 				struct bpf_insn *insn_buf,
 				struct bpf_prog *prog,
 				u32 *target_size);
+int bpf_dynptr_from_skb_rdonly(struct sk_buff *skb, u64 flags,
+			       struct bpf_dynptr_kern *ptr);
 #else
 static inline bool bpf_sock_common_is_valid_access(int off, int size,
 						   enum bpf_access_type type,
@@ -2867,6 +2874,11 @@ static inline u32 bpf_sock_convert_ctx_access(enum=
 bpf_access_type type,
 {
 	return 0;
 }
+static inline int bpf_dynptr_from_skb_rdonly(struct sk_buff *skb, u64 fl=
ags,
+					     struct bpf_dynptr_kern *ptr)
+{
+	return 0;
+}
 #endif
=20
 #ifdef CONFIG_INET
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1727898f1641..de18e844d15e 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1542,4 +1542,22 @@ static __always_inline int __bpf_xdp_redirect_map(=
struct bpf_map *map, u64 index
 	return XDP_REDIRECT;
 }
=20
+#ifdef CONFIG_NET
+int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to=
, u32 len);
+int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *f=
rom,
+			  u32 len, u64 flags);
+#else /* CONFIG_NET */
+static inline int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 of=
fset,
+				       void *to, u32 len)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset,
+					const void *from, u32 len, u64 flags)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_NET */
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1503f61336b6..4c229e0866db 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5320,11 +5320,17 @@ union bpf_attr {
  *	Description
  *		Write *len* bytes from *src* into *dst*, starting from *offset*
  *		into *dst*.
- *		*flags* is currently unused.
+ *
+ *		*flags* must be 0 except for skb-type dynptrs.
+ *
+ *		For skb-type dynptrs:
+ *		    *  For *flags*, please see the flags accepted by
+ *		       **bpf_skb_store_bytes**\ ().
  *	Return
  *		0 on success, -E2BIG if *offset* + *len* exceeds the length
  *		of *dst*'s data, -EINVAL if *dst* is an invalid dynptr or if *dst*
- *		is a read-only dynptr or if *flags* is not 0.
+ *		is a read-only dynptr or if *flags* is not correct. For skb-type dyn=
ptrs,
+ *		other errors correspond to errors returned by **bpf_skb_store_bytes*=
*\ ().
  *
  * void *bpf_dynptr_data(const struct bpf_dynptr *ptr, u32 offset, u32 l=
en)
  *	Description
@@ -5332,6 +5338,10 @@ union bpf_attr {
  *
  *		*len* must be a statically known value. The returned data slice
  *		is invalidated whenever the dynptr is invalidated.
+ *
+ *		skb type dynptrs may not use bpf_dynptr_data. They should
+ *		instead use bpf_dynptr_slice and bpf_dynptr_slice_rdwr.
+ *
  *	Return
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ae321c358699..ea2ab8cc3710 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -207,6 +207,11 @@ enum btf_kfunc_hook {
 	BTF_KFUNC_HOOK_TRACING,
 	BTF_KFUNC_HOOK_SYSCALL,
 	BTF_KFUNC_HOOK_FMODRET,
+	BTF_KFUNC_HOOK_CGROUP_SKB,
+	BTF_KFUNC_HOOK_SCHED_ACT,
+	BTF_KFUNC_HOOK_SK_SKB,
+	BTF_KFUNC_HOOK_SOCKET_FILTER,
+	BTF_KFUNC_HOOK_LWT,
 	BTF_KFUNC_HOOK_MAX,
 };
=20
@@ -7699,6 +7704,19 @@ static int bpf_prog_type_to_kfunc_hook(enum bpf_pr=
og_type prog_type)
 		return BTF_KFUNC_HOOK_TRACING;
 	case BPF_PROG_TYPE_SYSCALL:
 		return BTF_KFUNC_HOOK_SYSCALL;
+	case BPF_PROG_TYPE_CGROUP_SKB:
+		return BTF_KFUNC_HOOK_CGROUP_SKB;
+	case BPF_PROG_TYPE_SCHED_ACT:
+		return BTF_KFUNC_HOOK_SCHED_ACT;
+	case BPF_PROG_TYPE_SK_SKB:
+		return BTF_KFUNC_HOOK_SK_SKB;
+	case BPF_PROG_TYPE_SOCKET_FILTER:
+		return BTF_KFUNC_HOOK_SOCKET_FILTER;
+	case BPF_PROG_TYPE_LWT_OUT:
+	case BPF_PROG_TYPE_LWT_IN:
+	case BPF_PROG_TYPE_LWT_XMIT:
+	case BPF_PROG_TYPE_LWT_SEG6LOCAL:
+		return BTF_KFUNC_HOOK_LWT;
 	default:
 		return BTF_KFUNC_HOOK_MAX;
 	}
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5b278a38ae58..b9d357bdbd1d 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1420,11 +1420,21 @@ static bool bpf_dynptr_is_rdonly(const struct bpf=
_dynptr_kern *ptr)
 	return ptr->size & DYNPTR_RDONLY_BIT;
 }
=20
+void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr)
+{
+	ptr->size |=3D DYNPTR_RDONLY_BIT;
+}
+
 static void bpf_dynptr_set_type(struct bpf_dynptr_kern *ptr, enum bpf_dy=
nptr_type type)
 {
 	ptr->size |=3D type << DYNPTR_TYPE_SHIFT;
 }
=20
+static enum bpf_dynptr_type bpf_dynptr_get_type(const struct bpf_dynptr_=
kern *ptr)
+{
+	return (ptr->size & ~(DYNPTR_RDONLY_BIT)) >> DYNPTR_TYPE_SHIFT;
+}
+
 u32 bpf_dynptr_get_size(const struct bpf_dynptr_kern *ptr)
 {
 	return ptr->size & DYNPTR_SIZE_MASK;
@@ -1497,6 +1507,7 @@ static const struct bpf_func_proto bpf_dynptr_from_=
mem_proto =3D {
 BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, const struct bpf_dynp=
tr_kern *, src,
 	   u32, offset, u64, flags)
 {
+	enum bpf_dynptr_type type;
 	int err;
=20
 	if (!src->data || flags)
@@ -1506,13 +1517,23 @@ BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len=
, const struct bpf_dynptr_kern
 	if (err)
 		return err;
=20
-	/* Source and destination may possibly overlap, hence use memmove to
-	 * copy the data. E.g. bpf_dynptr_from_mem may create two dynptr
-	 * pointing to overlapping PTR_TO_MAP_VALUE regions.
-	 */
-	memmove(dst, src->data + src->offset + offset, len);
+	type =3D bpf_dynptr_get_type(src);
=20
-	return 0;
+	switch (type) {
+	case BPF_DYNPTR_TYPE_LOCAL:
+	case BPF_DYNPTR_TYPE_RINGBUF:
+		/* Source and destination may possibly overlap, hence use memmove to
+		 * copy the data. E.g. bpf_dynptr_from_mem may create two dynptr
+		 * pointing to overlapping PTR_TO_MAP_VALUE regions.
+		 */
+		memmove(dst, src->data + src->offset + offset, len);
+		return 0;
+	case BPF_DYNPTR_TYPE_SKB:
+		return __bpf_skb_load_bytes(src->data, src->offset + offset, dst, len)=
;
+	default:
+		WARN_ONCE(true, "bpf_dynptr_read: unknown dynptr type %d\n", type);
+		return -EFAULT;
+	}
 }
=20
 static const struct bpf_func_proto bpf_dynptr_read_proto =3D {
@@ -1529,22 +1550,36 @@ static const struct bpf_func_proto bpf_dynptr_rea=
d_proto =3D {
 BPF_CALL_5(bpf_dynptr_write, const struct bpf_dynptr_kern *, dst, u32, o=
ffset, void *, src,
 	   u32, len, u64, flags)
 {
+	enum bpf_dynptr_type type;
 	int err;
=20
-	if (!dst->data || flags || bpf_dynptr_is_rdonly(dst))
+	if (!dst->data || bpf_dynptr_is_rdonly(dst))
 		return -EINVAL;
=20
 	err =3D bpf_dynptr_check_off_len(dst, offset, len);
 	if (err)
 		return err;
=20
-	/* Source and destination may possibly overlap, hence use memmove to
-	 * copy the data. E.g. bpf_dynptr_from_mem may create two dynptr
-	 * pointing to overlapping PTR_TO_MAP_VALUE regions.
-	 */
-	memmove(dst->data + dst->offset + offset, src, len);
+	type =3D bpf_dynptr_get_type(dst);
=20
-	return 0;
+	switch (type) {
+	case BPF_DYNPTR_TYPE_LOCAL:
+	case BPF_DYNPTR_TYPE_RINGBUF:
+		if (flags)
+			return -EINVAL;
+		/* Source and destination may possibly overlap, hence use memmove to
+		 * copy the data. E.g. bpf_dynptr_from_mem may create two dynptr
+		 * pointing to overlapping PTR_TO_MAP_VALUE regions.
+		 */
+		memmove(dst->data + dst->offset + offset, src, len);
+		return 0;
+	case BPF_DYNPTR_TYPE_SKB:
+		return __bpf_skb_store_bytes(dst->data, dst->offset + offset, src, len=
,
+					     flags);
+	default:
+		WARN_ONCE(true, "bpf_dynptr_write: unknown dynptr type %d\n", type);
+		return -EFAULT;
+	}
 }
=20
 static const struct bpf_func_proto bpf_dynptr_write_proto =3D {
@@ -1560,6 +1595,7 @@ static const struct bpf_func_proto bpf_dynptr_write=
_proto =3D {
=20
 BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, of=
fset, u32, len)
 {
+	enum bpf_dynptr_type type;
 	int err;
=20
 	if (!ptr->data)
@@ -1572,7 +1608,19 @@ BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynpt=
r_kern *, ptr, u32, offset, u3
 	if (bpf_dynptr_is_rdonly(ptr))
 		return 0;
=20
-	return (unsigned long)(ptr->data + ptr->offset + offset);
+	type =3D bpf_dynptr_get_type(ptr);
+
+	switch (type) {
+	case BPF_DYNPTR_TYPE_LOCAL:
+	case BPF_DYNPTR_TYPE_RINGBUF:
+		return (unsigned long)(ptr->data + ptr->offset + offset);
+	case BPF_DYNPTR_TYPE_SKB:
+		/* skb dynptrs should use bpf_dynptr_slice / bpf_dynptr_slice_rdwr */
+		return 0;
+	default:
+		WARN_ONCE(true, "bpf_dynptr_data: unknown dynptr type %d\n", type);
+		return 0;
+	}
 }
=20
 static const struct bpf_func_proto bpf_dynptr_data_proto =3D {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index babc82e93ae6..7297f0d83792 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -750,6 +750,8 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum b=
pf_arg_type arg_type)
 		return BPF_DYNPTR_TYPE_LOCAL;
 	case DYNPTR_TYPE_RINGBUF:
 		return BPF_DYNPTR_TYPE_RINGBUF;
+	case DYNPTR_TYPE_SKB:
+		return BPF_DYNPTR_TYPE_SKB;
 	default:
 		return BPF_DYNPTR_TYPE_INVALID;
 	}
@@ -6286,6 +6288,9 @@ int process_dynptr_func(struct bpf_verifier_env *en=
v, int regno, int insn_idx,
 			case DYNPTR_TYPE_RINGBUF:
 				err_extra =3D "ringbuf";
 				break;
+			case DYNPTR_TYPE_SKB:
+				err_extra =3D "skb ";
+				break;
 			default:
 				err_extra =3D "<unknown>";
 				break;
@@ -6712,6 +6717,24 @@ static int dynptr_ref_obj_id(struct bpf_verifier_e=
nv *env, struct bpf_reg_state
 	return state->stack[spi].spilled_ptr.ref_obj_id;
 }
=20
+static enum bpf_dynptr_type dynptr_get_type(struct bpf_verifier_env *env=
,
+					    struct bpf_reg_state *reg)
+{
+	struct bpf_func_state *state =3D func(env, reg);
+	int spi;
+
+	if (reg->type =3D=3D CONST_PTR_TO_DYNPTR)
+		return reg->dynptr.type;
+
+	spi =3D __get_spi(reg->off);
+	if (spi < 0) {
+		verbose(env, "verifier internal error: invalid spi when querying dynpt=
r type\n");
+		return BPF_DYNPTR_TYPE_INVALID;
+	}
+
+	return state->stack[spi].spilled_ptr.dynptr.type;
+}
+
 static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			  struct bpf_call_arg_meta *meta,
 			  const struct bpf_func_proto *fn,
@@ -8362,6 +8385,27 @@ static int check_helper_call(struct bpf_verifier_e=
nv *env, struct bpf_insn *insn
=20
 		break;
 	}
+	case BPF_FUNC_dynptr_write:
+	{
+		enum bpf_dynptr_type dynptr_type;
+		struct bpf_reg_state *reg;
+
+		reg =3D get_dynptr_arg_reg(env, fn, regs);
+		if (!reg)
+			return -EFAULT;
+
+		dynptr_type =3D dynptr_get_type(env, reg);
+		if (dynptr_type =3D=3D BPF_DYNPTR_TYPE_INVALID)
+			return -EFAULT;
+
+		if (dynptr_type =3D=3D BPF_DYNPTR_TYPE_SKB)
+			/* this will trigger clear_all_pkt_pointers(), which will
+			 * invalidate all dynptr slices associated with the skb
+			 */
+			changes_data =3D true;
+
+		break;
+	}
 	case BPF_FUNC_user_ringbuf_drain:
 		err =3D __check_func_call(env, insn, insn_idx_p, meta.subprogno,
 					set_user_ringbuf_callback_state);
@@ -8872,6 +8916,7 @@ enum special_kfunc_type {
 	KF_bpf_rbtree_remove,
 	KF_bpf_rbtree_add,
 	KF_bpf_rbtree_first,
+	KF_bpf_dynptr_from_skb,
 };
=20
 BTF_SET_START(special_kfunc_set)
@@ -8886,6 +8931,7 @@ BTF_ID(func, bpf_rdonly_cast)
 BTF_ID(func, bpf_rbtree_remove)
 BTF_ID(func, bpf_rbtree_add)
 BTF_ID(func, bpf_rbtree_first)
+BTF_ID(func, bpf_dynptr_from_skb)
 BTF_SET_END(special_kfunc_set)
=20
 BTF_ID_LIST(special_kfunc_list)
@@ -8902,6 +8948,7 @@ BTF_ID(func, bpf_rcu_read_unlock)
 BTF_ID(func, bpf_rbtree_remove)
 BTF_ID(func, bpf_rbtree_add)
 BTF_ID(func, bpf_rbtree_first)
+BTF_ID(func, bpf_dynptr_from_skb)
=20
 static bool is_kfunc_bpf_rcu_read_lock(struct bpf_kfunc_call_arg_meta *m=
eta)
 {
@@ -9642,17 +9689,25 @@ static int check_kfunc_args(struct bpf_verifier_e=
nv *env, struct bpf_kfunc_call_
 				return ret;
 			break;
 		case KF_ARG_PTR_TO_DYNPTR:
+		{
+			enum bpf_arg_type dynptr_arg_type =3D ARG_PTR_TO_DYNPTR;
+
 			if (reg->type !=3D PTR_TO_STACK &&
 			    reg->type !=3D CONST_PTR_TO_DYNPTR) {
 				verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
 				return -EINVAL;
 			}
=20
-			ret =3D process_dynptr_func(env, regno, insn_idx,
-						  ARG_PTR_TO_DYNPTR | MEM_RDONLY);
+			if (meta->func_id =3D=3D special_kfunc_list[KF_bpf_dynptr_from_skb])
+				dynptr_arg_type |=3D MEM_UNINIT | DYNPTR_TYPE_SKB;
+			else
+				dynptr_arg_type |=3D MEM_RDONLY;
+
+			ret =3D process_dynptr_func(env, regno, insn_idx, dynptr_arg_type);
 			if (ret < 0)
 				return ret;
 			break;
+		}
 		case KF_ARG_PTR_TO_LIST_HEAD:
 			if (reg->type !=3D PTR_TO_MAP_VALUE &&
 			    reg->type !=3D (PTR_TO_BTF_ID | MEM_ALLOC)) {
@@ -16318,6 +16373,17 @@ static int fixup_kfunc_call(struct bpf_verifier_=
env *env, struct bpf_insn *insn,
 		   desc->func_id =3D=3D special_kfunc_list[KF_bpf_rdonly_cast]) {
 		insn_buf[0] =3D BPF_MOV64_REG(BPF_REG_0, BPF_REG_1);
 		*cnt =3D 1;
+	} else if (desc->func_id =3D=3D special_kfunc_list[KF_bpf_dynptr_from_s=
kb]) {
+		bool seen_direct_write =3D env->seen_direct_write;
+		bool is_rdonly =3D !may_access_direct_pkt_data(env, NULL, BPF_WRITE);
+
+		if (is_rdonly)
+			insn->imm =3D BPF_CALL_IMM(bpf_dynptr_from_skb_rdonly);
+
+		/* restore env->seen_direct_write to its original value, since
+		 * may_access_direct_pkt_data mutates it
+		 */
+		env->seen_direct_write =3D seen_direct_write;
 	}
 	return 0;
 }
diff --git a/net/core/filter.c b/net/core/filter.c
index 2ce06a72a5ba..34250a4d3b7a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1721,6 +1721,12 @@ static const struct bpf_func_proto bpf_skb_store_b=
ytes_proto =3D {
 	.arg5_type	=3D ARG_ANYTHING,
 };
=20
+int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *f=
rom,
+			  u32 len, u64 flags)
+{
+	return ____bpf_skb_store_bytes(skb, offset, from, len, flags);
+}
+
 BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
 	   void *, to, u32, len)
 {
@@ -1751,6 +1757,11 @@ static const struct bpf_func_proto bpf_skb_load_by=
tes_proto =3D {
 	.arg4_type	=3D ARG_CONST_SIZE,
 };
=20
+int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to=
, u32 len)
+{
+	return ____bpf_skb_load_bytes(skb, offset, to, len);
+}
+
 BPF_CALL_4(bpf_flow_dissector_load_bytes,
 	   const struct bpf_flow_dissector *, ctx, u32, offset,
 	   void *, to, u32, len)
@@ -11608,3 +11619,59 @@ bpf_sk_base_func_proto(enum bpf_func_id func_id)
=20
 	return func;
 }
+
+__diag_push();
+__diag_ignore_all("-Wmissing-prototypes",
+		  "Global functions as their definitions will be in vmlinux BTF");
+__bpf_kfunc int bpf_dynptr_from_skb(struct sk_buff *skb, u64 flags,
+				    struct bpf_dynptr_kern *ptr)
+{
+	if (flags) {
+		bpf_dynptr_set_null(ptr);
+		return -EINVAL;
+	}
+
+	bpf_dynptr_init(ptr, skb, BPF_DYNPTR_TYPE_SKB, 0, skb->len);
+
+	return 0;
+}
+__diag_pop();
+
+int bpf_dynptr_from_skb_rdonly(struct sk_buff *skb, u64 flags,
+			       struct bpf_dynptr_kern *ptr)
+{
+	int err;
+
+	err =3D bpf_dynptr_from_skb(skb, flags, ptr);
+	if (err)
+		return err;
+
+	bpf_dynptr_set_rdonly(ptr);
+
+	return 0;
+}
+
+BTF_SET8_START(bpf_kfunc_check_set_skb)
+BTF_ID_FLAGS(func, bpf_dynptr_from_skb)
+BTF_SET8_END(bpf_kfunc_check_set_skb)
+
+static const struct btf_kfunc_id_set bpf_kfunc_set_skb =3D {
+	.owner =3D THIS_MODULE,
+	.set =3D &bpf_kfunc_check_set_skb,
+};
+
+static int __init bpf_kfunc_init(void)
+{
+	int ret;
+
+	ret =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_kfunc_s=
et_skb);
+	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT, &bpf_=
kfunc_set_skb);
+	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SK_SKB, &bpf_kfu=
nc_set_skb);
+	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SOCKET_FILTER, &=
bpf_kfunc_set_skb);
+	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SKB, &bpf=
_kfunc_set_skb);
+	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_OUT, &bpf_kf=
unc_set_skb);
+	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_IN, &bpf_kfu=
nc_set_skb);
+	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_XMIT, &bpf_k=
func_set_skb);
+	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_SEG6LOCAL, &b=
pf_kfunc_set_skb);
+}
+late_initcall(bpf_kfunc_init);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 1503f61336b6..4c229e0866db 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5320,11 +5320,17 @@ union bpf_attr {
  *	Description
  *		Write *len* bytes from *src* into *dst*, starting from *offset*
  *		into *dst*.
- *		*flags* is currently unused.
+ *
+ *		*flags* must be 0 except for skb-type dynptrs.
+ *
+ *		For skb-type dynptrs:
+ *		    *  For *flags*, please see the flags accepted by
+ *		       **bpf_skb_store_bytes**\ ().
  *	Return
  *		0 on success, -E2BIG if *offset* + *len* exceeds the length
  *		of *dst*'s data, -EINVAL if *dst* is an invalid dynptr or if *dst*
- *		is a read-only dynptr or if *flags* is not 0.
+ *		is a read-only dynptr or if *flags* is not correct. For skb-type dyn=
ptrs,
+ *		other errors correspond to errors returned by **bpf_skb_store_bytes*=
*\ ().
  *
  * void *bpf_dynptr_data(const struct bpf_dynptr *ptr, u32 offset, u32 l=
en)
  *	Description
@@ -5332,6 +5338,10 @@ union bpf_attr {
  *
  *		*len* must be a statically known value. The returned data slice
  *		is invalidated whenever the dynptr is invalidated.
+ *
+ *		skb type dynptrs may not use bpf_dynptr_data. They should
+ *		instead use bpf_dynptr_slice and bpf_dynptr_slice_rdwr.
+ *
  *	Return
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
--=20
2.30.2

