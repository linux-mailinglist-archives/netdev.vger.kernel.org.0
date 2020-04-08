Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C98AE1A2C43
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgDHXZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:25:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40692 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726632AbgDHXZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:25:48 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 038NPkuQ019433
        for <netdev@vger.kernel.org>; Wed, 8 Apr 2020 16:25:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=T5gLjKrXex1+wfvDooG7fzGOcWB825ac5uDuX1d6xpY=;
 b=dFf6D+NB4tBeRoK83m2ya3HNXpkVRgw0j/IcHfY7+HCK68rcm8URAw2wRmjPdz0xiVL0
 nrM7G1+VcjvXsa3bMRS8M8OePUrPpalG+JY26kgSHeaeSK+/TBuBYmSXtbzL7lnsu1pQ
 inMcFomNpmGJYHVkQ2Qk6chC9m70L0tyYEg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3091m37bqa-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 16:25:47 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 8 Apr 2020 16:25:46 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id D002D3700D98; Wed,  8 Apr 2020 16:25:39 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 16/16] tools/bpf: selftests: add a selftest for anonymous dumper
Date:   Wed, 8 Apr 2020 16:25:39 -0700
Message-ID: <20200408232539.2676695-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200408232520.2675265-1-yhs@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-08_09:2020-04-07,2020-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080164
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
 .../selftests/bpf/prog_tests/bpfdump_test.c   | 41 +++++++++++++++++++
 .../selftests/bpf/progs/bpfdump_test_kern.c   | 26 ++++++++++++
 2 files changed, 67 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpfdump_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_test_kern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpfdump_test.c b/tool=
s/testing/selftests/bpf/prog_tests/bpfdump_test.c
new file mode 100644
index 000000000000..a04fae7f1e3d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpfdump_test.c
@@ -0,0 +1,41 @@
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
+	dumper_fd =3D bpf_prog_attach(prog_fd, 0, BPF_TRACE_DUMP, 0);
+	if (CHECK(dumper_fd < 0, "bpf_prog_attach", "attach dumper failed\n"))
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
index 000000000000..4758f5d11d9c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpfdump_test_kern.c
@@ -0,0 +1,26 @@
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
+int BPF_PROG(dump_tasks, struct task_struct *task, struct seq_file *seq,=
 u64 seq_num)
+{
+	static char fmt[] =3D "%d";
+	char c;
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

