Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A499A26CF23
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgIPWyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:54:09 -0400
Received: from mga17.intel.com ([192.55.52.151]:44501 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgIPWyI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 18:54:08 -0400
IronPort-SDR: YQ12HQ8065Q/y7Wb9b+p1W1Y3CPkYhuwVfQAw45W+0z7fVALnnN2aMVkM7ETxluT8VLTKprD67
 GMFMH3jxBjYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="139578084"
X-IronPort-AV: E=Sophos;i="5.76,434,1592895600"; 
   d="scan'208";a="139578084"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 14:16:56 -0700
IronPort-SDR: wsIZwBOy85wxVtKcXtSFxE4frLbrUWWpycZdVfn59lFfbZRVYVR9/a+XAN+bEmKF+YeaIaM5qe
 Si9v6c0m662g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,434,1592895600"; 
   d="scan'208";a="346369964"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga007.jf.intel.com with ESMTP; 16 Sep 2020 14:16:53 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v8 bpf-next 7/7] selftests: bpf: introduce tailcall_bpf2bpf test suite
Date:   Wed, 16 Sep 2020 23:10:10 +0200
Message-Id: <20200916211010.3685-8-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200916211010.3685-1-maciej.fijalkowski@intel.com>
References: <20200916211010.3685-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add four tests to tailcalls selftest explicitly named
"tailcall_bpf2bpf2_X" as their purpose is to validate that combination
of tailcalls with bpf2bpf calls are working properly.

Include also test_verifier's test cases, one negative that will exercise
check_max_stack_depth check against caller's stack being larger than 256
bytes. Second one should be accepted by verifier as caller's stack depth
is smaller than 256 and from subprogram that has the tailcall new stack
frame is intentionally created, so the total stack depth is > 256 but
this last stack frame will be unwinded before the actual tailcall.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 .../selftests/bpf/prog_tests/tailcalls.c      | 332 ++++++++++++++++++
 .../selftests/bpf/progs/tailcall_bpf2bpf1.c   |  38 ++
 .../selftests/bpf/progs/tailcall_bpf2bpf2.c   |  37 ++
 .../selftests/bpf/progs/tailcall_bpf2bpf3.c   |  57 +++
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c   |  61 ++++
 tools/testing/selftests/bpf/verifier/calls.c  |  53 +++
 6 files changed, 578 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf1.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf3.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tailcalls.c b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
