Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19C15A85DF
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 20:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbiHaSjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 14:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbiHaSjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 14:39:16 -0400
Received: from 66-220-155-178.mail-mxout.facebook.com (66-220-155-178.mail-mxout.facebook.com [66.220.155.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5382EDEA71
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 11:36:52 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id CCC321127DA72; Wed, 31 Aug 2022 11:36:38 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        kafai@fb.com, memxor@gmail.com, toke@redhat.com, kuba@kernel.org,
        netdev@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH bpf-next v5 2/3] bpf: Add xdp dynptrs
Date:   Wed, 31 Aug 2022 11:32:23 -0700
Message-Id: <20220831183224.3754305-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220831183224.3754305-1-joannelkoong@gmail.com>
References: <20220831183224.3754305-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_SOFTFAIL,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
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
from/to and across fragments. For data slices, direct access to
data in fragments is also permitted, but access across fragments
is not.

Any helper calls that change the underlying packet buffer (eg
bpf_xdp_adjust_head) invalidates any data slices of the associated
dynptr. The stack trace for this is check_helper_call() ->
clear_all_pkt_pointers() -> __clear_all_pkt_pointers() ->
mark_reg_unknown().

For examples of how xdp dynptrs can be used, please see the attached
selftests.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/bpf.h            |  6 ++++-
 include/linux/filter.h         | 18 +++++++++++++
 include/uapi/linux/bpf.h       | 25 +++++++++++++++---
 kernel/bpf/helpers.c           | 12 +++++++++
 kernel/bpf/verifier.c          | 18 +++++++++----
 net/core/filter.c              | 46 +++++++++++++++++++++++++++++-----
 tools/include/uapi/linux/bpf.h | 25 +++++++++++++++---
 7 files changed, 132 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 26ad1422a157..f07d127f559f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -411,11 +411,15 @@ enum bpf_type_flag {
 	/* DYNPTR points to sk_buff */
 	DYNPTR_TYPE_SKB		=3D BIT(11 + BPF_BASE_TYPE_BITS),
=20
+	/* DYNPTR points to xdp_buff */
+	DYNPTR_TYPE_XDP		=3D BIT(12 + BPF_BASE_TYPE_BITS),
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
diff --git a/include/linux/filter.h b/include/linux/filter.h
index a3a415344001..09311cb4375d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1536,6 +1536,9 @@ static __always_inline int __bpf_xdp_redirect_map(s=
truct bpf_map *map, u32 ifind
 int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to=
, u32 len);
 int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *f=
rom,
 			  u32 len, u64 flags);
+int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u3=
2 len);
+int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u=
32 len);
+void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len);
 #else /* CONFIG_NET */
 int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to=
, u32 len)
 {
@@ -1547,6 +1550,21 @@ int __bpf_skb_store_bytes(struct sk_buff *skb, u32=
 offset, const void *from,
 {
 	return -EOPNOTSUPP;
 }
+
+int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u3=
2 len)
+{
+	return -EOPNOTSUPP;
+}
+
+int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u=
32 len)
+{
+	return -EOPNOTSUPP;
+}
+
+void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
+{
+	return NULL;
+}
 #endif /* CONFIG_NET */
=20
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b4e5f7d81a20..992f7565a41e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5315,13 +5315,18 @@ union bpf_attr {
  *		      and try again.
  *
  *		    * The data slice is automatically invalidated anytime
- *		      **bpf_dynptr_write**\ () or a helper call that changes
- *		      the underlying packet buffer (eg **bpf_skb_pull_data**\ ())
+ *		      **bpf_dynptr_write**\ () is called.
+ *
+ *		For skb-type and xdp-type dynptrs:
+ *		    * The data slice is automatically invalidated anytime a
+ *		      helper call that changes the underlying packet buffer
+ *		      (eg **bpf_skb_pull_data**\ (), **bpf_xdp_adjust_head**\ ())
  *		      is called.
  *	Return
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
- *		is out of bounds or in a paged buffer for skb-type dynptrs.
+ *		is out of bounds or in a paged buffer for skb-type dynptrs or
+ *		across fragments for xdp-type dynptrs.
  *
  * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *=
th, u32 th_len)
  *	Description
