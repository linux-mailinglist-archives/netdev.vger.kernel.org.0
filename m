Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96F5497C95
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 11:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbiAXKBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 05:01:00 -0500
Received: from mga07.intel.com ([134.134.136.100]:24600 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbiAXKAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 05:00:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643018452; x=1674554452;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Tz1WJ/YY3EwQM6gWrJzFBZDFZsZ1MNsURDEDEz1XInA=;
  b=biYSu5IK/x8T5AC1VXTl/4m8cNVJQdF8yWBhGUcJYf/cN59ExScRyNLo
   Eu+gcv6ffiRH35cXCF4Duri+6u/uWPGDBGr526XYjPf725jwEWyHztKkc
   qGJKXhoRHm6AZlB3JFsTsdpgXCW5WN6Q6kfmHyZG+xOBbZq83bTdfwKNU
   8jfArGVA1nq2ckIopZWiPNOij08Xg+amRS1FwgK1ColoQyVqeHj+7Tq0D
   J/iW7zpw4MSDYdoHrdfYDv/P20ySOLVfhmSkMB0pTh0iBEmy/t3f87ukC
   i9F4ZJC7kWp7yxujLy89EYHhR3Fl1kdjw1JxtvT80nUZO4JD5KkeIF41U
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="309331438"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="309331438"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 02:00:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="519886948"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.13])
  by orsmga007.jf.intel.com with ESMTP; 24 Jan 2022 02:00:40 -0800
From:   Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net 1/2] net: stmmac: configure PTP clock source prior to PTP initialization
Date:   Mon, 24 Jan 2022 17:59:50 +0800
Message-Id: <20220124095951.23845-2-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124095951.23845-1-mohammad.athari.ismail@intel.com>
References: <20220124095951.23845-1-mohammad.athari.ismail@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For Intel platform, it is required to configure PTP clock source prior PTP
initialization in MAC. So, need to move ptp_clk_freq_config execution from
stmmac_ptp_register() to stmmac_init_ptp().

Fixes: 76da35dc99af ("stmmac: intel: Add PSE and PCH PTP clock source selection")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6708ca2aa4f7..d7e261768f73 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -889,6 +889,9 @@ static int stmmac_init_ptp(struct stmmac_priv *priv)
 	bool xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
 	int ret;
 
+	if (priv->plat->ptp_clk_freq_config)
+		priv->plat->ptp_clk_freq_config(priv);
+
 	ret = stmmac_init_tstamp_counter(priv, STMMAC_HWTS_ACTIVE);
 	if (ret)
 		return ret;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 0d24ebd37873..1c9f02f9c317 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -297,9 +297,6 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 {
 	int i;
 
-	if (priv->plat->ptp_clk_freq_config)
-		priv->plat->ptp_clk_freq_config(priv);
-
 	for (i = 0; i < priv->dma_cap.pps_out_num; i++) {
 		if (i >= STMMAC_PPS_MAX)
 			break;
-- 
2.17.1

