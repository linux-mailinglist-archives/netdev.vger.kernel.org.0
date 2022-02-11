Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCEA4B1F1A
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347624AbiBKHNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:13:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347621AbiBKHNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:13:20 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD68D110E
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:19 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ANrSNj018649
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=LEZ8scgy1qDfbqzhAvnlUfuwJes0fc2MM9TH2kqtX14=;
 b=hNtQu47+Ti+nEpkvJqku9Ce6KsM/SGVGyrvQbYw+/MtYtaVnofqy0OBLqnpdWxHNNtAr
 b8uET2fv1q+tl+Kqx7S8K98k0xex6U61BPlrgXbQ7eOivNgkRZU4tMl/j25Z9zKmkYPH
 dV/1dlWwSLYaz7G6yi1hHvFaVr1CV5iUGyI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e5866v2yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:19 -0800
Received: from twshared14630.35.frc1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 23:13:18 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 596CB6C75B6D; Thu, 10 Feb 2022 23:13:16 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v4 net-next 7/8] bpf: Add __sk_buff->delivery_time_type and bpf_skb_set_delivery_time()
Date:   Thu, 10 Feb 2022 23:13:16 -0800
Message-ID: <20220211071316.892630-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220211071232.885225-1-kafai@fb.com>
References: <20220211071232.885225-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: nNw0gq8i3Rbw1DBZiWoEmMoZJBUyGccE
X-Proofpoint-ORIG-GUID: nNw0gq8i3Rbw1DBZiWoEmMoZJBUyGccE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 clxscore=1015 suspectscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110040
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* __sk_buff->delivery_time_type:
This patch adds __sk_buff->delivery_time_type.  It tells if the
delivery_time is stored in __sk_buff->tstamp or not.

It will be most useful for ingress to tell if the __sk_buff->tstamp
has the (rcv) timestamp or delivery_time.  If delivery_time_type
is 0 (BPF_SKB_DELIVERY_TIME_NONE), it has the (rcv) timestamp.

Two non-zero types are defined for the delivery_time_type,
BPF_SKB_DELIVERY_TIME_MONO and BPF_SKB_DELIVERY_TIME_UNSPEC.  For UNSPEC,
it can only happen in egress because only mono delivery_time can be
forwarded to ingress now.  The clock of UNSPEC delivery_time
can be deduced from the skb->sk->sk_clockid which is how
the sch_etf doing it also.

Thus, while delivery_time_type provides (rcv) timestamp
vs delivery_time signal to tc-bpf@ingress, it should not change the
existing way of doing thing for tc-bpf@egress other than spelling
out more explicitly in the new __sk_buff->delivery_time_type
instead of having the tc-bpf to deduce it by checking the sk
is tcp (mono EDT) or by checking sk->sk_clockid for non-tcp.

delivery_time_type is read only.  Its convert_ctx_access() requires
the skb's mono_delivery_time bit and tc_at_ingress bit.
They are moved up in sk_buff so that bpf rewrite can be done at a
fixed offset.  tc_skip_classify is moved together with tc_at_ingress.
To get one bit for mono_delivery_time, csum_not_inet is moved down and
this bit is currently used by sctp.

* Provide forwarded delivery_time to tc-bpf@ingress:
With the help of the new delivery_time_type, the tc-bpf has a way
to tell if the __sk_buff->tstamp has the (rcv) timestamp or
the delivery_time.  During bpf load time, the verifier will learn if
the bpf prog has accessed the new __sk_buff->delivery_time_type.
If it does, it means the tc-bpf@ingress is expecting the
skb->tstamp could have the delivery_time.  The kernel will then keep
the forwarded delivery_time in skb->tstamp.  This is done by adding a
new prog->delivery_time_access bit.

Since the tc-bpf@ingress can access the delivery_time,
it also needs to clear the skb->mono_delivery_time after
running the bpf if 0 has been written to skb->tstamp.  This
is the same as the tc-bpf@egress in the previous patch.

For tail call, the callee will follow the __sk_buff->tstamp
expectation of its caller at ingress.  If caller does not have
its prog->delivery_time_access set, the callee prog will not have
the forwarded delivery_time in __sk_buff->tstamp and will have
the (rcv) timestamp instead.  If needed, in the future, a new
attach_type can be added to allow the tc-bpf to explicitly specify
its expectation on the __sk_buff->tstamp.

