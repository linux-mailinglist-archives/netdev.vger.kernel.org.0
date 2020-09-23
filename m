Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64420275F2C
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgIWRue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:50:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58102 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgIWRue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 13:50:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NHdKi5078131;
        Wed, 23 Sep 2020 17:49:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=3aMQBdXYDmmkEC7YyOk/oFsIJ0s7lzVZ46/gyCWmTGA=;
 b=ESt4PH2enSUovvABbcXIdH5rFG4fJf6rQ4XNQEPqD3a7nRb1Peu0cStmOCaiWby+bsxl
 fyl77nIkNAWNsbiQY30wRXhQ+/wiUXEOnK1BpTDS2BflfdVrzWyHpSSJmS0RdKp+EADB
 MjimxP4ft8ORWOlMTxjl/qDJtF5wu2Nu0oLGmxGSrZWB16ST2do0nW+dczFw5Ex+fT4Q
 87VEUzbQDw/Ik5LY6Ri8G/frbtxMKAwk1P/6izx5HWqdHn1+ZpthN68rGbpBw8ib6tsu
 3NvBadq+pvS93Y2P41sXi1aHF1XTyvZF2pkDqaehaZDU9Kd8KKwUJFAvf9Mnf2DAoMbu Jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33q5rgja2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 17:49:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NHeRAd042991;
        Wed, 23 Sep 2020 17:47:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33nurv0xa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 17:47:23 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08NHlL9V001564;
        Wed, 23 Sep 2020 17:47:21 GMT
Received: from localhost.uk.oracle.com (/10.175.195.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 10:47:21 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        acme@kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v6 bpf-next 6/6] selftests/bpf: add test for bpf_seq_printf_btf helper
Date:   Wed, 23 Sep 2020 18:46:28 +0100
Message-Id: <1600883188-4831-7-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
References: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=2
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=2 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test verifying iterating over tasks and displaying BTF
representation of data succeeds.  Note here that we do not display
the task_struct itself, as it will overflow the PAGE_SIZE limit on seq
data; instead we write task->fs (a struct fs_struct).

Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  | 66 ++++++++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_task_btf.c        | 49 ++++++++++++++++
 2 files changed, 115 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_btf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index fe1a83b9..323c48a 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -7,6 +7,7 @@
 #include "bpf_iter_task.skel.h"
 #include "bpf_iter_task_stack.skel.h"
 #include "bpf_iter_task_file.skel.h"
+#include "bpf_iter_task_btf.skel.h"
 #include "bpf_iter_tcp4.skel.h"
 #include "bpf_iter_tcp6.skel.h"
 #include "bpf_iter_udp4.skel.h"
@@ -167,6 +168,69 @@ static void test_task_file(void)
 	bpf_iter_task_file__destroy(skel);
 }
 
+#define FSBUFSZ		8192
+
+static char fsbuf[FSBUFSZ];
+
+static void do_btf_read(struct bpf_program *prog)
+{
+	int iter_fd = -1, len = 0, bufleft = FSBUFSZ;
+	struct bpf_link *link;
+	char *buf = fsbuf;
+
+	link = bpf_program__attach_iter(prog, NULL);
+	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+		return;
+
+	iter_fd = bpf_iter_create(bpf_link__fd(link));
+	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
+		goto free_link;
+
+	do {
+		len = read(iter_fd, buf, bufleft);
+		if (len > 0) {
+			buf += len;
+			bufleft -= len;
+		}
+	} while (len > 0);
+
+	if (CHECK(len < 0, "read", "read failed: %s\n", strerror(errno)))
+		goto free_link;
+
+	CHECK(strstr(fsbuf, "(struct fs_struct)") == NULL,
+	      "check for btf representation of fs_struct in iter data",
+	      "struct fs_struct not found");
+free_link:
+	if (iter_fd > 0)
+		close(iter_fd);
+	bpf_link__destroy(link);
+}
+
+static void test_task_btf(void)
+{
+	struct bpf_iter_task_btf__bss *bss;
+	struct bpf_iter_task_btf *skel;
+
+	skel = bpf_iter_task_btf__open_and_load();
+	if (CHECK(!skel, "bpf_iter_task_btf__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	bss = skel->bss;
+
+	do_btf_read(skel->progs.dump_task_fs_struct);
+
+	if (CHECK(bss->tasks == 0, "check if iterated over tasks",
+		  "no task iteration, did BPF program run?\n"))
+		goto cleanup;
+
+	CHECK(bss->seq_err != 0, "check for unexpected err",
+	      "bpf_seq_printf_btf returned %ld", bss->seq_err);
+
+cleanup:
+	bpf_iter_task_btf__destroy(skel);
+}
+
 static void test_tcp4(void)
 {
 	struct bpf_iter_tcp4 *skel;
@@ -957,6 +1021,8 @@ void test_bpf_iter(void)
 		test_task_stack();
 	if (test__start_subtest("task_file"))
 		test_task_file();
+	if (test__start_subtest("task_btf"))
+		test_task_btf();
 	if (test__start_subtest("tcp4"))
 		test_tcp4();
 	if (test__start_subtest("tcp6"))
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_btf.c b/tools/testing/selftests/bpf/progs/bpf_iter_task_btf.c
new file mode 100644
index 0000000..88631a8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_btf.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Oracle and/or its affiliates. */
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <errno.h>
+
+char _license[] SEC("license") = "GPL";
+
+long tasks = 0;
+long seq_err = 0;
+
+/* struct task_struct's BTF representation will overflow PAGE_SIZE so cannot
+ * be used here; instead dump a structure associated with each task.
+ */
+SEC("iter/task")
+int dump_task_fs_struct(struct bpf_iter__task *ctx)
+{
+	static const char fs_type[] = "struct fs_struct";
+	struct seq_file *seq = ctx->meta->seq;
+	struct task_struct *task = ctx->task;
+	struct fs_struct *fs = (void *)0;
+	static struct btf_ptr ptr = { };
+	long ret;
+
+	if (task)
+		fs = task->fs;
+
+	ptr.type = fs_type;
+	ptr.ptr = fs;
+
+	if (ctx->meta->seq_num == 0)
+		BPF_SEQ_PRINTF(seq, "Raw BTF fs_struct per task\n");
+
+	ret = bpf_seq_printf_btf(seq, &ptr, sizeof(ptr), 0);
+	switch (ret) {
+	case 0:
+		tasks++;
+		break;
+	case -ERANGE:
+		/* NULL task or task->fs, don't count it as an error. */
+		break;
+	default:
+		seq_err = ret;
+		break;
+	}
+
+	return 0;
+}
-- 
1.8.3.1

