Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9479B59C903
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 21:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238671AbiHVTfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238766AbiHVTfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:35:47 -0400
Received: from 69-171-232-181.mail-mxout.facebook.com (69-171-232-181.mail-mxout.facebook.com [69.171.232.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EE1167F5
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:35:45 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id 8BD6B10CDA51D; Mon, 22 Aug 2022 12:35:32 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        kafai@fb.com, kuba@kernel.org, netdev@vger.kernel.org,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH bpf-next v3 2/3] bpf: Add xdp dynptrs
Date:   Mon, 22 Aug 2022 12:34:41 -0700
Message-Id: <20220822193442.657638-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220822193442.657638-1-joannelkoong@gmail.com>
References: <20220822193442.657638-1-joannelkoong@gmail.com>
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
is not. The returned data slice is reg type PTR_TO_PACKET | PTR_MAYBE_NUL=
L.

Any helper calls that change the underlying packet buffer (eg
bpf_xdp_adjust_head) invalidates any data slices of the associated
dynptr. Whenever such a helper call is made, the verifier marks any
PTR_TO_PACKET reg type (which includes xdp dynptr slices since they are
PTR_TO_PACKETs) as unknown. The stack trace for this is
check_helper_call() -> clear_all_pkt_pointers() ->
__clear_all_pkt_pointers() -> mark_reg_unknown()

For examples of how xdp dynptrs can be used, please see the attached
selftests.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/bpf.h            |  8 +++++-
 include/linux/filter.h         |  3 +++
 include/uapi/linux/bpf.h       | 25 +++++++++++++++---
 kernel/bpf/helpers.c           | 14 ++++++++++-
 kernel/bpf/verifier.c          |  8 +++++-
 net/core/filter.c              | 46 +++++++++++++++++++++++++++++-----
 tools/include/uapi/linux/bpf.h | 25 +++++++++++++++---
 7 files changed, 114 insertions(+), 15 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a1fdc4d350c0..e3ff3e3758cc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -410,11 +410,15 @@ enum bpf_type_flag {
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
@@ -2575,6 +2579,8 @@ enum bpf_dynptr_type {
 	BPF_DYNPTR_TYPE_RINGBUF,
 	/* Underlying data is a sk_buff */
 	BPF_DYNPTR_TYPE_SKB,
+	/* Underlying data is a xdp_buff */
+	BPF_DYNPTR_TYPE_XDP,
 };
=20
 void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 649063d9cbfd..80f030239877 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1535,5 +1535,8 @@ static __always_inline int __bpf_xdp_redirect_map(s=
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
=20
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 320e6b95d95c..9feea29eebcd 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5283,13 +5283,18 @@ union bpf_attr {
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
@@ -5388,6 +5393,19 @@ union bpf_attr {
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
@@ -5600,6 +5618,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(ktime_get_tai_ns),		\
 	FN(dynptr_from_skb),		\
+	FN(dynptr_from_xdp),		\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 471a01a9b6ae..2b9dc4c6de04 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1541,6 +1541,8 @@ BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, =
struct bpf_dynptr_kern *, src
 		return 0;
 	case BPF_DYNPTR_TYPE_SKB:
 		return __bpf_skb_load_bytes(src->data, src->offset + offset, dst, len)=
;
+	case BPF_DYNPTR_TYPE_XDP:
+		return __bpf_xdp_load_bytes(src->data, src->offset + offset, dst, len)=
;
 	default:
 		WARN(true, "bpf_dynptr_read: unknown dynptr type %d\n", type);
 		return -EFAULT;
@@ -1583,6 +1585,10 @@ BPF_CALL_5(bpf_dynptr_write, struct bpf_dynptr_ker=
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
 		WARN(true, "bpf_dynptr_write: unknown dynptr type %d\n", type);
 		return -EFAULT;
@@ -1616,7 +1622,7 @@ BPF_CALL_3(bpf_dynptr_data, struct bpf_dynptr_kern =
*, ptr, u32, offset, u32, len
=20
 	type =3D bpf_dynptr_get_type(ptr);
=20
-	/* Only skb dynptrs can get read-only data slices, because the
+	/* Only skb and xdp dynptrs can get read-only data slices, because the
 	 * verifier enforces PTR_TO_PACKET accesses
 	 */
 	is_rdonly =3D bpf_dynptr_is_rdonly(ptr);
@@ -1640,6 +1646,12 @@ BPF_CALL_3(bpf_dynptr_data, struct bpf_dynptr_kern=
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
 		WARN(true, "bpf_dynptr_data: unknown dynptr type %d\n", type);
 		return 0;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1ea295f47525..d33648eee188 100644
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
@@ -6078,6 +6080,9 @@ static int check_func_arg(struct bpf_verifier_env *=
env, u32 arg,
 			case DYNPTR_TYPE_SKB:
 				err_extra =3D "skb ";
 				break;
+			case DYNPTR_TYPE_XDP:
+				err_extra =3D "xdp ";
+				break;
 			}
=20
 			verbose(env, "Expected an initialized %sdynptr as arg #%d\n",
@@ -7439,7 +7444,8 @@ static int check_helper_call(struct bpf_verifier_en=
v *env, struct bpf_insn *insn
 		mark_reg_known_zero(env, regs, BPF_REG_0);
=20
 		if (func_id =3D=3D BPF_FUNC_dynptr_data &&
-		    dynptr_type =3D=3D BPF_DYNPTR_TYPE_SKB) {
+		    (dynptr_type =3D=3D BPF_DYNPTR_TYPE_SKB ||
+		     dynptr_type =3D=3D BPF_DYNPTR_TYPE_XDP)) {
 			regs[BPF_REG_0].type =3D PTR_TO_PACKET | ret_flag;
 			regs[BPF_REG_0].range =3D meta.mem_size;
 		} else {
diff --git a/net/core/filter.c b/net/core/filter.c
index 5b204b42fb3e..54fbe8f511db 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3825,7 +3825,29 @@ static const struct bpf_func_proto sk_skb_change_h=
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
@@ -3927,7 +3949,7 @@ static void bpf_xdp_copy_buf(struct xdp_buff *xdp, =
unsigned long off,
 	}
 }
=20
-static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
+void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
 {
 	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
 	u32 size =3D xdp->data_end - xdp->data;
@@ -3958,8 +3980,7 @@ static void *bpf_xdp_pointer(struct xdp_buff *xdp, =
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
@@ -3975,6 +3996,12 @@ BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, =
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
@@ -3985,8 +4012,7 @@ static const struct bpf_func_proto bpf_xdp_load_byt=
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
@@ -4002,6 +4028,12 @@ BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *,=
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
@@ -8009,6 +8041,8 @@ xdp_func_proto(enum bpf_func_id func_id, const stru=
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
index 3f1800a2b77c..0d5b0117db2a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5283,13 +5283,18 @@ union bpf_attr {
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
@@ -5388,6 +5393,19 @@ union bpf_attr {
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
@@ -5600,6 +5618,7 @@ union bpf_attr {
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