@@ -5420,6 +5425,19 @@ union bpf_attr {
  *		*flags* is currently unused, it must be 0 for now.
  *	Return
  *		0 on success or -EINVAL if flags is not 0.
+ *
+ * long bpf_dynptr_from_xdp(struct xdp_buff *xdp_md, u64 flags, struct b=
pf_dynptr *ptr)
+ *	Description
+ *		Get a dynptr to the data in *xdp_md*. *xdp_md* must be the BPF progr=
am
+ *		context.
+ *
+ *		Calls that change the *xdp_md*'s underlying packet buffer
+ *		(eg **bpf_xdp_adjust_head**\ ()) do not invalidate the dynptr, but
+ *		they do invalidate any data slices associated with the dynptr.
+ *
+ *		*flags* is currently unused, it must be 0 for now.
+ *	Return
+ *		0 on success, -EINVAL if flags is not 0.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5632,6 +5650,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(ktime_get_tai_ns),		\
 	FN(dynptr_from_skb),		\
+	FN(dynptr_from_xdp),		\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 98fcb4704a9e..befafae34a63 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1507,6 +1507,8 @@ BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, =
struct bpf_dynptr_kern *, src
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
@@ -1549,6 +1551,10 @@ BPF_CALL_5(bpf_dynptr_write, struct bpf_dynptr_ker=
n *, dst, u32, offset, void *,
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
@@ -1600,6 +1606,12 @@ BPF_CALL_3(bpf_dynptr_data, struct bpf_dynptr_kern=
 *, ptr, u32, offset, u32, len
 		data =3D skb->data;
 		break;
 	}
+	case BPF_DYNPTR_TYPE_XDP:
+		/* if the requested data in across fragments, then it cannot
+		 * be accessed directly - bpf_xdp_pointer will return NULL
+		 */
+		return (unsigned long)bpf_xdp_pointer(ptr->data,
+						      ptr->offset + offset, len);
 	default:
 		WARN_ONCE(true, "bpf_dynptr_data: unknown dynptr type %d\n", type);
 		return 0;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7f67fac66735..f5ff0f26b7cc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -686,6 +686,8 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum b=
pf_arg_type arg_type)
 		return BPF_DYNPTR_TYPE_RINGBUF;
 	case DYNPTR_TYPE_SKB:
 		return BPF_DYNPTR_TYPE_SKB;
+	case DYNPTR_TYPE_XDP:
+		return BPF_DYNPTR_TYPE_XDP;
 	default:
 		return BPF_DYNPTR_TYPE_INVALID;
 	}
@@ -1411,7 +1413,7 @@ static bool reg_is_pkt_pointer_any(const struct bpf=
_reg_state *reg)
 static bool reg_is_dynptr_slice_pkt(const struct bpf_reg_state *reg)
 {
 	return base_type(reg->type) =3D=3D PTR_TO_MEM &&
-		reg->type & DYNPTR_TYPE_SKB;
+		(reg->type & DYNPTR_TYPE_SKB || reg->type & DYNPTR_TYPE_XDP);
 }
=20
 /* Unmodified PTR_TO_PACKET[_META,_END] register from ctx access. */
@@ -6088,6 +6090,9 @@ static int check_func_arg(struct bpf_verifier_env *=
env, u32 arg,
 			case DYNPTR_TYPE_SKB:
 				err_extra =3D "skb ";
 				break;
+			case DYNPTR_TYPE_XDP:
+				err_extra =3D "xdp ";
+				break;
 			default:
 				break;
 			}
@@ -6519,7 +6524,7 @@ static int check_func_proto(const struct bpf_func_p=
roto *fn, int func_id)
 /* Packet data might have moved, any old PTR_TO_PACKET[_META,_END]
  * are now invalid, so turn them into unknown SCALAR_VALUE.
  *
- * This applies to dynptr slices belonging to skb dynptrs,
+ * This applies to dynptr slices belonging to skb or xdp dynptrs,
  * since these slices point to packet data.
  */
 static void __clear_all_pkt_pointers(struct bpf_verifier_env *env,
@@ -7470,9 +7475,12 @@ static int check_helper_call(struct bpf_verifier_e=
nv *env, struct bpf_insn *insn
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type =3D PTR_TO_MEM | ret_flag;
 		regs[BPF_REG_0].mem_size =3D meta.mem_size;
-		if (func_id =3D=3D BPF_FUNC_dynptr_data &&
-		    dynptr_type =3D=3D BPF_DYNPTR_TYPE_SKB)
-			regs[BPF_REG_0].type |=3D DYNPTR_TYPE_SKB;
+		if (func_id =3D=3D BPF_FUNC_dynptr_data) {
+			if (dynptr_type =3D=3D BPF_DYNPTR_TYPE_SKB)
+				regs[BPF_REG_0].type |=3D DYNPTR_TYPE_SKB;
+			else if (dynptr_type =3D=3D BPF_DYNPTR_TYPE_XDP)
+				regs[BPF_REG_0].type |=3D DYNPTR_TYPE_XDP;
+		}
 		break;
 	case RET_PTR_TO_MEM_OR_BTF_ID:
 	{
diff --git a/net/core/filter.c b/net/core/filter.c
index 0e2238516d8b..cca8c7ab2829 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3844,7 +3844,29 @@ static const struct bpf_func_proto sk_skb_change_h=
ead_proto =3D {
 	.arg3_type	=3D ARG_ANYTHING,
 };
=20
-BPF_CALL_1(bpf_xdp_get_buff_len, struct  xdp_buff*, xdp)
+BPF_CALL_3(bpf_dynptr_from_xdp, struct xdp_buff*, xdp, u64, flags,
+	   struct bpf_dynptr_kern *, ptr)
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
+
+static const struct bpf_func_proto bpf_dynptr_from_xdp_proto =3D {
+	.func		=3D bpf_dynptr_from_xdp,
+	.gpl_only	=3D false,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_CTX,
+	.arg2_type	=3D ARG_ANYTHING,
+	.arg3_type	=3D ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_XDP | MEM_UNINIT,
+};
+
+BPF_CALL_1(bpf_xdp_get_buff_len, struct xdp_buff*, xdp)
 {
 	return xdp_get_buff_len(xdp);
 }
@@ -3946,7 +3968,7 @@ static void bpf_xdp_copy_buf(struct xdp_buff *xdp, =
unsigned long off,
 	}
 }
=20
-static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
+void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
 {
 	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
 	u32 size =3D xdp->data_end - xdp->data;
@@ -3977,8 +3999,7 @@ static void *bpf_xdp_pointer(struct xdp_buff *xdp, =
u32 offset, u32 len)
 	return offset + len <=3D size ? addr + offset : NULL;
 }
=20
-BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
-	   void *, buf, u32, len)
+int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u3=
2 len)
 {
 	void *ptr;
=20
@@ -3994,6 +4015,12 @@ BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, =
xdp, u32, offset,
 	return 0;
 }
