Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B983A30EC4F
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 07:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhBDGIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 01:08:18 -0500
Received: from mga04.intel.com ([192.55.52.120]:52991 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229752AbhBDGIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 01:08:17 -0500
IronPort-SDR: mLdB/EOCyyJpvIRIPv5CRcuLQTE7hAmSGgIhMX+jULFzjYXuJr/eGQPZaKb/DUjcr3SrvQvB2F
 AC+RB4o3msSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="178617424"
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="178617424"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 22:07:37 -0800
IronPort-SDR: GqenepCZ1VqBBEQ87nyq8OetNlRo6vlCyxXo/qqg4n3Jm1A6yowbrtNYPvD95I4kNJ6Zw4xKcw
 1T+3iZ+3Lyfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="583080137"
Received: from ssid-ilbpg3.png.intel.com ([10.88.227.36])
  by fmsmga005.fm.intel.com with ESMTP; 03 Feb 2021 22:07:34 -0800
From:   Song Yoong Siang <yoong.siang.song@intel.com>
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
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Gomes Vinicius <vinicius.gomes@intel.com>
Subject: [PATCH net 1/1] net: stmmac: set TxQ mode back to DCB after disabling CBS
Date:   Thu,  4 Feb 2021 22:03:16 +0800
Message-Id: <1612447396-20351-1-git-send-email-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

When disable CBS, mode_to_use parameter is not updated even the operation
mode of Tx Queue is changed to Data Centre Bridging (DCB). Therefore,
when tc_setup_cbs() function is called to re-enable CBS, the operation
mode of Tx Queue remains at DCB, which causing CBS fails to work.

This patch updates the value of mode_to_use parameter to MTL_QUEUE_DCB
after operation mode of Tx Queue is changed to DCB in stmmac_dma_qmode()
callback function.

Fixes: 1f705bc61aee ("net: stmmac: Add support for CBS QDISC")
Suggested-by: Gomes, Vinicius <vinicius.gomes@intel.com>
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Signed-off-by: Song, Yoong Siang <yoong.siang.song@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 8ed3b2c..5698554 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -324,7 +324,12 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 
 		priv->plat->tx_queues_cfg[queue].mode_to_use = MTL_QUEUE_AVB;
 	} else if (!qopt->enable) {
-		return stmmac_dma_qmode(priv, priv->ioaddr, queue, MTL_QUEUE_DCB);
+		ret = stmmac_dma_qmode(priv, priv->ioaddr, queue,
+				       MTL_QUEUE_DCB);
+		if (ret)
+			return ret;
+
+		priv->plat->tx_queues_cfg[queue].mode_to_use = MTL_QUEUE_DCB;
 	}
 
 	/* Port Transmit Rate and Speed Divider */
-- 
2.7.4

