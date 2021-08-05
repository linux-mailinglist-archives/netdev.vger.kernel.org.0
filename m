Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612DD3E1766
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241749AbhHEO4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:56:22 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50760 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241561AbhHEO4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 10:56:20 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 175Eu4X6028606;
        Thu, 5 Aug 2021 09:56:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628175364;
        bh=NDuefcGE9c7lZJH8LHOIrKPTwwvMdPR6WsTEg+PqBPo=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=H2pxgQP6OHM0XBsqhDY9Q2KeUDrfSxwn9QyURLN3QmQB4u9XX+IPQMxddtqXm2NCu
         nZt1stl0u2MV2RF30bV6QW90s476b0kHROfuaTzNyVxIUw1kzK2K47pZf8yMiTNmRn
         ceOkloX9ePMb/uzSkMoKXvoOr0r3uWeNWjp0ez8Q=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 175Eu4e1078589
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Aug 2021 09:56:04 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 5 Aug
 2021 09:56:03 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 5 Aug 2021 09:56:03 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 175Eu2j8118114;
        Thu, 5 Aug 2021 09:56:03 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@essensium.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 3/3] net: ethernet: ti: davinci_cpdma: drop frame padding
Date:   Thu, 5 Aug 2021 17:55:55 +0300
Message-ID: <20210805145555.12182-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210805145555.12182-1-grygorii.strashko@ti.com>
References: <20210805145555.12182-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hence all users of davinci_cpdma switched to skb_put_padto() the frame
padding can be removed from it.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_priv.c     | 1 -
 drivers/net/ethernet/ti/davinci_cpdma.c | 5 -----
 drivers/net/ethernet/ti/davinci_cpdma.h | 1 -
 drivers/net/ethernet/ti/davinci_emac.c  | 1 -
 4 files changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index ecc2a6b7e28f..d97a72c9ec53 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -518,7 +518,6 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 
 	dma_params.num_chan		= data->channels;
 	dma_params.has_soft_reset	= true;
-	dma_params.min_packet_size	= CPSW_MIN_PACKET_SIZE;
 	dma_params.desc_mem_size	= data->bd_ram_size;
 	dma_params.desc_align		= 16;
 	dma_params.has_ext_regs		= true;
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index d2eab5cd1e0c..753d94c9915a 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -1034,11 +1034,6 @@ static int cpdma_chan_submit_si(struct submit_info *si)
 		return -ENOMEM;
 	}
 
-	if (len < ctlr->params.min_packet_size) {
-		len = ctlr->params.min_packet_size;
-		chan->stats.runt_transmit_buff++;
-	}
-
 	mode = CPDMA_DESC_OWNER | CPDMA_DESC_SOP | CPDMA_DESC_EOP;
 	cpdma_desc_to_port(chan, mode, si->directed);
 
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.h b/drivers/net/ethernet/ti/davinci_cpdma.h
index d3cfe234d16a..62151f13c7ce 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.h
+++ b/drivers/net/ethernet/ti/davinci_cpdma.h
@@ -26,7 +26,6 @@ struct cpdma_params {
 	void __iomem		*rxthresh, *rxfree;
 	int			num_chan;
 	bool			has_soft_reset;
-	int			min_packet_size;
 	dma_addr_t		desc_mem_phys;
 	dma_addr_t		desc_hw_addr;
 	int			desc_mem_size;
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index b1c5cbe7478b..cd2ef0282f38 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1850,7 +1850,6 @@ static int davinci_emac_probe(struct platform_device *pdev)
 	dma_params.txcp			= priv->emac_base + 0x640;
 	dma_params.rxcp			= priv->emac_base + 0x660;
 	dma_params.num_chan		= EMAC_MAX_TXRX_CHANNELS;
-	dma_params.min_packet_size	= EMAC_DEF_MIN_ETHPKTSIZE;
 	dma_params.desc_hw_addr		= hw_ram_addr;
 	dma_params.desc_mem_size	= pdata->ctrl_ram_size;
 	dma_params.desc_align		= 16;
-- 
2.17.1

