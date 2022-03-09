Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833514D2B5D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbiCIJGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbiCIJGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:06:07 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDFF1480E6
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:05:08 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 228MG9n1004068
        for <netdev@vger.kernel.org>; Wed, 9 Mar 2022 01:05:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+8XM08CKjgMtJQRJ0qFFcM17xvZjf1jNNZaaoDK3+E8=;
 b=aug3TAYs0kJf6yeVhuE7nxYvjCt5V9E9zy9+v4CYaZgTZD+GG81A8mOHSF4YXvMQEcQg
 XFlknJnzlXTP/sUs96J9zlxPyI41KiIhEgJXpyy+e9gh1nu1BOSVzy0WJoO67KrRRZpp
 YBxyKS3Rkz7pyNZ/DJxDwqwTqiYB34WWSOs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3epfssjtqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 01:05:08 -0800
Received: from twshared21672.25.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 01:05:07 -0800
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id F16561ADC5EC; Wed,  9 Mar 2022 01:05:02 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 3/5] bpf: Simplify insn rewrite on BPF_WRITE __sk_buff->tstamp
Date:   Wed, 9 Mar 2022 01:05:02 -0800
Message-ID: <20220309090502.3711982-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220309090444.3710464-1-kafai@fb.com>
References: <20220309090444.3710464-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: GMAjL29igvKIy4BjI3Pywu5iTXRA_-un
X-Proofpoint-GUID: GMAjL29igvKIy4BjI3Pywu5iTXRA_-un
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-09_04,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_JMP32_IMM(BPF_JSET) is used to save a BPF_ALU32_IMM(BPF_AND).

The skb->tc_at_ingress and skb->mono_delivery_time are at the same
offset, so only one BPF_LDX_MEM(BPF_B) is needed.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/filter.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2c83d1f38704..f914e4b13b18 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8990,25 +8990,27 @@ static struct bpf_insn *bpf_convert_tstamp_write(=
const struct bpf_prog *prog,
 	__u8 skb_reg =3D si->dst_reg;
=20
 #ifdef CONFIG_NET_CLS_ACT
+	/* If the delivery_time_type is read,
+	 * the bpf prog is aware the tstamp could have delivery time.
+	 * Thus, write skb->tstamp as is if delivery_time_access is true.
+	 * Otherwise, writing at ingress will have to clear the
+	 * mono_delivery_time bit also.
+	 */
 	if (!prog->delivery_time_access) {
 		__u8 tmp_reg =3D BPF_REG_AX;
=20
 		*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, PKT_VLAN_PRESENT_OFFS=
ET);
-		*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
-		*insn++ =3D BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 3);
-		/* Writing __sk_buff->tstamp at ingress as the (rcv) timestamp.
-		 * Clear the skb->mono_delivery_time.
-		 */
-		*insn++ =3D BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
-				      PKT_VLAN_PRESENT_OFFSET);
-		*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg,
-					~SKB_MONO_DELIVERY_TIME_MASK);
-		*insn++ =3D BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
-				      PKT_VLAN_PRESENT_OFFSET);
+		/* Writing __sk_buff->tstamp as ingress, goto <clear> */
+		*insn++ =3D BPF_JMP32_IMM(BPF_JSET, tmp_reg, TC_AT_INGRESS_MASK, 1);
+		/* goto <store> */
+		*insn++ =3D BPF_JMP_A(2);
+		/* <clear>: mono_delivery_time */
+		*insn++ =3D BPF_ALU32_IMM(BPF_AND, tmp_reg, ~SKB_MONO_DELIVERY_TIME_MA=
SK);
+		*insn++ =3D BPF_STX_MEM(BPF_B, skb_reg, tmp_reg, PKT_VLAN_PRESENT_OFFS=
ET);
 	}
 #endif
=20
-	/* skb->tstamp =3D tstamp */
+	/* <store>: skb->tstamp =3D tstamp */
 	*insn++ =3D BPF_STX_MEM(BPF_DW, skb_reg, value_reg,
 			      offsetof(struct sk_buff, tstamp));
 	return insn;
--=20
2.30.2

