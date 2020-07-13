Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF60B21A6E1
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgGIS1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgGIS04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:26:56 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0712C08E9AC
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 11:26:55 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gc15so3600758pjb.0
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 11:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iP31zHoc/uwDLAJvOc1HsZ3FqkWLjToHRtpxdoPRW+Y=;
        b=FHiPkJxbdTAgV8ax40HGfMIhESxtZ2O4kV2BJqoztbqIKmddIdEvLseWuaXvUET7nE
         ReKCYfU61iv3zd9kW5cHNA+3YEuatQBDKu0coPnskce4EmCLPOSIf8CGpOT1YW6RHV6b
         wNx3mBp3QStRj1R+FTUCKh7Ks/hpaReaAhq7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iP31zHoc/uwDLAJvOc1HsZ3FqkWLjToHRtpxdoPRW+Y=;
        b=aEbNNRFcG2WWPtavl/VcmmiWl2D7zkucp+PRcLXVVEtcnwxWiDxAWOZX/i63AFXwgM
         hqXJRmHrsDPX5umnqd0f+CQoyWHiDqRX/O3GwsvBB5r7MLCPGqFfgpVC7KebmjrrBCNH
         9OhSjUXv1q/Bv0s+uL933OZm9uetng1vMed5LYp905aXcn5I4fSdAPYnNPmrkMq0ru/O
         vG4fGMfP2Er8501NhNsl6xf8hNDdjQNElL4TNLTvmjHD1YsP3S4xKbn/QWje8o/WdZHm
         78O9+0PsaSJpud4KweBxYH6+yBXFoT0oZTuhNnJbqFdZtg60BsM2nYzu+NoeRpXNk4/5
         JDhQ==
X-Gm-Message-State: AOAM531juQAZW5ESE31Ee/NmhIK5iepErlxYbddrnMD8u9fuL0H5EzcM
        1DtrcF3wj2EdmhXDS2BD1oTRVw==
X-Google-Smtp-Source: ABdhPJzSjSmp1+KqQ7+Yq+jgw1PrwYHvuqr/eyHRMKjltsneNN+grdzR7QVCE7rZXTwjkIig36Xr7Q==
X-Received: by 2002:a17:90b:1650:: with SMTP id il16mr1370281pjb.79.1594319215338;
        Thu, 09 Jul 2020 11:26:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u2sm3261252pfl.21.2020.07.09.11.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 11:26:51 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Matt Denton <mpdenton@google.com>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>,
        Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v7 8/9] seccomp: Introduce addfd ioctl to seccomp user notifier
Date:   Thu,  9 Jul 2020 11:26:41 -0700
Message-Id: <20200709182642.1773477-9-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709182642.1773477-1-keescook@chromium.org>
References: <20200709182642.1773477-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sargun Dhillon <sargun@sargun.me>

The current SECCOMP_RET_USER_NOTIF API allows for syscall supervision over
an fd. It is often used in settings where a supervising task emulates
syscalls on behalf of a supervised task in userspace, either to further
restrict the supervisee's syscall abilities or to circumvent kernel
enforced restrictions the supervisor deems safe to lift (e.g. actually
performing a mount(2) for an unprivileged container).

While SECCOMP_RET_USER_NOTIF allows for the interception of any syscall,
only a certain subset of syscalls could be correctly emulated. Over the
last few development cycles, the set of syscalls which can't be emulated
has been reduced due to the addition of pidfd_getfd(2). With this we are
now able to, for example, intercept syscalls that require the supervisor
to operate on file descriptors of the supervisee such as connect(2).

However, syscalls that cause new file descriptors to be installed can not
currently be correctly emulated since there is no way for the supervisor
to inject file descriptors into the supervisee. This patch adds a
new addfd ioctl to remove this restriction by allowing the supervisor to
install file descriptors into the intercepted task. By implementing this
feature via seccomp the supervisor effectively instructs the supervisee
to install a set of file descriptors into its own file descriptor table
during the intercepted syscall. This way it is possible to intercept
syscalls such as open() or accept(), and install (or replace, like
dup2(2)) the supervisor's resulting fd into the supervisee. One
replacement use-case would be to redirect the stdout and stderr of a
supervisee into log file descriptors opened by the supervisor.

