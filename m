Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E7147E5A5
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349178AbhLWPlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349092AbhLWPk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:40:58 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89363C061756;
        Thu, 23 Dec 2021 07:40:57 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id b13so22891691edd.8;
        Thu, 23 Dec 2021 07:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wR6ufi53cLMSqSVTH/P70HPPxbJlp15sO2dGTr1g/e8=;
        b=SYzgokc6zSrFJI5WXn8Kcz9OVGzs9378Bmzq3rNzl5p4pTTeRCXZCrkBQ2OWu5a1vm
         bGM5m1v0tHIr/15WOEwA2MguwbSe9Y8P/Ot56QC0vK77nED97mjrnsJsTg92UftYFvsS
         zFNOAWYaB4rf/u29q5kqj+NtQEK7HiqgPJ3mTJhxJg8/NkZjXNblLgvtXMrKUoIcBaUC
         Lpwv068BeHwXnvnlPP83JLsFuvjdR+gtSeL6GrpsCUf9nudy04wmciNPxzWzGSRAvGof
         pfx95/TwH+6I8gzyGkr3Y2TQa/DIxUPOYSCnhJL4E+lXsbBBW5m3tosYAgKh0RBq96Pq
         BYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wR6ufi53cLMSqSVTH/P70HPPxbJlp15sO2dGTr1g/e8=;
        b=IoqO74U9qFBBFzIZZJefmWJoGQYq3NeQYQbdXx7Wt+6rf5sUhDgLDkDNd4Hetv0PUL
         l6L4/1ZyyGoJMWlvAa5DKSmZWgm55HoERxEyUyl0sbC3WsR+igMqggc987ov2l6lx/HH
         fIPBnUfioa+kQny5PJacSMVlDUtM7bZgEllc++x4QmsS1nYP8PZzRFMAywVRasRHRX1W
         nAQbRl4fXFqwgPPF/OVDk43gOtarUwIob7imQdEEwmOpFgWgB4CibmDAqsdy0LXyTxVk
         pKQIFiv5xckAYq6h+pBBJUjZNrwQa+NDLWC9J4V6gKRDSQGiNGw6QlUuee0prDJKfkEu
         Fhsg==
X-Gm-Message-State: AOAM532J9KpRGTkZtwOrOkgoy+phos5afes3qQ1sbtfR+1d+qOdybDic
        y8IDgQPwHSmhJjyVhGwL+dI=
X-Google-Smtp-Source: ABdhPJxXQpCdWjCb2zta/GL+BOlEJgMxQUbdiRoe962aOSsCcYh3NegFYKSVu9VjvJVyovCNEzxcBw==
X-Received: by 2002:a50:a41e:: with SMTP id u30mr2500170edb.388.1640274056079;
        Thu, 23 Dec 2021 07:40:56 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:7c02:dfc6:b554:ab10])
        by smtp.gmail.com with ESMTPSA id bx6sm2088617edb.78.2021.12.23.07.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:40:55 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 11/19] tcp: ipv4: Add AO signing for skb-less replies
Date:   Thu, 23 Dec 2021 17:40:06 +0200
Message-Id: <695e6c5bd1bef2b3b93c123c7b595f4c625c27b1.1640273966.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1640273966.git.cdleonard@gmail.com>
References: <cover.1640273966.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code in tcp_v4_send_ack and tcp_v4_send_reset does not allocate a
full skb so special handling is required for tcp-authopt handling.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_ipv4.c | 84 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 81 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b16f263c3121..6b63175d0221 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -644,10 +644,50 @@ void tcp_v4_send_check(struct sock *sk, struct sk_buff *skb)
 
 	__tcp_v4_send_check(skb, inet->inet_saddr, inet->inet_daddr);
 }
 EXPORT_SYMBOL(tcp_v4_send_check);
 
