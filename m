Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CE6606D15
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 03:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJUBjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 21:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJUBjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 21:39:33 -0400
Received: from 66-220-155-178.mail-mxout.facebook.com (66-220-155-178.mail-mxout.facebook.com [66.220.155.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFFA26CF
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 18:39:22 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id 453B512EA6724; Thu, 20 Oct 2022 18:15:32 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     daniel@iogearbox.net, martin.lau@kernel.org, andrii@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, Kernel-team@fb.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH bpf-next v7 2/3] bpf: Add xdp dynptrs
Date:   Thu, 20 Oct 2022 18:15:09 -0700
Message-Id: <20221021011510.1890852-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221021011510.1890852-1-joannelkoong@gmail.com>
References: <20221021011510.1890852-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_SOFTFAIL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
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
 include/linux/bpf.h            |  8 +++++-
 include/linux/filter.h         | 20 +++++++++++++
 include/uapi/linux/bpf.h       | 24 ++++++++++++++--
 kernel/bpf/helpers.c           | 12 ++++++++
 kernel/bpf/verifier.c          | 52 ++++++++++++++++++++--------------
 net/core/filter.c              | 46 ++++++++++++++++++++++++++----
 tools/include/uapi/linux/bpf.h | 24 ++++++++++++++--
 7 files changed, 151 insertions(+), 35 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index caaaec69d91b..c0870a11f54d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -460,11 +460,15 @@ enum bpf_type_flag {
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
@@ -990,6 +994,8 @@ enum bpf_dynptr_type {
 	BPF_DYNPTR_TYPE_RINGBUF,
 	/* Underlying data is a sk_buff */
 	BPF_DYNPTR_TYPE_SKB,
+	/* Underlying data is a xdp_buff */
+	BPF_DYNPTR_TYPE_XDP,
 };
=20
 int bpf_dynptr_check_size(u32 size);
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 561b2e0fae3c..0df219201d3c 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1546,6 +1546,9 @@ static __always_inline int __bpf_xdp_redirect_map(s=
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
 static inline int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 of=
fset,
 				       void *to, u32 len)
@@ -1558,6 +1561,23 @@ static inline int __bpf_skb_store_bytes(struct sk_=
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
+
+static inline void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u3=
2 len)
+{
+	return NULL;
+}
 #endif /* CONFIG_NET */
=20
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7c65b5f26c1d..b048c557cb13 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5328,13 +5328,17 @@ union bpf_attr {
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
  *		Pointer to the underlying dynptr data, NULL if the dynptr is invalid=
,
  *		or if the offset and length is out of bounds or in a paged buffer fo=
r
- *		skb-type dynptrs.
+ *		skb-type dynptrs or across fragments for xdp-type dynptrs.
  *
  * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *=
th, u32 th_len)
  *	Description
@@ -5471,6 +5475,19 @@ union bpf_attr {
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
 #define ___BPF_FUNC_MAPPER(FN, ctx...)			\
 	FN(unspec, 0, ##ctx)				\
@@ -5684,6 +5701,7 @@ union bpf_attr {
 	FN(ktime_get_tai_ns, 208, ##ctx)		\
 	FN(user_ringbuf_drain, 209, ##ctx)		\
 	FN(dynptr_from_skb, 210, ##ctx)			\
+	FN(dynptr_from_xdp, 211, ##ctx)			\
 	/* */
=20
 /* backwards-compatibility macros for users of __BPF_FUNC_MAPPER that do=
n't
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 82fc7b4cec4f..42a746f8f42a 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1509,6 +1509,8 @@ BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, =
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
@@ -1551,6 +1553,10 @@ BPF_CALL_5(bpf_dynptr_write, struct bpf_dynptr_ker=
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
@@ -1606,6 +1612,12 @@ BPF_CALL_3(bpf_dynptr_data, struct bpf_dynptr_kern=
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
index f2c07e9c54e8..ebb2e0b0d90c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -689,6 +689,8 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum b=
pf_arg_type arg_type)
 		return BPF_DYNPTR_TYPE_RINGBUF;
 	case DYNPTR_TYPE_SKB:
 		return BPF_DYNPTR_TYPE_SKB;
+	case DYNPTR_TYPE_XDP:
+		return BPF_DYNPTR_TYPE_XDP;
 	default:
 		return BPF_DYNPTR_TYPE_INVALID;
 	}
@@ -1427,7 +1429,7 @@ static bool reg_is_pkt_pointer_any(const struct bpf=
_reg_state *reg)
 static bool reg_is_dynptr_slice_pkt(const struct bpf_reg_state *reg)
 {
 	return base_type(reg->type) =3D=3D PTR_TO_MEM &&
-		reg->type & DYNPTR_TYPE_SKB;
+		(reg->type & DYNPTR_TYPE_SKB || reg->type & DYNPTR_TYPE_XDP);
 }
=20
 /* Unmodified PTR_TO_PACKET[_META,_END] register from ctx access. */
@@ -6151,6 +6153,9 @@ static int check_func_arg(struct bpf_verifier_env *=
env, u32 arg,
 			case DYNPTR_TYPE_SKB:
 				err_extra =3D "skb ";
 				break;
+			case DYNPTR_TYPE_XDP:
+				err_extra =3D "xdp ";
+				break;
 			default:
 				err_extra =3D "<unknown>";
 				break;
@@ -6594,7 +6599,7 @@ static int check_func_proto(const struct bpf_func_p=
roto *fn, int func_id)
 /* Packet data might have moved, any old PTR_TO_PACKET[_META,_END]
  * are now invalid, so turn them into unknown SCALAR_VALUE.
  *
- * This also applies to dynptr slices belonging to skb dynptrs,
+ * This also applies to dynptr slices belonging to skb or xdp dynptrs,
  * since these slices point to packet data.
  */
 static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
@@ -7542,27 +7547,30 @@ static int check_helper_call(struct bpf_verifier_=
env *env, struct bpf_insn *insn
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type =3D PTR_TO_MEM | ret_flag;
 		regs[BPF_REG_0].mem_size =3D meta.mem_size;
-		if (func_id =3D=3D BPF_FUNC_dynptr_data &&
-		    dynptr_type =3D=3D BPF_DYNPTR_TYPE_SKB) {
-			bool seen_direct_write =3D env->seen_direct_write;
+		if (func_id =3D=3D BPF_FUNC_dynptr_data) {
+			if (dynptr_type =3D=3D BPF_DYNPTR_TYPE_SKB) {
+				bool seen_direct_write =3D env->seen_direct_write;
=20
-			regs[BPF_REG_0].type |=3D DYNPTR_TYPE_SKB;
-			if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
-				regs[BPF_REG_0].type |=3D MEM_RDONLY;
-			else
-				/*
-				 * Calling may_access_direct_pkt_data() will set
-				 * env->seen_direct_write to true if the skb is
-				 * writable. As an optimization, we can ignore
-				 * setting env->seen_direct_write.
-				 *
-				 * env->seen_direct_write is used by skb
-				 * programs to determine whether the skb's page
-				 * buffers should be cloned. Since data slice
-				 * writes would only be to the head, we can skip
-				 * this.
-				 */
-				env->seen_direct_write =3D seen_direct_write;
+				regs[BPF_REG_0].type |=3D DYNPTR_TYPE_SKB;
+				if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
+					regs[BPF_REG_0].type |=3D MEM_RDONLY;
+				else
+					/*
+					 * Calling may_access_direct_pkt_data() will set
+					 * env->seen_direct_write to true if the skb is
+					 * writable. As an optimization, we can ignore
+					 * setting env->seen_direct_write.
+					 *
+					 * env->seen_direct_write is used by skb
+					 * programs to determine whether the skb's page
+					 * buffers should be cloned. Since data slice
+					 * writes would only be to the head, we can skip
+					 * this.
+					 */
+					env->seen_direct_write =3D seen_direct_write;
+			} else if (dynptr_type =3D=3D BPF_DYNPTR_TYPE_XDP) {
+				regs[BPF_REG_0].type |=3D DYNPTR_TYPE_XDP;
+			}
 		}
 		break;
 	case RET_PTR_TO_MEM_OR_BTF_ID:
diff --git a/net/core/filter.c b/net/core/filter.c
index 1d39eee0980b..d9027ff07d85 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3847,7 +3847,29 @@ static const struct bpf_func_proto sk_skb_change_h=
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
@@ -3949,7 +3971,7 @@ static void bpf_xdp_copy_buf(struct xdp_buff *xdp, =
unsigned long off,
 	}
 }
=20
-static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
+void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
 {
 	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
 	u32 size =3D xdp->data_end - xdp->data;
@@ -3980,8 +4002,7 @@ static void *bpf_xdp_pointer(struct xdp_buff *xdp, =
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
@@ -3997,6 +4018,12 @@ BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, =
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
@@ -4007,8 +4034,7 @@ static const struct bpf_func_proto bpf_xdp_load_byt=
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
@@ -4024,6 +4050,12 @@ BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *,=
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
@@ -8041,6 +8073,8 @@ xdp_func_proto(enum bpf_func_id func_id, const stru=
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
index 7c65b5f26c1d..b048c557cb13 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5328,13 +5328,17 @@ union bpf_attr {
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
  *		Pointer to the underlying dynptr data, NULL if the dynptr is invalid=
,
  *		or if the offset and length is out of bounds or in a paged buffer fo=
r
- *		skb-type dynptrs.
+ *		skb-type dynptrs or across fragments for xdp-type dynptrs.
  *
  * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *=
th, u32 th_len)
  *	Description
@@ -5471,6 +5475,19 @@ union bpf_attr {
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
 #define ___BPF_FUNC_MAPPER(FN, ctx...)			\
 	FN(unspec, 0, ##ctx)				\
@@ -5684,6 +5701,7 @@ union bpf_attr {
 	FN(ktime_get_tai_ns, 208, ##ctx)		\
 	FN(user_ringbuf_drain, 209, ##ctx)		\
 	FN(dynptr_from_skb, 210, ##ctx)			\
+	FN(dynptr_from_xdp, 211, ##ctx)			\
 	/* */
=20
 /* backwards-compatibility macros for users of __BPF_FUNC_MAPPER that do=
n't
--=20
2.30.2

