Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B06F1FA6C4
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 05:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgFPDZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 23:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgFPDZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 23:25:50 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5CDC00863E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 20:25:37 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k1so7661652pls.2
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 20:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KTfRvQ2+mCIDg0D8OuodXNewLgRfaqh/goGXJ65dENQ=;
        b=X0n1cxGNpvYeOHV2yPu2fBSFtc2MKAx3yZ0vLy7WL65O5apqTRKBhNQ4cLyYniRtqA
         YIsZEQnj/LbWXG8JdYe19vjrgC11ZH94DIAwq1Z5BFk1A00VDCjehfs2gVsj0Ngd59yG
         hrpViber5y5CaAhre8WjGi+EtY95WWh28cVKo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KTfRvQ2+mCIDg0D8OuodXNewLgRfaqh/goGXJ65dENQ=;
        b=YnPbJXKwdpKkiTNJRsZYBFE/ToCzmClK/fRGN1YAELbxWpktvI6j+C1/G2E9L5w4FU
         sLeTnDgFeYpx1yC7wNKRMpKZiPsHbHgeRehI6ZZiDP4r4PM57akmM+BZrYPkZmC9duIH
         t4RzksDtvlqQXOvn5mUnCvHzvwhSKcxK4E6mzNsfrsfGaIy3lIRnmHihXrYXciSZZi/Z
         tx7NkNuazLHkmXK8txxRyWTFEyVti+ddNUVtuT5UrSBBe/waqwaio47YLJUVg4BDyFxD
         aP4QeEIWH+oYZXoOt9uR/wqBX/toJZZVEJYoeUbAB71usPm4MqPBLDoCYd6Av02DXfNY
         x25A==
X-Gm-Message-State: AOAM532CQOM0eGB10JrjJkZUJ0ZFc2GJMpadYl55ADgCngeItwNx0r+Q
        Aji+AIMYSXofhzWDnosw9lpIcw==
X-Google-Smtp-Source: ABdhPJx6ntz1tupSkb6Z5KF9pZydUmMhD/o4/B/Oo+8svDxMTBwbLKSSqbRRvTlmCqWioCbQypQnnA==
X-Received: by 2002:a17:90a:250b:: with SMTP id j11mr1073537pje.194.1592277934971;
        Mon, 15 Jun 2020 20:25:34 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m10sm775999pjs.27.2020.06.15.20.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 20:25:32 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v4 08/11] selftests/seccomp: Make kcmp() less required
Date:   Mon, 15 Jun 2020 20:25:21 -0700
Message-Id: <20200616032524.460144-9-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200616032524.460144-1-keescook@chromium.org>
References: <20200616032524.460144-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The seccomp tests are a bit noisy without CONFIG_CHECKPOINT_RESTORE (due
to missing the kcmp() syscall). The seccomp tests are more accurate with
kcmp(), but it's not strictly required. Refactor the tests to use
alternatives (comparing fd numbers), and provide a central test for
kcmp() so there is a single XFAIL instead of many. Continue to produce
warnings for the other tests, though.

Additionally adds some more bad flag EINVAL tests to the addfd selftest.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 100 +++++++++++-------
 1 file changed, 64 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index c4e264b37c30..40ed846744e4 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -258,6 +258,27 @@ int seccomp(unsigned int op, unsigned int flags, void *args)
 #define SIBLING_EXIT_FAILURE	0xbadface
 #define SIBLING_EXIT_NEWPRIVS	0xbadfeed
 
