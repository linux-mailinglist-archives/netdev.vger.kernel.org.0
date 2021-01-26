Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F6B303871
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 09:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387875AbhAZI4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 03:56:21 -0500
Received: from mga07.intel.com ([134.134.136.100]:43131 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728161AbhAZIzn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 03:55:43 -0500
IronPort-SDR: KKL/ZWufeUk/aISqYHmG5FDkdh3TApN0Fpde8RGFVvUxvqSGWeJg5nq1Csuexc1lDb2tzYFPuv
 ibUQrdI+7yZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="243950321"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="243950321"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 00:54:53 -0800
IronPort-SDR: HiSh2Eab8nbapDkJt/yoex7HLrUMn5c6fcYl8n6fDvfcicaBSFH5j4xuk/qLprrEo+P/BqLUc8
 LTbakaIISQ5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="393680509"
Received: from glass.png.intel.com ([10.158.65.51])
  by orsmga007.jf.intel.com with ESMTP; 26 Jan 2021 00:54:49 -0800
From:   Wong Vee Khee <vee.khee.wong@intel.com>
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
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH net-next 1/1] stmmac: intel: Add ADL-S 1Gbps PCI IDs
Date:   Tue, 26 Jan 2021 16:58:32 +0800
Message-Id: <20210126085832.3814-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Wong, Vee Khee" <vee.khee.wong@intel.com>

Added PCI IDs for both Ethernet TSN Controllers on the ADL-S.

Also, skip SerDes programming sequences as these are being carried out
at the BIOS level for ADL-S.

Signed-off-by: Wong, Vee Khee <vee.khee.wong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 9a6a519426a0..9c272a241136 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -457,6 +457,21 @@ static struct stmmac_pci_info tgl_sgmii1g_info = {
 	.setup = tgl_sgmii_data,
 };
 
+static int adls_sgmii_data(struct pci_dev *pdev,
+			   struct plat_stmmacenet_data *plat)
+{
+	plat->bus_id = 1;
+	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+
+	/* SerDes power up and power down are done in BIOS for ADL */
+
+	return tgl_common_data(pdev, plat);
+}
+
+static struct stmmac_pci_info adls_sgmii1g_info = {
+	.setup = adls_sgmii_data,
+};
+
 static const struct stmmac_pci_func_data galileo_stmmac_func_data[] = {
 	{
 		.func = 6,
@@ -724,6 +739,8 @@ static SIMPLE_DEV_PM_OPS(intel_eth_pm_ops, intel_eth_pci_suspend,
 #define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_0_ID		0x43ac
 #define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_1_ID		0x43a2
 #define PCI_DEVICE_ID_INTEL_TGL_SGMII1G_ID		0xa0ac
+#define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_0_ID		0x7aac
+#define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_1_ID		0x7aad
 
 static const struct pci_device_id intel_eth_pci_id_table[] = {
 	{ PCI_DEVICE_DATA(INTEL, QUARK_ID, &quark_info) },
@@ -739,6 +756,8 @@ static const struct pci_device_id intel_eth_pci_id_table[] = {
 	{ PCI_DEVICE_DATA(INTEL, TGL_SGMII1G_ID, &tgl_sgmii1g_info) },
 	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_0_ID, &tgl_sgmii1g_info) },
 	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_1_ID, &tgl_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_0_ID, &adls_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_1_ID, &adls_sgmii1g_info) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, intel_eth_pci_id_table);
-- 
2.17.0

