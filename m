Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21624B73A9
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240291AbiBOPcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:32:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240282AbiBOPcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:32:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9A3AF1D2;
        Tue, 15 Feb 2022 07:29:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49A1EB81AEA;
        Tue, 15 Feb 2022 15:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69C8C36AE3;
        Tue, 15 Feb 2022 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938995;
        bh=QX9P9b6jKNwVb+IFyUDJF/Xx6Le72wsrSkqWivmyQJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgggBu+ffXLh05Bz+vdIsZU4qIGFETib3sSE5RCV+m1XmPC79s5btfm9EP/uFW4o7
         uHzizJm9g0fkkh6kKBRgGxDQKMyz14pyMWx5WVzaYq0H4mrOUA15XQMzjZW2sxjrgm
         UdR8m4hkBmnALH6OzCM4ovBXgSDADO9AJ0KsNqIRklC5fqt0DuS/ufHE60WeWsnh+I
         ZuSAH2z+kRYQe6eePhbSVTzvU47vRMcFQxad5wonG7OX448+bM1YaLSzRoPx0KogcL
         6Soz0H77ZdKtS+9AmnZ4iPtfxNYTATWGGQ4ovDYbi3j3pJGj1vblN46AcUQP14RkeN
         nnPnGPOZyHcEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc St-Amand <mstamand@ciena.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, claudiu.beznea@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 32/33] net: macb: Align the dma and coherent dma masks
Date:   Tue, 15 Feb 2022 10:28:30 -0500
Message-Id: <20220215152831.580780-32-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152831.580780-1-sashal@kernel.org>
References: <20220215152831.580780-1-sashal@kernel.org>
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
index d13fb1d318215..d71c11a6282ec 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4739,7 +4739,7 @@ static int macb_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	if (GEM_BFEXT(DAW64, gem_readl(bp, DCFG6))) {
-		dma_set_mask(&pdev->dev, DMA_BIT_MASK(44));
+		dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
 		bp->hw_dma_cap |= HW_DMA_CAP_64B;
 	}
 #endif
-- 
2.34.1

