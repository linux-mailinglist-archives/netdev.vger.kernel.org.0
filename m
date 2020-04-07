Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE451A04F3
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 04:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgDGCg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 22:36:29 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54916 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgDGCg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 22:36:28 -0400
Received: by mail-pj1-f67.google.com with SMTP id np9so111645pjb.4;
        Mon, 06 Apr 2020 19:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ExK57tXOixEJPtpgQX6g+8AKcUB7kSM0nnsqiNXCe8g=;
        b=b57Mqs1SyShP3Bt0t9JzzA0NZqy2N4G3vB+SfwUQSesJu7SXsYL38fHId7tYnxONr9
         MlBOzEeaZw/TeYN+AIaWPvxmRwZkdYWKjWjNzPiLcBUV3Hha8AxakAfVC5BNCZS/KVBx
         904wYURAm3l73G6TCXuHoCmOJQQetZAssWnL+iMrUgAvNYJhqmUoMNNAgY3vJcJcCbiU
         NUp8H/IMn/Luk/iGvQlLSSrQhXNp53oOTEkj/xx+iB7IzQayOGMBir4tBjdE2PCuCtGB
         3ci41UWd27FUwH/MKTpH9KPsbxplzUBysnkQXr6Zv826LQqCDU6U5xVe0QyuPkb/JlG8
         sjXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ExK57tXOixEJPtpgQX6g+8AKcUB7kSM0nnsqiNXCe8g=;
        b=SG0o2LmNPmmMGDiueFhiYpkp2hWZcv/kist9t3C3uDkRqedN1FG7JIU+dyRcytyvz6
         w7QA9T2QxvhvyK2SGfwmMd61XnaGahdCE2SZ1wfEzaQ2ghcU91Vwb7DIyKU9JdWsLWtl
         O4AE8ZDVO4/rHtwyndm5IXtZK2FaHD9zB+e64ku7Awv9t+2f+Uct5XfL3UVYVrWlG5Md
         Y6MQzPkbYvsPq5eS6cuIduspjARLHh4f1TG9ePvFTxEDuMsNSIz8IbkdPWST7zS5oK5/
         gojsPjrwkxTg4dABlMOcsO+VNAEe8KBNuzaxIO9s0UslVuoSW0lNNRHP7zXdhdGIc1ac
         Ajiw==
X-Gm-Message-State: AGi0PuYQ+pwxExV3KyjZcXlgxSrvjrnj3cFe10urHYcc5YNDO3JiT4TX
        AVHNDKv9osLMpGMYO0FRdsM=
X-Google-Smtp-Source: APiQypIeTnYYzsxQVldoeNZqGd/EuxIqSfFT/gSqGItMiyge00wsJhmlNbG62DgPwOfbvsZD/piv1w==
X-Received: by 2002:a17:902:5a4b:: with SMTP id f11mr334310plm.7.1586226986814;
        Mon, 06 Apr 2020 19:36:26 -0700 (PDT)
Received: from ubuntu ([125.132.45.8])
        by smtp.gmail.com with ESMTPSA id v59sm168874pjb.26.2020.04.06.19.36.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 Apr 2020 19:36:26 -0700 (PDT)
Date:   Tue, 7 Apr 2020 11:35:46 +0900
From:   Levi <ppbuk5246@gmail.com>
To:     viro@zeniv.linux.org.uk, davem@davemloft.net, kuba@kernel.org,
        gnault@redhat.com, nicolas.dichtel@6wind.com, edumazet@google.com,
        lirongqing@baidu.com, tglx@linutronix.de, johannes.berg@intel.com,
        dhowells@redhat.com, daniel@iogearbox.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] netns: dangling pointer on netns bind mount point.
Message-ID: <20200407023512.GA25005@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we try to bind mount on network namespace (ex) /proc/{pid}/ns/net,
inode's private data can have dangling pointer to net_namespace that was
already freed in below case.

    1. Forking the process.
    2. [PARENT] Waiting the Child till the end.
    3. [CHILD] call unshare for creating new network namespace
    4. [CHILD] Bind mount with /proc/self/ns/net to some mount point.
    5. [CHILD] Exit child.
    6. [PARENT] Try to setns with binded mount point

In step 5, net_namespace made by child process'll be freed,
But in bind mount point, it still held the pointer to net_namespace made
by child process.
In this situation, when parent try to call "setns" systemcall with the
bind mount point, parent process try to access to freed memory, That
makes memory corruption.

This patch fix the above scenario by increaseing reference count.

Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
---
 fs/namespace.c              | 31 +++++++++++++++++++++++++++++++
 include/net/net_namespace.h |  7 +++++++
 net/core/net_namespace.c    |  5 -----
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index a28e4db075ed..ed0fbb6a1b52 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -31,6 +31,10 @@
 #include <linux/fs_context.h>
 #include <linux/shmem_fs.h>

+#ifdef CONFIG_NET_NS
+#include <net/net_namespace.h>
+#endif
+
 #include "pnode.h"
 #include "internal.h"

@@ -1013,12 +1017,25 @@ vfs_submount(const struct dentry *mountpoint, struct file_system_type *type,
 }
 EXPORT_SYMBOL_GPL(vfs_submount);

+#ifdef CONFIG_NET_NS
+static bool is_net_ns_file(struct dentry *dentry)
+{
+	/* Is this a proxy for a network namespace? */
+	return dentry->d_op == &ns_dentry_operations &&
+		dentry->d_fsdata == &netns_operations;
+}
+#endif
+
 static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 					int flag)
 {
 	struct super_block *sb = old->mnt.mnt_sb;
 	struct mount *mnt;
 	int err;
+#ifdef CONFIG_NET_NS
+	struct ns_common *ns = NULL;
+	struct net *net = NULL;
+#endif

 	mnt = alloc_vfsmnt(old->mnt_devname);
 	if (!mnt)
@@ -1035,6 +1052,20 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 			goto out_free;
 	}

+#ifdef CONFIG_NET_NS
+	if (!(flag & CL_COPY_MNT_NS_FILE) && is_net_ns_file(root)) {
+		ns = get_proc_ns(d_inode(root));
+		if (ns == NULL || ns->ops->type != CLONE_NEWNET) {
+			err = -EINVAL;
+
+			goto out_free;
+		}
+
+		net = to_net_ns(ns);
+		net = get_net(net);
+	}
+#endif
+
 	mnt->mnt.mnt_flags = old->mnt.mnt_flags;
 	mnt->mnt.mnt_flags &= ~(MNT_WRITE_HOLD|MNT_MARKED|MNT_INTERNAL);

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index ab96fb59131c..275258d1dbee 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -474,4 +474,11 @@ static inline void fnhe_genid_bump(struct net *net)
 	atomic_inc(&net->fnhe_genid);
 }

+#ifdef CONFIG_NET_NS
+static inline struct net *to_net_ns(struct ns_common *ns)
+{
+	return container_of(ns, struct net, ns);
+}
+#endif
+
 #endif /* __NET_NET_NAMESPACE_H */
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 190ca66a383b..3a6d9155806f 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -1343,11 +1343,6 @@ static struct ns_common *netns_get(struct task_struct *task)
 	return net ? &net->ns : NULL;
 }

-static inline struct net *to_net_ns(struct ns_common *ns)
-{
-	return container_of(ns, struct net, ns);
-}
-
 static void netns_put(struct ns_common *ns)
 {
 	put_net(to_net_ns(ns));
--
2.26.0
