Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0E34C835E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbiCAFij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbiCAFie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:38:34 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005394756D
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:37:52 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21SMwSUg007691
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:37:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gqoixQn5XvJ6Rw4nescxiFXcRHQjGvVuIl55oKjfWrI=;
 b=nEL+H5t4wLlS7Nj838yanEEH9oNdXoTmIrXtMfVm94TzJ8vxcb47V9RLcVCFMzNuWUYo
 1hrvd7Ue9Xk0/xEJVzMCGnI9Lmp6DazbDy2PO/OuMiPbsgWuLXkUK5w42kwq5+XuaB1D
 6CAZYpvEaujQV9/t8Uhcg+cx69LU0ww8+uM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3eh2jm471b-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:37:51 -0800
Received: from twshared7500.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 21:37:50 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id A8A657A89649; Mon, 28 Feb 2022 21:37:40 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v5 net-next 11/13] bpf: Keep the (rcv) timestamp behavior for the existing tc-bpf@ingress
Date:   Mon, 28 Feb 2022 21:37:40 -0800
Message-ID: <20220301053740.935214-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301053631.930498-1-kafai@fb.com>
References: <20220301053631.930498-1-kafai@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: yeXLBz-x-SkHfBA0hUrS-6Bz1eDXsnIT
X-Proofpoint-GUID: yeXLBz-x-SkHfBA0hUrS-6Bz1eDXsnIT
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-28_10,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 malwarescore=0 adultscore=0 impostorscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203010026
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current tc-bpf@ingress reads and writes the __sk_buff->tstamp
as a (rcv) timestamp which currently could either be 0 (not available)
or ktime_get_real().  This patch is to backward compatible with the
(rcv) timestamp expectation at ingress.  If the skb->tstamp has
the delivery_time, the bpf insn rewrite will read 0 for tc-bpf
running at ingress as it is not available.  When writing at ingress,
it will also clear the skb->mono_delivery_time bit.

/* BPF_READ: a =3D __sk_buff->tstamp */
if (!skb->tc_at_ingress || !skb->mono_delivery_time)
	a =3D skb->tstamp;
else
	a =3D 0

/* BPF_WRITE: __sk_buff->tstamp =3D a */
if (skb->tc_at_ingress)
	skb->mono_delivery_time =3D 0;
skb->tstamp =3D a;

[ A note on the BPF_CGROUP_INET_INGRESS which can also access
  skb->tstamp.  At that point, the skb is delivered locally
  and skb_clear_delivery_time() has already been done,
  so the skb->tstamp will only have the (rcv) timestamp. ]

If the tc-bpf@egress writes 0 to skb->tstamp, the skb->mono_delivery_time
has to be cleared also.  It could be done together during
convert_ctx_access().  However, the latter patch will also expose
the skb->mono_delivery_time bit as __sk_buff->delivery_time_type.
Changing the delivery_time_type in the background may surprise
the user, e.g. the 2nd read on __sk_buff->delivery_time_type
may need a READ_ONCE() to avoid compiler optimization.  Thus,
in expecting the needs in the latter patch, this patch does a
check on !skb->tstamp after running the tc-bpf and clears the
skb->mono_delivery_time bit if needed.  The earlier discussion
on v4 [0].

The bpf insn rewrite requires the skb's mono_delivery_time bit and
tc_at_ingress bit.  They are moved up in sk_buff so that bpf rewrite
can be done at a fixed offset.  tc_skip_classify is moved together with
tc_at_ingress.  To get one bit for mono_delivery_time, csum_not_inet is
moved down and this bit is currently used by sctp.

