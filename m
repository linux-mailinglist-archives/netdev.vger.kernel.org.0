Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F631C81A9
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 07:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgEGFjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 01:39:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12284 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726742AbgEGFjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 01:39:37 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0475cvU1027693
        for <netdev@vger.kernel.org>; Wed, 6 May 2020 22:39:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=JvhfnebOWE3d1EgrkH1c/oqGAd+CDSChpbRzngyEGfI=;
 b=o3HJTi2WvHiNCz0Lz0syYMt03Q/LYAXJ9yTlG1eBpJJDB0ifLis2NMQ1iAeHXNH95SpJ
 CuxQfiF4oCb8gQaZxPIGxrEYFxna2eE+98voaTSjVq4IpxDPMfTM/wGEo9Jr/ScWbiAn
 1kBwNcV9XpZcInSM9ThkFC1bsHcQ8UzHITY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30v4f022q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 22:39:36 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 22:39:35 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id BEA113701B99; Wed,  6 May 2020 22:39:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 14/21] bpf: handle spilled PTR_TO_BTF_ID properly when checking stack_boundary
Date:   Wed, 6 May 2020 22:39:31 -0700
Message-ID: <20200507053931.1544470-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200507053915.1542140-1-yhs@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_02:2020-05-05,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005070044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This specifically to handle the case like below:
   // ptr below is a socket ptr identified by PTR_TO_BTF_ID
   u64 param[2] =3D { ptr, val };
   bpf_seq_printf(seq, fmt, sizeof(fmt), param, sizeof(param));

In this case, the 16 bytes stack for "param" contains:
   8 bytes for ptr with spilled PTR_TO_BTF_ID
   8 bytes for val as STACK_MISC

The current verifier will complain the ptr should not be visible
to the helper.
   ...
   16: (7b) *(u64 *)(r10 -64) =3D r2
   18: (7b) *(u64 *)(r10 -56) =3D r1
   19: (bf) r4 =3D r10
   ;
   20: (07) r4 +=3D -64
   ; BPF_SEQ_PRINTF(seq, fmt1, (long)s, s->sk_protocol);
   21: (bf) r1 =3D r6
   22: (18) r2 =3D 0xffffa8d00018605a
   24: (b4) w3 =3D 10
   25: (b4) w5 =3D 16
   26: (85) call bpf_seq_printf#125
    R0=3Dinv(id=3D0) R1_w=3Dptr_seq_file(id=3D0,off=3D0,imm=3D0)
    R2_w=3Dmap_value(id=3D0,off=3D90,ks=3D4,vs=3D144,imm=3D0) R3_w=3Dinv1=
0
    R4_w=3Dfp-64 R5_w=3Dinv16 R6=3Dptr_seq_file(id=3D0,off=3D0,imm=3D0)
    R7=3Dptr_netlink_sock(id=3D0,off=3D0,imm=3D0) R10=3Dfp0 fp-56_w=3Dmmm=
mmmmm
    fp-64_w=3Dptr_
   last_idx 26 first_idx 13
   regs=3D8 stack=3D0 before 25: (b4) w5 =3D 16
   regs=3D8 stack=3D0 before 24: (b4) w3 =3D 10
   invalid indirect read from stack off -64+0 size 16

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 36b2a38a06fe..2a1826c76bb6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3494,6 +3494,11 @@ static int check_stack_boundary(struct bpf_verifie=
r_env *env, int regno,
 			*stype =3D STACK_MISC;
 			goto mark;
 		}
+
+		if (state->stack[spi].slot_type[0] =3D=3D STACK_SPILL &&
+		    state->stack[spi].spilled_ptr.type =3D=3D PTR_TO_BTF_ID)
+			goto mark;
+
 		if (state->stack[spi].slot_type[0] =3D=3D STACK_SPILL &&
 		    state->stack[spi].spilled_ptr.type =3D=3D SCALAR_VALUE) {
 			__mark_reg_unknown(env, &state->stack[spi].spilled_ptr);
--=20
2.24.1

