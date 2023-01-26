Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663C967DA1F
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbjA0AAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjA0AAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:00:04 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8AE23658
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 15:59:59 -0800 (PST)
Received: by devvm15675.prn0.facebook.com (Postfix, from userid 115148)
        id 1632E4BA36D9; Thu, 26 Jan 2023 15:38:33 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, memxor@gmail.com,
        kernel-team@fb.com, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v8 bpf-next 4/5] bpf: Add xdp dynptrs
Date:   Thu, 26 Jan 2023 15:34:38 -0800
Message-Id: <20230126233439.3739120-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230126233439.3739120-1-joannelkoong@gmail.com>
References: <20230126233439.3739120-1-joannelkoong@gmail.com>
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
 include/linux/bpf.h            |  8 ++++-
 include/linux/filter.h         | 20 ++++++++++++
 include/uapi/linux/bpf.h       | 10 ++++--
 kernel/bpf/helpers.c           | 12 +++++++
 kernel/bpf/verifier.c          | 57 +++++++++++++++++++++-------------
 net/core/filter.c              | 46 ++++++++++++++++++++++-----
 tools/include/uapi/linux/bpf.h | 10 ++++--
 7 files changed, 127 insertions(+), 36 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1ac061b64582..94e910d9598e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -578,11 +578,15 @@ enum bpf_type_flag {
 	/* DYNPTR points to sk_buff */
 	DYNPTR_TYPE_SKB		=3D BIT(14 + BPF_BASE_TYPE_BITS),
=20
+	/* DYNPTR points to xdp_buff */
+	DYNPTR_TYPE_XDP		=3D BIT(15 + BPF_BASE_TYPE_BITS),
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
@@ -1109,6 +1113,8 @@ enum bpf_dynptr_type {
 	BPF_DYNPTR_TYPE_RINGBUF,
 	/* Underlying data is a sk_buff */
 	BPF_DYNPTR_TYPE_SKB,
+	/* Underlying data is a xdp_buff */
+	BPF_DYNPTR_TYPE_XDP,
 };
=20
 int bpf_dynptr_check_size(u32 size);
diff --git a/include/linux/filter.h b/include/linux/filter.h
index c87d13954d89..674795ea9d20 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1545,6 +1545,9 @@ static __always_inline int __bpf_xdp_redirect_map(s=
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
+void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len);
 #else /* CONFIG_NET */
 static inline int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 of=
fset,
 				       void *to, u32 len)
@@ -1557,6 +1560,23 @@ static inline int __bpf_skb_store_bytes(struct sk_=
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
index f6910392d339..9cc988e063de 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5352,13 +5352,17 @@ union bpf_attr {
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
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index a79d522b3a26..ede199107016 100644
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
@@ -1631,6 +1637,12 @@ BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynpt=
r_kern *, ptr, u32, offset, u3
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
index 2c59975c9c39..e3b13f82c2a3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -743,6 +743,8 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum b=
pf_arg_type arg_type)
 		return BPF_DYNPTR_TYPE_RINGBUF;
 	case DYNPTR_TYPE_SKB:
 		return BPF_DYNPTR_TYPE_SKB;
+	case DYNPTR_TYPE_XDP:
+		return BPF_DYNPTR_TYPE_XDP;
 	default:
 		return BPF_DYNPTR_TYPE_INVALID;
 	}
@@ -1630,7 +1632,7 @@ static bool reg_is_pkt_pointer_any(const struct bpf=
_reg_state *reg)
 static bool reg_is_dynptr_slice_pkt(const struct bpf_reg_state *reg)
 {
 	return base_type(reg->type) =3D=3D PTR_TO_MEM &&
-		reg->type & DYNPTR_TYPE_SKB;
+		(reg->type & DYNPTR_TYPE_SKB || reg->type & DYNPTR_TYPE_XDP);
 }
=20
 /* Unmodified PTR_TO_PACKET[_META,_END] register from ctx access. */
