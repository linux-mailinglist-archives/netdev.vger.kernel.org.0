Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDEB4549E6
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 16:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbhKQPcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 10:32:39 -0500
Received: from mga14.intel.com ([192.55.52.115]:19452 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237048AbhKQPcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 10:32:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="234203472"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="234203472"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 07:29:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="586680506"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Nov 2021 07:29:33 -0800
Received: from alobakin-mobl.ger.corp.intel.com (alobakin-mobl.ger.corp.intel.com [10.237.140.117])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1AHFTWOf004941;
        Wed, 17 Nov 2021 15:29:32 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] stmmac: fix build due to brainos in trans_start changes
Date:   Wed, 17 Nov 2021 16:29:17 +0100
Message-Id: <20211117152917.3739-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

txq_trans_cond_update() takes netdev_tx_queue *nq,
not nq->trans_start.

Fixes: 5337824f4dc4 ("net: annotate accesses to queue->trans_start")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 389d125310c1..41e9d8838f05 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2356,7 +2356,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 	bool work_done = true;
 
 	/* Avoids TX time-out as we are sharing with slow path */
-	txq_trans_cond_update(nq->trans_start);
+	txq_trans_cond_update(nq);
 
 	budget = min(budget, stmmac_tx_avail(priv, queue));
 
@@ -4657,7 +4657,7 @@ static int stmmac_xdp_xmit_back(struct stmmac_priv *priv,
 
 	__netif_tx_lock(nq, cpu);
 	/* Avoids TX time-out as we are sharing with slow path */
-	txq_trans_cond_update(nq->trans_start);
+	txq_trans_cond_update(nq);
 
 	res = stmmac_xdp_xmit_xdpf(priv, queue, xdpf, false);
 	if (res == STMMAC_XDP_TX)
-- 
2.33.1

