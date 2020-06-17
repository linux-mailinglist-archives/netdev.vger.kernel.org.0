Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102E21FD822
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 00:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgFQWDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 18:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbgFQWDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 18:03:33 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA28C0613EF
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 15:03:32 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id n9so1572031plk.1
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 15:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JfpI1GG/4ASH8XTwm9WwhsnqJPuQkeJ3KfU5iE0siPk=;
        b=CyK2Y7jKcg3jWb83XP40NF0XUYGVXD+1V+4pT7KZSo4wCLqQ9iB9bRiDEd4nW56PXM
         hpIQOB7drdivotPmqckm3icsG3S6fJqxUXZUgTWB/JGpBy0Mts6JHOvn0vGN1qiSJx8E
         A8747kbFVyLgnx3F2OQvdMh3YUSLu0KYMhp+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JfpI1GG/4ASH8XTwm9WwhsnqJPuQkeJ3KfU5iE0siPk=;
        b=MeO9zqdteZAuWCpyBvirJ5p2bSzujetzmzMEG2L6VYqhUQ0aSwufvMk+/w5Yt6mtGS
         /fJZR7oBQEwlrI6EuabwJlAteNE/0efjHOpAxoyhpIoxUdufgvakw1oUGlgsXtNNqsQk
         sDDlHiKnl10/MY+DCJOnmDqb/PjZCNS652bagr35tl9Ia1iDkvJzjVFmdTktw/BzGexr
         LeoAerG01Sb+EUSk0rjJEH7pml9VwveyTgKAEkq3p2D44/acbgvnC6TZACzbaX8pXNCW
         glBUGSMOdUfoMjgg412Av3dCl/KOMd/+eJbp2qmGK1wtwEmIh0ESbVi0GcaTEdxAVd9/
         lEkA==
X-Gm-Message-State: AOAM531m3fnLeBCYABUnm8w3NKCdS7ZfHzzh8BhboN1HCwG8d3Gmpi8n
        k1GNVzpCO/Gvrfo1Dzxn7d3DyQ==
X-Google-Smtp-Source: ABdhPJyaT2WGGTn+xIpi/7pv38Ikw5LMtpji1hqM1t34IkAV/SXn2PXvoXUf9SlukpLNRSDtc3ssEA==
X-Received: by 2002:a17:90a:d803:: with SMTP id a3mr1130991pjv.125.1592431412195;
        Wed, 17 Jun 2020 15:03:32 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t201sm755132pfc.104.2020.06.17.15.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 15:03:30 -0700 (PDT)
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
Subject: [PATCH v5 3/7] fs: Add fd_install_received() wrapper for __fd_install_received()
Date:   Wed, 17 Jun 2020 15:03:23 -0700
Message-Id: <20200617220327.3731559-4-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200617220327.3731559-1-keescook@chromium.org>
References: <20200617220327.3731559-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For both pidfd and seccomp, the __user pointer is not used. Update
__fd_install_received() to make writing to ufd optional via a NULL check.
However, for the fd_install_received_user() wrapper, ufd is NULL checked
so an -EFAULT can be returned to avoid changing the SCM_RIGHTS interface
behavior. Add new wrapper fd_install_received() for pidfd and seccomp
that does not use the ufd argument. For the new helper, the new fd needs
to be returned on success. Update the existing callers to handle it.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/file.c            | 22 ++++++++++++++--------
 include/linux/file.h |  7 +++++++
 net/compat.c         |  2 +-
 net/core/scm.c       |  2 +-
 4 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index f2167d6feec6..de85a42defe2 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -942,9 +942,10 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
  * @o_flags: the O_* flags to apply to the new fd entry
  *
  * Installs a received file into the file descriptor table, with appropriate
- * checks and count updates. Writes the fd number to userspace.
+ * checks and count updates. Optionally writes the fd number to userspace, if
+ * @ufd is non-NULL.
  *
- * Returns -ve on error.
+ * Returns newly install fd or -ve on error.
  */
 int __fd_install_received(struct file *file, int __user *ufd, unsigned int o_flags)
 {
@@ -960,20 +961,25 @@ int __fd_install_received(struct file *file, int __user *ufd, unsigned int o_fla
 	if (new_fd < 0)
 		return new_fd;
 
-	error = put_user(new_fd, ufd);
-	if (error) {
-		put_unused_fd(new_fd);
-		return error;
+	if (ufd) {
+		error = put_user(new_fd, ufd);
+		if (error) {
+			put_unused_fd(new_fd);
+			return error;
+		}
 	}
 
-	/* Bump the usage count and install the file. */
+	/* Bump the usage count and install the file. The resulting value of
+	 * "error" is ignored here since we only need to take action when
+	 * the file is a socket and testing "sock" for NULL is sufficient.
+	 */
 	sock = sock_from_file(file, &error);
 	if (sock) {
 		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
 		sock_update_classid(&sock->sk->sk_cgrp_data);
 	}
 	fd_install(new_fd, get_file(file));
-	return 0;
+	return new_fd;
 }
 
 static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
diff --git a/include/linux/file.h b/include/linux/file.h
index fe18a1a0d555..e19974ed9322 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -9,6 +9,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/posix_types.h>
+#include <linux/errno.h>
 
 struct file;
 
@@ -96,8 +97,14 @@ extern int __fd_install_received(struct file *file, int __user *ufd,
 static inline int fd_install_received_user(struct file *file, int __user *ufd,
 					   unsigned int o_flags)
 {
+	if (ufd == NULL)
+		return -EFAULT;
 	return __fd_install_received(file, ufd, o_flags);
 }
+static inline int fd_install_received(struct file *file, unsigned int o_flags)
+{
+	return __fd_install_received(file, NULL, o_flags);
+}
 
 extern void flush_delayed_fput(void);
 extern void __fput_sync(struct file *);
diff --git a/net/compat.c b/net/compat.c
index 94f288e8dac5..71494337cca7 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -299,7 +299,7 @@ void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
 
 	for (i = 0; i < fdmax; i++) {
 		err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
-		if (err)
+		if (err < 0)
 			break;
 	}
 
diff --git a/net/core/scm.c b/net/core/scm.c
index df190f1fdd28..b9a0442ebd26 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -307,7 +307,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 
 	for (i = 0; i < fdmax; i++) {
 		err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
-		if (err)
+		if (err < 0)
 			break;
 	}
 
-- 
2.25.1