* bpf_skb_set_delivery_time():
The bpf_skb_set_delivery_time() helper is added to allow setting both
delivery_time and the delivery_time_type at the same time.  If the
tc-bpf does not need to change the delivery_time_type, it can directly
write to the __sk_buff->tstamp as the existing tc-bpf has already been
doing.  It will be most useful at ingress to change the
__sk_buff->tstamp from the (rcv) timestamp to
a mono delivery_time and then bpf_redirect_*().

bpf only has mono clock helper (bpf_ktime_get_ns), and
the current known use case is the mono EDT for fq, and
only mono delivery time can be kept during forward now,
so bpf_skb_set_delivery_time() only supports setting
BPF_SKB_DELIVERY_TIME_MONO.  It can be extended later when use cases
come up and the forwarding path also supports other clock bases.
This function could be inline and is left as a future exercise.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/filter.h         |  7 ++-
 include/linux/skbuff.h         | 20 ++++++---
 include/uapi/linux/bpf.h       | 35 ++++++++++++++-
 net/core/filter.c              | 79 +++++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h | 35 ++++++++++++++-
 5 files changed, 164 insertions(+), 12 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index e43e1701a80e..00bbde352ad0 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -572,7 +572,8 @@ struct bpf_prog {
 				has_callchain_buf:1, /* callchain buffer allocated? */
 				enforce_expected_attach_type:1, /* Enforce expected_attach_type chec=
king at attach time */
 				call_get_stack:1, /* Do we call bpf_get_stack() or bpf_get_stackid()=
 */
-				call_get_func_ip:1; /* Do we call get_func_ip() */
+				call_get_func_ip:1, /* Do we call get_func_ip() */
+				delivery_time_access:1; /* Accessed __sk_buff->delivery_time_type */
 	enum bpf_prog_type	type;		/* Type of BPF program */
 	enum bpf_attach_type	expected_attach_type; /* For some prog types */
 	u32			len;		/* Number of filter blocks */
@@ -705,7 +706,7 @@ static __always_inline u32 bpf_prog_run_at_ingress(co=
nst struct bpf_prog *prog,
 	ktime_t tstamp, saved_mono_dtime =3D 0;
 	int filter_res;
=20
-	if (unlikely(skb->mono_delivery_time)) {
+	if (unlikely(skb->mono_delivery_time) && !prog->delivery_time_access) {
 		saved_mono_dtime =3D skb->tstamp;
 		skb->mono_delivery_time =3D 0;
 		if (static_branch_unlikely(&netstamp_needed_key))
@@ -723,6 +724,8 @@ static __always_inline u32 bpf_prog_run_at_ingress(co=
nst struct bpf_prog *prog,
 	/* __sk_buff->tstamp was not changed, restore the delivery_time */
 	if (unlikely(saved_mono_dtime) && skb_tstamp(skb) =3D=3D tstamp)
 		skb_set_delivery_time(skb, saved_mono_dtime, true);
+	if (unlikely(skb->mono_delivery_time && !skb->tstamp))
+		skb->mono_delivery_time =3D 0;
=20
 	return filter_res;
 }
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0e09e75fa787..fb7146be48f7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -893,22 +893,23 @@ struct sk_buff {
 	__u8			vlan_present:1;	/* See PKT_VLAN_PRESENT_BIT */
 	__u8			csum_complete_sw:1;
 	__u8			csum_level:2;
-	__u8			csum_not_inet:1;
 	__u8			dst_pending_confirm:1;
+	__u8			mono_delivery_time:1;
+
+#ifdef CONFIG_NET_CLS_ACT
+	__u8			tc_skip_classify:1;
+	__u8			tc_at_ingress:1;
+#endif
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	__u8			ndisc_nodetype:2;
 #endif
-
+	__u8			csum_not_inet:1;
 	__u8			ipvs_property:1;
 	__u8			inner_protocol_type:1;
 	__u8			remcsum_offload:1;
 #ifdef CONFIG_NET_SWITCHDEV
 	__u8			offload_fwd_mark:1;
 	__u8			offload_l3_fwd_mark:1;
-#endif
-#ifdef CONFIG_NET_CLS_ACT
-	__u8			tc_skip_classify:1;
-	__u8			tc_at_ingress:1;
 #endif
 	__u8			redirected:1;
 #ifdef CONFIG_NET_REDIRECT
@@ -921,7 +922,6 @@ struct sk_buff {
 	__u8			decrypted:1;
 #endif
 	__u8			slow_gro:1;
-	__u8			mono_delivery_time:1;
=20
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
@@ -999,10 +999,16 @@ struct sk_buff {
 /* if you move pkt_vlan_present around you also must adapt these constan=
ts */
 #ifdef __BIG_ENDIAN_BITFIELD
 #define PKT_VLAN_PRESENT_BIT	7
+#define TC_AT_INGRESS_MASK		(1 << 0)
+#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 2)
 #else
 #define PKT_VLAN_PRESENT_BIT	0
+#define TC_AT_INGRESS_MASK		(1 << 7)
+#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 5)
 #endif
 #define PKT_VLAN_PRESENT_OFFSET	offsetof(struct sk_buff, __pkt_vlan_pres=
ent_offset)
+#define TC_AT_INGRESS_OFFSET offsetof(struct sk_buff, __pkt_vlan_present=
_offset)
+#define SKB_MONO_DELIVERY_TIME_OFFSET offsetof(struct sk_buff, __pkt_vla=
n_present_offset)
=20
 #ifdef __KERNEL__
 /*
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 16a7574292a5..b36771b1bfa1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5076,6 +5076,31 @@ union bpf_attr {
  *		associated to *xdp_md*, at *offset*.
  *	Return
  *		0 on success, or a negative error in case of failure.
+ *
+ * long bpf_skb_set_delivery_time(struct sk_buff *skb, u64 dtime, u32 dt=
ime_type)
+ *	Description
+ *		Set a *dtime* (delivery time) to the __sk_buff->tstamp and also
+ *		change the __sk_buff->delivery_time_type to *dtime_type*.
+ *
+ *		Only BPF_SKB_DELIVERY_TIME_MONO is supported in *dtime_type*
+ *		and it is the only delivery_time_type that will be kept
+ *		after bpf_redirect_*().
+ *		Only ipv4 and ipv6 skb->protocol is supported.
+ *
+ *		If there is no need to change the __sk_buff->delivery_time_type,
+ *		the delivery_time can be directly written to __sk_buff->tstamp
+ *		instead.
+ *
+ *		This function is most useful when it needs to set a
+ *		mono delivery_time to __sk_buff->tstamp and then
+ *		bpf_redirect_*() to the egress of an iface.  For example,
+ *		changing the (rcv) timestamp in __sk_buff->tstamp at
+ *		ingress to a mono delivery time and then bpf_redirect_*()
+ *		to sch_fq@phy-dev.
+ *	Return
+ *		0 on success.
+ *		**-EINVAL** for invalid input
+ *		**-EOPNOTSUPP** for unsupported delivery_time_type and protocol
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5269,6 +5294,7 @@ union bpf_attr {
 	FN(xdp_get_buff_len),		\
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
+	FN(skb_set_delivery_time),	\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
@@ -5458,6 +5484,12 @@ union {					\
 	__u64 :64;			\
 } __attribute__((aligned(8)))
=20
+enum {
+	BPF_SKB_DELIVERY_TIME_NONE,
+	BPF_SKB_DELIVERY_TIME_UNSPEC,
+	BPF_SKB_DELIVERY_TIME_MONO,
+};
+
 /* user accessible mirror of in-kernel sk_buff.
  * new fields can only be added to the end of this structure
  */
@@ -5498,7 +5530,8 @@ struct __sk_buff {
 	__u32 gso_segs;
 	__bpf_md_ptr(struct bpf_sock *, sk);
 	__u32 gso_size;
-	__u32 :32;		/* Padding, future use. */
+	__u8  delivery_time_type;
+	__u32 :24;		/* Padding, future use. */
 	__u64 hwtstamp;
 };
=20
diff --git a/net/core/filter.c b/net/core/filter.c
index a2d712be4985..0e79a6ca4a95 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7159,6 +7159,33 @@ static const struct bpf_func_proto bpf_sk_assign_p=
roto =3D {
 	.arg3_type	=3D ARG_ANYTHING,
 };
=20
+BPF_CALL_3(bpf_skb_set_delivery_time, struct sk_buff *, skb,
+	   u64, dtime, u32, dtime_type)
+{
+	if (!dtime)
+		return -EINVAL;
+
+	/* skb_clear_delivery_time() is done for inet protocol */
+	if (dtime_type !=3D BPF_SKB_DELIVERY_TIME_MONO ||
+	    (skb->protocol !=3D htons(ETH_P_IP) &&
+	     skb->protocol !=3D htons(ETH_P_IPV6)))
+		return -EOPNOTSUPP;
+
+	skb->mono_delivery_time =3D 1;
+	skb->tstamp =3D dtime;
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_skb_set_delivery_time_proto =3D {
+	.func		=3D bpf_skb_set_delivery_time,
+	.gpl_only	=3D false,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type      =3D ARG_PTR_TO_CTX,
+	.arg2_type      =3D ARG_ANYTHING,
+	.arg3_type	=3D ARG_ANYTHING,
+};
+
 static const u8 *bpf_search_tcp_opt(const u8 *op, const u8 *opend,
 				    u8 search_kind, const u8 *magic,
 				    u8 magic_len, bool *eol)
@@ -7746,6 +7773,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, con=
st struct bpf_prog *prog)
 		return &bpf_tcp_gen_syncookie_proto;
 	case BPF_FUNC_sk_assign:
 		return &bpf_sk_assign_proto;
+	case BPF_FUNC_skb_set_delivery_time:
+		return &bpf_skb_set_delivery_time_proto;
 #endif
 	default:
 		return bpf_sk_base_func_proto(func_id);
@@ -8085,7 +8114,9 @@ static bool bpf_skb_is_valid_access(int off, int si=
ze, enum bpf_access_type type
 			return false;
 		info->reg_type =3D PTR_TO_SOCK_COMMON_OR_NULL;
 		break;
-	case offsetofend(struct __sk_buff, gso_size) ... offsetof(struct __sk_b=
uff, hwtstamp) - 1:
+	case offsetof(struct __sk_buff, delivery_time_type):
+		return false;
+	case offsetofend(struct __sk_buff, delivery_time_type) ... offsetof(str=
uct __sk_buff, hwtstamp) - 1:
 		/* Explicitly prohibit access to padding in __sk_buff. */
 		return false;
 	default:
@@ -8432,6 +8463,8 @@ static bool tc_cls_act_is_valid_access(int off, int=
 size,
 		break;
 	case bpf_ctx_range_till(struct __sk_buff, family, local_port):
 		return false;
+	case offsetof(struct __sk_buff, delivery_time_type):
+		return size =3D=3D sizeof(__u8);
 	}
=20
 	return bpf_skb_is_valid_access(off, size, type, prog, info);
@@ -8848,6 +8881,45 @@ static struct bpf_insn *bpf_convert_shinfo_access(=
const struct bpf_insn *si,
 	return insn;
 }
=20
+static struct bpf_insn *bpf_convert_dtime_type_read(const struct bpf_ins=
n *si,
+						    struct bpf_insn *insn)
+{
+	__u8 value_reg =3D si->dst_reg;
+	__u8 skb_reg =3D si->src_reg;
+	__u8 tmp_reg =3D BPF_REG_AX;
+
+	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
+			      SKB_MONO_DELIVERY_TIME_OFFSET);
+	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
+				SKB_MONO_DELIVERY_TIME_MASK);
+	*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
+	/* value_reg =3D BPF_SKB_DELIVERY_TIME_MONO */
+	*insn++ =3D BPF_MOV32_IMM(value_reg, BPF_SKB_DELIVERY_TIME_MONO);
+	*insn++ =3D BPF_JMP_A(IS_ENABLED(CONFIG_NET_CLS_ACT) ? 10 : 5);
+
+	*insn++ =3D BPF_LDX_MEM(BPF_DW, tmp_reg, skb_reg,
+			      offsetof(struct sk_buff, tstamp));
+	*insn++ =3D BPF_JMP_IMM(BPF_JNE, tmp_reg, 0, 2);
+	/* value_reg =3D BPF_SKB_DELIVERY_TIME_NONE */
+	*insn++ =3D BPF_MOV32_IMM(value_reg, BPF_SKB_DELIVERY_TIME_NONE);
+	*insn++ =3D BPF_JMP_A(IS_ENABLED(CONFIG_NET_CLS_ACT) ? 6 : 1);
+
+#ifdef CONFIG_NET_CLS_ACT
+	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
+	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
+	*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
+	/* At ingress, value_reg =3D 0 */
+	*insn++ =3D BPF_MOV32_IMM(value_reg, 0);
+	*insn++ =3D BPF_JMP_A(1);
+#endif
+
+	/* value_reg =3D BPF_SKB_DELIVERYT_TIME_UNSPEC */
+	*insn++ =3D BPF_MOV32_IMM(value_reg, BPF_SKB_DELIVERY_TIME_UNSPEC);
+
+	/* 15 insns with CONFIG_NET_CLS_ACT */
+	return insn;
+}
+
 static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 				  const struct bpf_insn *si,
 				  struct bpf_insn *insn_buf,
@@ -9169,6 +9241,11 @@ static u32 bpf_convert_ctx_access(enum bpf_access_=
type type,
 							     target_size));
 		break;
=20
+	case offsetof(struct __sk_buff, delivery_time_type):
+		insn =3D bpf_convert_dtime_type_read(si, insn);
+		prog->delivery_time_access =3D 1;
+		break;
+
 	case offsetof(struct __sk_buff, gso_segs):
 		insn =3D bpf_convert_shinfo_access(si, insn);
 		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct skb_shared_info, gso_s=
egs),
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 16a7574292a5..b36771b1bfa1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5076,6 +5076,31 @@ union bpf_attr {
  *		associated to *xdp_md*, at *offset*.
  *	Return
  *		0 on success, or a negative error in case of failure.
+ *
+ * long bpf_skb_set_delivery_time(struct sk_buff *skb, u64 dtime, u32 dt=
ime_type)
+ *	Description
+ *		Set a *dtime* (delivery time) to the __sk_buff->tstamp and also
+ *		change the __sk_buff->delivery_time_type to *dtime_type*.
+ *
+ *		Only BPF_SKB_DELIVERY_TIME_MONO is supported in *dtime_type*
+ *		and it is the only delivery_time_type that will be kept
+ *		after bpf_redirect_*().
+ *		Only ipv4 and ipv6 skb->protocol is supported.
+ *
+ *		If there is no need to change the __sk_buff->delivery_time_type,
+ *		the delivery_time can be directly written to __sk_buff->tstamp
+ *		instead.
+ *
+ *		This function is most useful when it needs to set a
+ *		mono delivery_time to __sk_buff->tstamp and then
+ *		bpf_redirect_*() to the egress of an iface.  For example,
+ *		changing the (rcv) timestamp in __sk_buff->tstamp at
+ *		ingress to a mono delivery time and then bpf_redirect_*()
+ *		to sch_fq@phy-dev.
+ *	Return
+ *		0 on success.
+ *		**-EINVAL** for invalid input
+ *		**-EOPNOTSUPP** for unsupported delivery_time_type and protocol
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5269,6 +5294,7 @@ union bpf_attr {
 	FN(xdp_get_buff_len),		\
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
+	FN(skb_set_delivery_time),	\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
@@ -5458,6 +5484,12 @@ union {					\
 	__u64 :64;			\
 } __attribute__((aligned(8)))
=20
+enum {
+	BPF_SKB_DELIVERY_TIME_NONE,
+	BPF_SKB_DELIVERY_TIME_UNSPEC,
+	BPF_SKB_DELIVERY_TIME_MONO,
+};
+
 /* user accessible mirror of in-kernel sk_buff.
  * new fields can only be added to the end of this structure
  */
@@ -5498,7 +5530,8 @@ struct __sk_buff {
 	__u32 gso_segs;
 	__bpf_md_ptr(struct bpf_sock *, sk);
 	__u32 gso_size;
-	__u32 :32;		/* Padding, future use. */
+	__u8  delivery_time_type;
+	__u32 :24;		/* Padding, future use. */
 	__u64 hwtstamp;
 };
=20
--=20
2.30.2

