Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84045942C
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240293AbhKVRr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:47:59 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:28654 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240323AbhKVRrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 12:47:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637603088; x=1669139088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WqiNR1gioDzDqu1H/yLLc+s97iXxCJSAM2beWiVFdaQ=;
  b=bfvgXA5k0DPvyDnD5ctnWAlelpMgJC7vQLK20PcDoWmVCbxIZuWGnX3o
   3dhomOoLgViDbkszA+8/556RUxOhg79bRO+wBVvTj/0iW2Zxm0IrlH/cD
   YQ5Qu6diWyywZzqRmVBICODXVZFjc0TehXO+MMips1tkCBbwFoYxogNkn
   w=;
X-IronPort-AV: E=Sophos;i="5.87,255,1631577600"; 
   d="scan'208";a="153894375"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-1ac2810f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 22 Nov 2021 17:44:47 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-1ac2810f.us-east-1.amazon.com (Postfix) with ESMTPS id C36C98133E;
        Mon, 22 Nov 2021 17:44:46 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:44:45 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.57) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:44:43 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH RESEND v2 net-next 13/13] af_unix: Relax race in unix_autobind().
Date:   Tue, 23 Nov 2021 02:41:14 +0900
Message-ID: <20211122174114.84594-14-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122174114.84594-1-kuniyu@amazon.co.jp>
References: <20211122174114.84594-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.57]
X-ClientProxiedBy: EX13D23UWA004.ant.amazon.com (10.43.160.72) To
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
index 77334815bc3d..8b1e74d0f734 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1069,8 +1069,7 @@ static int unix_autobind(struct sock *sk)
 	unsigned int new_hash, old_hash = sk->sk_hash;
 	struct unix_sock *u = unix_sk(sk);
 	struct unix_address *addr;
-	unsigned int retries = 0;
-	static u32 ordernum = 1;
+	u32 lastnum, ordernum;
 	int err;
 
 	err = mutex_lock_interruptible(&u->bindlock);
@@ -1085,31 +1084,34 @@ static int unix_autobind(struct sock *sk)
 	if (!addr)
 		goto out;
 
+	addr->len = offsetof(struct sockaddr_un, sun_path) + 6;
 	addr->name->sun_family = AF_UNIX;
 	refcount_set(&addr->refcnt, 1);
 
+	lastnum = ordernum = prandom_u32();
+	lastnum &= 0xFFFFF;
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

