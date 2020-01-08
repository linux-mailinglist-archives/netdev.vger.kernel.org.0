Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA891134EAA
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgAHVOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:14:53 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:41366 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgAHVOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:14:53 -0500
Received: by mail-io1-f67.google.com with SMTP id c16so4784901ioo.8;
        Wed, 08 Jan 2020 13:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=TRxE7RDfuYSml0D0IusqQY61z0CPE8spL8tPdO24lwg=;
        b=B3EzAvZcJpv0qz7V1l+z8gkxismQaCPByV7jXiiKKu4SLbGRR/FvUWEhpOH4tV1Uu2
         4MgAPrU4aatis1mtuc9B7e228z1xWWWSyuYGV9r3wUhpBKcBrQbKOLJ0ivHejSvst9rs
         fobfUs4KzByJlZFmwhgynDVNOyp9Jn8WgAOq8OGFzSYqp4EvDHBI0m/q1iJknNXHxP7v
         jN/RaQnbFVxaRGOCUJACu4klsZhWsSblyQxFxodw7iq5MPkL+BEDdOKMnhjpr+bEe4nX
         932hlduyugBeeZKaUrVeVXmOh3gmqZKF55e2xAoZpOcQt9thE69mISYVaWaHtcg83OTD
         3Qiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=TRxE7RDfuYSml0D0IusqQY61z0CPE8spL8tPdO24lwg=;
        b=Un/5IR4U95xlS4gxEA3pPIKGSpTQpQAR2gYn22zqihCr6c+3Udr0c5qAzf8+FPnYzW
         YGCV4wcMW5XWWT8L0QchgN2/pQJwm3JEQH2x56+T3F/4DQIVT+sD61XJfkicJLNniX+v
         6ut01IB7Cq+3G9FRqe1FfI3wOsIxVcQFBrXBL93YaLQ3kX7Va1mrPXjEXyNTs4OCYtT7
         T2HLJZfKwyt5OmqK7KrE8w8yZrR0CNy9llruklJbcgFIuJjNwGnJ9HlMi5+yAWvM4K8B
         KyKnrf7WUO8eEF3/yY1YN9S5Im9VLIZdvJFq/YR5W1tvkJN5dsRih45SvsEeZaTDo3VK
         gNYQ==
X-Gm-Message-State: APjAAAUKVwQnJb3FvExPws5Kt7PWG961QHM26pk6x2Qy0cFwZiXqixV8
        VKJUKV9dgbUJFyqzYEQ/na/JIq/I
X-Google-Smtp-Source: APXvYqwd3+k3g9LbxdN9D+vjHiO5nb/Jis9a6lJk5DwFwAxbhtKgTkNhVHSHQFKkMSFgJQwdTR/GzQ==
X-Received: by 2002:a02:b602:: with SMTP id h2mr6090455jam.20.1578518092292;
        Wed, 08 Jan 2020 13:14:52 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w16sm1320379ilq.5.2020.01.08.13.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 13:14:51 -0800 (PST)
Subject: [bpf PATCH 3/9] bpf: sockmap/tls,
 push write_space updates through ulp updates
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Wed, 08 Jan 2020 21:14:41 +0000
Message-ID: <157851808101.1732.11616068811837364406.stgit@ubuntu3-kvm2>
In-Reply-To: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sockmap sock with TLS enabled is removed we cleanup bpf/psock state
and call tcp_update_ulp() to push updates to TLS ULP on top. However, we
don't push the write_space callback up and instead simply overwrite the
op with the psock stored previous op. This may or may not be correct so
to ensure we don't overwrite the TLS write space hook pass this field to
the ULP and have it fixup the ctx.

This completes a previous fix that pushed the ops through to the ULP
but at the time missed doing this for write_space, presumably because
write_space TLS hook was added around the same time.

