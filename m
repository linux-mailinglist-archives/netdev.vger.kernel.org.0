Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B3736494D
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240341AbhDSR5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240259AbhDSR5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 13:57:11 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4BBC06138A;
        Mon, 19 Apr 2021 10:56:41 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t22so24829476pgu.0;
        Mon, 19 Apr 2021 10:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nl87MwqpfRvd50+82J1Wpx63mRm0ruM72/35snEyNsY=;
        b=bBabVM2F2YuiLi0ib2vrjCHbKCKQH94mkBDN42j4GI20KRHqbK0v4fzwxQwye7EAPj
         b0GYA+vyiBuyW5W7GmzjE35UljCRoNW4qKtlTkfPMuXoFR/jKLS43ST3F6SQ/zRmKaWt
         IY3/9Cf2/HDp3tqRROHhOeiiDlCAK6fxGTL+zPyNZAzCMKjQtZxRRoNSQp7uujTZyw/r
         pgXPjUqbF3THBf262Ogn/+A34SfZc8LqzsXWfiLBZ/Pm2Dn42H5N+vmGx87oXK9G7Evx
         u0y669Pt7ZA57ASf6rVQ9FHYw2EsfweZz45/13u81WqxA+P2APgpV4qKxWUvT7sYo5tD
         A+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nl87MwqpfRvd50+82J1Wpx63mRm0ruM72/35snEyNsY=;
        b=REgauBEHUQJRk8+sgv51xRitdSeH6cnGQrOX9amgi78ulcAmMh719IFqMbtY6/MSj/
         4ZDb5Q7QVKd7maM+Jsf9v1nF06W+AUqKyOpg5pZAn6DJtc6Dzkj0Z01yVW8JIycN4yjG
         waQ2vmkRh57JwFKZIQQsXVeduTYFwwzUZskJxDKHt5M0JfpQzLE0nUjF7YUl+RwPKMdg
         nT+Idm/JnjflqKztjBgoqG42r9ItYaFmtVfINZ3DvGtWMZ8rG7XtlYU4kSoEvjoTQAJp
         eG3Xm0mAucsGFEDQfRzyJ/EXWrGs21JLt3eo9B9ptzDBTWSxTNxWOfDlXOEZ157h4fgm
         TAjQ==
X-Gm-Message-State: AOAM530IeID7yQs+44wVjaP/9n6HG/EEZp63gPO+3OXfh7wWskaF7rEu
        TcTfuP0p+idC1t7o1HaxpjaU0CZzIk51KQ==
X-Google-Smtp-Source: ABdhPJzRhno4l2BJ9KxYdg8JuWd5Id9MjniuGjQAFCoYiWG8NPJ/WLbNhP9z3B1yFDbrUlw6CrdvLw==
X-Received: by 2002:aa7:8103:0:b029:247:74a8:e54d with SMTP id b3-20020aa781030000b029024774a8e54dmr20806305pfi.60.1618855001116;
        Mon, 19 Apr 2021 10:56:41 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9c9:f92c:88fa:755e])
        by smtp.gmail.com with ESMTPSA id g2sm119660pju.18.2021.04.19.10.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 10:56:40 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 2/9] af_unix: implement ->psock_update_sk_prot()
Date:   Mon, 19 Apr 2021 10:55:56 -0700
Message-Id: <20210419175603.19378-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210419175603.19378-1-xiyou.wangcong@gmail.com>
References: <20210419175603.19378-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

unix_proto is special, it is very different from INET proto,
which even does not have a ->close(). We have to add a dummy
one to satisfy sockmap.

And now we can implement unix_bpf_update_proto() to update
sk_prot.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 MAINTAINERS           |  1 +
 include/net/af_unix.h | 10 ++++++++++
 net/core/sock_map.c   |  1 +
 net/unix/Makefile     |  1 +
 net/unix/af_unix.c    | 12 ++++++++++-
 net/unix/unix_bpf.c   | 46 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 70 insertions(+), 1 deletion(-)
 create mode 100644 net/unix/unix_bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 217c7470bfa9..02532e11da5b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10000,6 +10000,7 @@ F:	net/core/skmsg.c
 F:	net/core/sock_map.c
 F:	net/ipv4/tcp_bpf.c
 F:	net/ipv4/udp_bpf.c
+F:	net/unix/unix_bpf.c
 
 LANTIQ / INTEL Ethernet drivers
 M:	Hauke Mehrtens <hauke@hauke-m.de>
diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index f42fdddecd41..cca645846af1 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -89,4 +89,14 @@ void unix_sysctl_unregister(struct net *net);
 static inline int unix_sysctl_register(struct net *net) { return 0; }
 static inline void unix_sysctl_unregister(struct net *net) {}
 #endif
+
+#ifdef CONFIG_BPF_SYSCALL
+extern struct proto unix_proto;
+
+int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
+void __init unix_bpf_build_proto(void);
+#else
+static inline void __init unix_bpf_build_proto(void)
+{}
+#endif
 #endif
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 6f1b82b8ad49..1107c9dcc969 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1536,6 +1536,7 @@ void sock_map_close(struct sock *sk, long timeout)
 	release_sock(sk);
 	saved_close(sk, timeout);
 }
+EXPORT_SYMBOL_GPL(sock_map_close);
 
 static int sock_map_iter_attach_target(struct bpf_prog *prog,
 				       union bpf_iter_link_info *linfo,
diff --git a/net/unix/Makefile b/net/unix/Makefile
index 54e58cc4f945..20491825b4d0 100644
--- a/net/unix/Makefile
+++ b/net/unix/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_UNIX)	+= unix.o
 
 unix-y			:= af_unix.o garbage.o
 unix-$(CONFIG_SYSCTL)	+= sysctl_net_unix.o
+unix-$(CONFIG_BPF_SYSCALL) += unix_bpf.o
 
 obj-$(CONFIG_UNIX_DIAG)	+= unix_diag.o
 unix_diag-y		:= diag.o
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 966359b64a56..97dfb747e052 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -771,10 +771,18 @@ static const struct proto_ops unix_seqpacket_ops = {
 	.show_fdinfo =	unix_show_fdinfo,
 };
 
-static struct proto unix_proto = {
+static void unix_close(struct sock *sk, long timeout)
+{
+}
+
+struct proto unix_proto = {
 	.name			= "UNIX",
 	.owner			= THIS_MODULE,
 	.obj_size		= sizeof(struct unix_sock),
+	.close			= unix_close,
+#ifdef CONFIG_BPF_SYSCALL
+	.psock_update_sk_prot	= unix_bpf_update_proto,
+#endif
 };
 
 static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
@@ -859,6 +867,7 @@ static int unix_release(struct socket *sock)
 		return 0;
 
 	unix_release_sock(sk, 0);
+	sk->sk_prot->close(sk, 0);
 	sock->sk = NULL;
 
 	return 0;
@@ -2957,6 +2966,7 @@ static int __init af_unix_init(void)
 
 	sock_register(&unix_family_ops);
 	register_pernet_subsys(&unix_net_ops);
+	unix_bpf_build_proto();
 out:
 	return rc;
 }
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
new file mode 100644
index 000000000000..8ce7651893f3
--- /dev/null
+++ b/net/unix/unix_bpf.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Cong Wang <cong.wang@bytedance.com> */
+
+#include <linux/skmsg.h>
+#include <net/sock.h>
+#include <net/af_unix.h>
+
+static struct proto *unix_prot_saved __read_mostly;
+static DEFINE_SPINLOCK(unix_prot_lock);
+static struct proto unix_bpf_prot;
+
+static void unix_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
+{
+	*prot        = *base;
+	prot->close  = sock_map_close;
+}
+
+static void unix_bpf_check_needs_rebuild(struct proto *ops)
+{
+	if (unlikely(ops != smp_load_acquire(&unix_prot_saved))) {
+		spin_lock_bh(&unix_prot_lock);
+		if (likely(ops != unix_prot_saved)) {
+			unix_bpf_rebuild_protos(&unix_bpf_prot, ops);
+			smp_store_release(&unix_prot_saved, ops);
+		}
+		spin_unlock_bh(&unix_prot_lock);
+	}
+}
+
+int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
+{
+	if (restore) {
+		sk->sk_write_space = psock->saved_write_space;
+		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+		return 0;
+	}
+
+	unix_bpf_check_needs_rebuild(psock->sk_proto);
+	WRITE_ONCE(sk->sk_prot, &unix_bpf_prot);
+	return 0;
+}
+
+void __init unix_bpf_build_proto(void)
+{
+	unix_bpf_rebuild_protos(&unix_bpf_prot, &unix_proto);
+}
-- 
2.25.1

