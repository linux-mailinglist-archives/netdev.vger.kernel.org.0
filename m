Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E98225E233
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 21:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgIDTti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 15:49:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23872 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727989AbgIDTtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 15:49:36 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 084Jj6GG020084
        for <netdev@vger.kernel.org>; Fri, 4 Sep 2020 12:49:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9JwYIjoC0IbU1GFXnenfpT1paK1+I3w8jYW2p5RWCz8=;
 b=poUOrzpDm8cohb3qt2VHA5HKo4XG/+7fHDJKZ3Xohmz7YgniGJG7XD86Ql+8MIZcAuSY
 THDxGD2BVTlNBllgxYIcA6tYc5ytbzGl9LLf3D9iZKW4NEsRDDW0Ayn1+wCkAgJszXWu
 D5hOgIA6THDI1o0a+NOBpDZs6KrP55QzNYU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 33b2heym9g-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 12:49:35 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Sep 2020 12:49:03 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 241EA370507D; Fri,  4 Sep 2020 12:49:02 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 2/2] selftests/bpf: add test for map_ptr arithmetic
Date:   Fri, 4 Sep 2020 12:49:02 -0700
Message-ID: <20200904194902.3031474-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200904194900.3031319-1-yhs@fb.com>
References: <20200904194900.3031319-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_15:2020-09-04,2020-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 mlxlogscore=971 mlxscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

change selftest map_ptr_kern.c which will fail without previous
verifier change. Also added to verifier test for both
"map_ptr +=3D scalar" and "scalar +=3D map_ptr" arithmetic.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/progs/map_ptr_kern.c        |  4 +--
 .../testing/selftests/bpf/verifier/map_ptr.c  | 32 +++++++++++++++++++
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/tes=
ting/selftests/bpf/progs/map_ptr_kern.c
index 982a2d8aa844..d93413d24128 100644
--- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
+++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
@@ -74,8 +74,8 @@ static inline int check(struct bpf_map *indirect, struc=
t bpf_map *direct,
 	return 1;
 }
=20
-static inline int check_default(struct bpf_map *indirect,
-				struct bpf_map *direct)
+static __attribute__ ((noinline)) int
+check_default(struct bpf_map *indirect, struct bpf_map *direct)
 {
 	VERIFY(check(indirect, direct, sizeof(__u32), sizeof(__u32),
 		     MAX_ENTRIES));
diff --git a/tools/testing/selftests/bpf/verifier/map_ptr.c b/tools/testi=
ng/selftests/bpf/verifier/map_ptr.c
index b52209db8250..637f9293bda8 100644
--- a/tools/testing/selftests/bpf/verifier/map_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/map_ptr.c
@@ -60,3 +60,35 @@
 	.result =3D ACCEPT,
 	.retval =3D 1,
 },
+{
+	"bpf_map_ptr: r =3D 0, map_ptr =3D map_ptr + r",
+	.insns =3D {
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_1, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_16b =3D { 4 },
+	.result =3D ACCEPT,
+},
+{
+	"bpf_map_ptr: r =3D 0, r =3D r + map_ptr",
+	.insns =3D {
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_MOV64_IMM(BPF_REG_1, 0),
+	BPF_LD_MAP_FD(BPF_REG_0, 0),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_1, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_16b =3D { 4 },
+	.result =3D ACCEPT,
+},
--=20
2.24.1

