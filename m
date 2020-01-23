Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFB8146E1D
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 17:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAWQPZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Jan 2020 11:15:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36445 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727296AbgAWQPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 11:15:25 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-X4UCpbdsMOqmi2fDC3luWA-1; Thu, 23 Jan 2020 11:15:20 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F41041084420;
        Thu, 23 Jan 2020 16:15:18 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABDFE85753;
        Thu, 23 Jan 2020 16:15:16 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 3/3] selftest/bpf: Add test for allowed trampolines count
Date:   Thu, 23 Jan 2020 17:15:08 +0100
Message-Id: <20200123161508.915203-4-jolsa@kernel.org>
In-Reply-To: <20200123161508.915203-1-jolsa@kernel.org>
References: <20200123161508.915203-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: X4UCpbdsMOqmi2fDC3luWA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's limit of 40 programs tht can be attached
to trampoline for one function. Adding test that
tries to attach that many plus one extra that needs
to fail.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/trampoline_count.c         | 112 ++++++++++++++++++
 .../bpf/progs/test_trampoline_count.c         |  21 ++++
 2 files changed, 133 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trampoline_count.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trampoline_count.c

diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
new file mode 100644
index 000000000000..1235f3d1cc50
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define _GNU_SOURCE
+#include <sched.h>
+#include <sys/prctl.h>
+#include <test_progs.h>
+
+#define MAX_TRAMP_PROGS 40
+
+struct inst {
+	struct bpf_object *obj;
+	struct bpf_link   *link_fentry;
+	struct bpf_link   *link_fexit;
+};
+
+static int test_task_rename(void)
+{
+	int fd, duration = 0, err;
+	char buf[] = "test_overhead";
+
+	fd = open("/proc/self/comm", O_WRONLY|O_TRUNC);
+	if (CHECK(fd < 0, "open /proc", "err %d", errno))
+		return -1;
+	err = write(fd, buf, sizeof(buf));
+	if (err < 0) {
+		CHECK(err < 0, "task rename", "err %d", errno);
+		close(fd);
+		return -1;
+	}
+	close(fd);
+	return 0;
+}
+
+static struct bpf_link *load(struct bpf_object *obj, const char *name)
+{
+	struct bpf_program *prog;
+	int duration = 0;
+
+	prog = bpf_object__find_program_by_title(obj, name);
+	if (CHECK(!prog, "find_probe", "prog '%s' not found\n", name))
+		return ERR_PTR(-EINVAL);
+	return bpf_program__attach_trace(prog);
+}
+
+void test_trampoline_count(void)
+{
+	const char *fentry_name = "fentry/__set_task_comm";
+	const char *fexit_name = "fexit/__set_task_comm";
+	const char *object = "test_trampoline_count.o";
+	struct inst inst[MAX_TRAMP_PROGS] = { 0 };
+	int err, i = 0, duration = 0;
+	struct bpf_object *obj;
+	struct bpf_link *link;
+	char comm[16] = {};
+
+	/* attach 'allowed' 40 trampoline programs */
+	for (i = 0; i < MAX_TRAMP_PROGS; i++) {
+		obj = bpf_object__open_file(object, NULL);
+		if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
+			goto cleanup;
+
+		err = bpf_object__load(obj);
+		if (CHECK(err, "obj_load", "err %d\n", err))
+			goto cleanup;
+		inst[i].obj = obj;
+
+		if (rand() % 2) {
+			link = load(obj, fentry_name);
+			if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link)))
+				goto cleanup;
+			inst[i].link_fentry = link;
+		} else {
+			link = load(obj, fexit_name);
+			if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link)))
+				goto cleanup;
+			inst[i].link_fexit = link;
+		}
+	}
+
+	/* and try 1 extra.. */
+	obj = bpf_object__open_file(object, NULL);
+	if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
+		goto cleanup;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "obj_load", "err %d\n", err))
+		goto cleanup_extra;
+
+	/* ..that needs to fail */
+	link = load(obj, fentry_name);
+	if (CHECK(!IS_ERR(link), "cannot attach over the limit", "err %ld\n", PTR_ERR(link))) {
+		bpf_link__destroy(link);
+		goto cleanup_extra;
+	}
+
+	/* with E2BIG error */
+	CHECK(PTR_ERR(link) != -E2BIG, "proper error check", "err %ld\n", PTR_ERR(link));
+
+	/* and finaly execute the probe */
+	if (CHECK_FAIL(prctl(PR_GET_NAME, comm, 0L, 0L, 0L)))
+		goto cleanup_extra;
+	CHECK_FAIL(test_task_rename());
+	CHECK_FAIL(prctl(PR_SET_NAME, comm, 0L, 0L, 0L));
+
+cleanup_extra:
+	bpf_object__close(obj);
+cleanup:
+	while (--i) {
+		bpf_link__destroy(inst[i].link_fentry);
+		bpf_link__destroy(inst[i].link_fexit);
+		bpf_object__close(inst[i].obj);
+	}
+}
diff --git a/tools/testing/selftests/bpf/progs/test_trampoline_count.c b/tools/testing/selftests/bpf/progs/test_trampoline_count.c
new file mode 100644
index 000000000000..e51e6e3a81c2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_trampoline_count.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdbool.h>
+#include <stddef.h>
+#include <linux/bpf.h>
+#include "bpf_trace_helpers.h"
+
+struct task_struct;
+
+SEC("fentry/__set_task_comm")
+int BPF_PROG(prog1, struct task_struct *tsk, const char *buf, bool exec)
+{
+	return 0;
+}
+
+SEC("fexit/__set_task_comm")
+int BPF_PROG(prog2, struct task_struct *tsk, const char *buf, bool exec)
+{
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.24.1

