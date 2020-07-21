Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19E32278C3
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGUGRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:17:07 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:32977 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgGUGRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 02:17:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1595312227; x=1626848227;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=dPOvzF75Blw11Z02fvCg4wC2SJ4zlF6bd1nLEV9u+w0=;
  b=HzfhqT2g6U+/XANs4VMngHFhEFH2CXJiF/Y6E9flvtV6iHP52BkAJxAD
   AlWQHrfnsyfjKc0ueLBGPmdPOI6nIrhxjAuCuAHRcBPVHqTf7Xqqdoc2t
   iTYLwSJneflD3cSY5ln45f2zGCDGAktyb/0SucaagiPOOZbc8V8BMUmsG
   0=;
IronPort-SDR: GmcTD5UdQ3a1NbjjtaMDpcl3Yr4sUs+6AUgUKcJCcwN9BP/ibxF99eAGFVwcRgAqRGE4AeCgEX
 7RntnJD1d9Mw==
X-IronPort-AV: E=Sophos;i="5.75,377,1589241600"; 
   d="scan'208";a="44557928"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-60ce1996.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Jul 2020 06:17:05 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-60ce1996.us-west-2.amazon.com (Postfix) with ESMTPS id BA77AA76CE;
        Tue, 21 Jul 2020 06:17:03 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 06:17:03 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.161.34) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 06:16:58 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Craig Gallek <kraig@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "Kuniyuki Iwashima" <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <osa-contribution-log@amazon.com>
Subject: [PATCH net 2/2] udp: Improve load balancing for SO_REUSEPORT.
Date:   Tue, 21 Jul 2020 15:15:31 +0900
Message-ID: <20200721061531.94236-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200721061531.94236-1-kuniyu@amazon.co.jp>
References: <20200721061531.94236-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D46UWB001.ant.amazon.com (10.43.161.16) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, SO_REUSEPORT does not work well if connected sockets are in a
UDP reuseport group.

Then reuseport_has_conns() returns true and the result of
reuseport_select_sock() is discarded. Also, unconnected sockets have the
same score, hence only does the first unconnected socket in udp_hslot
always receive all packets sent to unconnected sockets.

So, the result of reuseport_select_sock() should be used for load
balancing.

The noteworthy point is that the unconnected sockets placed after
connected sockets in sock_reuseport.socks will receive more packets than
others because of the algorithm in reuseport_select_sock().

    index | connected | reciprocal_scale | result
    ---------------------------------------------
    0     | no        | 20%              | 40%
    1     | no        | 20%              | 20%
    2     | yes       | 20%              | 0%
    3     | no        | 20%              | 40%
    4     | yes       | 20%              | 0%

If most of the sockets are connected, this can be a problem, but it still
works better than now.

Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
CC: Willem de Bruijn <willemb@google.com>
Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/ipv4/udp.c | 15 +++++++++------
 net/ipv6/udp.c | 15 +++++++++------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1b7ebbcae497..99251d3c70d0 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -416,7 +416,7 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 				     struct udp_hslot *hslot2,
 				     struct sk_buff *skb)
 {
-	struct sock *sk, *result;
+	struct sock *sk, *result, *reuseport_result;
 	int score, badness;
 	u32 hash = 0;
 
@@ -426,17 +426,20 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif);
 		if (score > badness) {
+			reuseport_result = NULL;
+
 			if (sk->sk_reuseport &&
 			    sk->sk_state != TCP_ESTABLISHED) {
 				hash = udp_ehashfn(net, daddr, hnum,
 						   saddr, sport);
-				result = reuseport_select_sock(sk, hash, skb,
-							sizeof(struct udphdr));
-				if (result && !reuseport_has_conns(sk, false))
-					return result;
+				reuseport_result = reuseport_select_sock(sk, hash, skb,
+									 sizeof(struct udphdr));
+				if (reuseport_result && !reuseport_has_conns(sk, false))
+					return reuseport_result;
 			}
+
+			result = reuseport_result ? : sk;
 			badness = score;
-			result = sk;
 		}
 	}
 	return result;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7d4151747340..9503c87ac0b3 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -148,7 +148,7 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 		int dif, int sdif, struct udp_hslot *hslot2,
 		struct sk_buff *skb)
 {
-	struct sock *sk, *result;
+	struct sock *sk, *result, *reuseport_result;
 	int score, badness;
 	u32 hash = 0;
 
@@ -158,17 +158,20 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif);
 		if (score > badness) {
+			reuseport_result = NULL;
+
 			if (sk->sk_reuseport &&
 			    sk->sk_state != TCP_ESTABLISHED) {
 				hash = udp6_ehashfn(net, daddr, hnum,
 						    saddr, sport);
 
-				result = reuseport_select_sock(sk, hash, skb,
-							sizeof(struct udphdr));
-				if (result && !reuseport_has_conns(sk, false))
-					return result;
+				reuseport_result = reuseport_select_sock(sk, hash, skb,
+									 sizeof(struct udphdr));
+				if (reuseport_result && !reuseport_has_conns(sk, false))
+					return reuseport_result;
 			}
-			result = sk;
+
+			result = reuseport_result ? : sk;
 			badness = score;
 		}
 	}
-- 
2.17.2 (Apple Git-113)

