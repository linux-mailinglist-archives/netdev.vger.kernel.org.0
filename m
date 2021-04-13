Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98F335DE82
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhDMMQs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Apr 2021 08:16:48 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:21397 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345455AbhDMMQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:16:21 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-uF_9OH82MiWT4X1K6raq6A-1; Tue, 13 Apr 2021 08:15:58 -0400
X-MC-Unique: uF_9OH82MiWT4X1K6raq6A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7186A186E627;
        Tue, 13 Apr 2021 12:15:45 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.196.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60F1C10023B0;
        Tue, 13 Apr 2021 12:15:42 +0000 (UTC)
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
Subject: [PATCHv2 RFC bpf-next 7/7] selftests/bpf: Add ftrace probe test
Date:   Tue, 13 Apr 2021 14:15:16 +0200
Message-Id: <20210413121516.1467989-8-jolsa@kernel.org>
In-Reply-To: <20210413121516.1467989-1-jolsa@kernel.org>
References: <20210413121516.1467989-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding simple ftrace probe test that configures ftrace
probe and verifies the 'ip' argument matches the probed
functions addresses.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/ftrace_test.c    | 48 +++++++++++++++++++
 .../testing/selftests/bpf/progs/ftrace_test.c | 17 +++++++
 2 files changed, 65 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ftrace_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/ftrace_test.c

diff --git a/tools/testing/selftests/bpf/prog_tests/ftrace_test.c b/tools/testing/selftests/bpf/prog_tests/ftrace_test.c
new file mode 100644
index 000000000000..34d6dbe88251
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ftrace_test.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "ftrace_test.skel.h"
+
+void test_ftrace_test(void)
+{
+	struct ftrace_test *ftrace_skel = NULL;
+	__u32 duration = 0, retval;
+	int err, prog_fd;
+	__u64 *ips;
+	int idx, i;
+
+	ftrace_skel = ftrace_test__open_and_load();
+	if (!ASSERT_OK_PTR(ftrace_skel, "ftrace_skel_load"))
+		goto cleanup;
+
+	err = ftrace_test__attach(ftrace_skel);
+	if (!ASSERT_OK(err, "ftrace_attach"))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(ftrace_skel->progs.test);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err || retval, "test_run");
+
+	ips = ftrace_skel->bss->ips;
+	idx = ftrace_skel->bss->idx;
+
+	if (!ASSERT_EQ(idx, 8, "idx"))
+		goto cleanup;
+
+	for (i = 0; i < 8; i++) {
+		unsigned long long addr;
+		char func[50];
+
+		snprintf(func, sizeof(func), "bpf_fentry_test%d", i + 1);
+
+		err = kallsyms_find(func, &addr);
+		if (!ASSERT_OK(err, "kallsyms_find"))
+			goto cleanup;
+
+		if (!ASSERT_EQ(ips[i],  addr, "ips_addr"))
+			goto cleanup;
+	}
+
+cleanup:
+	ftrace_test__destroy(ftrace_skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/ftrace_test.c b/tools/testing/selftests/bpf/progs/ftrace_test.c
new file mode 100644
index 000000000000..b2a55aa10318
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/ftrace_test.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+__u64 ips[9] = { };
+unsigned int idx = 0;
+
+SEC("fentry.ftrace/bpf_fentry_test*")
+int BPF_PROG(test, __u64 ip, __u64 parent_ip)
+{
+	if (idx >= 0 && idx < 8)
+		ips[idx++] = ip;
+	return 0;
+}
-- 
2.30.2