The ioctl handling is based on the discussions[1] of how Extensible
Arguments should interact with ioctls. Instead of building size into
the addfd structure, make it a function of the ioctl command (which
is how sizes are normally passed to ioctls). To support forward and
backward compatibility, just mask out the direction and size, and match
everything. The size (and any future direction) checks are done along
with copy_struct_from_user() logic.

As a note, the seccomp_notif_addfd structure is laid out based on 8-byte
alignment without requiring packing as there have been packing issues
with uapi highlighted before[2][3]. Although we could overload the
newfd field and use -1 to indicate that it is not to be used, doing
so requires changing the size of the fd field, and introduces struct
packing complexity.

[1]: https://lore.kernel.org/lkml/87o8w9bcaf.fsf@mid.deneb.enyo.de/
[2]: https://lore.kernel.org/lkml/a328b91d-fd8f-4f27-b3c2-91a9c45f18c0@rasmusvillemoes.dk/
[3]: https://lore.kernel.org/lkml/20200612104629.GA15814@ircssh-2.c.rugged-nimbus-611.internal

Suggested-by: Matt Denton <mpdenton@google.com>
Link: https://lore.kernel.org/r/20200603011044.7972-4-sargun@sargun.me
Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/seccomp.h      |   4 +
 include/uapi/linux/seccomp.h |  22 +++++
 kernel/seccomp.c             | 173 ++++++++++++++++++++++++++++++++++-
 3 files changed, 198 insertions(+), 1 deletion(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index babcd6c02d09..881c90b6aa25 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -10,6 +10,10 @@
 					 SECCOMP_FILTER_FLAG_NEW_LISTENER | \
 					 SECCOMP_FILTER_FLAG_TSYNC_ESRCH)
 
+/* sizeof() the first published struct seccomp_notif_addfd */
+#define SECCOMP_NOTIFY_ADDFD_SIZE_VER0 24
+#define SECCOMP_NOTIFY_ADDFD_SIZE_LATEST SECCOMP_NOTIFY_ADDFD_SIZE_VER0
+
 #ifdef CONFIG_SECCOMP
 
 #include <linux/thread_info.h>
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 965290f7dcc2..6ba18b82a02e 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -113,6 +113,25 @@ struct seccomp_notif_resp {
 	__u32 flags;
 };
 
+/* valid flags for seccomp_notif_addfd */
+#define SECCOMP_ADDFD_FLAG_SETFD	(1UL << 0) /* Specify remote fd */
+
+/**
+ * struct seccomp_notif_addfd
+ * @id: The ID of the seccomp notification
+ * @flags: SECCOMP_ADDFD_FLAG_*
+ * @srcfd: The local fd number
+ * @newfd: Optional remote FD number if SETFD option is set, otherwise 0.
+ * @newfd_flags: The O_* flags the remote FD should have applied
+ */
+struct seccomp_notif_addfd {
+	__u64 id;
+	__u32 flags;
+	__u32 srcfd;
+	__u32 newfd;
+	__u32 newfd_flags;
+};
+
 #define SECCOMP_IOC_MAGIC		'!'
 #define SECCOMP_IO(nr)			_IO(SECCOMP_IOC_MAGIC, nr)
 #define SECCOMP_IOR(nr, type)		_IOR(SECCOMP_IOC_MAGIC, nr, type)
@@ -124,5 +143,8 @@ struct seccomp_notif_resp {
 #define SECCOMP_IOCTL_NOTIF_SEND	SECCOMP_IOWR(1,	\
 						struct seccomp_notif_resp)
 #define SECCOMP_IOCTL_NOTIF_ID_VALID	SECCOMP_IOW(2, __u64)
+/* On success, the return value is the remote process's added fd number */
+#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOW(3, \
+						struct seccomp_notif_addfd)
 
 #endif /* _UAPI_LINUX_SECCOMP_H */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 866a432cd746..b2725a2a9f3e 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -87,10 +87,42 @@ struct seccomp_knotif {
 	long val;
 	u32 flags;
 
