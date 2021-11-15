Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75F64514A5
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348878AbhKOULg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345802AbhKOT3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:24 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B7CC0BC9B3
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:17 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v23so13659988pjr.5
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LTc6Dee33uJ2iM5GtkCRCjbFA1CHZSBcy3vujWmv5u0=;
        b=KTfF3PIDGdoQGXweNs1CBj4XaRpu9S4ADSEdXfzBaljYYitpMtvvoFslOkR65Hy61Q
         QgDoJoiyNSBpiZbjGP/qmjkh+nB7PFIiasyMeqg1V1mjY9lcmfV5gesURwv/Xfx5IIGk
         iLrn0RmQtgj2Fnzi0I6rwkoPOYxEEaw6YyIrB4UPzewQNcyD5ihVHff+XtPLjiu+r7Uy
         S+3aR5iKC12NfQ1crPJ2s7K9nspn2W4dfVz7xpW1e/vTHC/Sp1yfd0f/B9vGNawbWUct
         LDLN84fzjYF3i+8I9x2MxCo7DXmM9VZmJ22hhWnGirXwneJP6ayr7duWequBpx3SQU/W
         iIww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LTc6Dee33uJ2iM5GtkCRCjbFA1CHZSBcy3vujWmv5u0=;
        b=KNC9IYqYuul68S7Taafnru8C3F57sMOHyhHNZfU3zGusfkCgzWjYtVmLa4Rd6/os21
         Mg5A7FmBm7DAgymqNCpdKHb2bgMSZy8w7HDKHP4MIk9fDFFi0nSsRRcPVCn4sQtTrNmV
         EVa39KrYcpG2USpzx8u/EoXS83N9V+HHNKNp7PA3uOHtUXHaTSkSOzpT2lnhN4Wkyj5G
         nTTYPs2fjpGtDTtb5pg0NrR4g1Xuh6KHbfYtK6oI959XzHWKAxojjmXWeZDPQy8dMB03
         hCDABwKsdmFqIIit/KPwHNx9fVJDqZGdBudPWTMBPcBajNvblBJU/CC4ewL8QdB6+UZr
         SkQg==
X-Gm-Message-State: AOAM533HMY6xEg0S24QwnEGyXOjCbb4NSeyI+NGaRyqg6UycFvIPt166
        z91Hb6QB6FbpMSjx6bLCyeYOjJZEMqU=
X-Google-Smtp-Source: ABdhPJxrXDoSXowmwEsh0uWdK4tV3jhxkjqyfEcvZ4+102cy33gdrYOpUR75OQjoILkcAGRJf47MSQ==
X-Received: by 2002:a17:902:74cb:b0:143:6fe9:ca4 with SMTP id f11-20020a17090274cb00b001436fe90ca4mr38689418plt.2.1637002996446;
        Mon, 15 Nov 2021 11:03:16 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:16 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 12/20] tcp: add RETPOLINE mitigation to sk_backlog_rcv
Date:   Mon, 15 Nov 2021 11:02:41 -0800
Message-Id: <20211115190249.3936899-13-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Use INDIRECT_CALL_INET() to avoid an indirect call
when/if CONFIG_RETPOLINE=y

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h  | 8 +++++++-
 net/core/sock.c     | 5 ++++-
 net/ipv6/tcp_ipv6.c | 5 +++--
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index cb97c448472aa5af3055916df844cbe422578190..2d40fe4c7718ee702bf7e5a847ceff6f8f2f5b7d 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1018,12 +1018,18 @@ static inline __must_check int sk_add_backlog(struct sock *sk, struct sk_buff *s
 
 int __sk_backlog_rcv(struct sock *sk, struct sk_buff *skb);
 
+INDIRECT_CALLABLE_DECLARE(int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb));
+INDIRECT_CALLABLE_DECLARE(int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb));
+
 static inline int sk_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	if (sk_memalloc_socks() && skb_pfmemalloc(skb))
 		return __sk_backlog_rcv(sk, skb);
 
-	return sk->sk_backlog_rcv(sk, skb);
+	return INDIRECT_CALL_INET(sk->sk_backlog_rcv,
+				  tcp_v6_do_rcv,
+				  tcp_v4_do_rcv,
+				  sk, skb);
 }
 
 static inline void sk_incoming_cpu_update(struct sock *sk)
diff --git a/net/core/sock.c b/net/core/sock.c
index 99738e14224c44e5aa4b88857620fb162e9c265f..c57d9883f62c75f522b7f6bc68451aaf8429dc83 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -327,7 +327,10 @@ int __sk_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 	BUG_ON(!sock_flag(sk, SOCK_MEMALLOC));
 
 	noreclaim_flag = memalloc_noreclaim_save();
-	ret = sk->sk_backlog_rcv(sk, skb);
+	ret = INDIRECT_CALL_INET(sk->sk_backlog_rcv,
+				 tcp_v6_do_rcv,
+				 tcp_v4_do_rcv,
+				 sk, skb);
 	memalloc_noreclaim_restore(noreclaim_flag);
 
 	return ret;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 1f1a89f096de9f77ab1bd2d871eb90a3f12e91e0..f41f14b701233dd2d0f5ad464a623a5ba9774763 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -72,7 +72,7 @@ static void	tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb);
 static void	tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 				      struct request_sock *req);
 
-static int	tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb);
+INDIRECT_CALLABLE_SCOPE int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb);
 
 static const struct inet_connection_sock_af_ops ipv6_mapped;
 const struct inet_connection_sock_af_ops ipv6_specific;
@@ -1466,7 +1466,8 @@ INDIRECT_CALLABLE_DECLARE(struct dst_entry *ipv4_dst_check(struct dst_entry *,
  * This is because we cannot sleep with the original spinlock
  * held.
  */
-static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
+INDIRECT_CALLABLE_SCOPE
+int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct sk_buff *opt_skb = NULL;
-- 
2.34.0.rc1.387.gb447b232ab-goog

