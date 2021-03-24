Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD9D348398
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238351AbhCXVY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:24:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:18332 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238348AbhCXVYd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 17:24:33 -0400
IronPort-SDR: O/tIaDQ0qyOSiB2mAlVKfSd+V4XEzch/b4jgTogb3K0iV5S8C5c440ESOIrY9B2zLV6aK1qTWd
 GJftOgIL4ubg==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="187489340"
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="187489340"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 14:24:32 -0700
IronPort-SDR: sbDsA9HpPpC8QqvcWQXESMZKsEmiDBoG7qXQuqgre5k3Pp/cUN0FlkEF2IIpY4DjZ3m27cflrV
 EShJ70vo3v7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="608243785"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2021 14:24:30 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id BEDF716A; Wed, 24 Mar 2021 23:24:44 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net v1 1/1] net: pch_gbe: Propagate error from devm_gpio_request_one()
Date:   Wed, 24 Mar 2021 23:23:10 +0200
Message-Id: <20210324212308.84898-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If GPIO controller is not available yet we need to defer
the probe of GBE until provider will become available.

While here, drop GPIOF_EXPORT because it's deprecated and
may not be available.

Fixes: f1a26fdf5944 ("pch_gbe: Add MinnowBoard support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 140cee7c459d..1b32a43f7024 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2531,9 +2531,13 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	adapter->pdev = pdev;
 	adapter->hw.back = adapter;
 	adapter->hw.reg = pcim_iomap_table(pdev)[PCH_GBE_PCI_BAR];
+
 	adapter->pdata = (struct pch_gbe_privdata *)pci_id->driver_data;
-	if (adapter->pdata && adapter->pdata->platform_init)
-		adapter->pdata->platform_init(pdev);
+	if (adapter->pdata && adapter->pdata->platform_init) {
+		ret = adapter->pdata->platform_init(pdev);
+		if (ret)
+			goto err_free_netdev;
+	}
 
 	adapter->ptp_pdev =
 		pci_get_domain_bus_and_slot(pci_domain_nr(adapter->pdev->bus),
@@ -2628,7 +2632,7 @@ static int pch_gbe_probe(struct pci_dev *pdev,
  */
 static int pch_gbe_minnow_platform_init(struct pci_dev *pdev)
 {
-	unsigned long flags = GPIOF_DIR_OUT | GPIOF_INIT_HIGH | GPIOF_EXPORT;
+	unsigned long flags = GPIOF_OUT_INIT_HIGH;
 	unsigned gpio = MINNOW_PHY_RESET_GPIO;
 	int ret;
 
-- 
2.30.2

