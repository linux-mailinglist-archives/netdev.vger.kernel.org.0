Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9671527C6
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 09:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgBEIzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 03:55:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:48635 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728107AbgBEIzq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 03:55:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 00:55:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,405,1574150400"; 
   d="scan'208";a="264149203"
Received: from unknown (HELO bong5-HP-Z440.png.intel.com) ([10.221.118.166])
  by fmsmga002.fm.intel.com with ESMTP; 05 Feb 2020 00:55:42 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     netdev@vger.kernel.org
Cc:     Tan Tee Min <tee.min.tan@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v4 4/6] net: stmmac: fix missing IFF_MULTICAST check in dwmac4_set_filter
Date:   Wed,  5 Feb 2020 16:55:08 +0800
Message-Id: <20200205085510.32353-5-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200205085510.32353-1-boon.leong.ong@intel.com>
References: <20200205085510.32353-1-boon.leong.ong@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Verma, Aashish" <aashishx.verma@intel.com>

Without checking for IFF_MULTICAST flag, it is wrong to assume multicast
filtering is always enabled. By checking against IFF_MULTICAST, now
the driver behaves correctly when the multicast support is toggled by below
command:-
  ip link set <devname> multicast off|on

Fixes: 477286b53f55 ("stmmac: add GMAC4 core support")
Signed-off-by: Verma, Aashish <aashishx.verma@intel.com>
Tested-by: Tan, Tee Min <tee.min.tan@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 4d8eef9ff137..dc09d2131e40 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -420,7 +420,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 		value |= GMAC_PACKET_FILTER_PM;
 		/* Set all the bits of the HASH tab */
 		memset(mc_filter, 0xff, sizeof(mc_filter));
-	} else if (!netdev_mc_empty(dev)) {
+	} else if (!netdev_mc_empty(dev) && (dev->flags & IFF_MULTICAST)) {
 		struct netdev_hw_addr *ha;
 
 		/* Hash filter for multicast */
-- 
2.17.1

