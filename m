Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3C818FC87
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbgCWSSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:18:33 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:29921 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbgCWSSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:18:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1584987513; x=1616523513;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=FzND84nNPkZzBPzL4bmCTlt7J7T1/lLAxyCupWjSGuY=;
  b=hM9y6DI9a5EnSwXKJ3QDDi2M5jXUItJ/JjAm8dAbOn68jlSI0xiaxLEC
   2cvF4W2R2f6VmI6xEHzFqlndxMpz4lPEEPyRNskTCXwP+APQWUlVYGRlH
   /hDSk5RaTpuemjv6Xy0yJ+bqmxnNT/ZlfZ947OrEwVA5qAcSQN3Uz31fm
   4=;
IronPort-SDR: Jnr22CbLPzClYWh3Z0xh1ZhrDDDMYHPw2tDi6IURHPsr60vWgOIdCuHVRcjW/e3YEVgm/jCchk
 5iqZxfrhBZLQ==
X-IronPort-AV: E=Sophos;i="5.72,297,1580774400"; 
   d="scan'208";a="32971668"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 23 Mar 2020 18:18:32 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 4887CA22A4;
        Mon, 23 Mar 2020 18:18:31 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 23 Mar 2020 18:18:30 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.101) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 23 Mar 2020 18:18:25 +0000
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
Subject: [PATCH net-next 1/2] tcp/dccp: Move initialisation of refcounted into if block.
Date:   Tue, 24 Mar 2020 03:18:13 +0900
Message-ID: <20200323181814.87661-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200323181814.87661-1-kuniyu@amazon.co.jp>
References: <20200323181814.87661-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.101]
X-ClientProxiedBy: EX13D03UWA003.ant.amazon.com (10.43.160.39) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The refcounted is initialised at most three times.

  - __inet_lookup_skb() sets it true.
  - skb_steal_sock() is false and __inet_lookup() sets it true.
  - __inet_lookup_established() is false and __inet_lookup() sets it false.

We do not need to initialise refcounted again and again, so we should do
it just before return.

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

