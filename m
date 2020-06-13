Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440F01F7FE4
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 02:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgFMAVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 20:21:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7056 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726380AbgFMAVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 20:21:34 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05D0FNv9004882
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 17:21:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=bNHpk1GtTCiK/ebk5O1Sie58LH5F6NwNe8m8BNBsluQ=;
 b=lbLRriL3O5Ne/mlqQ1tk85bDow2otvEag5UlVKV+vEaNv8oIjo01zzaHyOkSIirObw7S
 8WPJDzkI9z0H0SOfOIeCihSNKOERZ9VuUmgCD/T5TIiJVHDQPcSDaaWXcU/mV8SQUhsv
 Nyn6FeBNoXgl8X6t6qnd6eVDh7i7KwUZn7Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31je2vtw28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 17:21:33 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 12 Jun 2020 17:21:30 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C675D2EC2B55; Fri, 12 Jun 2020 17:21:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: undo internal BPF_PROBE_MEM in BPF insns dump
Date:   Fri, 12 Jun 2020 17:21:15 -0700
Message-ID: <20200613002115.1632142-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-12_17:2020-06-12,2020-06-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=8 mlxscore=0 adultscore=0
 cotscore=-2147483648 phishscore=0 malwarescore=0 mlxlogscore=707
 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006130000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_PROBE_MEM is kernel-internal implmementation details. When dumping BP=
F
instructions to user-space, it needs to be replaced back with BPF_MEM mod=
e.

Fixes: 2a02759ef5f8 ("bpf: Add support for BTF pointers to interpreter")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/syscall.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4d530b1d5683..e9a3ebc00e08 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3158,6 +3158,7 @@ static struct bpf_insn *bpf_insn_prepare_dump(const=
 struct bpf_prog *prog)
 	struct bpf_insn *insns;
 	u32 off, type;
 	u64 imm;
+	u8 code;
 	int i;
=20
 	insns =3D kmemdup(prog->insnsi, bpf_prog_insn_size(prog),
@@ -3166,21 +3167,27 @@ static struct bpf_insn *bpf_insn_prepare_dump(con=
st struct bpf_prog *prog)
 		return insns;
=20
 	for (i =3D 0; i < prog->len; i++) {
-		if (insns[i].code =3D=3D (BPF_JMP | BPF_TAIL_CALL)) {
+		code =3D insns[i].code;
+
+		if (code =3D=3D (BPF_JMP | BPF_TAIL_CALL)) {
 			insns[i].code =3D BPF_JMP | BPF_CALL;
 			insns[i].imm =3D BPF_FUNC_tail_call;
 			/* fall-through */
 		}
-		if (insns[i].code =3D=3D (BPF_JMP | BPF_CALL) ||
-		    insns[i].code =3D=3D (BPF_JMP | BPF_CALL_ARGS)) {
-			if (insns[i].code =3D=3D (BPF_JMP | BPF_CALL_ARGS))
+		if (code =3D=3D (BPF_JMP | BPF_CALL) ||
+		    code =3D=3D (BPF_JMP | BPF_CALL_ARGS)) {
+			if (code =3D=3D (BPF_JMP | BPF_CALL_ARGS))
 				insns[i].code =3D BPF_JMP | BPF_CALL;
 			if (!bpf_dump_raw_ok())
 				insns[i].imm =3D 0;
 			continue;
 		}
+		if (BPF_CLASS(code) =3D=3D BPF_LDX && BPF_MODE(code) =3D=3D BPF_PROBE_=
MEM) {
+			insns[i].code =3D BPF_LDX | BPF_SIZE(code) | BPF_MEM;
+			continue;
+		}
=20
-		if (insns[i].code !=3D (BPF_LD | BPF_IMM | BPF_DW))
+		if (code !=3D (BPF_LD | BPF_IMM | BPF_DW))
 			continue;
=20
 		imm =3D ((u64)insns[i + 1].imm << 32) | (u32)insns[i].imm;
--=20
2.24.1

