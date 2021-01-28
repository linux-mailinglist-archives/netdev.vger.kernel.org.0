Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D78307903
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 16:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhA1PD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 10:03:29 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:47240 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbhA1PDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 10:03:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1611846203; x=1643382203;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=9/VdyTFb8NHluY/IjaW1kRd1KpXx4zAWoo8u1a5kQC4=;
  b=YYdhKgjL3XmSgnHjooxKIv/NZzGpl0m8sv2S1HpplNzurlV/m/Wqsm/F
   9JqBaJptDW3IYqEhcNu50SXkwDGZb+16HLYPixPrtJs6yp1aXg1QIsdKl
   WS14YMos2WHt6txHt5jlWQsYGtYSoJdUJzcAwqkvvq1XwSIngyDmrhg8w
   8=;
X-IronPort-AV: E=Sophos;i="5.79,382,1602547200"; 
   d="scan'208";a="80752060"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 28 Jan 2021 15:02:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id D9BC1A2134;
        Thu, 28 Jan 2021 15:02:40 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 Jan 2021 15:02:40 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.253) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 Jan 2021 15:02:36 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
CC:     Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Amit Shah <aams@amazon.de>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "Kuniyuki Iwashima" <kuni1840@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Tariq Toukan <tariqt@mellanox.com>,
        "Boris Pismenny" <borisp@mellanox.com>
Subject: [PATCH v5 net-next] net: Remove redundant calls of sk_tx_queue_clear().
Date:   Fri, 29 Jan 2021 00:02:17 +0900
Message-ID: <20210128150217.6060-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D23UWC001.ant.amazon.com (10.43.162.196) To
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

CC: Tariq Toukan <tariqt@mellanox.com>
CC: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Acked-by: Tariq Toukan <tariqt@nvidia.com>
---
v5:
* Move the changelog after the --- separator

v4: https://lore.kernel.org/netdev/20210128124229.78315-1-kuniyu@amazon.co.jp/
* Fix typo in the changelog (runtime -> compile-time)

v3: https://lore.kernel.org/netdev/20210128021905.57471-1-kuniyu@amazon.co.jp/
* Remove Fixes: tag
* Add BUILD_BUG_ON
* Remove sk_tx_queue_clear() from sk_prot_alloc()
  instead of sk_alloc() and sk_clone_lock()

v2: https://lore.kernel.org/netdev/20210127132215.10842-1-kuniyu@amazon.co.jp/
* Remove Reviewed-by: tag

v1: https://lore.kernel.org/netdev/20210127125018.7059-1-kuniyu@amazon.co.jp/

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

