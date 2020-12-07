Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA772D1BA4
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgLGVHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:07:51 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45704 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727007AbgLGVHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:07:49 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 7 Dec 2020 23:06:53 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0B7L6qIC029788;
        Mon, 7 Dec 2020 23:06:53 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
Subject: [PATCH v1 net-next 04/15] net/tls: expose get_netdev_for_sock
Date:   Mon,  7 Dec 2020 23:06:38 +0200
Message-Id: <20201207210649.19194-5-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201207210649.19194-1-borisp@mellanox.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_netdev_for_sock is a utility that is used to obtain
the net_device structure from a connected socket.

Later patches will use this for nvme-tcp DDP and DDP CRC offloads.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 include/net/sock.h   | 17 +++++++++++++++++
 net/tls/tls_device.c | 20 ++------------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 093b51719c69..a8f7393ea433 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2711,4 +2711,21 @@ void sock_set_sndtimeo(struct sock *sk, s64 secs);
 
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
index a3ab2d3d4e4e..8c3bc8705efb 100644
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
@@ -1104,7 +1088,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;
 
-	netdev = get_netdev_for_sock(sk);
+	netdev = get_netdev_for_sock(sk, true);
 	if (!netdev) {
 		pr_err_ratelimited("%s: netdev not found\n", __func__);
 		rc = -EINVAL;
@@ -1180,7 +1164,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 	if (ctx->crypto_recv.info.version != TLS_1_2_VERSION)
 		return -EOPNOTSUPP;
 
-	netdev = get_netdev_for_sock(sk);
+	netdev = get_netdev_for_sock(sk, true);
 	if (!netdev) {
 		pr_err_ratelimited("%s: netdev not found\n", __func__);
 		return -EINVAL;
-- 
2.24.1

