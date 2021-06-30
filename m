Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971A83B893F
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 21:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhF3Tnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 15:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhF3Tnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 15:43:50 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465E3C061756;
        Wed, 30 Jun 2021 12:41:20 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id a11so4065437ilf.2;
        Wed, 30 Jun 2021 12:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RAsH87Dl+Xk0ALZXtlUT1irdqz1tbP3ucQOTTRoeFs4=;
        b=MvKovCzQIpJPwDwCTgWf3mzCizTGYye7z6NMI/mRHbKSS4JwCSNDx+XnKOF9DvAa8p
         FUUY0cI2oCUnwSTqWrwIf/w+eufhLABoxK2pC8+8gEpawHpF7CEUqFedUh1i7S9+Mhz+
         e2ntE5+hcHHDfxYKTY5MlIf8umfgOFEjJor7FsNkGTD+uHDmLevxlmgRVkSbtbmUbIsl
         GR58GydoULzlWwjszlzMYdz5Z33GcC2XkzR1ydLbzM0a3EZfC/JpPu8kb+PCnkTtKmrE
         LLSMBuSfp/kPw7X3BKQ5pElvNQh9X8HUF7qnF2ZO+o/Rut/hCkBWIF4EMpOqAGpiMPzj
         Oj9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RAsH87Dl+Xk0ALZXtlUT1irdqz1tbP3ucQOTTRoeFs4=;
        b=kz5+52On3IVxZFPbszDGYkH2vlgmjkivUrAVWKWp/SSWIbG8jQOLythAtD7ZlaaFVy
         8sBHaiLHwvmjLRw6A5yth6ATNCyjoq4/0wePrDNAPZ5R8eyI194wPstXLIuNe8O4/YUZ
         X9fEUrR0hMUTRM627koQuxgRnoI2V+7aULG5rAvuB8ZLNOjcws8LCypY+i52TAVNguzy
         pgqPh8/W4iFFGW8X/brVFNNW1lVy/QuWsR5ln5yOB5Mz8HkbBzHKUOjITcLOik3ckOJA
         r17irK5W1o7FeTbjlllHB8xIwoj7aZFMH2wrY7hQNLG9yiSzWM3by3IxWSmGxgLwEFhv
         n7EA==
X-Gm-Message-State: AOAM530Z0Zoi1oSqE6VFzkWE/HicDqdwLZmy7lvnTX+WCv0zQ80zg2Vg
        iPKPC40xtbPI3tAl/t5gJmQ=
X-Google-Smtp-Source: ABdhPJwNji68GXhD+fKEaUZxdk9EU4NrU9JhRRADZUCb6SeV4EH3aZUFwjDm3ouOl04nuTmAju7h7A==
X-Received: by 2002:a05:6e02:10c2:: with SMTP id s2mr26975794ilj.24.1625082079731;
        Wed, 30 Jun 2021 12:41:19 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id p9sm10977680iod.48.2021.06.30.12.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 12:41:19 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     maciej.fijalkowski@intel.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf 2/2] bpf: selftest to verify mixing bpf2bpf calls and tailcalls with insn patch
Date:   Wed, 30 Jun 2021 12:40:49 -0700
Message-Id: <20210630194049.46453-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210630194049.46453-1-john.fastabend@gmail.com>
References: <20210630194049.46453-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds some extra noise to the tailcall_bpf2bpf4 tests that will cause
verify to patch insns. This then moves around subprog start/end insn
index and poke descriptor insn index to ensure that verify and JIT will
continue to track these correctly.

If done correctly verifier should pass this program same as before and
JIT should emit tail call logic.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/tailcalls.c      | 36 +++++++++++++------
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c   | 21 ++++++++++-
 2 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tailcalls.c b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
index ee27d68d2a1c..b5940e6ca67c 100644
--- a/tools/testing/selftests/bpf/prog_tests/tailcalls.c
+++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
@@ -715,6 +715,8 @@ static void test_tailcall_bpf2bpf_3(void)
 	bpf_object__close(obj);
 }
 
