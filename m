Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945022041F0
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 22:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgFVU0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 16:26:32 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52835 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728386AbgFVU0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 16:26:32 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with SMTP; 22 Jun 2020 23:26:30 +0300
Received: from dev-l-vrt-051.mtl.labs.mlnx. (dev-l-vrt-051.mtl.labs.mlnx [10.234.40.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 05MKQUab002796;
        Mon, 22 Jun 2020 23:26:30 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net V2] net: Do not clear the sock TX queue in sk_set_socket()
Date:   Mon, 22 Jun 2020 23:26:04 +0300
Message-Id: <1592857564-13755-1-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clearing the sock TX queue in sk_set_socket() might cause unexpected
out-of-order transmit when called from sock_orphan(), as outstanding
packets can pick a different TX queue and bypass the ones already queued.

This is undesired in general. More specifically, it breaks the in-order
scheduling property guarantee for device-offloaded TLS sockets.

Remove the call to sk_tx_queue_clear() in sk_set_socket(), and add it
explicitly only where needed.

Fixes: e022f0b4a03f ("net: Introduce sk_tx_queue_mapping")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
---
 include/net/sock.h | 1 -
 net/core/sock.c    | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

Please queue to -stable.

Changes v1 -> v2:
Per Eric's suggestion, took sk_tx_queue_clear() out of sk_set_socket()
and called it explicitly where needed.

diff --git a/include/net/sock.h b/include/net/sock.h
index c53cc42b5ab9..3428619faae4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1848,7 +1848,6 @@ static inline int sk_rx_queue_get(const struct sock *sk)
 
 static inline void sk_set_socket(struct sock *sk, struct socket *sock)
 {
-	sk_tx_queue_clear(sk);
 	sk->sk_socket = sock;
 }
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 94391da27754..d832c650287c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1767,6 +1767,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
 		cgroup_sk_alloc(&sk->sk_cgrp_data);
 		sock_update_classid(&sk->sk_cgrp_data);
 		sock_update_netprioidx(&sk->sk_cgrp_data);
+		sk_tx_queue_clear(sk);
 	}
 
 	return sk;
@@ -1990,6 +1991,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		 */
 		sk_refcnt_debug_inc(newsk);
 		sk_set_socket(newsk, NULL);
+		sk_tx_queue_clear(newsk);
 		RCU_INIT_POINTER(newsk->sk_wq, NULL);
 
 		if (newsk->sk_prot->sockets_allocated)
-- 
1.8.3.1

