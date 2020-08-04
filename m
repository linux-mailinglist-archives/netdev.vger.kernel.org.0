Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CC423BF4C
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 20:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbgHDSYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 14:24:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16784 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726802AbgHDSYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 14:24:35 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 074IB5Vl018860
        for <netdev@vger.kernel.org>; Tue, 4 Aug 2020 11:24:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=glr8HfDU15ZFVtJ9eL26x2xAx6rBCH4bvcLUxzLrhRo=;
 b=Xw6FocLrqi+VfzR1xJfkzo2n8VwjP7YaEX+tzzbRqC5Saf2ebT+C9CgRqGU8QAeEqbUl
 QumPJhJ0GfMBVVb1OWkZyK65uylgKkzH6fmRXlCmacBimDi7zEpwcxVoE2M71TlDJfjd
 4+cuq8+JT2ZmdXeerFo2Ppvx3sJdakGHL24= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32nr3c3kxw-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 11:24:34 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 4 Aug 2020 11:24:26 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 79C722EC52E0; Tue,  4 Aug 2020 11:24:24 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 4/9] selftests/bpf: add test validating failure on ambiguous relocation value
Date:   Tue, 4 Aug 2020 11:24:04 -0700
Message-ID: <20200804182409.1512434-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200804182409.1512434-1-andriin@fb.com>
References: <20200804182409.1512434-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-04_04:2020-08-03,2020-08-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=8 phishscore=0 bulkscore=0 mlxlogscore=510
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008040132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test simulating ambiguous field size relocation, while fields themsel=
ves
are at the exact same offset.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     |  1 +
 .../btf__core_reloc_size___err_ambiguous.c    |  4 +++
 .../selftests/bpf/progs/core_reloc_types.h    | 25 +++++++++++++++++++
 3 files changed, 30 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_siz=
e___err_ambiguous.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/=
testing/selftests/bpf/prog_tests/core_reloc.c
index 084ed26a7d78..7d8f3645c330 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -452,6 +452,7 @@ static struct core_reloc_test_case test_cases[] =3D {
 	/* size relocation checks */
 	SIZE_CASE(size),
 	SIZE_CASE(size___diff_sz),
+	SIZE_ERR_CASE(size___err_ambiguous),
 };
=20
 struct data {
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_size___err=
_ambiguous.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_size___e=
rr_ambiguous.c
new file mode 100644
index 000000000000..f3e9904df9c2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_size___err_ambigu=
ous.c
@@ -0,0 +1,4 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_size___err_ambiguous1 x,
+       struct core_reloc_size___err_ambiguous2 y) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools=
/testing/selftests/bpf/progs/core_reloc_types.h
index 34d84717c946..29fa901b72d8 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -804,3 +804,28 @@ struct core_reloc_size___diff_sz {
 	void *ptr_field;
 	enum { OTHER_VALUE =3D 0xFFFFFFFFFFFFFFFF } enum_field;
 };
+
+/* Error case of two candidates with the fields (int_field) at the same
+ * offset, but with differing final relocation values: size 4 vs size 1
+ */
+struct core_reloc_size___err_ambiguous1 {
+	/* int at offset 0 */
+	int int_field;
+
+	struct { int x; } struct_field;
+	union { int x; } union_field;
+	int arr_field[4];
+	void *ptr_field;
+	enum { VALUE___1 =3D 123 } enum_field;
+};
+
+struct core_reloc_size___err_ambiguous2 {
+	/* char at offset 0 */
+	char int_field;
+
+	struct { int x; } struct_field;
+	union { int x; } union_field;
+	int arr_field[4];
+	void *ptr_field;
+	enum { VALUE___2 =3D 123 } enum_field;
+};
--=20
2.24.1

