Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A17F791A5
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbfG2Q7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:59:35 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41031 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728808AbfG2Q7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:59:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id m30so28348366pff.8;
        Mon, 29 Jul 2019 09:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+heWdKVZ67A1KrVZPfXJxz5dwOLJLsGom0bgqbhOGtw=;
        b=qmKoP6vuvj5oCwratwF53+jGyCAVigSB3pJmxu7fC6LfA5CQRuNSS9dctF6NyQQPL9
         c204QY04xWmCy8vuYeJwbIuck0KqueANaXQ7DFPPyH0tM1+uFoOhO8WvJnXhYq5UjMwJ
         kWE8xwvwcidQREENi1WLdfzSIJEEluurfFKEmCbPn2gg5q03cWGMHPPQRg/MzGmkPTDC
         5rTilKfk1MOHWJujVYtOJ8EylomYYxyDnBG9GEYtVAHDUIMqarwEzLQkrAEp5b5IMt0T
         uni1qW2g/I1vZHLKWkmXjT0sxe8Ixs10OaMLCYVxCnjTlQ4or5yKCy4CMIsiHdXN96Vp
         vvPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+heWdKVZ67A1KrVZPfXJxz5dwOLJLsGom0bgqbhOGtw=;
        b=RVYYXrMrAU8t20ps1PWZK0SnKfIejtG41rqKmc7onAJabnteOhWFl8cyNP2WRClWz9
         puIrPlmLb/D/fcCuGtb1RE09VqU+JRr2qOKWvlE+/ydSfdTaa1zwmKcAapB/nrVD/A/z
         Ue8FCAUq0iPAiy3ybEBTyS0EG4gQa/y3yFSBVPXg5apdbf4vafm0Lbt5U88KHQMor9Nc
         yR4ljtNbwNipiBHr1IjOovTrLh7EHlzUp6GIkPhBtNC3EgjDBWheMRZG/xyVRkJ2yKXv
         MlL8I90jvIkeJUWsbMQ3hmz5OBlhDHLvu//saQpKV9f5pdd8DFS9sFaVD8E+DYFCDuPk
         igEA==
X-Gm-Message-State: APjAAAVpCCmU6Cly7tojiDGMlyw84lXlKbHatzWYio1XDk0pn6L7KB+f
        7Guen1///CsutnjRX8oaNfkp1ws2
X-Google-Smtp-Source: APXvYqyATkKV5qrIhtHaYHGAKz4iYr7rkz4y6dn+FZBlwI90UGEEtbEyg7YxfXGHiNsRdILn6/lKHQ==
X-Received: by 2002:a63:5452:: with SMTP id e18mr88891843pgm.232.1564419572272;
        Mon, 29 Jul 2019 09:59:32 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id i198sm60784651pgd.44.2019.07.29.09.59.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:59:31 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        toke@redhat.com, Petar Penkov <ppenkov@google.com>
Subject: [bpf-next,v2 2/6] tcp: add skb-less helpers to retrieve SYN cookie
Date:   Mon, 29 Jul 2019 09:59:14 -0700
Message-Id: <20190729165918.92933-3-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
In-Reply-To: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
References: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

This patch allows generation of a SYN cookie before an SKB has been
allocated, as is the case at XDP.

Signed-off-by: Petar Penkov <ppenkov@google.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/net/tcp.h    | 10 ++++++
 net/ipv4/tcp_input.c | 73 ++++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c  | 15 +++++++++
 net/ipv6/tcp_ipv6.c  | 15 +++++++++
 4 files changed, 113 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e5cf514ba118..fb7e153aecc5 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -414,6 +414,16 @@ void tcp_parse_options(const struct net *net, const struct sk_buff *skb,
 		       int estab, struct tcp_fastopen_cookie *foc);
 const u8 *tcp_parse_md5sig_option(const struct tcphdr *th);
 
+/*
+ *	BPF SKB-less helpers
+ */
+u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
+			 struct tcphdr *th, u32 *cookie);
+u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
+			 struct tcphdr *th, u32 *cookie);
+u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
+			  const struct tcp_request_sock_ops *af_ops,
+			  struct sock *sk, struct tcphdr *th);
 /*
  *	TCP v4 functions exported for the inet6 API
  */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 8892df6de1d4..706cbb3b2986 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3782,6 +3782,49 @@ static void smc_parse_options(const struct tcphdr *th,
 #endif
 }
 
