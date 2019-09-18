Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA2BB5F85
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 10:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbfIRIs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 04:48:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41706 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730522AbfIRIsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 04:48:47 -0400
Received: from static-dcd-cqq-121001.business.bouyguestelecom.com ([212.194.121.1] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iAVdg-0004BF-Ba; Wed, 18 Sep 2019 08:48:40 +0000
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
Subject: [PATCH 4/4] seccomp: test SECCOMP_RET_USER_NOTIF_ALLOW
Date:   Wed, 18 Sep 2019 10:48:33 +0200
Message-Id: <20190918084833.9369-5-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918084833.9369-1-christian.brauner@ubuntu.com>
References: <20190918084833.9369-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test whether a syscall can be performed after having been intercepted by
the seccomp notifier. The test uses dup() and kcmp() since it allows us to
nicely test whether the dup() syscall actually succeeded by comparing whether
the fd refers to the same underlying struct file.

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
 tools/testing/selftests/seccomp/seccomp_bpf.c | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 921f0e26f835..788d7e9007d5 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -44,6 +44,7 @@
 #include <sys/times.h>
 #include <sys/socket.h>
 #include <sys/ioctl.h>
+#include <linux/kcmp.h>
 
 #include <unistd.h>
 #include <sys/syscall.h>
@@ -175,6 +176,10 @@ struct seccomp_metadata {
 
 #define SECCOMP_RET_USER_NOTIF 0x7fc00000U
 
+#ifndef SECCOMP_RET_USER_NOTIF_ALLOW
+#define SECCOMP_RET_USER_NOTIF_ALLOW 0x00000001
+#endif
+
 #define SECCOMP_IOC_MAGIC		'!'
 #define SECCOMP_IO(nr)			_IO(SECCOMP_IOC_MAGIC, nr)
 #define SECCOMP_IOR(nr, type)		_IOR(SECCOMP_IOC_MAGIC, nr, type)
@@ -3489,6 +3494,100 @@ TEST(seccomp_get_notif_sizes)
 	EXPECT_EQ(sizes.seccomp_notif_resp, sizeof(struct seccomp_notif_resp));
 }
 
+static int filecmp(pid_t pid1, pid_t pid2, int fd1, int fd2)
+{
+#ifdef __NR_kcmp
+	return syscall(__NR_kcmp, pid1, pid2, KCMP_FILE, fd1, fd2);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+
+TEST(user_notification_continue)
+{
+	pid_t pid;
+	long ret;
+	int status, listener;
+	struct seccomp_notif req = {};
+	struct seccomp_notif_resp resp = {};
+	struct pollfd pollfd;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	listener = user_trap_syscall(__NR_dup, SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		int dup_fd, pipe_fds[2];
+		pid_t self;
+
+		ret = pipe(pipe_fds);
+		if (ret < 0)
+			exit(EXIT_FAILURE);
+
+		dup_fd = dup(pipe_fds[0]);
+		if (dup_fd < 0)
+			exit(EXIT_FAILURE);
+
+		self = getpid();
+
+		ret = filecmp(self, self, pipe_fds[0], dup_fd);
+		if (ret)
+			exit(EXIT_FAILURE);
+
+		exit(EXIT_SUCCESS);
+	}
+
+	pollfd.fd = listener;
+	pollfd.events = POLLIN | POLLOUT;
+
+	EXPECT_GT(poll(&pollfd, 1, -1), 0);
+	EXPECT_EQ(pollfd.revents, POLLIN);
+
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
+
+	pollfd.fd = listener;
+	pollfd.events = POLLIN | POLLOUT;
+
+	EXPECT_GT(poll(&pollfd, 1, -1), 0);
+	EXPECT_EQ(pollfd.revents, POLLOUT);
+
+	EXPECT_EQ(req.data.nr, __NR_dup);
+
+	resp.id = req.id;
+	resp.flags = SECCOMP_RET_USER_NOTIF_ALLOW;
+
+	/* check that if (flags & SECCOMP_RET_USER_NOTIF_ALLOW) the rest is 0 */
+	resp.error = 0;
+	resp.val = USER_NOTIF_MAGIC;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	resp.error = USER_NOTIF_MAGIC;
+	resp.val = 0;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	resp.error = 0;
+	resp.val = 0;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0) {
+		if (errno == EINVAL)
+			XFAIL(goto skip, "Kernel does not support SECCOMP_RET_USER_NOTIF_ALLOW");
+	}
+
+skip:
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
 /*
  * TODO:
  * - add microbenchmarks
-- 
2.23.0

