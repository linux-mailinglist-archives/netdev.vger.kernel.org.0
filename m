Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057F245B1FD
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240716AbhKXCVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:21:18 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:60452 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240717AbhKXCVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:21:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637720287; x=1669256287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ks9WK6xPb6TdyOhpMGKIL0/NrZ84mDMpY9FGSn/57ps=;
  b=VvFhbZo0BPPKB7lYOoA//oG2vIHzB05mPF2xtM7rIJMxXkwtQipPXkVT
   YtIyk9KG8oLNTHHFF1DZvPZkqZbghM4oxucdNMH3Slqn2RNDUwgf7ssgP
   q/NVGJIvzH56gq0SRq7qKiTz7tKZwAEWG2QUcZeBjf8TzPxeoZLFzYG4K
   k=;
X-IronPort-AV: E=Sophos;i="5.87,258,1631577600"; 
   d="scan'208";a="43798714"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 24 Nov 2021 02:18:06 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id 810F44170C;
        Wed, 24 Nov 2021 02:18:06 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:18:05 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.102) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:18:02 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 13/13] af_unix: Relax race in unix_autobind().
Date:   Wed, 24 Nov 2021 11:14:31 +0900
Message-ID: <20211124021431.48956-14-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211124021431.48956-1-kuniyu@amazon.co.jp>
References: <20211124021431.48956-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D03UWA004.ant.amazon.com (10.43.160.250) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we bind an AF_UNIX socket without a name specified, the kernel selects
an available one from 0x00000 to 0xFFFFF.  unix_autobind() starts searching
from a number in the 'static' variable and increments it after acquiring
two locks.

If multiple processes try autobind, they obtain the same lock and check if
a socket in the hash list has the same name.  If not, one process uses it,
and all except one end up retrying the _next_ number (actually not, it may
be incremented by the other processes).  The more we autobind sockets in
parallel, the longer the latency gets.  We can avoid such a race by
searching for a name from a random number.

These show latency in unix_autobind() while 64 CPUs are simultaneously
autobind-ing 1024 sockets for each.

  Without this patch:

     usec          : count     distribution
        0          : 1176     |***                                     |
        2          : 3655     |***********                             |
        4          : 4094     |*************                           |
        6          : 3831     |************                            |
        8          : 3829     |************                            |
        10         : 3844     |************                            |
        12         : 3638     |***********                             |
        14         : 2992     |*********                               |
        16         : 2485     |*******                                 |
        18         : 2230     |*******                                 |
        20         : 2095     |******                                  |
        22         : 1853     |*****                                   |
        24         : 1827     |*****                                   |
        26         : 1677     |*****                                   |
        28         : 1473     |****                                    |
        30         : 1573     |*****                                   |
        32         : 1417     |****                                    |
        34         : 1385     |****                                    |
        36         : 1345     |****                                    |
        38         : 1344     |****                                    |
        40         : 1200     |***                                     |

  With this patch:

     usec          : count     distribution
        0          : 1855     |******                                  |
        2          : 6464     |*********************                   |
        4          : 9936     |********************************        |
        6          : 12107    |****************************************|
        8          : 10441    |**********************************      |
        10         : 7264     |***********************                 |
        12         : 4254     |**************                          |
        14         : 2538     |********                                |
        16         : 1596     |*****                                   |
        18         : 1088     |***                                     |
        20         : 800      |**                                      |
        22         : 670      |**                                      |
        24         : 601      |*                                       |
        26         : 562      |*                                       |
        28         : 525      |*                                       |
        30         : 446      |*                                       |
        32         : 378      |*                                       |
        34         : 337      |*                                       |
        36         : 317      |*                                       |
        38         : 314      |*                                       |
        40         : 298      |                                        |

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index d011d4059833..4c6bcd9283aa 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1074,8 +1074,7 @@ static int unix_autobind(struct sock *sk)
 	unsigned int new_hash, old_hash = sk->sk_hash;
 	struct unix_sock *u = unix_sk(sk);
 	struct unix_address *addr;
-	unsigned int retries = 0;
-	static u32 ordernum = 1;
+	u32 lastnum, ordernum;
 	int err;
 
 	err = mutex_lock_interruptible(&u->bindlock);
@@ -1091,32 +1090,35 @@ static int unix_autobind(struct sock *sk)
 	if (!addr)
 		goto out;
 
+	addr->len = offsetof(struct sockaddr_un, sun_path) + 6;
 	addr->name->sun_family = AF_UNIX;
 	refcount_set(&addr->refcnt, 1);
 
+	ordernum = prandom_u32();
+	lastnum = ordernum & 0xFFFFF;
 retry:
-	addr->len = sprintf(addr->name->sun_path + 1, "%05x", ordernum) +
-		offsetof(struct sockaddr_un, sun_path) + 1;
+	ordernum = (ordernum + 1) & 0xFFFFF;
+	sprintf(addr->name->sun_path + 1, "%05x", ordernum);
 
 	new_hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
 	unix_table_double_lock(old_hash, new_hash);
-	ordernum = (ordernum+1)&0xFFFFF;
 
 	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len,
 				      new_hash)) {
 		unix_table_double_unlock(old_hash, new_hash);
 
-		/*
-		 * __unix_find_socket_byname() may take long time if many names
+		/* __unix_find_socket_byname() may take long time if many names
 		 * are already in use.
 		 */
 		cond_resched();
-		/* Give up if all names seems to be in use. */
-		if (retries++ == 0xFFFFF) {
+
+		if (ordernum == lastnum) {
+			/* Give up if all names seems to be in use. */
 			err = -ENOSPC;
-			kfree(addr);
+			unix_release_addr(addr);
 			goto out;
 		}
+
 		goto retry;
 	}
 
-- 
2.30.2

