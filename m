Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22577137BC7
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 07:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgAKGMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 01:12:52 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:33815 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgAKGMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 01:12:52 -0500
Received: by mail-il1-f195.google.com with SMTP id s15so3630923iln.1;
        Fri, 10 Jan 2020 22:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QiMdV4OLEwq0FLj4VztT2ToAicHmfpX3NmaOXmEG4Lw=;
        b=OJOa+DHTTThbQQx89RRflJq4Tn7Xc6VGUA3aRIzrKAPY4FTfDIXHC5+Mt676ztjs0B
         2nsd2VHylloAqZ7xeKYpCy9u0u0DC4WB9KH3h/2ux07QQOTVNRcFefr5R0bqcWHf3WHg
         37g5/8XE9XDHhZ6SqShxBgOTaxAJC8qQA6E4gGHpqjBu+gPU1yvAjmalyCMVhlDBjd2Y
         u3NsKbTbGY6Pk/4/AQoH3Wmb8v723krAdxe9zx9JZ3Ah81+C+Mnb/KK4G72kJhZ1w7Yd
         sWsHTBgLoGBw2rD4qz7a/5c+4Azv9TpvgaQQNWCINR8cZ38rHHJ/txtFy22fZrBMJ55X
         BTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QiMdV4OLEwq0FLj4VztT2ToAicHmfpX3NmaOXmEG4Lw=;
        b=C2G4pn36/0WN3fUjWIHd9+LmL5j+lak/9ODas7ZKmS4dKlf/pSFYfAi47r17PAL5Up
         x0qPgKuVxEBgS5WTSFNC5iL+EGO2y/XhSO+EAsfMAoaoYdylsQJqxxgI4YX9TwmPp8w0
         19ZVaBy9KP1reHEGaBrwZLvBR4h8FDb4g4KjdOhpClN5ygfPWudMvQM/YbTJJJgQUB6x
         trtJVY26iXBXfwVhHUm5sk6ORX7ARmwKF7UedrktkAGpyXYHQkZhBcO3VLHlzKl0sk9e
         s06oAALHleGcYVOn39tQQJb1J9rgkAC4kVjYg9STM9NNmUuspA+3QNysPvPaJa3kpED3
         I+Hw==
X-Gm-Message-State: APjAAAUTHMcFgKqyeqZGybt9hj2X1mJlyQlyvs8BunCalJHst0cPEaTc
        Ji3be2yLoFzrupJNIlgMo9bQAoUN
X-Google-Smtp-Source: APXvYqwIgdCdmvs7bNvjMHilXiaKdd+ltp/jT2xDbe7RqRWATifael0p4TrYfj61xMPIwY7Zbw1EbA==
X-Received: by 2002:a92:ca8b:: with SMTP id t11mr6364437ilo.227.1578723171297;
        Fri, 10 Jan 2020 22:12:51 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 141sm1417784ile.44.2020.01.10.22.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 22:12:50 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, song@kernel.org, jonathan.lemon@gmail.com
Subject: [bpf PATCH v2 3/8] bpf: sockmap/tls, push write_space updates through ulp updates
Date:   Sat, 11 Jan 2020 06:12:01 +0000
Message-Id: <20200111061206.8028-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200111061206.8028-1-john.fastabend@gmail.com>
References: <20200111061206.8028-1-john.fastabend@gmail.com>
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

Cc: stable@vger.kernel.org
Fixes: 95fa145479fbc ("bpf: sockmap/tls, close can race with map free")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h | 12 ++++++++----
 include/net/tcp.h     |  6 ++++--
 net/ipv4/tcp_ulp.c    |  6 ++++--
 net/tls/tls_main.c    | 10 +++++++---
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
-- 
2.17.1

