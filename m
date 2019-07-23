Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 531E570E0D
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 02:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387640AbfGWAUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 20:20:52 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:35823 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387628AbfGWAUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 20:20:50 -0400
Received: by mail-pg1-f176.google.com with SMTP id s1so12136879pgr.2;
        Mon, 22 Jul 2019 17:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7rWINEKFNBhrkzn2eVjq0i+WJXxiQb0MvhMX3YqXCs4=;
        b=DXkRmXPL/XUMAqGwoS5/UTi0dmnQA2PR8XuiWeKmOkeLC6jo7xlKdcfDjhtUc4faTR
         sm0JQLcbb8/AWrHW481Tlh4EtAmc8qR5UqXvVdF3c6l4qEpGaMG1ULhlHLDGD375z448
         IyhH5HWyga5ZATRcBFc5XgxKwkh6FXf1yiM7yD0bac5odqAsZ/XpZddE1FnAIjrBdQEJ
         VvbJ1bOK2gn4owz+ytyOcU2TTSx9XMUyRw4GvkdaluVPDh4cdjzxjQ676RcW2ESIYe0r
         vTYLCbE+Icn9XCKe95ohC/4uYiK/RPQuEEXCszXKg8FoIRDq505AbyONsEDcvMx49jCN
         ucZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7rWINEKFNBhrkzn2eVjq0i+WJXxiQb0MvhMX3YqXCs4=;
        b=ptXbOVJk3cfv2EYS3FEaH1NJcZEJ4SKoFF4uDHGCaWNc/SpWNZ3CVAJbbi/ZAJU+Kh
         4FBTJwB77klC8LkogSLIYnFSjC+6XgCx3e9SaMwq07U1Ye7wxC+i7u8wKR6iGPuydoVN
         gMIhunyG1j0RWpk9TO+B72tpPuTf/onWKIUrWWTJCpLYfgxSE9IaayBhKALObyZ0xCCL
         9zdtic6m1hGylE0M4JI3Xd5e18UN5GdsiMM1b5XC0wxreRxoABuR+ijiujK1r0J47uTN
         I6Tea2vPKce0NIZmnMHzm6vew6Cm8CFEFM/qnOujWkR+oBdF66ZcAPY1R9b78Dx3h83L
         5Mvg==
X-Gm-Message-State: APjAAAXCLtAg+zWgRZuOgpnZR0UOsc94gT+oJ5OPJwWAUKtw4eatjIF+
        E+l3ld/MAvJ5waxgnJAOTB0ZZhzM
X-Google-Smtp-Source: APXvYqxylKuGligHaHUZ+Jhqjj0K52sqY1GM8PCAgf3QIb0MTz/fTfFPiIfwvN2aP6jECRQF1kmb4A==
X-Received: by 2002:a63:4c5a:: with SMTP id m26mr72707351pgl.270.1563841249868;
        Mon, 22 Jul 2019 17:20:49 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id k64sm21718423pge.65.2019.07.22.17.20.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 17:20:49 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next 2/6] tcp: add skb-less helpers to retrieve SYN cookie
Date:   Mon, 22 Jul 2019 17:20:38 -0700
Message-Id: <20190723002042.105927-3-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
In-Reply-To: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
References: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
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
 include/net/tcp.h    | 11 +++++++
 net/ipv4/tcp_input.c | 76 ++++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c  |  8 +++++
 net/ipv6/tcp_ipv6.c  |  8 +++++
 4 files changed, 103 insertions(+)

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
index 8892df6de1d4..893b275a6d49 100644
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
@@ -6464,6 +6507,39 @@ static void tcp_reqsk_record_syn(const struct sock *sk,
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
+	mss = tcp_parse_mss_option(th, tp->rx_opt.user_mss);
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
index 5da069e91cac..102f68c3152d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1063,6 +1063,14 @@ static struct sock *tcp_v6_cookie_check(struct sock *sk, struct sk_buff *skb)
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
2.22.0.657.g960e92d24f-goog

