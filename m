Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274E82B07C2
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 15:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgKLOq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 09:46:56 -0500
Received: from mga04.intel.com ([192.55.52.120]:7611 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgKLOq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 09:46:56 -0500
IronPort-SDR: 47AGfwby7pqgs741ZXuNwz4PKKFJZECacy4eNuIFMFjqWaXheCYgLR2MgXuW38XVDS1CNBvnHA
 DR4QBXJgC01Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="167733312"
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="167733312"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 06:46:49 -0800
IronPort-SDR: 7V223IaaLcQCP6ubSZGmGlFxIEdqv5gHZwMaWWRbbfsmwzTaJ4G6lYKc8huSCGztJzQIF3v6Yp
 BRlOkeYGO9fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="366356228"
Received: from glass.png.intel.com ([172.30.181.98])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Nov 2020 06:46:45 -0800
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
Subject: [PATCH net 1/1] net: stmmac: Use rtnl_lock/unlock on netif_set_real_num_rx_queues() call
Date:   Thu, 12 Nov 2020 22:49:48 +0800
Message-Id: <20201112144948.3042-1-vee.khee.wong@intel.com>
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ba855465a2db..33e280040000 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5278,7 +5278,10 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_clear_descriptors(priv);
 
+	rtnl_lock();
 	stmmac_hw_setup(ndev, false);
+	rtnl_unlock();
+
 	stmmac_init_coalesce(priv);
 	stmmac_set_rx_mode(ndev);
 
-- 
2.17.0

