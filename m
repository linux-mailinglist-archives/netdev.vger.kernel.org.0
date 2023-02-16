Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E45569A028
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 23:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjBPW46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 17:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjBPW4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 17:56:43 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9024C6D5
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 14:56:31 -0800 (PST)
Received: by devvm15675.prn0.facebook.com (Postfix, from userid 115148)
        id 70E196A5C852; Thu, 16 Feb 2023 14:56:10 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, memxor@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v10 bpf-next 7/9] bpf: Add xdp dynptrs
Date:   Thu, 16 Feb 2023 14:55:22 -0800
Message-Id: <20230216225524.1192789-8-joannelkoong@gmail.com>
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

Add xdp dynptrs, which are dynptrs whose underlying pointer points
to a xdp_buff. The dynptr acts on xdp data. xdp dynptrs have two main
benefits. One is that they allow operations on sizes that are not
statically known at compile-time (eg variable-sized accesses).
Another is that parsing the packet data through dynptrs (instead of
through direct access of xdp->data and xdp->data_end) can be more
ergonomic and less brittle (eg does not need manual if checking for
being within bounds of data_end).

For reads and writes on the dynptr, this includes reading/writing
from/to and across fragments. Data slices through the bpf_dynptr_data
API are not supported; instead bpf_dynptr_slice() and
bpf_dynptr_slice_rdwr() should be used.

For examples of how xdp dynptrs can be used, please see the attached
selftests.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/bpf.h            |  8 +++++++-
 include/linux/filter.h         | 14 +++++++++++++
 include/uapi/linux/bpf.h       |  3 +--
 kernel/bpf/helpers.c           |  9 ++++++++-
 kernel/bpf/verifier.c          | 10 +++++++++
 net/core/filter.c              | 37 ++++++++++++++++++++++++++++++++--
 tools/include/uapi/linux/bpf.h |  3 +--
 7 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3d18be35a5e6..92e4636f13fa 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -610,11 +610,15 @@ enum bpf_type_flag {
 	/* DYNPTR points to sk_buff */
 	DYNPTR_TYPE_SKB		=3D BIT(15 + BPF_BASE_TYPE_BITS),
=20
+	/* DYNPTR points to xdp_buff */
+	DYNPTR_TYPE_XDP		=3D BIT(16 + BPF_BASE_TYPE_BITS),
+
 	__BPF_TYPE_FLAG_MAX,
 	__BPF_TYPE_LAST_FLAG	=3D __BPF_TYPE_FLAG_MAX - 1,
 };
=20
-#define DYNPTR_TYPE_FLAG_MASK	(DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF |=
 DYNPTR_TYPE_SKB)
+#define DYNPTR_TYPE_FLAG_MASK	(DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF |=
 DYNPTR_TYPE_SKB \
+				 | DYNPTR_TYPE_XDP)
=20
 /* Max number of base types. */
 #define BPF_BASE_TYPE_LIMIT	(1UL << BPF_BASE_TYPE_BITS)
@@ -1151,6 +1155,8 @@ enum bpf_dynptr_type {
 	BPF_DYNPTR_TYPE_RINGBUF,
 	/* Underlying data is a sk_buff */
 	BPF_DYNPTR_TYPE_SKB,
+	/* Underlying data is a xdp_buff */
+	BPF_DYNPTR_TYPE_XDP,
 };
=20
 int bpf_dynptr_check_size(u32 size);
diff --git a/include/linux/filter.h b/include/linux/filter.h
index de18e844d15e..3f6992261ec5 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1546,6 +1546,8 @@ static __always_inline int __bpf_xdp_redirect_map(s=
truct bpf_map *map, u64 index
 int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to=
, u32 len);
 int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *f=
rom,
 			  u32 len, u64 flags);
+int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u3=
2 len);
+int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u=
32 len);
 #else /* CONFIG_NET */
 static inline int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 of=
fset,
 				       void *to, u32 len)
