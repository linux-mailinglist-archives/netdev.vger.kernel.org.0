Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7043D1920D5
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 06:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgCYF6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 01:58:04 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38240 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgCYF6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 01:58:03 -0400
Received: by mail-pj1-f67.google.com with SMTP id m15so567686pje.3;
        Tue, 24 Mar 2020 22:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5okIGh2vwOTEA3JNBGE+wuo//bGh6mzInA8cwTSERzo=;
        b=s6ixoIzDpq3jfw5wArEmR70TflLWvxMSvHJ6Kv1f7wkEGwqzrp/NB/P6AbOgbBT4Py
         GuEBKScNQTkEl49gIkmoZiESl+H5GxOT8sTYNHP2aMf2j2enb4zEplpkj5NNwwU0NPSH
         OeI7eeQuTfPt4VE4lU87iqQCl/5InNn0KUKdIfzjLhDLrXOCKzp0pPdf64JbFESfWTqr
         0rbm+Xo4No3ALFYcBD56Nz5zO1Gp4VV2R7H0XpcVTla6wQ8TsJB8jP6c+yw2jbWxHeJW
         /QdwIgVubTaN/fphlZRGl+tYMgIvj6wAHwRiZh4thK14qyPkf7QzIu5cLAGe8aJ4dFLa
         IjRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=5okIGh2vwOTEA3JNBGE+wuo//bGh6mzInA8cwTSERzo=;
        b=iDcNCIFYf+1TkWRDuf9YjbN3mF0ggPjZ7xfJGAfx/JBdJ8DR+nK6BrSIGAh7yFZIia
         +wdb52PlFH12SaIosjVZ/i6JgQdBNgCSI4o2HO8ndC+Jl0rNPdLtXq4sjs+zm6a9gEx6
         Vc11lxqAqDaYDx6wWkdWlkTW1cebTEFSXD8sBKCBtkMqjnL5UylkHtBejlPpiYJ2XK8q
         sATCGNC4Fs95gTnk6JxZsSNPtTT82icaMqx5yG+rWuFpxiwHmdYAb1SBFEJobd4cKexQ
         jY2RABdi7QFbRvto4oPzwZehha/4N3M26Pb8LE1tKXSohrDV42lDtatHLD5apUQu10oX
         /tXQ==
X-Gm-Message-State: ANhLgQ01QBUYCDOGRnZDj5fozLqrtOK99R408USADp/mSo2ptVp2Uzc/
        6FxJtYsQKU5lfNjeWb595A2GjGAP
X-Google-Smtp-Source: ADFU+vugpyTJjkUgDaw75Tc2R9ggrSI3SEIxea//9nJ4DlGWFxJUs2hzvCtgTTSi7ioboJwF735e5A==
X-Received: by 2002:a17:902:a9c5:: with SMTP id b5mr1720550plr.126.1585115880828;
        Tue, 24 Mar 2020 22:58:00 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id e10sm17605716pfm.121.2020.03.24.22.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 22:58:00 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv2 bpf-next 3/5] net: Track socket refcounts in skb_steal_sock()
Date:   Tue, 24 Mar 2020 22:57:43 -0700
Message-Id: <20200325055745.10710-4-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200325055745.10710-1-joe@wand.net.nz>
References: <20200325055745.10710-1-joe@wand.net.nz>
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

