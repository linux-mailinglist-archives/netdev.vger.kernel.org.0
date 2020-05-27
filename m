Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0661E1E3D83
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgE0JZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:25:37 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:48975 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726761AbgE0JZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:25:37 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 May 2020 12:25:34 +0300
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04R9PYAo015074;
        Wed, 27 May 2020 12:25:34 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next] net/tls: Add force_resync for driver resync
Date:   Wed, 27 May 2020 12:25:26 +0300
Message-Id: <20200527092526.3657-1-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a field to the tls rx offload context which enables
drivers to force a send_resync call.

This field can be used by drivers to request a resync at the next
possible tls record. It is beneficial for hardware that provides the
resync sequence number asynchronously. In such cases, the packet that
triggered the resync does not contain the information required for a
resync. Instead, the driver requests resync for all the following
TLS record until the asynchronous notification with the resync request
TCP sequence arrives.

A following series for mlx5e ConnectX-6DX TLS RX offload support will
use this mechanism.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/net/tls.h    | 12 +++++++++++-
 net/tls/tls_device.c |  9 ++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index bf9eb4823933..cf9ec152fbb7 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -594,12 +594,22 @@ tls_driver_ctx(const struct sock *sk, enum tls_offload_ctx_dir direction)
 #endif
 
 /* The TLS context is valid until sk_destruct is called */
+#define RESYNC_REQ (1 << 0)
+#define RESYNC_REQ_FORCE (1 << 1)
 static inline void tls_offload_rx_resync_request(struct sock *sk, __be32 seq)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
 
-	atomic64_set(&rx_ctx->resync_req, ((u64)ntohl(seq) << 32) | 1);
+	atomic64_set(&rx_ctx->resync_req, ((u64)ntohl(seq) << 32) | RESYNC_REQ);
+}
+
+static inline void tls_offload_rx_force_resync_request(struct sock *sk)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
+
+	atomic64_set(&rx_ctx->resync_req, RESYNC_REQ | RESYNC_REQ_FORCE);
 }
 
 static inline void
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a562ebaaa33c..0e55f8365ce2 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -694,10 +694,11 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_offload_context_rx *rx_ctx;
+	bool is_req_pending, is_force_resync;
 	u8 rcd_sn[TLS_MAX_REC_SEQ_SIZE];
-	u32 sock_data, is_req_pending;
 	struct tls_prot_info *prot;
 	s64 resync_req;
+	u32 sock_data;
 	u32 req_seq;
 
 	if (tls_ctx->rx_conf != TLS_HW)
@@ -712,9 +713,11 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 		resync_req = atomic64_read(&rx_ctx->resync_req);
 		req_seq = resync_req >> 32;
 		seq += TLS_HEADER_SIZE - 1;
-		is_req_pending = resync_req;
+		is_req_pending = resync_req & RESYNC_REQ;
+		is_force_resync = resync_req & RESYNC_REQ_FORCE;
 
-		if (likely(!is_req_pending) || req_seq != seq ||
+		if (likely(!is_req_pending) ||
+		    (!is_force_resync && req_seq != seq) ||
 		    !atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
 			return;
 		break;
-- 
2.21.0

