Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B566924B73D
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 12:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731283AbgHTKrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 06:47:53 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:50858 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731389AbgHTKrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 06:47:35 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C65852004D;
        Thu, 20 Aug 2020 10:47:33 +0000 (UTC)
Received: from us4-mdac16-33.at1.mdlocal (unknown [10.110.49.217])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C50D56009B;
        Thu, 20 Aug 2020 10:47:33 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 628A2220054;
        Thu, 20 Aug 2020 10:47:33 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 27778140061;
        Thu, 20 Aug 2020 10:47:33 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Aug
 2020 11:47:27 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net] sfc: fix build warnings on 32-bit
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <rdunlap@infradead.org>
Message-ID: <187ef73f-09ed-8c45-540f-85fb1714e887@solarflare.com>
Date:   Thu, 20 Aug 2020 11:47:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25614.005
X-TM-AS-Result: No-5.239700-8.000000-10
X-TMASE-MatchedRID: 4vm9ojrEpbH+xJ2g7e3ELwVl6/nUmdU9Pf2+tfEqWx3IPbn2oQhptaXl
        4QbYEisZ8XVI39JCRnSjfNAVYAJRAiHhSBQfglfsA9lly13c/gHYuVu0X/rOkIjusgfCDOEwdjZ
        axBOjo40FAZLPTWUTPt36btcoISiFlE0VgxbvH2yiAZ3zAhQYglxo0H+7nJCrGP0M/F8V3KjdYf
        bsqejRheLzNWBegCW2RYvisGWbbS+No+PRbWqfRDsAVzN+Ov/sq6P5uojorjiUYuFWZzSM9L5UD
        ck8IbAf2Zas3L80t6a7zMtP0Yg/XQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.239700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25614.005
X-MDID: 1597920453-oulr7cO4rI_w
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Truncation of DMA_BIT_MASK to 32-bit dma_addr_t is semantically safe,
 but the compiler was warning because it was happening implicitly.
Insert explicit casts to suppress the warnings.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
index 9729983f4840..c54b7f8243f3 100644
--- a/drivers/net/ethernet/sfc/ef100.c
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -142,7 +142,7 @@ static int ef100_pci_parse_continue_entry(struct efx_nic *efx, int entry_locatio
 
 		/* Temporarily map new BAR. */
 		rc = efx_init_io(efx, bar,
-				 DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
+				 (dma_addr_t)DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
 				 pci_resource_len(efx->pci_dev, bar));
 		if (rc) {
 			netif_err(efx, probe, efx->net_dev,
@@ -160,7 +160,7 @@ static int ef100_pci_parse_continue_entry(struct efx_nic *efx, int entry_locatio
 
 		/* Put old BAR back. */
 		rc = efx_init_io(efx, previous_bar,
-				 DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
+				 (dma_addr_t)DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
 				 pci_resource_len(efx->pci_dev, previous_bar));
 		if (rc) {
 			netif_err(efx, probe, efx->net_dev,
@@ -334,7 +334,7 @@ static int ef100_pci_parse_xilinx_cap(struct efx_nic *efx, int vndr_cap,
 
 	/* Temporarily map BAR. */
 	rc = efx_init_io(efx, bar,
-			 DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
+			 (dma_addr_t)DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
 			 pci_resource_len(efx->pci_dev, bar));
 	if (rc) {
 		netif_err(efx, probe, efx->net_dev,
@@ -495,7 +495,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
 
 	/* Set up basic I/O (BAR mappings etc) */
 	rc = efx_init_io(efx, fcw.bar,
-			 DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
+			 (dma_addr_t)DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
 			 pci_resource_len(efx->pci_dev, fcw.bar));
 	if (rc)
 		goto fail;
