Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CB84D2B58
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbiCIJGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiCIJGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:06:11 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2726C16BCC1
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:05:13 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2298Pb6H017411
        for <netdev@vger.kernel.org>; Wed, 9 Mar 2022 01:05:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Jkb0WnMSoZHBo/dvQJTwSL5k62C3Sas1WgGkzfhYHJk=;
 b=NxIXuZUi8Ib3z0Ky34/1BjRtKmRd22BNphInieba1MkmM9HhumkHlDoy32oH2osbNBua
 0huhCBemIXY9lveXLzk6UaJGU/ccgs714imhLiK3YG+SYk8OtcY0+BtzqmGKNSML5+LB
 RxWm6InIkQfTUoRcv09d4bktDORLKlpRluI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ep52tqre4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 01:05:12 -0800
Received: from twshared27297.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 01:05:11 -0800
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 427BA1ADC5F2; Wed,  9 Mar 2022 01:05:09 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 4/5] bpf: Remove BPF_SKB_DELIVERY_TIME_NONE and rename s/delivery_time_/tstamp_/
Date:   Wed, 9 Mar 2022 01:05:09 -0800
Message-ID: <20220309090509.3712315-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220309090444.3710464-1-kafai@fb.com>
References: <20220309090444.3710464-1-kafai@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4v3cmlhjC0BEJg-Mjw4JhCE2g5whJxRg
X-Proofpoint-GUID: 4v3cmlhjC0BEJg-Mjw4JhCE2g5whJxRg
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-09_04,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to simplify the uapi bpf.h regarding to the tstamp type
and use a similar way as the kernel to describe the value stored
in __sk_buff->tstamp.

My earlier thought was to avoid describing the semantic and
clock base for the rcv timestamp until there is more clarity
on the use case, so the __sk_buff->delivery_time_type naming instead
of __sk_buff->tstamp_type.

With some thoughts, it can reuse the UNSPEC naming.  This patch first
removes BPF_SKB_DELIVERY_TIME_NONE and also

rename BPF_SKB_DELIVERY_TIME_UNSPEC to BPF_SKB_TSTAMP_UNSPEC
and    BPF_SKB_DELIVERY_TIME_MONO   to BPF_SKB_TSTAMP_DELIVERY_MONO.

The semantic of BPF_SKB_TSTAMP_DELIVERY_MONO is the same:
__sk_buff->tstamp has delivery time in mono clock base.

BPF_SKB_TSTAMP_UNSPEC means __sk_buff->tstamp has the (rcv)
tstamp at ingress and the delivery time at egress.  At egress,
the clock base could be found from skb->sk->sk_clockid.
__sk_buff->tstamp =3D=3D 0 naturally means NONE, so NONE is not needed.

With BPF_SKB_TSTAMP_UNSPEC for the rcv tstamp at ingress,
the __sk_buff->delivery_time_type is also renamed to __sk_buff->tstamp_type
which was also suggested in the earlier discussion:
https://lore.kernel.org/bpf/b181acbe-caf8-502d-4b7b-7d96b9fc5d55@iogearbox.=
net/

The above will then make __sk_buff->tstamp and __sk_buff->tstamp_type
the same as its kernel skb->tstamp and skb->mono_delivery_time
counter part.

The internal kernel function bpf_skb_convert_dtime_type_read() is then
renamed to bpf_skb_convert_tstamp_type_read() and it can be simplified
with the BPF_SKB_DELIVERY_TIME_NONE gone.  A BPF_ALU32_IMM(BPF_AND)
insn is also saved by using BPF_JMP32_IMM(BPF_JSET).

The bpf helper bpf_skb_set_delivery_time() is also renamed to
bpf_skb_set_tstamp().  The arg name is changed from dtime
to tstamp also.  It only allows setting tstamp 0 for
BPF_SKB_TSTAMP_UNSPEC and it could be relaxed later
if there is use case to change mono delivery time to
non mono.

