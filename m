Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8735314A435
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 13:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgA0Mzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 07:55:45 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38401 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgA0Mzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 07:55:44 -0500
Received: by mail-lj1-f193.google.com with SMTP id w1so10572389ljh.5
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 04:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2faYqygbR37aPPmSyvnvEVhP/Ol5xmiYUyhpksjiNI=;
        b=T5fh4fswVKsSYtR/SdqSjTKfGAdgijSs4QESgsdVDcqZD9SXRrWkRXH9FeAY1/5LiK
         MVP2O3XcI1gBOjcdZ+MQX38kqocp4urnWUzjAA4iFY9ZH0Pnx6ixwGoWVgF5LH2a6Cju
         U4jDN1qTCj2Q/nlIPJpM8aSAGyarKvAhsHBqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2faYqygbR37aPPmSyvnvEVhP/Ol5xmiYUyhpksjiNI=;
        b=k9dFvS20E6qS3MVy/h2TTUIw+68RByFDphXTolbvJBCMrq4MH5+/slZvPhqA6kN4h7
         Yi7m23Sj6h7WJgd3abQNUbQFS+XuXVCTPbVscmC26QAQwgKpfPruJkkMAYjajul4/ttK
         JO9tV4QlCVemzW6m9+SOuVNpPv1L1koS44zH7NCQTocWfu6fMQ8EJNoEn/wv+I6al5uU
         NP4foeeM9GbitURfNYfSRAHRP5KpzP05uIHFUo2Aw5uyapuN+QnyvCG9/7RZgJhCipVo
         kOrOLLsFIlhV4ZlJjRGhvOpVDd1lUM+DTavIlQ2JhfRbNeUZ4dwODdesKMIjj9kHPWDN
         4DJg==
X-Gm-Message-State: APjAAAWmIlvCyw2JADhPoSTNdVc2Gp64m/zSMeC6E87pAVwCpwKNpTKv
        QZZxAZeELvSZf4MP6+Wu7EiEnQ==
X-Google-Smtp-Source: APXvYqwNJFCL7tSOkdgq9g11X9dhC6xBOeQWUOMHwrRAk9anoQ2LMoqYo5Ga7PYF8NapLbnbfHvFrA==
X-Received: by 2002:a05:651c:86:: with SMTP id 6mr7720572ljq.193.1580129742693;
        Mon, 27 Jan 2020 04:55:42 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id o6sm8023520lfg.11.2020.01.27.04.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 04:55:42 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v5 04/12] tcp_bpf: Don't let child socket inherit parent protocol ops on copy
Date:   Mon, 27 Jan 2020 13:55:26 +0100
Message-Id: <20200127125534.137492-5-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127125534.137492-1-jakub@cloudflare.com>
References: <20200127125534.137492-1-jakub@cloudflare.com>
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

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/tcp.h        |  7 +++++++
 net/ipv4/tcp_bpf.c       | 13 +++++++++++++
 net/ipv4/tcp_minisocks.c |  2 ++
 3 files changed, 22 insertions(+)

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
index dd183b050642..c0439c015341 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -579,6 +579,19 @@ static void tcp_bpf_close(struct sock *sk, long timeout)
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

