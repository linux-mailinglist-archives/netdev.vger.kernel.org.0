Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 832DF69FD2
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 02:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733035AbfGPA1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 20:27:03 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:40322 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731522AbfGPA1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 20:27:02 -0400
Received: by mail-pf1-f172.google.com with SMTP id p184so8191814pfp.7;
        Mon, 15 Jul 2019 17:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kR0eAk9Wpb9hrd+QvnzWqDUYGA359kOAWHMIgTlrfl0=;
        b=ikecxLh6YgezZpx821yjNnkCUY2J8h3Y9mOmJ7FcANanV6x+x8pz1q8MiLYqyAXHwo
         BeDp1pNRy25Xf0zLu/96gNq+Tvgr7gO0fsM2scDGWlep6I5zWMIKXBCmwhtmz4e4TfgQ
         ZwiQDP1DSaRpaIBRWPONF9Ko0IXlOPsgmr9IM3Y/2iLjiRHxqghWa1QNutRJz05OytbN
         KqeiJEghP4yg8eq65cZL4A5nGZhBmGYeQi8e6+8l3+fKjQhOuLaBaPbD9+Xnhpxxyhn6
         Q64ijDT8f1JTHyJCE7mE88z1TKXp6P73KCDwGKDGQUhCKUQNKMvcCwrsJHC/qcSuiiFy
         LDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kR0eAk9Wpb9hrd+QvnzWqDUYGA359kOAWHMIgTlrfl0=;
        b=n8wyG7CyTDCGf7Mxp7nf/7YzLKl08IGXu8W259MhG8xhgjlfPQHOeGViNeuuZOAPWh
         XKTUo0sB0gpJQKyq9RYAivtRSsWT/1UlxCnWQsqmW5G2/0kILqFHNnK3UpbmzTnvRxlQ
         uYFycvdd3Q4AZs7k0+kVIhxAgTRizK+RQiqDdbkhahV09ahC2z2axiBKWU6SGKlAyZbw
         9jrJJBg+4xLW0LhUU9UO32/qGHTnQXyeeuh6A/wihcajFie2YpP60jiJ9i1EAHVQUd1a
         IYG2uT3NanP82jLkvAcVZqZyDUUqlOZl+QsD+mzNJqiP1oc6uAWx2H8lT6nPnZzvFpXa
         2AUg==
X-Gm-Message-State: APjAAAVxne0pczIuJe4Uqin+Viz8rXKdAIn962uQggqVfUfcwlY4Q99n
        SHBUHzzJQxvNpVMCUOTbowNmQ7zQ
X-Google-Smtp-Source: APXvYqyGiP3cVnXztZpXcNV75aLBJE8CAzbtVrRHtZc9LLPmYlEh2cdc52FohHmbe3SnuNHeplsDfg==
X-Received: by 2002:a17:90a:cb87:: with SMTP id a7mr33388106pju.130.1563236821242;
        Mon, 15 Jul 2019 17:27:01 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id q24sm16775444pjp.14.2019.07.15.17.27.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 17:27:00 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next RFC 2/6] tcp: add skb-less helpers to retrieve SYN cookie
Date:   Mon, 15 Jul 2019 17:26:46 -0700
Message-Id: <20190716002650.154729-3-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
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
---
 include/net/tcp.h    | 11 ++++++
 net/ipv4/tcp_input.c | 79 ++++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c  |  8 +++++
 net/ipv6/tcp_ipv6.c  |  8 +++++
 4 files changed, 106 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index cca3c59b98bf..a128e22c0d5d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -414,6 +414,17 @@ void tcp_parse_options(const struct net *net, const struct sk_buff *skb,
 		       int estab, struct tcp_fastopen_cookie *foc);
 const u8 *tcp_parse_md5sig_option(const struct tcphdr *th);
 
+/*
+ *	BPF SKB-less helpers
+ */
+u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
+			 struct tcphdr *tch, u32 *cookie);
+u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
+			 struct tcphdr *tch, u32 *cookie);
+u16 tcp_get_syncookie(struct request_sock_ops *rsk_ops,
+		      const struct tcp_request_sock_ops *af_ops,
+		      struct sock *sk, void *iph, struct tcphdr *tch,
+		      u32 *cookie);
 /*
  *	TCP v4 functions exported for the inet6 API
  */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 8892df6de1d4..1406d7e0953c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3782,6 +3782,52 @@ static void smc_parse_options(const struct tcphdr *th,
 #endif
 }
 
+/* Try to parse the MSS option from the TCP header. Return 0 on failure, clamped
+ * value on success.
+ *
+ * Invoked for BPF SYN cookie generation, so th should be a SYN.
+ */
+static u16 tcp_parse_mss_option(const struct net *net, const struct tcphdr *th,
+				u16 user_mss)
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
@@ -6464,6 +6510,39 @@ static void tcp_reqsk_record_syn(const struct sock *sk,
 	}
 }
 
+u16 tcp_get_syncookie(struct request_sock_ops *rsk_ops,
+		      const struct tcp_request_sock_ops *af_ops,
+		      struct sock *sk, void *iph, struct tcphdr *th,
+		      u32 *cookie)
+{
+	u16 mss = 0;
+#ifdef CONFIG_SYN_COOKIES
+	bool is_v4 = rsk_ops->family == AF_INET;
+	struct tcp_sock *tp = tcp_sk(sk);
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
+	mss = tcp_parse_mss_option(sock_net(sk), th, tp->rx_opt.user_mss);
+	if (!mss)
+		mss = af_ops->mss_clamp;
+
+	tcp_synq_overflow(sk);
+	*cookie = is_v4 ? __cookie_v4_init_sequence(iph, th, &mss)
+			: __cookie_v6_init_sequence(iph, th, &mss);
+#endif
+	return mss;
+}
+
 int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		     const struct tcp_request_sock_ops *af_ops,
 		     struct sock *sk, struct sk_buff *skb)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d57641cb3477..0e06e59784bd 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1515,6 +1515,14 @@ static struct sock *tcp_v4_cookie_check(struct sock *sk, struct sk_buff *skb)
 	return sk;
 }
 
+u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
+			 struct tcphdr *tch, u32 *cookie)
+{
+	return tcp_get_syncookie(&tcp_request_sock_ops,
+				 &tcp_request_sock_ipv4_ops, sk, iph, tch,
+				 cookie);
+}
+
 /* The socket must have it's spinlock held when we get
  * here, unless it is a TCP_LISTEN socket.
  *
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d56a9019a0fe..ce46cdba54bc 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1058,6 +1058,14 @@ static struct sock *tcp_v6_cookie_check(struct sock *sk, struct sk_buff *skb)
 	return sk;
 }
 
+u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
+			 struct tcphdr *tch, u32 *cookie)
+{
+	return tcp_get_syncookie(&tcp6_request_sock_ops,
+				 &tcp_request_sock_ipv6_ops, sk, iph, tch,
+				 cookie);
+}
+
 static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 {
 	if (skb->protocol == htons(ETH_P_IP))
-- 
2.22.0.510.g264f2c817a-goog

