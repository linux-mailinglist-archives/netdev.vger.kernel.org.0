Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2525B446D33
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 10:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbhKFJXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 05:23:25 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:48276 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhKFJXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 05:23:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636190443; x=1667726443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VfzbhLVSWl/MyUE2VHE8dsQieL35uCjr7Lh2GpnHbjc=;
  b=rzg4rWTUahYjjCc/oUr1O7RcXHNuhqglXFDJEemefJ3O7Iz3cj0SOkRw
   +CIJJ+GsADpyRIjhTGHIBdudUpD2N0HgubORF5AL1B9NOh3/9kGq+M4Gh
   rqWUUErNX5RFvPW+3+7ztwzCN50p2Jeoq6mOzXw57CNWXJ8xAHxT/UsLj
   8=;
X-IronPort-AV: E=Sophos;i="5.87,213,1631577600"; 
   d="scan'208";a="154598049"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 06 Nov 2021 09:20:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com (Postfix) with ESMTPS id A1A83C09D1;
        Sat,  6 Nov 2021 09:20:41 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:20:40 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:20:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 13/13] af_unix: Relax race in unix_autobind().
Date:   Sat, 6 Nov 2021 18:17:12 +0900
Message-ID: <20211106091712.15206-14-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211106091712.15206-1-kuniyu@amazon.co.jp>
References: <20211106091712.15206-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.153]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
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
 net/unix/af_unix.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 643f0358bf7a..55d570b23475 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1075,8 +1075,7 @@ static int unix_autobind(struct sock *sk)
 	unsigned int new_hash, old_hash = sk->sk_hash;
 	struct unix_sock *u = unix_sk(sk);
 	struct unix_address *addr;
-	unsigned int retries = 0;
-	static u32 ordernum = 1;
+	u32 initnum, ordernum;
 	int err;
 
 	err = mutex_lock_interruptible(&u->bindlock);
@@ -1091,31 +1090,33 @@ static int unix_autobind(struct sock *sk)
 	if (!addr)
 		goto out;
 
+	addr->len = offsetof(struct sockaddr_un, sun_path) + 6;
 	addr->name->sun_family = AF_UNIX;
 	refcount_set(&addr->refcnt, 1);
 
+	initnum = ordernum = prandom_u32();
 retry:
-	addr->len = sprintf(addr->name->sun_path + 1, "%05x", ordernum) +
-		offsetof(struct sockaddr_un, sun_path) + 1;
+	ordernum = (ordernum + 1) & 0xFFFFF;
+	sprintf(addr->name->sun_path + 1, "%05x", ordernum);
 
 	new_hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
 	unix_table_double_lock(old_hash, new_hash);
-	ordernum = (ordernum+1)&0xFFFFF;
 
 	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len, new_hash)) {
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
+		if (ordernum == initnum) {
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

