Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D39738282E
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbhEQJYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:24:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23945 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235811AbhEQJYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:24:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621243366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Lh52OqTC2uVe5TI8Cj5aeQ7Ezjtu05JjDHOo/9GMNws=;
        b=XUZ81vZxb/wFtk4TDZzuxl+tfCITMohUH15CzxyM9JU8Z6+SL527en8osYR49bX8Gc6o7C
        AfU3fd2vWN/DFLV2qJ3UbN0LVX5BML0SQVdE4r+2qhvf3Lf1Jrz3z98gJlzeTHy5uvJzKD
        JfODfzAXoNFxJif3rsDA9E4SPNM6ZhM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-de3dLY17POmIfdt-ALw0vQ-1; Mon, 17 May 2021 05:20:12 -0400
X-MC-Unique: de3dLY17POmIfdt-ALw0vQ-1
Received: by mail-ej1-f72.google.com with SMTP id i8-20020a1709068508b02903d75f46b7aeso430424ejx.18
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:20:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lh52OqTC2uVe5TI8Cj5aeQ7Ezjtu05JjDHOo/9GMNws=;
        b=QGGO4Y7C2Du+o72in5drLhnk6j5NE703USyGThzy6ODkCQiaInkWSeeP2Z2g0hvfSj
         UOUPrpsTbk1pjO80nkM6Ku9ed/vi2FQxwzRy0JdSLE5yrdrPIOIzdtx5fEM7C5cMoz+b
         v9C8IqOUROz0kfNArZn8Rd94P1IkiE/o1dB5eFT0VlnasWo9ggLaIHoDtcFyCTLHhnBW
         M1fOgVEP8mgIwg8H1koXtIrDiJO2jBUob97p32oVwoP/2SiGCF/CElraSHED/xafj6uq
         kNFpb0vkHNxcH6vbqSB6DHQf0IGgVtnV3soNI+NrNYqRAMv8wIJf7r/dIY53o5bxLr+7
         Z2mg==
X-Gm-Message-State: AOAM532JrAEuifwJRbbWWU821zBCmH8UJPxePqX/kXsHIoLoI+T5Mb1y
        sL8+VRLwvPlDEynsC3KB0UZv1q8S5J9DSn9dyYinmNxmveOskgBxTg99a/K4NLTGBAcxxBpTBju
        rVjp7C92XUFdje2RV
X-Received: by 2002:aa7:d9c8:: with SMTP id v8mr15061161eds.186.1621243210383;
        Mon, 17 May 2021 02:20:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaCV4robSlfb92PPbNHj/c+tEG3xQ7HbJnmq6teN5zQAr/K9LMUZ4/D22Dap+04FeLklzF3Q==
X-Received: by 2002:aa7:d9c8:: with SMTP id v8mr15061143eds.186.1621243210166;
        Mon, 17 May 2021 02:20:10 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b105:dd00:277b:6436:24db:9466])
        by smtp.gmail.com with ESMTPSA id b9sm1905323edt.71.2021.05.17.02.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:20:09 -0700 (PDT)
From:   Ondrej Mosnacek <omosnace@redhat.com>
To:     linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown permission checks
Date:   Mon, 17 May 2021 11:20:06 +0200
Message-Id: <20210517092006.803332-1-omosnace@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
lockdown") added an implementation of the locked_down LSM hook to
SELinux, with the aim to restrict which domains are allowed to perform
operations that would breach lockdown.

However, in several places the security_locked_down() hook is called in
situations where the current task isn't doing any action that would
directly breach lockdown, leading to SELinux checks that are basically
bogus.

Since in most of these situations converting the callers such that
security_locked_down() is called in a context where the current task
would be meaningful for SELinux is impossible or very non-trivial (and
could lead to TOCTOU issues for the classic Lockdown LSM
implementation), fix this by modifying the hook to accept a struct cred
pointer as argument, where NULL will be interpreted as a request for a
"global", task-independent lockdown decision only. Then modify SELinux
to ignore calls with cred == NULL.

