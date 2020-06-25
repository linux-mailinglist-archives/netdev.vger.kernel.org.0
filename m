Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688CC20A8D6
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407829AbgFYX0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:26:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10798 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407820AbgFYX0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:26:47 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05PNPEJd001186
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:26:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=3J/l+YMR3k0ECoOCBzx0bWGdEUEGMc9fABAjFynRYsM=;
 b=jAj9iABJH4rMVcJhXWGZaVxBQ2e9fkPVbLFr9PZygQW4Z2qL6YyyaiffsjApO9ikfAG0
 5o21cB5xIEpUOA4mmHIhKmM+iWrZ6vds1j72qCv+/Ho116jdXwOMybogf7bfJhh2+2Yi
 TscQFT7eV1ABBLtue4hbwRfNVitBW0ckLi4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 31ux0ntp76-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:26:45 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 16:26:44 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D3B3B2EC3954; Thu, 25 Jun 2020 16:26:37 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/2] selftests/bpf: test auto-load disabling logic for BPF programs
Date:   Thu, 25 Jun 2020 16:26:29 -0700
Message-ID: <20200625232629.3444003-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200625232629.3444003-1-andriin@fb.com>
References: <20200625232629.3444003-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_19:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 cotscore=-2147483648 spamscore=0 suspectscore=8
 adultscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Validate that BPF object with broken (in multiple ways) BPF program can s=
till
be successfully loaded, if that broken BPF program is disabled.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/autoload.c       | 41 +++++++++++++++++++
 .../selftests/bpf/progs/test_autoload.c       | 40 ++++++++++++++++++
 2 files changed, 81 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/autoload.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_autoload.c

diff --git a/tools/testing/selftests/bpf/prog_tests/autoload.c b/tools/te=
sting/selftests/bpf/prog_tests/autoload.c
new file mode 100644
index 000000000000..3693f7d133eb
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/autoload.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include <test_progs.h>
+#include <time.h>
+#include "test_autoload.skel.h"
+
+void test_autoload(void)
+{
+	int duration =3D 0, err;
+	struct test_autoload* skel;
+
+	skel =3D test_autoload__open_and_load();
+	/* prog3 should be broken */
+	if (CHECK(skel, "skel_open_and_load", "unexpected success\n"))
+		goto cleanup;
+
+	skel =3D test_autoload__open();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		goto cleanup;
+
+	/* don't load prog3 */
+	bpf_program__set_autoload(skel->progs.prog3, false);
+
+	err =3D test_autoload__load(skel);
+	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
+		goto cleanup;
+
+	err =3D test_autoload__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	usleep(1);
+
+	CHECK(!skel->bss->prog1_called, "prog1", "not called\n");
+	CHECK(!skel->bss->prog2_called, "prog2", "not called\n");
+	CHECK(skel->bss->prog3_called, "prog3", "called?!\n");
+
+cleanup:
+	test_autoload__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_autoload.c b/tools/te=
sting/selftests/bpf/progs/test_autoload.c
new file mode 100644
index 000000000000..62c8cdec6d5d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_autoload.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+
+bool prog1_called =3D false;
+bool prog2_called =3D false;
+bool prog3_called =3D false;
+
+SEC("raw_tp/sys_enter")
+int prog1(const void *ctx)
+{
+	prog1_called =3D true;
+	return 0;
+}
+
+SEC("raw_tp/sys_exit")
+int prog2(const void *ctx)
+{
+	prog2_called =3D true;
+	return 0;
+}
+
+struct fake_kernel_struct {
+	int whatever;
+} __attribute__((preserve_access_index));
+
+SEC("fentry/unexisting-kprobe-will-fail-if-loaded")
+int prog3(const void *ctx)
+{
+	struct fake_kernel_struct *fake =3D (void *)ctx;
+	fake->whatever =3D 123;
+	prog3_called =3D true;
+	return 0;
+}
+
+char _license[] SEC("license") =3D "GPL";
--=20
2.24.1

