Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEBF24C8362
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbiCAFiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbiCAFim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:38:42 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCAD49F10
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:37:58 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21SMwccw019902
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:37:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hGFX2LDuDKaw6ZLgTyhmgP9Z1Lhpf8924/hIS5ltyz4=;
 b=Vyf6BgdHntErre3GDTyzNm8HWwDj2uvz5a9BoGV/TStcJFYQMxzE0PPcJaaEUGjzXGdt
 JlhWq1ee88si/e6yaWjdEgmjXf6ajM/5s1DFdL4cvJEJ6XXcO07KMGSmvsakciJvoBub
 CzSGpzJulKy0qH/84wq9zY42S1edy90+7DM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3egx7hp03u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:37:58 -0800
Received: from twshared21672.25.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 21:37:56 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id EC4A77A89655; Mon, 28 Feb 2022 21:37:46 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v5 net-next 12/13] bpf: Add __sk_buff->delivery_time_type and bpf_skb_set_skb_delivery_time()
Date:   Mon, 28 Feb 2022 21:37:46 -0800
Message-ID: <20220301053746.935420-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301053631.930498-1-kafai@fb.com>
References: <20220301053631.930498-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 0HbH8INGO2xZMofpnQqwXdlnrRWMz9I8
X-Proofpoint-ORIG-GUID: 0HbH8INGO2xZMofpnQqwXdlnrRWMz9I8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-28_10,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 bulkscore=0 phishscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203010026
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

* Provide forwarded delivery_time to tc-bpf@ingress:
With the help of the new delivery_time_type, the tc-bpf has a way
to tell if the __sk_buff->tstamp has the (rcv) timestamp or
the delivery_time.  During bpf load time, the verifier will learn if
the bpf prog has accessed the new __sk_buff->delivery_time_type.
If it does, it means the tc-bpf@ingress is expecting the
skb->tstamp could have the delivery_time.  The kernel will then
read the skb->tstamp as-is during bpf insn rewrite without
checking the skb->mono_delivery_time.  This is done by adding a
new prog->delivery_time_access bit.  The same goes for
writing skb->tstamp.

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

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/filter.h         |   3 +-
 include/uapi/linux/bpf.h       |  41 +++++++-
 net/core/filter.c              | 169 ++++++++++++++++++++++++++-------
 tools/include/uapi/linux/bpf.h |  41 +++++++-
 4 files changed, 216 insertions(+), 38 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1cb1af917617..9bf26307247f 100644
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
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index afe3d0d7f5f2..4eebea830613 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5086,6 +5086,37 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure. On error
  *		*dst* buffer is zeroed out.
