Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5B724AF20
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgHTGOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:14:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36950 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726766AbgHTGOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 02:14:33 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07K6DYlY001964
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 23:14:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=q3Py9zDbr9xpWqiEoF+77aFtI1FDT2lKyza5+vOGYxI=;
 b=Q6zyzUKng+Y5uUQjsyCqMYMxiRtWoQWdKypY+Ks17rvUBxn456fEVtLx6tqC+1WiwETc
 BSbQSfP9sqySDNIlhRpPDBsKuYUChUSXI2R2XXPq/8AlK7BgtP1f7xqLdi4msPolOGRs
 8dy2PX/BFowR+Xg9wC4zXv608NammcGbMFM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 331crb9f73-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 23:14:33 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 23:14:25 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 467FD2EC5ED6; Wed, 19 Aug 2020 23:14:19 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/4] selftests/bpf: list newest Clang built-ins needed for some CO-RE selftests
Date:   Wed, 19 Aug 2020 23:14:11 -0700
Message-ID: <20200820061411.1755905-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820061411.1755905-1-andriin@fb.com>
References: <20200820061411.1755905-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Record which built-ins are optional and needed for some of recent BPF CO-=
RE
subtests. Document Clang diff that fixed corner-case issue with
__builtin_btf_type_id().

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/README.rst        | 21 +++++++++++++++++++
 .../bpf/progs/test_core_reloc_type_id.c       |  4 +++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/README.rst b/tools/testing/selft=
ests/bpf/README.rst
index e885d351595f..66acfcf15ff2 100644
--- a/tools/testing/selftests/bpf/README.rst
+++ b/tools/testing/selftests/bpf/README.rst
@@ -43,3 +43,24 @@ This is due to a llvm BPF backend bug. The fix
   https://reviews.llvm.org/D78466
 has been pushed to llvm 10.x release branch and will be
 available in 10.0.1. The fix is available in llvm 11.0.0 trunk.
+
+BPF CO-RE-based tests and Clang version
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+A set of selftests use BPF target-specific built-ins, which might requir=
e
+bleeding-edge Clang versions (Clang 12 nightly at this time).
+
+Few sub-tests of core_reloc test suit (part of test_progs test runner) r=
equire
+the following built-ins, listed with corresponding Clang diffs introduci=
ng
+them to Clang/LLVM. These sub-tests are going to be skipped if Clang is =
too
+old to support them, they shouldn't cause build failures or runtime test
+failures:
+
+  - __builtin_btf_type_id() ([0], [1], [2]);
+  - __builtin_preserve_type_info(), __builtin_preserve_enum_value() ([3]=
, [4]).
+
+  [0] https://reviews.llvm.org/D74572
+  [1] https://reviews.llvm.org/D74668
+  [2] https://reviews.llvm.org/D85174
+  [3] https://reviews.llvm.org/D83878
+  [4] https://reviews.llvm.org/D83242
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c =
b/tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c
index 23e6e6bf276c..22aba3f6e344 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c
@@ -75,10 +75,12 @@ int test_core_type_id(void *ctx)
 {
 	/* We use __builtin_btf_type_id() in this tests, but up until the time
 	 * __builtin_preserve_type_info() was added it contained a bug that
-	 * would make this test fail. The bug was fixed with addition of
+	 * would make this test fail. The bug was fixed ([0]) with addition of
 	 * __builtin_preserve_type_info(), though, so that's what we are using
 	 * to detect whether this test has to be executed, however strange
 	 * that might look like.
+	 *
+	 *   [0] https://reviews.llvm.org/D85174
 	 */
 #if __has_builtin(__builtin_preserve_type_info)
 	struct core_reloc_type_id_output *out =3D (void *)&data.out;
--=20
2.24.1

