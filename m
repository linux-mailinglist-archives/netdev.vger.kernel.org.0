Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A264DB273
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 15:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356451AbiCPOQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 10:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356436AbiCPOQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 10:16:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D703DDFA;
        Wed, 16 Mar 2022 07:15:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A86A461209;
        Wed, 16 Mar 2022 14:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEF1C340E9;
        Wed, 16 Mar 2022 14:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440112;
        bh=ftg6mvtL2p5B+Es1xejb0jT2x8nNQtbP0JhbQhgOV6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSzPWzwzOpQA7DUJGCl96MzdMN7JNN4ExzbpnYXagOGzX2AIRQ75eps94o+b39lpp
         tb4FODbepsfDHP2ic00xhyRBIKsUBs7tU3A59xwdmse8g4fuuiGiHWfncp6rc1FY+g
         5OoBPsHZL1V33i2HMf9NnWfVyWjMxzga11TxLpXe11rtLTuhKE6lVxYgrUFQovolnh
         1bmWleJCm4gNqfwpbDu7W3sit1EoRwwuWjEWzIx9PKcTlpE9c6iquZB9qULo5YA7Qv
         5okhxbStxJY3nniCQlP41cpvTmKSiX6tof4Dn3xriqMJtPRrjYTx44Fgq89ho4eXz2
         2KgqiKqbqCNtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 13/13] net:mcf8390: Use platform_get_irq() to get the interrupt
Date:   Wed, 16 Mar 2022 10:13:54 -0400
Message-Id: <20220316141354.247750-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141354.247750-1-sashal@kernel.org>
References: <20220316141354.247750-1-sashal@kernel.org>
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

From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>

[ Upstream commit 2a760554dcba450d3ad61b32375b50ed6d59a87c ]

It is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ)
for requesting IRQ's resources any more, as they can be not ready yet in
case of DT-booting.

platform_get_irq() instead is a recommended way for getting IRQ even if
it was not retrieved earlier.

It also makes code simpler because we're getting "int" value right away
and no conversion from resource to int is required.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/8390/mcf8390.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/8390/mcf8390.c b/drivers/net/ethernet/8390/mcf8390.c
index e320cccba61a..90cd7bdf06f5 100644
--- a/drivers/net/ethernet/8390/mcf8390.c
+++ b/drivers/net/ethernet/8390/mcf8390.c
@@ -405,12 +405,12 @@ static int mcf8390_init(struct net_device *dev)
 static int mcf8390_probe(struct platform_device *pdev)
 {
 	struct net_device *dev;
-	struct resource *mem, *irq;
+	struct resource *mem;
 	resource_size_t msize;
-	int ret;
+	int ret, irq;
 
-	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (irq == NULL) {
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
 		dev_err(&pdev->dev, "no IRQ specified?\n");
 		return -ENXIO;
 	}
@@ -433,7 +433,7 @@ static int mcf8390_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	platform_set_drvdata(pdev, dev);
 
-	dev->irq = irq->start;
+	dev->irq = irq;
 	dev->base_addr = mem->start;
 
 	ret = mcf8390_init(dev);
-- 
2.34.1

