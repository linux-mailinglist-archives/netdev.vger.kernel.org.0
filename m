Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AE83B7FD9
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 11:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhF3JVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 05:21:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:37800 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233849AbhF3JVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 05:21:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="293954425"
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="293954425"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 02:18:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="489530422"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by orsmga001.jf.intel.com with ESMTP; 30 Jun 2021 02:18:36 -0700
From:   mohammad.athari.ismail@intel.com
To:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net] net: stmmac: Terminate FPE workqueue in suspend
Date:   Wed, 30 Jun 2021 17:17:54 +0800
Message-Id: <20210630091754.23423-1-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

Add stmmac_fpe_stop_wq() in stmmac_suspend() to terminate FPE workqueue
during suspend. So, in suspend mode, there will be no FPE workqueue
available. Without this fix, new additional FPE workqueue will be created
in every suspend->resume cycle.

Fixes: 5a5586112b92 ("net: stmmac: support FPE link partner hand-shaking procedure")
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c87202cbd3d6..796ad594543d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7170,6 +7170,7 @@ int stmmac_suspend(struct device *dev)
 				     priv->plat->rx_queues_to_use, false);
 
 		stmmac_fpe_handshake(priv, false);
+		stmmac_fpe_stop_wq(priv);
 	}
 
 	priv->speed = SPEED_UNKNOWN;
-- 
2.17.1

