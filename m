Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77DF30D289
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhBCEUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbhBCES1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:18:27 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7FBC0617A7;
        Tue,  2 Feb 2021 20:17:12 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id a77so25393520oii.4;
        Tue, 02 Feb 2021 20:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I8srG1L59T5lSA/sx67czDaMe/6mWiAIpF1LBobm/C8=;
        b=QUKYtXCfh0UBl/bdGnwunxOtACNvBs9dBnbmcTrJ7hHwRtG1ouO8NLCkYwNFQFZEbV
         f+dA61CT7JCiZ5+vin/uJGUccemujooRl2V4mA+RlpFTD79STZUetOqg7JfEO1chhVtf
         fpgIdQ2061t+NKr9r4ULHJDlWuFajw8OHMsoBhmXdB4Km7miTfaQ+A6lv8pXZow+dO96
         Iy+BrDTXkOasf6fLNqvFBAdxAUqKj8AMiWrkTi0GWHoHATGApXWWrEY9dU1f557FFh34
         mBv4uLZDx2MFjexS4w3vj2VyVkJ7sOz9GM3QuIXPyxKgj9Eu8jphlUBtU70ZOOgMZtkt
         KNVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I8srG1L59T5lSA/sx67czDaMe/6mWiAIpF1LBobm/C8=;
        b=hvLCRIALYAolPRld7L7Mw41a34fb2+pL3AGeqW3jW5H7eEoyYpG7qfCI5JQnAXu0pb
         /XQiUr2a3Vff6oHfNG55+6LIEa5TdFuloyNwtMFCBwRjkvnkCys2/UpKfs7uORGR7HAX
         cd7XUCcQ/GWX4N1mPCH4q6tUM+f2C8IqFnZSV8MUrVD/uoQKE+de41gfi6s8bEdvm3/U
         sQt7KCAhRTHOxS5NEZFSuYBrS2BnwwXMUito0Aijcf6u9+BLQx3MvTXuq0jcF/+HKMm4
         M4LYH7zlD6o1w6M736P4U1DPjlS564P78CZ0b8MzdBW5irESXD+MaIJVCRS63PhvB1NC
         afAw==
X-Gm-Message-State: AOAM530chb8QVZeuR23YREAe44yfxC1RyuaBWRtw77io0JamxW6IP14W
        6FOGPu4yHyzj3g6aRbDRiBf094I+nKYabg==
X-Google-Smtp-Source: ABdhPJzoP42CF4cWCYXDjP5S2b6u//MVgpOumSRK4FCz9fDlVcwcEbpF3oUWOBe/5hgwt29qVBW7+Q==
X-Received: by 2002:aca:b683:: with SMTP id g125mr789725oif.47.1612325831586;
        Tue, 02 Feb 2021 20:17:11 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:17:10 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 12/19] af_unix: implement ->update_proto()
Date:   Tue,  2 Feb 2021 20:16:29 -0800
Message-Id: <20210203041636.38555-13-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

unix_proto is special, it is very different from INET proto,
which even does not have a ->close(). We have to add a dummy
one to satisfy sockmap.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 MAINTAINERS           |  1 +
 include/net/af_unix.h | 10 +++++++++
 net/unix/Makefile     |  1 +
 net/unix/af_unix.c    | 12 ++++++++++-
 net/unix/unix_bpf.c   | 50 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 1 deletion(-)
 create mode 100644 net/unix/unix_bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 1df56a32d2df..1fa3971c45b0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9950,6 +9950,7 @@ F:	net/core/skmsg.c
 F:	net/core/sock_map.c
 F:	net/ipv4/tcp_bpf.c
 F:	net/ipv4/udp_bpf.c
+F:	net/unix/unix_bpf.c
 
 LANTIQ / INTEL Ethernet drivers
 M:	Hauke Mehrtens <hauke@hauke-m.de>
diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index f42fdddecd41..fa75f899e88a 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -89,4 +89,14 @@ void unix_sysctl_unregister(struct net *net);
 static inline int unix_sysctl_register(struct net *net) { return 0; }
 static inline void unix_sysctl_unregister(struct net *net) {}
 #endif
+
+extern struct proto unix_proto;
+
+#ifdef CONFIG_BPF_SOCK_MAP
+int unix_bpf_update_proto(struct sock *sk, bool restore);
+void __init unix_bpf_build_proto(void);
+#else
+static inline void __init unix_bpf_build_proto(void)
+{}
+#endif
 #endif
diff --git a/net/unix/Makefile b/net/unix/Makefile
index 54e58cc4f945..7d2c70c575b6 100644
--- a/net/unix/Makefile
+++ b/net/unix/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_UNIX)	+= unix.o
 
 unix-y			:= af_unix.o garbage.o
 unix-$(CONFIG_SYSCTL)	+= sysctl_net_unix.o
+unix-$(CONFIG_BPF_SOCK_MAP) += unix_bpf.o
 
 obj-$(CONFIG_UNIX_DIAG)	+= unix_diag.o
 unix_diag-y		:= diag.o
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 9315c4f4c27a..4ce12d3c369e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -773,10 +773,18 @@ static const struct proto_ops unix_seqpacket_ops = {
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
+#ifdef CONFIG_BPF_SOCK_MAP
+	.update_proto		= unix_bpf_update_proto,
+#endif
 };
 
 static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
@@ -861,6 +869,7 @@ static int unix_release(struct socket *sock)
 		return 0;
 
 	unix_release_sock(sk, 0);
+	sk->sk_prot->close(sk, 0);
 	sock->sk = NULL;
 
 	return 0;
@@ -2973,6 +2982,7 @@ static int __init af_unix_init(void)
 
 	sock_register(&unix_family_ops);
 	register_pernet_subsys(&unix_net_ops);
+	unix_bpf_build_proto();
 out:
 	return rc;
 }
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
new file mode 100644
index 000000000000..2e6a26ec4958
--- /dev/null
+++ b/net/unix/unix_bpf.c
@@ -0,0 +1,50 @@
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
+int unix_bpf_update_proto(struct sock *sk, bool restore)
+{
+	struct sk_psock *psock = sk_psock(sk);
+
+	if (restore) {
+		sk->sk_write_space = psock->saved_write_space;
+		/* Pairs with lockless read in sk_clone_lock() */
+		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+		return 0;
+	}
+
+	unix_bpf_check_needs_rebuild(psock->sk_proto);
+	/* Pairs with lockless read in sk_clone_lock() */
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

