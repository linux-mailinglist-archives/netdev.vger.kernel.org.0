Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B082B870E
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgKRWCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:02:04 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:32156 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgKRWCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:02:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1605736923; x=1637272923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6yveuebg1hE3BAFcvPAOr3k2hiKddRpUNOyKsGTikDo=;
  b=M8OjPrQF1VzkyVF+WoABzrxIOYFdnK/oLNuY+9g3CxERbcGt+gMpLkYz
   BmUyrJxwSG3/jtUry3ueTGooq8dbbiZ9ALyYlq9V9dLKeD7irmtM1wLLT
   k+QcZFqmo7F3/mVj1SEw+etJuBKiW3LRjvmNwt3yHcEota1ln5eOhNxHn
   A=;
X-IronPort-AV: E=Sophos;i="5.77,488,1596499200"; 
   d="scan'208";a="64517704"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 18 Nov 2020 22:00:50 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id DDF64A1FBB;
        Wed, 18 Nov 2020 22:00:49 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.161.43) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 18 Nov 2020 22:00:40 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>, Mike Cui <mikecui@amazon.com>
Subject: [PATCH V1 net 2/4] net: ena: set initial DMA width to avoid intel iommu issue
Date:   Wed, 18 Nov 2020 23:59:45 +0200
Message-ID: <20201118215947.8970-3-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201118215947.8970-1-shayagr@amazon.com>
References: <20201118215947.8970-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.43]
X-ClientProxiedBy: EX13D25UWC002.ant.amazon.com (10.43.162.210) To
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

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Mike Cui <mikecui@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 574c2b5ba21e..854a22e692bf 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4146,6 +4146,19 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 	}
 
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
+	if (rc) {
+		dev_err(&pdev->dev, "pci_set_dma_mask failed %d\n", rc);
+		goto err_disable_device;
+	}
+
+	rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
+	if (rc) {
+		dev_err(&pdev->dev, "err_pci_set_consistent_dma_mask failed %d\n",
+			rc);
+		goto err_disable_device;
+	}
+
 	pci_set_master(pdev);
 
 	ena_dev = vzalloc(sizeof(*ena_dev));
-- 
2.17.1

