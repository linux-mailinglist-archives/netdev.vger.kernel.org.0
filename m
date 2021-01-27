Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB762305C1F
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238099AbhA0MxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 07:53:07 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:49742 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237969AbhA0Mv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 07:51:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1611751888; x=1643287888;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=8A4azyf4kdWrTdp0Vr0w/gcfsSttk4jeq7jMqaaBCJo=;
  b=oTj/C3MtkPdp8QfdgL1cm5/dpgWIHK1CpC9VxRjVBwDp5mLGmnX7Zf7K
   G488SXgApx+54RkmyG8MouAd3KToKlA9+K4MAXTVEfd+IJHdDVgX78pLM
   EEFm9SwrZnXMo97x5dWZadCmBxQH2KrPOck6TfD2WiYd0Ur69KcRUhkBQ
   Q=;
X-IronPort-AV: E=Sophos;i="5.79,379,1602547200"; 
   d="scan'208";a="77733746"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 27 Jan 2021 12:50:47 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 687871414D5;
        Wed, 27 Jan 2021 12:50:45 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 27 Jan 2021 12:50:44 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.94) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 27 Jan 2021 12:50:40 +0000
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
Subject: [PATCH net] net: Remove redundant calls of sk_tx_queue_clear().
Date:   Wed, 27 Jan 2021 21:50:18 +0900
Message-ID: <20210127125018.7059-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.94]
X-ClientProxiedBy: EX13D44UWB004.ant.amazon.com (10.43.161.205) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 41b14fb8724d ("net: Do not clear the sock TX queue in
sk_set_socket()") removes sk_tx_queue_clear() from sk_set_socket() and adds
it instead in sk_alloc() and sk_clone_lock() to fix an issue introduced in
the commit e022f0b4a03f ("net: Introduce sk_tx_queue_mapping"). However,
the original commit had already put sk_tx_queue_clear() in sk_prot_alloc():
the callee of sk_alloc() and sk_clone_lock(). Thus sk_tx_queue_clear() is
called twice in each path currently.

This patch removes the redundant calls of sk_tx_queue_clear() in sk_alloc()
and sk_clone_lock().

Fixes: 41b14fb8724d ("net: Do not clear the sock TX queue in sk_set_socket()")
CC: Tariq Toukan <tariqt@mellanox.com>
CC: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Reviewed-by: Amit Shah <aams@amazon.de>
---
 net/core/sock.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index bbcd4b97eddd..5c665ee14159 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1759,7 +1759,6 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
 		cgroup_sk_alloc(&sk->sk_cgrp_data);
 		sock_update_classid(&sk->sk_cgrp_data);
 		sock_update_netprioidx(&sk->sk_cgrp_data);
-		sk_tx_queue_clear(sk);
 	}
 
 	return sk;
@@ -1983,7 +1982,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		 */
 		sk_refcnt_debug_inc(newsk);
 		sk_set_socket(newsk, NULL);
-		sk_tx_queue_clear(newsk);
 		RCU_INIT_POINTER(newsk->sk_wq, NULL);
 
 		if (newsk->sk_prot->sockets_allocated)
-- 
2.17.2 (Apple Git-113)

