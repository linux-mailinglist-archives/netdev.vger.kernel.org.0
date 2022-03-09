Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244C94D2B51
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbiCIJF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiCIJF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:05:56 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894971480ED
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:04:58 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2296sD2l006534
        for <netdev@vger.kernel.org>; Wed, 9 Mar 2022 01:04:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CJIvRMVKeVThsJZ4VJGvt5A6Gdxs44d8x2IPElkl0I4=;
 b=IqDDEN1fzWDM6yorlCTaSFj0ke7CS1tho4/mgFAuJH1WxnzpD17cNDXJQrWsLdZS/9YV
 wCmXMf8gGXgX/vTHh2huvvYjBA6CgZ21OR7laU8FJ6QeSEOCu02MO5/sY0Yp9PtXaqah
 LP2GeDMyZXk+chW3wtCbbDTKAm0Nkt4Sd5Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3epak3dha4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 01:04:57 -0800
Received: from twshared13345.18.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 01:04:56 -0800
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 60ED51ADC5DB; Wed,  9 Mar 2022 01:04:50 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 1/5] bpf: net: Remove TC_AT_INGRESS_OFFSET and SKB_MONO_DELIVERY_TIME_OFFSET macro
Date:   Wed, 9 Mar 2022 01:04:50 -0800
Message-ID: <20220309090450.3710955-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220309090444.3710464-1-kafai@fb.com>
References: <20220309090444.3710464-1-kafai@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: LU9MB-fGMTfxa748ld3lyRZ3LiqioiXs
X-Proofpoint-GUID: LU9MB-fGMTfxa748ld3lyRZ3LiqioiXs
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

This patch removes the TC_AT_INGRESS_OFFSET and
SKB_MONO_DELIVERY_TIME_OFFSET macros.  Instead, PKT_VLAN_PRESENT_OFFSET
is used because all of them are at the same offset.  Comment is added to
make it clear that changing the position of tc_at_ingress or
mono_delivery_time will require to adjust the defined macros.

The earlier discussion can be found here:
https://lore.kernel.org/bpf/419d994e-ff61-7c11-0ec7-11fefcb0186e@iogearbox.=
net/

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/skbuff.h | 10 +++++-----
 net/core/filter.c      | 14 +++++++-------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2be263184d1e..7b0cb10e70cb 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -960,10 +960,10 @@ struct sk_buff {
 	__u8			csum_complete_sw:1;
 	__u8			csum_level:2;
 	__u8			dst_pending_confirm:1;
-	__u8			mono_delivery_time:1;
+	__u8			mono_delivery_time:1;	/* See SKB_MONO_DELIVERY_TIME_MASK */
 #ifdef CONFIG_NET_CLS_ACT
 	__u8			tc_skip_classify:1;
-	__u8			tc_at_ingress:1;
+	__u8			tc_at_ingress:1;	/* See TC_AT_INGRESS_MASK */
 #endif
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	__u8			ndisc_nodetype:2;
@@ -1062,7 +1062,9 @@ struct sk_buff {
 #endif
 #define PKT_TYPE_OFFSET		offsetof(struct sk_buff, __pkt_type_offset)
=20
-/* if you move pkt_vlan_present around you also must adapt these constants=
 */
+/* if you move pkt_vlan_present, tc_at_ingress, or mono_delivery_time
+ * around, you also must adapt these constants.
+ */
 #ifdef __BIG_ENDIAN_BITFIELD
 #define PKT_VLAN_PRESENT_BIT	7
 #define TC_AT_INGRESS_MASK		(1 << 0)
@@ -1073,8 +1075,6 @@ struct sk_buff {
 #define SKB_MONO_DELIVERY_TIME_MASK	(1 << 5)
 #endif
 #define PKT_VLAN_PRESENT_OFFSET	offsetof(struct sk_buff, __pkt_vlan_presen=
t_offset)
-#define TC_AT_INGRESS_OFFSET offsetof(struct sk_buff, __pkt_vlan_present_o=
ffset)
-#define SKB_MONO_DELIVERY_TIME_OFFSET offsetof(struct sk_buff, __pkt_vlan_=
present_offset)
=20
 #ifdef __KERNEL__
 /*
diff --git a/net/core/filter.c b/net/core/filter.c
index 88767f7da150..738a294a3c82 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8896,7 +8896,7 @@ static struct bpf_insn *bpf_convert_dtime_type_read(c=
onst struct bpf_insn *si,
 	__u8 tmp_reg =3D BPF_REG_AX;
=20
 	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
-			      SKB_MONO_DELIVERY_TIME_OFFSET);
+			      PKT_VLAN_PRESENT_OFFSET);
 	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
 				SKB_MONO_DELIVERY_TIME_MASK);
 	*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
@@ -8912,7 +8912,7 @@ static struct bpf_insn *bpf_convert_dtime_type_read(c=
onst struct bpf_insn *si,
 	*insn++ =3D BPF_JMP_A(IS_ENABLED(CONFIG_NET_CLS_ACT) ? 6 : 1);
=20
 #ifdef CONFIG_NET_CLS_ACT
-	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
+	*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, PKT_VLAN_PRESENT_OFFSET);
 	*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
 	*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
 	/* At ingress, value_reg =3D 0 */
@@ -8959,14 +8959,14 @@ static struct bpf_insn *bpf_convert_tstamp_read(con=
st struct bpf_prog *prog,
 	if (!prog->delivery_time_access) {
 		__u8 tmp_reg =3D BPF_REG_AX;
=20
-		*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
+		*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, PKT_VLAN_PRESENT_OFFSET=
);
 		*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
 		*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 5);
 		/* @ingress, read __sk_buff->tstamp as the (rcv) timestamp,
 		 * so check the skb->mono_delivery_time.
 		 */
 		*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
-				      SKB_MONO_DELIVERY_TIME_OFFSET);
+				      PKT_VLAN_PRESENT_OFFSET);
 		*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
 					SKB_MONO_DELIVERY_TIME_MASK);
 		*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
@@ -8992,18 +8992,18 @@ static struct bpf_insn *bpf_convert_tstamp_write(co=
nst struct bpf_prog *prog,
 	if (!prog->delivery_time_access) {
 		__u8 tmp_reg =3D BPF_REG_AX;
=20
-		*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
+		*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, PKT_VLAN_PRESENT_OFFSET=
);
 		*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
 		*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 3);
 		/* Writing __sk_buff->tstamp at ingress as the (rcv) timestamp.
 		 * Clear the skb->mono_delivery_time.
 		 */
 		*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
-				      SKB_MONO_DELIVERY_TIME_OFFSET);
+				      PKT_VLAN_PRESENT_OFFSET);
 		*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
 					~SKB_MONO_DELIVERY_TIME_MASK);
 		*insn++ =3D BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
-				      SKB_MONO_DELIVERY_TIME_OFFSET);
+				      PKT_VLAN_PRESENT_OFFSET);
 	}
 #endif
=20
--=20
2.30.2

