Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923333BAE89
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhGDTF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhGDTFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 15:05:48 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1108FC061574;
        Sun,  4 Jul 2021 12:03:13 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so16051414oti.2;
        Sun, 04 Jul 2021 12:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YB4pREa650U7bhhcAeuwPw+Lb9YN7orZLUUMC3iUzAE=;
        b=sI2pSY6P7pbIyw/wo0EgbxpLXq5xLCudwFpcAVDjwGvgWIGfDc+uHIjxKlJ49gESwC
         iBhIFESizDK5y1cJKYLAu/knaSu+Xrz3p9sCA27tkzDvB+FlMSLHD/pW153GvYtgjx8k
         S6nm0HW1kkdbDe54LDC9PGwAYSjZVVA7qBfuPeM6428v3jnIes3RNMNXC1cICN2MoVkD
         IHK/46TS/8LDCoZogjjHQz/5/gI1qumbacAzMbH4CeodkfqvPB3TVzT0623N1Mdzo1Hx
         pOl85ArU1DjGRcXAJ9xUX8m/TVLFFy3TRJQkldULc64obz5V8XoPNM6QkukJa3xTOcNO
         ovHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YB4pREa650U7bhhcAeuwPw+Lb9YN7orZLUUMC3iUzAE=;
        b=SgrFiiqvCnIO1zAviYxmuglsScmxojZTWjaw15mDv13AFFS3WALU0vjihi/0cQitG+
         8Oeaah4hRa9abECm+FNP4+MqKuiULKbGm4NeiXshSmXgJ/thsphJA9YAju1wRQweyZ7N
         rHiLTNYkGNL2ouwxFuhP49OUSKp1mttW9io6UUZQGyomiloI6FG0lQ9gDdeZJ/BbZqzn
         naGzmpGEXwDXs+bDLz99Mj/n1cxhQIIeXhC3gN1Nv7E2zeglLxLFLufabHhg/JVFrt30
         HLYB0kIj3hlbVi410cG5LtO79c7JZeCLYRLs1IPGpurH4+sXQOhB3t2UDqR2lcDym8vZ
         PPgg==
X-Gm-Message-State: AOAM531WGlcmhC0W501RI6b9oOJA5rrqQSXKaZw2Gkbeo3W5F8iA+ETo
        mRAJy2A6bUJK4J1SDr8jKbPBxKjT6Jc=
X-Google-Smtp-Source: ABdhPJy9RmzPTFFhzIvI3wva0STzTZyC1sFDf6s53JeweOMuX2m2vjq8uP+jVODZKpkdPdxbikHQjw==
X-Received: by 2002:a05:6830:452:: with SMTP id d18mr7166152otc.258.1625425392368;
        Sun, 04 Jul 2021 12:03:12 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id 186sm1865848ooe.28.2021.07.04.12.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 12:03:12 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v5 06/11] af_unix: implement ->psock_update_sk_prot()
Date:   Sun,  4 Jul 2021 12:02:47 -0700
Message-Id: <20210704190252.11866-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Now we can implement unix_bpf_update_proto() to update
sk_prot, especially prot->close().

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 MAINTAINERS           |  1 +
 include/net/af_unix.h | 10 +++++++++
 net/core/sock_map.c   |  1 +
 net/unix/Makefile     |  1 +
 net/unix/af_unix.c    |  6 +++++-
 net/unix/unix_bpf.c   | 47 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 65 insertions(+), 1 deletion(-)
 create mode 100644 net/unix/unix_bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 88449b7a4c95..2c793df1d873 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10277,6 +10277,7 @@ F:	net/core/skmsg.c
 F:	net/core/sock_map.c
 F:	net/ipv4/tcp_bpf.c
 F:	net/ipv4/udp_bpf.c
+F:	net/unix/unix_bpf.c
 
 LANDLOCK SECURITY MODULE
 M:	Mickaël Salaün <mic@digikod.net>
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
index 3c427e7e6df9..ae5fa4338d9c 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1517,6 +1517,7 @@ void sock_map_close(struct sock *sk, long timeout)
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
index 875eeaaddc07..573253c5b5c2 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -788,11 +788,14 @@ static void unix_close(struct sock *sk, long timeout)
 	 */
 }
 
-static struct proto unix_proto = {
+struct proto unix_proto = {
 	.name			= "UNIX",
 	.owner			= THIS_MODULE,
 	.obj_size		= sizeof(struct unix_sock),
 	.close			= unix_close,
+#ifdef CONFIG_BPF_SYSCALL
+	.psock_update_sk_prot	= unix_bpf_update_proto,
+#endif
 };
 
 static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
@@ -2973,6 +2976,7 @@ static int __init af_unix_init(void)
 
 	sock_register(&unix_family_ops);
 	register_pernet_subsys(&unix_net_ops);
+	unix_bpf_build_proto();
 out:
 	return rc;
 }
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
new file mode 100644
index 000000000000..b1582a659427
--- /dev/null
+++ b/net/unix/unix_bpf.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Cong Wang <cong.wang@bytedance.com> */
+
+#include <linux/skmsg.h>
+#include <linux/bpf.h>
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
2.27.0

