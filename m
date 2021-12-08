Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5274F46CCE5
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhLHFUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:20:22 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:31605 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhLHFUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:20:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1638940611; x=1670476611;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fgYh5Rcic8LqrRXjEU3MI687TXbX3sUbjqjwBRlIhaw=;
  b=eeu/rbPEo1Bzpz0LWJRpYsP1+oX77lCQyGr7jctHbAV77KHHqkds+tFT
   vJvou82XR5ZoDSeNUxlJL4BRL6f7aAUDh70xpm4Zmt/WI5jPQYRv2vzyw
   t4z+YelFgmWRyEaaY6Bz8BvxAZBIdF0pR//wCVEeE0ZvJWERoJBjrd1qA
   o=;
X-IronPort-AV: E=Sophos;i="5.87,296,1631577600"; 
   d="scan'208";a="46958598"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 08 Dec 2021 05:16:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com (Postfix) with ESMTPS id 46F92C0905;
        Wed,  8 Dec 2021 05:16:47 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 8 Dec 2021 05:16:47 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.97) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 8 Dec 2021 05:16:43 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net] tcp: Remove sock_owned_by_user() test in tcp_child_process().
Date:   Wed, 8 Dec 2021 14:16:33 +0900
Message-ID: <20211208051633.49122-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.97]
X-ClientProxiedBy: EX13D21UWA001.ant.amazon.com (10.43.160.154) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While creating a child socket, before v2.3.41, we used to call
bh_lock_sock() later than now; it was called just before
tcp_rcv_state_process().  The full socket was put into an accept queue
and exposed to other CPUs before bh_lock_sock() so that process context
might have acquired the lock by then.  Thus, we had to check if any
process context was accessing the socket before tcp_rcv_state_process().

We can see this code in tcp_v4_do_rcv() of v2.3.14. [0]

	if (sk->state == TCP_LISTEN) {
		struct sock *nsk;

		nsk = tcp_v4_hnd_req(sk, skb);
		...
		if (nsk != sk) {
			bh_lock_sock(nsk);
			if (nsk->lock.users != 0) {
				...
				sk_add_backlog(nsk, skb);
				bh_unlock_sock(nsk);
				return 0;
			}
			...
		}
	}

	if (tcp_rcv_state_process(sk, skb, skb->h.th, skb->len))
		goto reset;

However, in 2.3.15, this lock.users test was replaced with BUG_TRAP() by
mistake. [1]

		if (nsk != sk) {
			...
			BUG_TRAP(nsk->lock.users == 0);
			...
			ret = tcp_rcv_state_process(nsk, skb, skb->h.th, skb->len);
			...
			bh_unlock_sock(nsk);
			...
			return 0;
		}

Fortunately, the test was back in 2.3.41. [2]  Then, related code was
packed into tcp_child_process() with comments, which remains until now.

What is interesting in v2.3.41 is that the bh_lock_sock() was moved to
tcp_create_openreq_child() and placed just after sock_lock_init().
Thus, the lock is never acquired until tcp_rcv_state_process() by process
contexts.  The bh_lock_sock() is now in sk_clone_lock() and the rule does
not change.

As of now, alas, it is not possible to reach the commented path by the
change.  Let's remove the remnant of the old days.

[0]: https://cdn.kernel.org/pub/linux/kernel/v2.3/linux-2.3.14.tar.gz
[1]: https://cdn.kernel.org/pub/linux/kernel/v2.3/patch-2.3.15.gz
[2]: https://cdn.kernel.org/pub/linux/kernel/v2.3/patch-2.3.41.gz

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/ipv4/tcp_minisocks.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 7c2d3ac2363a..b4a1f8728093 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -833,18 +833,12 @@ int tcp_child_process(struct sock *parent, struct sock *child,
 	sk_mark_napi_id_set(child, skb);
 
 	tcp_segs_in(tcp_sk(child), skb);
-	if (!sock_owned_by_user(child)) {
-		ret = tcp_rcv_state_process(child, skb);
-		/* Wakeup parent, send SIGIO */
-		if (state == TCP_SYN_RECV && child->sk_state != state)
-			parent->sk_data_ready(parent);
-	} else {
-		/* Alas, it is possible again, because we do lookup
-		 * in main socket hash table and lock on listening
-		 * socket does not protect us more.
-		 */
-		__sk_add_backlog(child, skb);
-	}
+
+	ret = tcp_rcv_state_process(child, skb);
+
+	/* Wakeup parent, send SIGIO */
+	if (state == TCP_SYN_RECV && child->sk_state != state)
+		parent->sk_data_ready(parent);
 
 	bh_unlock_sock(child);
 	sock_put(child);
-- 
2.30.2

