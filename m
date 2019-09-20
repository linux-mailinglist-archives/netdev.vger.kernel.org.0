Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE32DB8CED
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 10:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408302AbfITIah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 04:30:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39514 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408194AbfITIag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 04:30:36 -0400
Received: from static-dcd-cqq-121001.business.bouyguestelecom.com ([212.194.121.1] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iBEJB-0007Va-CH; Fri, 20 Sep 2019 08:30:29 +0000
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
Subject: [PATCH v2 1/3] seccomp: add SECCOMP_USER_NOTIF_FLAG_CONTINUE
Date:   Fri, 20 Sep 2019 10:30:05 +0200
Message-Id: <20190920083007.11475-2-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190920083007.11475-1-christian.brauner@ubuntu.com>
References: <20190920083007.11475-1-christian.brauner@ubuntu.com>
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

Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Tycho Andersen <tycho@tycho.ws>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
CC: Tyler Hicks <tyhicks@canonical.com>
---
/* v2 */
- Jann Horn <jannh@google.com>:
  - mention that SECCOMP_USER_NOTIF_FLAG_CONTINUE can be used to override lower
    SECCOMP_RET_USER_NOTIF and SECCOMP_RET_TRACE filters

/* v1 */
Link: https://lore.kernel.org/r/20190919095903.19370-2-christian.brauner@ubuntu.com
- Kees Cook <keescook@chromium.org>, Tycho Andersen <tycho@tycho.ws>:
  - s/SECCOMP_RET_USER_NOTIF_ALLOW/SECCOMP_USER_NOTIF_FLAG_CONTINUE/g
- Kees Cook <keescook@chromium.org>:
  - put giant warning about the dangers, and correct usage of the
    SECCOMP_USER_NOTIF_FLAG_CONTINUE flag
- Kees Cook <keescook@chromium.org>:
  - change return type for seccomp_do_user_notification() to int to align with
    similar functions

/* v0 */
Link: https://lore.kernel.org/r/20190918084833.9369-2-christian.brauner@ubuntu.com
---
 include/uapi/linux/seccomp.h | 28 ++++++++++++++++++++++++++++
 kernel/seccomp.c             | 28 ++++++++++++++++++++++------
 2 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 90734aa5aa36..61fbbb7c1ee9 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -76,6 +76,34 @@ struct seccomp_notif {
 	struct seccomp_data data;
 };
 
+/*
+ * Valid flags for struct seccomp_notif_resp
+ *
+ * Note, the SECCOMP_USER_NOTIF_FLAG_CONTINUE flag must be used with caution!
+ * If set by the process supervising the syscalls of another process the
+ * syscall will continue. This is problematic because of an inherent TOCTOU.
+ * An attacker can exploit the time while the supervised process is waiting on
+ * a response from the supervising process to rewrite syscall arguments which
+ * are passed as pointers of the intercepted syscall.
+ * It should be absolutely clear that this means that the seccomp notifier
+ * _cannot_ be used to implement a security policy! It should only ever be used
+ * in scenarios where a more privileged process supervises the syscalls of a
+ * lesser privileged process to get around kernel-enforced security
+ * restrictions when the privileged process deems this safe. In other words,
+ * in order to continue a syscall the supervising process should be sure that
+ * another security mechanism or the kernel itself will sufficiently block
+ * syscalls if arguments are rewritten to something unsafe.
+ *
+ * Similar precautions should be applied when stacking SECCOMP_RET_USER_NOTIF.
+ * For SECCOMP_RET_USER_NOTIF filters acting on the same syscall the uppermost
+ * filter takes precedence. This means that the uppermost
+ * SECCOMP_RET_USER_NOTIF filter can override any SECCOMP_IOCTL_NOTIF_SEND from
+ * lower filters essentially allowing all syscalls to pass by using
+ * SECCOMP_USER_NOTIF_FLAG_CONTINUE. Note that SECCOMP_RET_USER_NOTIF can
+ * equally be overriden by SECCOMP_USER_NOTIF_FLAG_CONTINUE.
+ */
+#define SECCOMP_USER_NOTIF_FLAG_CONTINUE BIT(0)
+
 struct seccomp_notif_resp {
 	__u64 id;
 	__s64 val;
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index dba52a7db5e8..12d2227e5786 100644
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
-					 struct seccomp_filter *match,
-					 const struct seccomp_data *sd)
+static int seccomp_do_user_notification(int this_syscall,
+					struct seccomp_filter *match,
+					const struct seccomp_data *sd)
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
+	/* Userspace requests to continue the syscall. */
+	if (flags & SECCOMP_USER_NOTIF_FLAG_CONTINUE)
+		return 0;
+
 	syscall_set_return_value(current, task_pt_regs(current),
 				 err, ret);
+	return -1;
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
+	if (resp.flags & ~SECCOMP_USER_NOTIF_FLAG_CONTINUE)
+		return -EINVAL;
+
+	if ((resp.flags & SECCOMP_USER_NOTIF_FLAG_CONTINUE) &&
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

