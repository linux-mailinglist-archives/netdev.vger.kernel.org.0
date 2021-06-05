Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278C039C7DB
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 13:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhFELNk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Jun 2021 07:13:40 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:46608 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230409AbhFELNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:13:32 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-o5osDj1yOdi-kVOAQcEKxQ-1; Sat, 05 Jun 2021 07:11:38 -0400
X-MC-Unique: o5osDj1yOdi-kVOAQcEKxQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 572DD1013720;
        Sat,  5 Jun 2021 11:11:36 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4AE5614FD;
        Sat,  5 Jun 2021 11:11:33 +0000 (UTC)
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
Subject: [PATCH 18/19] selftests/bpf: Add fentry/fexit multi func test
Date:   Sat,  5 Jun 2021 13:10:33 +0200
Message-Id: <20210605111034.1810858-19-jolsa@kernel.org>
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

Adding selftest for fentry/fexit multi func test that attaches
to bpf_fentry_test* functions and checks argument values based
on the processed function.

When multi_arg_check is used from 2 different places I'm getting
compilation fail, which I did not deciphered yet:

  $ CLANG=/opt/clang/bin/clang LLC=/opt/clang/bin/llc make
    CLNG-BPF [test_maps] fentry_fexit_multi_test.o
  progs/fentry_fexit_multi_test.c:18:2: error: too many args to t24: i64 = \
  GlobalAddress<void (i64, i64, i64, i64, i64, i64, i64, i64*)* @multi_arg_check> 0, \
  progs/fentry_fexit_multi_test.c:18:2 @[ progs/fentry_fexit_multi_test.c:16:5 ]
          multi_arg_check(ip, a, b, c, d, e, f, &test1_arg_result);
          ^
  progs/fentry_fexit_multi_test.c:25:2: error: too many args to t32: i64 = \
  GlobalAddress<void (i64, i64, i64, i64, i64, i64, i64, i64*)* @multi_arg_check> 0, \
  progs/fentry_fexit_multi_test.c:25:2 @[ progs/fentry_fexit_multi_test.c:23:5 ]
          multi_arg_check(ip, a, b, c, d, e, f, &test2_arg_result);
          ^
  In file included from progs/fentry_fexit_multi_test.c:5:
  /home/jolsa/linux-qemu/tools/testing/selftests/bpf/multi_check.h:9:6: error: defined with too many args
  void multi_arg_check(unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, __u64 *test_result)
       ^
  /home/jolsa/linux-qemu/tools/testing/selftests/bpf/multi_check.h:9:6: error: defined with too many args
  /home/jolsa/linux-qemu/tools/testing/selftests/bpf/multi_check.h:9:6: error: defined with too many args
  5 errors generated.
  make: *** [Makefile:470: /home/jolsa/linux-qemu/tools/testing/selftests/bpf/fentry_fexit_multi_test.o] Error 1

I can fix that by defining 2 separate multi_arg_check functions
with different names, which I did in follow up temporaary patch.
Not sure I'm hitting some clang/bpf limitation in here?

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/fentry_fexit_multi_test.c  | 52 +++++++++++++++++++
 .../bpf/progs/fentry_fexit_multi_test.c       | 28 ++++++++++
 2 files changed, 80 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_fexit_multi_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_fexit_multi_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_fexit_multi_test.c
new file mode 100644
index 000000000000..76f917ad843d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_fexit_multi_test.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "fentry_fexit_multi_test.skel.h"
+
+void test_fentry_fexit_multi_test(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, link_upd_opts);
+	struct fentry_fexit_multi_test *skel = NULL;
+	unsigned long long *bpf_fentry_test;
+	__u32 duration = 0, retval;
+	struct bpf_link *link;
+	int err, prog_fd;
+
+	skel = fentry_fexit_multi_test__open_and_load();
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
+	link = bpf_program__attach(skel->progs.test1);
+	if (!ASSERT_OK_PTR(link, "attach_fentry_fexit"))
+		goto cleanup;
+
+	err = bpf_link_update(bpf_link__fd(link),
+			      bpf_program__fd(skel->progs.test2),
+			      NULL);
+	if (!ASSERT_OK(err, "bpf_link_update"))
+		goto cleanup_link;
+
+	prog_fd = bpf_program__fd(skel->progs.test1);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+
+	ASSERT_EQ(skel->bss->test1_arg_result, 8, "test1_arg_result");
+	ASSERT_EQ(skel->bss->test2_arg_result, 8, "test2_arg_result");
+	ASSERT_EQ(skel->bss->test2_ret_result, 8, "test2_ret_result");
+
+cleanup_link:
+	bpf_link__destroy(link);
+cleanup:
+	fentry_fexit_multi_test__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c b/tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c
new file mode 100644
index 000000000000..e25ab0085399
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c
@@ -0,0 +1,28 @@
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
+__u64 test1_arg_result = 0;
+__u64 test2_arg_result = 0;
+__u64 test2_ret_result = 0;
+
+SEC("fentry.multi/bpf_fentry_test*")
+int BPF_PROG(test1, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
+{
+	multi_arg_check(ip, a, b, c, d, e, f, &test1_arg_result);
+	return 0;
+}
+
+SEC("fexit.multi/")
+int BPF_PROG(test2, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, int ret)
+{
+	multi_arg_check(ip, a, b, c, d, e, f, &test2_arg_result);
+	multi_ret_check(ip, ret, &test2_ret_result);
+	return 0;
+}
-- 
2.31.1

