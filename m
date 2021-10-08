Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21700427255
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 22:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242730AbhJHUfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 16:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242279AbhJHUfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 16:35:16 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C6DC061570;
        Fri,  8 Oct 2021 13:33:20 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id p4so10733966qki.3;
        Fri, 08 Oct 2021 13:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mjh66l7EjiKQtKP9c2a3KtPXE8PrCUDOCdt6/27IAc4=;
        b=LpPIRW7LFjwatmS0X/2Ogdhky7Za9m+BHxGsmYrGbuORhJcSv/ih3FsGb0UN1+2Grb
         OoQU/ExLUQGh+5w2tRSLYEu7j2Ohi4y+zOX5vXOpXcvjXxhwybkczKh9wozmAxp0RmM/
         JrL++z5f0TF/IOSY7dfXP2fcFtHP+rasl4NYTfGva2fZiAWyz03ymnusybEr/R80yn3n
         J0YoOpG8KPZMwkDz0MarDIyUN4EIGuEHli/HPIJouxFk4nBwHO+2AtHEoBj/G9ky2Wh6
         WSctMLTpZgfn3I+Fbz2+bx7Hn4h+tWjte4KdS3KwFzrMZpXyklTODkxm0SgLdxrAavJ5
         5XEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mjh66l7EjiKQtKP9c2a3KtPXE8PrCUDOCdt6/27IAc4=;
        b=zXAAvVKhE5dTSEvptUr6KIFB9JbZriHPs8BttUQCyoydzz58hbuGYxumMlleRmeV5J
         8bomR/pQ4CBUYSXKhKg2jHKk990tQxJr1Mu+dzaWA+oc0Rr68USAN2U6lY3dIe3mDQSP
         Y3SvXB6IPA+TR0icYAq40aziBuppa98aBvFl8DKccSOxbeVdYLyY7tEZAvxrG0Yyfiy1
         bhz1P5lqrVvEFasxrsTZcAPt7w691FDzKSwsfnSaCoPlrxmBGzWz8zgu2f5VXZq+5FtN
         ZJ5mo0+JaYs2l0br5t+dr3XGdQKOgzCE757RaIFLnke4jxElBKnBVp2J1VkO9vQXIQeu
         KgZQ==
X-Gm-Message-State: AOAM532JkNg3WA+VqaNgh9XmGX5SMaTBEDRWeSdsI0iWdGd7YrgQjhLl
        LDYhkWOUY7XLnaucTwtbKIHKoej2lqE=
X-Google-Smtp-Source: ABdhPJwtWOAns0TANabseZMUaUr3A+07qUEJ2zIEofPWG2sZrnQqEkWZqrMhxv4ZvvTj5ODTutHnxQ==
X-Received: by 2002:ae9:eb06:: with SMTP id b6mr4540793qkg.417.1633725199865;
        Fri, 08 Oct 2021 13:33:19 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:795f:367d:1f1e:4801])
        by smtp.gmail.com with ESMTPSA id c8sm381945qtb.9.2021.10.08.13.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:33:19 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v4 2/4] skmsg: extract and reuse sk_msg_is_readable()
Date:   Fri,  8 Oct 2021 13:33:04 -0700
Message-Id: <20211008203306.37525-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211008203306.37525-1-xiyou.wangcong@gmail.com>
References: <20211008203306.37525-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

tcp_bpf_sock_is_readable() is pretty much generic,
we can extract it and reuse it for non-TCP sockets.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h |  1 +
 net/core/skmsg.c      | 14 ++++++++++++++
 net/ipv4/tcp_bpf.c    | 15 +--------------
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 14ab0c0bc924..1ce9a9eb223b 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -128,6 +128,7 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 			     struct sk_msg *msg, u32 bytes);
 int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		   int len, int flags);
+bool sk_msg_is_readable(struct sock *sk);
 
 static inline void sk_msg_check_to_free(struct sk_msg *msg, u32 i, u32 bytes)
 {
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 2d6249b28928..a86ef7e844f8 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -474,6 +474,20 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 }
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
 
+bool sk_msg_is_readable(struct sock *sk)
+{
+	struct sk_psock *psock;
+	bool empty = true;
+
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (likely(psock))
+		empty = list_empty(&psock->ingress_msg);
+	rcu_read_unlock();
+	return !empty;
+}
+EXPORT_SYMBOL_GPL(sk_msg_is_readable);
+
 static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 						  struct sk_buff *skb)
 {
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 0175dbcb7722..dabbc93e31b6 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -150,19 +150,6 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
 EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir);
 
 #ifdef CONFIG_BPF_SYSCALL
-static bool tcp_bpf_sock_is_readable(struct sock *sk)
-{
-	struct sk_psock *psock;
-	bool empty = true;
-
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	if (likely(psock))
-		empty = list_empty(&psock->ingress_msg);
-	rcu_read_unlock();
-	return !empty;
-}
-
 static int tcp_msg_wait_data(struct sock *sk, struct sk_psock *psock,
 			     long timeo)
 {
@@ -479,7 +466,7 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 	prot[TCP_BPF_BASE].unhash		= sock_map_unhash;
 	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
-	prot[TCP_BPF_BASE].sock_is_readable	= tcp_bpf_sock_is_readable;
+	prot[TCP_BPF_BASE].sock_is_readable	= sk_msg_is_readable;
 
 	prot[TCP_BPF_TX]			= prot[TCP_BPF_BASE];
 	prot[TCP_BPF_TX].sendmsg		= tcp_bpf_sendmsg;
-- 
2.30.2

