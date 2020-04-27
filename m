Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31A51BAF07
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgD0UNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:13:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726897AbgD0UNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:13:05 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RKAks8025724
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:13:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7UBamCLWDQhgWDHiQWfeGEoYv7F9Gi7Jgks002Pic1o=;
 b=fuzaWgMKZNMrIpXZ5zScNb84I36EQPoKbcSdb0vffr8HdXGtss+1RpH6qu1R8uyEFTeU
 Txbx3bkD3RS2+kWFnUPc81Wqq7OpnQmPzRiP4NFhFI+VylzyBTWCTKWICaEUR4pavOlN
 XiUTwg7cL4W5VtigBCawaVY7+yLn5IJjqWQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n515t701-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:13:03 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:59 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id A63473700871; Mon, 27 Apr 2020 13:12:57 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 19/19] tools/bpf: selftests: add bpf_iter selftests
Date:   Mon, 27 Apr 2020 13:12:57 -0700
Message-ID: <20200427201257.2996328-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=2 mlxlogscore=999 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test includes three subtests for the previous three verifier changes:
  - new reg state btf_id_or_null
  - access fields in the variable length array of the structure.
  - put a btf_id ptr value in a stack and accessible to
    tracing/iter programs.

The test also tested the workflow of creating and reading data
from an anonymous or file iterator. Further for file based
iterator, it tested that the link update can change the underlying
bpf program.

  $ test_progs -n 2
  #2/1 btf_id_or_null:OK
  #2/2 ipv6_route:OK
  #2/3 netlink:OK
  #2/4 anon:OK
  #2/5 file:OK
  #2 bpf_iter:OK
  Summary: 1/5 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 180 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_test_kern1.c |   4 +
 .../selftests/bpf/progs/bpf_iter_test_kern2.c |   4 +
 .../selftests/bpf/progs/bpf_iter_test_kern3.c |  18 ++
 .../bpf/progs/bpf_iter_test_kern_common.h     |  22 +++
 5 files changed, 228 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern1=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern2=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern3=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern_=
