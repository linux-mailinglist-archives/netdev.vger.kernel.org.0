Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7815C372529
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 06:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhEDEkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 00:40:18 -0400
Received: from mga17.intel.com ([192.55.52.151]:49602 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhEDEkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 00:40:17 -0400
IronPort-SDR: 1ZH8AFgq97vdI+SfcHTSqi976EgDJAzEMrXmu55vzx8rMyIQXRjB6nMTeOlN3Mg69cIOcBmCyT
 qd0HxH2moIfw==
X-IronPort-AV: E=McAfee;i="6200,9189,9973"; a="178107188"
X-IronPort-AV: E=Sophos;i="5.82,271,1613462400"; 
   d="scan'208";a="178107188"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 21:39:23 -0700
IronPort-SDR: hojtwMwQeNiR593ORTkypqOZ9gZwUJ+9pdBSRBrRObwNbyFut3j2a1fvElPqa1dUNEShOSUv4T
 thd6Gus9d97Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,271,1613462400"; 
   d="scan'208";a="395990371"
Received: from intel-z390-ud.iind.intel.com ([10.223.96.21])
  by fmsmga007.fm.intel.com with ESMTP; 03 May 2021 21:39:19 -0700
From:   Ramesh Babu B <ramesh.Babu.B@intel.com>
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
        Ramesh Babu B <ramesh.Babu.B@intel.com>
Subject: [PATCH net 1/1] net: stmmac: Clear receive all(RA) bit when promiscuous mode is off
Date:   Tue,  4 May 2021 21:12:41 +0530
Message-Id: <20210504154241.1165-1-ramesh.Babu.B@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ramesh Babu B <ramesh.babu.b@intel.com>

In promiscuous mode Receive All bit is set in GMAC packet filter register,
but outside promiscuous mode Receive All bit is not cleared,
which resulted in all network packets are received when toggle (ON/OFF)
the promiscuous mode.

Fixes: e0f9956a3862 ("net: stmmac: Add option for VLAN filter fail queue enable")
Signed-off-by: Ramesh Babu B <ramesh.babu.b@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 95864f014ffa..f35c03c9f91e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -642,6 +642,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	value &= ~GMAC_PACKET_FILTER_PCF;
 	value &= ~GMAC_PACKET_FILTER_PM;
 	value &= ~GMAC_PACKET_FILTER_PR;
+	value &= ~GMAC_PACKET_FILTER_RA;
 	if (dev->flags & IFF_PROMISC) {
 		/* VLAN Tag Filter Fail Packets Queuing */
 		if (hw->vlan_fail_q_en) {
-- 
2.17.1

