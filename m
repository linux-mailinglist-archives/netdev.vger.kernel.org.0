Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2F14B7283
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240029AbiBOPaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:30:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240030AbiBOP3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:29:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86914BE1D7;
        Tue, 15 Feb 2022 07:28:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D5BEB81A9A;
        Tue, 15 Feb 2022 15:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A241C340F2;
        Tue, 15 Feb 2022 15:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938908;
        bh=ZRcJMNIkHVIlbx+l7COfnU0tBLbEkmCGXNn/81rerzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/izHpNaV+sVbKd9EeQYtvFBuArnUwy9a1gNtHWJq2OgdnMD1M1eQl+07LpJyJ4h2
         9OkGpPcd//TLZJfPPb59wZjtJ37zZNmCa634yj/o1nxE7t8aCYm5RHqYd5OhqcT2AG
         Dl8rcyrhYYeTds7q4dMxTPtsR9YL9tF4JN/oAZ3dggm0sfSDlV1kinyU8+TXypw2Rp
         ChpA+VcJQf4kCcQ0zQS58XULk+1oVSZoZhTZYA4dXtLuKHXgFMqwLOkUN4qO3bYHwa
         jdFLXERxx2e+LUzdVl+W7bLlQRkPE54iJP6IfV10VJe3vRB+ZKddiaFcJZwmfAmD7l
         FfTTiDgRLvmTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc St-Amand <mstamand@ciena.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, claudiu.beznea@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 33/34] net: macb: Align the dma and coherent dma masks
Date:   Tue, 15 Feb 2022 10:26:56 -0500
Message-Id: <20220215152657.580200-33-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152657.580200-1-sashal@kernel.org>
References: <20220215152657.580200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc St-Amand <mstamand@ciena.com>

[ Upstream commit 37f7860602b5b2d99fc7465f6407f403f5941988 ]

Single page and coherent memory blocks can use different DMA masks
when the macb accesses physical memory directly. The kernel is clever
enough to allocate pages that fit into the requested address width.

When using the ARM SMMU, the DMA mask must be the same for single
pages and big coherent memory blocks. Otherwise the translation
tables turn into one big mess.

  [   74.959909] macb ff0e0000.ethernet eth0: DMA bus error: HRESP not OK
  [   74.959989] arm-smmu fd800000.smmu: Unhandled context fault: fsr=0x402, iova=0x3165687460, fsynr=0x20001, cbfrsynra=0x877, cb=1
  [   75.173939] macb ff0e0000.ethernet eth0: DMA bus error: HRESP not OK
  [   75.173955] arm-smmu fd800000.smmu: Unhandled context fault: fsr=0x402, iova=0x3165687460, fsynr=0x20001, cbfrsynra=0x877, cb=1

Since using the same DMA mask does not hurt direct 1:1 physical
memory mappings, this commit always aligns DMA and coherent masks.

Signed-off-by: Marc St-Amand <mstamand@ciena.com>
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index ffce528aa00e4..aac1b27bfc7bf 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4749,7 +4749,7 @@ static int macb_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	if (GEM_BFEXT(DAW64, gem_readl(bp, DCFG6))) {
-		dma_set_mask(&pdev->dev, DMA_BIT_MASK(44));
+		dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
 		bp->hw_dma_cap |= HW_DMA_CAP_64B;
 	}
 #endif
-- 
2.34.1

