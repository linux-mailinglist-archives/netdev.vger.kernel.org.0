Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4881BAF17
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgD0UN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:13:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31444 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726849AbgD0UMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:12:54 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RKAoiN031128
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=KoU+eBOgm84GYKFMCRf8IzLM26AAVlbV1/nM6UxF9MA=;
 b=T+js0XXCiRT48ajG3jDjOCVozwRq5BkoTaI/+kjtzDTS8IIgYD/MmtSltpzXRoYcBGq6
 uaKrtwASr1BxhZlQsMYMN0a/Wl0mwsS5xMwzvUGSeTV39yjoF9ygBbHVq6L4SVQo7mJe
 uxRt53NIbHlLOd6XBkn4Rx7z8iUJnRUofL4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57q246k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:53 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:52 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 4705C3700871; Mon, 27 Apr 2020 13:12:50 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 13/19] bpf: handle spilled PTR_TO_BTF_ID properly when checking stack_boundary
Date:   Mon, 27 Apr 2020 13:12:50 -0700
Message-ID: <20200427201250.2995815-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004270164
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

Let us permit this if the program is a tracing/iter program.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/verifier.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 21ec85e382ca..17a780e59f77 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3474,6 +3474,14 @@ static int check_stack_boundary(struct bpf_verifie=
r_env *env, int regno,
 			*stype =3D STACK_MISC;
 			goto mark;
 		}
+
+		/* pointer value can be visible to tracing/iter program */
+		if (env->prog->type =3D=3D BPF_PROG_TYPE_TRACING &&
+		    env->prog->expected_attach_type =3D=3D BPF_TRACE_ITER &&
+		    state->stack[spi].slot_type[0] =3D=3D STACK_SPILL &&
+		    state->stack[spi].spilled_ptr.type =3D=3D PTR_TO_BTF_ID)
+			goto mark;
+
 		if (state->stack[spi].slot_type[0] =3D=3D STACK_SPILL &&
 		    state->stack[spi].spilled_ptr.type =3D=3D SCALAR_VALUE) {
 			__mark_reg_unknown(env, &state->stack[spi].spilled_ptr);
--=20
2.24.1

