Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFB58CCCD
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 09:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbfHNH2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 03:28:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:54619 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbfHNH2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 03:28:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 00:28:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,384,1559545200"; 
   d="scan'208";a="327923132"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.52.109])
  by orsmga004.jf.intel.com with ESMTP; 14 Aug 2019 00:28:44 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com,
        maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, jonathan.lemon@gmail.com,
        kiran.patil@intel.com, axboe@kernel.dk,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v4 8/8] net/mlx5e: Add AF_XDP need_wakeup support
Date:   Wed, 14 Aug 2019 09:27:23 +0200
Message-Id: <1565767643-4908-9-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

This commit adds support for the new need_wakeup feature of AF_XDP. The
applications can opt-in by using the XDP_USE_NEED_WAKEUP bind() flag.
When this feature is enabled, some behavior changes:

RX side: If the Fill Ring is empty, instead of busy-polling, set the
flag to tell the application to kick the driver when it refills the Fill
Ring.

TX side: If there are pending completions or packets queued for
transmission, set the flag to tell the application that it can skip the
sendto() syscall and save time.

The performance testing was performed on a machine with the following
configuration:

- 24 cores of Intel Xeon E5-2620 v3 @ 2.40 GHz
- Mellanox ConnectX-5 Ex with 100 Gbit/s link

The results with retpoline disabled:

       | without need_wakeup  | with need_wakeup     |
       |----------------------|----------------------|
       | one core | two cores | one core | two cores |
-------|----------|-----------|----------|-----------|
txonly | 20.1     | 33.5      | 29.0     | 34.2      |
rxdrop | 0.065    | 14.1      | 12.0     | 14.1      |
l2fwd  | 0.032    | 7.3       | 6.6      | 7.2       |

"One core" means the application and NAPI run on the same core. "Two
cores" means they are pinned to different cores.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h | 14 ++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h | 12 ++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     |  7 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c   | 20 +++++++++++++++++---
 4 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index 307b923..cab0e93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -5,6 +5,7 @@
 #define __MLX5_EN_XSK_RX_H__
 
 #include "en.h"
+#include <net/xdp_sock.h>
 
 /* RX data path */
 
@@ -24,4 +25,17 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      struct mlx5e_wqe_frag_info *wi,
 					      u32 cqe_bcnt);
 
+static inline bool mlx5e_xsk_update_rx_wakeup(struct mlx5e_rq *rq, bool alloc_err)
+{
+	if (!xsk_umem_uses_need_wakeup(rq->umem))
+		return alloc_err;
+
+	if (unlikely(alloc_err))
+		xsk_set_rx_need_wakeup(rq->umem);
+	else
+		xsk_clear_rx_need_wakeup(rq->umem);
+
+	return false;
+}
+
 #endif /* __MLX5_EN_XSK_RX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
index 9c50515..79b487d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
@@ -5,6 +5,7 @@
 #define __MLX5_EN_XSK_TX_H__
 
 #include "en.h"
+#include <net/xdp_sock.h>
 
 /* TX data path */
 
@@ -12,4 +13,15 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags);
 
 bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget);
 
+static inline void mlx5e_xsk_update_tx_wakeup(struct mlx5e_xdpsq *sq)
+{
+	if (!xsk_umem_uses_need_wakeup(sq->umem))
+		return;
+
+	if (sq->pc != sq->cc)
+		xsk_clear_tx_need_wakeup(sq->umem);
+	else
+		xsk_set_tx_need_wakeup(sq->umem);
+}
+
 #endif /* __MLX5_EN_XSK_TX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 60570b4..fae0694 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -692,8 +692,11 @@ bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 	rq->mpwqe.umr_in_progress += rq->mpwqe.umr_last_bulk;
 	rq->mpwqe.actual_wq_head   = head;
 
-	/* If XSK Fill Ring doesn't have enough frames, busy poll by
-	 * rescheduling the NAPI poll.
+	/* If XSK Fill Ring doesn't have enough frames, report the error, so
+	 * that one of the actions can be performed:
+	 * 1. If need_wakeup is used, signal that the application has to kick
+	 * the driver when it refills the Fill Ring.
+	 * 2. Otherwise, busy poll by rescheduling the NAPI poll.
 	 */
 	if (unlikely(alloc_err == -ENOMEM && rq->umem))
 		return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 6d16dee..257a7c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -33,6 +33,7 @@
 #include <linux/irq.h>
 #include "en.h"
 #include "en/xdp.h"
+#include "en/xsk/rx.h"
 #include "en/xsk/tx.h"
 
 static inline bool mlx5e_channel_no_affinity_change(struct mlx5e_channel *c)
@@ -83,10 +84,23 @@ void mlx5e_trigger_irq(struct mlx5e_icosq *sq)
 
 static bool mlx5e_napi_xsk_post(struct mlx5e_xdpsq *xsksq, struct mlx5e_rq *xskrq)
 {
-	bool busy_xsk = false;
-
+	bool busy_xsk = false, xsk_rx_alloc_err;
+
+	/* Handle the race between the application querying need_wakeup and the
+	 * driver setting it:
+	 * 1. Update need_wakeup both before and after the TX. If it goes to
+	 * "yes", it can only happen with the first update.
+	 * 2. If the application queried need_wakeup before we set it, the
+	 * packets will be transmitted anyway, even w/o a wakeup.
+	 * 3. Give a chance to clear need_wakeup after new packets were queued
+	 * for TX.
+	 */
+	mlx5e_xsk_update_tx_wakeup(xsksq);
 	busy_xsk |= mlx5e_xsk_tx(xsksq, MLX5E_TX_XSK_POLL_BUDGET);
-	busy_xsk |= xskrq->post_wqes(xskrq);
+	mlx5e_xsk_update_tx_wakeup(xsksq);
+
+	xsk_rx_alloc_err = xskrq->post_wqes(xskrq);
+	busy_xsk |= mlx5e_xsk_update_rx_wakeup(xskrq, xsk_rx_alloc_err);
 
 	return busy_xsk;
 }
-- 
2.7.4

