Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59142495AB5
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 08:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378997AbiAUHbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 02:31:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34690 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1378998AbiAUHa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 02:30:57 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 20L04Rsf005971
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 23:30:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Sg0ix8wtmyhIXwiOi+i3PRlqwkIUNiicrkJlSL/oteI=;
 b=YEa341z0tBsRQ+QttUHztehf7cALFTdflI3zoWwF18bbfPF//jvM1skO4sJ06Dab9hF7
 YAVIbbA3UOQaqC679UOtx+coIOXNpxZ2voXp8ZCzoWoZ1jh2bX+g0Rxt9xbcmNzmnH+/
 rZMH9/7pP2IkAwGgpcZDhHOXSapErHtQifI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3dqhy4hmsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 23:30:56 -0800
Received: from twshared18912.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 20 Jan 2022 23:30:55 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 69F975BDEC4B; Thu, 20 Jan 2022 23:30:51 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [RFC PATCH v3 net-next 4/4] bpf: Add __sk_buff->mono_delivery_time and handle __sk_buff->tstamp based on tc_at_ingress
Date:   Thu, 20 Jan 2022 23:30:51 -0800
Message-ID: <20220121073051.4180328-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121073026.4173996-1-kafai@fb.com>
References: <20220121073026.4173996-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: dEthWMJbrKln4HcFSt_cP1PPK9Q6atp8
X-Proofpoint-GUID: dEthWMJbrKln4HcFSt_cP1PPK9Q6atp8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 spamscore=0 malwarescore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210047
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__sk_buff->mono_delivery_time:
This patch adds __sk_buff->mono_delivery_time to
read and write the mono delivery_time in skb->tstamp.

The bpf rewrite is like:
/* BPF_READ: __u64 a =3D __sk_buff->mono_delivery_time; */
if (skb->mono_delivery_time)
	a =3D skb->tstamp;
else
	a =3D 0;

/* BPF_WRITE: __sk_buff->mono_delivery_time =3D a; */
skb->tstamp =3D a;
skb->mono_delivery_time =3D !!a;

__sk_buff->tstamp:
The bpf rewrite is like:
/* BPF_READ: __u64 a =3D __sk_buff->tstamp; */
if (skb->tc_at_ingress && skb->mono_delivery_time)
	a =3D 0;
else
	a =3D skb->tstamp;

/* BPF_WRITE: __sk_buff->tstamp =3D a; */
skb->tstamp =3D a;
if (skb->tc_at_ingress || !a)
	skb->mono_delivery_time =3D 0;

At egress, reading is the same as before.  All skb->tstamp
is the delivery_time.  Writing will not change the (kernel)
skb->mono_delivery_time also unless 0 is being written.  This
will be the same behavior as before.

