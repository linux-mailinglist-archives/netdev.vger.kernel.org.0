Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1607C3A441A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 16:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhFKOcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 10:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbhFKOcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 10:32:23 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52916C061574;
        Fri, 11 Jun 2021 07:30:12 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id h12so2924987plf.4;
        Fri, 11 Jun 2021 07:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aZwUj1oQjzfy8pMKa2YiJLF+wN290SZ2awmanFa5QtE=;
        b=BzmU0pMKUM/RdSek5uSsg6RDQocaOr9viY4FV2UGYd8hiQ8UB34vrV40M5NbkCusAA
         uWbS0l4b+ET1JtvtmtdA31D3aqHGJZTVPVoLCYGVIkdWKaTLJEIy3p+OzB/+pXQweLDY
         tt5oj5CA+9nShrS/X3Tj1BIxeJt6Wozchpe5Shh6MBWbh9G7e797u7mNRZ1YV8irNw1q
         Tn8jt9Wgl+Kv18ydEsSzYnJjdZGlWSq0Yz64y+uxd9/pKttU9e3XPDbQ9qyr6ba5khQ/
         k46YAunh1+MdtZunrF1njMd/XADaqfK3S7P7V3h0llG1WrM7uJZgCEz0b7B4kt9YKU/Z
         LoRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aZwUj1oQjzfy8pMKa2YiJLF+wN290SZ2awmanFa5QtE=;
        b=StoVDpc9ZrEsqplVEQLliM/FH8ucpUcPE9N0SH0QYwRb1Ri+p7C/Ok8H3AmX/cvcRd
         jpyMSvaDPFTHqJJHbp8nFOquUH70UsRpW8aQ5osepa1E2y0uhlfE8R6V5SUfg96x4Btm
         VkUb8/hTNNGdTuOts5trpoZaNySTNRhiAwGwvuLJvFqwfUzgesGUtvySE54b+N67ONCh
         farI84E5iuTlsJkQrSRP47zg8FNrid4FF4w4aKOkpQ319Zmr9TMpKEzUi3zp0lOpKQ3A
         FPtirLKHEDQUhnAx2pHFuDBqI1VeyFT8JtysOpt5uJNd8oTyk9NwVbAWyE/AZGZlB7gF
         8Dbw==
X-Gm-Message-State: AOAM533ka32CxtLBuz2ltM9Au2NZ2DWcuigtxrWILiabzIdkWMl2bh7C
        NtmeSzsTfYhmaV1DefVfhY4=
X-Google-Smtp-Source: ABdhPJxPYEHLuu3n0lBU1WHBYaKa9KGhqVhQ6Y5EPZH947r3xK6aNFGiPQMMK9JOh00+i7Cg+hc8Sg==
X-Received: by 2002:a17:902:d4c8:b029:102:715b:e3a5 with SMTP id o8-20020a170902d4c8b0290102715be3a5mr4147534plg.83.1623421811748;
        Fri, 11 Jun 2021 07:30:11 -0700 (PDT)
Received: from WRT-WX9.. ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id z14sm5442218pfn.11.2021.06.11.07.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 07:30:11 -0700 (PDT)
From:   Changbin Du <changbin.du@gmail.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jakub Kici nski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v4] net: make get_net_ns return error if NET_NS is disabled
Date:   Fri, 11 Jun 2021 22:29:59 +0800
Message-Id: <20210611142959.92358-1-changbin.du@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a panic in socket ioctl cmd SIOCGSKNS when NET_NS is not enabled.
The reason is that nsfs tries to access ns->ops but the proc_ns_operations
is not implemented in this case.

[7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
[7.670268] pgd = 32b54000
[7.670544] [00000010] *pgd=00000000
[7.671861] Internal error: Oops: 5 [#1] SMP ARM
[7.672315] Modules linked in:
[7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
[7.673309] Hardware name: Generic DT based system
[7.673642] PC is at nsfs_evict+0x24/0x30
[7.674486] LR is at clear_inode+0x20/0x9c

The same to tun SIOCGSKNS command.

To fix this problem, we make get_net_ns() return -EINVAL when NET_NS is
disabled. Meanwhile move it to right place net/core/net_namespace.c.

Signed-off-by: Changbin Du <changbin.du@gmail.com>
Fixes: c62cce2caee5 ("net: add an ioctl to get a socket network namespace")
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>

---
v4: rebase to net tree.
---
 include/linux/socket.h      |  2 --
 include/net/net_namespace.h |  7 +++++++
 net/core/net_namespace.c    | 12 ++++++++++++
 net/socket.c                | 13 -------------
 4 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index b8fc5c53ba6f..0d8e3dcb7f88 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -438,6 +438,4 @@ extern int __sys_socketpair(int family, int type, int protocol,
 			    int __user *usockvec);
 extern int __sys_shutdown_sock(struct socket *sock, int how);
 extern int __sys_shutdown(int fd, int how);
-
-extern struct ns_common *get_net_ns(struct ns_common *ns);
 #endif /* _LINUX_SOCKET_H */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index fa5887143f0d..6412d7833d97 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -184,6 +184,8 @@ struct net *copy_net_ns(unsigned long flags, struct user_namespace *user_ns,
 void net_ns_get_ownership(const struct net *net, kuid_t *uid, kgid_t *gid);
 
 void net_ns_barrier(void);
+
+struct ns_common *get_net_ns(struct ns_common *ns);
 #else /* CONFIG_NET_NS */
 #include <linux/sched.h>
 #include <linux/nsproxy.h>
@@ -203,6 +205,11 @@ static inline void net_ns_get_ownership(const struct net *net,
 }
 
 static inline void net_ns_barrier(void) {}
+
+static inline struct ns_common *get_net_ns(struct ns_common *ns)
+{
+	return ERR_PTR(-EINVAL);
+}
 #endif /* CONFIG_NET_NS */
 
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 43b6ac4c4439..cc8dafb25d61 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -641,6 +641,18 @@ void __put_net(struct net *net)
 }
 EXPORT_SYMBOL_GPL(__put_net);
 
+/**
+ * get_net_ns - increment the refcount of the network namespace
+ * @ns: common namespace (net)
+ *
+ * Returns the net's common namespace.
+ */
+struct ns_common *get_net_ns(struct ns_common *ns)
+{
+	return &get_net(container_of(ns, struct net, ns))->ns;
+}
+EXPORT_SYMBOL_GPL(get_net_ns);
+
 struct net *get_net_ns_by_fd(int fd)
 {
 	struct file *file;
diff --git a/net/socket.c b/net/socket.c
index 27e3e7d53f8e..4f2c6d2795d0 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1072,19 +1072,6 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
  *	what to do with it - that's up to the protocol still.
  */
 
-/**
- *	get_net_ns - increment the refcount of the network namespace
- *	@ns: common namespace (net)
- *
- *	Returns the net's common namespace.
- */
-
-struct ns_common *get_net_ns(struct ns_common *ns)
-{
-	return &get_net(container_of(ns, struct net, ns))->ns;
-}
-EXPORT_SYMBOL_GPL(get_net_ns);
-
 static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
 	struct socket *sock;
-- 
2.30.2

