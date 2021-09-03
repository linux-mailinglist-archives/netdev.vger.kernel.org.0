Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006EB3FF8C9
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 04:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344750AbhICCIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 22:08:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:31374 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232931AbhICCIW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 22:08:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="206422289"
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="206422289"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 19:07:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="691781879"
Received: from siang-ilbpg0.png.intel.com ([10.88.227.28])
  by fmsmga005.fm.intel.com with ESMTP; 02 Sep 2021 19:07:18 -0700
From:   Song Yoong Siang <yoong.siang.song@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net 1/1] net: stmmac: Fix overall budget calculation for rxtx_napi
Date:   Fri,  3 Sep 2021 10:00:26 +0800
Message-Id: <20210903020026.1381962-1-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tx_done is not used for napi_complete_done(). Thus, NAPI busy polling
mechanism by gro_flush_timeout and napi_defer_hard_irqs will not able
be triggered after a packet is transmitted when there is no receive
packet.

Fix this by taking the maximum value between tx_done and rx_done as
overall budget completed by the rxtx NAPI poll to ensure XDP Tx ZC
operation is continuously polling for next Tx frame. This gives
benefit of lower packet submission processing latency and jitter
under XDP Tx ZC mode.

Performance of tx-only using xdp-sock on Intel ADL-S platform is
the same with and without this patch.

root@intel-corei7-64:~# ./xdpsock -i enp0s30f4 -t -z -q 1 -n 10
 sock0@enp0s30f4:1 txonly xdp-drv
                   pps            pkts           10.00
rx                 0              0
tx                 511630         8659520

 sock0@enp0s30f4:1 txonly xdp-drv
                   pps            pkts           10.00
rx                 0              0
tx                 511625         13775808

 sock0@enp0s30f4:1 txonly xdp-drv
                   pps            pkts           10.00
rx                 0              0
tx                 511619         18892032

Fixes: 132c32ee5bc0 ("net: stmmac: Add TX via XDP zero-copy socket")
Cc: <stable@vger.kernel.org> # 5.13.x
Co-developed-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ed0cd3920171..97238359e101 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5347,7 +5347,7 @@ static int stmmac_napi_poll_rxtx(struct napi_struct *napi, int budget)
 	struct stmmac_channel *ch =
 		container_of(napi, struct stmmac_channel, rxtx_napi);
 	struct stmmac_priv *priv = ch->priv_data;
-	int rx_done, tx_done;
+	int rx_done, tx_done, rxtx_done;
 	u32 chan = ch->index;
 
 	priv->xstats.napi_poll++;
@@ -5357,14 +5357,16 @@ static int stmmac_napi_poll_rxtx(struct napi_struct *napi, int budget)
 
 	rx_done = stmmac_rx_zc(priv, budget, chan);
 
+	rxtx_done = max(tx_done, rx_done);
+
 	/* If either TX or RX work is not complete, return budget
 	 * and keep pooling
 	 */
-	if (tx_done >= budget || rx_done >= budget)
+	if (rxtx_done >= budget)
 		return budget;
 
 	/* all work done, exit the polling mode */
-	if (napi_complete_done(napi, rx_done)) {
+	if (napi_complete_done(napi, rxtx_done)) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&ch->lock, flags);
@@ -5375,7 +5377,7 @@ static int stmmac_napi_poll_rxtx(struct napi_struct *napi, int budget)
 		spin_unlock_irqrestore(&ch->lock, flags);
 	}
 
-	return min(rx_done, budget - 1);
+	return min(rxtx_done, budget - 1);
 }
 
 /**
-- 
2.25.1

