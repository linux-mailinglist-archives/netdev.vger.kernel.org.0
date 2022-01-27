Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFBA49EDCD
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 22:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbiA0Vws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 16:52:48 -0500
Received: from mga03.intel.com ([134.134.136.65]:32610 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243708AbiA0Vwn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 16:52:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643320363; x=1674856363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mkuu8zSaph5A19qMOnJs2RqERi6BfBqLSaY92OBLPt0=;
  b=mHhMLLz5qBWHHRzuvkUEZKTvLwZOXY6AV1C7YHzkkzBf4o6luO27xJGn
   FZVq1gvV5aZCn/sK2yUEIyiocW/E9a2nubqhlxTLuKnJk9vc4F0mu1iq+
   0vBOcOu10ye5ngr++V4nbrsI0awqypj1pA1gQ0lprZwafUHaFFBRPtYek
   PP6vuLShPWCi642S6q3y79PExgOS33Yy4d0dBzRFpamdCrYmKcC6EbWrZ
   /njIN7oL6Rw7SjGCV3WV40Z8hKj8TZubBB6B7iQxAjNto56ICJ8KC7yAj
   4eGgwxJqHTz/Z5y8ERY8uiyZPP4HTsbMGOP6VbGJk2g/aMlsf6CQtKpR/
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246918945"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="246918945"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 13:52:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="625391780"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 27 Jan 2022 13:52:43 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Christoph Hellwig <hch@lst.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH net-next 05/10] e1000e: Remove useless DMA-32 fallback configuration
Date:   Thu, 27 Jan 2022 13:52:19 -0800
Message-Id: <20220127215224.422113-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127215224.422113-1-anthony.l.nguyen@intel.com>
References: <20220127215224.422113-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

As stated in [1], dma_set_mask() with a 64-bit mask never fails if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

So, if dma_set_mask_and_coherent() succeeds, 'pci_using_dac' is known to be
1.

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 635a95927e93..4f6ee5c44f75 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7385,9 +7385,9 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	resource_size_t flash_start, flash_len;
 	static int cards_found;
 	u16 aspm_disable_flag = 0;
-	int bars, i, err, pci_using_dac;
 	u16 eeprom_data = 0;
 	u16 eeprom_apme_mask = E1000_EEPROM_APME;
+	int bars, i, err;
 	s32 ret_val = 0;
 
 	if (ei->flags2 & FLAG2_DISABLE_ASPM_L0S)
@@ -7401,17 +7401,11 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		return err;
 
-	pci_using_dac = 0;
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
-	if (!err) {
-		pci_using_dac = 1;
-	} else {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev,
-				"No usable DMA configuration, aborting\n");
-			goto err_dma;
-		}
+	if (err) {
+		dev_err(&pdev->dev,
+			"No usable DMA configuration, aborting\n");
+		goto err_dma;
 	}
 
 	bars = pci_select_bars(pdev, IORESOURCE_MEM);
@@ -7547,10 +7541,8 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	if (pci_using_dac) {
-		netdev->features |= NETIF_F_HIGHDMA;
-		netdev->vlan_features |= NETIF_F_HIGHDMA;
-	}
+	netdev->features |= NETIF_F_HIGHDMA;
+	netdev->vlan_features |= NETIF_F_HIGHDMA;
 
 	/* MTU range: 68 - max_hw_frame_size */
 	netdev->min_mtu = ETH_MIN_MTU;
-- 
2.31.1