(#) At ingress, the current bpf prog can only expect the
(rcv) timestamp.  Thus, both reading and writing are now treated as
operating on the (rcv) timestamp for the existing bpf prog.

During bpf load time, the verifier will learn if the
bpf prog has accessed the new __sk_buff->mono_delivery_time.

When reading at ingress, if the bpf prog does not access the
new __sk_buff->mono_delivery_time, it will be treated as the
existing behavior as mentioned in (#) above.  If the (kernel) skb->tstamp
currently has a delivery_time,  it will temporary be saved first and then
set the skb->tstamp to either the ktime_get_real() or zero.  After
the bpf prog finished running, if the bpf prog did not change
the skb->tstamp,  the saved delivery_time will be restored
back to the skb->tstamp.

When writing __sk_buff->tstamp at ingress, the
skb->mono_delivery_time will be cleared because of
the (#) mentioned above.

If the bpf prog does access the new __sk_buff->mono_delivery_time
at ingress, it indicates that the bpf prog is aware of this new
kernel support:
the (kernel) skb->tstamp can have the delivery_time or the
(rcv) timestamp at ingress.  If the __sk_buff->mono_delivery_time
is available, the __sk_buff->tstamp will not be available and
it will be zero.

The bpf rewrite needs to access the skb's mono_delivery_time
and tc_at_ingress bit.  They are moved up in sk_buff so
that bpf rewrite can be done at a fixed offset.  tc_skip_classify
is moved together with tc_at_ingress.  To get one bit for
mono_delivery_time, csum_not_inet is moved down and this bit
is currently used by sctp.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/filter.h         |  31 +++++++-
 include/linux/skbuff.h         |  20 +++--
 include/uapi/linux/bpf.h       |   1 +
 net/core/filter.c              | 134 ++++++++++++++++++++++++++++++---
 net/sched/act_bpf.c            |   5 +-
 net/sched/cls_bpf.c            |   6 +-
 tools/include/uapi/linux/bpf.h |   1 +
 7 files changed, 171 insertions(+), 27 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 71fa57b88bfc..5cef695d6575 100644
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
+				delivery_time_access:1; /* Accessed __sk_buff->mono_delivery_time */
 	enum bpf_prog_type	type;		/* Type of BPF program */
 	enum bpf_attach_type	expected_attach_type; /* For some prog types */
 	u32			len;		/* Number of filter blocks */
@@ -699,6 +700,34 @@ static inline void bpf_compute_data_pointers(struct =
sk_buff *skb)
 	cb->data_end  =3D skb->data + skb_headlen(skb);
 }
=20
+static __always_inline u32 bpf_prog_run_at_ingress(const struct bpf_prog=
 *prog,
+						   struct sk_buff *skb)
+{
+	ktime_t tstamp, delivery_time =3D 0;
+	int filter_res;
+
+	if (unlikely(skb->mono_delivery_time) && !prog->delivery_time_access) {
+		delivery_time =3D skb->tstamp;
+		skb->mono_delivery_time =3D 0;
+		if (static_branch_unlikely(&netstamp_needed_key))
+			skb->tstamp =3D tstamp =3D ktime_get_real();
+		else
+			skb->tstamp =3D tstamp =3D 0;
+	}
+
+	/* It is safe to push/pull even if skb_shared() */
+	__skb_push(skb, skb->mac_len);
+	bpf_compute_data_pointers(skb);
+	filter_res =3D bpf_prog_run(prog, skb);
+	__skb_pull(skb, skb->mac_len);
+
+	/* __sk_buff->tstamp was not changed, restore the delivery_time */
+	if (unlikely(delivery_time) && skb_tstamp(skb) =3D=3D tstamp)
+		skb_set_delivery_time(skb, delivery_time, true);
+
+	return filter_res;
+}
+
 /* Similar to bpf_compute_data_pointers(), except that save orginal
  * data in cb->data and cb->meta_data for restore.
  */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4677bb6c7279..a14b04b86c13 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -866,22 +866,23 @@ struct sk_buff {
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
@@ -894,7 +895,6 @@ struct sk_buff {
 	__u8			decrypted:1;
 #endif
 	__u8			slow_gro:1;
-	__u8			mono_delivery_time:1;
=20
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
@@ -972,10 +972,16 @@ struct sk_buff {
 /* if you move pkt_vlan_present around you also must adapt these constan=
ts */
 #ifdef __BIG_ENDIAN_BITFIELD
 #define PKT_VLAN_PRESENT_BIT	7
+#define TC_AT_INGRESS_SHIFT	0
+#define SKB_MONO_DELIVERY_TIME_SHIFT 2
 #else
 #define PKT_VLAN_PRESENT_BIT	0
+#define TC_AT_INGRESS_SHIFT	7
+#define SKB_MONO_DELIVERY_TIME_SHIFT 5
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
index b0383d371b9a..83725c891f3c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5437,6 +5437,7 @@ struct __sk_buff {
 	__u32 gso_size;
 	__u32 :32;		/* Padding, future use. */
 	__u64 hwtstamp;
+	__u64 mono_delivery_time;
 };
=20
 struct bpf_tunnel_key {
diff --git a/net/core/filter.c b/net/core/filter.c
index 4fc53d645a01..db17812f0f8c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7832,6 +7832,7 @@ static bool bpf_skb_is_valid_access(int off, int si=
ze, enum bpf_access_type type
 			return false;
 		break;
 	case bpf_ctx_range(struct __sk_buff, tstamp):
+	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
 		if (size !=3D sizeof(__u64))
 			return false;
 		break;
@@ -7872,6 +7873,7 @@ static bool sk_filter_is_valid_access(int off, int =
size,
 	case bpf_ctx_range(struct __sk_buff, tstamp):
 	case bpf_ctx_range(struct __sk_buff, wire_len):
 	case bpf_ctx_range(struct __sk_buff, hwtstamp):
+	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
 		return false;
 	}
=20
@@ -7911,6 +7913,7 @@ static bool cg_skb_is_valid_access(int off, int siz=
e,
 		case bpf_ctx_range_till(struct __sk_buff, cb[0], cb[4]):
 			break;
 		case bpf_ctx_range(struct __sk_buff, tstamp):
+		case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
 			if (!bpf_capable())
 				return false;
 			break;
@@ -7943,6 +7946,7 @@ static bool lwt_is_valid_access(int off, int size,
 	case bpf_ctx_range(struct __sk_buff, tstamp):
 	case bpf_ctx_range(struct __sk_buff, wire_len):
 	case bpf_ctx_range(struct __sk_buff, hwtstamp):
+	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
 		return false;
 	}
=20
@@ -8169,6 +8173,7 @@ static bool tc_cls_act_is_valid_access(int off, int=
 size,
 		case bpf_ctx_range_till(struct __sk_buff, cb[0], cb[4]):
 		case bpf_ctx_range(struct __sk_buff, tstamp):
 		case bpf_ctx_range(struct __sk_buff, queue_mapping):
+		case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
 			break;
 		default:
 			return false;
@@ -8445,6 +8450,7 @@ static bool sk_skb_is_valid_access(int off, int siz=
e,
 	case bpf_ctx_range(struct __sk_buff, tstamp):
 	case bpf_ctx_range(struct __sk_buff, wire_len):
 	case bpf_ctx_range(struct __sk_buff, hwtstamp):
+	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
 		return false;
 	}
=20
@@ -8603,6 +8609,114 @@ static struct bpf_insn *bpf_convert_shinfo_access=
(const struct bpf_insn *si,
 	return insn;
 }
=20
+static struct bpf_insn *bpf_convert_tstamp_read(const struct bpf_insn *s=
i,
+						struct bpf_insn *insn)
+{
+	__u8 value_reg =3D si->dst_reg;
+	__u8 skb_reg =3D si->src_reg;
+	__u8 tmp_reg =3D BPF_REG_AX;
+
+#ifdef CONFIG_NET_CLS_ACT
+	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
+	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, 1 << TC_AT_INGRESS_SHIFT);
+	*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 5);
+	/* @ingress, read __sk_buff->tstamp as the (rcv) timestamp,
+	 * so check the skb->mono_delivery_time.
+	 */
+	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
+			      SKB_MONO_DELIVERY_TIME_OFFSET);
+	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
+				1 << SKB_MONO_DELIVERY_TIME_SHIFT);
+	*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
+	/* skb->mono_delivery_time is set, read 0 as the (rcv) timestamp. */
+	*insn++ =3D BPF_MOV64_IMM(value_reg, 0);
+	*insn++ =3D BPF_JMP_A(1);
+#endif
+
+	*insn++ =3D BPF_LDX_MEM(BPF_DW, value_reg, skb_reg,
+			      offsetof(struct sk_buff, tstamp));
+	return insn;
+}
+
+static struct bpf_insn *bpf_convert_tstamp_write(const struct bpf_insn *=
si,
+						 struct bpf_insn *insn)
+{
+	__u8 value_reg =3D si->src_reg;
+	__u8 skb_reg =3D si->dst_reg;
+	__u8 tmp_reg =3D BPF_REG_AX;
+
+	/* skb->tstamp =3D tstamp */
+	*insn++ =3D BPF_STX_MEM(BPF_DW, skb_reg, value_reg,
+			      offsetof(struct sk_buff, tstamp));
+
+#ifdef CONFIG_NET_CLS_ACT
+	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
+	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, 1 << TC_AT_INGRESS_SHIFT);
+	*insn++ =3D BPF_JMP32_IMM(BPF_JNE, tmp_reg, 0, 1);
+#endif
+
+	/* test tstamp !=3D 0 */
+	*insn++ =3D BPF_JMP_IMM(BPF_JNE, value_reg, 0, 3);
+	/* writing __sk_buff->tstamp at ingress or writing 0,
+	 * clear the skb->mono_delivery_time.
+	 */
+	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
+			      SKB_MONO_DELIVERY_TIME_OFFSET);
+	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
+				~(1 << SKB_MONO_DELIVERY_TIME_SHIFT));
+	*insn++ =3D BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
+			      SKB_MONO_DELIVERY_TIME_OFFSET);
+
+	return insn;
+}
+
+static struct bpf_insn *
+bpf_convert_mono_delivery_time_read(const struct bpf_insn *si,
+				    struct bpf_insn *insn)
+{
+	__u8 value_reg =3D si->dst_reg;
+	__u8 skb_reg =3D si->src_reg;
+	__u8 tmp_reg =3D BPF_REG_AX;
+
+	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
+			      SKB_MONO_DELIVERY_TIME_OFFSET);
+	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
+				1 << SKB_MONO_DELIVERY_TIME_SHIFT);
+	*insn++ =3D BPF_JMP32_IMM(BPF_JNE, tmp_reg, 0, 2);
+	*insn++ =3D BPF_MOV64_IMM(value_reg, 0);
+	*insn++ =3D BPF_JMP_A(1);
+	*insn++ =3D BPF_LDX_MEM(BPF_DW, value_reg, skb_reg,
+			      offsetof(struct sk_buff, tstamp));
+
+	return insn;
+}
+
+static struct bpf_insn *
+bpf_convert_mono_delivery_time_write(const struct bpf_insn *si,
+				     struct bpf_insn *insn)
+{
+	__u8 value_reg =3D si->src_reg;
+	__u8 skb_reg =3D si->dst_reg;
+	__u8 tmp_reg =3D BPF_REG_AX;
+
+	*insn++ =3D BPF_STX_MEM(BPF_DW, skb_reg, value_reg,
+			      offsetof(struct sk_buff, tstamp));
+	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
+			      SKB_MONO_DELIVERY_TIME_OFFSET);
+	*insn++ =3D BPF_JMP_IMM(BPF_JNE, value_reg, 0, 2);
+	/* write zero, clear the skb->mono_delivery_time */
+	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
+				~(1 << SKB_MONO_DELIVERY_TIME_SHIFT));
+	*insn++ =3D BPF_JMP_A(1);
+	/* write non zero, set skb->mono_delivery_time */
+	*insn++ =3D BPF_ALU32_IMM(BPF_OR, tmp_reg,
+				1 << SKB_MONO_DELIVERY_TIME_SHIFT);
+	*insn++ =3D BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
+			      SKB_MONO_DELIVERY_TIME_OFFSET);
+
+	return insn;
+}
+
 static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 				  const struct bpf_insn *si,
 				  struct bpf_insn *insn_buf,
