Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FC436F2CB
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 01:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhD2XC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 19:02:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:46036 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhD2XCW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 19:02:22 -0400
IronPort-SDR: KsNG1196CrkiVMs+iBtYzsAMngsWG6waT1KKDX6qJtL16v2+trc8F/yMeSnel6bC+hPOleegXV
 bWeNlK/NQGsA==
X-IronPort-AV: E=McAfee;i="6200,9189,9969"; a="261086319"
X-IronPort-AV: E=Sophos;i="5.82,260,1613462400"; 
   d="scan'208";a="261086319"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2021 16:01:33 -0700
IronPort-SDR: Fs4pZUxMK/8fcBFX0Jb8mob6R/t0PY5ARNLAXFEgVblwdspSkxuzuukhnkHZ/mdnqNPvd9alWr
 2e+5YiWNWk1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,260,1613462400"; 
   d="scan'208";a="455748252"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Apr 2021 16:01:29 -0700
From:   mohammad.athari.ismail@intel.com
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net] net: stmmac: cleared __FPE_REMOVING bit in stmmac_fpe_start_wq()
Date:   Fri, 30 Apr 2021 07:01:04 +0800
Message-Id: <20210429230104.16977-1-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

An issue found when network interface is down and up again, FPE handshake
fails to trigger. This is due to __FPE_REMOVING bit remains being set in
stmmac_fpe_stop_wq() but not cleared in stmmac_fpe_start_wq(). This
cause FPE workqueue task, stmmac_fpe_lp_task() not able to be executed.

To fix this, add clearing __FPE_REMOVING bit in stmmac_fpe_start_wq().

Fixes: 5a5586112b92 ("net: stmmac: support FPE link partner hand-shaking procedure")
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a9a984c57d78..e0b7eebcb512 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3180,6 +3180,7 @@ static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
 	char *name;
 
 	clear_bit(__FPE_TASK_SCHED, &priv->fpe_task_state);
+	clear_bit(__FPE_REMOVING,  &priv->fpe_task_state);
 
 	name = priv->wq_name;
 	sprintf(name, "%s-fpe", priv->dev->name);
-- 
2.17.1

