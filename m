Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C213AE658
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 11:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFUJsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 05:48:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:3842 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhFUJsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 05:48:15 -0400
IronPort-SDR: ACKINIfdYFznCtK5tu8GZSp/ZmGJga/zHav6t9gh2QtbWfFvweCqGdsqCnfjDAmp9BjkzeEzy/
 1TGPs5XuBcOA==
X-IronPort-AV: E=McAfee;i="6200,9189,10021"; a="194122097"
X-IronPort-AV: E=Sophos;i="5.83,289,1616482800"; 
   d="scan'208";a="194122097"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 02:45:57 -0700
IronPort-SDR: UYcFbSaQpm9HP8pM6XRraAIQTHeKL9oInUzshZB5a+JJ/FV65qNZQVGpiocM2/Rs0dUiJ9nNoP
 TGDPEiytJ4pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,289,1616482800"; 
   d="scan'208";a="638720260"
Received: from peileeli.png.intel.com ([172.30.240.12])
  by fmsmga006.fm.intel.com with ESMTP; 21 Jun 2021 02:45:52 -0700
From:   Ling Pei Lee <pei.lee.ling@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     pei.lee.ling@intel.com
Subject: [PATCH net-next V1 1/4] net: stmmac: option to enable PHY WOL with PMT enabled
Date:   Mon, 21 Jun 2021 17:45:33 +0800
Message-Id: <20210621094536.387442-2-pei.lee.ling@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210621094536.387442-1-pei.lee.ling@intel.com>
References: <20210621094536.387442-1-pei.lee.ling@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current stmmac driver WOL implementation will enable MAC WOL
if MAC HW PMT feature is on. Else, the driver will check for
PHY WOL support. There is another case where MAC HW PMT is
enabled but the platform still goes for the PHY WOL option.
E.g, Intel platform are designed for PHY WOL but not MAC WOL
although HW MAC PMT features are enabled.

Introduce use_phy_wol platform data to select PHY WOL
instead of depending on HW PMT features. Set use_phy_wol
will disable the plat->pmt which currently used to
determine the system to wake up by MAC WOL or PHY WOL.

Signed-off-by: Ling Pei Lee <pei.lee.ling@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 include/linux/stmmac.h                            | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0a266fa0af7e..a3b79ddcf08e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6533,7 +6533,8 @@ static int stmmac_hw_init(struct stmmac_priv *priv)
 		 * register (if supported).
 		 */
 		priv->plat->enh_desc = priv->dma_cap.enh_desc;
-		priv->plat->pmt = priv->dma_cap.pmt_remote_wake_up;
+		priv->plat->pmt = priv->dma_cap.pmt_remote_wake_up &&
+				!priv->plat->use_phy_wol;
 		priv->hw->pmt = priv->plat->pmt;
 		if (priv->dma_cap.hash_tb_sz) {
 			priv->hw->multicast_filter_bins =
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index e55a4807e3ea..9496e6c9ee82 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -263,5 +263,6 @@ struct plat_stmmacenet_data {
 	int msi_sfty_ue_vec;
 	int msi_rx_base_vec;
 	int msi_tx_base_vec;
+	bool use_phy_wol;
 };
 #endif
-- 
2.25.1

