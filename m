Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF223102F9
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 03:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBECui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 21:50:38 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12129 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhBECui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 21:50:38 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DX0Gq0ZSZz164Hm;
        Fri,  5 Feb 2021 10:48:35 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Fri, 5 Feb 2021
 10:49:45 +0800
From:   wanghongzhe <wanghongzhe@huawei.com>
To:     <keescook@chromium.org>, <luto@amacapital.net>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <songliubraving@fb.com>,
        <wad@chromium.org>, <wanghongzhe@huawei.com>, <yhs@fb.com>
Subject: [PATCH v2] seccomp: Improve performace by optimizing rmb()
Date:   Fri, 5 Feb 2021 11:34:09 +0800
Message-ID: <1612496049-32507-1-git-send-email-wanghongzhe@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to kees's suggest, we started with the patch that just replaces
rmb() with smp_rmb() and did a performace test with UnixBench. The results 
showed the overhead about 2.53% in rmb() test compared to the smp_rmb() 
one, in a x86-64 kernel with CONFIG_SMP enabled running inside a qemu-kvm 
vm. The test is a "syscall" testcase in UnixBench, which executes 5 
syscalls in a loop during a certain timeout (100 second in our test) and 
counts the total number of executions of this 5-syscall sequence. We set a 
seccomp filter with all allow rule for all used syscalls in this test 
(which will go bitmap path) to make sure the rmb() will be executed. The 
details for the test:

with rmb():
/txm # ./syscall_allow_min 100
COUNT|35861159|1|lps
/txm # ./syscall_allow_min 100
COUNT|35545501|1|lps
/txm # ./syscall_allow_min 100
COUNT|35664495|1|lps

with smp_rmb():
/txm # ./syscall_allow_min 100
COUNT|36552771|1|lps
/txm # ./syscall_allow_min 100
COUNT|36491247|1|lps
/txm # ./syscall_allow_min 100
COUNT|36504746|1|lps

For a x86-64 kernel with CONFIG_SMP enabled, the smp_rmb() is just a 
compiler barrier() which have no impact in runtime, while rmb() is a 
lfence which will prevent all memory access operations (not just load 
according the recently claim by Intel) behind itself. We can also figure 
it out in disassembly:

with rmb():
0000000000001430 <__seccomp_filter>:
    1430:   41 57                   push   %r15
    1432:   41 56                   push   %r14
    1434:   41 55                   push   %r13
    1436:   41 54                   push   %r12
    1438:   55                      push   %rbp
    1439:   53                      push   %rbx
    143a:   48 81 ec 90 00 00 00    sub    $0x90,%rsp
    1441:   89 7c 24 10             mov    %edi,0x10(%rsp)
    1445:   89 54 24 14             mov    %edx,0x14(%rsp)
    1449:   65 48 8b 04 25 28 00    mov    %gs:0x28,%rax
    1450:   00 00
    1452:   48 89 84 24 88 00 00    mov    %rax,0x88(%rsp)
    1459:   00
    145a:   31 c0                   xor    %eax,%eax
*   145c:   0f ae e8                lfence
    145f:   48 85 f6                test   %rsi,%rsi
    1462:   49 89 f4                mov    %rsi,%r12
    1465:   0f 84 42 03 00 00       je     17ad <__seccomp_filter+0x37d>
    146b:   65 48 8b 04 25 00 00    mov    %gs:0x0,%rax
    1472:   00 00
    1474:   48 8b 98 80 07 00 00    mov    0x780(%rax),%rbx
    147b:   48 85 db                test   %rbx,%rbx

with smp_rmb();
0000000000001430 <__seccomp_filter>:
    1430:   41 57                   push   %r15
    1432:   41 56                   push   %r14
    1434:   41 55                   push   %r13
    1436:   41 54                   push   %r12
    1438:   55                      push   %rbp
    1439:   53                      push   %rbx
    143a:   48 81 ec 90 00 00 00    sub    $0x90,%rsp
    1441:   89 7c 24 10             mov    %edi,0x10(%rsp)
    1445:   89 54 24 14             mov    %edx,0x14(%rsp)
    1449:   65 48 8b 04 25 28 00    mov    %gs:0x28,%rax
    1450:   00 00
    1452:   48 89 84 24 88 00 00    mov    %rax,0x88(%rsp)
    1459:   00
    145a:   31 c0                   xor    %eax,%eax
    145c:   48 85 f6                test   %rsi,%rsi
    145f:   49 89 f4                mov    %rsi,%r12
    1462:   0f 84 42 03 00 00       je     17aa <__seccomp_filter+0x37a>
    1468:   65 48 8b 04 25 00 00    mov    %gs:0x0,%rax
    146f:   00 00
    1471:   48 8b 98 80 07 00 00    mov    0x780(%rax),%rbx
    1478:   48 85 db                test   %rbx,%rbx

We will go further for the next optimize patch, if you guys thinks this
smp_rmb() refactor is appropriate.

v1 -> v2:
 - only replace rmb() with smp_rmb()
 - provide the performance test number

RFC -> v1:
 - replace rmb() with smp_rmb()
 - move the smp_rmb() logic to the middle between TIF_SECCOMP and mode

Signed-off-by: wanghongzhe <wanghongzhe@huawei.com>
---
 kernel/seccomp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 952dc1c90229..8505b438a590 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1164,7 +1164,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	 * Make sure that any changes to mode from another thread have
 	 * been seen after SYSCALL_WORK_SECCOMP was seen.
 	 */
-	rmb();
+	smp_rmb();
 
 	if (!sd) {
 		populate_seccomp_data(&sd_local);
-- 
2.19.1

