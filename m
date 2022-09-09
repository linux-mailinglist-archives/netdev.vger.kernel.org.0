Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137E35B2ED6
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 08:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiIIG0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 02:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiIIG0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 02:26:52 -0400
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 647481269F7;
        Thu,  8 Sep 2022 23:26:50 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 6EDC61E80D5E;
        Fri,  9 Sep 2022 14:25:19 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qC0r7odWaN2A; Fri,  9 Sep 2022 14:25:16 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: yuzhe@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 50AF21E80D06;
        Fri,  9 Sep 2022 14:25:16 +0800 (CST)
From:   Yu Zhe <yuzhe@nfschina.com>
To:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, liqiong@nfschina.com,
        Yu Zhe <yuzhe@nfschina.com>
Subject: [PATCH] net: broadcom: bcm4908enet: add platform_get_irq_byname error checking
Date:   Fri,  9 Sep 2022 14:25:45 +0800
Message-Id: <20220909062545.16696-1-yuzhe@nfschina.com>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The platform_get_irq_byname() function returns negative error codes on error,
check it.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index c131d8118489..d985056db6c2 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -705,6 +705,8 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 		return netdev->irq;
 
 	enet->irq_tx = platform_get_irq_byname(pdev, "tx");
+	if (enet->irq_tx < 0)
+		return enet->irq_tx;
 
 	err = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
 	if (err)
-- 
2.11.0

