Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB592A4367
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgKCKuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:50:01 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:39618 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgKCKuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 05:50:00 -0500
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A3Ann4W008411;
        Tue, 3 Nov 2020 02:49:49 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        borisp@nvidia.com
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net] net/tls: Fix kernel panic when socket is in TLS ULP
Date:   Tue,  3 Nov 2020 16:17:03 +0530
Message-Id: <20201103104702.798-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

user can initialize tls ulp using setsockopt call on socket
before listen() in case of tls-toe (TLS_HW_RECORD) and same
setsockopt call on connected socket in case of kernel tls (TLS_SW).
In presence of tls-toe devices, TLS ulp is initialized, tls context
is allocated per listen socket and socket is listening at adapter
as well as kernel tcp stack. now consider the scenario, connections
are established in kernel stack.
on every connection close which is established in kernel stack,
it clears tls context which is created on listen socket causing
kernel panic.
Addressed the issue by setting child socket to base (non TLS ULP)
when tls ulp is initialized on parent socket (listen socket).

Fixes: 76f7164d02d4 ("net/tls: free ctx in sock destruct")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 .../chelsio/inline_crypto/chtls/chtls_cm.c    |  3 +++
 net/tls/tls_main.c                            | 23 ++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 63aacc184f68..c56cd9c1e40c 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1206,6 +1206,9 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	sk_setup_caps(newsk, dst);
 	ctx = tls_get_ctx(lsk);
 	newsk->sk_destruct = ctx->sk_destruct;
+	newsk->sk_prot = lsk->sk_prot;
+	inet_csk(newsk)->icsk_ulp_ops = inet_csk(lsk)->icsk_ulp_ops;
+	rcu_assign_pointer(inet_csk(newsk)->icsk_ulp_data, ctx);
 	csk->sk = newsk;
 	csk->passive_reap_next = oreq;
 	csk->tx_chan = cxgb4_port_chan(ndev);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 8d93cea99f2c..9682dacae30c 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -715,7 +715,7 @@ static int tls_init(struct sock *sk)
 	tls_build_proto(sk);
 
 #ifdef CONFIG_TLS_TOE
-	if (tls_toe_bypass(sk))
+	if (sk->sk_state == TCP_CLOSE && tls_toe_bypass(sk))
 		return 0;
 #endif
 
@@ -744,6 +744,24 @@ static int tls_init(struct sock *sk)
 	return rc;
 }
 
+#ifdef CONFIG_TLS_TOE
+static void tls_clone(const struct request_sock *req,
+		      struct sock *newsk, const gfp_t priority)
+{
+	struct tls_context *ctx = tls_get_ctx(newsk);
+	struct inet_connection_sock *icsk = inet_csk(newsk);
+
+	/* In presence of TLS TOE devices, TLS ulp is initialized on listen
+	 * socket so lets child socket back to non tls ULP mode because tcp
+	 * connections can happen in non TLS TOE mode.
+	 */
+	newsk->sk_prot = ctx->sk_proto;
+	newsk->sk_destruct = ctx->sk_destruct;
+	icsk->icsk_ulp_ops = NULL;
+	rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
+}
+#endif
+
 static void tls_update(struct sock *sk, struct proto *p,
 		       void (*write_space)(struct sock *sk))
 {
@@ -857,6 +875,9 @@ static struct tcp_ulp_ops tcp_tls_ulp_ops __read_mostly = {
 	.update			= tls_update,
 	.get_info		= tls_get_info,
 	.get_info_size		= tls_get_info_size,
+#ifdef CONFIG_TLS_TOE
+	.clone                  = tls_clone
+#endif
 };
 
 static int __init tls_register(void)
-- 
2.18.1

