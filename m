Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CE63F3A8D
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 14:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhHUMOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 08:14:54 -0400
Received: from mail.loongson.cn ([114.242.206.163]:53002 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234466AbhHUMOx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 08:14:53 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx30EH7iBhLFozAA--.19387S2;
        Sat, 21 Aug 2021 20:14:00 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] bpf: test_bpf: Print total time of test in the summary
Date:   Sat, 21 Aug 2021 20:13:59 +0800
Message-Id: <1629548039-3747-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9Dx30EH7iBhLFozAA--.19387S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar17Ary3ur1UtrWxtw1UKFg_yoW8Kw45pF
        WYg3s2gw45ta1fuFyxJFWUtF4fKFW0k3yfCryxG34Yyan3Kw1jqF48tryFvrySy3yFqr4a
        y3W0yrW5CF1fKaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvlb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
        C2z280aVCY1x0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kI
        c2xKxwCY02Avz4vE14v_Xr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
        DU0xZFpf9x07jcPE-UUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The total time of test is useful to compare the performance
when bpf_jit_enable is 0 or 1, so print it in the summary.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 lib/test_bpf.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 830a18e..b1b17ba 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -8920,6 +8920,9 @@ static __init int test_skb_segment_single(const struct skb_segment_test *test)
 static __init int test_skb_segment(void)
 {
 	int i, err_cnt = 0, pass_cnt = 0;
+	u64 start, finish;
+
+	start = ktime_get_ns();
 
 	for (i = 0; i < ARRAY_SIZE(skb_segment_tests); i++) {
 		const struct skb_segment_test *test = &skb_segment_tests[i];
@@ -8935,8 +8938,10 @@ static __init int test_skb_segment(void)
 		}
 	}
 
-	pr_info("%s: Summary: %d PASSED, %d FAILED\n", __func__,
-		pass_cnt, err_cnt);
+	finish = ktime_get_ns();
+
+	pr_info("%s: Summary: %d PASSED, %d FAILED in %llu nsec\n",
+		__func__, pass_cnt, err_cnt, finish - start);
 	return err_cnt ? -EINVAL : 0;
 }
 
@@ -8944,6 +8949,9 @@ static __init int test_bpf(void)
 {
 	int i, err_cnt = 0, pass_cnt = 0;
 	int jit_cnt = 0, run_cnt = 0;
+	u64 start, finish;
+
+	start = ktime_get_ns();
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		struct bpf_prog *fp;
@@ -8983,8 +8991,10 @@ static __init int test_bpf(void)
 		}
 	}
 
-	pr_info("Summary: %d PASSED, %d FAILED, [%d/%d JIT'ed]\n",
-		pass_cnt, err_cnt, jit_cnt, run_cnt);
+	finish = ktime_get_ns();
+
+	pr_info("Summary: %d PASSED, %d FAILED, [%d/%d JIT'ed] in %llu nsec\n",
+		pass_cnt, err_cnt, jit_cnt, run_cnt, finish - start);
 
 	return err_cnt ? -EINVAL : 0;
 }
@@ -9192,6 +9202,9 @@ static __init int test_tail_calls(struct bpf_array *progs)
 {
 	int i, err_cnt = 0, pass_cnt = 0;
 	int jit_cnt = 0, run_cnt = 0;
+	u64 start, finish;
+
+	start = ktime_get_ns();
 
 	for (i = 0; i < ARRAY_SIZE(tail_call_tests); i++) {
 		struct tail_call_test *test = &tail_call_tests[i];
@@ -9222,8 +9235,10 @@ static __init int test_tail_calls(struct bpf_array *progs)
 		}
 	}
 
-	pr_info("%s: Summary: %d PASSED, %d FAILED, [%d/%d JIT'ed]\n",
-		__func__, pass_cnt, err_cnt, jit_cnt, run_cnt);
+	finish = ktime_get_ns();
+
+	pr_info("%s: Summary: %d PASSED, %d FAILED, [%d/%d JIT'ed] in %llu nsec\n",
+		__func__, pass_cnt, err_cnt, jit_cnt, run_cnt, finish - start);
 
 	return err_cnt ? -EINVAL : 0;
 }
-- 
2.1.0

