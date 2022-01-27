Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BC549EDD0
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 22:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239875AbiA0Vwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 16:52:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:32606 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243766AbiA0Vwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 16:52:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643320364; x=1674856364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=leqm2CcNpXDT8BUi6hRFno6MXuS1zxsK3GwXkRaS+hA=;
  b=jTQbwDVCo6bNmCpF/SdFC4t/s9UtE0t4Rv9rD0ILHJ/GYubK/ug7X3uG
   9R8cFTstSyV9qvMqVAzlp6VhJczyNbDxDddZZhcemO03lexlqVOyNPF9/
   Y+MzF3kBlvsM+jlOFhbAoYYm14tEA4wnoapQFk9IeqYFMhR+5e4DMielq
   ASif+OFgzC7j50AOjfmV1WHyKbx24QxCeSiWk0W4PBo2hrzW8Y+rqhJPB
   in4mXiB/qy0p8B4gDCKKzHX47QWlRWisyFN0lto4KuRgDlNwx9n3sxZfa
   3fOa+91mOFSFTU1Uo/gGe9frFE04c1saj9BzOZ/P8I/XMzySqtppwV0gJ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246918947"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="246918947"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 13:52:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="625391783"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 27 Jan 2022 13:52:43 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Christoph Hellwig <hch@lst.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 06/10] iavf: Remove useless DMA-32 fallback configuration
Date:   Thu, 27 Jan 2022 13:52:20 -0800
Message-Id: <20220127215224.422113-7-anthony.l.nguyen@intel.com>
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

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 8125b9120615..b0bd95c85480 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4368,12 +4368,9 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err) {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev,
-				"DMA configuration failed: 0x%x\n", err);
-			goto err_dma;
-		}
+		dev_err(&pdev->dev,
+			"DMA configuration failed: 0x%x\n", err);
+		goto err_dma;
 	}
 
 	err = pci_request_regions(pdev, iavf_driver_name);
-- 
2.31.1