Since most callers will just want to pass current_cred() as the cred
parameter, rename the hook to security_cred_locked_down() and provide
the original security_locked_down() function as a simple wrapper around
the new hook.

The callers migrated to the new hook, passing NULL as cred:
1. arch/powerpc/xmon/xmon.c
     Here the hook seems to be called from non-task context and is only
     used for redacting some sensitive values from output sent to
     userspace.
2. fs/tracefs/inode.c:tracefs_create_file()
     Here the call is used to prevent creating new tracefs entries when
     the kernel is locked down. Assumes that locking down is one-way -
     i.e. if the hook returns non-zero once, it will never return zero
     again, thus no point in creating these files.
3. kernel/trace/bpf_trace.c:bpf_probe_read_kernel{,_str}_common()
     Called when a BPF program calls a helper that could leak kernel
     memory. The task context is not relevant here, since the program
     may very well be run in the context of a different task than the
     consumer of the data.
     See: https://bugzilla.redhat.com/show_bug.cgi?id=1955585
4. net/xfrm/xfrm_user.c:copy_to_user_*()
     Here a cryptographic secret is redacted based on the value returned
     from the hook. There are two possible actions that may lead here:
     a) A netlink message XFRM_MSG_GETSA with NLM_F_DUMP set - here the
        task context is relevant, since the dumped data is sent back to
        the current task.
     b) When deleting an SA via XFRM_MSG_DELSA, the dumped SAs are
        broadcasted to tasks subscribed to XFRM events - here the
        SELinux check is not meningful as the current task's creds do
        not represent the tasks that could potentially see the secret.
     It really doesn't seem worth it to try to preserve the check in the
     a) case, since the eventual leak can be circumvented anyway via b),
     plus there is no way for the task to indicate that it doesn't care
     about the actual key value, so the check could generate a lot of
     noise.

Improvements-suggested-by: Casey Schaufler <casey@schaufler-ca.com>
Fixes: 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---

v2:
- change to a single hook based on suggestions by Casey Schaufler

