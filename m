Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14BAFD1BC9
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 00:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732041AbfJIWcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 18:32:42 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:41821 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730809AbfJIWcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 18:32:42 -0400
Received: by mail-pg1-f201.google.com with SMTP id p2so2737460pgb.8
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 15:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OP0rOGI7Eew5efT77zq7Qg+lMWlydg6a1gaA5rxGEsY=;
        b=asQWQjzlVfhc4UDhiLGZ9tkIlR2+1d5iIfj9ae3JHDTpOsq1FbspGOlBylIweQSQxJ
         Lovj3VXq0dVr7CzfraazXyK/20ksvpPeO/6kj8wd8x8ePFF7ylwoC5L7UL2GBe3ZKQEn
         +2/qj1pZQaujQq9WHu+OHUjyoiSIqeoWZdWc4Qwk+8zGvSzBJlNXEfyIWJGn27joQ35e
         xckL3Ns6Dy2DdArC2ENFq+9eBfqEupOj0T/9IxokdmE/pL2fLPWcv0iCtroihiQFrFYz
         IvNemS/VWM3m2/nFadWPxECif7fuvLCRPv7EqBj2Eq6Ko0XXpUhj2yXrtP01kNsC3RK8
         XmgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OP0rOGI7Eew5efT77zq7Qg+lMWlydg6a1gaA5rxGEsY=;
        b=oigwOplzATVWOU116I2jDdlb0FBoWvblnKEtf8wqmNxMox5FkfAdx5z2fjo9FD5Q9n
         68WjsgX62j+ksjnl0AnxBg6XBz0kcIRBEAoDnZ9B8af/seSfM25/cDO/4mHFxhBR6i8y
         njc5CC3OgiaW/QbXnb6cuzDPhm80N75UiBtIeYED+zKbXieZEAmcVZiZ1xTb50vo9UPm
         GzPA2WDloyPd66LMLfIlpWf4XGC9CpEBlH9WoEUNXy7JGKAbqWgforT4N2g9CH5v481C
         JkKjQHF9RXFhhP2kvq2lz9ukxKOFgVMWGzk48zvV8cgk0wM+EpjM8G+6iAT6CWn1CNCi
         ivnQ==
X-Gm-Message-State: APjAAAUgTSfiHldGVSgJaqImMpY8+t75qMxyg89hBoavYHDUqjO3rcl6
        KRjCo96blxK/8k6MqkajZgARmJ0WbUgEZg==
X-Google-Smtp-Source: APXvYqxxOvgt/OSRSa11/r8xBI3JEPfwOl1jx1dnRmE94LHhNGmTzdG6CYe+Q8JrzoLlGu3yfkzV6AGMrJsHKw==
X-Received: by 2002:a63:cb4c:: with SMTP id m12mr4175481pgi.58.1570660360360;
 Wed, 09 Oct 2019 15:32:40 -0700 (PDT)
Date:   Wed,  9 Oct 2019 15:32:35 -0700
Message-Id: <20191009223235.92999-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net] net: annotate sk->sk_rcvlowat lockless reads
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_rcvlowat() or int_sk_rcvlowat() might be called without the socket
lock for example from tcp_poll().

Use READ_ONCE() to document the fact that other cpus might change
sk->sk_rcvlowat under us and avoid KCSAN splats.

Use WRITE_ONCE() on write sides too.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h  | 4 +++-
 net/core/filter.c   | 2 +-
 net/core/sock.c     | 2 +-
 net/ipv4/tcp.c      | 2 +-
 net/sched/em_meta.c | 2 +-
 5 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 2c53f1a1d905409247b1bdafdfaf99d86e430cd0..79f54e1f88277dc7cc64ca0f35fd5ba869a2f96d 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2271,7 +2271,9 @@ static inline long sock_sndtimeo(const struct sock *sk, bool noblock)
 
 static inline int sock_rcvlowat(const struct sock *sk, int waitall, int len)
 {
-	return (waitall ? len : min_t(int, sk->sk_rcvlowat, len)) ? : 1;
+	int v = waitall ? len : min_t(int, READ_ONCE(sk->sk_rcvlowat), len);
+
+	return v ?: 1;
 }
 
 /* Alas, with timeout socket operations are not restartable.
diff --git a/net/core/filter.c b/net/core/filter.c
index ed6563622ce31dcced4e6ba622770e26f1f7756a..a50c0b6846f29006268b2fb18303d692533bc081 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4274,7 +4274,7 @@ BPF_CALL_5(bpf_setsockopt, struct bpf_sock_ops_kern *, bpf_sock,
 		case SO_RCVLOWAT:
 			if (val < 0)
 				val = INT_MAX;
-			sk->sk_rcvlowat = val ? : 1;
+			WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
 			break;
 		case SO_MARK:
 			if (sk->sk_mark != val) {
diff --git a/net/core/sock.c b/net/core/sock.c
index 1cf06934da50b98fccc849d396680cee46badb7d..b7c5c6ea51baf88548e73abd85c8f77cf29a2249 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -974,7 +974,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		if (sock->ops->set_rcvlowat)
 			ret = sock->ops->set_rcvlowat(sk, val);
 		else
-			sk->sk_rcvlowat = val ? : 1;
+			WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
 		break;
 
 	case SO_RCVTIMEO_OLD:
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 888c92b63f5a6dc4b935cca7c979c1e559126d44..8781a92ea4b6e4ee9ceeb763dae01970e7f4438a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1699,7 +1699,7 @@ int tcp_set_rcvlowat(struct sock *sk, int val)
 	else
 		cap = sock_net(sk)->ipv4.sysctl_tcp_rmem[2] >> 1;
 	val = min(val, cap);
-	sk->sk_rcvlowat = val ? : 1;
+	WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
 
 	/* Check if we need to signal EPOLLIN right now */
 	tcp_data_ready(sk);
diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index 82bd14e7ac93dc709483b3437cdc1779b34d0888..4c9122fc35c9d5f86ed60bc03427da1cde57b636 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -554,7 +554,7 @@ META_COLLECTOR(int_sk_rcvlowat)
 		*err = -1;
 		return;
 	}
-	dst->value = sk->sk_rcvlowat;
+	dst->value = READ_ONCE(sk->sk_rcvlowat);
 }
 
 META_COLLECTOR(int_sk_rcvtimeo)
-- 
2.23.0.581.g78d2f28ef7-goog