index bb8fe646dd9f..ee27d68d2a1c 100644
--- a/tools/testing/selftests/bpf/prog_tests/tailcalls.c
+++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
+#include <network_helpers.h>
 
 /* test_tailcall_1 checks basic functionality by patching multiple locations
  * in a single program for a single tail call slot with nop->jmp, jmp->nop
@@ -472,6 +473,329 @@ static void test_tailcall_5(void)
 	bpf_object__close(obj);
 }
 
+/* test_tailcall_bpf2bpf_1 purpose is to make sure that tailcalls are working
+ * correctly in correlation with BPF subprograms
+ */
+static void test_tailcall_bpf2bpf_1(void)
+{
+	int err, map_fd, prog_fd, main_fd, i;
+	struct bpf_map *prog_array;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	__u32 retval, duration;
+	char prog_name[32];
+
+	err = bpf_prog_load("tailcall_bpf2bpf1.o", BPF_PROG_TYPE_SCHED_CLS,
+			    &obj, &prog_fd);
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
+	/* nop -> jmp */
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
+	err = bpf_prog_test_run(main_fd, 1, &pkt_v4, sizeof(pkt_v4), 0,
+				0, &retval, &duration);
+	CHECK(err || retval != 1, "tailcall",
+	      "err %d errno %d retval %d\n", err, errno, retval);
+
+	/* jmp -> nop, call subprog that will do tailcall */
+	i = 1;
+	err = bpf_map_delete_elem(map_fd, &i);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	err = bpf_prog_test_run(main_fd, 1, &pkt_v4, sizeof(pkt_v4), 0,
+				0, &retval, &duration);
+	CHECK(err || retval != 0, "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+
+	/* make sure that subprog can access ctx and entry prog that
+	 * called this subprog can properly return
+	 */
+	i = 0;
+	err = bpf_map_delete_elem(map_fd, &i);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	err = bpf_prog_test_run(main_fd, 1, &pkt_v4, sizeof(pkt_v4), 0,
+				0, &retval, &duration);
+	CHECK(err || retval != sizeof(pkt_v4) * 2,
+	      "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+out:
+	bpf_object__close(obj);
+}
+
+/* test_tailcall_bpf2bpf_2 checks that the count value of the tail call limit
+ * enforcement matches with expectations when tailcall is preceded with
+ * bpf2bpf call.
+ */
+static void test_tailcall_bpf2bpf_2(void)
+{
+	int err, map_fd, prog_fd, main_fd, data_fd, i, val;
+	struct bpf_map *prog_array, *data_map;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	__u32 retval, duration;
+	char buff[128] = {};
+
+	err = bpf_prog_load("tailcall_bpf2bpf2.o", BPF_PROG_TYPE_SCHED_CLS,
+			    &obj, &prog_fd);
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
+/* test_tailcall_bpf2bpf_3 checks that non-trivial amount of stack (up to
+ * 256 bytes) can be used within bpf subprograms that have the tailcalls
+ * in them
+ */
+static void test_tailcall_bpf2bpf_3(void)
+{
+	int err, map_fd, prog_fd, main_fd, i;
+	struct bpf_map *prog_array;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	__u32 retval, duration;
+	char prog_name[32];
+
+	err = bpf_prog_load("tailcall_bpf2bpf3.o", BPF_PROG_TYPE_SCHED_CLS,
+			    &obj, &prog_fd);
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
+	err = bpf_prog_test_run(main_fd, 1, &pkt_v4, sizeof(pkt_v4), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != sizeof(pkt_v4) * 3,
+	      "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+
+	i = 1;
+	err = bpf_map_delete_elem(map_fd, &i);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	err = bpf_prog_test_run(main_fd, 1, &pkt_v4, sizeof(pkt_v4), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != sizeof(pkt_v4),
+	      "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+
+	i = 0;
+	err = bpf_map_delete_elem(map_fd, &i);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	err = bpf_prog_test_run(main_fd, 1, &pkt_v4, sizeof(pkt_v4), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != sizeof(pkt_v4) * 2,
+	      "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+out:
+	bpf_object__close(obj);
+}
+
+/* test_tailcall_bpf2bpf_4 checks that tailcall counter is correctly preserved
+ * across tailcalls combined with bpf2bpf calls. for making sure that tailcall
+ * counter behaves correctly, bpf program will go through following flow:
+ *
+ * entry -> entry_subprog -> tailcall0 -> bpf_func0 -> subprog0 ->
+ * -> tailcall1 -> bpf_func1 -> subprog1 -> tailcall2 -> bpf_func2 ->
+ * subprog2 [here bump global counter] --------^
+ *
+ * We go through first two tailcalls and start counting from the subprog2 where
+ * the loop begins. At the end of the test make sure that the global counter is
+ * equal to 31, because tailcall counter includes the first two tailcalls
+ * whereas global counter is incremented only on loop presented on flow above.
+ */
+static void test_tailcall_bpf2bpf_4(void)
+{
+	int err, map_fd, prog_fd, main_fd, data_fd, i, val;
+	struct bpf_map *prog_array, *data_map;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	__u32 retval, duration;
+	char prog_name[32];
+
+	err = bpf_prog_load("tailcall_bpf2bpf4.o", BPF_PROG_TYPE_SCHED_CLS,
+			    &obj, &prog_fd);
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
+	err = bpf_prog_test_run(main_fd, 1, &pkt_v4, sizeof(pkt_v4), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != sizeof(pkt_v4) * 3, "tailcall", "err %d errno %d retval %d\n",
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
+	CHECK(err || val != 31, "tailcall count", "err %d errno %d count %d\n",
+	      err, errno, val);
+
+out:
+	bpf_object__close(obj);
+}
+
 void test_tailcalls(void)
 {
 	if (test__start_subtest("tailcall_1"))
@@ -484,4 +808,12 @@ void test_tailcalls(void)
 		test_tailcall_4();
 	if (test__start_subtest("tailcall_5"))
 		test_tailcall_5();
+	if (test__start_subtest("tailcall_bpf2bpf_1"))
+		test_tailcall_bpf2bpf_1();
+	if (test__start_subtest("tailcall_bpf2bpf_2"))
+		test_tailcall_bpf2bpf_2();
+	if (test__start_subtest("tailcall_bpf2bpf_3"))
+		test_tailcall_bpf2bpf_3();
+	if (test__start_subtest("tailcall_bpf2bpf_4"))
+		test_tailcall_bpf2bpf_4();
 }
diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf1.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf1.c
new file mode 100644
index 000000000000..e72ca5869b58
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf1.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, 2);
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
+
+static __attribute__ ((noinline))
+int subprog_tail(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, 0);
+
+	return skb->len * 2;
+}
+
+SEC("classifier")
+int entry(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, 1);
+
+	return subprog_tail(skb);
+}
+
+char __license[] SEC("license") = "GPL";
+int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c
new file mode 100644
index 000000000000..1f7fc46628e4
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} jmp_table SEC(".maps");
+
+static __attribute__ ((noinline))
+int subprog_tail(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, 0);
+	return 1;
+}
+
+static volatile int count;
+
+SEC("classifier/0")
+int bpf_func_0(struct __sk_buff *skb)
+{
+	count++;
+	return subprog_tail(skb);
+}
+
+SEC("classifier")
+int entry(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, 0);
+
+	return 0;
+}
+
+char __license[] SEC("license") = "GPL";
+int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf3.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf3.c
new file mode 100644
index 000000000000..2f61abce83ca
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf3.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, 2);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} jmp_table SEC(".maps");
+
+static __attribute__ ((noinline))
+int subprog_tail2(struct __sk_buff *skb)
+{
+	volatile char arr[64] = {};
+
+	bpf_tail_call(skb, &jmp_table, 1);
+
+	return skb->len;
+}
+
+static __attribute__ ((noinline))
+int subprog_tail(struct __sk_buff *skb)
+{
+	volatile char arr[64] = {};
+
+	bpf_tail_call(skb, &jmp_table, 0);
+
+	return skb->len * 2;
+}
+
+SEC("classifier/0")
+int bpf_func_0(struct __sk_buff *skb)
+{
+	volatile char arr[128] = {};
+
+	return subprog_tail2(skb);
+}
+
+SEC("classifier/1")
+int bpf_func_1(struct __sk_buff *skb)
+{
+	volatile char arr[128] = {};
+
+	return skb->len * 3;
+}
+
+SEC("classifier")
+int entry(struct __sk_buff *skb)
+{
+	volatile char arr[128] = {};
+
+	return subprog_tail(skb);
+}
+
+char __license[] SEC("license") = "GPL";
+int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
new file mode 100644
index 000000000000..686511535f83
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, 3);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} jmp_table SEC(".maps");
+
+static volatile int count;
+
+static __attribute__ ((noinline))
+int subprog_tail_2(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, 2);
+	return skb->len * 3;
+}
+
+static __attribute__ ((noinline))
+int subprog_tail_1(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, 1);
+	return skb->len * 2;
+}
+
+static __attribute__ ((noinline))
+int subprog_tail(struct __sk_buff *skb)
+{
+	bpf_tail_call(skb, &jmp_table, 0);
+	return skb->len;
+}
+
+SEC("classifier/1")
+int bpf_func_1(struct __sk_buff *skb)
+{
+	return subprog_tail_2(skb);
+}
+
+SEC("classifier/2")
+int bpf_func_2(struct __sk_buff *skb)
+{
+	count++;
+	return subprog_tail_2(skb);
+}
+
+SEC("classifier/0")
+int bpf_func_0(struct __sk_buff *skb)
+{
+	return subprog_tail_1(skb);
+}
+
+SEC("classifier")
+int entry(struct __sk_buff *skb)
+{
+	return subprog_tail(skb);
+}
+
+char __license[] SEC("license") = "GPL";
+int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
index 94258c6b5235..dc4603adb9eb 100644
--- a/tools/testing/selftests/bpf/verifier/calls.c
+++ b/tools/testing/selftests/bpf/verifier/calls.c
@@ -780,6 +780,59 @@
 	.errstr = "combined stack size",
 	.result = REJECT,
 },
