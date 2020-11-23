Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7A12C1436
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbgKWTKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:10:09 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:33403 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgKWTKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 14:10:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606158609; x=1637694609;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3/oyopuY9OZJYjf3cT/I2waF/eIPcgafDeRD/fNBxx8=;
  b=kfyEFITpz6GzfaodBlqzPdqbZk0tuBSDzRhL/nKnSiT9d8At6mkfRrQa
   jwd57RtIRWyfBCqPp08N3QpUD9T1ahLaoR8F58JB/ywswhBzTQM6HPkWE
   Ld6k5TRJC5abvPbETanaOHnamtWiZgdVgKmaO+KyCEWseB1P7CxrpvSbz
   U=;
X-IronPort-AV: E=Sophos;i="5.78,364,1599523200"; 
   d="scan'208";a="65638577"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 23 Nov 2020 19:10:03 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id CCF5DA07B9;
        Mon, 23 Nov 2020 19:10:01 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.160.229) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 23 Nov 2020 19:09:52 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>, Mike Cui <mikecui@amazon.com>
Subject: [PATCH V3 net 2/3] net: ena: set initial DMA width to avoid intel iommu issue
Date:   Mon, 23 Nov 2020 21:08:58 +0200
Message-ID: <20201123190859.21298-3-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123190859.21298-1-shayagr@amazon.com>
References: <20201123190859.21298-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D17UWC003.ant.amazon.com (10.43.162.206) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ENA driver uses the readless mechanism, which uses DMA, to find
out what the DMA mask is supposed to be.

If DMA is used without setting the dma_mask first, it causes the
Intel IOMMU driver to think that ENA is a 32-bit device and therefore
disables IOMMU passthrough permanently.

This patch sets the dma_mask to be ENA_MAX_PHYS_ADDR_SIZE_BITS=48
before readless initialization in
ena_device_init()->ena_com_mmio_reg_read_request_init(),
which is large enough to workaround the intel_iommu issue.

DMA mask is set again to the correct value after it's received from the
device after readless is initialized.

The patch also changes the driver to use dma_set_mask_and_coherent()
function instead of the two pci_set_dma_mask() and
pci_set_consistent_dma_mask() ones. Both methods achieve the same
effect.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Mike Cui <mikecui@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 574c2b5ba21e..ec0008ba7751 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3367,16 +3367,9 @@ static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 		goto err_mmio_read_less;
 	}
 
-	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(dma_width));
+	rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(dma_width));
 	if (rc) {
-		dev_err(dev, "pci_set_dma_mask failed 0x%x\n", rc);
-		goto err_mmio_read_less;
-	}
-
-	rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(dma_width));
-	if (rc) {
-		dev_err(dev, "err_pci_set_consistent_dma_mask failed 0x%x\n",
-			rc);
+		dev_err(dev, "dma_set_mask_and_coherent failed %d\n", rc);
 		goto err_mmio_read_less;
 	}
 
@@ -4146,6 +4139,12 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 	}
 
+	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
+	if (rc) {
+		dev_err(&pdev->dev, "dma_set_mask_and_coherent failed %d\n", rc);
+		goto err_disable_device;
+	}
+
 	pci_set_master(pdev);
 
 	ena_dev = vzalloc(sizeof(*ena_dev));
-- 
2.17.1

