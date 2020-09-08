Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D99C261897
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731778AbgIHR5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:57:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2634 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731807AbgIHR5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:57:12 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088Htd9V016446
        for <netdev@vger.kernel.org>; Tue, 8 Sep 2020 10:57:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9dIqUSAOyW4JTjJ0Sx+D38qoYSVKeVPCJyRl+wMhUAU=;
 b=eXlFAnjeRGKpvARRqEY6uP8OxxfZKAJlyiSh8+wFrQzSDS+Isnnd62gSqicZUFbkUrFb
 VtfMWWMXzrTOIvt7vBUHKkCoA5FRlO2fc2lh60QC29WP5068KcTnWXOv95693c82BJGt
 eUU8Cd+Wz6xOm0Awnt/PiPZevocoxcYUT6U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33ctr6aqy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 10:57:12 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Sep 2020 10:57:11 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id E2C013704E21; Tue,  8 Sep 2020 10:57:03 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf-next v3 2/2] selftests/bpf: add test for map_ptr arithmetic
Date:   Tue, 8 Sep 2020 10:57:03 -0700
Message-ID: <20200908175703.2463721-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200908175702.2463416-1-yhs@fb.com>
References: <20200908175702.2463416-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_09:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=957 phishscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 adultscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009080170
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change selftest map_ptr_kern.c with disabling inlining for
one of subtests, which will fail the test without previous
verifier change. Also added to verifier test for both
"map_ptr +=3D scalar" and "scalar +=3D map_ptr" arithmetic.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/progs/map_ptr_kern.c        | 10 +++++-
 .../testing/selftests/bpf/verifier/map_ptr.c  | 32 +++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/tes=
ting/selftests/bpf/progs/map_ptr_kern.c
index 982a2d8aa844..0b754106407d 100644
--- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
+++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
@@ -82,6 +82,14 @@ static inline int check_default(struct bpf_map *indire=
ct,
 	return 1;
 }
=20
+static __attribute__ ((noinline)) int
+check_default_noinline(struct bpf_map *indirect, struct bpf_map *direct)
+{
+	VERIFY(check(indirect, direct, sizeof(__u32), sizeof(__u32),
+		     MAX_ENTRIES));
+	return 1;
+}
+
 typedef struct {
 	int counter;
 } atomic_t;
@@ -107,7 +115,7 @@ static inline int check_hash(void)
 	struct bpf_map *map =3D (struct bpf_map *)&m_hash;
 	int i;
=20
-	VERIFY(check_default(&hash->map, map));
+	VERIFY(check_default_noinline(&hash->map, map));
=20
 	VERIFY(hash->n_buckets =3D=3D MAX_ENTRIES);
 	VERIFY(hash->elem_size =3D=3D 64);
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

