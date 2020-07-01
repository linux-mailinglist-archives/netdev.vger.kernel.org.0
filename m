Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A666C210419
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 08:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgGAGph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 02:45:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23568 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727888AbgGAGpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 02:45:36 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0616eZFf007317
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 23:45:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=2L7S9U/k/EhDNpSC8L+eKX2Oid0O4l2yqewA+6LWDbc=;
 b=XmAjCk3vD538CRw1tmLaCtYg9cfSDNUSS5gd0SgGlOHcP7fZgoHz4E9YhwAE3pW5g1Cp
 mO/aX9oc5Xhi7s5b1k8xrzYoe8maEBO8dcfMjVNCI3h8vi3I2KNOrpfs4ld/6NlzDjmw
 DCfgVkYXWN56oYlI+IVfOSEY3+uwCB2jiOo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 320bcdta0v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 23:45:36 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 23:45:35 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 63FD82EC3A2B; Tue, 30 Jun 2020 23:45:33 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Anton Protopopov <a.s.protopopov@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/3] selftests/bpf: add selftest testin btf_dump's mod-stripping output
Date:   Tue, 30 Jun 2020 23:45:24 -0700
Message-ID: <20200701064527.3158178-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200701064527.3158178-1-andriin@fb.com>
References: <20200701064527.3158178-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_03:2020-07-01,2020-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 mlxlogscore=558
 impostorscore=0 adultscore=0 cotscore=-2147483648 spamscore=0
 suspectscore=9 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftest validating that .strip_mods=3Dtrue works.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/btf_dump.c       |  5 +-
 .../bpf/progs/btf_dump_test_case_strip_mods.c | 50 +++++++++++++++++++
 2 files changed, 54 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_=
strip_mods.c

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/te=
sting/selftests/bpf/prog_tests/btf_dump.c
index cb33a7ee4e04..112b653b9c80 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -21,6 +21,8 @@ static struct btf_dump_test_case {
 	{"btf_dump: bitfields", "btf_dump_test_case_bitfields", {}},
 	{"btf_dump: multidim", "btf_dump_test_case_multidim", {}},
 	{"btf_dump: namespacing", "btf_dump_test_case_namespacing", {}},
+	{"btf_dump: strip mods", "btf_dump_test_case_strip_mods",
+	 { .strip_mods =3D true }},
 };
=20
 static int btf_dump_all_types(const struct btf *btf,
@@ -125,6 +127,7 @@ void test_btf_dump() {
 		if (!test__start_subtest(t->name))
 			continue;
=20
-		test_btf_dump_case(i, &btf_dump_test_cases[i]);
+		t->opts.sz =3D sizeof(t->opts);
+		test_btf_dump_case(i, t);
 	}
 }
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_strip_m=
ods.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_strip_mods.c
new file mode 100644
index 000000000000..1a6ba26d5d75
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_strip_mods.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+/* Copyright (c) 2020 Facebook */
+
+struct s {
+	const int a;
+	volatile int * const b;
+	const volatile struct {
+		int * const volatile c1;
+		const int (* const c2)(volatile int x, const void * const y);
+		const volatile int c3[10];
+	} c;
+	const union {
+		const int * restrict d1;
+		const volatile int * const volatile restrict d2;
+	} d[2];
+	const struct {
+		const volatile int *e1[5];
+	} e;
+	const volatile int * const * volatile * restrict *f;
+	const void * volatile * (*g)(const int x, const void * restrict y);
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct s {
+ *	int a;
+ *	int *b;
+ *	struct {
+ *		int *c1;
+ *		int (*c2)(int, void *);
+ *		int c3[10];
+ *	} c;
+ *	union {
+ *		int *d1;
+ *		int *d2;
+ *	} d[2];
+ *	struct {
+ *		int *e1[5];
+ *	} e;
+ *	int ****f;
+ *	void ** (*g)(int, void *);
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+int f(struct s *s)
+{
+	return 0;
+}
--=20
2.24.1

