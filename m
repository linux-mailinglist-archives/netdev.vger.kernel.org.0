Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F77553F15
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 01:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238239AbiFUXjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 19:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344222AbiFUXjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 19:39:51 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7579E3122C
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:39:49 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id q11so19055766oih.10
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=huv2RTjsGDwilBCbef/P98mwZ35L+fncBIqkcOwhEoQ=;
        b=Cdk7IqdUOCuZT8nbDb+rIQqHc9Qld5ajj6cuRHEGtM9rz2FkUEKrHTx4KvJ45/1udm
         NQeazcjps23qhrOc4Us53GBsH0QktC7SY74rqwXecFNimTeSoplvg9XOa9UEbul0hDqR
         97UWIuKIsuumf2vl2DaTBcXThnwFpmj21ZODw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=huv2RTjsGDwilBCbef/P98mwZ35L+fncBIqkcOwhEoQ=;
        b=npxyb4E+V/ntCPJVVtiHW53/ld04JqRLl8oW7+BnDnjyvX9eVz9iObZnssr5U3kW33
         qHyyr5UfpVuWTsmVh0+fjgPWNSQ0nYVdKO9744UTrToWoS2E4iR9QL0W8D99TE/3wqgX
         dma8QOImN/CaVvWSjMjWRK8IjtqXiuYKbRQdUq8LE6BG+oP4/e8yu3Wftx0jDf9ac6Ag
         60upOsAf/Sqw+0D0bFTTVKKSsgj9fIiauWdFYSPC+ewNkRA44C3HGBLucqZCtYtAOQxE
         +jho+N57Ly50oR15xSNfsZtiBniZHYxa7JgOzv6tqbqWzRJs3MnhJnfnei6dLWFjuptP
         Yo5w==
X-Gm-Message-State: AJIora9w+8DngE6sDTSjf0JTC1zDEizUDFq2LfmWnVqieWrq0lIbesGI
        bMoPRFOS44RfRiaZ6CYroHJihkEgzHU2bA==
X-Google-Smtp-Source: AGRyM1vTDxHi1GKF6Vuy5fCOCpBYBG+YhPjJ7KOlB9WbhbBwJmrY5xotmQwM3vjhmPjn+deeENWm2g==
X-Received: by 2002:a05:6808:11c7:b0:2f9:f96c:d0ee with SMTP id p7-20020a05680811c700b002f9f96cd0eemr325810oiv.134.1655854788652;
        Tue, 21 Jun 2022 16:39:48 -0700 (PDT)
Received: from localhost.localdomain ([172.58.70.161])
        by smtp.gmail.com with ESMTPSA id v73-20020acaac4c000000b00326414c1bb7sm9839181oie.35.2022.06.21.16.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 16:39:48 -0700 (PDT)
From:   Frederick Lawler <fred@cloudflare.com>
To:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org
Cc:     brauner@kernel.org, casey@schaufler-ca.com, paul@paul-moore.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com, Frederick Lawler <fred@cloudflare.com>
Subject: [PATCH 1/2] security, lsm: Introduce security_create_user_ns()
Date:   Tue, 21 Jun 2022 18:39:38 -0500
Message-Id: <20220621233939.993579-2-fred@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220621233939.993579-1-fred@cloudflare.com>
References: <20220621233939.993579-1-fred@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
create_user_ns LSM hook.

This hook takes the prepared creds and the newly created user namespace
for LSM authors to write policy against. On success, the new namespace
is applied to credentials, otherwise an error is returned.

Signed-off-by: Frederick Lawler <fred@cloudflare.com>
---
 include/linux/lsm_hook_defs.h | 2 ++
 include/linux/lsm_hooks.h     | 5 +++++
 include/linux/security.h      | 8 ++++++++
 kernel/user_namespace.c       | 5 +++++
 security/security.c           | 6 ++++++
 5 files changed, 26 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index eafa1d2489fd..bd9b38db4d03 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -223,6 +223,8 @@ LSM_HOOK(int, -ENOSYS, task_prctl, int option, unsigned long arg2,
 	 unsigned long arg3, unsigned long arg4, unsigned long arg5)
 LSM_HOOK(void, LSM_RET_VOID, task_to_inode, struct task_struct *p,
 	 struct inode *inode)
+LSM_HOOK(int, 0, create_user_ns, const struct cred *new,
+	 const struct user_namespace *new_userns)
 LSM_HOOK(int, 0, ipc_permission, struct kern_ipc_perm *ipcp, short flag)
 LSM_HOOK(void, LSM_RET_VOID, ipc_getsecid, struct kern_ipc_perm *ipcp,
 	 u32 *secid)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 91c8146649f5..1356a792a6bd 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -799,6 +799,11 @@
  *	security attributes, e.g. for /proc/pid inodes.
  *	@p contains the task_struct for the task.
  *	@inode contains the inode structure for the inode.
+ * @create_user_ns:
+ *	Check permission prior to assigning the new namespace to @cred->user_ns.
+ *	@cred points to prepared creds.
+ *	@new_userns points to the newly created user namespace.
+ *	Return 0 if successful, otherwise < 0 error code.
  *
  * Security hooks for Netlink messaging.
  *
diff --git a/include/linux/security.h b/include/linux/security.h
index 7fc4e9f49f54..a656dbe7b65a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -435,6 +435,8 @@ int security_task_kill(struct task_struct *p, struct kernel_siginfo *info,
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			unsigned long arg4, unsigned long arg5);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
+int security_create_user_ns(const struct cred *cred,
+			    const struct user_namespace *new_userns);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
 void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
 int security_msg_msg_alloc(struct msg_msg *msg);
@@ -1185,6 +1187,12 @@ static inline int security_task_prctl(int option, unsigned long arg2,
 static inline void security_task_to_inode(struct task_struct *p, struct inode *inode)
 { }
 
+static inline int security_create_user_ns(const struct cred *cred,
+					  const struct user_namespace *new_userns)
+{
+	return 0;
+}
+
 static inline int security_ipc_permission(struct kern_ipc_perm *ipcp,
 					  short flag)
 {
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 5481ba44a8d6..8c5e5592a503 100644
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
@@ -153,6 +154,10 @@ int create_user_ns(struct cred *new)
 	if (!setup_userns_sysctls(ns))
 		goto fail_keyring;
 
+	ret = security_create_user_ns(new, ns);
+	if (ret < 0)
+		goto fail_keyring;
+
 	set_cred_user_ns(new, ns);
 	return 0;
 fail_keyring:
diff --git a/security/security.c b/security/security.c
index 188b8f782220..d6b1751805ca 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1903,6 +1903,12 @@ void security_task_to_inode(struct task_struct *p, struct inode *inode)
 	call_void_hook(task_to_inode, p, inode);
 }
 
+int security_create_user_ns(const struct cred *cred,
+			    const struct user_namespace *new_userns)
+{
+	return call_int_hook(create_user_ns, 0, cred, new_userns);
+}
+
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 {
 	return call_int_hook(ipc_permission, 0, ipcp, flag);
-- 
2.30.2

