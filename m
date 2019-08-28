Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568529FB86
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfH1HXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:23:12 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33355 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfH1HXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 03:23:11 -0400
Received: by mail-lj1-f195.google.com with SMTP id z17so1636489ljz.0
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 00:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dOjmOoluf3gBhq8eXlD9r/R6bKdILCYGeFhsMtNw2Bg=;
        b=drPLXTz/iUa3KrW0woM6DgA1FNTMXghWMAgZ/d1hRLAhtim8Tqxij8+YlUrnTti9Q6
         XYfqoyhRr44AmkTHDWRPOLDSAr6Ac2Ll1AVby4+cuGTHsmlA51wZ4eWTz2lbOhH5aep+
         zrPc2HDnJTTo5QmT9BuDypfBJjHuns02syetU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dOjmOoluf3gBhq8eXlD9r/R6bKdILCYGeFhsMtNw2Bg=;
        b=hue99cEkQYXfcrNuZeiAJBwrb11S96GIlvN5+jMVSBG+hW3kzPa7SUiLkBkLDyQUhR
         wpNWSDd5VU3ZeHmJv6yvPMuH25qpk42l14sRA+9uzpOsNoKsqSsIwz33Ngy0ZUWrQC0x
         JhJfcBvF0vd1twmrIe6WNGYTBPRaswuUB0f/Ysrm5yd7UiCsSUMEMUURgddIgWBuOMQy
         XmaSO2BUlXsfhFMSdPb1Z4wXgLZS/9vnwcaUbQhySWljasPXrBRC5P1eXyPaKS20h4V1
         2f6G3LKyFzRTPfKntvZH/v7t9ptrOcwDicPAE5G6Z5bhDplnxkgPM3979uad8deVqjGX
         43XA==
X-Gm-Message-State: APjAAAWNePFAC2CJTvYC7lXItZwrPIg5KKPznY582y9LnzKYUOxJdsE5
        pXcmFvb0iW9ovs48BE2ybuKD3Q==
X-Google-Smtp-Source: APXvYqy/051ovGZpvNRH2c/q6cFO4hCR/+K3XMh/dqaiEIodzAbMuxW+CIdS0I8dfWDIR8SpD2Tl1A==
X-Received: by 2002:a2e:9417:: with SMTP id i23mr1210580ljh.12.1566976989273;
        Wed, 28 Aug 2019 00:23:09 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 141sm414630ljf.32.2019.08.28.00.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:23:08 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [RFCv2 bpf-next 09/12] udp6: Run inet_lookup bpf program on socket lookup
Date:   Wed, 28 Aug 2019 09:22:47 +0200
Message-Id: <20190828072250.29828-10-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190828072250.29828-1-jakub@cloudflare.com>
References: <20190828072250.29828-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Same as for udp, split the socket lookup into two phases and let the BPF
inet_lookup program select the receiving socket.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv6/udp.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 16ef2303bd8d..7380cf57e88c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -101,7 +101,7 @@ void udp_v6_rehash(struct sock *sk)
 static int compute_score(struct sock *sk, struct net *net,
 			 const struct in6_addr *saddr, __be16 sport,
 			 const struct in6_addr *daddr, unsigned short hnum,
-			 int dif, int sdif)
+			 int dif, int sdif, unsigned char state)
 {
 	int score;
 	struct inet_sock *inet;
@@ -112,6 +112,9 @@ static int compute_score(struct sock *sk, struct net *net,
 	    sk->sk_family != PF_INET6)
 		return -1;
 
+	if (state && sk->sk_state != state)
+		return -1;
+
 	if (!ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
 		return -1;
 
@@ -146,7 +149,7 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 		const struct in6_addr *saddr, __be16 sport,
 		const struct in6_addr *daddr, unsigned int hnum,
 		int dif, int sdif, struct udp_hslot *hslot2,
-		struct sk_buff *skb)
+		struct sk_buff *skb, unsigned char state)
 {
 	struct sock *sk, *result;
 	int score, badness;
@@ -156,7 +159,7 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 	badness = -1;
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
 		score = compute_score(sk, net, saddr, sport,
-				      daddr, hnum, dif, sdif);
+				      daddr, hnum, dif, sdif, state);
 		if (score > badness) {
 			if (sk->sk_reuseport) {
 				hash = udp6_ehashfn(net, daddr, hnum,
@@ -190,19 +193,34 @@ struct sock *__udp6_lib_lookup(struct net *net,
 	slot2 = hash2 & udptable->mask;
 	hslot2 = &udptable->hash2[slot2];
 
+	/* Lookup connected sockets */
 	result = udp6_lib_lookup2(net, saddr, sport,
 				  daddr, hnum, dif, sdif,
-				  hslot2, skb);
-	if (!result) {
-		hash2 = ipv6_portaddr_hash(net, &in6addr_any, hnum);
-		slot2 = hash2 & udptable->mask;
+				  hslot2, skb, TCP_ESTABLISHED);
+	if (result)
+		goto done;
 
-		hslot2 = &udptable->hash2[slot2];
+	/* Lookup redirect from BPF */
+	result = inet6_lookup_run_bpf(net, udptable->protocol,
+				      saddr, sport, daddr, hnum);
+	if (result)
+		goto done;
 
-		result = udp6_lib_lookup2(net, saddr, sport,
-					  &in6addr_any, hnum, dif, sdif,
-					  hslot2, skb);
-	}
+	/* Lookup bound sockets */
+	result = udp6_lib_lookup2(net, saddr, sport,
+				  daddr, hnum, dif, sdif,
+				  hslot2, skb, 0);
+	if (result)
+		goto done;
+
+	hash2 = ipv6_portaddr_hash(net, &in6addr_any, hnum);
+	slot2 = hash2 & udptable->mask;
+	hslot2 = &udptable->hash2[slot2];
+
+	result = udp6_lib_lookup2(net, saddr, sport,
+				  &in6addr_any, hnum, dif, sdif,
+				  hslot2, skb, 0);
+done:
 	if (IS_ERR(result))
 		return NULL;
 	return result;
-- 
2.20.1

