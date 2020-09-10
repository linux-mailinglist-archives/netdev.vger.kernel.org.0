Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BD42650C8
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgIJU2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:28:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52710 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726683AbgIJU1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:27:35 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AKKbbP022314
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:27:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=LPiMaf8HaswzXltwf9IMpJ/oBrjUHzCrrs7jkW525lk=;
 b=Rg+Ym+5JEkWx34CuQjsh9Rb14hYUlTGM/q0JYNFCFXYgOub0mlatkTj/mzIdBUkgP8ll
 v0fv60T6F5X7Ke0oC/xn/70DaF37GzbjZ/I/IqpmQkhVBtYP1D889kIaFjSJiWpy0Rp2
 ednU9rhcDzJvTu7Gr/GKFx+Ai1n+BVNfats= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33fhxub58u-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:27:34 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Sep 2020 13:27:19 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 060D13705A39; Thu, 10 Sep 2020 13:27:18 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf-next] selftests/bpf: define string const as global for test_sysctl_prog.c
Date:   Thu, 10 Sep 2020 13:27:18 -0700
Message-ID: <20200910202718.956042-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_09:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 suspectscore=8 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009100183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When tweaking llvm optimizations, I found that selftest build failed
with the following error:
  libbpf: elf: skipping unrecognized data section(6) .rodata.str1.1
  libbpf: prog 'sysctl_tcp_mem': bad map relo against '.L__const.is_tcp_m=
em.tcp_mem_name'
          in section '.rodata.str1.1'
  Error: failed to open BPF object file: Relocation failed
  make: *** [/work/net-next/tools/testing/selftests/bpf/test_sysctl_prog.=
skel.h] Error 255
  make: *** Deleting file `/work/net-next/tools/testing/selftests/bpf/tes=
t_sysctl_prog.skel.h'

The local string constant "tcp_mem_name" is put into '.rodata.str1.1' sec=
tion
which libbpf cannot handle. Using untweaked upstream llvm, "tcp_mem_name"
is completely inlined after loop unrolling.

Commit 7fb5eefd7639 ("selftests/bpf: Fix test_sysctl_loop{1, 2}
failure due to clang change") solved a similar problem by defining
the string const as a global. Let us do the same here
for test_sysctl_prog.c so it can weather future potential llvm changes.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/progs/test_sysctl_prog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_prog.c b/tools=
/testing/selftests/bpf/progs/test_sysctl_prog.c
index 50525235380e..5489823c83fc 100644
--- a/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
+++ b/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
@@ -19,11 +19,11 @@
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 #endif
=20
+const char tcp_mem_name[] =3D "net/ipv4/tcp_mem";
 static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
 {
-	char tcp_mem_name[] =3D "net/ipv4/tcp_mem";
 	unsigned char i;
-	char name[64];
+	char name[sizeof(tcp_mem_name)];
 	int ret;
=20
 	memset(name, 0, sizeof(name));
--=20
2.24.1

