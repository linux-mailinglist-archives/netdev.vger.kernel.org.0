Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74223350444
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 18:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhCaQO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 12:14:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:34566 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbhCaQON (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 12:14:13 -0400
IronPort-SDR: tKeYW7aSA0P/8fppuSCV/GLY4e4VPfPj5YSJxb3gl36xBlIkMaJejMBDoPUfmHpyC/EZNls8o/
 U2ESZ1c18y0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="188782402"
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="188782402"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 09:14:07 -0700
IronPort-SDR: WrTshGn4jYlIW31Qo/prw/DSgBfhbbbJBQI4nvgqzP3sGhi1KCTPbujTv3VaI3jUVXwAun0FW8
 MshyRnLtO4Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="416292467"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 31 Mar 2021 09:14:07 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.59])
        by linux.intel.com (Postfix) with ESMTP id 9AAD158033E;
        Wed, 31 Mar 2021 09:14:04 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH net-next 1/1] net: stmmac: enable MTL ECC Error Address Status Over-ride by default
Date:   Thu,  1 Apr 2021 00:18:25 +0800
Message-Id: <20210331161825.32100-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

Turn on the MEEAO field of MTL_ECC_Control_Register by default.

As the MTL ECC Error Address Status Over-ride(MEEAO) is set by default,
the following error address fields will hold the last valid address
where the error is detected.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Tan Tee Min <tee.min.tan@intel.com>
Co-developed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 5b010ebfede9..d8c6ff725237 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -192,6 +192,7 @@ int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp)
 
 	/* 1. Enable Safety Features */
 	value = readl(ioaddr + MTL_ECC_CONTROL);
+	value |= MEEAO; /* MTL ECC Error Addr Status Override */
 	value |= TSOEE; /* TSO ECC */
 	value |= MRXPEE; /* MTL RX Parser ECC */
 	value |= MESTEE; /* MTL EST ECC */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
index ff555d8b0cdf..6b2fd37b29ad 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
@@ -98,6 +98,7 @@
 #define ADDR				GENMASK(15, 0)
 #define MTL_RXP_IACC_DATA		0x00000cb4
 #define MTL_ECC_CONTROL			0x00000cc0
+#define MEEAO				BIT(8)
 #define TSOEE				BIT(4)
 #define MRXPEE				BIT(3)
 #define MESTEE				BIT(2)
-- 
2.25.1