@@ -1558,6 +1560,18 @@ static inline int __bpf_skb_store_bytes(struct sk_=
buff *skb, u32 offset,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset,
+				       void *buf, u32 len)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset=
,
+					void *buf, u32 len)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_NET */
=20
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4c229e0866db..e7435acbdd30 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5339,9 +5339,8 @@ union bpf_attr {
  *		*len* must be a statically known value. The returned data slice
  *		is invalidated whenever the dynptr is invalidated.
  *
- *		skb type dynptrs may not use bpf_dynptr_data. They should
+ *		skb and xdp type dynptrs may not use bpf_dynptr_data. They should
  *		instead use bpf_dynptr_slice and bpf_dynptr_slice_rdwr.
- *
  *	Return
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index b9d357bdbd1d..989be97b0f81 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1530,6 +1530,8 @@ BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, =
const struct bpf_dynptr_kern
 		return 0;
 	case BPF_DYNPTR_TYPE_SKB:
 		return __bpf_skb_load_bytes(src->data, src->offset + offset, dst, len)=
;
+	case BPF_DYNPTR_TYPE_XDP:
+		return __bpf_xdp_load_bytes(src->data, src->offset + offset, dst, len)=
;
 	default:
 		WARN_ONCE(true, "bpf_dynptr_read: unknown dynptr type %d\n", type);
 		return -EFAULT;
@@ -1576,6 +1578,10 @@ BPF_CALL_5(bpf_dynptr_write, const struct bpf_dynp=
tr_kern *, dst, u32, offset, v
 	case BPF_DYNPTR_TYPE_SKB:
 		return __bpf_skb_store_bytes(dst->data, dst->offset + offset, src, len=
,
 					     flags);
+	case BPF_DYNPTR_TYPE_XDP:
+		if (flags)
+			return -EINVAL;
+		return __bpf_xdp_store_bytes(dst->data, dst->offset + offset, src, len=
);
 	default:
 		WARN_ONCE(true, "bpf_dynptr_write: unknown dynptr type %d\n", type);
 		return -EFAULT;
@@ -1615,7 +1621,8 @@ BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr=
_kern *, ptr, u32, offset, u3
 	case BPF_DYNPTR_TYPE_RINGBUF:
 		return (unsigned long)(ptr->data + ptr->offset + offset);
 	case BPF_DYNPTR_TYPE_SKB:
-		/* skb dynptrs should use bpf_dynptr_slice / bpf_dynptr_slice_rdwr */
+	case BPF_DYNPTR_TYPE_XDP:
+		/* skb and xdp dynptrs should use bpf_dynptr_slice / bpf_dynptr_slice_=
rdwr */
 		return 0;
 	default:
 		WARN_ONCE(true, "bpf_dynptr_data: unknown dynptr type %d\n", type);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7297f0d83792..0b767134ecaa 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -752,6 +752,8 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum b=
pf_arg_type arg_type)
 		return BPF_DYNPTR_TYPE_RINGBUF;
 	case DYNPTR_TYPE_SKB:
 		return BPF_DYNPTR_TYPE_SKB;
+	case DYNPTR_TYPE_XDP:
+		return BPF_DYNPTR_TYPE_XDP;
 	default:
 		return BPF_DYNPTR_TYPE_INVALID;
 	}
