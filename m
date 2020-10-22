Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780CF295A27
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895471AbgJVIW5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 04:22:57 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:52621 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895438AbgJVIWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:22:55 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-CuehPYyMNMiBU6pwuZxr1g-1; Thu, 22 Oct 2020 04:22:50 -0400
X-MC-Unique: CuehPYyMNMiBU6pwuZxr1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 812C28049E7;
        Thu, 22 Oct 2020 08:22:48 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 357E760BFA;
        Thu, 22 Oct 2020 08:22:45 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: [RFC bpf-next 15/16] selftests/bpf: Add trampoline batch test
Date:   Thu, 22 Oct 2020 10:21:37 +0200
Message-Id: <20201022082138.2322434-16-jolsa@kernel.org>
In-Reply-To: <20201022082138.2322434-1-jolsa@kernel.org>
References: <20201022082138.2322434-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding simple test that loads fentry tracing programs to
bpf_fentry_test* functions and uses trampoline_attach_batch
bool in struct bpf_object_open_opts to attach them in batch
mode.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/trampoline_batch.c         | 45 +++++++++++
 .../bpf/progs/trampoline_batch_test.c         | 75 +++++++++++++++++++
 2 files changed, 120 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trampoline_batch.c
 create mode 100644 tools/testing/selftests/bpf/progs/trampoline_batch_test.c

diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_batch.c b/tools/testing/selftests/bpf/prog_tests/trampoline_batch.c
new file mode 100644
index 000000000000..98929ac0bef6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trampoline_batch.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+#include <test_progs.h>
+#include "trampoline_batch_test.skel.h"
+
+void test_trampoline_batch(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts);
+	struct trampoline_batch_test *skel = NULL;
+	int err, prog_fd, i;
+	__u32 duration = 0, retval;
+	__u64 *result;
+
+	opts.trampoline_attach_batch = true;
+
+	skel = trampoline_batch_test__open_opts(&opts);
+	if (CHECK(!skel, "skel_open", "open failed\n"))
+		goto cleanup;
+
+	err = trampoline_batch_test__load(skel);
+	if (CHECK(err, "skel_load", "load failed: %d\n", err))
+		goto cleanup;
+
+	err = trampoline_batch_test__attach(skel);
+	if (CHECK(err, "skel_attach", "attach failed: %d\n", err))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(skel->progs.test1);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	CHECK(err || retval, "test_run",
+	      "err %d errno %d retval %d duration %d\n",
+	      err, errno, retval, duration);
+
+	result = (__u64 *)skel->bss;
+	for (i = 0; i < 6; i++) {
+		if (CHECK(result[i] != 1, "result",
+			  "trampoline_batch_test fentry_test%d failed err %lld\n",
+			  i + 1, result[i]))
+			goto cleanup;
+	}
+
+cleanup:
+	trampoline_batch_test__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/trampoline_batch_test.c b/tools/testing/selftests/bpf/progs/trampoline_batch_test.c
new file mode 100644
index 000000000000..ff93799037f0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/trampoline_batch_test.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+__u64 test1_result = 0;
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(test1, int a)
+{
+	test1_result = 1;
+	return 0;
+}
+
+__u64 test2_result = 0;
+SEC("fentry/bpf_fentry_test2")
+int BPF_PROG(test2, int a, __u64 b)
+{
+	test2_result = 1;
+	return 0;
+}
+
+__u64 test3_result = 0;
+SEC("fentry/bpf_fentry_test3")
+int BPF_PROG(test3, char a, int b, __u64 c)
+{
+	test3_result = 1;
+	return 0;
+}
+
+__u64 test4_result = 0;
+SEC("fentry/bpf_fentry_test4")
+int BPF_PROG(test4, void *a, char b, int c, __u64 d)
+{
+	test4_result = 1;
+	return 0;
+}
+
+__u64 test5_result = 0;
+SEC("fentry/bpf_fentry_test5")
+int BPF_PROG(test5, __u64 a, void *b, short c, int d, __u64 e)
+{
+	test5_result = 1;
+	return 0;
+}
+
+__u64 test6_result = 0;
+SEC("fentry/bpf_fentry_test6")
+int BPF_PROG(test6, __u64 a, void *b, short c, int d, void * e, __u64 f)
+{
+	test6_result = 1;
+	return 0;
+}
+
+struct bpf_fentry_test_t {
+	struct bpf_fentry_test_t *a;
+};
+
+__u64 test7_result = 0;
+SEC("fentry/bpf_fentry_test7")
+int BPF_PROG(test7, struct bpf_fentry_test_t *arg)
+{
+	test7_result = 1;
+	return 0;
+}
+
+__u64 test8_result = 0;
+SEC("fentry/bpf_fentry_test8")
+int BPF_PROG(test8, struct bpf_fentry_test_t *arg)
+{
+	test8_result = 1;
+	return 0;
+}
-- 
2.26.2