Fixes: 95fa145479fbc ("bpf: sockmap/tls, close can race with map free")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h |   12 ++++++++----
 include/net/tcp.h     |    6 ++++--
 net/ipv4/tcp_ulp.c    |    6 ++++--
 net/tls/tls_main.c    |   10 +++++++---
 4 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index b6afe01f8592..14d61bba0b79 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -359,17 +359,21 @@ static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
 	sk->sk_prot->unhash = psock->saved_unhash;
-	sk->sk_write_space = psock->saved_write_space;
 
 	if (psock->sk_proto) {
 		struct inet_connection_sock *icsk = inet_csk(sk);
 		bool has_ulp = !!icsk->icsk_ulp_data;
 
-		if (has_ulp)
-			tcp_update_ulp(sk, psock->sk_proto);
-		else
+		if (has_ulp) {
+			tcp_update_ulp(sk, psock->sk_proto,
+				       psock->saved_write_space);
+		} else {
 			sk->sk_prot = psock->sk_proto;
+			sk->sk_write_space = psock->saved_write_space;
+		}
 		psock->sk_proto = NULL;
+	} else {
+		sk->sk_write_space = psock->saved_write_space;
 	}
 }
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index e460ea7f767b..e6f48384dc71 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2147,7 +2147,8 @@ struct tcp_ulp_ops {
 	/* initialize ulp */
 	int (*init)(struct sock *sk);
 	/* update ulp */
-	void (*update)(struct sock *sk, struct proto *p);
+	void (*update)(struct sock *sk, struct proto *p,
+		       void (*write_space)(struct sock *sk));
 	/* cleanup ulp */
 	void (*release)(struct sock *sk);
 	/* diagnostic */
@@ -2162,7 +2163,8 @@ void tcp_unregister_ulp(struct tcp_ulp_ops *type);
 int tcp_set_ulp(struct sock *sk, const char *name);
 void tcp_get_available_ulp(char *buf, size_t len);
 void tcp_cleanup_ulp(struct sock *sk);
-void tcp_update_ulp(struct sock *sk, struct proto *p);
+void tcp_update_ulp(struct sock *sk, struct proto *p,
+		    void (*write_space)(struct sock *sk));
 
 #define MODULE_ALIAS_TCP_ULP(name)				\
 	__MODULE_INFO(alias, alias_userspace, name);		\
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 12ab5db2b71c..38d3ad141161 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -99,17 +99,19 @@ void tcp_get_available_ulp(char *buf, size_t maxlen)
 	rcu_read_unlock();
 }
 
-void tcp_update_ulp(struct sock *sk, struct proto *proto)
+void tcp_update_ulp(struct sock *sk, struct proto *proto,
+		    void (*write_space)(struct sock *sk))
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
 	if (!icsk->icsk_ulp_ops) {
+		sk->sk_write_space = write_space;
 		sk->sk_prot = proto;
 		return;
 	}
 
 	if (icsk->icsk_ulp_ops->update)
-		icsk->icsk_ulp_ops->update(sk, proto);
+		icsk->icsk_ulp_ops->update(sk, proto, write_space);
 }
 
 void tcp_cleanup_ulp(struct sock *sk)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index dac24c7aa7d4..94774c0e5ff3 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -732,15 +732,19 @@ static int tls_init(struct sock *sk)
 	return rc;
 }
 
-static void tls_update(struct sock *sk, struct proto *p)
+static void tls_update(struct sock *sk, struct proto *p,
+		       void (*write_space)(struct sock *sk))
 {
 	struct tls_context *ctx;
 
 	ctx = tls_get_ctx(sk);
-	if (likely(ctx))
+	if (likely(ctx)) {
+		ctx->sk_write_space = write_space;
 		ctx->sk_proto = p;
-	else
+	} else {
 		sk->sk_prot = p;
+		sk->sk_write_space = write_space;
+	}
 }
 
 static int tls_get_info(const struct sock *sk, struct sk_buff *skb)

