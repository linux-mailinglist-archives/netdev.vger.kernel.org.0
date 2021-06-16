Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C873AA71A
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhFPW6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbhFPW6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 18:58:20 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67697C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 15:56:11 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id 5so997172ioe.1
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 15:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=3DLASFQ15Z81rloOq6n84/zQvsm6YmqeDbgPpYmXx0A=;
        b=p1wQF/DPc15yWjfECOkMCxK5ue6n1s4xTNEUohTbIgU7wHjjfk0rnvsCAOTsNa33tg
         +0/KFTiwv7HeYU9FGPUyzNgZcDJV8nnp4IIxmv7uloSIbdNlb/GsENI7mA4IUS2JrkvW
         kiu+5zaTJoFM/qYk2Bwua3yvFYp6zHewknSGo8Adf0kaCxPp+5X9HYUNgNYSlVqYgPKg
         wOO+lZLOzPExHWxubDDJgp2dmKPIu7iU5gpk5HaVK7SuauTKtuKmNMjCBci/W8kjitns
         s2u3Y77cC30WBk5n4ZpNOL8YUhlktqBlh85NMeFBOVVccbAtlUd4loSxCspSmXqIK1q/
         SaSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=3DLASFQ15Z81rloOq6n84/zQvsm6YmqeDbgPpYmXx0A=;
        b=F7X/S5oletRuqRXB7HaE3Q4BnpJ6ve9f7euGIiNJtKhSrP1McsQxR/0fRO59W9XsVg
         qCjsw/ZWIZmzSn1fwmhxlKaXTLm05r9V0kjdMSlpuKVP7r+V7hqM+gMQaxU0enVjfZH+
         UbnBYdpg34D8AbutMalln2bsKvHvVF8VZCQZUF4XmGWy2NHlkQ3SUO2Ik2CPq3B037dW
         Q0RfQ9NwIHoOyi91qLfdN08K2grcNz+Lr4X7KVEuTeEhDXyFCAGqu3aTsXfwj8Nt8ilm
         4FIXEVXhdH6YQj0jYBEbqwUJnRWme65FPZO/r0klC+d/WPQ8YqfoO0MUb8+8WmpL8cqd
         uaFg==
X-Gm-Message-State: AOAM531nMq3z+ZZkuhGzz7RAivYC8MOrFlibZK/uD99h5d9/2JJNUAyK
        XmyBZo4fv9OfryWN/t3UcuM=
X-Google-Smtp-Source: ABdhPJyCVBdgBagf/DYUJEryH3KtpkoowCnB39rkVTChGwAaMpZuF5JE40FUYwysgY37xhoLFjbv/A==
X-Received: by 2002:a05:6602:2a43:: with SMTP id k3mr1314309iov.47.1623884170683;
        Wed, 16 Jun 2021 15:56:10 -0700 (PDT)
Received: from [127.0.1.1] ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id n2sm1908745iod.54.2021.06.16.15.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 15:56:10 -0700 (PDT)
Subject: [PATCH bpf v2 4/4] bpf: selftest to verify mixing bpf2bpf calls and
 tailcalls with insn patch
From:   John Fastabend <john.fastabend@gmail.com>
To:     maciej.fijalkowski@intel.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Wed, 16 Jun 2021 15:55:57 -0700
Message-ID: <162388415754.151936.11542697725599301296.stgit@john-XPS-13-9370>
In-Reply-To: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
References: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-85-g6af9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |   36 ++++++++++++++------
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |   20 +++++++++++
 2 files changed, 45 insertions(+), 11 deletions(-)

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
index 9a1b166b7fbe..e89368a50b97 100644
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
@@ -9,11 +16,22 @@ struct {
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