-	/* Signals when this has entered SECCOMP_NOTIFY_REPLIED */
+	/*
+	 * Signals when this has changed states, such as the listener
+	 * dying, a new seccomp addfd message, or changing to REPLIED
+	 */
 	struct completion ready;
 
 	struct list_head list;
+
+	/* outstanding addfd requests */
+	struct list_head addfd;
+};
+
+/**
+ * struct seccomp_kaddfd - container for seccomp_addfd ioctl messages
+ *
+ * @file: A reference to the file to install in the other task
+ * @fd: The fd number to install it at. If the fd number is -1, it means the
+ *      installing process should allocate the fd as normal.
+ * @flags: The flags for the new file descriptor. At the moment, only O_CLOEXEC
+ *         is allowed.
+ * @ret: The return value of the installing process. It is set to the fd num
+ *       upon success (>= 0).
+ * @completion: Indicates that the installing process has completed fd
+ *              installation, or gone away (either due to successful
+ *              reply, or signal)
+ *
+ */
+struct seccomp_kaddfd {
+	struct file *file;
+	int fd;
+	unsigned int flags;
+
+	/* To only be set on reply */
+	int ret;
+	struct completion completion;
+	struct list_head list;
 };
 
 /**
@@ -793,6 +825,17 @@ static u64 seccomp_next_notify_id(struct seccomp_filter *filter)
 	return filter->notif->next_id++;
 }
 
+static void seccomp_handle_addfd(struct seccomp_kaddfd *addfd)
+{
+	/*
+	 * Remove the notification, and reset the list pointers, indicating
+	 * that it has been handled.
+	 */
+	list_del_init(&addfd->list);
+	addfd->ret = receive_fd_replace(addfd->fd, addfd->file, addfd->flags);
+	complete(&addfd->completion);
+}
+
 static int seccomp_do_user_notification(int this_syscall,
 					struct seccomp_filter *match,
 					const struct seccomp_data *sd)