+ *
+ * long bpf_skb_set_delivery_time(struct sk_buff *skb, u64 dtime, u32 dt=
ime_type)
+ *	Description
+ *		Set a *dtime* (delivery time) to the __sk_buff->tstamp and also
+ *		change the __sk_buff->delivery_time_type to *dtime_type*.
+ *
+ *		When setting a delivery time (non zero *dtime*) to
+ *		__sk_buff->tstamp, only BPF_SKB_DELIVERY_TIME_MONO *dtime_type*
+ *		is supported.  It is the only delivery_time_type that will be
+ *		kept after bpf_redirect_*().
+ *
+ *		If there is no need to change the __sk_buff->delivery_time_type,
+ *		the delivery time can be directly written to __sk_buff->tstamp
+ *		instead.
+ *
+ *		*dtime* 0 and *dtime_type* BPF_SKB_DELIVERY_TIME_NONE
+ *		can be used to clear any delivery time stored in
+ *		__sk_buff->tstamp.
+ *
+ *		Only IPv4 and IPv6 skb->protocol are supported.
+ *
+ *		This function is most useful when it needs to set a
+ *		mono delivery time to __sk_buff->tstamp and then
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
@@ -5280,6 +5311,7 @@ union bpf_attr {
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
 	FN(copy_from_user_task),	\
+	FN(skb_set_delivery_time),      \
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
@@ -5469,6 +5501,12 @@ union {					\
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
@@ -5509,7 +5547,8 @@ struct __sk_buff {
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
index 5072733743e9..88767f7da150 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7388,6 +7388,43 @@ static const struct bpf_func_proto bpf_sock_ops_re=
serve_hdr_opt_proto =3D {
 	.arg3_type	=3D ARG_ANYTHING,
 };
=20
+BPF_CALL_3(bpf_skb_set_delivery_time, struct sk_buff *, skb,
+	   u64, dtime, u32, dtime_type)
+{
+	/* skb_clear_delivery_time() is done for inet protocol */
+	if (skb->protocol !=3D htons(ETH_P_IP) &&
+	    skb->protocol !=3D htons(ETH_P_IPV6))
+		return -EOPNOTSUPP;
+
+	switch (dtime_type) {
+	case BPF_SKB_DELIVERY_TIME_MONO:
+		if (!dtime)
+			return -EINVAL;
+		skb->tstamp =3D dtime;
+		skb->mono_delivery_time =3D 1;
+		break;
+	case BPF_SKB_DELIVERY_TIME_NONE:
+		if (dtime)
+			return -EINVAL;
+		skb->tstamp =3D 0;
+		skb->mono_delivery_time =3D 0;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_skb_set_delivery_time_proto =3D {
+	.func           =3D bpf_skb_set_delivery_time,
+	.gpl_only       =3D false,
+	.ret_type       =3D RET_INTEGER,
+	.arg1_type      =3D ARG_PTR_TO_CTX,
+	.arg2_type      =3D ARG_ANYTHING,
+	.arg3_type      =3D ARG_ANYTHING,
+};
+
 #endif /* CONFIG_INET */
=20
 bool bpf_helper_changes_pkt_data(void *func)
@@ -7749,6 +7786,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, con=
st struct bpf_prog *prog)
 		return &bpf_tcp_gen_syncookie_proto;
 	case BPF_FUNC_sk_assign:
 		return &bpf_sk_assign_proto;
+	case BPF_FUNC_skb_set_delivery_time:
+		return &bpf_skb_set_delivery_time_proto;
 #endif
 	default:
 		return bpf_sk_base_func_proto(func_id);
@@ -8088,7 +8127,9 @@ static bool bpf_skb_is_valid_access(int off, int si=
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
@@ -8443,6 +8484,15 @@ static bool tc_cls_act_is_valid_access(int off, in=
t size,
 		break;
 	case bpf_ctx_range_till(struct __sk_buff, family, local_port):
 		return false;
+	case offsetof(struct __sk_buff, delivery_time_type):
+		/* The convert_ctx_access() on reading and writing
+		 * __sk_buff->tstamp depends on whether the bpf prog
+		 * has used __sk_buff->delivery_time_type or not.
+		 * Thus, we need to set prog->delivery_time_access
+		 * earlier during is_valid_access() here.
+		 */
+		((struct bpf_prog *)prog)->delivery_time_access =3D 1;
+		return size =3D=3D sizeof(__u8);
 	}
=20
 	return bpf_skb_is_valid_access(off, size, type, prog, info);
@@ -8838,6 +8888,45 @@ static u32 flow_dissector_convert_ctx_access(enum =
bpf_access_type type,
 	return insn - insn_buf;
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
 static struct bpf_insn *bpf_convert_shinfo_access(const struct bpf_insn =
*si,
 						  struct bpf_insn *insn)
 {
@@ -8859,29 +8948,32 @@ static struct bpf_insn *bpf_convert_shinfo_access=
(const struct bpf_insn *si,
 	return insn;
 }
=20
-static struct bpf_insn *bpf_convert_tstamp_read(const struct bpf_insn *s=
i,
+static struct bpf_insn *bpf_convert_tstamp_read(const struct bpf_prog *p=
rog,
+						const struct bpf_insn *si,
 						struct bpf_insn *insn)
 {
 	__u8 value_reg =3D si->dst_reg;
 	__u8 skb_reg =3D si->src_reg;
=20
 #ifdef CONFIG_NET_CLS_ACT
-	__u8 tmp_reg =3D BPF_REG_AX;
-
-	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
-	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
-	*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 5);
-	/* @ingress, read __sk_buff->tstamp as the (rcv) timestamp,
-	 * so check the skb->mono_delivery_time.
-	 */
-	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
-			      SKB_MONO_DELIVERY_TIME_OFFSET);
-	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
-				SKB_MONO_DELIVERY_TIME_MASK);
-	*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
-	/* skb->mono_delivery_time is set, read 0 as the (rcv) timestamp. */
-	*insn++ =3D BPF_MOV64_IMM(value_reg, 0);
-	*insn++ =3D BPF_JMP_A(1);
+	if (!prog->delivery_time_access) {
+		__u8 tmp_reg =3D BPF_REG_AX;
+
+		*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET)=
;
+		*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
+		*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 5);
+		/* @ingress, read __sk_buff->tstamp as the (rcv) timestamp,
+		 * so check the skb->mono_delivery_time.
+		 */
+		*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
+				      SKB_MONO_DELIVERY_TIME_OFFSET);
+		*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
+					SKB_MONO_DELIVERY_TIME_MASK);
+		*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
+		/* skb->mono_delivery_time is set, read 0 as the (rcv) timestamp. */
+		*insn++ =3D BPF_MOV64_IMM(value_reg, 0);
+		*insn++ =3D BPF_JMP_A(1);
+	}
 #endif
=20
 	*insn++ =3D BPF_LDX_MEM(BPF_DW, value_reg, skb_reg,
@@ -8889,27 +8981,30 @@ static struct bpf_insn *bpf_convert_tstamp_read(c=
onst struct bpf_insn *si,
 	return insn;
 }
=20
-static struct bpf_insn *bpf_convert_tstamp_write(const struct bpf_insn *=
si,
+static struct bpf_insn *bpf_convert_tstamp_write(const struct bpf_prog *=
prog,
+						 const struct bpf_insn *si,
 						 struct bpf_insn *insn)
 {
 	__u8 value_reg =3D si->src_reg;
 	__u8 skb_reg =3D si->dst_reg;
=20
 #ifdef CONFIG_NET_CLS_ACT
-	__u8 tmp_reg =3D BPF_REG_AX;
-
-	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
-	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
-	*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 3);
-	/* Writing __sk_buff->tstamp at ingress as the (rcv) timestamp.
-	 * Clear the skb->mono_delivery_time.
-	 */
-	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
-			      SKB_MONO_DELIVERY_TIME_OFFSET);
-	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
-				~SKB_MONO_DELIVERY_TIME_MASK);
-	*insn++ =3D BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
-			      SKB_MONO_DELIVERY_TIME_OFFSET);
+	if (!prog->delivery_time_access) {
+		__u8 tmp_reg =3D BPF_REG_AX;
+
+		*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET)=
;
+		*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
+		*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 3);
+		/* Writing __sk_buff->tstamp at ingress as the (rcv) timestamp.
+		 * Clear the skb->mono_delivery_time.
+		 */
+		*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
+				      SKB_MONO_DELIVERY_TIME_OFFSET);
+		*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
+					~SKB_MONO_DELIVERY_TIME_MASK);
+		*insn++ =3D BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
+				      SKB_MONO_DELIVERY_TIME_OFFSET);
+	}
 #endif
