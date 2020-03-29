Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3A421970E8
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 00:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgC2Wxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 18:53:54 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46570 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbgC2Wxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 18:53:53 -0400
Received: by mail-pl1-f194.google.com with SMTP id s23so5957413plq.13;
        Sun, 29 Mar 2020 15:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c+BkXWhjWc53zBoepmwqng8x8EpnMWNubZu4AAkDPys=;
        b=VSsTHskTOm5kjwwGkEyYmhUySN/e4b5NoyDVhNUoyWXZjH11mP1Hy62o/7SLySx3vt
         d4/0ipna1MESck4kL7nmlFFWcrTtOrvGlR/4YlWKmNgMbYj8wFlVQl2QZTiZvrl4o3Nm
         R/VWs9+BRltlsltblBU+rxJH6CYY0USlbeZsF93BUvnyo7uVhKM6zvLeCdt0us7xi1sK
         L0MIOds9we9Yq510zmNsVybz9BY1FmIrGI+NBLEcmpxhRNi5+cYAWvdcXoHtwUWjqsE0
         DfN+yVnDJJmakiZd4ms3/orL58Ts/gWahulLm9aI9pz20w0bzy2cfHdSb6ThWUDuYlO3
         uOPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=c+BkXWhjWc53zBoepmwqng8x8EpnMWNubZu4AAkDPys=;
        b=bdvRZ00qthaQIpN0a/tVuXkAv9P9JNlwPqHU2436cYyTcVLw+CIEhqCvxA88sO0J4E
         +M5zakFCgtqCJn6aOFPXxT60dTf5FjcrQRzZkq5zphyn6KIdEkecxRhBvdp/YOkRQL9G
         4AoIq0Su+aTqyVwBtZFk0sJLY6D9ZiYuvReZSUYiHd87NWLHxaByeanT7PNpu7iiMSB6
         4DOvpqTb6BpsFQrpRLaOgEFPCHmbPmAVcTRvctfYQcehQhhYQhhFuZCYy56jRGgBNKb4
         LMkm4xPTzD3imylJJ07MRXl8QHBqHxVGdwr0QSjMez6cNeGe++hoBomMPICWoIh6rP1s
         yVAw==
X-Gm-Message-State: AGi0PuYcZAG/P7a6NRcPqvOsTLGREcgjhhXfLyGXA0MTVKaPlgK/N790
        dwfFI/LG22dH9I9TmNNrljrgtc5Z
X-Google-Smtp-Source: APiQypJ4wls1dXfuvJic6Fj3aocUpApZSThuGOiziCQLjMIfkNtBHyYYqq6Z6ExUm4ONa9LvE9940Q==
X-Received: by 2002:a17:90a:8c96:: with SMTP id b22mr4272056pjo.25.1585522430935;
        Sun, 29 Mar 2020 15:53:50 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id i187sm8710386pfg.33.2020.03.29.15.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 15:53:50 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv5 bpf-next 2/5] net: Track socket refcounts in skb_steal_sock()
Date:   Sun, 29 Mar 2020 15:53:39 -0700
Message-Id: <20200329225342.16317-3-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200329225342.16317-1-joe@wand.net.nz>
References: <20200329225342.16317-1-joe@wand.net.nz>
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
v5: No change
v4: Commit message update
    Acked
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
index dc398cee7873..f81d528845f6 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2537,15 +2537,23 @@ skb_sk_is_prefetched(struct sk_buff *skb)
 #endif /* CONFIG_INET */
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

