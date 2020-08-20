Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036B624C84D
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgHTXNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:13:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31402 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728671AbgHTXNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:13:40 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KNDcpH011051
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:13:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=bI9TgMVX03zYqrLXfwdmE/a8ijCVXKZsfy9+ej8nW3o=;
 b=d1ZaHure6/V+c84xQrBGt0ooZMdpeC+Rf5bnvfB8Uun4upIpF1Jsf79Y3zwqVURosbTB
 hSA2Cw9yqu/fN+5My95Yve7DRFL3eBXA1YS+i9h9ekIxcW+U9PLmniYLclAypJ4nC+2Y
 Lffyi/aiHNE+jWFgwf/JtnhOeUAjECWVJ74= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 331crbebdx-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:13:39 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 16:13:22 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6C44F2EC5F42; Thu, 20 Aug 2020 16:13:18 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 12/16] selftests/bpf: add selftest for multi-prog sections and bpf-to-bpf calls
Date:   Thu, 20 Aug 2020 16:12:46 -0700
Message-ID: <20200820231250.1293069-13-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820231250.1293069-1-andriin@fb.com>
References: <20200820231250.1293069-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_07:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200190
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a selftest excercising bpf-to-bpf subprogram calls, as well as multip=
le
entry-point BPF programs per section. Also make sure that BPF CO-RE works=
 for
such set ups both for sub-programs and for multi-entry sections.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/subprogs.c       | 31 +++++++
 .../selftests/bpf/progs/test_subprogs.c       | 92 +++++++++++++++++++
 2 files changed, 123 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/subprogs.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_subprogs.c

diff --git a/tools/testing/selftests/bpf/prog_tests/subprogs.c b/tools/te=
sting/selftests/bpf/prog_tests/subprogs.c
new file mode 100644
index 000000000000..a00abf58c037
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/subprogs.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <test_progs.h>
+#include <time.h>
+#include "test_subprogs.skel.h"
+
+static int duration;
+
+void test_subprogs(void)
+{
+	struct test_subprogs *skel;
+	int err;
+
+	skel =3D test_subprogs__open_and_load();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+
+	err =3D test_subprogs__attach(skel);
+	if (CHECK(err, "skel_attach", "failed to attach skeleton: %d\n", err))
+		goto cleanup;
+
+	usleep(1);
+
+	CHECK(skel->bss->res1 !=3D 12, "res1", "got %d, exp %d\n", skel->bss->r=
es1, 12);
+	CHECK(skel->bss->res2 !=3D 17, "res2", "got %d, exp %d\n", skel->bss->r=
es2, 17);
+	CHECK(skel->bss->res3 !=3D 19, "res3", "got %d, exp %d\n", skel->bss->r=
es3, 19);
+	CHECK(skel->bss->res4 !=3D 36, "res4", "got %d, exp %d\n", skel->bss->r=
es4, 36);
+
+cleanup:
+	test_subprogs__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_subprogs.c b/tools/te=
sting/selftests/bpf/progs/test_subprogs.c
new file mode 100644
index 000000000000..5954a104ac3b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_subprogs.c
@@ -0,0 +1,92 @@
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+const char LICENSE[] SEC("license") =3D "GPL";
+
+__noinline int sub1(int x)
+{
+	return x + 1;
+}
+
+__noinline int sub2(int y)
+{
+	return y + 2;
+}
+
+static __noinline int sub3(int z)
+{
+	return z + 3 + sub1(4);
+}
+
+static __noinline int sub4(int w)
+{
+	return w + sub3(5) + sub1(6);
+}
+
+/* unfortunately verifier rejects `struct task_struct *t` as an unkown p=
ointer
+ * type, so we need to accept pointer as integer and then cast it inside=
 the
+ * function
+ */
+__noinline int get_task_tgid(uintptr_t t)
+{
+	/* this ensures that CO-RE relocs work in multi-subprogs .text */
+	return BPF_CORE_READ((struct task_struct *)(void *)t, tgid);
+}
+
+int res1 =3D 0;
+int res2 =3D 0;
+int res3 =3D 0;
+
+SEC("raw_tp/sys_enter")
+int prog1(void *ctx)
+{
+	/* perform some CO-RE relocations to ensure they work with multi-prog
+	 * sections correctly
+	 */
+	struct task_struct *t =3D (void *)bpf_get_current_task();
+
+	if (!BPF_CORE_READ(t, pid) || !get_task_tgid((uintptr_t)t))
+		return 1;
+
+	res1 =3D sub1(1) + sub3(2); /* (1 + 1) + (2 + 3 + (4 + 1)) =3D 12 */
+	return 0;
+}
+
+SEC("raw_tp/sys_exit")
+int prog2(void *ctx)
+{
+	struct task_struct *t =3D (void *)bpf_get_current_task();
+
+	if (!BPF_CORE_READ(t, pid) || !get_task_tgid((uintptr_t)t))
+		return 1;
+
+	res2 =3D sub2(3) + sub3(4); /* (3 + 2) + (4 + 3 + (4 + 1)) =3D 17 */
+	return 0;
+}
+
+/* prog3 has the same section name as prog1 */
+SEC("raw_tp/sys_enter")
+int prog3(void *ctx)
+{
+	struct task_struct *t =3D (void *)bpf_get_current_task();
+
+	if (!BPF_CORE_READ(t, pid) || !get_task_tgid((uintptr_t)t))
+		return 1;
+
+	res3 =3D sub3(5) + 6; /* (5 + 3 + (4 + 1)) + 6 =3D 19 */
+	return 0;
+}
+
+/* prog4 has the same section name as prog2 */
+SEC("raw_tp/sys_exit")
+int prog4(void *ctx)
+{
+	struct task_struct *t =3D (void *)bpf_get_current_task();
+
+	if (!BPF_CORE_READ(t, pid) || !get_task_tgid((uintptr_t)t))
+		return 1;
+
+	res2 =3D sub4(7) + sub1(8); /* (7 + (5 + 3 + (4 + 1)) + (6 + 1)) + (8 +=
 1) =3D 36 */
+	return 0;
+}
--=20
2.24.1

