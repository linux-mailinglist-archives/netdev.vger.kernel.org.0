Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216844DB2F2
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 15:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356597AbiCPOVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 10:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356672AbiCPOUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 10:20:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9743F286DC;
        Wed, 16 Mar 2022 07:18:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BECDA612E6;
        Wed, 16 Mar 2022 14:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCBCC340E9;
        Wed, 16 Mar 2022 14:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440320;
        bh=YBW9ISviAOPaKNtXuRYKHpW5Tf299q3Fe1E8jrVtelQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCWQU5Qwa6t0Vff/GJBMIyeZRFPACdVH3v7M0J3Q+nAsa5J2WjoNhSwwqviRiHlGB
         DcasFEPtSpXfYew9KA9CvO0/EW/LL7QmHtRiAvQfvGtr2sPGsPA5O+IVL2GnHjlzTX
         WF8e9tRkzfOwzlG9hNS2BZHgD66awqML4aY+MUDJL+uV6TSQrEk+TUCqy7KkCH5uti
         KYnsWbj8M0ghSXY0x9SozAwcljGpuq/IkflMFXazMcwjsur45ukR3bK+zXgbLNIwyT
         jCGziViLVdj/0KBUhrD0YMQqBD3FaytbrlywzLfXUebjmKxpRlSaDpB88nyYM85x10
         6ivutPCR4cnnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        tanghui20@huawei.com, christophe.jaillet@wanadoo.fr,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 4/6] ethernet: sun: Free the coherent when failing in probing
Date:   Wed, 16 Mar 2022 10:18:15 -0400
Message-Id: <20220316141817.248621-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141817.248621-1-sashal@kernel.org>
References: <20220316141817.248621-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit bb77bd31c281f70ec77c9c4f584950a779e05cf8 ]

When the driver fails to register net device, it should free the DMA
region first, and then do other cleanup.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/sunhme.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 06da2f59fcbf..882908e74cc9 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -3164,7 +3164,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	if (err) {
 		printk(KERN_ERR "happymeal(PCI): Cannot register net device, "
 		       "aborting.\n");
-		goto err_out_iounmap;
+		goto err_out_free_coherent;
 	}
 
 	pci_set_drvdata(pdev, hp);
@@ -3197,6 +3197,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
+err_out_free_coherent:
+	dma_free_coherent(hp->dma_dev, PAGE_SIZE,
+			  hp->happy_block, hp->hblock_dvma);
+
 err_out_iounmap:
 	iounmap(hp->gregs);
 
-- 
2.34.1

