Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217A73B8080
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 12:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhF3KCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 06:02:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:60216 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233943AbhF3KCw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 06:02:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="205313909"
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="205313909"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 03:00:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="408505872"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by orsmga006.jf.intel.com with ESMTP; 30 Jun 2021 03:00:18 -0700
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
        linux-kernel@vger.kernel.org, mohammad.athari.ismail@intel.com
Subject: [PATCH v2 net] net: stmmac: Terminate FPE workqueue in suspend
Date:   Wed, 30 Jun 2021 17:59:35 +0800
Message-Id: <20210630095935.29097-1-mohammad.athari.ismail@intel.com>
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
v2 changelog:
- Removed  stable@vger.kernel.org from email cc list.
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

