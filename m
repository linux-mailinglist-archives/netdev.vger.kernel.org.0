Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2094518FC95
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgCWSWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:22:02 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:33571 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbgCWSWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:22:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1584987720; x=1616523720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=dTUXlBoaxIAuJgjtQvyBD9pejs66JFIyDVKbuPwLcqE=;
  b=a/haRMjLQ9atRxAz3QToTtZKo/Uyfh8UF3eRjPxPDmF8xSWIGC35QRHV
   4HDKUq6kWf3huTaTnAcd98YUbeaEvSTkLLuTFd+gvjQnX/gZjjoD+9JmP
   BZb6HujTD/hS4cOxH6vJlO22JBuNn32Z+1d2ezmmv1irnqgmkjzy0K/Tr
   s=;
IronPort-SDR: Zxnhtq1BBTlFOVRjtANYMngFU6HjTEGzO3AFBO+6WGiR2R9RAYU6D6mg8BNzojY8LUzcKJA79E
 L0MizBsbxawA==
X-IronPort-AV: E=Sophos;i="5.72,297,1580774400"; 
   d="scan'208";a="22553398"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 23 Mar 2020 18:18:35 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id D9518A1FD4;
        Mon, 23 Mar 2020 18:18:34 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 23 Mar 2020 18:18:34 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.101) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 23 Mar 2020 18:18:30 +0000
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
Subject: [PATCH net-next 2/2] tcp/dccp: Remove unnecessary initialization of refcounted.
Date:   Tue, 24 Mar 2020 03:18:14 +0900
Message-ID: <20200323181814.87661-3-kuniyu@amazon.co.jp>
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

When we get a TCP_NEW_SYN_RECV/DCCP_NEW_SYN_RECV socket by
__inet_lookup_skb(), refcounted is already set true, so it is not
necessary to do it again.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/dccp/ipv4.c     | 1 -
 net/dccp/ipv6.c     | 1 -
 net/ipv4/tcp_ipv4.c | 1 -
 net/ipv6/tcp_ipv6.c | 1 -
 4 files changed, 4 deletions(-)

diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index d19557c6d04b..c63b6bd68284 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -838,7 +838,6 @@ static int dccp_v4_rcv(struct sk_buff *skb)
 			goto lookup;
 		}
 		sock_hold(sk);
-		refcounted = true;
 		nsk = dccp_check_req(sk, skb, req);
 		if (!nsk) {
 			reqsk_put(req);
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 1e5e08cc0bfc..b3ca9b1ef32a 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -740,7 +740,6 @@ static int dccp_v6_rcv(struct sk_buff *skb)
 			goto lookup;
 		}
 		sock_hold(sk);
-		refcounted = true;
 		nsk = dccp_check_req(sk, skb, req);
 		if (!nsk) {
 			reqsk_put(req);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index df1166b76126..b59a89d8fa69 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1931,7 +1931,6 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		 * as we might lose it too soon.
 		 */
 		sock_hold(sk);
-		refcounted = true;
 		nsk = NULL;
 		if (!tcp_filter(sk, skb)) {
 			th = (const struct tcphdr *)skb->data;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index eaf09e6b7844..3a587c40ca52 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1603,7 +1603,6 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			goto lookup;
 		}
 		sock_hold(sk);
-		refcounted = true;
 		nsk = NULL;
 		if (!tcp_filter(sk, skb)) {
 			th = (const struct tcphdr *)skb->data;
-- 
2.17.2 (Apple Git-113)

