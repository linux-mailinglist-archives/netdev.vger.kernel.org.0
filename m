Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF97A307649
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhA1Mn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:43:26 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:6406 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhA1MnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:43:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1611837804; x=1643373804;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=MihEBDTLfnvbuC3+H6o2DfOu7iO4hUziMz4d2oMBnQM=;
  b=UinAzwACJHixH8G2rYW7IVNXNo/V+8lQ2tvOxy3PwtJHLkN68L6H846N
   y8rOuq3QaBrSEA9VGkv4dT1/yNi52rjA5ksw3yk8FLmNNqOmoRMN91ryA
   dKy+BVRru73HZDZAkjLdHQLQNddNILjLW+OWhCI24W5WtWBlHTxA08L0W
   Q=;
X-IronPort-AV: E=Sophos;i="5.79,382,1602547200"; 
   d="scan'208";a="77994506"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 28 Jan 2021 12:42:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 53BFA1A0589;
        Thu, 28 Jan 2021 12:42:41 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 Jan 2021 12:42:40 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.67) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 Jan 2021 12:42:36 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
CC:     Amit Shah <aams@amazon.de>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "Boris Pismenny" <borisp@mellanox.com>
Subject: [PATCH v4 net-next] net: Remove redundant calls of sk_tx_queue_clear().
Date:   Thu, 28 Jan 2021 21:42:29 +0900
Message-ID: <20210128124229.78315-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.67]
X-ClientProxiedBy: EX13D40UWC001.ant.amazon.com (10.43.162.149) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 41b14fb8724d ("net: Do not clear the sock TX queue in
sk_set_socket()") removes sk_tx_queue_clear() from sk_set_socket() and adds
it instead in sk_alloc() and sk_clone_lock() to fix an issue introduced in
the commit e022f0b4a03f ("net: Introduce sk_tx_queue_mapping"). On the
other hand, the original commit had already put sk_tx_queue_clear() in
sk_prot_alloc(): the callee of sk_alloc() and sk_clone_lock(). Thus
sk_tx_queue_clear() is called twice in each path.

If we remove sk_tx_queue_clear() in sk_alloc() and sk_clone_lock(), it
currently works well because (i) sk_tx_queue_mapping is defined between
sk_dontcopy_begin and sk_dontcopy_end, and (ii) sock_copy() called after
sk_prot_alloc() in sk_clone_lock() does not overwrite sk_tx_queue_mapping.
However, if we move sk_tx_queue_mapping out of the no copy area, it
introduces a bug unintentionally.

Therefore, this patch adds a compile-time check to take care of the order
of sock_copy() and sk_tx_queue_clear() and removes sk_tx_queue_clear() from
sk_prot_alloc() so that it does the only allocation and its callers
initialize fields.

v4:
* Fix typo in the changelog (runtime -> compile-time)

v3: https://lore.kernel.org/netdev/20210128021905.57471-1-kuniyu@amazon.co.jp/
* Remove Fixes: tag
* Add BUILD_BUG_ON
* Remove sk_tx_queue_clear() from sk_prot_alloc()
  instead of sk_alloc() and sk_clone_lock()

v2: https://lore.kernel.org/netdev/20210127132215.10842-1-kuniyu@amazon.co.jp/
* Remove Reviewed-by: tag

v1: https://lore.kernel.org/netdev/20210127125018.7059-1-kuniyu@amazon.co.jp/

CC: Tariq Toukan <tariqt@mellanox.com>
CC: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/core/sock.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index bbcd4b97eddd..cfbd62a5e079 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1657,6 +1657,16 @@ static void sock_copy(struct sock *nsk, const struct sock *osk)
 #ifdef CONFIG_SECURITY_NETWORK
 	void *sptr = nsk->sk_security;
 #endif
+
+	/* If we move sk_tx_queue_mapping out of the private section,
+	 * we must check if sk_tx_queue_clear() is called after
+	 * sock_copy() in sk_clone_lock().
+	 */
+	BUILD_BUG_ON(offsetof(struct sock, sk_tx_queue_mapping) <
+		     offsetof(struct sock, sk_dontcopy_begin) ||
+		     offsetof(struct sock, sk_tx_queue_mapping) >=
+		     offsetof(struct sock, sk_dontcopy_end));
+
 	memcpy(nsk, osk, offsetof(struct sock, sk_dontcopy_begin));
 
 	memcpy(&nsk->sk_dontcopy_end, &osk->sk_dontcopy_end,
@@ -1690,7 +1700,6 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
 
 		if (!try_module_get(prot->owner))
 			goto out_free_sec;
-		sk_tx_queue_clear(sk);
 	}
 
 	return sk;
-- 
2.17.2 (Apple Git-113)

