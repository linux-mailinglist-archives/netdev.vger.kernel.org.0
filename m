Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F0F377445
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhEHWKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbhEHWKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:10:18 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7586C061574;
        Sat,  8 May 2021 15:09:15 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id h21so5544927qtu.5;
        Sat, 08 May 2021 15:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wlJs7uKgRrKVYquQOhfr1Ax5B30l7MZiTJBcTYOyR4M=;
        b=B0fJ50FjuwLYki5kIDudC8ABjvkFGRzwsQWQFOV7LwSJGCzedbwyWxpl4dgJeZ059e
         0+Lm3WDTbD4V0igkjoxnW+hajxmdkGQYuAtkTMZje1yic+fbhOI5em7OGWfH/Z7CF+ze
         Yf2GEZ6hpw4IfHEA4b+tV0C4uRLCgoMGEXe4H4YtfG6Q4gu9QR4mu4DnUXf0YzWDwmza
         aM5aVK0deZtXaSbgtxAFFMFQ5s59SHUgb02C1HyZmZzQY6eGxEysld8Iyqtsv5U8Sy6D
         y2gYch4m1ys3zsqrR00gvkqwuRmThryKhFgwiHTCkMCGgljxIAshReOP1yQ0DXo13wwT
         +Uew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wlJs7uKgRrKVYquQOhfr1Ax5B30l7MZiTJBcTYOyR4M=;
        b=VsYERw/lntmO7Kc18wEf5evLqFuHUYAjUApqs8jPcaRC+TI4NGcdKuZxRXqSqaqxGq
         MkDckOGy1D0D3WvIYTMuKvxqVhQX3zfkyY6pvPz12mbj1UXI08RveKFahMnBOdOhp8yr
         3HIOzoYmpq9LVj1LOglBNzgkM8gTgFuPHDxxuXyjzwghTEw12DykCdJvPoV3/pE1bpoy
         o8AGhVVzqBHtV9JCnPLZrcnBslaGvf9qOppm+L5kJE3sEdlhcuvKudQqj34TGWFSvaa1
         uegvcmbSIKoBtRnXwpgQaVNBxV3XIJRTeNTJGazZ1JsFfZf2iw4mLcE7s8d2uQ+rodfv
         1dtw==
X-Gm-Message-State: AOAM5324YJ5Le+WDUBLqCqGehI5Za369hk4Z0hTWzjrvRYbw7A9R5SXE
        WOJ6Y7TQKxj2vmDsLPVku9UGtkBSGPInuA==
X-Google-Smtp-Source: ABdhPJzkkgTr3JfLkKLsORtgZDJa23gENArDIBy0nI3v+10tjkKLBTKtbivHTEaBEHT7E6TtHTen/w==
X-Received: by 2002:ac8:502:: with SMTP id u2mr15313897qtg.218.1620511754964;
        Sat, 08 May 2021 15:09:14 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id 189sm8080797qkd.51.2021.05.08.15.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:09:14 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 06/12] af_unix: implement ->psock_update_sk_prot()
Date:   Sat,  8 May 2021 15:08:29 -0700
Message-Id: <20210508220835.53801-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
References: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Now we can implement unix_bpf_update_proto() to update
sk_prot, particularly prot->close() and prot->unhash().

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 MAINTAINERS           |  1 +
 include/net/af_unix.h | 10 +++++++++
 net/unix/Makefile     |  1 +
 net/unix/af_unix.c    |  6 +++++-
 net/unix/unix_bpf.c   | 48 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 65 insertions(+), 1 deletion(-)
 create mode 100644 net/unix/unix_bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4796ccf9f871..f9354cb422b1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10162,6 +10162,7 @@ F:	net/core/skmsg.c
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
index 0f9a6dcca752..5424e8007858 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -786,12 +786,15 @@ static void unix_close(struct sock *sk, long timeout)
 {
 }
 
-static struct proto unix_proto = {
+struct proto unix_proto = {
 	.name			= "UNIX",
 	.owner			= THIS_MODULE,
 	.obj_size		= sizeof(struct unix_sock),
 	.unhash			= unix_unhash,
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
index 000000000000..3ff71fb9aac8
--- /dev/null
+++ b/net/unix/unix_bpf.c
@@ -0,0 +1,48 @@
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
+	prot->unhash = sock_map_unhash;
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

