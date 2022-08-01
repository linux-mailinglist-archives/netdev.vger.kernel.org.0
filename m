Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901CA58700F
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 20:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbiHASCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 14:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiHASCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 14:02:20 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C577924942
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 11:02:17 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-10dc1b16c12so14583451fac.6
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 11:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=qEASjFQgHEXoxjCsMlwe3mWZuEgE+ke0lwJ4HSwmC1o=;
        b=IfFAjRq+tt0+0QkOil6iDkdm5PR1dhXxMMxF03kiwCYv+F35KXZll/Aos3m0bfnTPi
         ovfmDfsxJ2/RIRYdW+e+N27wxkP57PDcj+IKBbsr/h0smuJR0MFpmf3MmZUA0r9ow4fk
         1RWQ/JoDadNY0VcpELObOrpway7EKWAzd/7Us=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=qEASjFQgHEXoxjCsMlwe3mWZuEgE+ke0lwJ4HSwmC1o=;
        b=jqJ/UvDwznwO1l03tM6fN0o/CIMNFThkUx8ZvEjEUH4NlAMBmibuHOZHF00tziyGnI
         ljF/O26uK/tlE7ZSB+vfNF0+4WxfGLCjH60iTVMCyqriTT+4nCQV1sAZldzTpO4NKN55
         FFwQB7mKu0YAcjBcVp7oyeAgnEarcrl//ivdZgR+xEM1ICpoRb0ZmEizhoB658vKhOkM
         pzIinnM0mIJP/dyg6X1o9hdLkBCwkIDDOq39vpV0LtXI2WbE6hwfDnXxPNjDGlzDPWqu
         wvW6CrVPMboE3aWdpSt/kkXhbjtJwewbgmx3FiO5NjzbDdf2Lx58RVfICWlNXtiPlk89
         ULhQ==
X-Gm-Message-State: AJIora+uFFD5m4ms3PI2oZj4/DZxBUfc2qwbKYvtTuEn65CeTMWu+QYu
        SFQbnMQ9McOwNF0rVPSOw2MSaQ==
X-Google-Smtp-Source: AGRyM1sD4g9Y9q/qyaXFCXmpcHuPT+pZOrtXQ6KE1YfTchLBWdjWov0aG3GFbThSnBywcxw6nVYfgw==
X-Received: by 2002:a05:6870:d59c:b0:101:7e59:d723 with SMTP id u28-20020a056870d59c00b001017e59d723mr8156224oao.165.1659376936978;
        Mon, 01 Aug 2022 11:02:16 -0700 (PDT)
Received: from localhost.localdomain ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id n14-20020a9d64ce000000b00618fa37308csm2881348otl.35.2022.08.01.11.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 11:02:16 -0700 (PDT)
From:   Frederick Lawler <fred@cloudflare.com>
To:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, brauner@kernel.org,
        casey@schaufler-ca.com, ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com, Frederick Lawler <fred@cloudflare.com>
Subject: [PATCH v4 1/4] security, lsm: Introduce security_create_user_ns()
Date:   Mon,  1 Aug 2022 13:01:43 -0500
Message-Id: <20220801180146.1157914-2-fred@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220801180146.1157914-1-fred@cloudflare.com>
References: <20220801180146.1157914-1-fred@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Preventing user namespace (privileged or otherwise) creation comes in a
few of forms in order of granularity:

        1. /proc/sys/user/max_user_namespaces sysctl
        2. OS specific patch(es)
        3. CONFIG_USER_NS