+/* Try to parse the MSS option from the TCP header. Return 0 on failure, clamped
+ * value on success.
+ */
+static u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss)
+{
+	const unsigned char *ptr = (const unsigned char *)(th + 1);
+	int length = (th->doff * 4) - sizeof(struct tcphdr);
+	u16 mss = 0;
+
+	while (length > 0) {
+		int opcode = *ptr++;
+		int opsize;
+
+		switch (opcode) {
+		case TCPOPT_EOL:
+			return mss;
+		case TCPOPT_NOP:	/* Ref: RFC 793 section 3.1 */
+			length--;
+			continue;
+		default:
+			if (length < 2)
+				return mss;
+			opsize = *ptr++;
+			if (opsize < 2) /* "silly options" */
+				return mss;
+			if (opsize > length)
+				return mss;	/* fail on partial options */
+			if (opcode == TCPOPT_MSS && opsize == TCPOLEN_MSS) {
+				u16 in_mss = get_unaligned_be16(ptr);
+
+				if (in_mss) {
+					if (user_mss && user_mss < in_mss)
+						in_mss = user_mss;
+					mss = in_mss;
+				}
+			}
+			ptr += opsize - 2;
+			length -= opsize;
+		}
+	}
+	return mss;
+}
+
 /* Look for tcp options. Normally only called on SYN and SYNACK packets.
  * But, this can also be called on packets in the established flow when
  * the fast version below fails.
@@ -6464,6 +6507,36 @@ static void tcp_reqsk_record_syn(const struct sock *sk,
 	}
 }
 
+/* If a SYN cookie is required and supported, returns a clamped MSS value to be
+ * used for SYN cookie generation.
+ */
+u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
+			  const struct tcp_request_sock_ops *af_ops,
+			  struct sock *sk, struct tcphdr *th)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	u16 mss;
+
+	if (sock_net(sk)->ipv4.sysctl_tcp_syncookies != 2 &&
+	    !inet_csk_reqsk_queue_is_full(sk))
+		return 0;
+
+	if (!tcp_syn_flood_action(sk, rsk_ops->slab_name))
+		return 0;
+
+	if (sk_acceptq_is_full(sk)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
+		return 0;
+	}
+
+	mss = tcp_parse_mss_option(th, tp->rx_opt.user_mss);
+	if (!mss)
+		mss = af_ops->mss_clamp;
+
+	return mss;
+}
+EXPORT_SYMBOL_GPL(tcp_get_syncookie_mss);
+
 int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		     const struct tcp_request_sock_ops *af_ops,
 		     struct sock *sk, struct sk_buff *skb)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d57641cb3477..10217393cda6 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1515,6 +1515,21 @@ static struct sock *tcp_v4_cookie_check(struct sock *sk, struct sk_buff *skb)
 	return sk;
 }
 
+u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
+			 struct tcphdr *th, u32 *cookie)
+{
+	u16 mss = 0;
+#ifdef CONFIG_SYN_COOKIES
+	mss = tcp_get_syncookie_mss(&tcp_request_sock_ops,
+				    &tcp_request_sock_ipv4_ops, sk, th);
+	if (mss) {
+		*cookie = __cookie_v4_init_sequence(iph, th, &mss);
+		tcp_synq_overflow(sk);
+	}
+#endif
+	return mss;
+}
+
 /* The socket must have it's spinlock held when we get
  * here, unless it is a TCP_LISTEN socket.
  *
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5da069e91cac..87f44d3250ee 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1063,6 +1063,21 @@ static struct sock *tcp_v6_cookie_check(struct sock *sk, struct sk_buff *skb)
 	return sk;
 }
 
+u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
+			 struct tcphdr *th, u32 *cookie)
+{
+	u16 mss = 0;
+#ifdef CONFIG_SYN_COOKIES
+	mss = tcp_get_syncookie_mss(&tcp6_request_sock_ops,
+				    &tcp_request_sock_ipv6_ops, sk, th);
+	if (mss) {
+		*cookie = __cookie_v6_init_sequence(iph, th, &mss);
+		tcp_synq_overflow(sk);
+	}
+#endif
+	return mss;
+}
+
 static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 {
 	if (skb->protocol == htons(ETH_P_IP))
-- 
2.22.0.709.g102302147b-goog

