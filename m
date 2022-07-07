Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A0E569884
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 05:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbiGGDAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 23:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbiGGDAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 23:00:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8165F2FFCF
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 20:00:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA689B81FF0
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 03:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23434C341C6;
        Thu,  7 Jul 2022 03:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657162823;
        bh=n0ZTrEENMeLD9WyESJtJk+DTmymLkXIJs/0M/aFUT70=;
        h=From:To:Cc:Subject:Date:From;
        b=D5Ez2H5FmnjllhNB23DJRA+evqoNCd7DNUiySEeqip6O8fhz6viqMh9XSxDwljcp9
         8l7wUL9QN+gH8hAC1avpr0kN/aheGLDLG/1R/BUXh8UQHF4fcp/+HbnHv8gNDPrVqT
         bxhMzo6k48kMBw7KzHXnavjC7TxVKrTTbXMTAulHm9cnwfeJw6lgkCfZaLTC3Y5A0s
         Dlz7xkQrXFPTauTz794zrS3UfFvmo8A5D7dUZBnVvcymxbJhJ2B8eR+N+NWPcuFnMW
         tB0OuBkdAp5N1aEwId87NyJ5nOOFbje2oixIJdxhIQHeBmCssdMFl8JXG9q6WPCNxT
         VKZEU1JqjBmRg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com
Subject: [PATCH net-next 1/2] eth: mtk: switch to netif_napi_add_tx()
Date:   Wed,  6 Jul 2022 20:00:19 -0700
Message-Id: <20220707030020.1382722-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netif_napi_add_tx() does not require the weight argument.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: nbd@nbd.name
CC: john@phrozen.org
CC: sean.wang@mediatek.com
CC: Mark-MC.Lee@mediatek.com
CC: matthias.bgg@gmail.com
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 21c3668194eb..3f0e5e64de50 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1653,8 +1653,7 @@ static int mtk_star_probe(struct platform_device *pdev)
 
 	netif_napi_add(ndev, &priv->rx_napi, mtk_star_rx_poll,
 		       NAPI_POLL_WEIGHT);
-	netif_tx_napi_add(ndev, &priv->tx_napi, mtk_star_tx_poll,
-			  NAPI_POLL_WEIGHT);
+	netif_napi_add_tx(ndev, &priv->tx_napi, mtk_star_tx_poll);
 
 	return devm_register_netdev(dev, ndev);
 }
-- 
2.36.1

