Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7B1405FF8
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 01:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348945AbhIIXVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 19:21:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:48290 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbhIIXVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 19:21:46 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mOTLI-000FQ5-5O; Fri, 10 Sep 2021 01:20:28 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mOTLH-000Rzk-Re; Fri, 10 Sep 2021 01:20:27 +0200
Subject: Re: Actual tail call count limits in x86 JITs and interpreter
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Paul Chaignon <paul@cilium.io>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <CAM1=_QRyRVCODcXo_Y6qOm1iT163HoiSj8U2pZ8Rj3hzMTT=HQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f79a0ea1-fa20-82e1-71bd-f3a9f9e946ec@iogearbox.net>
Date:   Fri, 10 Sep 2021 01:20:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAM1=_QRyRVCODcXo_Y6qOm1iT163HoiSj8U2pZ8Rj3hzMTT=HQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------4F1BF1A3FD060DAEA711EF56"
Content-Language: en-US
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26289/Thu Sep  9 10:20:35 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------4F1BF1A3FD060DAEA711EF56
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/21 12:15 AM, Johan Almbladh wrote:
> I have done some investigation into this matter, and this is what I
> have found. To recap, the situation is as follows.
> 
> MAX_TAIL_CALL_CNT is defined to be 32. Since the interpreter has used
> 33 instead, we agree to use that limit across all JIT implementations
> to not break any user space program. To make sure everything uses the
> same limit, we must first understand what the current state actually
> is so we know what to fix.
> 
> Me: according to test_bpf.ko the tail call limit is 33 for the
> interpreter, and 32 for the x86-64 JIT.
> Paul: according to selftests the tail call limit is 33 for both the
> interpreter and the x86-64 JIT.
> 
> Link: https://lore.kernel.org/bpf/20210809093437.876558-1-johan.almbladh@anyfinetworks.com/
> 
> I have been able to reproduce the above selftests results using
> vmtest.sh. Digging deeper into this, I found that there are actually
> two different code paths where the tail call count is checked in the
> x86-64 JIT, corresponding to direct and indirect tail calls. By
> setting different limits in those two places, I found that selftests
> tailcall_3 hits the limit in emit_bpf_tail_call_direct(), whereas the
> test_bpf.ko is limited by emit_bpf_tail_call_indirect().

I hacked a quick test case so that both are covered, see attached. Both
have the same behavior from my testing with and without the x86-64 JIT.
Bit late over here, will check more tomorrow, but in both cases we also
emit the same JIT code wrt counter update..

> I am not 100% sure that this is the correct explanation, but it sounds
> very reasonable. However, the asm generated in the two cases look very
> similar to me, so by looking at that alone I cannot really see that
> the limits would be different. Perhaps someone more versed in x86 asm
> could take a closer look.
> 
> What are your thoughts?
> 
> Johan
> 


--------------4F1BF1A3FD060DAEA711EF56
Content-Type: text/x-patch;
 name="0001-bpf-selftests-Replicate-tailcall_3-limit-test-for-in.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-bpf-selftests-Replicate-tailcall_3-limit-test-for-in.pa";
 filename*1="tch"

From c68f8e699a639392f24244068c1b49389f67f302 Mon Sep 17 00:00:00 2001
From: Daniel Borkmann <daniel@iogearbox.net>
Date: Thu, 9 Sep 2021 22:55:13 +0000
Subject: [PATCH bpf-next] bpf, selftests: Replicate tailcall_3 limit test for indirect call case

