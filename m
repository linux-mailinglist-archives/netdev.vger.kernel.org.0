Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325D639C7D5
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 13:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhFELNY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Jun 2021 07:13:24 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:43631 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230330AbhFELNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:13:23 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-wYdvKePDPZKEVCDa-jvReg-1; Sat, 05 Jun 2021 07:11:31 -0400
X-MC-Unique: wYdvKePDPZKEVCDa-jvReg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CA50801817;
        Sat,  5 Jun 2021 11:11:30 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DC16614FD;
        Sat,  5 Jun 2021 11:11:27 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH 16/19] selftests/bpf: Add fentry multi func test
Date:   Sat,  5 Jun 2021 13:10:31 +0200
Message-Id: <20210605111034.1810858-17-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-1-jolsa@kernel.org>
References: <20210605111034.1810858-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding selftest for fentry multi func test that attaches
to bpf_fentry_test* functions and checks argument values
based on the processed function.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/multi_check.h     | 52 +++++++++++++++++++
 .../bpf/prog_tests/fentry_multi_test.c        | 43 +++++++++++++++
 .../selftests/bpf/progs/fentry_multi_test.c   | 18 +++++++
 3 files changed, 113 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/multi_check.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/fentry_multi_test.c

diff --git a/tools/testing/selftests/bpf/multi_check.h b/tools/testing/selftests/bpf/multi_check.h
new file mode 100644
index 000000000000..36c2a93f9be3
--- /dev/null
+++ b/tools/testing/selftests/bpf/multi_check.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __MULTI_CHECK_H
+#define __MULTI_CHECK_H
+
+extern unsigned long long bpf_fentry_test[8];
+
+static __attribute__((unused)) inline
+void multi_arg_check(unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, __u64 *test_result)
+{
+	if (ip == bpf_fentry_test[0]) {
+		*test_result += (int) a == 1;
+	} else if (ip == bpf_fentry_test[1]) {
+		*test_result += (int) a == 2 && (__u64) b == 3;
+	} else if (ip == bpf_fentry_test[2]) {
+		*test_result += (char) a == 4 && (int) b == 5 && (__u64) c == 6;
+	} else if (ip == bpf_fentry_test[3]) {
+		*test_result += (void *) a == (void *) 7 && (char) b == 8 && (int) c == 9 && (__u64) d == 10;
+	} else if (ip == bpf_fentry_test[4]) {
+		*test_result += (__u64) a == 11 && (void *) b == (void *) 12 && (short) c == 13 && (int) d == 14 && (__u64) e == 15;
+	} else if (ip == bpf_fentry_test[5]) {
+		*test_result += (__u64) a == 16 && (void *) b == (void *) 17 && (short) c == 18 && (int) d == 19 && (void *) e == (void *) 20 && (__u64) f == 21;
+	} else if (ip == bpf_fentry_test[6]) {
+		*test_result += 1;
+	} else if (ip == bpf_fentry_test[7]) {
+		*test_result += 1;
+	}
+}
+
+static __attribute__((unused)) inline
+void multi_ret_check(unsigned long ip, int ret, __u64 *test_result)
+{
+	if (ip == bpf_fentry_test[0]) {
+		*test_result += ret == 2;
+	} else if (ip == bpf_fentry_test[1]) {
+		*test_result += ret == 5;
+	} else if (ip == bpf_fentry_test[2]) {
+		*test_result += ret == 15;
+	} else if (ip == bpf_fentry_test[3]) {
+		*test_result += ret == 34;
+	} else if (ip == bpf_fentry_test[4]) {
+		*test_result += ret == 65;
+	} else if (ip == bpf_fentry_test[5]) {
+		*test_result += ret == 111;
+	} else if (ip == bpf_fentry_test[6]) {
+		*test_result += ret == 0;
+	} else if (ip == bpf_fentry_test[7]) {
+		*test_result += ret == 0;
+	}
+}
+
+#endif /* __MULTI_CHECK_H */
diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c
new file mode 100644
index 000000000000..e4a8089533d6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "fentry_multi_test.skel.h"
+#include "trace_helpers.h"
+
+void test_fentry_multi_test(void)
+{
+	struct fentry_multi_test *skel = NULL;
+	unsigned long long *bpf_fentry_test;
+	__u32 duration = 0, retval;
+	int err, prog_fd;
+
+	skel = fentry_multi_test__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_multi_skel_load"))
+		goto cleanup;
+
+	bpf_fentry_test = &skel->bss->bpf_fentry_test[0];
+	ASSERT_OK(kallsyms_find("bpf_fentry_test1", &bpf_fentry_test[0]), "kallsyms_find");
+	ASSERT_OK(kallsyms_find("bpf_fentry_test2", &bpf_fentry_test[1]), "kallsyms_find");
+	ASSERT_OK(kallsyms_find("bpf_fentry_test3", &bpf_fentry_test[2]), "kallsyms_find");
+	ASSERT_OK(kallsyms_find("bpf_fentry_test4", &bpf_fentry_test[3]), "kallsyms_find");
+	ASSERT_OK(kallsyms_find("bpf_fentry_test5", &bpf_fentry_test[4]), "kallsyms_find");
+	ASSERT_OK(kallsyms_find("bpf_fentry_test6", &bpf_fentry_test[5]), "kallsyms_find");
+	ASSERT_OK(kallsyms_find("bpf_fentry_test7", &bpf_fentry_test[6]), "kallsyms_find");
+	ASSERT_OK(kallsyms_find("bpf_fentry_test8", &bpf_fentry_test[7]), "kallsyms_find");
+
+	err = fentry_multi_test__attach(skel);
+	if (!ASSERT_OK(err, "fentry_attach"))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(skel->progs.test);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+
+	ASSERT_EQ(skel->bss->test_result, 8, "test_result");
+
+	fentry_multi_test__detach(skel);
+
+cleanup:
+	fentry_multi_test__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/fentry_multi_test.c b/tools/testing/selftests/bpf/progs/fentry_multi_test.c
new file mode 100644
index 000000000000..a443fc958e5a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/fentry_multi_test.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "multi_check.h"
+
+char _license[] SEC("license") = "GPL";
+
+unsigned long long bpf_fentry_test[8];
+
+__u64 test_result = 0;
+
+SEC("fentry.multi/bpf_fentry_test*")
+int BPF_PROG(test, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
+{
+	multi_arg_check(ip, a, b, c, d, e, f, &test_result);
+	return 0;
+}
-- 
2.31.1

