Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E0D2F99A1
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 07:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbhARGBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 01:01:34 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:10993 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731944AbhARGAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 01:00:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1610949631; x=1642485631;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=ICr6OFk3wrAZC74Io67N6wL+Jy9kHRSLW2QyfIYX3og=;
  b=jJDNpD6nCB56mU+hCFx+XrbX1H4DEc4e6DDMxkOtmI79jxP/Zg6GCkHe
   vr449ukaP5jFvV+2EH5kVlI50/w5uAA2IDdikcnn4FNSHXmx9Nnnhieh0
   15/IHQ0ldUwps5p6QIwIQlTGv2CF1VFR+yXTKsf4DmmD55FpA9vCJtTwf
   s=;
X-IronPort-AV: E=Sophos;i="5.79,355,1602547200"; 
   d="scan'208";a="111557182"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-e69428c4.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 18 Jan 2021 05:59:47 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-e69428c4.us-east-1.amazon.com (Postfix) with ESMTPS id AE6F6C2028;
        Mon, 18 Jan 2021 05:59:44 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 18 Jan 2021 05:59:43 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.203) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 18 Jan 2021 05:59:39 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Kuniyuki Iwashima" <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Ricardo Dias <rdias@singlestore.com>
Subject: [PATCH net] tcp: Fix potential use-after-free due to double kfree().
Date:   Mon, 18 Jan 2021 14:59:20 +0900
Message-ID: <20210118055920.82516-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.203]
X-ClientProxiedBy: EX13D41UWB003.ant.amazon.com (10.43.161.243) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Receiving ACK with a valid SYN cookie, cookie_v4_check() allocates struct
request_sock and then can allocate inet_rsk(req)->ireq_opt. After that,
tcp_v4_syn_recv_sock() allocates struct sock and copies ireq_opt to
inet_sk(sk)->inet_opt. Normally, tcp_v4_syn_recv_sock() inserts the full
socket into ehash and sets NULL to ireq_opt. Otherwise,
tcp_v4_syn_recv_sock() has to reset inet_opt by NULL and free the full
socket.

The commit 01770a1661657 ("tcp: fix race condition when creating child
sockets from syncookies") added a new path, in which more than one cores
create full sockets for the same SYN cookie. Currently, the core which
loses the race frees the full socket without resetting inet_opt, resulting
in that both sock_put() and reqsk_put() call kfree() for the same memory:

  sock_put
    sk_free
      __sk_free
        sk_destruct
          __sk_destruct
            sk->sk_destruct/inet_sock_destruct
              kfree(rcu_dereference_protected(inet->inet_opt, 1));

  reqsk_put
    reqsk_free
      __reqsk_free
        req->rsk_ops->destructor/tcp_v4_reqsk_destructor
          kfree(rcu_dereference_protected(inet_rsk(req)->ireq_opt, 1));

Calling kmalloc() between the double kfree() can lead to use-after-free, so
this patch fixes it by setting NULL to inet_opt before sock_put().

As a side note, this kind of issue does not happen for IPv6. This is
because tcp_v6_syn_recv_sock() clones both ipv6_opt and pktopts which
correspond to ireq_opt in IPv4.

Fixes: 01770a166165 ("tcp: fix race condition when creating child sockets from syncookies")
CC: Ricardo Dias <rdias@singlestore.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
---
 net/ipv4/tcp_ipv4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 58207c7769d0..87eb614dab27 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1595,6 +1595,8 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 		tcp_move_syn(newtp, req);
 		ireq->ireq_opt = NULL;
 	} else {
+		newinet->inet_opt = NULL;
+
 		if (!req_unhash && found_dup_sk) {
 			/* This code path should only be executed in the
 			 * syncookie case only
@@ -1602,8 +1604,6 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 			bh_unlock_sock(newsk);
 			sock_put(newsk);
 			newsk = NULL;
-		} else {
-			newinet->inet_opt = NULL;
 		}
 	}
 	return newsk;
-- 
2.17.2 (Apple Git-113)

