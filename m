Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAEAC3DBB
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732321AbfJARCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729570AbfJAQkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:40:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4A8F21906;
        Tue,  1 Oct 2019 16:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948005;
        bh=KeGk7ekKKZHY2R8nLwGcjBusx9sdG8nRc9xvnHtfSGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5mo18adlS3mD7VBqclMZ84gx4heR8sBcuMoUb+3Lx7x8ZLT3mkdjaehkK71CbFh/
         B9a2m1gh2cNrgFq7ra2dyFVrPTA37T+FTzTzwXLup93AXJojEiWMWw8OspFxXXbXs+
         IiVUAWSkLvsWUNhBIA/moK2dByXWWDWI5C8Td7yo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 30/71] selftests/seccomp: fix build on older kernels
Date:   Tue,  1 Oct 2019 12:38:40 -0400
Message-Id: <20191001163922.14735-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tycho Andersen <tycho@tycho.ws>

[ Upstream commit 88282297fff00796e81f5e67734a6afdfb31fbc4 ]

The seccomp selftest goes to some length to build against older kernel
headers, viz. all the #ifdefs at the beginning of the file.

Commit 201766a20e30 ("ptrace: add PTRACE_GET_SYSCALL_INFO request")
introduces some additional macros, but doesn't do the #ifdef dance.
Let's add that dance here to avoid:

gcc -Wl,-no-as-needed -Wall  seccomp_bpf.c -lpthread -o seccomp_bpf
In file included from seccomp_bpf.c:51:
seccomp_bpf.c: In function ‘tracer_ptrace’:
seccomp_bpf.c:1787:20: error: ‘PTRACE_EVENTMSG_SYSCALL_ENTRY’ undeclared (first use in this function); did you mean ‘PTRACE_EVENT_CLONE’?
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../kselftest_harness.h:608:13: note: in definition of macro ‘__EXPECT’
  __typeof__(_expected) __exp = (_expected); \
             ^~~~~~~~~
seccomp_bpf.c:1787:2: note: in expansion of macro ‘EXPECT_EQ’
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
  ^~~~~~~~~
seccomp_bpf.c:1787:20: note: each undeclared identifier is reported only once for each function it appears in
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../kselftest_harness.h:608:13: note: in definition of macro ‘__EXPECT’
  __typeof__(_expected) __exp = (_expected); \
             ^~~~~~~~~
seccomp_bpf.c:1787:2: note: in expansion of macro ‘EXPECT_EQ’
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
  ^~~~~~~~~
seccomp_bpf.c:1788:6: error: ‘PTRACE_EVENTMSG_SYSCALL_EXIT’ undeclared (first use in this function); did you mean ‘PTRACE_EVENT_EXIT’?
    : PTRACE_EVENTMSG_SYSCALL_EXIT, msg);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
../kselftest_harness.h:608:13: note: in definition of macro ‘__EXPECT’
  __typeof__(_expected) __exp = (_expected); \
             ^~~~~~~~~
seccomp_bpf.c:1787:2: note: in expansion of macro ‘EXPECT_EQ’
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
  ^~~~~~~~~
make: *** [Makefile:12: seccomp_bpf] Error 1

[skhan@linuxfoundation.org: Fix checkpatch error in commit log]
Signed-off-by: Tycho Andersen <tycho@tycho.ws>
Fixes: 201766a20e30 ("ptrace: add PTRACE_GET_SYSCALL_INFO request")
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 6ef7f16c4cf52..7f8b5c8982e3b 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -199,6 +199,11 @@ struct seccomp_notif_sizes {
 };
 #endif
 
+#ifndef PTRACE_EVENTMSG_SYSCALL_ENTRY
+#define PTRACE_EVENTMSG_SYSCALL_ENTRY	1
+#define PTRACE_EVENTMSG_SYSCALL_EXIT	2
+#endif
+
 #ifndef seccomp
 int seccomp(unsigned int op, unsigned int flags, void *args)
 {
-- 
2.20.1

