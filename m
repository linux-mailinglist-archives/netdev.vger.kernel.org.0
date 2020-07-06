Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4322D216013
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgGFURz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbgGFURe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:17:34 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE4FC08C5FB
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:17:34 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id w17so1310043ply.11
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 13:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lglyYoPPQJEZuf+l/iqQmwTlxwVcqZysi0PoSrLMJSg=;
        b=myT4t02Qp3BsS4tK2n7hYmgPQAU0ZJOlwyQcW34UeWfRyL9CZb+YT/ydAGxuAkW3pZ
         u6m4w3vT9mhp93EuAutpqK+j8dTfpZVEbQHpdr1sQs2MWhnFJX/5IAfGGmM4rKvF16Rp
         5T0AJL9uOlSXJ3n+71B2xce7MMqzuEh+fa9nk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lglyYoPPQJEZuf+l/iqQmwTlxwVcqZysi0PoSrLMJSg=;
        b=O+svYXyYb2Zy+/SlesGeSULAS7duFCpBB/BxDSE/2J/evFbSbnD06wIUl02Wj8jrTM
         ZQfYduaYgeNPvyYZ60M7/akVNOQ+J6yxLPQ9R0qTsKfNU+71P3d+EHqDGCnCgdpHKrAE
         t/SeqXhM+2Fq/58wa5FFcxIBI99SJOdg+2AsDxiHJjMzYJIy++5jo5MujXVvG6bUlod3
         HcbkTGFBBn6MiKzF4zcPfwkFWhOnorl30GCKlz/gGxVBHg8evgohpgu1qAS9pEIicrvf
         IuywkFlpbdlNlp7t79+pdqcyTF4P704mId6gvYsPEe8mHeq8Ryr6igXU9Q0EO0Ovez+u
         eovw==
X-Gm-Message-State: AOAM532hSTLCR+1WejB5JhqLeGijW3Zwq4wfsPZP2LnB5GrGRyfkXJEi
        b/GHWne5EjZN3eizneOyu9LfVg==
X-Google-Smtp-Source: ABdhPJx4z0wddCWEx6nREZ6MCFfI4P9iEbpNoNbQirt/73QzOH9zF3ez1J/EWYjbbvk2WmcGfTfLZg==
X-Received: by 2002:a17:90a:c915:: with SMTP id v21mr869548pjt.48.1594066653575;
        Mon, 06 Jul 2020 13:17:33 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d14sm292926pjc.20.2020.07.06.13.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 13:17:31 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
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
Subject: [PATCH v6 7/7] selftests/seccomp: Test SECCOMP_IOCTL_NOTIF_ADDFD
Date:   Mon,  6 Jul 2020 13:17:20 -0700
Message-Id: <20200706201720.3482959-8-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706201720.3482959-1-keescook@chromium.org>
References: <20200706201720.3482959-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sargun Dhillon <sargun@sargun.me>

Test whether we can add file descriptors in response to notifications.
This injects the file descriptors via notifications, and then uses kcmp
to determine whether or not it has been successful.

It also includes some basic sanity checking for arguments.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Link: https://lore.kernel.org/r/20200603011044.7972-5-sargun@sargun.me
Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 229 ++++++++++++++++++
 1 file changed, 229 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 2c77105e50e6..b854a6c5bf49 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -45,6 +45,7 @@
 #include <sys/socket.h>
 #include <sys/ioctl.h>
 #include <linux/kcmp.h>
+#include <sys/resource.h>
 
 #include <unistd.h>
 #include <sys/syscall.h>
@@ -168,7 +169,9 @@ struct seccomp_metadata {
 
 #ifndef SECCOMP_FILTER_FLAG_NEW_LISTENER
 #define SECCOMP_FILTER_FLAG_NEW_LISTENER	(1UL << 3)
+#endif
 
+#ifndef SECCOMP_RET_USER_NOTIF
 #define SECCOMP_RET_USER_NOTIF 0x7fc00000U
 
 #define SECCOMP_IOC_MAGIC		'!'
@@ -204,6 +207,39 @@ struct seccomp_notif_sizes {
 };
 #endif
 
+#ifndef SECCOMP_IOCTL_NOTIF_ADDFD
+/* On success, the return value is the remote process's added fd number */
+#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOW(3,	\
+						struct seccomp_notif_addfd)
+
+/* valid flags for seccomp_notif_addfd */
+#define SECCOMP_ADDFD_FLAG_SETFD	(1UL << 0) /* Specify remote fd */
+
+struct seccomp_notif_addfd {
+	__u64 id;
+	__u32 flags;
+	__u32 srcfd;
+	__u32 newfd;
+	__u32 newfd_flags;
+};
+#endif
+
+struct seccomp_notif_addfd_small {
+	__u64 id;
+	char weird[4];
+};
+#define SECCOMP_IOCTL_NOTIF_ADDFD_SMALL	\
+	SECCOMP_IOW(3, struct seccomp_notif_addfd_small)
+
+struct seccomp_notif_addfd_big {
+	union {
+		struct seccomp_notif_addfd addfd;
+		char buf[sizeof(struct seccomp_notif_addfd) + 8];
+	};
+};
+#define SECCOMP_IOCTL_NOTIF_ADDFD_BIG	\
+	SECCOMP_IOWR(3, struct seccomp_notif_addfd_big)
+
 #ifndef PTRACE_EVENTMSG_SYSCALL_ENTRY
 #define PTRACE_EVENTMSG_SYSCALL_ENTRY	1
 #define PTRACE_EVENTMSG_SYSCALL_EXIT	2
