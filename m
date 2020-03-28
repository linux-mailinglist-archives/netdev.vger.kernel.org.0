Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9C41968BE
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 19:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgC1SzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 14:55:23 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41065 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgC1SzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 14:55:21 -0400
Received: by mail-pl1-f196.google.com with SMTP id d24so1046771pll.8;
        Sat, 28 Mar 2020 11:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AXwEK4/+KEcLToq3y6f3bgpsRtBTc8LMEI6YEpgoXLI=;
        b=JJkaF5g1Neec6tTiRYebxMW5p8aq/fZ/c/j1/hHCwjf2gHoOvN8V+i8FGJ7QPtqh3n
         LkNIKrYZqkJpTmkq/U3euGleWsQh+K5vDs0yWWxpT73gxH6JUF5qQ4WNRWH1s7ebsn9m
         qJ70xw9Ftxv2wDYvC0/kn5VfmAdtWknBesiwThbxlUevNpydYUiQn8lAxq5Gw3zhdYOf
         GqM5SEeH7vvAK1rWLC1mIgekudkiLWekNKlDqZ7norvmUWWHueUd2uhY9zaPEEAgjecC
         jm1/S5/xkN+XlLaEN7nOLeOGYBSReZnEMPcb+r/xQVkrI4uleYEByazt58BlrVwzLrn+
         kUIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=AXwEK4/+KEcLToq3y6f3bgpsRtBTc8LMEI6YEpgoXLI=;
        b=FrBLhnPOU9hL9/SpWYi/8cdbMkjQ9gKUX3+GljyhdWRzCOifF3E5Vi2XI/X6vaNcsb
         XGrXKH8200a9tnDapUIvXkJ8um7Oqi67vN9BaJ39NepQIZ0n6AOfjpjRvgj1m3FfH820
         ystTfUOz69vALq56QkgyQ7Z0yg+uVZwJ1Pv6eyPJgp825aikRGOuZU27HHMzm96jGQ4Q
         554fOcXiqomFIbpCBdKHEmWHmKcfBNDOyw968lmcEb2L7SnVs8p3sjF645xEYZfV/x51
         OHj17lN3GL8z9ZY1wCurMlwUXDlFzV6wLyT8zQLNM8MubwwKNeC8PPHwROvrxS/4GINd
         hsUw==
X-Gm-Message-State: ANhLgQ0aWKqvU7gFDg0gO4nA6BmbatB9KjuYj4trYOd3L2cq7VS/ytCQ
        HaP7vg+G/4jqWs72FC50sAdqX9Cm
X-Google-Smtp-Source: ADFU+vtu1BJ15Y5kfVFgMh12YAhK0r6CPRGrF8Wq8gx2RV6YhhBuykT7bxsj9fThJ5Dz/QYltr/Maw==
X-Received: by 2002:a17:90a:c482:: with SMTP id j2mr6435352pjt.71.1585421718843;
        Sat, 28 Mar 2020 11:55:18 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id d7sm6682022pfo.86.2020.03.28.11.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 11:55:18 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv4 bpf-next 2/5] net: Track socket refcounts in skb_steal_sock()
Date:   Sat, 28 Mar 2020 11:55:05 -0700
Message-Id: <20200328185509.20892-3-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200328185509.20892-1-joe@wand.net.nz>
References: <20200328185509.20892-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the UDP/TCP handlers slightly to allow skb_steal_sock() to make
the determination of whether the socket is reference counted in the case
where it is prefetched by earlier logic such as early_demux.

Signed-off-by: Joe Stringer <joe@wand.net.nz>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
v4: Commit message update
v3: No changes
v2: Initial version
---
 include/net/inet6_hashtables.h |  3 +--
 include/net/inet_hashtables.h  |  3 +--
 include/net/sock.h             | 10 +++++++++-
 net/ipv4/udp.c                 |  6 ++++--
 net/ipv6/udp.c                 |  9 ++++++---
 5 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index fe96bf247aac..81b965953036 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -85,9 +85,8 @@ static inline struct sock *__inet6_lookup_skb(struct inet_hashinfo *hashinfo,
 					      int iif, int sdif,
 					      bool *refcounted)
 {
-	struct sock *sk = skb_steal_sock(skb);
+	struct sock *sk = skb_steal_sock(skb, refcounted);
 
-	*refcounted = true;
 	if (sk)
 		return sk;
 
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index d0019d3395cf..ad64ba6a057f 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -379,10 +379,9 @@ static inline struct sock *__inet_lookup_skb(struct inet_hashinfo *hashinfo,
 					     const int sdif,
 					     bool *refcounted)
 {
-	struct sock *sk = skb_steal_sock(skb);
+	struct sock *sk = skb_steal_sock(skb, refcounted);
 	const struct iphdr *iph = ip_hdr(skb);
 
-	*refcounted = true;
 	if (sk)
 		return sk;
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 2613d21a667a..1ca2e808cb8e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2533,15 +2533,23 @@ skb_sk_is_prefetched(struct sk_buff *skb)
 	return skb->destructor == sock_pfree;
 }
 
-static inline struct sock *skb_steal_sock(struct sk_buff *skb)
+/**
+ * skb_steal_sock
+ * @skb to steal the socket from
+ * @refcounted is set to true if the socket is reference-counted
+ */
+static inline struct sock *
+skb_steal_sock(struct sk_buff *skb, bool *refcounted)
 {
 	if (skb->sk) {
 		struct sock *sk = skb->sk;
 
+		*refcounted = true;
 		skb->destructor = NULL;
 		skb->sk = NULL;
 		return sk;
 	}
+	*refcounted = false;
 	return NULL;
 }
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2633fc231593..b4035021bbd3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2288,6 +2288,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	struct rtable *rt = skb_rtable(skb);
 	__be32 saddr, daddr;
 	struct net *net = dev_net(skb->dev);
+	bool refcounted;
 
 	/*
 	 *  Validate the packet.
@@ -2313,7 +2314,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	if (udp4_csum_init(skb, uh, proto))
 		goto csum_error;
 
-	sk = skb_steal_sock(skb);
+	sk = skb_steal_sock(skb, &refcounted);
 	if (sk) {
 		struct dst_entry *dst = skb_dst(skb);
 		int ret;
@@ -2322,7 +2323,8 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 			udp_sk_rx_dst_set(sk, dst);
 
 		ret = udp_unicast_rcv_skb(sk, skb, uh);
-		sock_put(sk);
+		if (refcounted)
+			sock_put(sk);
 		return ret;
 	}
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 5dc439a391fe..7d4151747340 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -843,6 +843,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	struct net *net = dev_net(skb->dev);
 	struct udphdr *uh;
 	struct sock *sk;
+	bool refcounted;
 	u32 ulen = 0;
 
 	if (!pskb_may_pull(skb, sizeof(struct udphdr)))
@@ -879,7 +880,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 		goto csum_error;
 
 	/* Check if the socket is already available, e.g. due to early demux */
-	sk = skb_steal_sock(skb);
+	sk = skb_steal_sock(skb, &refcounted);
 	if (sk) {
 		struct dst_entry *dst = skb_dst(skb);
 		int ret;
@@ -888,12 +889,14 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 			udp6_sk_rx_dst_set(sk, dst);
 
 		if (!uh->check && !udp_sk(sk)->no_check6_rx) {
-			sock_put(sk);
+			if (refcounted)
+				sock_put(sk);
 			goto report_csum_error;
 		}
 
 		ret = udp6_unicast_rcv_skb(sk, skb, uh);
-		sock_put(sk);
+		if (refcounted)
+			sock_put(sk);
 		return ret;
 	}
 
-- 
2.20.1

