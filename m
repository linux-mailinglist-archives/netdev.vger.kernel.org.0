Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45BE41A2CA5
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgDHX6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:58:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53208 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgDHX6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:58:14 -0400
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1jMKaC-0001Kx-Ef; Wed, 08 Apr 2020 23:58:12 +0000
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        luto@amacapital.net, wad@chromium.org, shuah@kernel.org
Subject: [PATCH] selftests/seccomp: allow clock_nanosleep instead of nanosleep
Date:   Wed,  8 Apr 2020 20:57:53 -0300
Message-Id: <20200408235753.8566-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

glibc 2.31 calls clock_nanosleep when its nanosleep function is used. So
the restart_syscall fails after that. In order to deal with it, we trace
clock_nanosleep and nanosleep. Then we check for either.

This works just fine on systems with both glibc 2.30 and glibc 2.31,
whereas it failed before on a system with glibc 2.31.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 89fb3e0b552e..c0aa46ce14f6 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -2803,12 +2803,13 @@ TEST(syscall_restart)
 			 offsetof(struct seccomp_data, nr)),
 
 #ifdef __NR_sigreturn
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_sigreturn, 6, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_sigreturn, 7, 0),
 #endif
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 5, 0),
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_exit, 4, 0),
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_rt_sigreturn, 3, 0),
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_nanosleep, 4, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 6, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_exit, 5, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_rt_sigreturn, 4, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_nanosleep, 5, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_clock_nanosleep, 4, 0),
 		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_restart_syscall, 4, 0),
 
 		/* Allow __NR_write for easy logging. */
@@ -2895,7 +2896,8 @@ TEST(syscall_restart)
 	ASSERT_EQ(PTRACE_EVENT_SECCOMP, (status >> 16));
 	ASSERT_EQ(0, ptrace(PTRACE_GETEVENTMSG, child_pid, NULL, &msg));
 	ASSERT_EQ(0x100, msg);
-	EXPECT_EQ(__NR_nanosleep, get_syscall(_metadata, child_pid));
+	ret = get_syscall(_metadata, child_pid);
+	EXPECT_TRUE(ret == __NR_nanosleep || ret == __NR_clock_nanosleep);
 
 	/* Might as well check siginfo for sanity while we're here. */
 	ASSERT_EQ(0, ptrace(PTRACE_GETSIGINFO, child_pid, NULL, &info));
-- 
2.20.1

