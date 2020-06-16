Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115881FA6C1
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 05:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgFPDZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 23:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbgFPDZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 23:25:53 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DFEC0085C4
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 20:25:37 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a45so659101pje.1
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 20:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0XLeJlm9EgjXcakcD9qCa51hLblsobf6+bsB3dZc0i8=;
        b=FKACMKyfxUA7EW9AFaoKVvRC5y/1zAscVNsROkN95jbzPz/DVctU6B9b39AAvKij7N
         6Nlikz3HjI7F5mqdklSF71vSDdkiuk/lo6fE6XK2BMW71zU3jrwvPABfdtnLEM9oR5Bn
         531elB+kI1SaW2n2BDWmttY4VIZSDBG5Z5y28=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0XLeJlm9EgjXcakcD9qCa51hLblsobf6+bsB3dZc0i8=;
        b=MP3vNDAXzDkevI0fzwM5lETSi7FT+MYN4demHvsIvDcx9nWvUxCxnxiS1vck++oVC3
         yR/pm09CDsxopxt7Ii8neXa6fLX2da+YyWGLWdLIrL1fwesGIdcmDk2lxKMzk4K8Zrx/
         t/jRzEJVKVf0cbJg3ejDysQCJ6YWLt8C1v69dg/jNMSUKFZn9iX1oc48a5IxTE3Enpfz
         qXzkPN/QHNV05uGgTCIw2vjamZEKYpiXzIj6ZTaPQ6Jp4Gj8nnGskezzf2y+J0ZptMW8
         DC9mC7rTqx2FkqoqgZN4LI0+hki1+Pqm13vhUGswUI6UDulE50uWJg3AJXwMfohrwd4z
         N4Nw==
X-Gm-Message-State: AOAM533STUXKztgWsLiyrfKye5P3+wViCMHoOkccQosuDZj2PSCO6ttz
        32P7zUCnwqzWkwoTJgKHjG4Ufg==
X-Google-Smtp-Source: ABdhPJwVGDqjGiwBmdUw+0CM58qrM4XZkDqMs17lV5U6dITKbuVhjYUHCQGtjBUBVlvKZE+GWSFt+Q==
X-Received: by 2002:a17:90a:634a:: with SMTP id v10mr851059pjs.50.1592277937337;
        Mon, 15 Jun 2020 20:25:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 140sm15093613pfy.95.2020.06.15.20.25.31
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
Subject: [PATCH v4 10/11] seccomp: Switch addfd to Extensible Argument ioctl
Date:   Mon, 15 Jun 2020 20:25:23 -0700
Message-Id: <20200616032524.460144-11-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200616032524.460144-1-keescook@chromium.org>
References: <20200616032524.460144-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is based on discussions[1] with Sargun Dhillon, Christian
Brauner, and David Laight. Instead of building size into the addfd
structure, make it a function of the ioctl command (which is how sizes are
normally passed to ioctls). To support forward and backward compatibility,
just mask out the direction and size, and match everything. The size (and
any future direction) checks are done along with copy_struct_from_user()
logic. Also update the selftests to check size bounds.

