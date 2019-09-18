Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E3BB5F7F
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 10:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbfIRIsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 04:48:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41699 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730502AbfIRIsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 04:48:46 -0400
Received: from static-dcd-cqq-121001.business.bouyguestelecom.com ([212.194.121.1] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iAVdf-0004BF-BN; Wed, 18 Sep 2019 08:48:39 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     keescook@chromium.org, luto@amacapital.net
Cc:     jannh@google.com, wad@chromium.org, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Tycho Andersen <tycho@tycho.ws>,
        Tyler Hicks <tyhicks@canonical.com>, stable@vger.kernel.org
Subject: [PATCH 2/4] seccomp: add two missing ptrace ifdefines
Date:   Wed, 18 Sep 2019 10:48:31 +0200
Message-Id: <20190918084833.9369-3-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918084833.9369-1-christian.brauner@ubuntu.com>
References: <20190918084833.9369-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tw missing ptrace ifdefines to avoid compilation errors on systems
that do not provide PTRACE_EVENTMSG_SYSCALL_ENTRY or
PTRACE_EVENTMSG_SYSCALL_EXIT or:

gcc -Wl,-no-as-needed -Wall  seccomp_bpf.c -lpthread -o seccomp_bpf
In file included from seccomp_bpf.c:52:0:
seccomp_bpf.c: In function ‘tracer_ptrace’:
seccomp_bpf.c:1792:20: error: ‘PTRACE_EVENTMSG_SYSCALL_ENTRY’ undeclared (first use in this function); did you mean ‘PTRACE_EVENT_CLONE’?
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
                    ^
../kselftest_harness.h:608:13: note: in definition of macro ‘__EXPECT’
  __typeof__(_expected) __exp = (_expected); \
             ^~~~~~~~~
seccomp_bpf.c:1792:2: note: in expansion of macro ‘EXPECT_EQ’
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
  ^~~~~~~~~
seccomp_bpf.c:1792:20: note: each undeclared identifier is reported only once for each function it appears in
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
                    ^
../kselftest_harness.h:608:13: note: in definition of macro ‘__EXPECT’
  __typeof__(_expected) __exp = (_expected); \
             ^~~~~~~~~
seccomp_bpf.c:1792:2: note: in expansion of macro ‘EXPECT_EQ’
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
  ^~~~~~~~~
seccomp_bpf.c:1793:6: error: ‘PTRACE_EVENTMSG_SYSCALL_EXIT’ undeclared (first use in this function); did you mean ‘PTRACE_EVENTMSG_SYSCALL_ENTRY’?
    : PTRACE_EVENTMSG_SYSCALL_EXIT, msg);
      ^
../kselftest_harness.h:608:13: note: in definition of macro ‘__EXPECT’
  __typeof__(_expected) __exp = (_expected); \
             ^~~~~~~~~
seccomp_bpf.c:1792:2: note: in expansion of macro ‘EXPECT_EQ’
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
  ^~~~~~~~~

Fixes: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Tycho Andersen <tycho@tycho.ws>
CC: Tyler Hicks <tyhicks@canonical.com>
Cc: Jann Horn <jannh@google.com>
Cc: stable@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 6ef7f16c4cf5..ee52eab01800 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -155,6 +155,14 @@ struct seccomp_data {
 #ifndef PTRACE_SECCOMP_GET_METADATA
 #define PTRACE_SECCOMP_GET_METADATA	0x420d
 
+#ifndef PTRACE_EVENTMSG_SYSCALL_ENTRY
+#define PTRACE_EVENTMSG_SYSCALL_ENTRY 1
+#endif
+
+#ifndef PTRACE_EVENTMSG_SYSCALL_EXIT
+#define PTRACE_EVENTMSG_SYSCALL_EXIT 2
+#endif
+
 struct seccomp_metadata {
 	__u64 filter_off;       /* Input: which filter */
 	__u64 flags;             /* Output: filter's flags */
-- 
2.23.0