@@ -3738,6 +3774,199 @@ TEST(user_notification_filter_empty_threaded)
 	EXPECT_GT((pollfd.revents & POLLHUP) ?: 0, 0);
 }
 
+TEST(user_notification_addfd)
+{
+	pid_t pid;
+	long ret;
+	int status, listener, memfd, fd;
+	struct seccomp_notif_addfd addfd = {};
+	struct seccomp_notif_addfd_small small = {};
+	struct seccomp_notif_addfd_big big = {};
+	struct seccomp_notif req = {};
+	struct seccomp_notif_resp resp = {};
+	/* 100 ms */
+	struct timespec delay = { .tv_nsec = 100000000 };
+
+	memfd = memfd_create("test", 0);
+	ASSERT_GE(memfd, 0);
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	/* Check that the basic notification machinery works */
+	listener = user_notif_syscall(__NR_getppid,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		if (syscall(__NR_getppid) != USER_NOTIF_MAGIC)
+			exit(1);
+		exit(syscall(__NR_getppid) != USER_NOTIF_MAGIC);
+	}
+
+	ASSERT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
+
+	addfd.srcfd = memfd;
+	addfd.newfd = 0;
+	addfd.id = req.id;
+	addfd.flags = 0x0;
+
+	/* Verify bad newfd_flags cannot be set */
+	addfd.newfd_flags = ~O_CLOEXEC;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), -1);
+	EXPECT_EQ(errno, EINVAL);
+	addfd.newfd_flags = O_CLOEXEC;
+
+	/* Verify bad flags cannot be set */
+	addfd.flags = 0xff;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), -1);
+	EXPECT_EQ(errno, EINVAL);
+	addfd.flags = 0;
+
+	/* Verify that remote_fd cannot be set without setting flags */
+	addfd.newfd = 1;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), -1);
+	EXPECT_EQ(errno, EINVAL);
+	addfd.newfd = 0;
+
+	/* Verify small size cannot be set */
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD_SMALL, &small), -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	/* Verify we can't send bits filled in unknown buffer area */
+	memset(&big, 0xAA, sizeof(big));
+	big.addfd = addfd;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD_BIG, &big), -1);
+	EXPECT_EQ(errno, E2BIG);
+
+
+	/* Verify we can set an arbitrary remote fd */
+	fd = ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd);
+	/*
+	 * The child has fds 0(stdin), 1(stdout), 2(stderr), 3(memfd),
+	 * 4(listener), so the newly allocated fd should be 5.
+	 */
+	EXPECT_EQ(fd, 5);
+	EXPECT_EQ(filecmp(getpid(), pid, memfd, fd), 0);
+
+	/* Verify we can set an arbitrary remote fd with large size */
+	memset(&big, 0x0, sizeof(big));
+	big.addfd = addfd;
+	fd = ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD_BIG, &big);
+	EXPECT_EQ(fd, 6);
+
+	/* Verify we can set a specific remote fd */
+	addfd.newfd = 42;
+	addfd.flags = SECCOMP_ADDFD_FLAG_SETFD;
+	fd = ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd);
+	EXPECT_EQ(fd, 42);
+	EXPECT_EQ(filecmp(getpid(), pid, memfd, fd), 0);
+
+	/* Resume syscall */
+	resp.id = req.id;
+	resp.error = 0;
+	resp.val = USER_NOTIF_MAGIC;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
+
+	/*
+	 * This sets the ID of the ADD FD to the last request plus 1. The
+	 * notification ID increments 1 per notification.
+	 */
+	addfd.id = req.id + 1;
+
+	/* This spins until the underlying notification is generated */
+	while (ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd) != -1 &&
+	       errno != -EINPROGRESS)
+		nanosleep(&delay, NULL);
+
+	memset(&req, 0, sizeof(req));
+	ASSERT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
+	ASSERT_EQ(addfd.id, req.id);
+
+	resp.id = req.id;
+	resp.error = 0;
+	resp.val = USER_NOTIF_MAGIC;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
+
+	/* Wait for child to finish. */
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+
+	close(memfd);
+}
+
+TEST(user_notification_addfd_rlimit)
+{
+	pid_t pid;
+	long ret;
+	int status, listener, memfd;
+	struct seccomp_notif_addfd addfd = {};
+	struct seccomp_notif req = {};
+	struct seccomp_notif_resp resp = {};
+	const struct rlimit lim = {
+		.rlim_cur	= 0,
+		.rlim_max	= 0,
+	};
+
+	memfd = memfd_create("test", 0);
+	ASSERT_GE(memfd, 0);
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	/* Check that the basic notification machinery works */
+	listener = user_notif_syscall(__NR_getppid,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0)
+		exit(syscall(__NR_getppid) != USER_NOTIF_MAGIC);
+
+
+	ASSERT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
+
+	ASSERT_EQ(prlimit(pid, RLIMIT_NOFILE, &lim, NULL), 0);
+
+	addfd.srcfd = memfd;
+	addfd.newfd_flags = O_CLOEXEC;
+	addfd.newfd = 0;
+	addfd.id = req.id;
+	addfd.flags = 0;
+
+	/* Should probably spot check /proc/sys/fs/file-nr */
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), -1);
+	EXPECT_EQ(errno, EMFILE);
+
+	addfd.newfd = 100;
+	addfd.flags = SECCOMP_ADDFD_FLAG_SETFD;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), -1);
+	EXPECT_EQ(errno, EBADF);
+
+	resp.id = req.id;
+	resp.error = 0;
+	resp.val = USER_NOTIF_MAGIC;
+
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
+
+	/* Wait for child to finish. */
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+
+	close(memfd);
+}
+
 /*
  * TODO:
  * - expand NNP testing
-- 
2.25.1

