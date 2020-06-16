Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA92B1FA6C9
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 05:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgFPD0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 23:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbgFPDZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 23:25:50 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D1DC00863F
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 20:25:37 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id v24so7758884plo.6
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 20:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vY6XnehwafBZJOkQHoxk+049ZnyiWS2rNzwOao2yGyU=;
        b=H6W7RXGgrY5QaaraC5tiCpRsU2fQjleZAbAysPWcLB/lm4uvRa4nDCyrB7m5Fpv68L
         sFaHX1//uplN2O2KasdqIAT1ZcPKCkxL7o44qnplZN7SG5a1kFcuUZsiBOYrynPhn69y
         b2TZ01u48Wnn5F82vOy3WCTHh8BuZPHjk/uK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vY6XnehwafBZJOkQHoxk+049ZnyiWS2rNzwOao2yGyU=;
        b=KO/cs0gMhvvEfi1x7+EGHwhxrINyywAapSG/n+LItNIMw4+sDPyBXQsE1EwV8K3faL
         HiZHWbR2TiIECeWmUb63rgczEleE45xIKzliyzTLitYuxypCvUVpjo+fbgB2G1HyWY1f
         L/NbL5GdnN1aazGmEXp7ssjJNpAT6SZdhoM0twqJvYlRvbjiN1XyedrqEhcAJbbSfRLD
         wWrg3AtUv964Ar+2Xo+O8Xp8mKu7hJY2guGVgS2aywywGlY80lLDhrVIohHpN48Mg6Go
         n5MsWhqr4GiORqkJ7RIeVAaJ46gg/VZOEJa8sVoDwkk+ulqymgU8LMvnO2T7IaxRnEWN
         rHTg==
X-Gm-Message-State: AOAM533hATtKikukGTOYPtFZGbwiRlpgWZUbW88bcyu3nBM++Y3SfVbJ
        PaKU3XrPUvnUXIg5QzvPwO/ksQ==
X-Google-Smtp-Source: ABdhPJyih+Kodk3wUY89vUdRFHOPEIv8KpSbbjXu+ND3SdRoOfgZEnFg+Ja+pXOE9M61S+nyEKMgug==
X-Received: by 2002:a17:90a:c797:: with SMTP id gn23mr756375pjb.165.1592277936331;
        Mon, 15 Jun 2020 20:25:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o1sm767346pja.49.2020.06.15.20.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 20:25:32 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Matt Denton <mpdenton@google.com>,
        Christian Brauner <christian@brauner.io>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Tycho Andersen <tycho@tycho.ws>,
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
Subject: [PATCH v4 06/11] seccomp: Introduce addfd ioctl to seccomp user notifier
Date:   Mon, 15 Jun 2020 20:25:19 -0700
Message-Id: <20200616032524.460144-7-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200616032524.460144-1-keescook@chromium.org>
References: <20200616032524.460144-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sargun Dhillon <sargun@sargun.me>

This adds a seccomp notifier ioctl which allows for the listener to
"add" file descriptors to a process which originated a seccomp user
notification. This allows calls like mount, and mknod to be "implemented",
as the return value, and the arguments are data in memory. On the other
hand, calls like connect can be "implemented" using pidfd_getfd.

Unfortunately, there are calls which return file descriptors, like
open, which are vulnerable to ToCToU attacks, and require that the more
privileged supervisor can inspect the argument, and perform the syscall
on behalf of the process generating the notification. This allows the
file descriptor generated from that open call to be returned to the
calling process.

In addition, there is functionality to allow for replacement of specific
file descriptors, following dup2-like semantics.

As a note, the seccomp_notif_addfd structure is laid out based on 8-byte
alignment without requiring packing as there have been packing issues
with uapi highlighted before[1][2]. Although we could overload the
newfd field and use -1 to indicate that it is not to be used, doing
so requires changing the size of the fd field, and introduces struct
packing complexity.

[1]: https://lore.kernel.org/lkml/87o8w9bcaf.fsf@mid.deneb.enyo.de/
[2]: https://lore.kernel.org/lkml/a328b91d-fd8f-4f27-b3c2-91a9c45f18c0@rasmusvillemoes.dk/

Suggested-by: Matt Denton <mpdenton@google.com>
Link: https://lore.kernel.org/r/20200603011044.7972-4-sargun@sargun.me
Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/uapi/linux/seccomp.h |  25 ++++++
 kernel/seccomp.c             | 165 ++++++++++++++++++++++++++++++++++-
 2 files changed, 189 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index c1735455bc53..c347160378e5 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -113,6 +113,27 @@ struct seccomp_notif_resp {
 	__u32 flags;
 };
 
