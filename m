Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB46E6B8506
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjCMWnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjCMWnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:43:25 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26F7B900AB;
        Mon, 13 Mar 2023 15:42:56 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 728ECE0EB6;
        Tue, 14 Mar 2023 01:42:48 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=Bs1amY+XsKSxbeDn+7iKOOqICBSFRydBCis7liFwu4M=; b=s5zEKbtDGfsz
        GMOXYO34rCQXnqbu/6HpjlHjQYT7qG5sah9NBsitvYdUzg5MXWvhy0KWhDLRdAmc
        jTmIL314/LxUWbEmhwsWmPv0H/zf9Iq5Ab6vZLq77jmEtx1fM/zEjWZDGe+CI7Ul
        lj6dxXk/4+cLAR4n+cNei4FUWrovtXo=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 57D7FE0E6A;
        Tue, 14 Mar 2023 01:42:48 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:42:47 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 05/13] net: stmmac: Enable ATDS for chain-mode
Date:   Tue, 14 Mar 2023 01:42:29 +0300
Message-ID: <20230313224237.28757-6-Sergey.Semin@baikalelectronics.ru>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
References: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.8.30.10]
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It wasn't stated why the Alternate Descriptor Size shouldn't have been
changed for the chained DMA descriptors, while the original commit did
introduce some chain_mode.c modifications. So the ATDS-related change in
commit c24602ef8664 ("stmmac: support extend descriptors") seems
contradicting. Anyway from the DW MAC/GMAC hardware point of view there is
no such limitation - whether the chained descriptors can't be used
together with the extended alternate descriptors. Moreover not setting the
BUS_MODE.ATDS flag will cause the driver malfunction in the framework of
the IPC Full Checksum and Advanced Timestamp feature, since the later
features require the additional 4-7 dwords of the DMA descriptor to set
some flags and a timestamp. So to speak in order to have all these
features working correctly in the chained mode too let's make sure the
ATDS flag is set irrespectively from the DMA descriptors mode.

Fixes: c24602ef8664 ("stmmac: support extend descriptors")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 2ed63acaee5b..ee4297a25521 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2907,7 +2907,6 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 	struct stmmac_rx_queue *rx_q;
 	struct stmmac_tx_queue *tx_q;
 	u32 chan = 0;
-	int atds = 0;
 	int ret = 0;
 
 	if (!priv->plat->dma_cfg || !priv->plat->dma_cfg->pbl) {
@@ -2915,9 +2914,6 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 		return -EINVAL;
 	}
 
-	if (priv->extend_desc && (priv->mode == STMMAC_RING_MODE))
-		atds = 1;
-
 	ret = stmmac_reset(priv, priv->ioaddr);
 	if (ret) {
 		dev_err(priv->device, "Failed to reset the dma\n");
@@ -2925,7 +2921,8 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 	}
 
 	/* DMA Configuration */
-	stmmac_dma_init(priv, priv->ioaddr, priv->plat->dma_cfg, atds);
+	stmmac_dma_init(priv, priv->ioaddr, priv->plat->dma_cfg,
+			priv->extend_desc);
 
 	if (priv->plat->axi)
 		stmmac_axi(priv, priv->ioaddr, priv->plat->axi);
-- 
2.39.2