+#include "tailcall_bpf2bpf4.skel.h"
+
 /* test_tailcall_bpf2bpf_4 checks that tailcall counter is correctly preserved
  * across tailcalls combined with bpf2bpf calls. for making sure that tailcall
  * counter behaves correctly, bpf program will go through following flow:
@@ -727,10 +729,15 @@ static void test_tailcall_bpf2bpf_3(void)
  * the loop begins. At the end of the test make sure that the global counter is
  * equal to 31, because tailcall counter includes the first two tailcalls
  * whereas global counter is incremented only on loop presented on flow above.
+ *
+ * The noise parameter is used to insert bpf_map_update calls into the logic
+ * to force verifier to patch instructions. This allows us to ensure jump
+ * logic remains correct with instruction movement.
  */
-static void test_tailcall_bpf2bpf_4(void)
+static void test_tailcall_bpf2bpf_4(bool noise)
 {
-	int err, map_fd, prog_fd, main_fd, data_fd, i, val;
+	int err, map_fd, prog_fd, main_fd, data_fd, i;
+	struct tailcall_bpf2bpf4__bss val;
 	struct bpf_map *prog_array, *data_map;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
@@ -774,11 +781,6 @@ static void test_tailcall_bpf2bpf_4(void)
 			goto out;
 	}
 
-	err = bpf_prog_test_run(main_fd, 1, &pkt_v4, sizeof(pkt_v4), 0,
-				&duration, &retval, NULL);
-	CHECK(err || retval != sizeof(pkt_v4) * 3, "tailcall", "err %d errno %d retval %d\n",
-	      err, errno, retval);
-
 	data_map = bpf_object__find_map_by_name(obj, "tailcall.bss");
 	if (CHECK_FAIL(!data_map || !bpf_map__is_internal(data_map)))
 		return;
@@ -787,10 +789,22 @@ static void test_tailcall_bpf2bpf_4(void)
 	if (CHECK_FAIL(map_fd < 0))
 		return;
 
+	i = 0;
+	val.noise = noise;
+	val.count = 0;
+	err = bpf_map_update_elem(data_fd, &i, &val, BPF_ANY);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	err = bpf_prog_test_run(main_fd, 1, &pkt_v4, sizeof(pkt_v4), 0,
+				&duration, &retval, NULL);
+	CHECK(err || retval != sizeof(pkt_v4) * 3, "tailcall", "err %d errno %d retval %d\n",
+	      err, errno, retval);
+
 	i = 0;
 	err = bpf_map_lookup_elem(data_fd, &i, &val);
-	CHECK(err || val != 31, "tailcall count", "err %d errno %d count %d\n",
-	      err, errno, val);
+	CHECK(err || val.count != 31, "tailcall count", "err %d errno %d count %d\n",
+	      err, errno, val.count);
 
 out:
 	bpf_object__close(obj);
@@ -815,5 +829,7 @@ void test_tailcalls(void)
 	if (test__start_subtest("tailcall_bpf2bpf_3"))
 		test_tailcall_bpf2bpf_3();
 	if (test__start_subtest("tailcall_bpf2bpf_4"))
-		test_tailcall_bpf2bpf_4();
+		test_tailcall_bpf2bpf_4(false);
+	if (test__start_subtest("tailcall_bpf2bpf_5"))
+		test_tailcall_bpf2bpf_4(true);
 }
diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
index 9a1b166b7fbe..6242803dabde 100644
--- a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
+++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
@@ -2,6 +2,13 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} nop_table SEC(".maps");
+
 struct {
 	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
 	__uint(max_entries, 3);
@@ -9,11 +16,23 @@ struct {
 	__uint(value_size, sizeof(__u32));
 } jmp_table SEC(".maps");
 
-static volatile int count;
+int count = 0;
+int noise = 0;
+
+__always_inline int subprog_noise(void)
+{
+	__u32 key = 0;
+
+	bpf_printk("hello noisy subprog %d\n", key);
+	bpf_map_lookup_elem(&nop_table, &key);
+	return 0;
+}
 
 __noinline
 int subprog_tail_2(struct __sk_buff *skb)
 {
+	if (noise)
+		subprog_noise();
 	bpf_tail_call_static(skb, &jmp_table, 2);
 	return skb->len * 3;
 }
-- 
2.25.1