+/* valid flags for seccomp_notif_addfd */
+#define SECCOMP_ADDFD_FLAG_SETFD	(1UL << 0) /* Specify remote fd */
+
+/**
+ * struct seccomp_notif_addfd
+ * @size: The size of the seccomp_notif_addfd structure
+ * @id: The ID of the seccomp notification
+ * @flags: SECCOMP_ADDFD_FLAG_*
+ * @srcfd: The local fd number
+ * @newfd: Optional remote FD number if SETFD option is set, otherwise 0.
+ * @newfd_flags: The O_* flags the remote FD should have applied
+ */
+struct seccomp_notif_addfd {
+	__u64 size;
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
@@ -124,4 +145,8 @@ struct seccomp_notif_resp {
 #define SECCOMP_IOCTL_NOTIF_SEND	SECCOMP_IOWR(1,	\
 						struct seccomp_notif_resp)
 #define SECCOMP_IOCTL_NOTIF_ID_VALID	SECCOMP_IOR(2, __u64)
+/* On success, the return value is the remote process's added fd number */
+#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOW(3, \
+						struct seccomp_notif_addfd)
+
 #endif /* _UAPI_LINUX_SECCOMP_H */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 0016cad0e605..3c913f3b8451 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -78,10 +78,42 @@ struct seccomp_knotif {
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
@@ -784,6 +816,17 @@ static u64 seccomp_next_notify_id(struct seccomp_filter *filter)
 	return filter->notif->next_id++;
 }
 
+static void seccomp_handle_addfd(struct seccomp_kaddfd *addfd)
+{
+	/*
+	 * Remove the notification, and reset the list pointers, indicating
+	 * that it has been handled.
+	 */
+	list_del_init(&addfd->list);
+	addfd->ret = fd_replace_received(addfd->fd, addfd->file, addfd->flags);
+	complete(&addfd->completion);
+}
+
 static int seccomp_do_user_notification(int this_syscall,
 					struct seccomp_filter *match,
 					const struct seccomp_data *sd)
@@ -792,6 +835,7 @@ static int seccomp_do_user_notification(int this_syscall,
 	u32 flags = 0;
 	long ret = 0;
 	struct seccomp_knotif n = {};
+	struct seccomp_kaddfd *addfd, *tmp;
 
 	mutex_lock(&match->notify_lock);
 	err = -ENOSYS;
@@ -804,6 +848,7 @@ static int seccomp_do_user_notification(int this_syscall,
 	n.id = seccomp_next_notify_id(match);
 	init_completion(&n.ready);
 	list_add(&n.list, &match->notif->notifications);
+	INIT_LIST_HEAD(&n.addfd);
 
 	up(&match->notif->request);
 	wake_up_poll(&match->wqh, EPOLLIN | EPOLLRDNORM);
@@ -812,14 +857,31 @@ static int seccomp_do_user_notification(int this_syscall,
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
@@ -1060,6 +1122,11 @@ static int seccomp_notify_release(struct inode *inode, struct file *file)
 		knotif->error = -ENOSYS;
 		knotif->val = 0;
 
+		/*
+		 * We do not need to wake up any pending addfd messages, as
+		 * the notifier will do that for us, as this just looks
+		 * like a standard reply.
+		 */
 		complete(&knotif->ready);
 	}
 
@@ -1224,6 +1291,100 @@ static long seccomp_notify_id_valid(struct seccomp_filter *filter,
 	return ret;
 }
 
+static long seccomp_notify_addfd(struct seccomp_filter *filter,
+				 struct seccomp_notif_addfd __user *uaddfd)
+{
+	struct seccomp_notif_addfd addfd;
+	struct seccomp_knotif *knotif;
+	struct seccomp_kaddfd kaddfd;
+	u64 size;
+	int ret;
+
+	ret = get_user(size, &uaddfd->size);
+	if (ret)
+		return ret;
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
@@ -1237,6 +1398,8 @@ static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 		return seccomp_notify_send(filter, buf);
 	case SECCOMP_IOCTL_NOTIF_ID_VALID:
 		return seccomp_notify_id_valid(filter, buf);
+	case SECCOMP_IOCTL_NOTIF_ADDFD:
+		return seccomp_notify_addfd(filter, buf);
 	default:
 		return -EINVAL;
 	}
-- 
2.25.1