@@ -6244,6 +6246,9 @@ int process_dynptr_func(struct bpf_verifier_env *en=
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
@@ -7315,7 +7320,7 @@ static int check_func_proto(const struct bpf_func_p=
roto *fn, int func_id)
 /* Packet data might have moved, any old PTR_TO_PACKET[_META,_END]
  * are now invalid, so turn them into unknown SCALAR_VALUE.
  *
- * This also applies to dynptr slices belonging to skb dynptrs,
+ * This also applies to dynptr slices belonging to skb or xdp dynptrs,
  * since these slices point to packet data.
  */
 static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
@@ -8312,27 +8317,30 @@ static int check_helper_call(struct bpf_verifier_=
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
@@ -8741,6 +8749,7 @@ enum special_kfunc_type {
 	KF_bpf_cast_to_kern_ctx,
 	KF_bpf_rdonly_cast,
 	KF_bpf_dynptr_from_skb,
+	KF_bpf_dynptr_from_xdp,
 	KF_bpf_rcu_read_lock,
 	KF_bpf_rcu_read_unlock,
 };
@@ -8755,6 +8764,7 @@ BTF_ID(func, bpf_list_pop_back)
 BTF_ID(func, bpf_cast_to_kern_ctx)
 BTF_ID(func, bpf_rdonly_cast)
 BTF_ID(func, bpf_dynptr_from_skb)
+BTF_ID(func, bpf_dynptr_from_xdp)
 BTF_SET_END(special_kfunc_set)
=20
 BTF_ID_LIST(special_kfunc_list)
@@ -8767,6 +8777,7 @@ BTF_ID(func, bpf_list_pop_back)
 BTF_ID(func, bpf_cast_to_kern_ctx)
 BTF_ID(func, bpf_rdonly_cast)
 BTF_ID(func, bpf_dynptr_from_skb)
+BTF_ID(func, bpf_dynptr_from_xdp)
 BTF_ID(func, bpf_rcu_read_lock)
 BTF_ID(func, bpf_rcu_read_unlock)
=20
@@ -9368,6 +9379,8 @@ static int check_kfunc_args(struct bpf_verifier_env=
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
index ddb47126071a..fb77d0c9bad6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3855,7 +3855,19 @@ static const struct bpf_func_proto sk_skb_change_h=
ead_proto =3D {
 	.arg3_type	=3D ARG_ANYTHING,
 };
=20
-BPF_CALL_1(bpf_xdp_get_buff_len, struct  xdp_buff*, xdp)
+int bpf_dynptr_from_xdp(struct xdp_buff *xdp, u64 flags, struct bpf_dynp=
tr_kern *ptr)
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
+BPF_CALL_1(bpf_xdp_get_buff_len, struct xdp_buff*, xdp)
 {
 	return xdp_get_buff_len(xdp);
 }
@@ -3957,7 +3969,7 @@ static void bpf_xdp_copy_buf(struct xdp_buff *xdp, =
unsigned long off,
 	}
 }
=20
-static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
+void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
 {
 	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
 	u32 size =3D xdp->data_end - xdp->data;
@@ -3988,8 +4000,7 @@ static void *bpf_xdp_pointer(struct xdp_buff *xdp, =
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
@@ -4005,6 +4016,12 @@ BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, =
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
@@ -4015,8 +4032,7 @@ static const struct bpf_func_proto bpf_xdp_load_byt=
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
@@ -4032,6 +4048,12 @@ BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *,=
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
@@ -11635,6 +11657,10 @@ bpf_sk_base_func_proto(enum bpf_func_id func_id)
 	return func;
 }
=20
+BTF_SET8_START(bpf_kfunc_check_set_xdp)
+BTF_ID_FLAGS(func, bpf_dynptr_from_xdp)
+BTF_SET8_END(bpf_kfunc_check_set_xdp)
+
 BTF_SET8_START(bpf_kfunc_check_set_skb)
 BTF_ID_FLAGS(func, bpf_dynptr_from_skb)
 BTF_SET8_END(bpf_kfunc_check_set_skb)
@@ -11644,6 +11670,11 @@ static const struct btf_kfunc_id_set bpf_kfunc_s=
et_skb =3D {
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
@@ -11656,6 +11687,7 @@ static int __init bpf_kfunc_init(void)
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
index 6b58e5a75fc5..04aa7d0b6437 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5352,13 +5352,17 @@ union bpf_attr {
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
--=20
2.30.2