[1] https://lore.kernel.org/lkml/20200612104629.GA15814@ircssh-2.c.rugged-nimbus-611.internal

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/uapi/linux/seccomp.h                  |  2 -
 kernel/seccomp.c                              | 21 ++++++----
 tools/testing/selftests/seccomp/seccomp_bpf.c | 40 ++++++++++++++++---
 3 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index c347160378e5..473a61695ac3 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -118,7 +118,6 @@ struct seccomp_notif_resp {
 
 /**
  * struct seccomp_notif_addfd
- * @size: The size of the seccomp_notif_addfd structure
  * @id: The ID of the seccomp notification
  * @flags: SECCOMP_ADDFD_FLAG_*
  * @srcfd: The local fd number
@@ -126,7 +125,6 @@ struct seccomp_notif_resp {
  * @newfd_flags: The O_* flags the remote FD should have applied
  */
 struct seccomp_notif_addfd {
-	__u64 size;
 	__u64 id;
 	__u32 flags;
 	__u32 srcfd;
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 3c913f3b8451..9660abf91135 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1292,17 +1292,17 @@ static long seccomp_notify_id_valid(struct seccomp_filter *filter,
 }
 
 static long seccomp_notify_addfd(struct seccomp_filter *filter,
-				 struct seccomp_notif_addfd __user *uaddfd)
+				 struct seccomp_notif_addfd __user *uaddfd,
+				 unsigned int size)
 {
 	struct seccomp_notif_addfd addfd;
 	struct seccomp_knotif *knotif;
 	struct seccomp_kaddfd kaddfd;
-	u64 size;
 	int ret;
 
-	ret = get_user(size, &uaddfd->size);
-	if (ret)
-		return ret;
+	/* 24 is original sizeof(struct seccomp_notif_addfd) */
+	if (size < 24 || size >= PAGE_SIZE)
+		return -EINVAL;
 
 	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
 	if (ret)
@@ -1391,6 +1391,7 @@ static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 	struct seccomp_filter *filter = file->private_data;
 	void __user *buf = (void __user *)arg;
 
+	/* Fixed-size ioctls */
 	switch (cmd) {
 	case SECCOMP_IOCTL_NOTIF_RECV:
 		return seccomp_notify_recv(filter, buf);
@@ -1398,11 +1399,17 @@ static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 		return seccomp_notify_send(filter, buf);
 	case SECCOMP_IOCTL_NOTIF_ID_VALID:
 		return seccomp_notify_id_valid(filter, buf);
-	case SECCOMP_IOCTL_NOTIF_ADDFD:
-		return seccomp_notify_addfd(filter, buf);
+	}
+
+	/* Extensible Argument ioctls */
+#define EA_IOCTL(cmd)	((cmd) & ~(IOC_INOUT | IOCSIZE_MASK))
+	switch (EA_IOCTL(cmd)) {
+	case EA_IOCTL(SECCOMP_IOCTL_NOTIF_ADDFD):
+		return seccomp_notify_addfd(filter, buf, _IOC_SIZE(cmd));
 	default:
 		return -EINVAL;
 	}
+#undef EA_IOCTL
 }
 
 static __poll_t seccomp_notify_poll(struct file *file,
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 95b134933831..cf1480e498ea 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -216,7 +216,6 @@ struct seccomp_notif_sizes {
 #define SECCOMP_ADDFD_FLAG_SETFD	(1UL << 0) /* Specify remote fd */
 
 struct seccomp_notif_addfd {
-	__u64 size;
 	__u64 id;
 	__u32 flags;
 	__u32 srcfd;
@@ -225,6 +224,22 @@ struct seccomp_notif_addfd {
 };
 #endif
 
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
@@ -3853,6 +3868,8 @@ TEST(user_notification_sendfd)
 	long ret;
 	int status, listener, memfd, fd;
 	struct seccomp_notif_addfd addfd = {};
+	struct seccomp_notif_addfd_small small = {};
+	struct seccomp_notif_addfd_big big = {};
 	struct seccomp_notif req = {};
 	struct seccomp_notif_resp resp = {};
 	/* 100 ms */
@@ -3882,7 +3899,6 @@ TEST(user_notification_sendfd)
 
 	ASSERT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
 
-	addfd.size = sizeof(addfd);
 	addfd.srcfd = memfd;
 	addfd.newfd = 0;
 	addfd.id = req.id;
@@ -3906,6 +3922,16 @@ TEST(user_notification_sendfd)
 	EXPECT_EQ(errno, EINVAL);
 	addfd.newfd = 0;
 
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
 	/* Verify we can set an arbitrary remote fd */
 	fd = ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd);
 	/*
@@ -3921,10 +3947,15 @@ TEST(user_notification_sendfd)
 			EXPECT_EQ(ret, 0);
 	}
 
+	/* Verify we can set an arbitrary remote fd with large size */
+	memset(&big, 0x0, sizeof(big));
+	big.addfd = addfd;
+	fd = ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD_BIG, &big);
+	EXPECT_EQ(fd, 6);
+
 	/* Verify we can set a specific remote fd */
 	addfd.newfd = 42;
 	addfd.flags = SECCOMP_ADDFD_FLAG_SETFD;
-
 	fd = ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd);
 	EXPECT_EQ(fd, 42);
 	ret = filecmp(getpid(), pid, memfd, fd);
@@ -3935,10 +3966,10 @@ TEST(user_notification_sendfd)
 			EXPECT_EQ(ret, 0);
 	}
 
+	/* Resume syscall */
 	resp.id = req.id;
 	resp.error = 0;
 	resp.val = USER_NOTIF_MAGIC;
-
 	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
 
 	/*
@@ -4006,7 +4037,6 @@ TEST(user_notification_sendfd_rlimit)
 
 	ASSERT_EQ(prlimit(pid, RLIMIT_NOFILE, &lim, NULL), 0);
 
-	addfd.size = sizeof(addfd);
 	addfd.srcfd = memfd;
 	addfd.newfd_flags = O_CLOEXEC;
 	addfd.newfd = 0;
-- 
2.25.1

