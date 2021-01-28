Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EF0306B02
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhA1CU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:20:26 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:32492 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhA1CUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 21:20:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1611800418; x=1643336418;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=nxnE6peKQuQI6EPAUsAkzTReC/Ivi8beCiT3uzrFH3A=;
  b=eFPJUo+s9hUWTbuFbZE28PkOcI+j4F4ySM5xfsweEi6Y/+syrdUDC7+X
   vYsggnyVcJY7CVMaoJCFOzBzTg9QFsLhHAbGKqT3SKVvQtFypBBjj6T70
   JD+sLF2Y7lFF6ojp2sNRrETluoAXWTkX1HteJT0Rr+iDNS/7Whptgv+aw
   E=;
X-IronPort-AV: E=Sophos;i="5.79,381,1602547200"; 
   d="scan'208";a="78132507"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 28 Jan 2021 02:19:36 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id 32BBFA1C40;
        Thu, 28 Jan 2021 02:19:35 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 Jan 2021 02:19:34 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.253) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 Jan 2021 02:19:30 +0000
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
Subject: [PATCH v3 net-next] net: Remove redundant calls of sk_tx_queue_clear().
Date:   Thu, 28 Jan 2021 11:19:04 +0900
Message-ID: <20210128021905.57471-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D43UWA001.ant.amazon.com (10.43.160.44) To
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

Therefore, this patch adds a runtime check to take care of the order of
sock_copy() and sk_tx_queue_clear() and removes sk_tx_queue_clear() from
sk_prot_alloc() so that it does the only allocation and its callers
initialize fields.

v3:
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

