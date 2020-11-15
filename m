Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FF02B32D9
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 08:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgKOHjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 02:39:09 -0500
Received: from mga04.intel.com ([192.55.52.120]:52336 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgKOHjJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 02:39:09 -0500
IronPort-SDR: wxyNbdlvlqA8m7aTpOn2KdYWc2WtMTLl4Ng1VPj1Rdj6voDAvkRzInkKgfWf1/jABgDdl8o73Y
 mJLeVbyaHJBA==
X-IronPort-AV: E=McAfee;i="6000,8403,9805"; a="168050188"
X-IronPort-AV: E=Sophos;i="5.77,479,1596524400"; 
   d="scan'208";a="168050188"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2020 23:39:08 -0800
IronPort-SDR: 1PWLKPx+ILB4Z7PKdGv3btmqqAenr4VbrHzlnTFWgn38go0Cbgb4borWqG52M6ZoGMt2mFoDkq
 GoXTj+qfzNmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,479,1596524400"; 
   d="scan'208";a="367367170"
Received: from glass.png.intel.com ([172.30.181.98])
  by orsmga007.jf.intel.com with ESMTP; 14 Nov 2020 23:39:04 -0800
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Christophe ROULLIER <christophe.roullier@st.com>
Subject: [PATCH v2 net 1/1] net: stmmac: Use rtnl_lock/unlock on netif_set_real_num_rx_queues() call
Date:   Sun, 15 Nov 2020 15:42:10 +0800
Message-Id: <20201115074210.23605-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix an issue where dump stack is printed on suspend resume flow due to
netif_set_real_num_rx_queues() is not called with rtnl_lock held().

Fixes: 686cff3d7022 ("net: stmmac: Fix incorrect location to set real_num_rx|tx_queues")
Reported-by: Christophe ROULLIER <christophe.roullier@st.com>
Tested-by: Christophe ROULLIER <christophe.roullier@st.com>
Cc: Alexandre TORGUE <alexandre.torgue@st.com>
Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
---
v2 changelog:
- Move rtnl_lock() before priv->lock and release it after to avoid a
  possible ABBA deadlock scenario.
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ba855465a2db..c8770e9668a1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5272,6 +5272,7 @@ int stmmac_resume(struct device *dev)
 			return ret;
 	}
 
+	rtnl_lock();
 	mutex_lock(&priv->lock);
 
 	stmmac_reset_queues_param(priv);
@@ -5287,6 +5288,7 @@ int stmmac_resume(struct device *dev)
 	stmmac_enable_all_queues(priv);
 
 	mutex_unlock(&priv->lock);
+	rtnl_unlock();
 
 	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
 		rtnl_lock();
-- 
2.17.0

