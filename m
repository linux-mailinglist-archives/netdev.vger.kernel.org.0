Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86AEC136B55
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgAJKui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:50:38 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:46595 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgAJKug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 05:50:36 -0500
Received: by mail-wr1-f47.google.com with SMTP id z7so1314889wrl.13
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 02:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nQJ3t6QcJMZGGzj/x1LBt1HN6BTIXhofhKfBZ07X8jg=;
        b=m3usTONH2lGKmBCz4S5ZFGHk1HYOxzU2sRajLN+ULuCJ4oJOmFMnW7gX31oiknpEPe
         wYm0i4t/vYmqO/4qY8e9FCuKUj01g39gnLMUmXxiLWqmwsUkq8kqMl/NcpeHorAp4hrF
         lEcCQIsdqxNDMTlUcfI8VxjtqQ6kACfG5KFgc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nQJ3t6QcJMZGGzj/x1LBt1HN6BTIXhofhKfBZ07X8jg=;
        b=TsTFIOKtqEDW6z9IGDZi9mMSqyYNYZgmM6vVMpq7zypRIGoFy8UZ6SxKD0MnsJsnDb
         5J2JMrW9xEncQYwh5/cDIBJiriisI8XgJ+kaSn3QeCGy61SbagvZiLUjWivgvZA2f6VO
         yfuy1iV8Q/AQQ9ohu+yBPb6EJJJnRAV5ELQJ3/B8VyxXc3lqXpiVe1dL7II/0nty44aW
         TJHFMQwxyg4NaBN3ymGGIwIfBMX86Kuw/4mvCpOKNRRbQOHDgd1HOOgKl/bInvlDN35l
         M+/JusH4AKVkjadLyg9nTMo48FV4zYiZod2u9MH2KlU8flNeVO3eg2rLdRZlRBewVqKD
         FfyQ==
X-Gm-Message-State: APjAAAWlJ/MaMianKnhjiI8mzzB6l9k+I48O+I/b+bQUt4GUdI9iGZMo
        9PCgmCmGF9aB15RcPKS/gE1xoQ==
X-Google-Smtp-Source: APXvYqxLwc0sv10OR6RvQ750Z6ESOK33W36TGw/kqe/I0qQ/Byxgu/zU+xnTQ0o+0Sw6uYIOrrGIGQ==
X-Received: by 2002:a5d:4c8c:: with SMTP id z12mr2804641wrs.222.1578653434895;
        Fri, 10 Jan 2020 02:50:34 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id h8sm1777985wrx.63.2020.01.10.02.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 02:50:34 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v2 04/11] tcp_bpf: Don't let child socket inherit parent protocol ops on copy
Date:   Fri, 10 Jan 2020 11:50:20 +0100
Message-Id: <20200110105027.257877-5-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110105027.257877-1-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for cloning listening sockets that have their protocol callbacks
overridden by sk_msg. Child sockets must not inherit parent callbacks that
access state stored in sk_user_data owned by the parent.

Restore the child socket protocol callbacks before the it gets hashed and
any of the callbacks can get invoked.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/tcp.h        |  1 +
 net/ipv4/tcp_bpf.c       | 13 +++++++++++++
 net/ipv4/tcp_minisocks.c |  2 ++
 3 files changed, 16 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9dd975be7fdf..7cbf9465bb10 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2181,6 +2181,7 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		    int nonblock, int flags, int *addr_len);
 int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 		      struct msghdr *msg, int len, int flags);
+void tcp_bpf_clone(const struct sock *sk, struct sock *child);
 
 /* Call BPF_SOCK_OPS program that returns an int. If the return value
  * is < 0, then the BPF op failed (for example if the loaded BPF
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index f6c83747c71e..6f96320fb7cf 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -586,6 +586,19 @@ static void tcp_bpf_close(struct sock *sk, long timeout)
 	saved_close(sk, timeout);
 }
 
+/* If a child got cloned from a listening socket that had tcp_bpf
+ * protocol callbacks installed, we need to restore the callbacks to
+ * the default ones because the child does not inherit the psock state
+ * that tcp_bpf callbacks expect.
+ */
+void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
+{
+	struct proto *prot = newsk->sk_prot;
+
+	if (prot->recvmsg == tcp_bpf_recvmsg)
+		newsk->sk_prot = sk->sk_prot_creator;
+}
+
 enum {
 	TCP_BPF_IPV4,
 	TCP_BPF_IPV6,
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

