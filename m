Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0350437943E
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 18:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhEJQke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 12:40:34 -0400
Received: from mga04.intel.com ([192.55.52.120]:34391 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231736AbhEJQk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 12:40:29 -0400
IronPort-SDR: /xGwYU2dGwFl9lIvyAdLi/NYtodZ0DmhfsQdJZe+pGyDKEQq2lAhwwiaZQOtN4MkL2OUCAh78J
 zNRekIjbjlSg==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="197252475"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="197252475"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 09:39:24 -0700
IronPort-SDR: /nfL6uo3oFSoqbrgT0xCvG6RUtu/MqRfnsLnhK5rbsTaC2cZpDvdF+hiOTTOAdFx7qiBU5SqMF
 jbfSUe2fG4SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="391976131"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 10 May 2021 09:39:22 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 09FF012A; Mon, 10 May 2021 19:39:42 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Flavio Suligoi <f.suligoi@asem.it>,
        Lee Jones <lee.jones@linaro.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 1/5] net: pch_gbe: Propagate error from devm_gpio_request_one()
Date:   Mon, 10 May 2021 19:39:27 +0300
Message-Id: <20210510163931.42417-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510163931.42417-1-andriy.shevchenko@linux.intel.com>
References: <20210510163931.42417-1-andriy.shevchenko@linux.intel.com>
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
Tested-by: Flavio Suligoi <f.suligoi@asem.it>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 334af49e5add..3dc29b282a88 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2532,9 +2532,13 @@ static int pch_gbe_probe(struct pci_dev *pdev,
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
@@ -2629,7 +2633,7 @@ static int pch_gbe_probe(struct pci_dev *pdev,
  */
 static int pch_gbe_minnow_platform_init(struct pci_dev *pdev)
 {
-	unsigned long flags = GPIOF_DIR_OUT | GPIOF_INIT_HIGH | GPIOF_EXPORT;
+	unsigned long flags = GPIOF_OUT_INIT_HIGH;
 	unsigned gpio = MINNOW_PHY_RESET_GPIO;
 	int ret;
 
-- 
2.30.2

