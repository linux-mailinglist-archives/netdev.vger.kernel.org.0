Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBEE4195006
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 05:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgC0E0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 00:26:04 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35113 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgC0E0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 00:26:03 -0400
Received: by mail-pg1-f195.google.com with SMTP id k5so1788452pga.2;
        Thu, 26 Mar 2020 21:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hE7UlM3ZtEnNpeciPaaHTgLJRlCO3pbOUpwcsVBcWZ8=;
        b=t2G2V4r7HffD+c4ILowSI7JAOui6fyu/ae/UuasROnB+k27wJfhMzT5226WTjVVOpl
         jzNJEBl41+S8e64a4Sl1d3tvnPuTM88ClM0nGRuZGBGTEVwqZEZM43oroDB2OiC5Yw+b
         7HTtNTychVjoICmMuKnXRPjjBwn2xyIcPoEBW2N/bIZ8fTlJIHtzJ+zARgLw/whTKzyv
         P+Hojkg2MUxTfDm1obZBNcZuMKDOvCxkzn54NmnHP42w1vI/yWXrGZxIjMCqKdKiAvf8
         xj4WmpNqrjscUZYpF+RlRjWYdGi9w/Dgzs2N5Um+x+u9Zbq+TXwyOW39ExDcKeFnaJoB
         j9cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=hE7UlM3ZtEnNpeciPaaHTgLJRlCO3pbOUpwcsVBcWZ8=;
        b=Z1cS3LizYPaqCp6lU/l2gJULmnaQlq9EYXX28b6OLmISbt3BU7RV5WrgEVzZgIG9FO
         9Cyg0FZuPlot4rNpXEskKMsl27DLK21ARy3dJZ3dkuY8dwVbZfpTEdsiUBRikFvxBxzW
         ErwmbnSl7SmmfyWNWWOvQZGBP87KzVW+i74F6LGfRtexs6fwvHypSj3zB/tBc+mpLAU9
         xlyqv56vZBmd0lsCkkNGR+WQ1t4AAgns1zwOCcAHR8ZvFRok+FObIjp9P/HZWMsBDrHt
         iXgUujlSUXrVeCKsHs15leR1jTLzUNH1NIhI+6j3TdIl2HgEZBdSEo1IBrjU9BF8Vtat
         U3yQ==
X-Gm-Message-State: ANhLgQ2im4zQG2T8TsUCo6b85PWdEpy4aYunG837r/Kl2K/qXeHRquLt
        FPHP5KKtesWYRi0H6rpUvv2Mf4iy
X-Google-Smtp-Source: ADFU+vvxq0zeJRbduAB1srsyLn7O5JlGNW/Gqh8DQScr6Mi7gcP7pnQ7/9H0te68rgs33o777HEy8g==
X-Received: by 2002:a63:8b42:: with SMTP id j63mr11503672pge.27.1585283161593;
        Thu, 26 Mar 2020 21:26:01 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id y17sm3004647pfl.104.2020.03.26.21.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 21:26:00 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv3 bpf-next 2/5] net: Track socket refcounts in skb_steal_sock()
Date:   Thu, 26 Mar 2020 21:25:53 -0700
Message-Id: <20200327042556.11560-3-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200327042556.11560-1-joe@wand.net.nz>
References: <20200327042556.11560-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the UDP/TCP handlers slightly to allow skb_steal_sock() to make
the determination of whether the socket is reference counted in the case
where it is prefetched by earlier logic such as early_demux or
dst_sk_prefetch.

Signed-off-by: Joe Stringer <joe@wand.net.nz>
---
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