+static int filecmp(pid_t pid1, pid_t pid2, int fd1, int fd2)
+{
+#ifdef __NR_kcmp
+	errno = 0;
+	return syscall(__NR_kcmp, pid1, pid2, KCMP_FILE, fd1, fd2);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+
+TEST(kcmp)
+{
+	int ret;
+
+	ret = filecmp(getpid(), getpid(), 1, 1);
+	EXPECT_EQ(ret, 0);
+	if (ret != 0 && errno == ENOSYS)
+		XFAIL(return, "Kernel does not support kcmp() (missing CONFIG_CHECKPOINT_RESTORE?)");
+}
+
 TEST(mode_strict_support)
 {
 	long ret;
@@ -3606,16 +3627,6 @@ TEST(seccomp_get_notif_sizes)
 	EXPECT_EQ(sizes.seccomp_notif_resp, sizeof(struct seccomp_notif_resp));
 }
 
-static int filecmp(pid_t pid1, pid_t pid2, int fd1, int fd2)
-{
-#ifdef __NR_kcmp
-	return syscall(__NR_kcmp, pid1, pid2, KCMP_FILE, fd1, fd2);
-#else
-	errno = ENOSYS;
-	return -1;
-#endif
-}
-
 TEST(user_notification_continue)
 {
 	pid_t pid;
@@ -3640,20 +3651,20 @@ TEST(user_notification_continue)
 		int dup_fd, pipe_fds[2];
 		pid_t self;
 
-		ret = pipe(pipe_fds);
-		if (ret < 0)
-			exit(1);
+		ASSERT_GE(pipe(pipe_fds), 0);
 
 		dup_fd = dup(pipe_fds[0]);
-		if (dup_fd < 0)
-			exit(1);
+		ASSERT_GE(dup_fd, 0);
+		EXPECT_NE(pipe_fds[0], dup_fd);
 
 		self = getpid();
-
 		ret = filecmp(self, self, pipe_fds[0], dup_fd);
-		if (ret)
-			exit(2);
-
+		if (ret != 0) {
+			if (ret < 0 && errno == ENOSYS) {
+				TH_LOG("kcmp() syscall missing (test is less accurate)");
+			} else
+				ASSERT_EQ(ret, 0);
+		}
 		exit(0);
 	}
 
@@ -3700,12 +3711,7 @@ TEST(user_notification_continue)
 skip:
 	EXPECT_EQ(waitpid(pid, &status, 0), pid);
 	EXPECT_EQ(true, WIFEXITED(status));
-	EXPECT_EQ(0, WEXITSTATUS(status)) {
-		if (WEXITSTATUS(status) == 2) {
-			XFAIL(return, "Kernel does not support kcmp() syscall");
-			return;
-		}
-	}
+	EXPECT_EQ(0, WEXITSTATUS(status));
 }
 
 TEST(user_notification_filter_empty)
@@ -3847,7 +3853,7 @@ TEST(user_notification_sendfd)
 {
 	pid_t pid;
 	long ret;
-	int status, listener, memfd;
+	int status, listener, memfd, fd;
 	struct seccomp_notif_addfd addfd = {};
 	struct seccomp_notif req = {};
 	struct seccomp_notif_resp resp = {};
@@ -3880,34 +3886,56 @@ TEST(user_notification_sendfd)
 
 	addfd.size = sizeof(addfd);
 	addfd.srcfd = memfd;
-	addfd.newfd_flags = O_CLOEXEC;
 	addfd.newfd = 0;
 	addfd.id = req.id;
-	addfd.flags = 0xff;
+	addfd.flags = 0;
+
+	/* Verify bad newfd_flags cannot be set */
+	addfd.newfd_flags = ~O_CLOEXEC;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), -1);
+	EXPECT_EQ(errno, EINVAL);
+	addfd.newfd_flags = O_CLOEXEC;
 
 	/* Verify bad flags cannot be set */
+	addfd.flags = 0xff;
 	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), -1);
 	EXPECT_EQ(errno, EINVAL);
+	addfd.flags = 0;
 
 	/* Verify that remote_fd cannot be set without setting flags */
-	addfd.flags = 0;
 	addfd.newfd = 1;
 	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), -1);
 	EXPECT_EQ(errno, EINVAL);
-
-	/* Verify we can set an arbitrary remote fd */
 	addfd.newfd = 0;
 
-	ret = ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd);
-	EXPECT_GE(ret, 0);
-	EXPECT_EQ(filecmp(getpid(), pid, memfd, ret), 0);
+	/* Verify we can set an arbitrary remote fd */
+	fd = ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd);
+	/*
+	 * The child has fds 0(stdin), 1(stdout), 2(stderr), 3(memfd),
+	 * 4(listener), so the newly allocated fd should be 5.
+	 */
+	EXPECT_EQ(fd, 5);
+	ret = filecmp(getpid(), pid, memfd, fd);
+	if (ret != 0) {
+		if (ret < 0 && errno == ENOSYS) {
+			TH_LOG("kcmp() syscall missing (test is less accurate)");
+		} else
+			EXPECT_EQ(ret, 0);
+	}
 
 	/* Verify we can set a specific remote fd */
 	addfd.newfd = 42;
 	addfd.flags = SECCOMP_ADDFD_FLAG_SETFD;
 
-	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), 42);
-	EXPECT_EQ(filecmp(getpid(), pid, memfd, 42), 0);
+	fd = ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd);
+	EXPECT_EQ(fd, 42);
+	ret = filecmp(getpid(), pid, memfd, fd);
+	if (ret != 0) {
+		if (ret < 0 && errno == ENOSYS) {
+			TH_LOG("kcmp() syscall missing (test is less accurate)");
+		} else
+			EXPECT_EQ(ret, 0);
+	}
 
 	resp.id = req.id;
 	resp.error = 0;
-- 
2.25.1