=20
 	/* skb->tstamp =3D tstamp */
@@ -9226,9 +9321,13 @@ static u32 bpf_convert_ctx_access(enum bpf_access_=
type type,
 		BUILD_BUG_ON(sizeof_field(struct sk_buff, tstamp) !=3D 8);
=20
 		if (type =3D=3D BPF_WRITE)
-			insn =3D bpf_convert_tstamp_write(si, insn);
+			insn =3D bpf_convert_tstamp_write(prog, si, insn);
 		else
-			insn =3D bpf_convert_tstamp_read(si, insn);
+			insn =3D bpf_convert_tstamp_read(prog, si, insn);
+		break;
+
+	case offsetof(struct __sk_buff, delivery_time_type):
+		insn =3D bpf_convert_dtime_type_read(si, insn);
 		break;
=20
 	case offsetof(struct __sk_buff, gso_segs):
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index afe3d0d7f5f2..4eebea830613 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5086,6 +5086,37 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure. On error
  *		*dst* buffer is zeroed out.
+ *
+ * long bpf_skb_set_delivery_time(struct sk_buff *skb, u64 dtime, u32 dt=
ime_type)
+ *	Description
+ *		Set a *dtime* (delivery time) to the __sk_buff->tstamp and also
+ *		change the __sk_buff->delivery_time_type to *dtime_type*.
+ *
+ *		When setting a delivery time (non zero *dtime*) to
+ *		__sk_buff->tstamp, only BPF_SKB_DELIVERY_TIME_MONO *dtime_type*
+ *		is supported.  It is the only delivery_time_type that will be
+ *		kept after bpf_redirect_*().
+ *
+ *		If there is no need to change the __sk_buff->delivery_time_type,
+ *		the delivery time can be directly written to __sk_buff->tstamp
+ *		instead.
+ *
+ *		*dtime* 0 and *dtime_type* BPF_SKB_DELIVERY_TIME_NONE
+ *		can be used to clear any delivery time stored in
+ *		__sk_buff->tstamp.
+ *
+ *		Only IPv4 and IPv6 skb->protocol are supported.
+ *
+ *		This function is most useful when it needs to set a
+ *		mono delivery time to __sk_buff->tstamp and then
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
@@ -5280,6 +5311,7 @@ union bpf_attr {
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
 	FN(copy_from_user_task),	\
+	FN(skb_set_delivery_time),      \
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
@@ -5469,6 +5501,12 @@ union {					\
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
@@ -5509,7 +5547,8 @@ struct __sk_buff {
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