prog->delivery_time_access is also renamed to prog->tstamp_type_access.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/filter.h         |  2 +-
 include/uapi/linux/bpf.h       | 40 ++++++++--------
 net/core/filter.c              | 88 +++++++++++++---------------------
 tools/include/uapi/linux/bpf.h | 40 ++++++++--------
 4 files changed, 77 insertions(+), 93 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 9bf26307247f..05ed9bd31b45 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -573,7 +573,7 @@ struct bpf_prog {
 				enforce_expected_attach_type:1, /* Enforce expected_attach_type checki=
ng at attach time */
 				call_get_stack:1, /* Do we call bpf_get_stack() or bpf_get_stackid() */
 				call_get_func_ip:1, /* Do we call get_func_ip() */
-				delivery_time_access:1; /* Accessed __sk_buff->delivery_time_type */
+				tstamp_type_access:1; /* Accessed __sk_buff->tstamp_type */
 	enum bpf_prog_type	type;		/* Type of BPF program */
 	enum bpf_attach_type	expected_attach_type; /* For some prog types */
 	u32			len;		/* Number of filter blocks */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4eebea830613..65871bdbb9c8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5087,23 +5087,22 @@ union bpf_attr {
  *		0 on success, or a negative error in case of failure. On error
  *		*dst* buffer is zeroed out.
  *
- * long bpf_skb_set_delivery_time(struct sk_buff *skb, u64 dtime, u32 dtim=
e_type)
+ * long bpf_skb_set_tstamp(struct sk_buff *skb, u64 tstamp, u32 tstamp_typ=
e)
  *	Description
- *		Set a *dtime* (delivery time) to the __sk_buff->tstamp and also
- *		change the __sk_buff->delivery_time_type to *dtime_type*.
+ *		Change the __sk_buff->tstamp_type to *tstamp_type*
+ *		and set *tstamp* to the __sk_buff->tstamp together.
  *
- *		When setting a delivery time (non zero *dtime*) to
- *		__sk_buff->tstamp, only BPF_SKB_DELIVERY_TIME_MONO *dtime_type*
- *		is supported.  It is the only delivery_time_type that will be
- *		kept after bpf_redirect_*().
- *
- *		If there is no need to change the __sk_buff->delivery_time_type,
- *		the delivery time can be directly written to __sk_buff->tstamp
+ *		If there is no need to change the __sk_buff->tstamp_type,
+ *		the tstamp value can be directly written to __sk_buff->tstamp
  *		instead.
  *
- *		*dtime* 0 and *dtime_type* BPF_SKB_DELIVERY_TIME_NONE
- *		can be used to clear any delivery time stored in
- *		__sk_buff->tstamp.
+ *		BPF_SKB_TSTAMP_DELIVERY_MONO is the only tstamp that
+ *		will be kept during bpf_redirect_*().  A non zero
+ *		*tstamp* must be used with the BPF_SKB_TSTAMP_DELIVERY_MONO
+ *		*tstamp_type*.
+ *
+ *		A BPF_SKB_TSTAMP_UNSPEC *tstamp_type* can only be used
+ *		with a zero *tstamp*.
  *
  *		Only IPv4 and IPv6 skb->protocol are supported.
  *
@@ -5116,7 +5115,7 @@ union bpf_attr {
  *	Return
  *		0 on success.
  *		**-EINVAL** for invalid input
- *		**-EOPNOTSUPP** for unsupported delivery_time_type and protocol
+ *		**-EOPNOTSUPP** for unsupported protocol
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5311,7 +5310,7 @@ union bpf_attr {
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
 	FN(copy_from_user_task),	\
-	FN(skb_set_delivery_time),      \
+	FN(skb_set_tstamp),		\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which help=
er
@@ -5502,9 +5501,12 @@ union {					\
 } __attribute__((aligned(8)))
=20
 enum {
-	BPF_SKB_DELIVERY_TIME_NONE,
-	BPF_SKB_DELIVERY_TIME_UNSPEC,
-	BPF_SKB_DELIVERY_TIME_MONO,
+	BPF_SKB_TSTAMP_UNSPEC,
+	BPF_SKB_TSTAMP_DELIVERY_MONO,	/* tstamp has mono delivery time */
+	/* For any BPF_SKB_TSTAMP_* that the bpf prog cannot handle,
+	 * the bpf prog should handle it like BPF_SKB_TSTAMP_UNSPEC
+	 * and try to deduce it by ingress, egress or skb->sk->sk_clockid.
+	 */
 };
=20
 /* user accessible mirror of in-kernel sk_buff.
@@ -5547,7 +5549,7 @@ struct __sk_buff {
 	__u32 gso_segs;
 	__bpf_md_ptr(struct bpf_sock *, sk);
 	__u32 gso_size;
-	__u8  delivery_time_type;
+	__u8  tstamp_type;
 	__u32 :24;		/* Padding, future use. */
 	__u64 hwtstamp;
 };
diff --git a/net/core/filter.c b/net/core/filter.c
index f914e4b13b18..03655f2074ae 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7388,36 +7388,36 @@ static const struct bpf_func_proto bpf_sock_ops_res=
erve_hdr_opt_proto =3D {
 	.arg3_type	=3D ARG_ANYTHING,
 };
=20
-BPF_CALL_3(bpf_skb_set_delivery_time, struct sk_buff *, skb,
-	   u64, dtime, u32, dtime_type)
+BPF_CALL_3(bpf_skb_set_tstamp, struct sk_buff *, skb,
+	   u64, tstamp, u32, tstamp_type)
 {
 	/* skb_clear_delivery_time() is done for inet protocol */
 	if (skb->protocol !=3D htons(ETH_P_IP) &&
 	    skb->protocol !=3D htons(ETH_P_IPV6))
 		return -EOPNOTSUPP;
=20
-	switch (dtime_type) {
-	case BPF_SKB_DELIVERY_TIME_MONO:
-		if (!dtime)
+	switch (tstamp_type) {
+	case BPF_SKB_TSTAMP_DELIVERY_MONO:
+		if (!tstamp)
 			return -EINVAL;
-		skb->tstamp =3D dtime;
+		skb->tstamp =3D tstamp;
 		skb->mono_delivery_time =3D 1;
 		break;
-	case BPF_SKB_DELIVERY_TIME_NONE:
-		if (dtime)
+	case BPF_SKB_TSTAMP_UNSPEC:
+		if (tstamp)
 			return -EINVAL;
 		skb->tstamp =3D 0;
 		skb->mono_delivery_time =3D 0;
 		break;
 	default:
-		return -EOPNOTSUPP;
+		return -EINVAL;
 	}
=20
 	return 0;
 }
=20
-static const struct bpf_func_proto bpf_skb_set_delivery_time_proto =3D {
-	.func           =3D bpf_skb_set_delivery_time,
+static const struct bpf_func_proto bpf_skb_set_tstamp_proto =3D {
+	.func           =3D bpf_skb_set_tstamp,
 	.gpl_only       =3D false,
 	.ret_type       =3D RET_INTEGER,
 	.arg1_type      =3D ARG_PTR_TO_CTX,
@@ -7786,8 +7786,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const=
 struct bpf_prog *prog)
 		return &bpf_tcp_gen_syncookie_proto;
 	case BPF_FUNC_sk_assign:
 		return &bpf_sk_assign_proto;
-	case BPF_FUNC_skb_set_delivery_time:
-		return &bpf_skb_set_delivery_time_proto;
+	case BPF_FUNC_skb_set_tstamp:
+		return &bpf_skb_set_tstamp_proto;
 #endif
 	default:
 		return bpf_sk_base_func_proto(func_id);
@@ -8127,9 +8127,9 @@ static bool bpf_skb_is_valid_access(int off, int size=
, enum bpf_access_type type
 			return false;
 		info->reg_type =3D PTR_TO_SOCK_COMMON_OR_NULL;
 		break;
-	case offsetof(struct __sk_buff, delivery_time_type):
+	case offsetof(struct __sk_buff, tstamp_type):
 		return false;
-	case offsetofend(struct __sk_buff, delivery_time_type) ... offsetof(struc=
t __sk_buff, hwtstamp) - 1:
+	case offsetofend(struct __sk_buff, tstamp_type) ... offsetof(struct __sk_=
buff, hwtstamp) - 1:
 		/* Explicitly prohibit access to padding in __sk_buff. */
 		return false;
 	default:
@@ -8484,14 +8484,14 @@ static bool tc_cls_act_is_valid_access(int off, int=
 size,
 		break;
 	case bpf_ctx_range_till(struct __sk_buff, family, local_port):
 		return false;
-	case offsetof(struct __sk_buff, delivery_time_type):
+	case offsetof(struct __sk_buff, tstamp_type):
 		/* The convert_ctx_access() on reading and writing
 		 * __sk_buff->tstamp depends on whether the bpf prog
-		 * has used __sk_buff->delivery_time_type or not.
-		 * Thus, we need to set prog->delivery_time_access
+		 * has used __sk_buff->tstamp_type or not.
+		 * Thus, we need to set prog->tstamp_type_access
 		 * earlier during is_valid_access() here.
 		 */
-		((struct bpf_prog *)prog)->delivery_time_access =3D 1;
+		((struct bpf_prog *)prog)->tstamp_type_access =3D 1;
 		return size =3D=3D sizeof(__u8);
 	}
=20
@@ -8888,42 +8888,22 @@ static u32 flow_dissector_convert_ctx_access(enum b=
pf_access_type type,
 	return insn - insn_buf;
 }
=20
-static struct bpf_insn *bpf_convert_dtime_type_read(const struct bpf_insn =
*si,
-						    struct bpf_insn *insn)
+static struct bpf_insn *bpf_convert_tstamp_type_read(const struct bpf_insn=
 *si,
+						     struct bpf_insn *insn)
 {
 	__u8 value_reg =3D si->dst_reg;
 	__u8 skb_reg =3D si->src_reg;
+	/* AX is needed because src_reg and dst_reg could be the same */
 	__u8 tmp_reg =3D BPF_REG_AX;
=20
 	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
 			      PKT_VLAN_PRESENT_OFFSET);
-	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
-				SKB_MONO_DELIVERY_TIME_MASK);
-	*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
-	/* value_reg =3D BPF_SKB_DELIVERY_TIME_MONO */
-	*insn++ =3D BPF_MOV32_IMM(value_reg, BPF_SKB_DELIVERY_TIME_MONO);
-	*insn++ =3D BPF_JMP_A(IS_ENABLED(CONFIG_NET_CLS_ACT) ? 10 : 5);
-
-	*insn++ =3D BPF_LDX_MEM(BPF_DW, tmp_reg, skb_reg,
-			      offsetof(struct sk_buff, tstamp));
-	*insn++ =3D BPF_JMP_IMM(BPF_JNE, tmp_reg, 0, 2);
-	/* value_reg =3D BPF_SKB_DELIVERY_TIME_NONE */
-	*insn++ =3D BPF_MOV32_IMM(value_reg, BPF_SKB_DELIVERY_TIME_NONE);
-	*insn++ =3D BPF_JMP_A(IS_ENABLED(CONFIG_NET_CLS_ACT) ? 6 : 1);
-
-#ifdef CONFIG_NET_CLS_ACT
-	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, PKT_VLAN_PRESENT_OFFSET);
-	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
-	*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
-	/* At ingress, value_reg =3D 0 */
-	*insn++ =3D BPF_MOV32_IMM(value_reg, 0);
+	*insn++ =3D BPF_JMP32_IMM(BPF_JSET, tmp_reg,
+				SKB_MONO_DELIVERY_TIME_MASK, 2);
+	*insn++ =3D BPF_MOV32_IMM(value_reg, BPF_SKB_TSTAMP_UNSPEC);
 	*insn++ =3D BPF_JMP_A(1);
-#endif
-
-	/* value_reg =3D BPF_SKB_DELIVERYT_TIME_UNSPEC */
-	*insn++ =3D BPF_MOV32_IMM(value_reg, BPF_SKB_DELIVERY_TIME_UNSPEC);
+	*insn++ =3D BPF_MOV32_IMM(value_reg, BPF_SKB_TSTAMP_DELIVERY_MONO);
=20
-	/* 15 insns with CONFIG_NET_CLS_ACT */
 	return insn;
 }
=20
@@ -8956,11 +8936,11 @@ static struct bpf_insn *bpf_convert_tstamp_read(con=
st struct bpf_prog *prog,
 	__u8 skb_reg =3D si->src_reg;
=20
 #ifdef CONFIG_NET_CLS_ACT
-	/* If the delivery_time_type is read,
+	/* If the tstamp_type is read,
 	 * the bpf prog is aware the tstamp could have delivery time.
-	 * Thus, read skb->tstamp as is if delivery_time_access is true.
+	 * Thus, read skb->tstamp as is if tstamp_type_access is true.
 	 */
-	if (!prog->delivery_time_access) {
+	if (!prog->tstamp_type_access) {
 		/* AX is needed because src_reg and dst_reg could be the same */
 		__u8 tmp_reg =3D BPF_REG_AX;
=20
@@ -8990,13 +8970,13 @@ static struct bpf_insn *bpf_convert_tstamp_write(co=
nst struct bpf_prog *prog,
 	__u8 skb_reg =3D si->dst_reg;
=20
 #ifdef CONFIG_NET_CLS_ACT
-	/* If the delivery_time_type is read,
+	/* If the tstamp_type is read,
 	 * the bpf prog is aware the tstamp could have delivery time.
-	 * Thus, write skb->tstamp as is if delivery_time_access is true.
+	 * Thus, write skb->tstamp as is if tstamp_type_access is true.
 	 * Otherwise, writing at ingress will have to clear the
 	 * mono_delivery_time bit also.
 	 */
-	if (!prog->delivery_time_access) {
+	if (!prog->tstamp_type_access) {
 		__u8 tmp_reg =3D BPF_REG_AX;
=20
 		*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, PKT_VLAN_PRESENT_OFFSET=
);
@@ -9329,8 +9309,8 @@ static u32 bpf_convert_ctx_access(enum bpf_access_typ=
e type,
 			insn =3D bpf_convert_tstamp_read(prog, si, insn);
 		break;
=20
-	case offsetof(struct __sk_buff, delivery_time_type):
-		insn =3D bpf_convert_dtime_type_read(si, insn);
+	case offsetof(struct __sk_buff, tstamp_type):
+		insn =3D bpf_convert_tstamp_type_read(si, insn);
 		break;
=20
 	case offsetof(struct __sk_buff, gso_segs):
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4eebea830613..65871bdbb9c8 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5087,23 +5087,22 @@ union bpf_attr {
  *		0 on success, or a negative error in case of failure. On error
  *		*dst* buffer is zeroed out.
  *
- * long bpf_skb_set_delivery_time(struct sk_buff *skb, u64 dtime, u32 dtim=
e_type)
+ * long bpf_skb_set_tstamp(struct sk_buff *skb, u64 tstamp, u32 tstamp_typ=
e)
  *	Description
- *		Set a *dtime* (delivery time) to the __sk_buff->tstamp and also
- *		change the __sk_buff->delivery_time_type to *dtime_type*.
+ *		Change the __sk_buff->tstamp_type to *tstamp_type*
+ *		and set *tstamp* to the __sk_buff->tstamp together.
  *
- *		When setting a delivery time (non zero *dtime*) to
- *		__sk_buff->tstamp, only BPF_SKB_DELIVERY_TIME_MONO *dtime_type*
- *		is supported.  It is the only delivery_time_type that will be
- *		kept after bpf_redirect_*().
- *
- *		If there is no need to change the __sk_buff->delivery_time_type,
- *		the delivery time can be directly written to __sk_buff->tstamp
+ *		If there is no need to change the __sk_buff->tstamp_type,
+ *		the tstamp value can be directly written to __sk_buff->tstamp
  *		instead.
  *
- *		*dtime* 0 and *dtime_type* BPF_SKB_DELIVERY_TIME_NONE
- *		can be used to clear any delivery time stored in
- *		__sk_buff->tstamp.
+ *		BPF_SKB_TSTAMP_DELIVERY_MONO is the only tstamp that
+ *		will be kept during bpf_redirect_*().  A non zero
+ *		*tstamp* must be used with the BPF_SKB_TSTAMP_DELIVERY_MONO
+ *		*tstamp_type*.
+ *
+ *		A BPF_SKB_TSTAMP_UNSPEC *tstamp_type* can only be used
+ *		with a zero *tstamp*.
  *
  *		Only IPv4 and IPv6 skb->protocol are supported.
  *
@@ -5116,7 +5115,7 @@ union bpf_attr {
  *	Return
  *		0 on success.
  *		**-EINVAL** for invalid input
- *		**-EOPNOTSUPP** for unsupported delivery_time_type and protocol
+ *		**-EOPNOTSUPP** for unsupported protocol
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5311,7 +5310,7 @@ union bpf_attr {
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
 	FN(copy_from_user_task),	\
-	FN(skb_set_delivery_time),      \
+	FN(skb_set_tstamp),		\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which help=
er
@@ -5502,9 +5501,12 @@ union {					\
 } __attribute__((aligned(8)))
=20
 enum {
-	BPF_SKB_DELIVERY_TIME_NONE,
-	BPF_SKB_DELIVERY_TIME_UNSPEC,
-	BPF_SKB_DELIVERY_TIME_MONO,
+	BPF_SKB_TSTAMP_UNSPEC,
+	BPF_SKB_TSTAMP_DELIVERY_MONO,	/* tstamp has mono delivery time */
+	/* For any BPF_SKB_TSTAMP_* that the bpf prog cannot handle,
+	 * the bpf prog should handle it like BPF_SKB_TSTAMP_UNSPEC
+	 * and try to deduce it by ingress, egress or skb->sk->sk_clockid.
+	 */
 };
=20
 /* user accessible mirror of in-kernel sk_buff.
@@ -5547,7 +5549,7 @@ struct __sk_buff {
 	__u32 gso_segs;
 	__bpf_md_ptr(struct bpf_sock *, sk);
 	__u32 gso_size;
-	__u8  delivery_time_type;
+	__u8  tstamp_type;
 	__u32 :24;		/* Padding, future use. */
 	__u64 hwtstamp;
 };
--=20
2.30.2

