Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B21125FE6E
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbgIGQQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:16:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:42694 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729947AbgIGQP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:15:58 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BB40560066;
        Mon,  7 Sep 2020 16:15:57 +0000 (UTC)
Received: from us4-mdac16-42.ut7.mdlocal (unknown [10.7.64.24])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B9F6A800A4;
        Mon,  7 Sep 2020 16:15:57 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.42])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2E5128005D;
        Mon,  7 Sep 2020 16:15:57 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DA6F6A40059;
        Mon,  7 Sep 2020 16:15:56 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep 2020
 17:15:51 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 6/6] sfc: simplify DMA mask setting
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
References: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
Message-ID: <3140001a-66eb-b770-e7b8-c5be71dbd41b@solarflare.com>
Date:   Mon, 7 Sep 2020 17:15:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25650.007
X-TM-AS-Result: No-8.858400-8.000000-10
X-TMASE-MatchedRID: WNBRmQC8/ElthJ7IXRIqNgT8qiDldlXbxXRDKEyu2zFbmyxV5cr3hirK
        DshTV4ki3UwJgnKc1S4zklok+iw0PKKgpS1QMZdl8Kg68su2wyFLXPA26IG0hN9RlPzeVuQQRbU
        eXJo3FEypRAhKpORMdrAsv4uIGkjDAHh4glaDf/scLuEDP+gqctcIyvtEUQYeu1+KMhi4A6Yy5P
        BtqoQlkwgWHyC03vY71nqP5h12sNAczEPrqnY8wp4CIKY/Hg3AtOt1ofVlaoLWRN8STJpl3PoLR
        4+zsDTtyMdyHKes7ltRxKH7PG6D4Y2wCSRyWt0362ajDH6P+5Dzzx+PeZ/JaQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.858400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25650.007
X-MDID: 1599495357-PK8Y1htQxl2m
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph says[1] that dma_set_mask_and_coherent() is smart enough to
 truncate the mask itself if it's too long.  So we can get rid of our
 "lop off one bit and retry" loop in efx_init_io().

[1]: https://www.spinics.net/lists/netdev/msg677266.html

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx_common.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 9eda54e27cd4..80a23def96ad 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1086,17 +1086,7 @@ int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
 
 	pci_set_master(pci_dev);
 
-	/* Set the PCI DMA mask.  Try all possibilities from our
-	 * genuine mask down to 32 bits, because some architectures
-	 * (e.g. x86_64 with iommu_sac_force set) will allow 40 bit
-	 * masks event though they reject 46 bit masks.
-	 */
-	while (dma_mask > 0x7fffffffUL) {
-		rc = dma_set_mask_and_coherent(&pci_dev->dev, dma_mask);
-		if (rc == 0)
-			break;
-		dma_mask >>= 1;
-	}
+	rc = dma_set_mask_and_coherent(&pci_dev->dev, dma_mask);
 	if (rc) {
 		netif_err(efx, probe, efx->net_dev,
 			  "could not find a suitable DMA mask\n");
