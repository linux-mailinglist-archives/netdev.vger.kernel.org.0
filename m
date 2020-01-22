Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070BF144E41
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 10:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgAVJK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 04:10:26 -0500
Received: from mga12.intel.com ([192.55.52.136]:54325 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgAVJKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 04:10:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2020 01:10:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,349,1574150400"; 
   d="scan'208";a="244990468"
Received: from unknown (HELO bong5-HP-Z440.png.intel.com) ([10.221.118.166])
  by orsmga002.jf.intel.com with ESMTP; 22 Jan 2020 01:10:21 -0800
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
Subject: [PATCH net v3 2/5] net: stmmac: fix incorrect GMAC_VLAN_TAG register writting in GMAC4+
Date:   Wed, 22 Jan 2020 17:09:33 +0800
Message-Id: <20200122090936.28555-3-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122090936.28555-1-boon.leong.ong@intel.com>
References: <20200122090936.28555-1-boon.leong.ong@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Tan, Tee Min" <tee.min.tan@intel.com>

It should always do a read of current value of GMAC_VLAN_TAG instead of
directly overwriting the register value.

Fixes: c1be0022df0d ("net: stmmac: Add VLAN HASH filtering support in GMAC4+")
Signed-off-by: Tan, Tee Min <tee.min.tan@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 40ca00e596dd..6e3d0ab0ecd6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -736,11 +736,14 @@ static void dwmac4_update_vlan_hash(struct mac_device_info *hw, u32 hash,
 				    __le16 perfect_match, bool is_double)
 {
 	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
 
 	writel(hash, ioaddr + GMAC_VLAN_HASH_TABLE);
 
+	value = readl(ioaddr + GMAC_VLAN_TAG);
+
 	if (hash) {
-		u32 value = GMAC_VLAN_VTHM | GMAC_VLAN_ETV;
+		value |= GMAC_VLAN_VTHM | GMAC_VLAN_ETV;
 		if (is_double) {
 			value |= GMAC_VLAN_EDVLP;
 			value |= GMAC_VLAN_ESVL;
@@ -759,8 +762,6 @@ static void dwmac4_update_vlan_hash(struct mac_device_info *hw, u32 hash,
 
 		writel(value | perfect_match, ioaddr + GMAC_VLAN_TAG);
 	} else {
-		u32 value = readl(ioaddr + GMAC_VLAN_TAG);
-
 		value &= ~(GMAC_VLAN_VTHM | GMAC_VLAN_ETV);
 		value &= ~(GMAC_VLAN_EDVLP | GMAC_VLAN_ESVL);
 		value &= ~GMAC_VLAN_DOVLTC;
-- 
2.17.1

