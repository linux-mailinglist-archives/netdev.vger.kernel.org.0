Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2285C202AF0
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 16:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbgFUOJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 10:09:48 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55735 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730022AbgFUOJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 10:09:48 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with SMTP; 21 Jun 2020 17:09:46 +0300
Received: from dev-l-vrt-051.mtl.labs.mlnx. (dev-l-vrt-051.mtl.labs.mlnx [10.234.40.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 05LE9kh0026166;
        Sun, 21 Jun 2020 17:09:46 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net] net: Do not clear the socket TX queue in sock_orphan()
Date:   Sun, 21 Jun 2020 17:09:04 +0300
Message-Id: <1592748544-41555-1-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_orphan() call to sk_set_socket() implies clearing the sock TX queue.
This might cause unexpected out-of-order transmit, as outstanding packets
can pick a different TX queue and bypass the ones already queued.
This is undesired in general. More specifically, it breaks the in-order
scheduling property guarantee for device-offloaded TLS sockets.

Introduce a function variation __sk_set_socket() that does not clear
the TX queue, and call it from sock_orphan().
All other callers of sk_set_socket() do not operate on an active socket,
so they do not need this change.

Fixes: e022f0b4a03f ("net: Introduce sk_tx_queue_mapping")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
---
 include/net/sock.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Please queue for -stable.

diff --git a/include/net/sock.h b/include/net/sock.h
index c53cc42b5ab9..23e43f3d79f0 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1846,10 +1846,15 @@ static inline int sk_rx_queue_get(const struct sock *sk)
 }
 #endif
 
+static inline void __sk_set_socket(struct sock *sk, struct socket *sock)
+{
+	sk->sk_socket = sock;
+}
+
 static inline void sk_set_socket(struct sock *sk, struct socket *sock)
 {
 	sk_tx_queue_clear(sk);
-	sk->sk_socket = sock;
+	__sk_set_socket(sk, sock);
 }
 
 static inline wait_queue_head_t *sk_sleep(struct sock *sk)
@@ -1868,7 +1873,7 @@ static inline void sock_orphan(struct sock *sk)
 {
 	write_lock_bh(&sk->sk_callback_lock);
 	sock_set_flag(sk, SOCK_DEAD);
-	sk_set_socket(sk, NULL);
+	__sk_set_socket(sk, NULL);
 	sk->sk_wq  = NULL;
 	write_unlock_bh(&sk->sk_callback_lock);
 }
-- 
1.8.3.1

