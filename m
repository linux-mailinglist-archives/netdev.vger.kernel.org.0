Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740CB36671F
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 10:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbhDUImP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 04:42:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:28332 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231354AbhDUImO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 04:42:14 -0400
IronPort-SDR: f+l9Wj78NpD/RQTmAVr2CkDG/2k+HCYx1LEmFVCou8yLBQbS/OzgKf2DCZeC9WDfdBP0dqbw82
 qiq9AUj+iVOQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9960"; a="182793781"
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="182793781"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 01:41:41 -0700
IronPort-SDR: /fwMw7Aaz+8j1L6wYxFmScfEReB1nmgpeJCTWfKvGnnbkI3h1qiIYaZADDhsfvqJp/tpUFEtIi
 rdWm/MvFW9ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="455249802"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga002.fm.intel.com with ESMTP; 21 Apr 2021 01:41:38 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 1/1] stmmac: intel: set TSO/TBS TX Queues default settings
Date:   Wed, 21 Apr 2021 16:46:06 +0800
Message-Id: <20210421084606.20851-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TSO and TBS cannot coexist, for now we set Intel mGbE controller to use
below TX Queue mapping: TxQ0 uses TSO and the rest of TXQs supports TBS.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index ec140fc4a0f5..844332a2c2e0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -446,6 +446,9 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 
 		/* Disable Priority config by default */
 		plat->tx_queues_cfg[i].use_prio = false;
+		/* Default TX Q0 to use TSO and rest TXQ for TBS */
+		if (i > 0)
+			plat->tx_queues_cfg[i].tbs_en = 1;
 	}
 
 	/* FIFO size is 4096 bytes for 1 tx/rx queue */
-- 
2.25.1