To block a task based on its attributes, the LSM hook cred_prepare is a
good candidate for use because it provides more granular control, and
it is called before create_user_ns():

        cred = prepare_creds()
                security_prepare_creds()
                        call_int_hook(cred_prepare, ...
        if (cred)
                create_user_ns(cred)

Since security_prepare_creds() is meant for LSMs to copy and prepare
credentials, access control is an unintended use of the hook. Therefore
introduce a new function security_create_user_ns() with an accompanying
userns_create LSM hook.

This hook takes the prepared creds for LSM authors to write policy
against. On success, the new namespace is applied to credentials,
otherwise an error is returned.

Signed-off-by: Frederick Lawler <fred@cloudflare.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>

---
Changes since v3:
- No changes
Changes since v2:
- Rename create_user_ns hook to userns_create
Changes since v1:
- Changed commit wording
- Moved execution to be after id mapping check
- Changed signature to only accept a const struct cred *
---
 include/linux/lsm_hook_defs.h | 1 +
 include/linux/lsm_hooks.h     | 4 ++++
 include/linux/security.h      | 6 ++++++
 kernel/user_namespace.c       | 5 +++++
 security/security.c           | 5 +++++
 5 files changed, 21 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index eafa1d2489fd..7ff93cb8ca8d 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -223,6 +223,7 @@ LSM_HOOK(int, -ENOSYS, task_prctl, int option, unsigned long arg2,
 	 unsigned long arg3, unsigned long arg4, unsigned long arg5)
 LSM_HOOK(void, LSM_RET_VOID, task_to_inode, struct task_struct *p,
 	 struct inode *inode)
+LSM_HOOK(int, 0, userns_create, const struct cred *cred)
 LSM_HOOK(int, 0, ipc_permission, struct kern_ipc_perm *ipcp, short flag)
 LSM_HOOK(void, LSM_RET_VOID, ipc_getsecid, struct kern_ipc_perm *ipcp,
 	 u32 *secid)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 91c8146649f5..54fe534d0e01 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -799,6 +799,10 @@
  *	security attributes, e.g. for /proc/pid inodes.
  *	@p contains the task_struct for the task.
  *	@inode contains the inode structure for the inode.
+ * @userns_create:
+ *	Check permission prior to creating a new user namespace.
+ *	@cred points to prepared creds.
+ *	Return 0 if successful, otherwise < 0 error code.
  *
  * Security hooks for Netlink messaging.
  *
diff --git a/include/linux/security.h b/include/linux/security.h
index 7fc4e9f49f54..a195bf33246a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -435,6 +435,7 @@ int security_task_kill(struct task_struct *p, struct kernel_siginfo *info,
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			unsigned long arg4, unsigned long arg5);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
+int security_create_user_ns(const struct cred *cred);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
 void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
 int security_msg_msg_alloc(struct msg_msg *msg);
@@ -1185,6 +1186,11 @@ static inline int security_task_prctl(int option, unsigned long arg2,
 static inline void security_task_to_inode(struct task_struct *p, struct inode *inode)
 { }
 
+static inline int security_create_user_ns(const struct cred *cred)
+{
+	return 0;
+}
+
 static inline int security_ipc_permission(struct kern_ipc_perm *ipcp,
 					  short flag)
 {
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 5481ba44a8d6..3f464bbda0e9 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -9,6 +9,7 @@
 #include <linux/highuid.h>
 #include <linux/cred.h>
 #include <linux/securebits.h>
+#include <linux/security.h>
 #include <linux/keyctl.h>
 #include <linux/key-type.h>
 #include <keys/user-type.h>
@@ -113,6 +114,10 @@ int create_user_ns(struct cred *new)
 	    !kgid_has_mapping(parent_ns, group))
 		goto fail_dec;
 
+	ret = security_create_user_ns(new);
+	if (ret < 0)
+		goto fail_dec;
+
 	ret = -ENOMEM;
 	ns = kmem_cache_zalloc(user_ns_cachep, GFP_KERNEL);
 	if (!ns)
diff --git a/security/security.c b/security/security.c
index 188b8f782220..ec9b4696e86c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1903,6 +1903,11 @@ void security_task_to_inode(struct task_struct *p, struct inode *inode)
 	call_void_hook(task_to_inode, p, inode);
 }
 
+int security_create_user_ns(const struct cred *cred)
+{
+	return call_int_hook(userns_create, 0, cred);
+}
+
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 {
 	return call_int_hook(ipc_permission, 0, ipcp, flag);
-- 
2.30.2

