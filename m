Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39567161081
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 11:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgBQK6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 05:58:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:50402 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgBQK6b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 05:58:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Feb 2020 02:58:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,452,1574150400"; 
   d="scan'208";a="229164428"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 17 Feb 2020 02:58:29 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 6A14C2BA; Mon, 17 Feb 2020 12:58:28 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] net: stmmac: Get rid of custom STMMAC_DEVICE() macro
Date:   Mon, 17 Feb 2020 12:58:27 +0200
Message-Id: <20200217105827.54512-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since PCI core provides a generic PCI_DEVICE_DATA() macro,
replace STMMAC_DEVICE() with former one.

No functional change intended.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  | 35 ++++++++-----------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index fe2c9fa6a71c..7acbac73c29c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -579,28 +579,23 @@ static int __maybe_unused stmmac_pci_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(stmmac_pm_ops, stmmac_pci_suspend, stmmac_pci_resume);
 
 /* synthetic ID, no official vendor */
-#define PCI_VENDOR_ID_STMMAC 0x700
-
-#define STMMAC_QUARK_ID  0x0937
-#define STMMAC_DEVICE_ID 0x1108
-#define STMMAC_EHL_RGMII1G_ID	0x4b30
-#define STMMAC_EHL_SGMII1G_ID	0x4b31
-#define STMMAC_TGL_SGMII1G_ID	0xa0ac
-#define STMMAC_GMAC5_ID		0x7102
-
-#define STMMAC_DEVICE(vendor_id, dev_id, info)	{	\
-	PCI_VDEVICE(vendor_id, dev_id),			\
-	.driver_data = (kernel_ulong_t)&info		\
-	}
+#define PCI_VENDOR_ID_STMMAC		0x0700
+
+#define PCI_DEVICE_ID_STMMAC_STMMAC		0x1108
+#define PCI_DEVICE_ID_INTEL_QUARK_ID		0x0937
+#define PCI_DEVICE_ID_INTEL_EHL_RGMII1G_ID	0x4b30
+#define PCI_DEVICE_ID_INTEL_EHL_SGMII1G_ID	0x4b31
+#define PCI_DEVICE_ID_INTEL_TGL_SGMII1G_ID	0xa0ac
+#define PCI_DEVICE_ID_SYNOPSYS_GMAC5_ID		0x7102
 
 static const struct pci_device_id stmmac_id_table[] = {
-	STMMAC_DEVICE(STMMAC, STMMAC_DEVICE_ID, stmmac_pci_info),
-	STMMAC_DEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_MAC, stmmac_pci_info),
-	STMMAC_DEVICE(INTEL, STMMAC_QUARK_ID, quark_pci_info),
-	STMMAC_DEVICE(INTEL, STMMAC_EHL_RGMII1G_ID, ehl_rgmii1g_pci_info),
-	STMMAC_DEVICE(INTEL, STMMAC_EHL_SGMII1G_ID, ehl_sgmii1g_pci_info),
-	STMMAC_DEVICE(INTEL, STMMAC_TGL_SGMII1G_ID, tgl_sgmii1g_pci_info),
-	STMMAC_DEVICE(SYNOPSYS, STMMAC_GMAC5_ID, snps_gmac5_pci_info),
+	{ PCI_DEVICE_DATA(STMMAC, STMMAC, &stmmac_pci_info) },
+	{ PCI_DEVICE_DATA(STMICRO, MAC, &stmmac_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, QUARK_ID, &quark_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_RGMII1G_ID, &ehl_rgmii1g_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII1G_ID, &ehl_sgmii1g_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, TGL_SGMII1G_ID, &tgl_sgmii1g_pci_info) },
+	{ PCI_DEVICE_DATA(SYNOPSYS, GMAC5_ID, &snps_gmac5_pci_info) },
 	{}
 };
 
-- 
2.25.0