+{
+	"calls: stack overflow for bpf2bpf calls combined with tailcall",
+	.insns = {
+	/* prog 1 */
+	BPF_ST_MEM(BPF_B, BPF_REG_10, -128, 0),
+	BPF_RAW_INSN(BPF_JMP|BPF_CALL, 0, 1, 0, 1),
+	BPF_EXIT_INSN(),
+
+	/* prog 2 */
+	BPF_ST_MEM(BPF_B, BPF_REG_10, -192, 0),
+	BPF_RAW_INSN(BPF_JMP|BPF_CALL, 0, 1, 0, 1),
+	BPF_EXIT_INSN(),
+
+	/*prog 3, caller's stack depth > 256 */
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_tail_call),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.errstr = "Cannot do bpf_tail_call in subprog",
+	.fixup_prog1 = { 7 },
+	.result = REJECT,
+},
+{
+	"calls: bpf2bpf calls combined with tailcall",
+	.insns = {
+	/* prog 1 */
+	BPF_ST_MEM(BPF_B, BPF_REG_10, -128, 0),
+	BPF_RAW_INSN(BPF_JMP|BPF_CALL, 0, 1, 0, 1),
+	BPF_EXIT_INSN(),
+
+	/* prog 2 */
+	BPF_ST_MEM(BPF_B, BPF_REG_10, -64, 0),
+	BPF_RAW_INSN(BPF_JMP|BPF_CALL, 0, 1, 0, 1),
+	BPF_EXIT_INSN(),
+
+	/* prog 3, caller's stack depth < 256; we are free to introduce here new
+	 * stack frame which will be unwinded before the tailcall
+	 */
+	BPF_ST_MEM(BPF_B, BPF_REG_10, -192, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_tail_call),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.fixup_prog1 = { 8 },
+	.result = ACCEPT,
+	.retval = 42,
+},
 {
 	"calls: stack depth check using three frames. test1",
 	.insns = {
-- 
2.20.1

