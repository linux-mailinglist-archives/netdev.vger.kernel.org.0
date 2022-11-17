Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B7962DE1F
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 15:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240137AbiKQOab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 09:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240134AbiKQOa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 09:30:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D6A1D0FB
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 06:30:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C125CB8206C
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FC7C433D6;
        Thu, 17 Nov 2022 14:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668695422;
        bh=E1LtY+xdTae3qLWPMC17QO9a6AW6o03PYGA7QzuCX4k=;
        h=From:To:Cc:Subject:Date:From;
        b=ht06XaZ/e2dTZJrrl6mpslryBfXKE1lAfWOVm1ovnRhGbkR7ZUI/SXoz6Iw5UMO8G
         CfpzB48N9ZTYXq2SRNgwWHuP3AYaXaquAleqAYflOq17kCA7xl1lm8CcenBYi8o9NU
         +dQDEcU9rWXSk4A3xNIyA+HBIei1TmeKrHEAeeZqZH81gjMpdAgSJotTrTSJVjtv3X
         jf76jeloRJZ18Mwe3XUyvwwDnKavMuUODgYDmAyZD16QDPJK365DBCdAdKgEHvxwz6
         YB07c7OXpBR1VUYnON2n6K61rxxATaJXV3/Li+/aZW3vSln1dkTIMHiqb3gNl2P7MF
         bul1wjizBcEGg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] net: ethernet: mtk_eth_soc: fix RSTCTRL_PPE{0,1} definitions
Date:   Thu, 17 Nov 2022 15:29:53 +0100
Message-Id: <9a10df72ee337803bc369481a2b82f7aa14b0913.1668695355.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix RSTCTRL_PPE0 and RSTCTRL_PPE1 register mask definitions for
MTK_NETSYS_V2.
Remove duplicated definitions.

Fixes: 160d3a9b1929 ("net: ethernet: mtk_eth_soc: introduce MTK_NETSYS_V2 support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 13 +++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 10 +++-------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index cdc0ff596196..fdef47bf5497 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3344,16 +3344,17 @@ static int mtk_hw_init(struct mtk_eth *eth)
 		return 0;
 	}
 
-	val = RSTCTRL_FE | RSTCTRL_PPE;
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN, 0);
-
-		val |= RSTCTRL_ETH;
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_RSTCTRL_PPE1))
-			val |= RSTCTRL_PPE1;
+		val = RSTCTRL_PPE0_V2;
+	} else {
+		val = RSTCTRL_PPE0;
 	}
 
-	ethsys_reset(eth, val);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_RSTCTRL_PPE1))
+		val |= RSTCTRL_PPE1;
+
+	ethsys_reset(eth, RSTCTRL_ETH | RSTCTRL_FE | val);
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index a572416e25de..5c37cd932bb1 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -453,18 +453,14 @@
 /* ethernet reset control register */
 #define ETHSYS_RSTCTRL			0x34
 #define RSTCTRL_FE			BIT(6)
-#define RSTCTRL_PPE			BIT(31)
-#define RSTCTRL_PPE1			BIT(30)
+#define RSTCTRL_PPE0			BIT(31)
+#define RSTCTRL_PPE0_V2			BIT(30)
+#define RSTCTRL_PPE1			BIT(31)
 #define RSTCTRL_ETH			BIT(23)
 
 /* ethernet reset check idle register */
 #define ETHSYS_FE_RST_CHK_IDLE_EN	0x28
 
-/* ethernet reset control register */
-#define ETHSYS_RSTCTRL		0x34
-#define RSTCTRL_FE		BIT(6)
-#define RSTCTRL_PPE		BIT(31)
-
 /* ethernet dma channel agent map */
 #define ETHSYS_DMA_AG_MAP	0x408
 #define ETHSYS_DMA_AG_MAP_PDMA	BIT(0)
-- 
2.38.1

