Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2299B10793F
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 21:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfKVUIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 15:08:22 -0500
Received: from www62.your-server.de ([213.133.104.62]:37404 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbfKVUIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 15:08:16 -0500
Received: from 30.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYFDy-0004Zi-Ja; Fri, 22 Nov 2019 21:08:14 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next v2 8/8] bpf, testing: add various tail call test cases
Date:   Fri, 22 Nov 2019 21:08:01 +0100
Message-Id: <3d6cbecbeb171117dccfe153306e479798fb608d.1574452833.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1574452833.git.daniel@iogearbox.net>
References: <cover.1574452833.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25641/Fri Nov 22 11:06:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add several BPF kselftest cases for tail calls which test the various
patch directions, and that multiple locations are patched in same and
different programs.

  # ./test_progs -n 45
   #45/1 tailcall_1:OK
   #45/2 tailcall_2:OK
   #45/3 tailcall_3:OK
   #45/4 tailcall_4:OK
   #45/5 tailcall_5:OK
   #45 tailcalls:OK
  Summary: 1/5 PASSED, 0 SKIPPED, 0 FAILED

I've also verified the JITed dump after each of the rewrite cases that
it matches expectations.

Also regular test_verifier suite passes fine which contains further tail
call tests:

  # ./test_verifier
  [...]
  Summary: 1563 PASSED, 0 SKIPPED, 0 FAILED

Checked under JIT, interpreter and JIT + hardening.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 .../selftests/bpf/prog_tests/tailcalls.c      | 487 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/tailcall1.c |  48 ++
 tools/testing/selftests/bpf/progs/tailcall2.c |  59 +++
 tools/testing/selftests/bpf/progs/tailcall3.c |  31 ++
 tools/testing/selftests/bpf/progs/tailcall4.c |  33 ++
 tools/testing/selftests/bpf/progs/tailcall5.c |  40 ++
 6 files changed, 698 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tailcalls.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall1.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall2.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall3.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall4.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall5.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tailcalls.c b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
