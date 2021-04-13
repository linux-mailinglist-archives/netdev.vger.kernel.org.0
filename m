Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FBA35DCA9
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 12:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343697AbhDMKpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 06:45:19 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:50442 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343672AbhDMKpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 06:45:18 -0400
Received: from redhouse-blr-asicdesigners-com.asicdesigners.com (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 13DAim5N011608;
        Tue, 13 Apr 2021 03:44:49 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com
Cc:     borisp@nvidia.com, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [net] tls/chtls: fix kernel panic with tls_toe
Date:   Tue, 13 Apr 2021 16:14:47 +0530
Message-Id: <20210413104447.965-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If tls_toe is supported by any device, tls_toe will be enabled
and tls context will be created for listen sockets. But the
connections established in stack issue context delete for every
connection close, this causes kernel panic.
  As part of the fix, if tls_toe is supported, don't initialize
tcp_ulp_ops. Also make sure tls context is freed only for listen
sockets.

Fixes: 95fa145479fb ("bpf: sockmap/tls, close can race with map free")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/chtls/chtls_cm.c    | 12 -------
 .../chelsio/inline_crypto/chtls/chtls_main.c  |  5 +--
 net/tls/tls_main.c                            |  6 +++-
 net/tls/tls_toe.c                             | 31 ++++++++++++-------
 4 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 19dc7dc054a2..d06850575096 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1275,16 +1275,6 @@ static  void mk_tid_release(struct sk_buff *skb,
 	INIT_TP_WR_CPL(req, CPL_TID_RELEASE, tid);
 }
 
-static int chtls_get_module(struct sock *sk)
-{
-	struct inet_connection_sock *icsk = inet_csk(sk);
-
-	if (!try_module_get(icsk->icsk_ulp_ops->owner))
-		return -1;
-
-	return 0;
-}
-
 static void chtls_pass_accept_request(struct sock *sk,
 				      struct sk_buff *skb)
 {
@@ -1401,8 +1391,6 @@ static void chtls_pass_accept_request(struct sock *sk,
 	if (!newsk)
 		goto reject;
 
-	if (chtls_get_module(newsk))
-		goto reject;
 	inet_csk_reqsk_queue_added(sk);
 	reply_skb->sk = newsk;
 	chtls_install_cpl_ops(newsk);
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
index 9098b3eed4da..f3d981ec6573 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
@@ -569,11 +569,8 @@ static int do_chtls_setsockopt(struct sock *sk, int optname,
 static int chtls_setsockopt(struct sock *sk, int level, int optname,
 			    sockptr_t optval, unsigned int optlen)
 {
-	struct tls_context *ctx = tls_get_ctx(sk);
-
 	if (level != SOL_TLS)
-		return ctx->sk_proto->setsockopt(sk, level,
-						 optname, optval, optlen);
+		return -EOPNOTSUPP;
 
 	return do_chtls_setsockopt(sk, optname, optval, optlen);
 }
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 47b7c5334c34..e03eed5f882e 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -718,8 +718,12 @@ static int tls_init(struct sock *sk)
 	tls_build_proto(sk);
 
 #ifdef CONFIG_TLS_TOE
+	/* if tls_toe is supported by a device, return failure
+	 * for this TCP_ULP operation. TLS TOE will take over
+	 * from here.
+	 */
 	if (tls_toe_bypass(sk))
-		return 0;
+		return -EOPNOTSUPP;
 #endif
 
 	/* The TLS ulp is currently supported only for TCP sockets
diff --git a/net/tls/tls_toe.c b/net/tls/tls_toe.c
index 7e1330f19165..21616c2511a7 100644
--- a/net/tls/tls_toe.c
+++ b/net/tls/tls_toe.c
@@ -47,9 +47,13 @@ static void tls_toe_sk_destruct(struct sock *sk)
 	struct tls_context *ctx = tls_get_ctx(sk);
 
 	ctx->sk_destruct(sk);
-	/* Free ctx */
-	rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
-	tls_ctx_free(sk, ctx);
+	/* toe_tls ctx is created only for listen sockets,
+	 * don't free it for any other socket type.
+	 */
+	if (sk->sk_state == TCP_LISTEN) {
+		rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
+		tls_ctx_free(sk, ctx);
+	}
 }
 
 int tls_toe_bypass(struct sock *sk)
@@ -61,15 +65,20 @@ int tls_toe_bypass(struct sock *sk)
 	spin_lock_bh(&device_spinlock);
 	list_for_each_entry(dev, &device_list, dev_list) {
 		if (dev->feature && dev->feature(dev)) {
-			ctx = tls_ctx_create(sk);
-			if (!ctx)
-				goto out;
+			/* ESTABLISHED socket may also reach here, make
+			 * sure new context is not created for that.
+			 */
+			if (sk->sk_state == TCP_CLOSE) {
+				ctx = tls_ctx_create(sk);
+				if (!ctx)
+					goto out;
 
-			ctx->sk_destruct = sk->sk_destruct;
-			sk->sk_destruct = tls_toe_sk_destruct;
-			ctx->rx_conf = TLS_HW_RECORD;
-			ctx->tx_conf = TLS_HW_RECORD;
-			update_sk_prot(sk, ctx);
+				ctx->sk_destruct = sk->sk_destruct;
+				sk->sk_destruct = tls_toe_sk_destruct;
+				ctx->rx_conf = TLS_HW_RECORD;
+				ctx->tx_conf = TLS_HW_RECORD;
+				update_sk_prot(sk, ctx);
+			}
 			rc = 1;
 			break;
 		}
-- 
2.18.1