The tailcall_3 test program uses bpf_tail_call_static() where the JIT
would patch a direct jump. Add a new tailcall_6 test program replicating
exactly the same test just ensuring that bpf_tail_call() uses a map index
where the verifier cannot make assumptions this time. In other words this
will now cover both on x86-64 JIT, emit_bpf_tail_call_direct() emission
as well as emit_bpf_tail_call_indirect() emission.

  # ./test_progs -t tailcalls
  #136/1 tailcalls/tailcall_1:OK
  #136/2 tailcalls/tailcall_2:OK
  #136/3 tailcalls/tailcall_3:OK
  #136/4 tailcalls/tailcall_4:OK
  #136/5 tailcalls/tailcall_5:OK
  #136/6 tailcalls/tailcall_6:OK
  #136/7 tailcalls/tailcall_bpf2bpf_1:OK
  #136/8 tailcalls/tailcall_bpf2bpf_2:OK
  #136/9 tailcalls/tailcall_bpf2bpf_3:OK
  #136/10 tailcalls/tailcall_bpf2bpf_4:OK
  #136/11 tailcalls/tailcall_bpf2bpf_5:OK
  #136 tailcalls:OK
  Summary: 1/11 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc: Paul Chaignon <paul@cilium.io>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 .../selftests/bpf/prog_tests/tailcalls.c      | 25 ++++++++++---
 tools/testing/selftests/bpf/progs/tailcall6.c | 36 +++++++++++++++++++
 2 files changed, 56 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall6.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tailcalls.c b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
index b5940e6ca67c..7bf3a7a97d7b 100644
--- a/tools/testing/selftests/bpf/prog_tests/tailcalls.c
+++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
@@ -219,10 +219,7 @@ static void test_tailcall_2(void)
 	bpf_object__close(obj);
 }
 
-/* test_tailcall_3 checks that the count value of the tail call limit
- * enforcement matches with expectations.
- */
-static void test_tailcall_3(void)
+static void test_tailcall_count(const char *which)
 {
 	int err, map_fd, prog_fd, main_fd, data_fd, i, val;
 	struct bpf_map *prog_array, *data_map;
@@ -231,7 +228,7 @@ static void test_tailcall_3(void)
 	__u32 retval, duration;
 	char buff[128] = {};
 
-	err = bpf_prog_load("tailcall3.o", BPF_PROG_TYPE_SCHED_CLS, &obj,
+	err = bpf_prog_load(which, BPF_PROG_TYPE_SCHED_CLS, &obj,
 			    &prog_fd);
 	if (CHECK_FAIL(err))
 		return;
@@ -296,6 +293,22 @@ static void test_tailcall_3(void)
 	bpf_object__close(obj);
 }
 
+/* test_tailcall_3 checks that the count value of the tail call limit
+ * enforcement matches with expectations. JIT uses direct jump.
+ */
+static void test_tailcall_3(void)
+{
+	test_tailcall_count("tailcall3.o");
+}
+
+/* test_tailcall_6 checks that the count value of the tail call limit
+ * enforcement matches with expectations. JIT uses indirect jump.
+ */
+static void test_tailcall_6(void)
+{
+	test_tailcall_count("tailcall6.o");
+}
+
 /* test_tailcall_4 checks that the kernel properly selects indirect jump
  * for the case where the key is not known. Latter is passed via global
  * data to select different targets we can compare return value of.
@@ -822,6 +835,8 @@ void test_tailcalls(void)
 		test_tailcall_4();
 	if (test__start_subtest("tailcall_5"))
 		test_tailcall_5();
+	if (test__start_subtest("tailcall_6"))
+		test_tailcall_6();
 	if (test__start_subtest("tailcall_bpf2bpf_1"))
 		test_tailcall_bpf2bpf_1();
 	if (test__start_subtest("tailcall_bpf2bpf_2"))
diff --git a/tools/testing/selftests/bpf/progs/tailcall6.c b/tools/testing/selftests/bpf/progs/tailcall6.c
new file mode 100644
index 000000000000..9c298d908693
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tailcall6.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} jmp_table SEC(".maps");
+
+int count = 0;
+volatile int which;
+
+SEC("classifier/0")
+int bpf_func_0(struct __sk_buff *skb)
+{
+	count++;
+	if (__builtin_constant_p(which))
+		__bpf_unreachable();
+	bpf_tail_call(skb, &jmp_table, which);
+	return 1;
+}
+
+SEC("classifier")
+int entry(struct __sk_buff *skb)
+{
+	if (__builtin_constant_p(which))
+		__bpf_unreachable();
+	bpf_tail_call(skb, &jmp_table, which);
+	return 0;
+}
+
+char __license[] SEC("license") = "GPL";
+int _version SEC("version") = 1;
-- 
2.27.0


--------------4F1BF1A3FD060DAEA711EF56--