+#ifdef CONFIG_TCP_AUTHOPT
+/** tcp_v4_authopt_handle_reply - Insert TCPOPT_AUTHOPT if required
+ *
+ * returns number of bytes (always aligned to 4) or zero
+ */
+static int tcp_v4_authopt_handle_reply(const struct sock *sk,
+				       struct sk_buff *skb,
+				       __be32 *optptr,
+				       struct tcphdr *th)
+{
+	struct tcp_authopt_info *info;
+	struct tcp_authopt_key_info *key_info;
+	u8 rnextkeyid;
+
+	if (sk->sk_state == TCP_TIME_WAIT)
+		info = tcp_twsk(sk)->tw_authopt_info;
+	else
+		info = rcu_dereference_check(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return 0;
+	key_info = __tcp_authopt_select_key(sk, info, sk, &rnextkeyid);
+	if (!key_info)
+		return 0;
+	*optptr = htonl((TCPOPT_AUTHOPT << 24) |
+			(TCPOLEN_AUTHOPT_OUTPUT << 16) |
+			(key_info->send_id << 8) |
+			(rnextkeyid));
+	/* must update doff before signature computation */
+	th->doff += TCPOLEN_AUTHOPT_OUTPUT / 4;
+	tcp_v4_authopt_hash_reply((char *)(optptr + 1),
+				  info,
+				  key_info,
+				  ip_hdr(skb)->daddr,
+				  ip_hdr(skb)->saddr,
+				  th);
+
+	return TCPOLEN_AUTHOPT_OUTPUT;
+}
+#endif
+
 /*
  *	This routine will send an RST to the other tcp.
  *
  *	Someone asks: why I NEVER use socket parameters (TOS, TTL etc.)
  *		      for reset.
@@ -659,10 +699,12 @@ EXPORT_SYMBOL(tcp_v4_send_check);
  *	Exception: precedence violation. We do not implement it in any case.
  */
 
 #ifdef CONFIG_TCP_MD5SIG
 #define OPTION_BYTES TCPOLEN_MD5SIG_ALIGNED
+#elif defined(OPTION_BYTES_TCP_AUTHOPT)
+#define OPTION_BYTES TCPOLEN_AUTHOPT_OUTPUT
 #else
 #define OPTION_BYTES sizeof(__be32)
 #endif
 
 static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
@@ -712,12 +754,29 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	memset(&arg, 0, sizeof(arg));
 	arg.iov[0].iov_base = (unsigned char *)&rep;
 	arg.iov[0].iov_len  = sizeof(rep.th);
 
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
 	rcu_read_lock();
+#endif
+#ifdef CONFIG_TCP_AUTHOPT
+	/* Unlike TCP-MD5 the signatures for TCP-AO depend on initial sequence
+	 * numbers so we can only handle established and time-wait sockets.
+	 */
+	if (tcp_authopt_needed && sk &&
+	    sk->sk_state != TCP_NEW_SYN_RECV &&
+	    sk->sk_state != TCP_LISTEN) {
+		int tcp_authopt_ret = tcp_v4_authopt_handle_reply(sk, skb, rep.opt, &rep.th);
+
+		if (tcp_authopt_ret) {
+			arg.iov[0].iov_len += tcp_authopt_ret;
+			goto skip_md5sig;
+		}
+	}
+#endif
+#ifdef CONFIG_TCP_MD5SIG
 	hash_location = tcp_parse_md5sig_option(th);
 	if (sk && sk_fullsock(sk)) {
 		const union tcp_md5_addr *addr;
 		int l3index;
 
@@ -755,11 +814,10 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
 		key = tcp_md5_do_lookup(sk1, l3index, addr, AF_INET);
 		if (!key)
 			goto out;
 
-
 		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
 		if (genhash || memcmp(hash_location, newhash, 16) != 0)
 			goto out;
 
 	}
@@ -775,10 +833,13 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 
 		tcp_v4_md5_hash_hdr((__u8 *) &rep.opt[1],
 				     key, ip_hdr(skb)->saddr,
 				     ip_hdr(skb)->daddr, &rep.th);
 	}
+#endif
+#ifdef CONFIG_TCP_AUTHOPT
+skip_md5sig:
 #endif
 	/* Can't co-exist with TCPMD5, hence check rep.opt[0] */
 	if (rep.opt[0] == 0) {
 		__be32 mrst = mptcp_reset_option(skb);
 
@@ -828,12 +889,14 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	ctl_sk->sk_mark = 0;
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG)
 out:
+#endif
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
 	rcu_read_unlock();
 #endif
 }
 
 /* The code following below sending ACKs in SYN-RECV and TIME-WAIT states
@@ -850,10 +913,12 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	struct {
 		struct tcphdr th;
 		__be32 opt[(TCPOLEN_TSTAMP_ALIGNED >> 2)
 #ifdef CONFIG_TCP_MD5SIG
 			   + (TCPOLEN_MD5SIG_ALIGNED >> 2)
+#elif defined(CONFIG_TCP_AUTHOPT)
+			   + (TCPOLEN_AUTHOPT_OUTPUT >> 2)
 #endif
 			];
 	} rep;
 	struct net *net = sock_net(sk);
 	struct ip_reply_arg arg;
@@ -881,10 +946,23 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	rep.th.seq     = htonl(seq);
 	rep.th.ack_seq = htonl(ack);
 	rep.th.ack     = 1;
 	rep.th.window  = htons(win);
 
+#ifdef CONFIG_TCP_AUTHOPT
+	if (tcp_authopt_needed) {
+		int aoret, offset = (tsecr) ? 3 : 0;
+
+		aoret = tcp_v4_authopt_handle_reply(sk, skb, &rep.opt[offset], &rep.th);
+		if (aoret) {
+			arg.iov[0].iov_len += aoret;
+#ifdef CONFIG_TCP_MD5SIG
+			key = NULL;
+#endif
+		}
+	}
+#endif
 #ifdef CONFIG_TCP_MD5SIG
 	if (key) {
 		int offset = (tsecr) ? 3 : 0;
 
 		rep.opt[offset++] = htonl((TCPOPT_NOP << 24) |
-- 
2.25.1

