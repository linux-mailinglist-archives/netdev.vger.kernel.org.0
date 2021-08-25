Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71AF3F6CE8
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 03:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbhHYBFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 21:05:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:4245 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234210AbhHYBFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 21:05:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="196997639"
X-IronPort-AV: E=Sophos;i="5.84,349,1620716400"; 
   d="scan'208";a="196997639"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 18:04:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,349,1620716400"; 
   d="scan'208";a="473679256"
Received: from siang-ilbpg0.png.intel.com ([10.88.227.28])
  by orsmga008.jf.intel.com with ESMTP; 24 Aug 2021 18:04:31 -0700
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
Subject: [PATCH net v2 1/1] net: stmmac: fix kernel panic due to NULL pointer dereference of buf->xdp
Date:   Wed, 25 Aug 2021 08:57:42 +0800
Message-Id: <20210825005742.980267-1-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure a valid XSK buffer before proceed to free the xdp buffer.

The following kernel panic is observed without this patch:

RIP: 0010:xp_free+0x5/0x40
Call Trace:
stmmac_napi_poll_rxtx+0x332/0xb30 [stmmac]
? stmmac_tx_timer+0x3c/0xb0 [stmmac]
net_rx_action+0x13d/0x3d0
__do_softirq+0xfc/0x2fb
? smpboot_register_percpu_thread+0xe0/0xe0
run_ksoftirqd+0x32/0x70
smpboot_thread_fn+0x1d8/0x2c0
kthread+0x169/0x1a0
? kthread_park+0x90/0x90
ret_from_fork+0x1f/0x30
---[ end trace 0000000000000002 ]---

Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Cc: <stable@vger.kernel.org> # 5.13.x
Suggested-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
---
v2 changelog:
 - Add stable@vger.kernel.org in email cc list.
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7b8404a21544..fa90bcdf4e45 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4914,6 +4914,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 
 		prefetch(np);
 
+		/* Ensure a valid XSK buffer before proceed */
+		if (!buf->xdp)
+			break;
+
 		if (priv->extend_desc)
 			stmmac_rx_extended_status(priv, &priv->dev->stats,
 						  &priv->xstats,
@@ -4934,10 +4938,6 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			continue;
 		}
 
-		/* Ensure a valid XSK buffer before proceed */
-		if (!buf->xdp)
-			break;
-
 		/* XSK pool expects RX frame 1:1 mapped to XSK buffer */
 		if (likely(status & rx_not_ls)) {
 			xsk_buff_free(buf->xdp);
-- 
2.25.1

