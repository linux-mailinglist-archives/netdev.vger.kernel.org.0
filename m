Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFDF305D0C
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbhA0NZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:25:28 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:12616 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238355AbhA0NXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 08:23:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1611753786; x=1643289786;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=KrUTu8hKVvdhX21kN7ECBHdjF8qc0AA/jylBcvei2f4=;
  b=KAghYjUi0xErofb/sml+gFlw9VYwe6m0DARw8WKx4jWz+8gkSXeEgnqD
   fBEj2yNiadB/e4wRPALpmNRuLs+t6Dw6gX2FDzMBrlANyPa9JT3zP3ieE
   YAsuZ7up1i2GCPmOdyOn7Jvi3d+GYzKbvKQRhpwDomRjwvt+BNwfd5YxY
   8=;
X-IronPort-AV: E=Sophos;i="5.79,379,1602547200"; 
   d="scan'208";a="80468539"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 27 Jan 2021 13:22:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id D19EF22900F;
        Wed, 27 Jan 2021 13:22:28 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 27 Jan 2021 13:22:28 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.247) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 27 Jan 2021 13:22:23 +0000
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
Subject: [PATCH v2 net] net: Remove redundant calls of sk_tx_queue_clear().
Date:   Wed, 27 Jan 2021 22:22:15 +0900
Message-ID: <20210127132215.10842-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.247]
X-ClientProxiedBy: EX13D23UWC004.ant.amazon.com (10.43.162.219) To
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

