Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D981A58938E
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 22:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238794AbiHCUuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 16:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238776AbiHCUuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 16:50:11 -0400
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03035C94E
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 13:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3ecjpm3sx0/+YW3MsSKZjLFDsRvOUBiiGHSbAKikewo=; b=EGoBzIzQ272wFqV3RBsVBytXtx
        xfovhQMoz6gWllqiNnY5hW+hAAn9oSykHJqBe9rlxdbPuOaGHl4G9Z6QhR73EoD/J0RbfrO/BBwLj
        nrUI46Ma+ZDIVdPcEXUDv32lO+RUxrZ2Zuav39ncliV/mf1B5Co5VcbKVfDrKPgbWVVs=;
Received: from 88-117-54-219.adsl.highway.telekom.at ([88.117.54.219] helo=hornet.engleder.at)
        by mx05lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oJLJd-0001TF-77; Wed, 03 Aug 2022 22:50:05 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 5/6] tsnep: Support full DMA mask
Date:   Wed,  3 Aug 2022 22:49:46 +0200
Message-Id: <20220803204947.52789-6-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220803204947.52789-1-gerhard@engleder-embedded.com>
References: <20220803204947.52789-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