@@ -801,6 +844,7 @@ static int seccomp_do_user_notification(int this_syscall,
 	u32 flags = 0;
 	long ret = 0;
 	struct seccomp_knotif n = {};
+	struct seccomp_kaddfd *addfd, *tmp;
 
 	mutex_lock(&match->notify_lock);
 	err = -ENOSYS;
@@ -813,6 +857,7 @@ static int seccomp_do_user_notification(int this_syscall,
 	n.id = seccomp_next_notify_id(match);
 	init_completion(&n.ready);
 	list_add(&n.list, &match->notif->notifications);
+	INIT_LIST_HEAD(&n.addfd);
 
 	up(&match->notif->request);
 	wake_up_poll(&match->wqh, EPOLLIN | EPOLLRDNORM);
@@ -821,14 +866,31 @@ static int seccomp_do_user_notification(int this_syscall,
 	/*
 	 * This is where we wait for a reply from userspace.
 	 */
+wait:
 	err = wait_for_completion_interruptible(&n.ready);
 	mutex_lock(&match->notify_lock);
 	if (err == 0) {
+		/* Check if we were woken up by a addfd message */
+		addfd = list_first_entry_or_null(&n.addfd,
+						 struct seccomp_kaddfd, list);
+		if (addfd && n.state != SECCOMP_NOTIFY_REPLIED) {
+			seccomp_handle_addfd(addfd);
+			mutex_unlock(&match->notify_lock);
+			goto wait;
+		}
 		ret = n.val;
 		err = n.error;
 		flags = n.flags;
 	}
 
+	/* If there were any pending addfd calls, clear them out */
+	list_for_each_entry_safe(addfd, tmp, &n.addfd, list) {
+		/* The process went away before we got a chance to handle it */
+		addfd->ret = -ESRCH;
+		list_del_init(&addfd->list);
+		complete(&addfd->completion);
+	}
+
 	/*
 	 * Note that it's possible the listener died in between the time when
 	 * we were notified of a respons (or a signal) and when we were able to
@@ -1069,6 +1131,11 @@ static int seccomp_notify_release(struct inode *inode, struct file *file)
 		knotif->error = -ENOSYS;
 		knotif->val = 0;
 
+		/*
+		 * We do not need to wake up any pending addfd messages, as
+		 * the notifier will do that for us, as this just looks
+		 * like a standard reply.
+		 */
 		complete(&knotif->ready);
 	}
 
@@ -1233,12 +1300,109 @@ static long seccomp_notify_id_valid(struct seccomp_filter *filter,
 	return ret;
 }
 
+static long seccomp_notify_addfd(struct seccomp_filter *filter,
+				 struct seccomp_notif_addfd __user *uaddfd,
+				 unsigned int size)
+{
+	struct seccomp_notif_addfd addfd;
+	struct seccomp_knotif *knotif;
+	struct seccomp_kaddfd kaddfd;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(addfd) < SECCOMP_NOTIFY_ADDFD_SIZE_VER0);
+	BUILD_BUG_ON(sizeof(addfd) != SECCOMP_NOTIFY_ADDFD_SIZE_LATEST);
+
+	if (size < SECCOMP_NOTIFY_ADDFD_SIZE_VER0 || size >= PAGE_SIZE)
+		return -EINVAL;
+
+	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
+	if (ret)
+		return ret;
+
+	if (addfd.newfd_flags & ~O_CLOEXEC)
+		return -EINVAL;
+
+	if (addfd.flags & ~SECCOMP_ADDFD_FLAG_SETFD)
+		return -EINVAL;
+
+	if (addfd.newfd && !(addfd.flags & SECCOMP_ADDFD_FLAG_SETFD))
+		return -EINVAL;
+
+	kaddfd.file = fget(addfd.srcfd);
+	if (!kaddfd.file)
+		return -EBADF;
+
+	kaddfd.flags = addfd.newfd_flags;
+	kaddfd.fd = (addfd.flags & SECCOMP_ADDFD_FLAG_SETFD) ?
+		    addfd.newfd : -1;
+	init_completion(&kaddfd.completion);
+
+	ret = mutex_lock_interruptible(&filter->notify_lock);
+	if (ret < 0)
+		goto out;
+
+	knotif = find_notification(filter, addfd.id);
+	if (!knotif) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	/*
+	 * We do not want to allow for FD injection to occur before the
+	 * notification has been picked up by a userspace handler, or after
+	 * the notification has been replied to.
+	 */
+	if (knotif->state != SECCOMP_NOTIFY_SENT) {
+		ret = -EINPROGRESS;
+		goto out_unlock;
+	}
+
+	list_add(&kaddfd.list, &knotif->addfd);
+	complete(&knotif->ready);
+	mutex_unlock(&filter->notify_lock);
+
+	/* Now we wait for it to be processed or be interrupted */
+	ret = wait_for_completion_interruptible(&kaddfd.completion);
+	if (ret == 0) {
+		/*
+		 * We had a successful completion. The other side has already
+		 * removed us from the addfd queue, and
+		 * wait_for_completion_interruptible has a memory barrier upon
+		 * success that lets us read this value directly without
+		 * locking.
+		 */
+		ret = kaddfd.ret;
+		goto out;
+	}
+
+	mutex_lock(&filter->notify_lock);
+	/*
+	 * Even though we were woken up by a signal and not a successful
+	 * completion, a completion may have happened in the mean time.
+	 *
+	 * We need to check again if the addfd request has been handled,
+	 * and if not, we will remove it from the queue.
+	 */
+	if (list_empty(&kaddfd.list))
+		ret = kaddfd.ret;
+	else
+		list_del(&kaddfd.list);
+
+out_unlock:
+	mutex_unlock(&filter->notify_lock);
+out:
+	fput(kaddfd.file);
+
+	return ret;
+}
+
 static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 				 unsigned long arg)
 {
 	struct seccomp_filter *filter = file->private_data;
 	void __user *buf = (void __user *)arg;
 
+	/* Fixed-size ioctls */
 	switch (cmd) {
 	case SECCOMP_IOCTL_NOTIF_RECV:
 		return seccomp_notify_recv(filter, buf);
@@ -1247,6 +1411,13 @@ static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 	case SECCOMP_IOCTL_NOTIF_ID_VALID_WRONG_DIR:
 	case SECCOMP_IOCTL_NOTIF_ID_VALID:
 		return seccomp_notify_id_valid(filter, buf);
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
-- 
2.25.1