new file mode 100644
index 000000000000..bb8fe646dd9f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
@@ -0,0 +1,487 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+/* test_tailcall_1 checks basic functionality by patching multiple locations
+ * in a single program for a single tail call slot with nop->jmp, jmp->nop
+ * and jmp->jmp rewrites. Also checks for nop->nop.
+ */
+static void test_tailcall_1(void)
+{
+	int err, map_fd, prog_fd, main_fd, i, j;
+	struct bpf_map *prog_array;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	__u32 retval, duration;
+	char prog_name[32];
+	char buff[128] = {};
+
+	err = bpf_prog_load("tailcall1.o", BPF_PROG_TYPE_SCHED_CLS, &obj,
+			    &prog_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	prog = bpf_object__find_program_by_title(obj, "classifier");
+	if (CHECK_FAIL(!prog))
+		goto out;
+
+	main_fd = bpf_program__fd(prog);
+	if (CHECK_FAIL(main_fd < 0))
+		goto out;
+
+	prog_array = bpf_object__find_map_by_name(obj, "jmp_table");
+	if (CHECK_FAIL(!prog_array))
+		goto out;
+
+	map_fd = bpf_map__fd(prog_array);
+	if (CHECK_FAIL(map_fd < 0))
+		goto out;
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		snprintf(prog_name, sizeof(prog_name), "classifier/%i", i);
+
+		prog = bpf_object__find_program_by_title(obj, prog_name);
+		if (CHECK_FAIL(!prog))
+			goto out;
+
+		prog_fd = bpf_program__fd(prog);
+		if (CHECK_FAIL(prog_fd < 0))
+			goto out;
+
+		err = bpf_map_update_elem(map_fd, &i, &prog_fd, BPF_ANY);
+		if (CHECK_FAIL(err))
+			goto out;
+	}
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+					&duration, &retval, NULL);
+		CHECK(err || retval != i, "tailcall",
+		      "err %d errno %d retval %d\n", err, errno, retval);
+
+		err = bpf_map_delete_elem(map_fd, &i);
+		if (CHECK_FAIL(err))
+			goto out;
+	}
+
+	err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != 3, "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		snprintf(prog_name, sizeof(prog_name), "classifier/%i", i);
+
+		prog = bpf_object__find_program_by_title(obj, prog_name);
+		if (CHECK_FAIL(!prog))
+			goto out;
+
+		prog_fd = bpf_program__fd(prog);
+		if (CHECK_FAIL(prog_fd < 0))
+			goto out;
+
+		err = bpf_map_update_elem(map_fd, &i, &prog_fd, BPF_ANY);
+		if (CHECK_FAIL(err))
+			goto out;
+	}
+
+	err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != 0, "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		j = bpf_map__def(prog_array)->max_entries - 1 - i;
+		snprintf(prog_name, sizeof(prog_name), "classifier/%i", j);
+
+		prog = bpf_object__find_program_by_title(obj, prog_name);
+		if (CHECK_FAIL(!prog))
+			goto out;
+
+		prog_fd = bpf_program__fd(prog);
+		if (CHECK_FAIL(prog_fd < 0))
+			goto out;
+
+		err = bpf_map_update_elem(map_fd, &i, &prog_fd, BPF_ANY);
+		if (CHECK_FAIL(err))
+			goto out;
+	}
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		j = bpf_map__def(prog_array)->max_entries - 1 - i;
+
+		err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+					&duration, &retval, NULL);
+		CHECK(err || retval != j, "tailcall",
+		      "err %d errno %d retval %d\n", err, errno, retval);
+
+		err = bpf_map_delete_elem(map_fd, &i);
+		if (CHECK_FAIL(err))
+			goto out;
+	}
+
+	err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != 3, "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		err = bpf_map_delete_elem(map_fd, &i);
+		if (CHECK_FAIL(err >= 0 || errno != ENOENT))
+			goto out;
+
+		err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+					&duration, &retval, NULL);
+		CHECK(err || retval != 3, "tailcall",
+		      "err %d errno %d retval %d\n", err, errno, retval);
+	}
+
+out:
+	bpf_object__close(obj);
+}
+
+/* test_tailcall_2 checks that patching multiple programs for a single
+ * tail call slot works. It also jumps through several programs and tests
+ * the tail call limit counter.
+ */
+static void test_tailcall_2(void)
+{
+	int err, map_fd, prog_fd, main_fd, i;
+	struct bpf_map *prog_array;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	__u32 retval, duration;
+	char prog_name[32];
+	char buff[128] = {};
+
+	err = bpf_prog_load("tailcall2.o", BPF_PROG_TYPE_SCHED_CLS, &obj,
+			    &prog_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	prog = bpf_object__find_program_by_title(obj, "classifier");
+	if (CHECK_FAIL(!prog))
+		goto out;
+
+	main_fd = bpf_program__fd(prog);
+	if (CHECK_FAIL(main_fd < 0))
+		goto out;
+
+	prog_array = bpf_object__find_map_by_name(obj, "jmp_table");
+	if (CHECK_FAIL(!prog_array))
+		goto out;
+
+	map_fd = bpf_map__fd(prog_array);
+	if (CHECK_FAIL(map_fd < 0))
+		goto out;
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		snprintf(prog_name, sizeof(prog_name), "classifier/%i", i);
+
+		prog = bpf_object__find_program_by_title(obj, prog_name);
+		if (CHECK_FAIL(!prog))
+			goto out;
+
+		prog_fd = bpf_program__fd(prog);
+		if (CHECK_FAIL(prog_fd < 0))
+			goto out;
+
+		err = bpf_map_update_elem(map_fd, &i, &prog_fd, BPF_ANY);
+		if (CHECK_FAIL(err))
+			goto out;
+	}
+
+	err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != 2, "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+
+	i = 2;
+	err = bpf_map_delete_elem(map_fd, &i);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != 1, "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+
+	i = 0;
+	err = bpf_map_delete_elem(map_fd, &i);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != 3, "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+out:
+	bpf_object__close(obj);
+}
+
+/* test_tailcall_3 checks that the count value of the tail call limit
+ * enforcement matches with expectations.
+ */
+static void test_tailcall_3(void)
+{
+	int err, map_fd, prog_fd, main_fd, data_fd, i, val;
+	struct bpf_map *prog_array, *data_map;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	__u32 retval, duration;
+	char buff[128] = {};
+
+	err = bpf_prog_load("tailcall3.o", BPF_PROG_TYPE_SCHED_CLS, &obj,
+			    &prog_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	prog = bpf_object__find_program_by_title(obj, "classifier");
+	if (CHECK_FAIL(!prog))
+		goto out;
+
+	main_fd = bpf_program__fd(prog);
+	if (CHECK_FAIL(main_fd < 0))
+		goto out;
+
+	prog_array = bpf_object__find_map_by_name(obj, "jmp_table");
+	if (CHECK_FAIL(!prog_array))
+		goto out;
+
+	map_fd = bpf_map__fd(prog_array);
+	if (CHECK_FAIL(map_fd < 0))
+		goto out;
+
+	prog = bpf_object__find_program_by_title(obj, "classifier/0");
+	if (CHECK_FAIL(!prog))
+		goto out;
+
+	prog_fd = bpf_program__fd(prog);
+	if (CHECK_FAIL(prog_fd < 0))
+		goto out;
+
+	i = 0;
+	err = bpf_map_update_elem(map_fd, &i, &prog_fd, BPF_ANY);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != 1, "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+
+	data_map = bpf_object__find_map_by_name(obj, "tailcall.bss");
+	if (CHECK_FAIL(!data_map || !bpf_map__is_internal(data_map)))
+		return;
+
+	data_fd = bpf_map__fd(data_map);
+	if (CHECK_FAIL(map_fd < 0))
+		return;
+
+	i = 0;
+	err = bpf_map_lookup_elem(data_fd, &i, &val);
+	CHECK(err || val != 33, "tailcall count", "err %d errno %d count %d\n",
+	      err, errno, val);
+
+	i = 0;
+	err = bpf_map_delete_elem(map_fd, &i);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != 0, "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+out:
+	bpf_object__close(obj);
+}
+
+/* test_tailcall_4 checks that the kernel properly selects indirect jump
+ * for the case where the key is not known. Latter is passed via global
+ * data to select different targets we can compare return value of.
+ */
+static void test_tailcall_4(void)
+{
+	int err, map_fd, prog_fd, main_fd, data_fd, i;
+	struct bpf_map *prog_array, *data_map;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	__u32 retval, duration;
+	static const int zero = 0;
+	char buff[128] = {};
+	char prog_name[32];
+
+	err = bpf_prog_load("tailcall4.o", BPF_PROG_TYPE_SCHED_CLS, &obj,
+			    &prog_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	prog = bpf_object__find_program_by_title(obj, "classifier");
+	if (CHECK_FAIL(!prog))
+		goto out;
+
+	main_fd = bpf_program__fd(prog);
+	if (CHECK_FAIL(main_fd < 0))
+		goto out;
+
+	prog_array = bpf_object__find_map_by_name(obj, "jmp_table");
+	if (CHECK_FAIL(!prog_array))
+		goto out;
+
+	map_fd = bpf_map__fd(prog_array);
+	if (CHECK_FAIL(map_fd < 0))
+		goto out;
+
+	data_map = bpf_object__find_map_by_name(obj, "tailcall.bss");
+	if (CHECK_FAIL(!data_map || !bpf_map__is_internal(data_map)))
+		return;
+
+	data_fd = bpf_map__fd(data_map);
+	if (CHECK_FAIL(map_fd < 0))
+		return;
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		snprintf(prog_name, sizeof(prog_name), "classifier/%i", i);
+
+		prog = bpf_object__find_program_by_title(obj, prog_name);
+		if (CHECK_FAIL(!prog))
+			goto out;
+
+		prog_fd = bpf_program__fd(prog);
+		if (CHECK_FAIL(prog_fd < 0))
+			goto out;
+
+		err = bpf_map_update_elem(map_fd, &i, &prog_fd, BPF_ANY);
+		if (CHECK_FAIL(err))
+			goto out;
+	}
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		err = bpf_map_update_elem(data_fd, &zero, &i, BPF_ANY);
+		if (CHECK_FAIL(err))
+			goto out;
+
+		err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+					&duration, &retval, NULL);
+		CHECK(err || retval != i, "tailcall",
+		      "err %d errno %d retval %d\n", err, errno, retval);
+	}
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		err = bpf_map_update_elem(data_fd, &zero, &i, BPF_ANY);
+		if (CHECK_FAIL(err))
+			goto out;
+
+		err = bpf_map_delete_elem(map_fd, &i);
+		if (CHECK_FAIL(err))
+			goto out;
+
+		err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+					&duration, &retval, NULL);
+		CHECK(err || retval != 3, "tailcall",
+		      "err %d errno %d retval %d\n", err, errno, retval);
+	}
+out:
+	bpf_object__close(obj);
+}
+
+/* test_tailcall_5 probes similarly to test_tailcall_4 that the kernel generates
+ * an indirect jump when the keys are const but different from different branches.
+ */
+static void test_tailcall_5(void)
+{
+	int err, map_fd, prog_fd, main_fd, data_fd, i, key[] = { 1111, 1234, 5678 };
+	struct bpf_map *prog_array, *data_map;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	__u32 retval, duration;
+	static const int zero = 0;
+	char buff[128] = {};
+	char prog_name[32];
+
+	err = bpf_prog_load("tailcall5.o", BPF_PROG_TYPE_SCHED_CLS, &obj,
+			    &prog_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	prog = bpf_object__find_program_by_title(obj, "classifier");
+	if (CHECK_FAIL(!prog))
+		goto out;
+
+	main_fd = bpf_program__fd(prog);
+	if (CHECK_FAIL(main_fd < 0))
+		goto out;
+
+	prog_array = bpf_object__find_map_by_name(obj, "jmp_table");
+	if (CHECK_FAIL(!prog_array))
+		goto out;
+
+	map_fd = bpf_map__fd(prog_array);
+	if (CHECK_FAIL(map_fd < 0))
+		goto out;
+
+	data_map = bpf_object__find_map_by_name(obj, "tailcall.bss");
+	if (CHECK_FAIL(!data_map || !bpf_map__is_internal(data_map)))
+		return;
+
+	data_fd = bpf_map__fd(data_map);
+	if (CHECK_FAIL(map_fd < 0))
+		return;
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		snprintf(prog_name, sizeof(prog_name), "classifier/%i", i);
+
+		prog = bpf_object__find_program_by_title(obj, prog_name);
+		if (CHECK_FAIL(!prog))
+			goto out;
+
+		prog_fd = bpf_program__fd(prog);
+		if (CHECK_FAIL(prog_fd < 0))
+			goto out;
+
+		err = bpf_map_update_elem(map_fd, &i, &prog_fd, BPF_ANY);
+		if (CHECK_FAIL(err))
+			goto out;
+	}
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		err = bpf_map_update_elem(data_fd, &zero, &key[i], BPF_ANY);
+		if (CHECK_FAIL(err))
+			goto out;
+
+		err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+					&duration, &retval, NULL);
+		CHECK(err || retval != i, "tailcall",
+		      "err %d errno %d retval %d\n", err, errno, retval);
+	}
+
+	for (i = 0; i < bpf_map__def(prog_array)->max_entries; i++) {
+		err = bpf_map_update_elem(data_fd, &zero, &key[i], BPF_ANY);
+		if (CHECK_FAIL(err))
+			goto out;
+
+		err = bpf_map_delete_elem(map_fd, &i);
+		if (CHECK_FAIL(err))
+			goto out;
+
+		err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+					&duration, &retval, NULL);
+		CHECK(err || retval != 3, "tailcall",
+		      "err %d errno %d retval %d\n", err, errno, retval);
+	}
+out:
+	bpf_object__close(obj);
+}
+
+void test_tailcalls(void)
+{
+	if (test__start_subtest("tailcall_1"))
+		test_tailcall_1();
+	if (test__start_subtest("tailcall_2"))
+		test_tailcall_2();
+	if (test__start_subtest("tailcall_3"))
+		test_tailcall_3();
+	if (test__start_subtest("tailcall_4"))
+		test_tailcall_4();
+	if (test__start_subtest("tailcall_5"))
+		test_tailcall_5();
+}
diff --git a/tools/testing/selftests/bpf/progs/tailcall1.c b/tools/testing/selftests/bpf/progs/tailcall1.c
new file mode 100644
index 000000000000..63531e1a9fa4
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tailcall1.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+
+#include "bpf_helpers.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, 3);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} jmp_table SEC(".maps");
+
+#define TAIL_FUNC(x) 				\
+	SEC("classifier/" #x)			\
+	int bpf_func_##x(struct __sk_buff *skb)	\
+	{					\
+		return x;			\
+	}
+TAIL_FUNC(0)
+TAIL_FUNC(1)
+TAIL_FUNC(2)
+
+SEC("classifier")
+int entry(struct __sk_buff *skb)
+{
+	/* Multiple locations to make sure we patch
+	 * all of them.
+	 */
+	bpf_tail_call(skb, &jmp_table, 0);
+	bpf_tail_call(skb, &jmp_table, 0);
+	bpf_tail_call(skb, &jmp_table, 0);
+	bpf_tail_call(skb, &jmp_table, 0);
+
+	bpf_tail_call(skb, &jmp_table, 1);
+	bpf_tail_call(skb, &jmp_table, 1);
+	bpf_tail_call(skb, &jmp_table, 1);
+	bpf_tail_call(skb, &jmp_table, 1);
+
+	bpf_tail_call(skb, &jmp_table, 2);
+	bpf_tail_call(skb, &jmp_table, 2);
+	bpf_tail_call(skb, &jmp_table, 2);
+	bpf_tail_call(skb, &jmp_table, 2);
+
+	return 3;
+}
+
+char __license[] SEC("license") = "GPL";
+int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/tailcall2.c b/tools/testing/selftests/bpf/progs/tailcall2.c
new file mode 100644
index 000000000000..21c85c477210
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tailcall2.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+
+#include "bpf_helpers.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, 5);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} jmp_table SEC(".maps");
+
+SEC("classifier/0")
+int bpf_func_0(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, 1);
+	return 0;
+}
+
+SEC("classifier/1")
+int bpf_func_1(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, 2);
+	return 1;
+}
+
+SEC("classifier/2")
+int bpf_func_2(struct __sk_buff *skb)
+{
+	return 2;
+}
+
+SEC("classifier/3")
+int bpf_func_3(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, 4);
+	return 3;
+}
+
+SEC("classifier/4")
+int bpf_func_4(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, 3);
+	return 4;
+}
+
+SEC("classifier")
+int entry(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, 0);
+	/* Check multi-prog update. */
+	bpf_tail_call(skb, &jmp_table, 2);
+	/* Check tail call limit. */
+	bpf_tail_call(skb, &jmp_table, 3);
+	return 3;
+}
+
+char __license[] SEC("license") = "GPL";
+int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/tailcall3.c b/tools/testing/selftests/bpf/progs/tailcall3.c
new file mode 100644
index 000000000000..1ecae198b8c1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tailcall3.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+
+#include "bpf_helpers.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} jmp_table SEC(".maps");
+
+static volatile int count;
+
+SEC("classifier/0")
+int bpf_func_0(struct __sk_buff *skb)
+{
+	count++;
+	bpf_tail_call(skb, &jmp_table, 0);
+	return 1;
+}
+
+SEC("classifier")
+int entry(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, 0);
+	return 0;
+}
+
+char __license[] SEC("license") = "GPL";
+int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/tailcall4.c b/tools/testing/selftests/bpf/progs/tailcall4.c
new file mode 100644
index 000000000000..499388758119
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tailcall4.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+
+#include "bpf_helpers.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, 3);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} jmp_table SEC(".maps");
+
+static volatile int selector;
+
+#define TAIL_FUNC(x)				\
+	SEC("classifier/" #x)			\
+	int bpf_func_##x(struct __sk_buff *skb)	\
+	{					\
+		return x;			\
+	}
+TAIL_FUNC(0)
+TAIL_FUNC(1)
+TAIL_FUNC(2)
+
+SEC("classifier")
+int entry(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, selector);
+	return 3;
+}
+
+char __license[] SEC("license") = "GPL";
+int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/tailcall5.c b/tools/testing/selftests/bpf/progs/tailcall5.c
new file mode 100644
index 000000000000..49c64eb53f19
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tailcall5.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+
+#include "bpf_helpers.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, 3);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} jmp_table SEC(".maps");
+
+static volatile int selector;
+
+#define TAIL_FUNC(x)				\
+	SEC("classifier/" #x)			\
+	int bpf_func_##x(struct __sk_buff *skb)	\
+	{					\
+		return x;			\
+	}
+TAIL_FUNC(0)
+TAIL_FUNC(1)
+TAIL_FUNC(2)
+
+SEC("classifier")
+int entry(struct __sk_buff *skb)
+{
+	int idx = 0;
+
+	if (selector == 1234)
+		idx = 1;
+	else if (selector == 5678)
+		idx = 2;
+
+	bpf_tail_call(skb, &jmp_table, idx);
+	return 3;
+}
+
+char __license[] SEC("license") = "GPL";
+int _version SEC("version") = 1;
-- 
2.21.0

