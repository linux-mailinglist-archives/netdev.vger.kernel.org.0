Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9577249ADB4
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446221AbiAYHgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:36:43 -0500
Received: from mga05.intel.com ([192.55.52.43]:18809 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354037AbiAYDc6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 22:32:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643081578; x=1674617578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Tz1WJ/YY3EwQM6gWrJzFBZDFZsZ1MNsURDEDEz1XInA=;
  b=jZHTnO1zYSbJeGU+pF1OGuCYOR8iw7ugseA0MQjRLriNHJbHu2MtbjMY
   avO9zV/xSQL1l+uIbiY24s0iOZPmSrkTd1Ea9DeHKjbhHfV+vdphNWmHC
   U6fzwzJZt4054Ymb8C5H70Z/htAOdqNugDnZOZcjRs1xMRzAtuZBDyH/z
   fBRmgIswFhj2K9sxWtJTGlBzN4+W78xIx0rVboB0E0L730X7pIH5ILnOO
   Z+UfTcCy7y1ueMMKZZ3Wh2QGiO2IdP5VQNjE3fXBgb/Ltlh6oENhNnyyi
   aafRieScN1uK6HuvmEWJ/tvLCJqXHaWDVgflOS6JiqmZVXbWCju0GeULV
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="332562390"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="332562390"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 19:24:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="532293067"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.13])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jan 2022 19:24:15 -0800
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
        Huacai Chen <chenhuacai@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, mohammad.athari.ismail@intel.com
Subject: [PATCH net 1/2] net: stmmac: configure PTP clock source prior to PTP initialization
Date:   Tue, 25 Jan 2022 11:23:23 +0800
Message-Id: <20220125032324.4055-2-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220125032324.4055-1-mohammad.athari.ismail@intel.com>
References: <20220125032324.4055-1-mohammad.athari.ismail@intel.com>
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