common.h

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_iter.c
new file mode 100644
index 000000000000..d51ed0d99a75
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <test_progs.h>
+#include "bpf_iter_ipv6_route.skel.h"
+#include "bpf_iter_netlink.skel.h"
+#include "bpf_iter_test_kern1.skel.h"
+#include "bpf_iter_test_kern2.skel.h"
+#include "bpf_iter_test_kern3.skel.h"
+
+static int duration;
+
+static void test_btf_id_or_null(void)
+{
+	struct bpf_iter_test_kern3 *skel;
+
+	skel =3D bpf_iter_test_kern3__open_and_load();
+	if (CHECK(skel, "skel_open_and_load",
+		  "skeleton open_and_load unexpectedly succeeded\n")) {
+		bpf_iter_test_kern3__destroy(skel);
+		return;
+	}
+}
+
+static void test_load_ipv6_route(void)
+{
+	struct bpf_iter_ipv6_route *skel;
+
+	skel =3D bpf_iter_ipv6_route__open_and_load();
+	if (CHECK(!skel, "skel_open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	bpf_iter_ipv6_route__destroy(skel);
+}
+
+static void test_load_netlink(void)
+{
+	struct bpf_iter_netlink *skel;
+
+	skel =3D bpf_iter_netlink__open_and_load();
+	if (CHECK(!skel, "skel_open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	bpf_iter_netlink__destroy(skel);
+}
+
+static int do_read_with_fd(int iter_fd, const char *expected)
+{
+	int err =3D -1, len;
+	char buf[16] =3D {};
+
+	while ((len =3D read(iter_fd, buf, sizeof(buf))) > 0) {
+		if (CHECK(len !=3D strlen(expected), "read",
+			  "wrong read len %d\n", len))
+			return -1;
+
+		if (CHECK(err =3D=3D 0, "read", "invalid additional read\n"))
+			return -1;
+
+		err =3D strcmp(buf, expected);
+		if (CHECK(err, "read",
+			  "incorrect read result: buf %s, expected %s\n",
+			  buf, expected))
+			return -1;
+	}
+
+	CHECK(err, "read", "missing read result\n");
+	return err;
+}
+
+static void test_anon_iter(void)
+{
+	struct bpf_iter_test_kern1 *skel;
+	struct bpf_link *link;
+	int iter_fd;
+
+	skel =3D bpf_iter_test_kern1__open_and_load();
+	if (CHECK(!skel, "skel_open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	link =3D bpf_program__attach_iter(skel->progs.dump_tasks, NULL);
+	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+		goto out;
+
+	iter_fd =3D bpf_link__create_iter(link, 0);
+	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
+		goto free_link;
+
+	do_read_with_fd(iter_fd, "abcd");
+	close(iter_fd);
+
+free_link:
+	bpf_link__disconnect(link);
+	bpf_link__destroy(link);
+out:
+	bpf_iter_test_kern1__destroy(skel);
+}
+
+static int do_read(const char *path, const char *expected)
+{
+	int err, iter_fd;
+
+	iter_fd =3D open(path, O_RDONLY);
+	if (CHECK(iter_fd < 0, "open", "open %s failed: %s\n",
+		  path, strerror(errno)))
+		return -1;
+
+	err =3D do_read_with_fd(iter_fd, expected);
+	close(iter_fd);
+	return err;
+}
+
+static void test_file_iter(void)
+{
+	const char *path =3D "/sys/fs/bpf/bpf_iter_test1";
+	struct bpf_iter_test_kern1 *skel1;
+	struct bpf_iter_test_kern2 *skel2;
+	struct bpf_link *link;
+	int err;
+
+	skel1 =3D bpf_iter_test_kern1__open_and_load();
+	if (CHECK(!skel1, "skel_open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	link =3D bpf_program__attach_iter(skel1->progs.dump_tasks, NULL);
+	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+		goto out;
+
+	/* unlink this path if it exists. */
+	unlink(path);
+
+	err =3D bpf_link__pin(link, path);
+	if (CHECK(err, "pin_iter", "pin_iter to %s failed: %s\n", path,
+		  strerror(errno)))
+		goto free_link;
+
+	err =3D do_read(path, "abcd");
+	if (err)
+		goto free_link;
+
+	/* file based iterator seems working fine. Let us a link update
+	 * of the underlying link and `cat` the iterator again, its content
+	 * should change.
+	 */
+	skel2 =3D bpf_iter_test_kern2__open_and_load();
+	if (CHECK(!skel2, "skel_open_and_load",
+		  "skeleton open_and_load failed\n"))
+		goto free_link;
+
+	err =3D bpf_link__update_program(link, skel2->progs.dump_tasks);
+	if (CHECK(err, "update_prog", "update_prog failed\n"))
+		goto destroy_skel2;
+
+	do_read(path, "ABCD");
+
+destroy_skel2:
+	bpf_iter_test_kern2__destroy(skel2);
+free_link:
+	bpf_link__disconnect(link);
+	bpf_link__destroy(link);
+out:
+	bpf_iter_test_kern1__destroy(skel1);
+}
+
+void test_bpf_iter(void)
+{
+	if (test__start_subtest("btf_id_or_null"))
+		test_btf_id_or_null();
+	if (test__start_subtest("ipv6_route"))
+		test_load_ipv6_route();
+	if (test__start_subtest("netlink"))
+		test_load_netlink();
+	if (test__start_subtest("anon"))
+		test_anon_iter();
+	if (test__start_subtest("file"))
+		test_file_iter();
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern1.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_test_kern1.c
new file mode 100644
index 000000000000..c71a7c283108
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern1.c
@@ -0,0 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#define START_CHAR 'a'
+#include "bpf_iter_test_kern_common.h"
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern2.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_test_kern2.c
new file mode 100644
index 000000000000..8bdc8dc07444
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern2.c
@@ -0,0 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#define START_CHAR 'A'
+#include "bpf_iter_test_kern_common.h"
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
new file mode 100644
index 000000000000..a52555ef2826
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+SEC("iter/task")
+int dump_tasks(struct bpf_iter__task *ctx)
+{
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct task_struct *task =3D ctx->task;
+	int tgid;
+
+	tgid =3D task->tgid;
+	bpf_seq_write(seq, &tgid, sizeof(tgid));
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.=
h b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.h
new file mode 100644
index 000000000000..7cd9125a291f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.h
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") =3D "GPL";
+int count =3D 0;
+
+SEC("iter/task")
+int dump_tasks(struct bpf_iter__task *ctx)
+{
+	struct seq_file *seq =3D ctx->meta->seq;
+	char c;
+
+	if (count < 4) {
+		c =3D START_CHAR + count;
+		bpf_seq_write(seq, &c, sizeof(c));
+		count++;
+	}
+
+	return 0;
+}
--=20
2.24.1

