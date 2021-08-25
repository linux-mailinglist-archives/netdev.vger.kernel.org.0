Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320633F6CE3
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 03:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbhHYBDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 21:03:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:2753 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234058AbhHYBDJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 21:03:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="215583432"
X-IronPort-AV: E=Sophos;i="5.84,349,1620716400"; 
   d="scan'208";a="215583432"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 18:02:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,349,1620716400"; 
   d="scan'208";a="507828430"
Received: from siang-ilbpg0.png.intel.com ([10.88.227.28])
  by orsmga001.jf.intel.com with ESMTP; 24 Aug 2021 18:02:18 -0700
From:   Song Yoong Siang <yoong.siang.song@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net v2 1/1] net: stmmac: fix kernel panic due to NULL pointer dereference of xsk_pool
Date:   Wed, 25 Aug 2021 08:55:29 +0800
Message-Id: <20210825005529.980109-1-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After free xsk_pool, there is possibility that napi polling is still
running in the middle, thus causes a kernel crash due to kernel NULL
pointer dereference of rx_q->xsk_pool and tx_q->xsk_pool.

Fix this by changing the XDP pool setup sequence to:
 1. disable napi before free xsk_pool
 2. enable napi after init xsk_pool

The following kernel panic is observed without this patch:

RIP: 0010:xsk_uses_need_wakeup+0x5/0x10
Call Trace:
stmmac_napi_poll_rxtx+0x3a9/0xae0 [stmmac]
__napi_poll+0x27/0x130
net_rx_action+0x233/0x280
__do_softirq+0xe2/0x2b6
run_ksoftirqd+0x1a/0x20
smpboot_thread_fn+0xac/0x140
? sort_range+0x20/0x20
kthread+0x124/0x150
? set_kthread_struct+0x40/0x40
ret_from_fork+0x1f/0x30
---[ end trace a77c8956b79ac107 ]---

Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Cc: <stable@vger.kernel.org> # 5.13.x
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
---
v2 changelog:
 - Add stable@vger.kernel.org in email cc list.
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
index 105821b53020..2a616c6f7cd0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
@@ -34,18 +34,18 @@ static int stmmac_xdp_enable_pool(struct stmmac_priv *priv,
 	need_update = netif_running(priv->dev) && stmmac_xdp_is_enabled(priv);
 
 	if (need_update) {
-		stmmac_disable_rx_queue(priv, queue);
-		stmmac_disable_tx_queue(priv, queue);
 		napi_disable(&ch->rx_napi);
 		napi_disable(&ch->tx_napi);
+		stmmac_disable_rx_queue(priv, queue);
+		stmmac_disable_tx_queue(priv, queue);
 	}
 
 	set_bit(queue, priv->af_xdp_zc_qps);
 
 	if (need_update) {
-		napi_enable(&ch->rxtx_napi);
 		stmmac_enable_rx_queue(priv, queue);
 		stmmac_enable_tx_queue(priv, queue);
+		napi_enable(&ch->rxtx_napi);
 
 		err = stmmac_xsk_wakeup(priv->dev, queue, XDP_WAKEUP_RX);
 		if (err)
@@ -72,10 +72,10 @@ static int stmmac_xdp_disable_pool(struct stmmac_priv *priv, u16 queue)
 	need_update = netif_running(priv->dev) && stmmac_xdp_is_enabled(priv);
 
 	if (need_update) {
+		napi_disable(&ch->rxtx_napi);
 		stmmac_disable_rx_queue(priv, queue);
 		stmmac_disable_tx_queue(priv, queue);
 		synchronize_rcu();
-		napi_disable(&ch->rxtx_napi);
 	}
 
 	xsk_pool_dma_unmap(pool, STMMAC_RX_DMA_ATTR);
@@ -83,10 +83,10 @@ static int stmmac_xdp_disable_pool(struct stmmac_priv *priv, u16 queue)
 	clear_bit(queue, priv->af_xdp_zc_qps);
 
 	if (need_update) {
-		napi_enable(&ch->rx_napi);
-		napi_enable(&ch->tx_napi);
 		stmmac_enable_rx_queue(priv, queue);
 		stmmac_enable_tx_queue(priv, queue);
+		napi_enable(&ch->rx_napi);
+		napi_enable(&ch->tx_napi);
 	}
 
 	return 0;
-- 
2.25.1

