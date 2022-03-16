Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8224DB2F5
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 15:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356646AbiCPOWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 10:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356777AbiCPOVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 10:21:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD60C4DF57;
        Wed, 16 Mar 2022 07:19:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 518CE6114A;
        Wed, 16 Mar 2022 14:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84FDC340EC;
        Wed, 16 Mar 2022 14:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440342;
        bh=m010D5kfjHCZrOKrDHaOt/zruGT7jWSVi3xsW6bm/1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmmvmf6n6dQN2ihRaynqSfOFAEEzOhKiq1OG5NB/ko+yCAeyVq8eeeNG4eCqCcXPB
         tBebWk+qiaClaiMOS1VJmFxc7+5a7Rqj68DGBNTHdZnJAbEXv6MohInxjD1VwnsElM
         rPKZ8i8+nE+7Nbe+301NXDYQG2ZxsJdzjjAcyzgPPlhvMCmdEkmz6+zviCzxOCfX7D
         9eZOD/6DBqrKkxNEZSjNb8u3IDAvKd3mWwRRSkG4A6M1gT9w8lwwrUfs/52j5WM4f3
         +QK6/m8sbA26/MgN0xefhYBFtyWoPKJpPHJqx6EOfiwWWzym06ff1atZmAVMh8SWeJ
         hAKujCqx0Cc7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        tanghui20@huawei.com, christophe.jaillet@wanadoo.fr,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 2/3] ethernet: sun: Free the coherent when failing in probing
Date:   Wed, 16 Mar 2022 10:18:49 -0400
Message-Id: <20220316141850.248784-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141850.248784-1-sashal@kernel.org>
References: <20220316141850.248784-1-sashal@kernel.org>
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
index 9e983e1d8249..7522f277e912 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -3165,7 +3165,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	if (err) {
 		printk(KERN_ERR "happymeal(PCI): Cannot register net device, "
 		       "aborting.\n");
-		goto err_out_iounmap;
+		goto err_out_free_coherent;
 	}
 
 	pci_set_drvdata(pdev, hp);
@@ -3198,6 +3198,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
+err_out_free_coherent:
+	dma_free_coherent(hp->dma_dev, PAGE_SIZE,
+			  hp->happy_block, hp->hblock_dvma);
+
 err_out_iounmap:
 	iounmap(hp->gregs);
 
-- 
2.34.1

