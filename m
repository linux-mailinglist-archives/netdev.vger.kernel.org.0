Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB5338CCCB
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 09:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfHNH2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 03:28:45 -0400
Received: from mga05.intel.com ([192.55.52.43]:36054 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfHNH2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 03:28:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 00:28:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,384,1559545200"; 
   d="scan'208";a="327923120"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.52.109])
  by orsmga004.jf.intel.com with ESMTP; 14 Aug 2019 00:28:38 -0700
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
Subject: [PATCH bpf-next v4 7/8] net/mlx5e: Move the SW XSK code from NAPI poll to a separate function
Date:   Wed, 14 Aug 2019 09:27:22 +0200
Message-Id: <1565767643-4908-8-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Two XSK tasks are performed during NAPI polling, that are not bound to
hardware interrupts: TXing packets and polling for frames in the Fill
Ring. They are special in a way that the hardware doesn't know about
these tasks, so it doesn't trigger interrupts if there is still some
work to be done, it's our driver's responsibility to ensure NAPI will be
rescheduled if needed.

Create a new function to handle these tasks and move the corresponding
code from mlx5e_napi_poll to the new function to improve modularity and
prepare for the changes in the following patch.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 49b06b2..6d16dee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -81,6 +81,16 @@ void mlx5e_trigger_irq(struct mlx5e_icosq *sq)
 	mlx5e_notify_hw(wq, sq->pc, sq->uar_map, &nopwqe->ctrl);
 }
 
+static bool mlx5e_napi_xsk_post(struct mlx5e_xdpsq *xsksq, struct mlx5e_rq *xskrq)
+{
+	bool busy_xsk = false;
+
+	busy_xsk |= mlx5e_xsk_tx(xsksq, MLX5E_TX_XSK_POLL_BUDGET);
+	busy_xsk |= xskrq->post_wqes(xskrq);
+
+	return busy_xsk;
+}
+
 int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 {
 	struct mlx5e_channel *c = container_of(napi, struct mlx5e_channel,
@@ -122,8 +132,7 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	if (xsk_open) {
 		mlx5e_poll_ico_cq(&c->xskicosq.cq);
 		busy |= mlx5e_poll_xdpsq_cq(&xsksq->cq);
-		busy_xsk |= mlx5e_xsk_tx(xsksq, MLX5E_TX_XSK_POLL_BUDGET);
-		busy_xsk |= xskrq->post_wqes(xskrq);
+		busy_xsk |= mlx5e_napi_xsk_post(xsksq, xskrq);
 	}
 
 	busy |= busy_xsk;
-- 
2.7.4

