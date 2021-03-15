Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0449F33AAD7
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 06:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhCOFYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 01:24:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:59451 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhCOFXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 01:23:51 -0400
IronPort-SDR: xi6NYwcu5tT5rr0u6BvVdnNN4S/HNb2Mac2akA28ZXb56O3wsTbbCrPl5jiguTNmDruNivJFoR
 P+WDBD73u0JA==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="253054437"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="253054437"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 22:23:51 -0700
IronPort-SDR: BqcOxkLjuot/FprQQm7kYbqmSY0YPwIjfXl8opJS6IeVMmfPCaW9ogyz8VeyHCQTS0D5Rdcyq7
 5ZK0niJA+6dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="373313790"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga006.jf.intel.com with ESMTP; 14 Mar 2021 22:23:46 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King i <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: [PATCH net-next 5/6] net: stmmac: ensure phydev is attached to phylink for C37 AN
Date:   Mon, 15 Mar 2021 13:27:10 +0800
Message-Id: <20210315052711.16728-6-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315052711.16728-1-boon.leong.ong@intel.com>
References: <20210315052711.16728-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the support for MAC-side SGMII C37 AN is added to pcs-xpcs, phydev
should be attached to phylink during driver's open(). So, we change the
condition to "Not C73 AN" instead.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b64ee029d41f..e58ff652e95f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2898,7 +2898,7 @@ static int stmmac_open(struct net_device *dev)
 
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI &&
-	    priv->hw->xpcs == NULL) {
+	    priv->hw->xpcs_args.an_mode != DW_AN_C73) {
 		ret = stmmac_init_phy(dev);
 		if (ret) {
 			netdev_err(priv->dev,
-- 
2.25.1

