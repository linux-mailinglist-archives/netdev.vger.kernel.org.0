Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFE4217CCF
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 03:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgGHBxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 21:53:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43940 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728184AbgGHBxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 21:53:39 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0681nxAt003479
        for <netdev@vger.kernel.org>; Tue, 7 Jul 2020 18:53:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=M8qte6aUYHvlqu1pqz09htIAbuhJ0OGOKTLO38N0+yU=;
 b=RLr9+gu4RCespPiUPh4+ZjG6nUbMbiIaKaJmfAc/8wiUDGGJZPjbPE9Q47y+PVBoSiYN
 UuAmaM4RGlrbhjie5IsXF4VebHes9YyljyucEu50P5WmWmZHf851OhI+sHoHH/OH5TCO
 M9yAd6D0o97JqncqtJaz8VMrZ8JBp6C066A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 322q9vqmej-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 18:53:37 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 7 Jul 2020 18:53:32 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 394D62EC39F5; Tue,  7 Jul 2020 18:53:29 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Matthew Lim <matthewlim@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/6] selftests/bpf: add test relying only on CO-RE and no recent kernel features
Date:   Tue, 7 Jul 2020 18:53:16 -0700
Message-ID: <20200708015318.3827358-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200708015318.3827358-1-andriin@fb.com>
References: <20200708015318.3827358-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_15:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 clxscore=1015 cotscore=-2147483648
 suspectscore=8 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test that relies on CO-RE, but doesn't expect any of the recent
features, not available on old kernels. This is useful for Travis CI test=
s
running against very old kernels (e.g., libbpf has 4.9 kernel testing now=
), to
verify that CO-RE still works, even if kernel itself doesn't support BTF =
yet,
as long as there is .BTF embedded into vmlinux image by pahole. Given mos=
t of
CO-RE doesn't require any kernel awareness of BTF, it is a useful test to
validate that libbpf's BTF sanitization is working well even with ancient
kernels.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_retro.c     | 33 +++++++++++++++++++
 .../selftests/bpf/progs/test_core_retro.c     | 30 +++++++++++++++++
 2 files changed, 63 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_retro.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_retro.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_retro.c b/tools/=
testing/selftests/bpf/prog_tests/core_retro.c
new file mode 100644
index 000000000000..78e30d3a23d5
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/core_retro.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include "test_core_retro.skel.h"
+
+void test_core_retro(void)
+{
+	int err, zero =3D 0, res, duration =3D 0;
+	struct test_core_retro *skel;
+
+	/* load program */
+	skel =3D test_core_retro__open_and_load();
+	if (CHECK(!skel, "skel_load", "skeleton open/load failed\n"))
+		goto out_close;
+
+	/* attach probe */
+	err =3D test_core_retro__attach(skel);
+	if (CHECK(err, "attach_kprobe", "err %d\n", err))
+		goto out_close;
+
+	/* trigger */
+	usleep(1);
+
+	err =3D bpf_map_lookup_elem(bpf_map__fd(skel->maps.results), &zero, &re=
s);
+	if (CHECK(err, "map_lookup", "failed to lookup result: %d\n", errno))
+		goto out_close;
+
+	CHECK(res !=3D getpid(), "pid_check", "got %d !=3D exp %d\n", res, getp=
id());
+
+out_close:
+	test_core_retro__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_core_retro.c b/tools/=
testing/selftests/bpf/progs/test_core_retro.c
new file mode 100644
index 000000000000..75c60c3c29cf
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_retro.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+struct task_struct {
+	int tgid;
+} __attribute__((preserve_access_index));
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, int);
+	__type(value, int);
+} results SEC(".maps");
+
+SEC("tp/raw_syscalls/sys_enter")
+int handle_sys_enter(void *ctx)
+{
+	struct task_struct *task =3D (void *)bpf_get_current_task();
+	int tgid =3D BPF_CORE_READ(task, tgid);
+	int zero =3D 0;
+
+	bpf_map_update_elem(&results, &zero, &tgid, 0);
+
+	return 0;
+}
+
+char _license[] SEC("license") =3D "GPL";
--=20
2.24.1