@@ -8911,17 +9025,17 @@ static u32 bpf_convert_ctx_access(enum bpf_access=
_type type,
 		BUILD_BUG_ON(sizeof_field(struct sk_buff, tstamp) !=3D 8);
=20
 		if (type =3D=3D BPF_WRITE)
-			*insn++ =3D BPF_STX_MEM(BPF_DW,
-					      si->dst_reg, si->src_reg,
-					      bpf_target_off(struct sk_buff,
-							     tstamp, 8,
-							     target_size));
+			insn =3D bpf_convert_tstamp_write(si, insn);
 		else
-			*insn++ =3D BPF_LDX_MEM(BPF_DW,
-					      si->dst_reg, si->src_reg,
-					      bpf_target_off(struct sk_buff,
-							     tstamp, 8,
-							     target_size));
+			insn =3D bpf_convert_tstamp_read(si, insn);
+		break;
+
+	case offsetof(struct __sk_buff, mono_delivery_time):
+		if (type =3D=3D BPF_WRITE)
+			insn =3D bpf_convert_mono_delivery_time_write(si, insn);
+		else
+			insn =3D bpf_convert_mono_delivery_time_read(si, insn);
+		prog->delivery_time_access =3D 1;
 		break;
=20
 	case offsetof(struct __sk_buff, gso_segs):
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index a77d8908e737..14c3bd0a5088 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -45,10 +45,7 @@ static int tcf_bpf_act(struct sk_buff *skb, const stru=
ct tc_action *act,
=20
 	filter =3D rcu_dereference(prog->filter);
 	if (at_ingress) {
-		__skb_push(skb, skb->mac_len);
-		bpf_compute_data_pointers(skb);
-		filter_res =3D bpf_prog_run(filter, skb);
-		__skb_pull(skb, skb->mac_len);
+		filter_res =3D bpf_prog_run_at_ingress(filter, skb);
 	} else {
 		bpf_compute_data_pointers(skb);
 		filter_res =3D bpf_prog_run(filter, skb);
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index df19a847829e..036b2e1f74af 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -93,11 +93,7 @@ static int cls_bpf_classify(struct sk_buff *skb, const=
 struct tcf_proto *tp,
 		if (tc_skip_sw(prog->gen_flags)) {
 			filter_res =3D prog->exts_integrated ? TC_ACT_UNSPEC : 0;
 		} else if (at_ingress) {
-			/* It is safe to push/pull even if skb_shared() */
-			__skb_push(skb, skb->mac_len);
-			bpf_compute_data_pointers(skb);
-			filter_res =3D bpf_prog_run(prog->filter, skb);
-			__skb_pull(skb, skb->mac_len);
+			filter_res =3D bpf_prog_run_at_ingress(prog->filter, skb);
 		} else {
 			bpf_compute_data_pointers(skb);
 			filter_res =3D bpf_prog_run(prog->filter, skb);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index b0383d371b9a..83725c891f3c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5437,6 +5437,7 @@ struct __sk_buff {
 	__u32 gso_size;
 	__u32 :32;		/* Padding, future use. */
 	__u64 hwtstamp;
+	__u64 mono_delivery_time;
 };
=20
 struct bpf_tunnel_key {
--=20
2.30.2

