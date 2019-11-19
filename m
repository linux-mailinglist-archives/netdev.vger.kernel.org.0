Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B911010D7
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfKSBi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:38:59 -0500
Received: from www62.your-server.de ([213.133.104.62]:53698 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfKSBiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:38:50 -0500
Received: from 45.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.45] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWsTg-0002ko-OZ; Tue, 19 Nov 2019 02:38:48 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 8/8] bpf, testing: add various tail call test cases
Date:   Tue, 19 Nov 2019 02:38:39 +0100
Message-Id: <fee9a309e61c4abee212b6287f41637aae78acbe.1574126683.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1574126683.git.daniel@iogearbox.net>
References: <cover.1574126683.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25637/Mon Nov 18 10:53:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add several BPF kselftest cases for tail calls which test the various
patch directions (NOP -> JMP, JMP -> JMP, JMP -> NOP), and that multiple
locations are patched.

  # ./test_progs -n 44
  #44 tailcalls:OK
  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 .../selftests/bpf/prog_tests/tailcalls.c      | 210 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/tailcall1.c |  48 ++++
 tools/testing/selftests/bpf/progs/tailcall2.c |  59 +++++
 3 files changed, 317 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tailcalls.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall1.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall2.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tailcalls.c b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
new file mode 100644
index 000000000000..6862bb5f9688
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
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
+	/* Testing NOP -> JMP */
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
+	/* Testing JMP -> NOP */
+	err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != 3, "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+
+	/* Testing JMP -> JMP */
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
+out:
+	bpf_object__close(obj);
+}
+
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
+	/* Testing JMP -> NOP in entry() and bpf_func_1() */
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
+	/* Tail call limit */
+	err = bpf_prog_test_run(main_fd, 1, buff, sizeof(buff), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != 3, "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+out:
+	bpf_object__close(obj);
+}
+
+void test_tailcalls(void)
+{
+	test_tailcall_1();
+	test_tailcall_2();
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
-- 
2.21.0

