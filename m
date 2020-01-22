Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2771454BC
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgAVNGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:06:01 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:46700 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729093AbgAVNF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 08:05:59 -0500
Received: by mail-lj1-f174.google.com with SMTP id m26so6658589ljc.13
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 05:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1JjdJREQ2zttEU0s3bIX4pMOwpQo6iyj2JULQnJxcMk=;
        b=kC42uhHaySkK4xzi0ojC5CIT0K72E+g9zZxJ1P1yDEvOQ5yq5utvABTSW0P8lggXxc
         ZoyqN4+okFH/fWTU7+umN4PEEhcVQesw84OQtTYDZFT6tFLsQEjpfiW1Cchc+lXQ3zEL
         ZuVhMW4sQoMfn+l7IdGuFHxxmkS/nnKHbjlRw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1JjdJREQ2zttEU0s3bIX4pMOwpQo6iyj2JULQnJxcMk=;
        b=UFYI077HhLJ7oFvr+OL3h2r92EzsDRZui4LFLrRMeFwSteKFyasH3T+XqxeMzFXq/a
         n6eNh7Ml7ZwnK7Q9x9taAWJQ4wP7wwAn2Fg+9KEVzqPySfQJvVyfu00J9k+wxi+0HYOF
         Hcly3BwbPtaMxQxj5qZ5vMbhhnM8ogBKLmP/HSooQtdnVU5kh8TwKuIT5U3NF9bdy2BI
         AYmOV5Cl/IVhg3/+pd2L9Mk5Nm5yfktOA/IfIYhZTJVVP/T5nNj0i5FvfY5oXVmHw2pk
         HRBfdPXu2yGkYxotW9DT1ELW5uUHDl7vm4Tk2l2wXUmgNmLP9YlvDVHF65+ulre+Z6nB
         nE3g==
X-Gm-Message-State: APjAAAWBhJ1uxQnIcWgUXISugClQXWLjFZboLDJHhEHKxQTW6mcytBVZ
        Yi6v8T4LTenodeP2+mneJpcg+Q==
X-Google-Smtp-Source: APXvYqx9KQU+tz+UyVGHJ4cHw9kES1UYVSkM9qFHmPqeV1avljeo4OZ0TubCeky7Nd5kGhyNVwSd+g==
X-Received: by 2002:a05:651c:2046:: with SMTP id t6mr19733735ljo.180.1579698357276;
        Wed, 22 Jan 2020 05:05:57 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id i4sm23976820lji.0.2020.01.22.05.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 05:05:56 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v3 04/12] tcp_bpf: Don't let child socket inherit parent protocol ops on copy
Date:   Wed, 22 Jan 2020 14:05:41 +0100
Message-Id: <20200122130549.832236-5-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122130549.832236-1-jakub@cloudflare.com>
References: <20200122130549.832236-1-jakub@cloudflare.com>
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
 net/ipv4/tcp_bpf.c       | 13 +++++++++++++
 net/ipv4/tcp_minisocks.c |  2 ++
 3 files changed, 22 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9dd975be7fdf..ac205d31e4ad 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2181,6 +2181,13 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		    int nonblock, int flags, int *addr_len);
 int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 		      struct msghdr *msg, int len, int flags);
+#ifdef CONFIG_NET_SOCK_MSG
+void tcp_bpf_clone(const struct sock *sk, struct sock *child);
+#else
+static inline void tcp_bpf_clone(const struct sock *sk, struct sock *child)
+{
+}
+#endif
 
 /* Call BPF_SOCK_OPS program that returns an int. If the return value
  * is < 0, then the BPF op failed (for example if the loaded BPF
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 4f25aba44ead..16060e0893a1 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -582,6 +582,19 @@ static void tcp_bpf_close(struct sock *sk, long timeout)
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
+	if (prot->unhash == tcp_bpf_unhash)
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