v1: https://lore.kernel.org/lkml/20210507114048.138933-1-omosnace@redhat.com/

 arch/powerpc/xmon/xmon.c      |  4 ++--
 fs/tracefs/inode.c            |  2 +-
 include/linux/lsm_hook_defs.h |  3 ++-
 include/linux/lsm_hooks.h     |  3 ++-
 include/linux/security.h      | 11 ++++++++---
 kernel/trace/bpf_trace.c      |  4 ++--
 net/xfrm/xfrm_user.c          |  2 +-
 security/lockdown/lockdown.c  |  5 +++--
 security/security.c           |  6 +++---
 security/selinux/hooks.c      | 12 +++++++++---
 10 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index c8173e92f19d..90992793b4c5 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -299,7 +299,7 @@ static bool xmon_is_locked_down(void)
 	static bool lockdown;
 
 	if (!lockdown) {
-		lockdown = !!security_locked_down(LOCKDOWN_XMON_RW);
+		lockdown = !!security_cred_locked_down(NULL, LOCKDOWN_XMON_RW);
 		if (lockdown) {
 			printf("xmon: Disabled due to kernel lockdown\n");
 			xmon_is_ro = true;
@@ -307,7 +307,7 @@ static bool xmon_is_locked_down(void)
 	}
 
 	if (!xmon_is_ro) {
-		xmon_is_ro = !!security_locked_down(LOCKDOWN_XMON_WR);
+		xmon_is_ro = !!security_cred_locked_down(NULL, LOCKDOWN_XMON_WR);
 		if (xmon_is_ro)
 			printf("xmon: Read-only due to kernel lockdown\n");
 	}
diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 1261e8b41edb..7edde3fc22f5 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -396,7 +396,7 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
 	struct dentry *dentry;
 	struct inode *inode;
 
-	if (security_locked_down(LOCKDOWN_TRACEFS))
+	if (security_cred_locked_down(NULL, LOCKDOWN_TRACEFS))
 		return NULL;
 
 	if (!(mode & S_IFMT))
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 2adeea44c0d5..0115d7e3db55 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -393,7 +393,8 @@ LSM_HOOK(int, 0, bpf_prog_alloc_security, struct bpf_prog_aux *aux)
 LSM_HOOK(void, LSM_RET_VOID, bpf_prog_free_security, struct bpf_prog_aux *aux)
 #endif /* CONFIG_BPF_SYSCALL */
 
-LSM_HOOK(int, 0, locked_down, enum lockdown_reason what)
+LSM_HOOK(int, 0, cred_locked_down, const struct cred *cred,
+	 enum lockdown_reason what)
 
 #ifdef CONFIG_PERF_EVENTS
 LSM_HOOK(int, 0, perf_event_open, struct perf_event_attr *attr, int type)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 5c4c5c0602cb..2d2d82ffea34 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1539,10 +1539,11 @@
  * @bpf_prog_free_security:
  *	Clean up the security information stored inside bpf prog.
  *
- * @locked_down:
+ * @cred_locked_down:
  *     Determine whether a kernel feature that potentially enables arbitrary
  *     code execution in kernel space should be permitted.
  *
+ *     @cred: credential asociated with the operation, or NULL if not applicable
  *     @what: kernel feature being accessed
  *
  * Security hooks for perf events
diff --git a/include/linux/security.h b/include/linux/security.h
index 24eda04221e9..6a609787a03a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -26,6 +26,7 @@
 #include <linux/kernel_read_file.h>
 #include <linux/key.h>
 #include <linux/capability.h>
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/err.h>
@@ -33,7 +34,6 @@
 #include <linux/mm.h>
 
 struct linux_binprm;
-struct cred;
 struct rlimit;
 struct kernel_siginfo;
 struct sembuf;
@@ -470,7 +470,7 @@ void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
 int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
-int security_locked_down(enum lockdown_reason what);
+int security_cred_locked_down(const struct cred *cred, enum lockdown_reason what);
 #else /* CONFIG_SECURITY */
 
 static inline int call_blocking_lsm_notifier(enum lsm_event event, void *data)
@@ -1343,12 +1343,17 @@ static inline int security_inode_getsecctx(struct inode *inode, void **ctx, u32
 {
 	return -EOPNOTSUPP;
 }
-static inline int security_locked_down(enum lockdown_reason what)
+static inline int security_cred_locked_down(struct cred *cred, enum lockdown_reason what)
 {
 	return 0;
 }
 #endif	/* CONFIG_SECURITY */
 
+static inline int security_locked_down(enum lockdown_reason what)
+{
+	return security_cred_locked_down(current_cred(), what);
+}
+
 #if defined(CONFIG_SECURITY) && defined(CONFIG_WATCH_QUEUE)
 int security_post_notification(const struct cred *w_cred,
 			       const struct cred *cred,
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d2d7cf6cfe83..d8a242837c1e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -215,7 +215,7 @@ const struct bpf_func_proto bpf_probe_read_user_str_proto = {
 static __always_inline int
 bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr)
 {
-	int ret = security_locked_down(LOCKDOWN_BPF_READ);
+	int ret = security_cred_locked_down(NULL, LOCKDOWN_BPF_READ);
 
 	if (unlikely(ret < 0))
 		goto fail;
@@ -246,7 +246,7 @@ const struct bpf_func_proto bpf_probe_read_kernel_proto = {
 static __always_inline int
 bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr)
 {
-	int ret = security_locked_down(LOCKDOWN_BPF_READ);
+	int ret = security_cred_locked_down(NULL, LOCKDOWN_BPF_READ);
 
 	if (unlikely(ret < 0))
 		goto fail;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index f0aecee4d539..5f45848c4ff3 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -851,7 +851,7 @@ static int copy_user_offload(struct xfrm_state_offload *xso, struct sk_buff *skb
 static bool xfrm_redact(void)
 {
 	return IS_ENABLED(CONFIG_SECURITY) &&
-		security_locked_down(LOCKDOWN_XFRM_SECRET);
+		security_cred_locked_down(NULL, LOCKDOWN_XFRM_SECRET);
 }
 
 static int copy_to_user_auth(struct xfrm_algo_auth *auth, struct sk_buff *skb)
diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
index 87cbdc64d272..2a13c866c22a 100644
--- a/security/lockdown/lockdown.c
+++ b/security/lockdown/lockdown.c
@@ -55,7 +55,8 @@ early_param("lockdown", lockdown_param);
  * lockdown_is_locked_down - Find out if the kernel is locked down
  * @what: Tag to use in notice generated if lockdown is in effect
  */
-static int lockdown_is_locked_down(enum lockdown_reason what)
+static int lockdown_is_locked_down(const struct cred *cred,
+				   enum lockdown_reason what)
 {
 	if (WARN(what >= LOCKDOWN_CONFIDENTIALITY_MAX,
 		 "Invalid lockdown reason"))
@@ -72,7 +73,7 @@ static int lockdown_is_locked_down(enum lockdown_reason what)
 }
 
 static struct security_hook_list lockdown_hooks[] __lsm_ro_after_init = {
-	LSM_HOOK_INIT(locked_down, lockdown_is_locked_down),
+	LSM_HOOK_INIT(cred_locked_down, lockdown_is_locked_down),
 };
 
 static int __init lockdown_lsm_init(void)
diff --git a/security/security.c b/security/security.c
index 0c1c9796e3e4..c987b70bc16c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2592,11 +2592,11 @@ void security_bpf_prog_free(struct bpf_prog_aux *aux)
 }
 #endif /* CONFIG_BPF_SYSCALL */
 
-int security_locked_down(enum lockdown_reason what)
+int security_cred_locked_down(const struct cred *cred, enum lockdown_reason what)
 {
-	return call_int_hook(locked_down, 0, what);
+	return call_int_hook(cred_locked_down, 0, cred, what);
 }
-EXPORT_SYMBOL(security_locked_down);
+EXPORT_SYMBOL(security_cred_locked_down);
 
 #ifdef CONFIG_PERF_EVENTS
 int security_perf_event_open(struct perf_event_attr *attr, int type)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index eaea837d89d1..c415e3ca4f24 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7017,10 +7017,10 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
 }
 #endif
 
-static int selinux_lockdown(enum lockdown_reason what)
+static int selinux_lockdown(const struct cred *cred, enum lockdown_reason what)
 {
 	struct common_audit_data ad;
-	u32 sid = current_sid();
+	u32 sid;
 	int invalid_reason = (what <= LOCKDOWN_NONE) ||
 			     (what == LOCKDOWN_INTEGRITY_MAX) ||
 			     (what >= LOCKDOWN_CONFIDENTIALITY_MAX);
@@ -7032,6 +7032,12 @@ static int selinux_lockdown(enum lockdown_reason what)
 		return -EINVAL;
 	}
 
+	/* Ignore if there is no relevant cred to check against */
+	if (!cred)
+		return 0;
+
+	sid = cred_sid(cred);
+
 	ad.type = LSM_AUDIT_DATA_LOCKDOWN;
 	ad.u.reason = what;
 
@@ -7353,7 +7359,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(perf_event_write, selinux_perf_event_write),
 #endif
 
-	LSM_HOOK_INIT(locked_down, selinux_lockdown),
+	LSM_HOOK_INIT(cred_locked_down, selinux_lockdown),
 
 	/*
 	 * PUT "CLONING" (ACCESSING + ALLOCATING) HOOKS HERE
-- 
2.31.1

