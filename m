Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FE146E044
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhLIBgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:36:40 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:45033 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhLIBgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:36:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1639013587; x=1670549587;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gNEZJiIUE+pA6ZcElCp+uviKrevsUuPZCVHqu+oY2H8=;
  b=qpo/etTF6bDFM0nwg8wwQL0lXXeH4642gaYt8A1ZcJ+2Jthxqi7ZA2qX
   /BcfoqpwhW8YNY/1LzmArhvn3G59jywRGqFy1pm+msWyb4wVp7QEZceLc
   iH7u5+ndCTFLv2rSL/bx4EBtP/jrW6xBdopuTGASNd7Y/BqermTYv4eUU
   0=;
X-IronPort-AV: E=Sophos;i="5.88,190,1635206400"; 
   d="scan'208";a="162260231"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-02ee77e7.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 09 Dec 2021 01:33:06 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-02ee77e7.us-west-2.amazon.com (Postfix) with ESMTPS id 7F51E42344;
        Thu,  9 Dec 2021 01:33:05 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 9 Dec 2021 01:33:04 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.34) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 9 Dec 2021 01:33:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next] tcp: Warn if sock_owned_by_user() is true in tcp_child_process().
Date:   Thu, 9 Dec 2021 10:32:50 +0900
Message-ID: <20211209013250.44347-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D32UWA003.ant.amazon.com (10.43.160.167) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While creating a child socket from ACK (not TCP Fast Open case), before
v2.3.41, we used to call bh_lock_sock() later than now; it was called just
before tcp_rcv_state_process().  The full socket was put into an accept
queue and exposed to other CPUs before bh_lock_sock() so that process
context might have acquired the lock by then.  Thus, we had to check if any
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
not change.  As of now, alas, it is not possible to reach the commented
path by the change.

This patch removes the unreachable path and adds a WARN_ON_ONCE() so that
syzbot can validate if it is dead code or not.  The WARN_ON_ONCE() could
be removed if syzbot is happy for at least one release. [3]

[0]: https://cdn.kernel.org/pub/linux/kernel/v2.3/linux-2.3.14.tar.gz
[1]: https://cdn.kernel.org/pub/linux/kernel/v2.3/patch-2.3.15.gz
[2]: https://cdn.kernel.org/pub/linux/kernel/v2.3/patch-2.3.41.gz
[3]: https://lore.kernel.org/all/CANn89iL+YWbQDCTQU-D1nU4EePv07EyHvMPjFPkpH1ELyzg5MA@mail.gmail.com/

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
I left Fixes: tag as a reference, but if it is unnecessary, please remove
it.

Changelog:
  v2:
    * Add a WARN_ON_ONCE()
    * Clarify TCP Fast Open is not the case

  v1:
  https://lore.kernel.org/all/20211208051633.49122-1-kuniyu@amazon.co.jp/
---
 net/ipv4/tcp_minisocks.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index cf913a66df17..85b1e752da5d 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -833,18 +833,15 @@ int tcp_child_process(struct sock *parent, struct sock *child,
 	sk_mark_napi_id(child, skb);
 
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
+	/* The lock is held in sk_clone_lock() */
+	WARN_ON_ONCE(sock_owned_by_user(child));
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

