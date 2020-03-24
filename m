Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E855190C91
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 12:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbgCXLdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 07:33:50 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:23955 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbgCXLdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 07:33:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1585049629; x=1616585629;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=9Ca8dxUm7ddOgL9H0BytUrqBfOqUJSO10FidWuQnzRA=;
  b=R2xyLRHYSJOFYIiZA6wsr46OZn4w3pS4S42AnNwIKg9abj4CRJYfOQE8
   HFmYZDeT9BM1nOEE8BQ7qyvIeaiDAjz8iv6P32jDSzLRmI4Idg/NbQZHF
   J9vtSqfIiVLFFzUrqlAo3JgHnuriklLI8yX5HiNnbDsox7D640KXh9SvM
   I=;
IronPort-SDR: QnF62z297fYXRXx1KIkRqDqrIE2/W//r9kSMn3Fkf7x1LnhXOfy4YhiqlpBd8ZO5TpVbL6kwrF
 BPOOBpSbYzXg==
X-IronPort-AV: E=Sophos;i="5.72,300,1580774400"; 
   d="scan'208";a="33113906"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 24 Mar 2020 11:33:47 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id 39E42A21A0;
        Tue, 24 Mar 2020 11:33:46 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 24 Mar 2020 11:33:45 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.27) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 24 Mar 2020 11:33:41 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>
CC:     <dccp@vger.kernel.org>, <netdev@vger.kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        <osa-contribution-log@amazon.com>
Subject: [PATCH v2 net-next] tcp/dccp: Move initialisation of refcounted into if block.
Date:   Tue, 24 Mar 2020 20:33:31 +0900
Message-ID: <20200324113331.29031-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.27]
X-ClientProxiedBy: EX13D18UWC003.ant.amazon.com (10.43.162.237) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The refcounted seems to be initialised at most three times, but the
complier can optimize that and the refcounted is initialised only at once.

  - __inet_lookup_skb() sets it true.
  - skb_steal_sock() is false and __inet_lookup() sets it true.
  - __inet_lookup_established() is false and __inet_lookup() sets it false.

The code is bit confusing, so this patch makes it more readable so that no
one doubt about the complier optimization.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/inet6_hashtables.h | 11 +++++++----
 include/net/inet_hashtables.h  | 11 +++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index fe96bf247aac..9b6c97100d54 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -70,9 +70,11 @@ static inline struct sock *__inet6_lookup(struct net *net,
 	struct sock *sk = __inet6_lookup_established(net, hashinfo, saddr,
 						     sport, daddr, hnum,
 						     dif, sdif);
-	*refcounted = true;
-	if (sk)
+	if (sk) {
+		*refcounted = true;
 		return sk;
+	}
+
 	*refcounted = false;
 	return inet6_lookup_listener(net, hashinfo, skb, doff, saddr, sport,
 				     daddr, hnum, dif, sdif);
@@ -87,9 +89,10 @@ static inline struct sock *__inet6_lookup_skb(struct inet_hashinfo *hashinfo,
 {
 	struct sock *sk = skb_steal_sock(skb);
 
-	*refcounted = true;
-	if (sk)
+	if (sk) {
+		*refcounted = true;
 		return sk;
+	}
 
 	return __inet6_lookup(dev_net(skb_dst(skb)->dev), hashinfo, skb,
 			      doff, &ipv6_hdr(skb)->saddr, sport,
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index d0019d3395cf..aa859bf8607b 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -345,9 +345,11 @@ static inline struct sock *__inet_lookup(struct net *net,
 
 	sk = __inet_lookup_established(net, hashinfo, saddr, sport,
 				       daddr, hnum, dif, sdif);
-	*refcounted = true;
-	if (sk)
+	if (sk) {
+		*refcounted = true;
 		return sk;
+	}
+
 	*refcounted = false;
 	return __inet_lookup_listener(net, hashinfo, skb, doff, saddr,
 				      sport, daddr, hnum, dif, sdif);
@@ -382,9 +384,10 @@ static inline struct sock *__inet_lookup_skb(struct inet_hashinfo *hashinfo,
 	struct sock *sk = skb_steal_sock(skb);
 	const struct iphdr *iph = ip_hdr(skb);
 
-	*refcounted = true;
-	if (sk)
+	if (sk) {
+		*refcounted = true;
 		return sk;
+	}
 
 	return __inet_lookup(dev_net(skb_dst(skb)->dev), hashinfo, skb,
 			     doff, iph->saddr, sport,
-- 
2.17.2 (Apple Git-113)

