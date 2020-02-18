Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D243162BA7
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgBRRKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:10:32 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35240 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgBRRKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:10:32 -0500
Received: by mail-wm1-f68.google.com with SMTP id b17so3790539wmb.0
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 09:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=27JEC+mS9JHJtR2IEk1OqN9kNl9Z/xXQwj4Ucc5DWTw=;
        b=VJtQtll83pYRuSvUB7rhv1vcpst6bYiEPZUWvn8XkyqXogpWJEufdMG/Y87qMNN0Ep
         GnBBE+vY2CZofnussLItYy0REEB+JyEWj1uedFA+zzGdU9daxg3diZ3RT4FlPAvX/4U0
         z4OgoZQZzj4MEa06hDarG04aCyXeF86SfHARE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=27JEC+mS9JHJtR2IEk1OqN9kNl9Z/xXQwj4Ucc5DWTw=;
        b=l1+Wqj0lkqK9nLiMyWkr019zj+8mt+b5I6JsiBMXVT1UBA7GTjTqOgnR2AdYViK6GQ
         J8hLsES4kfIG4eAZkM7z4/p7qdSnNgdQCGB4DOfoG14v3Mpd4GEPEmye1/HDWqsOEH67
         HJGyF3kQa8VyU0ER2fOInntjYQ9YULNGp8ExrLqXP0Q8zKEq/TNIRwpxHMaKDObJN/Sg
         I7038LgFbQI72naophod0FYywWqriL11aIIY7XP0pRNrB/oOIrpdBj8ZDaI1wTHzvVvE
         bSNi3zsJF7h0aX6QppIKkUqfhITW1qzdgshNQtyiKYUhcmdz2u4oh393tD+zRC15gxqt
         apVg==
X-Gm-Message-State: APjAAAXs7SOyjNhmCgmNK0iC/GFb8WfchYoot+55wMYJ/dvXuzKdDaB0
        8FeZHYNnCPH0DJdUSezl/ZGsFg==
X-Google-Smtp-Source: APXvYqyl5I/y7N6mnnXd1o1bS4Uq0V7y9267CRfeKoyPYi6fJ6/BR0YWRjO7FCS9IUAvt9gzV/os+A==
X-Received: by 2002:a7b:c119:: with SMTP id w25mr4281358wmi.116.1582045830559;
        Tue, 18 Feb 2020 09:10:30 -0800 (PST)
Received: from cloudflare.com ([88.157.168.82])
        by smtp.gmail.com with ESMTPSA id s22sm4096951wmh.4.2020.02.18.09.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:10:30 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v7 03/11] tcp_bpf: Don't let child socket inherit parent protocol ops on copy
Date:   Tue, 18 Feb 2020 17:10:15 +0000
Message-Id: <20200218171023.844439-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218171023.844439-1-jakub@cloudflare.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for cloning listening sockets that have their protocol callbacks
overridden by sk_msg. Child sockets must not inherit parent callbacks that
access state stored in sk_user_data owned by the parent.

Restore the child socket protocol callbacks before it gets hashed and any
of the callbacks can get invoked.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/tcp.h        |  7 +++++++
 net/ipv4/tcp_bpf.c       | 14 ++++++++++++++
 net/ipv4/tcp_minisocks.c |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index a5ea27df3c2b..07f947cc80e6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2203,6 +2203,13 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		    int nonblock, int flags, int *addr_len);
 int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 		      struct msghdr *msg, int len, int flags);
+#ifdef CONFIG_NET_SOCK_MSG
+void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
+#else
+static inline void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
+{
+}
+#endif
 
 /* Call BPF_SOCK_OPS program that returns an int. If the return value
  * is < 0, then the BPF op failed (for example if the loaded BPF
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index dd183b050642..7d6e1b75d4d4 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -693,3 +693,17 @@ int tcp_bpf_init(struct sock *sk)
 	rcu_read_unlock();
 	return 0;
 }
+
+/* If a child got cloned from a listening socket that had tcp_bpf
+ * protocol callbacks installed, we need to restore the callbacks to
+ * the default ones because the child does not inherit the psock state
+ * that tcp_bpf callbacks expect.
+ */
+void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
+{
+	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
+	struct proto *prot = newsk->sk_prot;
+
+	if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
+		newsk->sk_prot = sk->sk_prot_creator;
+}
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index ad3b56d9fa71..c8274371c3d0 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -548,6 +548,8 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	newtp->fastopen_req = NULL;
 	RCU_INIT_POINTER(newtp->fastopen_rsk, NULL);
 
+	tcp_bpf_clone(sk, newsk);
+
 	__TCP_INC_STATS(sock_net(sk), TCP_MIB_PASSIVEOPENS);
 
 	return newsk;
-- 
2.24.1

