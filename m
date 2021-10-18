Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C93F431A25
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhJRM5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:57:37 -0400
Received: from mail.loongson.cn ([114.242.206.163]:42716 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230526AbhJRM5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 08:57:32 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxb2qvbm1hiBEcAA--.29016S2;
        Mon, 18 Oct 2021 20:55:11 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xuefeng Li <lixuefeng@loongson.cn>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [PATCH bpf-next v6] test_bpf: Add module parameter test_suite
Date:   Mon, 18 Oct 2021 20:55:10 +0800
Message-Id: <1634561710-3648-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9Dxb2qvbm1hiBEcAA--.29016S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Cr4rWw1fGFyDXw1fWr1Dtrb_yoWkXF4DpF
        Wjqrn0yF18XF97XF48XF17Aa4FyF40v3y8KrWfJryqyrs5CryUtF48K34IqFn3Jr40vw15
        Z3W0vFs8G3W2yaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_Xr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
        VjvjDU0xZFpf9x0JUID73UUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 9298e63eafea ("bpf/tests: Add exhaustive tests of ALU
operand magnitudes"), when modprobe test_bpf.ko with jit on mips64,
there exists segment fault due to the following reason:

ALU64_MOV_X: all register value magnitudes jited:1
Break instruction in kernel code[#1]

It seems that the related jit implementations of some test cases
in test_bpf() have problems. At this moment, I do not care about
the segment fault while I just want to verify the test cases of
tail calls.

Based on the above background and motivation, add the following
module parameter test_suite to the test_bpf.ko:
test_suite=<string>: only the specified test suite will be run, the
string can be "test_bpf", "test_tail_calls" or "test_skb_segment".

If test_suite is not specified, but test_id, test_name or test_range
is specified, set 'test_bpf' as the default test suite.

This is useful to only test the corresponding test suite when specify
the valid test_suite string.

Any invalid test suite will result in -EINVAL being returned and no
tests being run. If the test_suite is not specified or specified as
empty string, it does not change the current logic, all of the test
cases will be run.

Here are some test results:
 # dmesg -c
 # modprobe test_bpf
 # dmesg | grep Summary
 test_bpf: Summary: 1009 PASSED, 0 FAILED, [0/997 JIT'ed]
 test_bpf: test_tail_calls: Summary: 8 PASSED, 0 FAILED, [0/8 JIT'ed]
 test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED

 # rmmod test_bpf
 # dmesg -c
 # modprobe test_bpf test_suite=test_bpf
 # dmesg | tail -1
 test_bpf: Summary: 1009 PASSED, 0 FAILED, [0/997 JIT'ed]

 # rmmod test_bpf
 # dmesg -c
 # modprobe test_bpf test_suite=test_tail_calls
 # dmesg
 test_bpf: #0 Tail call leaf jited:0 21 PASS
 [...]
 test_bpf: #7 Tail call error path, index out of range jited:0 32 PASS
 test_bpf: test_tail_calls: Summary: 8 PASSED, 0 FAILED, [0/8 JIT'ed]

 # rmmod test_bpf
 # dmesg -c
 # modprobe test_bpf test_suite=test_skb_segment
 # dmesg
 test_bpf: #0 gso_with_rx_frags PASS
 test_bpf: #1 gso_linear_no_head_frag PASS
 test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED

 # rmmod test_bpf
 # dmesg -c
 # modprobe test_bpf test_id=1
 # dmesg
 test_bpf: test_bpf: set 'test_bpf' as the default test_suite.
 test_bpf: #1 TXA jited:0 54 51 50 PASS
 test_bpf: Summary: 1 PASSED, 0 FAILED, [0/1 JIT'ed]

 # rmmod test_bpf
 # dmesg -c
 # modprobe test_bpf test_suite=test_bpf test_name=TXA
 # dmesg
 test_bpf: #1 TXA jited:0 54 50 51 PASS
 test_bpf: Summary: 1 PASSED, 0 FAILED, [0/1 JIT'ed]

 # rmmod test_bpf
 # dmesg -c
 # modprobe test_bpf test_suite=test_tail_calls test_range=6,7
 # dmesg
 test_bpf: #6 Tail call error path, NULL target jited:0 41 PASS
 test_bpf: #7 Tail call error path, index out of range jited:0 32 PASS
 test_bpf: test_tail_calls: Summary: 2 PASSED, 0 FAILED, [0/2 JIT'ed]

 # rmmod test_bpf
 # dmesg -c
 # modprobe test_bpf test_suite=test_skb_segment test_id=1
 # dmesg
 test_bpf: #1 gso_linear_no_head_frag PASS
 test_bpf: test_skb_segment: Summary: 1 PASSED, 0 FAILED

By the way, the above segment fault has been fixed in the latest bpf-next
tree.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---

v6:
  -- Compute the valid range once in the beginning of prepare_bpf_tests(),
     suggested by Johan Almbladh, thank you.

v5:
  -- Remove some duplicated code, suggested by Johan Almbladh,
     thank you.
  -- Initialize test_range[2] to {0, INT_MAX}.
  -- If test_suite is specified, but test_range is not specified,
     set the upper limit of each test_suite to overwrite INT_MAX.

v4:
  -- Fix the following checkpatch issues:
     CHECK: Alignment should match open parenthesis
     CHECK: Please don't use multiple blank lines

     ./scripts/checkpatch.pl --strict *.patch
     total: 0 errors, 0 warnings, 0 checks, 299 lines checked

     the default max-line-length is 100 in ./scripts/checkpatch.pl,
     but it seems that the netdev/checkpatch is 80:
     https://patchwork.hopto.org/static/nipa/559961/12545157/checkpatch/stdout

v3:
  -- Use test_suite instead of test_type as module parameter
  -- Make test_id, test_name and test_range selection applied to each test suite

v2:
  -- Fix typo in the commit message
  -- Use my private email to send

 lib/test_bpf.c | 230 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 154 insertions(+), 76 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index e5b10fd..06f9b66 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -14316,72 +14316,9 @@ module_param_string(test_name, test_name, sizeof(test_name), 0);
 static int test_id = -1;
 module_param(test_id, int, 0);
 
-static int test_range[2] = { 0, ARRAY_SIZE(tests) - 1 };
+static int test_range[2] = { 0, INT_MAX };
 module_param_array(test_range, int, NULL, 0);
 
-static __init int find_test_index(const char *test_name)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(tests); i++) {
-		if (!strcmp(tests[i].descr, test_name))
-			return i;
-	}
-	return -1;
-}
-
-static __init int prepare_bpf_tests(void)
-{
-	if (test_id >= 0) {
-		/*
-		 * if a test_id was specified, use test_range to
-		 * cover only that test.
-		 */
-		if (test_id >= ARRAY_SIZE(tests)) {
-			pr_err("test_bpf: invalid test_id specified.\n");
-			return -EINVAL;
-		}
-
-		test_range[0] = test_id;
-		test_range[1] = test_id;
-	} else if (*test_name) {
-		/*
-		 * if a test_name was specified, find it and setup
-		 * test_range to cover only that test.
-		 */
-		int idx = find_test_index(test_name);
-
-		if (idx < 0) {
-			pr_err("test_bpf: no test named '%s' found.\n",
-			       test_name);
-			return -EINVAL;
-		}
-		test_range[0] = idx;
-		test_range[1] = idx;
-	} else {
-		/*
-		 * check that the supplied test_range is valid.
-		 */
-		if (test_range[0] >= ARRAY_SIZE(tests) ||
-		    test_range[1] >= ARRAY_SIZE(tests) ||
-		    test_range[0] < 0 || test_range[1] < 0) {
-			pr_err("test_bpf: test_range is out of bound.\n");
-			return -EINVAL;
-		}
-
-		if (test_range[1] < test_range[0]) {
-			pr_err("test_bpf: test_range is ending before it starts.\n");
-			return -EINVAL;
-		}
-	}
-
-	return 0;
-}
-
-static __init void destroy_bpf_tests(void)
-{
-}
-
 static bool exclude_test(int test_id)
 {
 	return test_id < test_range[0] || test_id > test_range[1];
@@ -14553,6 +14490,10 @@ static __init int test_skb_segment(void)
 	for (i = 0; i < ARRAY_SIZE(skb_segment_tests); i++) {
 		const struct skb_segment_test *test = &skb_segment_tests[i];
 
+		cond_resched();
+		if (exclude_test(i))
+			continue;
+
 		pr_info("#%d %s ", i, test->descr);
 
 		if (test_skb_segment_single(test)) {
@@ -14934,6 +14875,8 @@ static __init int test_tail_calls(struct bpf_array *progs)
 		int ret;
 
 		cond_resched();
+		if (exclude_test(i))
+			continue;
 
 		pr_info("#%d %s ", i, test->descr);
 		if (!fp) {
@@ -14966,29 +14909,164 @@ static __init int test_tail_calls(struct bpf_array *progs)
 	return err_cnt ? -EINVAL : 0;
 }
 
+static char test_suite[32];
+module_param_string(test_suite, test_suite, sizeof(test_suite), 0);
+
+static __init int find_test_index(const char *test_name)
+{
+	int i;
+
+	if (!strcmp(test_suite, "test_bpf")) {
+		for (i = 0; i < ARRAY_SIZE(tests); i++) {
+			if (!strcmp(tests[i].descr, test_name))
+				return i;
+		}
+	}
+
+	if (!strcmp(test_suite, "test_tail_calls")) {
+		for (i = 0; i < ARRAY_SIZE(tail_call_tests); i++) {
+			if (!strcmp(tail_call_tests[i].descr, test_name))
+				return i;
+		}
+	}
+
+	if (!strcmp(test_suite, "test_skb_segment")) {
+		for (i = 0; i < ARRAY_SIZE(skb_segment_tests); i++) {
+			if (!strcmp(skb_segment_tests[i].descr, test_name))
+				return i;
+		}
+	}
+
+	return -1;
+}
+
+static __init int prepare_bpf_tests(void)
+{
+	int valid_range;
+
+	if (!strcmp(test_suite, "test_bpf"))
+		valid_range = ARRAY_SIZE(tests);
+	else if (!strcmp(test_suite, "test_tail_calls"))
+		valid_range = ARRAY_SIZE(tail_call_tests);
+	else if (!strcmp(test_suite, "test_skb_segment"))
+		valid_range = ARRAY_SIZE(skb_segment_tests);
+
+	if (test_id >= 0) {
+		/*
+		 * if a test_id was specified, use test_range to
+		 * cover only that test.
+		 */
+		if (test_id >= valid_range) {
+			pr_err("test_bpf: invalid test_id specified for '%s' suite.\n",
+			       test_suite);
+			return -EINVAL;
+		}
+
+		test_range[0] = test_id;
+		test_range[1] = test_id;
+	} else if (*test_name) {
+		/*
+		 * if a test_name was specified, find it and setup
+		 * test_range to cover only that test.
+		 */
+		int idx = find_test_index(test_name);
+
+		if (idx < 0) {
+			pr_err("test_bpf: no test named '%s' found for '%s' suite.\n",
+			       test_name, test_suite);
+			return -EINVAL;
+		}
+		test_range[0] = idx;
+		test_range[1] = idx;
+	} else {
+		/*
+		 * check that the supplied test_range is valid.
+		 */
+		if (strlen(test_suite)) {
+			if (test_range[0] >= valid_range ||
+			    test_range[1] >= valid_range ||
+			    test_range[0] < 0 || test_range[1] < 0) {
+				pr_err("test_bpf: test_range is out of bound for '%s' suite.\n",
+				       test_suite);
+				return -EINVAL;
+			}
+		}
+
+		if (test_range[1] < test_range[0]) {
+			pr_err("test_bpf: test_range is ending before it starts.\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static __init void destroy_bpf_tests(void)
+{
+}
+
 static int __init test_bpf_init(void)
 {
 	struct bpf_array *progs = NULL;
 	int ret;
 
+	if (strlen(test_suite) &&
+	    strcmp(test_suite, "test_bpf") &&
+	    strcmp(test_suite, "test_tail_calls") &&
+	    strcmp(test_suite, "test_skb_segment")) {
+		pr_err("test_bpf: invalid test_suite '%s' specified.\n", test_suite);
+		return -EINVAL;
+	}
+
+	/*
+	 * if test_suite is not specified, but test_id, test_name or test_range
+	 * is specified, set 'test_bpf' as the default test suite.
+	 */
+	if (!strlen(test_suite) &&
+	    (test_id != -1 || strlen(test_name) ||
+	    (test_range[0] != 0 || test_range[1] != INT_MAX))) {
+		pr_info("test_bpf: set 'test_bpf' as the default test_suite.\n");
+		strcpy(test_suite, "test_bpf");
+	}
+
+	/*
+	 * if test_suite is specified, but test_range is not specified,
+	 * set the upper limit of each test_suite to overwrite INT_MAX.
+	 */
+	if (strlen(test_suite) && test_range[0] == 0 && test_range[1] == INT_MAX) {
+		if (!strcmp(test_suite, "test_bpf"))
+			test_range[1] = ARRAY_SIZE(tests) - 1;
+		else if (!strcmp(test_suite, "test_tail_calls"))
+			test_range[1] = ARRAY_SIZE(tail_call_tests) - 1;
+		else if (!strcmp(test_suite, "test_skb_segment"))
+			test_range[1] = ARRAY_SIZE(skb_segment_tests) - 1;
+	}
+
 	ret = prepare_bpf_tests();
 	if (ret < 0)
 		return ret;
 
-	ret = test_bpf();
-	destroy_bpf_tests();
-	if (ret)
-		return ret;
+	if (!strlen(test_suite) || !strcmp(test_suite, "test_bpf")) {
+		ret = test_bpf();
+		destroy_bpf_tests();
+		if (ret)
+			return ret;
+	}
 
-	ret = prepare_tail_call_tests(&progs);
-	if (ret)
-		return ret;
-	ret = test_tail_calls(progs);
-	destroy_tail_call_tests(progs);
-	if (ret)
-		return ret;
+	if (!strlen(test_suite) || !strcmp(test_suite, "test_tail_calls")) {
+		ret = prepare_tail_call_tests(&progs);
+		if (ret)
+			return ret;
+		ret = test_tail_calls(progs);
+		destroy_tail_call_tests(progs);
+		if (ret)
+			return ret;
+	}
 
-	return test_skb_segment();
+	if (!strlen(test_suite) || !strcmp(test_suite, "test_skb_segment"))
+		return test_skb_segment();
+
+	return 0;
 }
 
 static void __exit test_bpf_exit(void)
-- 
2.1.0

