Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EC23F5662
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 05:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhHXDDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 23:03:13 -0400
Received: from mail.loongson.cn ([114.242.206.163]:55966 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234677AbhHXDB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 23:01:56 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxv0PjYCRhtVU0AA--.4468S2;
        Tue, 24 Aug 2021 11:00:52 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
Subject: [PATCH bpf-next v2] bpf: test_bpf: Print total time of test in the summary
Date:   Tue, 24 Aug 2021 11:00:50 +0800
Message-Id: <1629774050-4048-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9Dxv0PjYCRhtVU0AA--.4468S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCr1rWF4xZw4rAr13KF4xCrg_yoW5GF15pF
        W5Kas2kr1Utay3W347AF1DtF43tFWxta97Cry7G34YyFs3tr1jqF48try0vr9xC39Yv3W3
        A3W0yrW7CryrA3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F
        4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
        628vn2kIc2xKxwCY02Avz4vE14v_Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
        1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
        AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0D
        MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
        VFxhVjvjDU0xZFpf9x0JUa0PhUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The total time of test is useful to compare the performance
when bpf_jit_enable is 0 or 1, so print it in the summary.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 lib/test_bpf.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 830a18e..37f49b7 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -8627,9 +8627,10 @@ static int __run_one(const struct bpf_prog *fp, const void *data,
 	return ret;
 }
 
-static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
+static int run_one(const struct bpf_prog *fp, struct bpf_test *test, u64 *run_one_time)
 {
 	int err_cnt = 0, i, runs = MAX_TESTRUNS;
+	u64 time = 0;
 
 	for (i = 0; i < MAX_SUBTESTS; i++) {
 		void *data;
@@ -8663,8 +8664,12 @@ static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
 				test->test[i].result);
 			err_cnt++;
 		}
+
+		time += duration;
 	}
 
+	*run_one_time = time;
+
 	return err_cnt;
 }
 
@@ -8944,9 +8949,11 @@ static __init int test_bpf(void)
 {
 	int i, err_cnt = 0, pass_cnt = 0;
 	int jit_cnt = 0, run_cnt = 0;
+	u64 total_time = 0;
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		struct bpf_prog *fp;
+		u64 run_one_time;
 		int err;
 
 		cond_resched();
@@ -8971,7 +8978,7 @@ static __init int test_bpf(void)
 		if (fp->jited)
 			jit_cnt++;
 
-		err = run_one(fp, &tests[i]);
+		err = run_one(fp, &tests[i], &run_one_time);
 		release_filter(fp, i);
 
 		if (err) {
@@ -8981,10 +8988,12 @@ static __init int test_bpf(void)
 			pr_cont("PASS\n");
 			pass_cnt++;
 		}
+
+		total_time += run_one_time;
 	}
 
-	pr_info("Summary: %d PASSED, %d FAILED, [%d/%d JIT'ed]\n",
-		pass_cnt, err_cnt, jit_cnt, run_cnt);
+	pr_info("Summary: %d PASSED, %d FAILED, [%d/%d JIT'ed] in %llu nsec\n",
+		pass_cnt, err_cnt, jit_cnt, run_cnt, total_time);
 
 	return err_cnt ? -EINVAL : 0;
 }
@@ -9192,6 +9201,7 @@ static __init int test_tail_calls(struct bpf_array *progs)
 {
 	int i, err_cnt = 0, pass_cnt = 0;
 	int jit_cnt = 0, run_cnt = 0;
+	u64 total_time = 0;
 
 	for (i = 0; i < ARRAY_SIZE(tail_call_tests); i++) {
 		struct tail_call_test *test = &tail_call_tests[i];
@@ -9220,10 +9230,12 @@ static __init int test_tail_calls(struct bpf_array *progs)
 			pr_cont("ret %d != %d FAIL", ret, test->result);
 			err_cnt++;
 		}
+
+		total_time += duration;
 	}
 
-	pr_info("%s: Summary: %d PASSED, %d FAILED, [%d/%d JIT'ed]\n",
-		__func__, pass_cnt, err_cnt, jit_cnt, run_cnt);
+	pr_info("%s: Summary: %d PASSED, %d FAILED, [%d/%d JIT'ed] in %llu nsec\n",
+		__func__, pass_cnt, err_cnt, jit_cnt, run_cnt, total_time);
 
 	return err_cnt ? -EINVAL : 0;
 }
-- 
2.1.0

