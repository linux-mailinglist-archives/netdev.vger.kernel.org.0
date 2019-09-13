Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB240B1706
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 03:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfIMBQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 21:16:52 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41312 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfIMBQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 21:16:52 -0400
Received: by mail-qk1-f195.google.com with SMTP id p10so8519284qkg.8
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 18:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mChTQIJY7HYQYLAaRML7dWZmsFscb2agrGuRHVuGXUw=;
        b=ndHCIBvERsuu3LdTXy/FwCPeZNLKn2R+fiMi6izH4l6rB5WP+HiPF7cL4Cds0Sgc32
         zzeZ79XjCDkaOKf0EnzA5G2gJ3XV8ZNDswhgYbYPgj6ofWV2Tfl8SNka6GJSwWf0qdzK
         +e2veNzM5w3uvL5AkKqtlFU5BBg5mjYnjoVGju45JPB+R3GxnP8w/cDlkeRhJ0VQLIa+
         sQePw6YGwgXdFOWz701NOnEs8UV3uNexIEXz0pr+Glla9jnPLTiR/QAGr3gP49jVtKpo
         kyQ6au+FGfRiIJTPAwk7WvxfCb+o6MrRBVF+hMfkzjmfQnYhxOw+XNhBYwfEJYjQOYQR
         xODw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mChTQIJY7HYQYLAaRML7dWZmsFscb2agrGuRHVuGXUw=;
        b=PSP+6PzMvbSUaGmhDzy3fyG8jr7KrcFWtRH6dNUo0BiEaA7Z7hrQhJ4jir0pDiYrpi
         JM+eb7GaPMJUcYw047YIf6bbYmpVEMgMLyUtluTRHVDzq3FhaRAE7thy0mQCXQ10zvpN
         lUAEGRoPp9EjqHbpkMBVVv3mFKC1jLvXIR0QuqSAWWgdX7XUl8AEJsOYN0QkqE5hhh9s
         Er9Isku0cGeBIo0thykzogjjS/1HaY6yjLqhHjDUXmLJReQ8YZE/FnJApDwvyZF2/rRU
         26JlCCL9HwrPRvYibOG3SgdbHWwjV0TUsmFOB2l/nHYLqIwtm+MJivYDdzwOCn5X44H/
         Y/Tw==
X-Gm-Message-State: APjAAAVedonUn5JLmQlU6yJhTHUyOuuyLUFTOEKSQbbcR3ReN3gULNZx
        F8npk6/nxCe8pAVm2a0heCeQFwWU
X-Google-Smtp-Source: APXvYqzWV3j6WZd5yCVlwuCICRZe6hphzOuFUkXG1+ZWsVqm2DCDz9UUx42+2Hoqs7E2OaHsfd3n0Q==
X-Received: by 2002:ae9:edd8:: with SMTP id c207mr38755936qkg.337.1568337410668;
        Thu, 12 Sep 2019 18:16:50 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:89db:8f93:8219:1619])
        by smtp.gmail.com with ESMTPSA id j17sm16146724qta.0.2019.09.12.18.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 18:16:49 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kraig@google.com,
        zabele@comcast.net, pabeni@redhat.com, mark.keaton@raytheon.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] udp: correct reuseport selection with connected sockets
Date:   Thu, 12 Sep 2019 21:16:39 -0400
Message-Id: <20190913011639.55895-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

UDP reuseport groups can hold a mix unconnected and connected sockets.
Ensure that connections only receive all traffic to their 4-tuple.

Fast reuseport returns on the first reuseport match on the assumption
that all matches are equal. Only if connections are present, return to
the previous behavior of scoring all sockets.

Record if connections are present and if so (1) treat such connected
sockets as an independent match from the group, (2) only return
2-tuple matches from reuseport and (3) do not return on the first
2-tuple reuseport match to allow for a higher scoring match later.

New field has_conns is set without locks. No other fields in the
bitmap are modified at runtime and the field is only ever set
unconditionally, so an RMW cannot miss a change.

Fixes: e32ea7e74727 ("soreuseport: fast reuseport UDP socket selection")
Link: http://lkml.kernel.org/r/CA+FuTSfRP09aJNYRt04SS6qj22ViiOEWaWmLAwX0psk8-PGNxw@mail.gmail.com
Signed-off-by: Willem de Bruijn <willemb@google.com>

---

