Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DACE27EEEB
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731338AbgI3QUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:20:39 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50435 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731296AbgI3QUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:20:34 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 30 Sep 2020 19:20:27 +0300
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08UGKR2F032498;
        Wed, 30 Sep 2020 19:20:27 +0300
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next RFC v1 04/10] net/tls: expose get_netdev_for_sock
Date:   Wed, 30 Sep 2020 19:20:04 +0300
Message-Id: <20200930162010.21610-5-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200930162010.21610-1-borisp@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_netdev_for_sock is a utility that is used to obtain
the net_device structure from a connected socket.

Later patches will use this for nvme-tcp DDP and DDP CRC offloads.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
---
 include/net/sock.h   | 17 +++++++++++++++++
 net/tls/tls_device.c | 20 ++------------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index a5c6ae78df77..e0a92187f9ea 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2703,4 +2703,21 @@ void sock_set_sndtimeo(struct sock *sk, s64 secs);
 
 int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
 
+/* Assume that the socket is already connected */
+static inline struct net_device *get_netdev_for_sock(struct sock *sk, bool hold)
+{
+	struct dst_entry *dst = sk_dst_get(sk);
+	struct net_device *netdev = NULL;
+
+	if (likely(dst)) {
+		netdev = dst->dev;
+		if (hold)
+			dev_hold(netdev);
+	}
+
+	dst_release(dst);
+
+	return netdev;
+}
+
 #endif	/* _SOCK_H */
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b74e2741f74f..4df0de65db04 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -106,22 +106,6 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 	spin_unlock_irqrestore(&tls_device_lock, flags);
 }
 
-/* We assume that the socket is already connected */
-static struct net_device *get_netdev_for_sock(struct sock *sk)
-{
-	struct dst_entry *dst = sk_dst_get(sk);
-	struct net_device *netdev = NULL;
-
-	if (likely(dst)) {
-		netdev = dst->dev;
-		dev_hold(netdev);
-	}
-
-	dst_release(dst);
-
-	return netdev;
-}
-
 static void destroy_record(struct tls_record_info *record)
 {
 	int i;
@@ -1086,7 +1070,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;
 
-	netdev = get_netdev_for_sock(sk);
+	netdev = get_netdev_for_sock(sk, true);
 	if (!netdev) {
 		pr_err_ratelimited("%s: netdev not found\n", __func__);
 		rc = -EINVAL;
@@ -1162,7 +1146,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 	if (ctx->crypto_recv.info.version != TLS_1_2_VERSION)
 		return -EOPNOTSUPP;
 
-	netdev = get_netdev_for_sock(sk);
+	netdev = get_netdev_for_sock(sk, true);
 	if (!netdev) {
 		pr_err_ratelimited("%s: netdev not found\n", __func__);
 		return -EINVAL;
-- 
2.24.1