=20
+BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
+	   void *, buf, u32, len)
+{
+	return __bpf_xdp_load_bytes(xdp, offset, buf, len);
+}
+
 static const struct bpf_func_proto bpf_xdp_load_bytes_proto =3D {
 	.func		=3D bpf_xdp_load_bytes,
 	.gpl_only	=3D false,
@@ -4004,8 +4031,7 @@ static const struct bpf_func_proto bpf_xdp_load_byt=
es_proto =3D {
 	.arg4_type	=3D ARG_CONST_SIZE,
 };
=20
-BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
-	   void *, buf, u32, len)
+int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u=
32 len)
 {
 	void *ptr;
=20
@@ -4021,6 +4047,12 @@ BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *,=
 xdp, u32, offset,
 	return 0;
 }
=20
+BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
+	   void *, buf, u32, len)
+{
+	return __bpf_xdp_store_bytes(xdp, offset, buf, len);
+}
+
 static const struct bpf_func_proto bpf_xdp_store_bytes_proto =3D {
 	.func		=3D bpf_xdp_store_bytes,
 	.gpl_only	=3D false,
@@ -8010,6 +8042,8 @@ xdp_func_proto(enum bpf_func_id func_id, const stru=
ct bpf_prog *prog)
 		return &bpf_tcp_raw_check_syncookie_ipv6_proto;
 #endif
 #endif
+	case BPF_FUNC_dynptr_from_xdp:
+		return &bpf_dynptr_from_xdp_proto;
 	default:
 		return bpf_sk_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 52e891b00a35..b22ffbb6f382 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5315,13 +5315,18 @@ union bpf_attr {
  *		      and try again.
  *
  *		    * The data slice is automatically invalidated anytime
- *		      **bpf_dynptr_write**\ () or a helper call that changes
- *		      the underlying packet buffer (eg **bpf_skb_pull_data**\ ())
+ *		      **bpf_dynptr_write**\ () is called.
+ *
+ *		For skb-type and xdp-type dynptrs:
+ *		    * The data slice is automatically invalidated anytime a
+ *		      helper call that changes the underlying packet buffer
+ *		      (eg **bpf_skb_pull_data**\ (), **bpf_xdp_adjust_head**\ ())
  *		      is called.
  *	Return
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
- *		is out of bounds or in a paged buffer for skb-type dynptrs.
+ *		is out of bounds or in a paged buffer for skb-type dynptrs or
+ *		across fragments for xdp-type dynptrs.
  *
  * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *=
th, u32 th_len)
  *	Description
@@ -5420,6 +5425,19 @@ union bpf_attr {
  *		*flags* is currently unused, it must be 0 for now.
  *	Return
  *		0 on success or -EINVAL if flags is not 0.
+ *
+ * long bpf_dynptr_from_xdp(struct xdp_buff *xdp_md, u64 flags, struct b=
pf_dynptr *ptr)
+ *	Description
+ *		Get a dynptr to the data in *xdp_md*. *xdp_md* must be the BPF progr=
am
+ *		context.
+ *
+ *		Calls that change the *xdp_md*'s underlying packet buffer
+ *		(eg **bpf_xdp_adjust_head**\ ()) do not invalidate the dynptr, but
+ *		they do invalidate any data slices associated with the dynptr.
+ *
+ *		*flags* is currently unused, it must be 0 for now.
+ *	Return
+ *		0 on success, -EINVAL if flags is not 0.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5632,6 +5650,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(ktime_get_tai_ns),		\
 	FN(dynptr_from_skb),		\
+	FN(dynptr_from_xdp),		\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
--=20
2.30.2