I was unable to compile some older kernels, so the Fixes tag is based
on basic analysis, not bisected to by the regression test.
---
 include/net/sock_reuseport.h | 20 +++++++++++++++++++-
 net/core/sock_reuseport.c    | 15 +++++++++++++--
 net/ipv4/datagram.c          |  2 ++
 net/ipv4/udp.c               |  5 +++--
 net/ipv6/datagram.c          |  2 ++
 net/ipv6/udp.c               |  5 +++--
 6 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index d9112de85261..43f4a818d88f 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -21,7 +21,8 @@ struct sock_reuseport {
 	unsigned int		synq_overflow_ts;
 	/* ID stays the same even after the size of socks[] grows. */
 	unsigned int		reuseport_id;
-	bool			bind_inany;
+	unsigned int		bind_inany:1;
+	unsigned int		has_conns:1;
 	struct bpf_prog __rcu	*prog;		/* optional BPF sock selector */
 	struct sock		*socks[0];	/* array of sock pointers */
 };
@@ -37,6 +38,23 @@ extern struct sock *reuseport_select_sock(struct sock *sk,
 extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
 extern int reuseport_detach_prog(struct sock *sk);
 
+static inline bool reuseport_has_conns(struct sock *sk, bool set)
+{
+	struct sock_reuseport *reuse;
+	bool ret = false;
+
+	rcu_read_lock();
+	reuse = rcu_dereference(sk->sk_reuseport_cb);
+	if (reuse) {
+		if (set)
+			reuse->has_conns = 1;
+		ret = reuse->has_conns;
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 int reuseport_get_id(struct sock_reuseport *reuse);
 
 #endif  /* _SOCK_REUSEPORT_H */
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 9408f9264d05..f3ceec93f392 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -295,8 +295,19 @@ struct sock *reuseport_select_sock(struct sock *sk,
 
 select_by_hash:
 		/* no bpf or invalid bpf result: fall back to hash usage */
-		if (!sk2)
-			sk2 = reuse->socks[reciprocal_scale(hash, socks)];
+		if (!sk2) {
+			int i, j;
+
+			i = j = reciprocal_scale(hash, socks);
+			while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
+				i++;
+				if (i >= reuse->num_socks)
+					i = 0;
+				if (i == j)
+					goto out;
+			}
+			sk2 = reuse->socks[i];
+		}
 	}
 
 out:
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 7bd29e694603..9a0fe0c2fa02 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -15,6 +15,7 @@
 #include <net/sock.h>
 #include <net/route.h>
 #include <net/tcp_states.h>
+#include <net/sock_reuseport.h>
 
 int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
@@ -69,6 +70,7 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 	}
 	inet->inet_daddr = fl4->daddr;
 	inet->inet_dport = usin->sin_port;
+	reuseport_has_conns(sk, true);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 	inet->inet_id = jiffies;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index d88821c794fb..16486c8b708b 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -423,12 +423,13 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif);
 		if (score > badness) {
-			if (sk->sk_reuseport) {
+			if (sk->sk_reuseport &&
+			    sk->sk_state != TCP_ESTABLISHED) {
 				hash = udp_ehashfn(net, daddr, hnum,
 						   saddr, sport);
 				result = reuseport_select_sock(sk, hash, skb,
 							sizeof(struct udphdr));
-				if (result)
+				if (result && !reuseport_has_conns(sk, false))
 					return result;
 			}
 			badness = score;
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 9ab897ded4df..96f939248d2f 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -27,6 +27,7 @@
 #include <net/ip6_route.h>
 #include <net/tcp_states.h>
 #include <net/dsfield.h>
+#include <net/sock_reuseport.h>
 
 #include <linux/errqueue.h>
 #include <linux/uaccess.h>
@@ -254,6 +255,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 		goto out;
 	}
 
+	reuseport_has_conns(sk, true);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 out:
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 827fe7385078..5995fdc99d3f 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -158,13 +158,14 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif);
 		if (score > badness) {
-			if (sk->sk_reuseport) {
+			if (sk->sk_reuseport &&
+			    sk->sk_state != TCP_ESTABLISHED) {
 				hash = udp6_ehashfn(net, daddr, hnum,
 						    saddr, sport);
 
 				result = reuseport_select_sock(sk, hash, skb,
 							sizeof(struct udphdr));
-				if (result)
+				if (result && !reuseport_has_conns(sk, false))
 					return result;
 			}
 			result = sk;
-- 
2.23.0.237.gc6a4ce50a0-goog

