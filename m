Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD341AB1A9
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411885AbgDOT26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:28:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61424 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411869AbgDOT2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:32 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FJSMjo024691
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZuHVPcaW1pLeyf56TL2TTP6NLj4DSjqUkw74KGNT07k=;
 b=OAXCYRAev2h5ETgqEu6ADvV0J0gQRgR4Ko837wfE1GMGnUWHMhcDZ90AEbMN/z/kiYFW
 5hXqRnTTB/6YdBy8l+OREi0DLTXaPupZVYN20ouAnFOTSHAL86KTADS0ZQaXZHRQ+jtU
 g0smYh9rPxZnmSrT0uMr1wbIJ6L/UdhzS6Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7gqkqw-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:31 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:28:02 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 8D13A3700AF5; Wed, 15 Apr 2020 12:28:00 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 17/17] tools/bpf: selftests: add a selftest for anonymous dumper
Date:   Wed, 15 Apr 2020 12:28:00 -0700
Message-ID: <20200415192800.4084266-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 phishscore=0 adultscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The selftest creates a anonymous dumper for the
/sys/kernel/bpfdump/task/ target and ensure the
user space got the expected contents. Both
bpf_seq_printf() and bpf_seq_write() helpers
are tested in this selftest.

  $ test_progs -n 2
  #2 bpfdump_test:OK
  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/prog_tests/bpfdump_test.c   | 42 +++++++++++++++++++
 .../selftests/bpf/progs/bpfdump_test_kern.c   | 31 ++++++++++++++
 2 files changed, 73 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpfdump_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_test_kern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpfdump_test.c b/tool=
s/testing/selftests/bpf/prog_tests/bpfdump_test.c
new file mode 100644
index 000000000000..8978e04c3ca9
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpfdump_test.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "bpfdump_test_kern.skel.h"
+
+void test_bpfdump_test(void)
+{
+	int err, prog_fd, dumper_fd, duration =3D 0;
+	struct bpfdump_test_kern *skel;
+	char buf[16] =3D {};
+	const char *expected =3D "0A1B2C3D";
+
+	skel =3D bpfdump_test_kern__open_and_load();
+	if (CHECK(!skel, "skel_open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	prog_fd =3D bpf_program__fd(skel->progs.dump_tasks);
+	dumper_fd =3D bpf_raw_tracepoint_open(NULL, prog_fd);
+	if (CHECK(dumper_fd < 0, "bpf_raw_tracepoint_open",
+		  "anonymous dumper creation failed\n"))
+		goto destroy_skel;
+
+	err =3D -EINVAL;
+	while (read(dumper_fd, buf, sizeof(buf)) > 0) {
+		if (CHECK(!err, "read", "unexpected extra read\n"))
+			goto close_fd;
+
+		err =3D strcmp(buf, expected) !=3D 0;
+		if (CHECK(err, "read",
+			  "read failed: buf %s, expected %s\n", buf,
+			  expected))
+			goto close_fd;
+	}
+
+	CHECK(err, "read", "real failed: no read, expected %s\n",
+	      expected);
+
+close_fd:
+	close(dumper_fd);
+destroy_skel:
+	bpfdump_test_kern__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/bpfdump_test_kern.c b/tool=
s/testing/selftests/bpf/progs/bpfdump_test_kern.c
new file mode 100644
index 000000000000..f6bd61a75a22
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpfdump_test_kern.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+int count =3D 0;
+
+SEC("dump//sys/kernel/bpfdump/task")
+int dump_tasks(struct bpfdump__task *ctx)
+{
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct task_struct *task =3D ctx->task;
+	static char fmt[] =3D "%d";
+	char c;
+
+	if (task =3D=3D (void *)0)
+		return 0;
+
+	if (count < 4) {
+		bpf_seq_printf(seq, fmt, sizeof(fmt), count);
+		c =3D 'A' + count;
+		bpf_seq_write(seq, &c, sizeof(c));
+		count++;
+	}
+
+	return 0;
+}
--=20
2.24.1