@@ -6291,6 +6293,9 @@ int process_dynptr_func(struct bpf_verifier_env *en=
v, int regno, int insn_idx,
 			case DYNPTR_TYPE_SKB:
 				err_extra =3D "skb ";
 				break;
+			case DYNPTR_TYPE_XDP:
+				err_extra =3D "xdp ";
+				break;
 			default:
 				err_extra =3D "<unknown>";
 				break;
@@ -8917,6 +8922,7 @@ enum special_kfunc_type {
 	KF_bpf_rbtree_add,
 	KF_bpf_rbtree_first,
 	KF_bpf_dynptr_from_skb,
+	KF_bpf_dynptr_from_xdp,
 };
=20
 BTF_SET_START(special_kfunc_set)
@@ -8932,6 +8938,7 @@ BTF_ID(func, bpf_rbtree_remove)
 BTF_ID(func, bpf_rbtree_add)
 BTF_ID(func, bpf_rbtree_first)
 BTF_ID(func, bpf_dynptr_from_skb)
+BTF_ID(func, bpf_dynptr_from_xdp)
 BTF_SET_END(special_kfunc_set)
=20
 BTF_ID_LIST(special_kfunc_list)
@@ -8949,6 +8956,7 @@ BTF_ID(func, bpf_rbtree_remove)
 BTF_ID(func, bpf_rbtree_add)
 BTF_ID(func, bpf_rbtree_first)
 BTF_ID(func, bpf_dynptr_from_skb)
+BTF_ID(func, bpf_dynptr_from_xdp)
=20
 static bool is_kfunc_bpf_rcu_read_lock(struct bpf_kfunc_call_arg_meta *m=
eta)
 {
@@ -9700,6 +9708,8 @@ static int check_kfunc_args(struct bpf_verifier_env=
 *env, struct bpf_kfunc_call_
=20
 			if (meta->func_id =3D=3D special_kfunc_list[KF_bpf_dynptr_from_skb])
 				dynptr_arg_type |=3D MEM_UNINIT | DYNPTR_TYPE_SKB;
+			else if (meta->func_id =3D=3D special_kfunc_list[KF_bpf_dynptr_from_x=
dp])
+				dynptr_arg_type |=3D MEM_UNINIT | DYNPTR_TYPE_XDP;
 			else
 				dynptr_arg_type |=3D MEM_RDONLY;
=20
diff --git a/net/core/filter.c b/net/core/filter.c
index 34250a4d3b7a..dcf1e6d2582d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3839,7 +3839,7 @@ static const struct bpf_func_proto sk_skb_change_he=
ad_proto =3D {
 	.arg3_type	=3D ARG_ANYTHING,
 };
=20
-BPF_CALL_1(bpf_xdp_get_buff_len, struct  xdp_buff*, xdp)
+BPF_CALL_1(bpf_xdp_get_buff_len, struct xdp_buff*, xdp)
 {
 	return xdp_get_buff_len(xdp);
 }
@@ -3999,6 +3999,11 @@ static const struct bpf_func_proto bpf_xdp_load_by=
tes_proto =3D {
 	.arg4_type	=3D ARG_CONST_SIZE,
 };
=20
+int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u3=
2 len)
+{
+	return ____bpf_xdp_load_bytes(xdp, offset, buf, len);
+}
+
 BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
 	   void *, buf, u32, len)
 {
@@ -4026,6 +4031,11 @@ static const struct bpf_func_proto bpf_xdp_store_b=
ytes_proto =3D {
 	.arg4_type	=3D ARG_CONST_SIZE,
 };
=20
+int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u=
32 len)
+{
+	return ____bpf_xdp_store_bytes(xdp, offset, buf, len);
+}
+
 static int bpf_xdp_frags_increase_tail(struct xdp_buff *xdp, int offset)
 {
 	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
@@ -11635,6 +11645,19 @@ __bpf_kfunc int bpf_dynptr_from_skb(struct sk_bu=
ff *skb, u64 flags,
=20
 	return 0;
 }
+
+__bpf_kfunc int bpf_dynptr_from_xdp(struct xdp_buff *xdp, u64 flags,
+				    struct bpf_dynptr_kern *ptr)
+{
+	if (flags) {
+		bpf_dynptr_set_null(ptr);
+		return -EINVAL;
+	}
+
+	bpf_dynptr_init(ptr, xdp, BPF_DYNPTR_TYPE_XDP, 0, xdp_get_buff_len(xdp)=
);
+
+	return 0;
+}
 __diag_pop();
=20
 int bpf_dynptr_from_skb_rdonly(struct sk_buff *skb, u64 flags,
@@ -11655,11 +11678,20 @@ BTF_SET8_START(bpf_kfunc_check_set_skb)
 BTF_ID_FLAGS(func, bpf_dynptr_from_skb)
 BTF_SET8_END(bpf_kfunc_check_set_skb)
=20
+BTF_SET8_START(bpf_kfunc_check_set_xdp)
+BTF_ID_FLAGS(func, bpf_dynptr_from_xdp)
+BTF_SET8_END(bpf_kfunc_check_set_xdp)
+
 static const struct btf_kfunc_id_set bpf_kfunc_set_skb =3D {
 	.owner =3D THIS_MODULE,
 	.set =3D &bpf_kfunc_check_set_skb,
 };
=20
+static const struct btf_kfunc_id_set bpf_kfunc_set_xdp =3D {
+	.owner =3D THIS_MODULE,
+	.set =3D &bpf_kfunc_check_set_xdp,
+};
+
 static int __init bpf_kfunc_init(void)
 {
 	int ret;
@@ -11672,6 +11704,7 @@ static int __init bpf_kfunc_init(void)
 	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_OUT, &bpf_kf=
unc_set_skb);
 	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_IN, &bpf_kfu=
nc_set_skb);
 	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_XMIT, &bpf_k=
func_set_skb);
-	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_SEG6LOCAL, &b=
pf_kfunc_set_skb);
+	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_SEG6LOCAL, &=
bpf_kfunc_set_skb);
+	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &bpf_kfunc_s=
et_xdp);
 }
 late_initcall(bpf_kfunc_init);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 4c229e0866db..e7435acbdd30 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5339,9 +5339,8 @@ union bpf_attr {
  *		*len* must be a statically known value. The returned data slice
  *		is invalidated whenever the dynptr is invalidated.
  *
- *		skb type dynptrs may not use bpf_dynptr_data. They should
+ *		skb and xdp type dynptrs may not use bpf_dynptr_data. They should
  *		instead use bpf_dynptr_slice and bpf_dynptr_slice_rdwr.
- *
  *	Return
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
--=20
2.30.2