[0]: https://lore.kernel.org/bpf/20220217015043.khqwqklx45c4m4se@kafai-mbp.=
dhcp.thefacebook.com/

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/skbuff.h | 18 +++++++----
 net/core/filter.c      | 71 ++++++++++++++++++++++++++++++++++++------
 net/sched/act_bpf.c    |  2 ++
 net/sched/cls_bpf.c    |  2 ++
 4 files changed, 77 insertions(+), 16 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4b5b926a81f2..5445860e1ba6 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -941,8 +941,12 @@ struct sk_buff {
 	__u8			vlan_present:1;	/* See PKT_VLAN_PRESENT_BIT */
 	__u8			csum_complete_sw:1;
 	__u8			csum_level:2;
-	__u8			csum_not_inet:1;
 	__u8			dst_pending_confirm:1;
+	__u8			mono_delivery_time:1;
+#ifdef CONFIG_NET_CLS_ACT
+	__u8			tc_skip_classify:1;
+	__u8			tc_at_ingress:1;
+#endif
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	__u8			ndisc_nodetype:2;
 #endif
@@ -953,10 +957,6 @@ struct sk_buff {
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
@@ -969,7 +969,7 @@ struct sk_buff {
 	__u8			decrypted:1;
 #endif
 	__u8			slow_gro:1;
-	__u8			mono_delivery_time:1;
+	__u8			csum_not_inet:1;
=20
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
@@ -1047,10 +1047,16 @@ struct sk_buff {
 /* if you move pkt_vlan_present around you also must adapt these constants=
 */
 #ifdef __BIG_ENDIAN_BITFIELD
 #define PKT_VLAN_PRESENT_BIT	7
+#define TC_AT_INGRESS_MASK		(1 << 0)
+#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 2)
 #else
 #define PKT_VLAN_PRESENT_BIT	0
+#define TC_AT_INGRESS_MASK		(1 << 7)
+#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 5)
 #endif
 #define PKT_VLAN_PRESENT_OFFSET	offsetof(struct sk_buff, __pkt_vlan_presen=
t_offset)
+#define TC_AT_INGRESS_OFFSET offsetof(struct sk_buff, __pkt_vlan_present_o=
ffset)
+#define SKB_MONO_DELIVERY_TIME_OFFSET offsetof(struct sk_buff, __pkt_vlan_=
present_offset)
=20
 #ifdef __KERNEL__
 /*
diff --git a/net/core/filter.c b/net/core/filter.c
index cfcf9b4d1ec2..5072733743e9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8859,6 +8859,65 @@ static struct bpf_insn *bpf_convert_shinfo_access(co=
nst struct bpf_insn *si,
 	return insn;
 }
=20
+static struct bpf_insn *bpf_convert_tstamp_read(const struct bpf_insn *si,
+						struct bpf_insn *insn)
+{
+	__u8 value_reg =3D si->dst_reg;
+	__u8 skb_reg =3D si->src_reg;
+
+#ifdef CONFIG_NET_CLS_ACT
+	__u8 tmp_reg =3D BPF_REG_AX;
+
+	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
+	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
+	*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 5);
+	/* @ingress, read __sk_buff->tstamp as the (rcv) timestamp,
+	 * so check the skb->mono_delivery_time.
+	 */
+	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
+			      SKB_MONO_DELIVERY_TIME_OFFSET);
+	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
+				SKB_MONO_DELIVERY_TIME_MASK);
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
+static struct bpf_insn *bpf_convert_tstamp_write(const struct bpf_insn *si,
+						 struct bpf_insn *insn)
+{
+	__u8 value_reg =3D si->src_reg;
+	__u8 skb_reg =3D si->dst_reg;
+
+#ifdef CONFIG_NET_CLS_ACT
+	__u8 tmp_reg =3D BPF_REG_AX;
+
+	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
+	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
+	*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 3);
+	/* Writing __sk_buff->tstamp at ingress as the (rcv) timestamp.
+	 * Clear the skb->mono_delivery_time.
+	 */
+	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
+			      SKB_MONO_DELIVERY_TIME_OFFSET);
+	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
+				~SKB_MONO_DELIVERY_TIME_MASK);
+	*insn++ =3D BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
+			      SKB_MONO_DELIVERY_TIME_OFFSET);
+#endif
+
+	/* skb->tstamp =3D tstamp */
+	*insn++ =3D BPF_STX_MEM(BPF_DW, skb_reg, value_reg,
+			      offsetof(struct sk_buff, tstamp));
+	return insn;
+}
+
 static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 				  const struct bpf_insn *si,
 				  struct bpf_insn *insn_buf,
@@ -9167,17 +9226,9 @@ static u32 bpf_convert_ctx_access(enum bpf_access_ty=
pe type,
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
 		break;
=20
 	case offsetof(struct __sk_buff, gso_segs):
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index a77d8908e737..fea2d78b9ddc 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -53,6 +53,8 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct =
tc_action *act,
 		bpf_compute_data_pointers(skb);
 		filter_res =3D bpf_prog_run(filter, skb);
 	}
+	if (unlikely(!skb->tstamp && skb->mono_delivery_time))
+		skb->mono_delivery_time =3D 0;
 	if (skb_sk_is_prefetched(skb) && filter_res !=3D TC_ACT_OK)
 		skb_orphan(skb);
=20
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index df19a847829e..c85b85a192bf 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -102,6 +102,8 @@ static int cls_bpf_classify(struct sk_buff *skb, const =
struct tcf_proto *tp,
 			bpf_compute_data_pointers(skb);
 			filter_res =3D bpf_prog_run(prog->filter, skb);
 		}
+		if (unlikely(!skb->tstamp && skb->mono_delivery_time))
+			skb->mono_delivery_time =3D 0;
=20
 		if (prog->exts_integrated) {
 			res->class   =3D 0;
--=20
2.30.2

