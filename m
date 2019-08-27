Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E20579D516
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733245AbfHZRjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:39:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:54772 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729466AbfHZRjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 13:39:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 10:39:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="355499072"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga005.jf.intel.com with ESMTP; 26 Aug 2019 10:39:07 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [PATCH v1 net-next 2/4] net: stmmac: add TGL SGMII 1Gbps PCI info and PCI ID
Date:   Tue, 27 Aug 2019 09:38:09 +0800
Message-Id: <1566869891-29239-3-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1566869891-29239-1-git-send-email-weifeng.voon@intel.com>
References: <1566869891-29239-1-git-send-email-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added TGL SGMII 1Gbps PCI ID. Different MII and speed will have
different PCI ID.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 29 ++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index f6930e02f578..edb76408308b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -213,6 +213,33 @@ static int ehl_sgmii_data(struct pci_dev *pdev,
 	.setup = ehl_sgmii_data,
 };
 
+static int tgl_common_data(struct pci_dev *pdev,
+			   struct plat_stmmacenet_data *plat)
+{
+	int ret;
+
+	plat->rx_queues_to_use = 6;
+	plat->tx_queues_to_use = 4;
+	ret = intel_mgbe_common_data(pdev, plat);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int tgl_sgmii_data(struct pci_dev *pdev,
+			  struct plat_stmmacenet_data *plat)
+{
+	plat->bus_id = 1;
+	plat->phy_addr = 0;
+	plat->interface = PHY_INTERFACE_MODE_SGMII;
+	return tgl_common_data(pdev, plat);
+}
+
+static struct stmmac_pci_info tgl_sgmii1g_pci_info = {
+	.setup = tgl_sgmii_data,
+};
+
 static const struct stmmac_pci_func_data galileo_stmmac_func_data[] = {
 	{
 		.func = 6,
@@ -455,6 +482,7 @@ static int __maybe_unused stmmac_pci_resume(struct device *dev)
 #define STMMAC_QUARK_ID  0x0937
 #define STMMAC_DEVICE_ID 0x1108
 #define STMMAC_EHL_SGMII1G_ID	0x4b31
+#define STMMAC_TGL_SGMII1G_ID	0xa0ac
 
 #define STMMAC_DEVICE(vendor_id, dev_id, info)	{	\
 	PCI_VDEVICE(vendor_id, dev_id),			\
@@ -466,6 +494,7 @@ static int __maybe_unused stmmac_pci_resume(struct device *dev)
 	STMMAC_DEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_MAC, stmmac_pci_info),
 	STMMAC_DEVICE(INTEL, STMMAC_QUARK_ID, quark_pci_info),
 	STMMAC_DEVICE(INTEL, STMMAC_EHL_SGMII1G_ID, ehl_sgmii1g_pci_info),
+	STMMAC_DEVICE(INTEL, STMMAC_TGL_SGMII1G_ID, tgl_sgmii1g_pci_info),
 	{}
 };
 
-- 
1.9.1

