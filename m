Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6549A567AB0
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 01:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiGEXhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 19:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGEXhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 19:37:46 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900A613D1E
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 16:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657064265; x=1688600265;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zi4JAqQpfmJtMdLu8/EwO52e5qftYA2O5ap7dpixg/U=;
  b=D+g8i3gWtCe4an+G8UMyxMQ/TJUZsNm3HHrwPfI9Vi4sGImTMPshL31/
   x2Q8Pv+bOLUEKvqiO9a2wCCDfnpHvRrhwBrCJR7Zucv95+xqW25tPMvm1
   OuuWAMjy7e6DZPJ6yb7PRV3ibLq3uRkW0xNfgZhAyuU7chf1O0gPXVOKc
   c=;
X-IronPort-AV: E=Sophos;i="5.92,248,1650931200"; 
   d="scan'208";a="105214738"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 05 Jul 2022 23:37:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com (Postfix) with ESMTPS id 3B168C095C;
        Tue,  5 Jul 2022 23:37:27 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 5 Jul 2022 23:37:27 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.106) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Tue, 5 Jul 2022 23:37:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next] af_unix: Optimise hash table layout.
Date:   Tue, 5 Jul 2022 16:37:15 -0700
Message-ID: <20220705233715.759-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.106]
X-ClientProxiedBy: EX13D13UWA003.ant.amazon.com (10.43.160.181) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 6dd4142fb5a9 ("Merge branch 'af_unix-per-netns-socket-hash'") and
commit 51bae889fe11 ("af_unix: Put pathname sockets in the global hash
table.") changed a hash table layout.

  Before:
    unix_socket_table [0   - 255] : abstract & pathname sockets
                      [256 - 511] : unnamed sockets

  After:
    per-netns table   [0   - 255] : abstract & pathname sockets
                      [256 - 511] : unnamed sockets
    bsd_socket_table  [0   - 255] : pathname sockets (sk_bind_node)

Now, while looking up sockets, we traverse the global table for the
pathname sockets and the first half of each per-netns hash table for
abstract sockets, where pathname sockets are also linked.  Thus, the
more pathname sockets we have, the longer we take to look up abstract
sockets.  This characteristic has been there before the layout change,
but we can improve it now.

This patch changes the per-netns hash table's layout so that sockets not
requiring lookup reside in the first half and do not impact the lookup of
abstract sockets.

    per-netns table   [0   - 255] : pathname & unnamed sockets
                      [256 - 511] : abstract sockets
    bsd_socket_table  [0   - 255] : pathname sockets (sk_bind_node)

We have run a test that bind()s 100,000 abstract/pathname sockets for
each, bind()s an abstract socket 100,000 times and measures the time
on __unix_find_socket_byname().  The result shows that the patch makes
each lookup faster.

  Without this patch:
    $ sudo ./funclatency -p 2278 --microseconds __unix_find_socket_byname.isra.44
     usec                : count    distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 0        |                                        |
         8 -> 15         : 126      |                                        |
        16 -> 31         : 1438     |*                                       |
        32 -> 63         : 4150     |***                                     |
        64 -> 127        : 9049     |*******                                 |
       128 -> 255        : 37704    |*******************************         |
       256 -> 511        : 47533    |****************************************|

  With this patch:
    $ sudo ./funclatency -p 3648 --microseconds __unix_find_socket_byname.isra.46
     usec                : count    distribution
         0 -> 1          : 109      |                                        |
         2 -> 3          : 318      |                                        |
         4 -> 7          : 725      |                                        |
         8 -> 15         : 2501     |*                                       |
        16 -> 31         : 3061     |**                                      |
        32 -> 63         : 4028     |***                                     |
        64 -> 127        : 9312     |*******                                 |
       128 -> 255        : 51372    |****************************************|
       256 -> 511        : 28574    |**********************                  |

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/unix/af_unix.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 526b872cc710..784b4b30ce9a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -135,7 +135,7 @@ static unsigned int unix_unbound_hash(struct sock *sk)
 	hash ^= hash >> 8;
 	hash ^= sk->sk_type;
 
-	return UNIX_HASH_MOD + 1 + (hash & UNIX_HASH_MOD);
+	return hash & UNIX_HASH_MOD;
 }
 
 static unsigned int unix_bsd_hash(struct inode *i)
@@ -153,16 +153,17 @@ static unsigned int unix_abstract_hash(struct sockaddr_un *sunaddr,
 	hash ^= hash >> 8;
 	hash ^= type;
 
-	return hash & UNIX_HASH_MOD;
+	return UNIX_HASH_MOD + 1 + (hash & UNIX_HASH_MOD);
 }
 
 static void unix_table_double_lock(struct net *net,
 				   unsigned int hash1, unsigned int hash2)
 {
-	/* hash1 and hash2 is never the same because
-	 * one is between 0 and UNIX_HASH_MOD, and
-	 * another is between UNIX_HASH_MOD + 1 and UNIX_HASH_SIZE - 1.
-	 */
+	if (hash1 == hash2) {
+		spin_lock(&net->unx.table.locks[hash1]);
+		return;
+	}
+
 	if (hash1 > hash2)
 		swap(hash1, hash2);
 
@@ -173,6 +174,11 @@ static void unix_table_double_lock(struct net *net,
 static void unix_table_double_unlock(struct net *net,
 				     unsigned int hash1, unsigned int hash2)
 {
+	if (hash1 == hash2) {
+		spin_unlock(&net->unx.table.locks[hash1]);
+		return;
+	}
+
 	spin_unlock(&net->unx.table.locks[hash1]);
 	spin_unlock(&net->unx.table.locks[hash2]);
 }
-- 
2.30.2

