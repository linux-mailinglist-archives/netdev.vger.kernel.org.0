Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE5C597677
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240824AbiHQTae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241476AbiHQTab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:30:31 -0400
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925D35FAC3
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 12:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3ecjpm3sx0/+YW3MsSKZjLFDsRvOUBiiGHSbAKikewo=; b=F7wgiUoOrcG3Trpz+KoaRvSs4W
        eDYr14MgzluvZbQqtXx0XJUcm2InfIx1KwVvPpy28c6qTW3IVqEKMb05o4Q4RSK6fLdlYkaFhLUgw
        2gH0FCAGo+uEVOdjoc8bN5x70hdgxSRURmsW2AWoe1F7Zsj1pY1uxOxkMB+6CrNrjOw0=;
Received: from 88-117-52-3.adsl.highway.telekom.at ([88.117.52.3] helo=hornet.engleder.at)
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oOOkE-0006Vi-19; Wed, 17 Aug 2022 21:30:26 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 4/5] tsnep: Support full DMA mask
Date:   Wed, 17 Aug 2022 21:30:16 +0200
Message-Id: <20220817193017.44063-5-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220817193017.44063-1-gerhard@engleder-embedded.com>
References: <20220817193017.44063-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DMA addresses up to 64bit are supported by the device. Configure DMA
mask according to the capabilities of the device.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 9f8ca6d9a010..415ae6a4b32c 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1239,6 +1239,13 @@ static int tsnep_probe(struct platform_device *pdev)
 	adapter->queue[0].rx = &adapter->rx[0];
 	adapter->queue[0].irq_mask = ECM_INT_TX_0 | ECM_INT_RX_0;
 
+	retval = dma_set_mask_and_coherent(&adapter->pdev->dev,
+					   DMA_BIT_MASK(64));
+	if (retval) {
+		dev_err(&adapter->pdev->dev, "no usable DMA configuration.\n");
+		return retval;
+	}
+
 	tsnep_disable_irq(adapter, ECM_INT_ALL);
 	retval = devm_request_irq(&adapter->pdev->dev, adapter->irq, tsnep_irq,
 				  0, TSNEP, adapter);
-- 
2.30.2

