Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23484B5F82
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 10:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbfIRIss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 04:48:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41698 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729310AbfIRIsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 04:48:46 -0400
Received: from static-dcd-cqq-121001.business.bouyguestelecom.com ([212.194.121.1] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iAVde-0004BF-Rm; Wed, 18 Sep 2019 08:48:38 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     keescook@chromium.org, luto@amacapital.net
Cc:     jannh@google.com, wad@chromium.org, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Tycho Andersen <tycho@tycho.ws>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH 1/4] seccomp: add SECCOMP_RET_USER_NOTIF_ALLOW
Date:   Wed, 18 Sep 2019 10:48:30 +0200
Message-Id: <20190918084833.9369-2-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918084833.9369-1-christian.brauner@ubuntu.com>
References: <20190918084833.9369-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows the seccomp notifier to continue a syscall. A positive
discussion about this feature was triggered by a post to the
ksummit-discuss mailing list (cf. [3]) and took place during KSummit
(cf. [1]) and again at the containers/checkpoint-restore
micro-conference at Linux Plumbers.

Recently we landed seccomp support for SECCOMP_RET_USER_NOTIF (cf. [4])
which enables a process (watchee) to retrieve an fd for its seccomp
filter. This fd can then be handed to another (usually more privileged)
process (watcher). The watcher will then be able to receive seccomp
messages about the syscalls having been performed by the watchee.

This feature is heavily used in some userspace workloads. For example,
it is currently used to intercept mknod() syscalls in user namespaces
aka in containers.
The mknod() syscall can be easily filtered based on dev_t. This allows
us to only intercept a very specific subset of mknod() syscalls.
Furthermore, mknod() is not possible in user namespaces toto coelo and
so intercepting and denying syscalls that are not in the whitelist on
accident is not a big deal. The watchee won't notice a difference.

In contrast to mknod(), a lot of other syscall we intercept (e.g.
setxattr()) cannot be easily filtered like mknod() because they have
pointer arguments. Additionally, some of them might actually succeed in
user namespaces (e.g. setxattr() for all "user.*" xattrs). Since we
currently cannot tell seccomp to continue from a user notifier we are
stuck with performing all of the syscalls in lieu of the container. This
is a huge security liability since it is extremely difficult to
correctly assume all of the necessary privileges of the calling task
such that the syscall can be successfully emulated without escaping
other additional security restrictions (think missing CAP_MKNOD for
mknod(), or MS_NODEV on a filesystem etc.). This can be solved by
telling seccomp to resume the syscall.

One thing that came up in the discussion was the problem that another
thread could change the memory after userspace has decided to let the
syscall continue which is a well known TOCTOU with seccomp which is
present in other ways already.
The discussion showed that this feature is already very useful for any
syscall without pointer arguments. For any accidentally intercepted
non-pointer syscall it is safe to continue.
For syscalls with pointer arguments there is a race but for any cautious
userspace and the main usec cases the race doesn't matter. The notifier
is intended to be used in a scenario where a more privileged watcher
supervises the syscalls of lesser privileged watchee to allow it to get
around kernel-enforced limitations by performing the syscall for it
whenever deemed save by the watcher. Hence, if a user tricks the watcher
into allowing a syscall they will either get a deny based on
kernel-enforced restrictions later or they will have changed the
arguments in such a way that they manage to perform a syscall with
arguments that they would've been allowed to do anyway.
In general, it is good to point out again, that the notifier fd was not
intended to allow userspace to implement a security policy but rather to
work around kernel security mechanisms in cases where the watcher knows
that a given action is safe to perform.

/* References */
[1]: https://linuxplumbersconf.org/event/4/contributions/560
[2]: https://linuxplumbersconf.org/event/4/contributions/477
[3]: https://lore.kernel.org/r/20190719093538.dhyopljyr5ns33qx@brauner.io
[4]: commit 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Tycho Andersen <tycho@tycho.ws>
CC: Tyler Hicks <tyhicks@canonical.com>
Cc: Jann Horn <jannh@google.com>
---
 include/uapi/linux/seccomp.h |  2 ++
 kernel/seccomp.c             | 24 ++++++++++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 90734aa5aa36..2c23b9aa6383 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -76,6 +76,8 @@ struct seccomp_notif {
 	struct seccomp_data data;
 };
 
+#define SECCOMP_RET_USER_NOTIF_ALLOW 0x00000001
+
 struct seccomp_notif_resp {
 	__u64 id;
 	__s64 val;
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index dba52a7db5e8..cdb90184d6d7 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -75,6 +75,7 @@ struct seccomp_knotif {
 	/* The return values, only valid when in SECCOMP_NOTIFY_REPLIED */
 	int error;
 	long val;
+	u32 flags;
 
 	/* Signals when this has entered SECCOMP_NOTIFY_REPLIED */
 	struct completion ready;
@@ -732,11 +733,12 @@ static u64 seccomp_next_notify_id(struct seccomp_filter *filter)
 	return filter->notif->next_id++;
 }
 
-static void seccomp_do_user_notification(int this_syscall,
+static bool seccomp_do_user_notification(int this_syscall,
 					 struct seccomp_filter *match,
 					 const struct seccomp_data *sd)
 {
 	int err;
+	u32 flags = 0;
 	long ret = 0;
 	struct seccomp_knotif n = {};
 
@@ -764,6 +766,7 @@ static void seccomp_do_user_notification(int this_syscall,
 	if (err == 0) {
 		ret = n.val;
 		err = n.error;
+		flags = n.flags;
 	}
 
 	/*
@@ -780,8 +783,14 @@ static void seccomp_do_user_notification(int this_syscall,
 		list_del(&n.list);
 out:
 	mutex_unlock(&match->notify_lock);
+
+	/* perform syscall */
+	if (flags & SECCOMP_RET_USER_NOTIF_ALLOW)
+		return false;
+
 	syscall_set_return_value(current, task_pt_regs(current),
 				 err, ret);
+	return true;
 }
 
 static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
@@ -867,8 +876,10 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 		return 0;
 
 	case SECCOMP_RET_USER_NOTIF:
-		seccomp_do_user_notification(this_syscall, match, sd);
-		goto skip;
+		if (seccomp_do_user_notification(this_syscall, match, sd))
+			goto skip;
+
+		return 0;
 
 	case SECCOMP_RET_LOG:
 		seccomp_log(this_syscall, 0, action, true);
@@ -1087,7 +1098,11 @@ static long seccomp_notify_send(struct seccomp_filter *filter,
 	if (copy_from_user(&resp, buf, sizeof(resp)))
 		return -EFAULT;
 
-	if (resp.flags)
+	if (resp.flags & ~SECCOMP_RET_USER_NOTIF_ALLOW)
+		return -EINVAL;
+
+	if ((resp.flags & SECCOMP_RET_USER_NOTIF_ALLOW) &&
+	    (resp.error || resp.val))
 		return -EINVAL;
 
 	ret = mutex_lock_interruptible(&filter->notify_lock);
@@ -1116,6 +1131,7 @@ static long seccomp_notify_send(struct seccomp_filter *filter,
 	knotif->state = SECCOMP_NOTIFY_REPLIED;
 	knotif->error = resp.error;
 	knotif->val = resp.val;
+	knotif->flags = resp.flags;
 	complete(&knotif->ready);
 out:
 	mutex_unlock(&filter->notify_lock);
-- 
2.23.0

