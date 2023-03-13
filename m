Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A486B8509
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCMWnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjCMWnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:43:25 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 269D187A2D;
        Mon, 13 Mar 2023 15:42:56 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id B5247E0EBD;
        Tue, 14 Mar 2023 01:42:54 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=nZ9yG0elRT6uL0+4AaOond5kO+hwjv7M4hDEo8ZCYAM=; b=FeqczvuB9KUR
        dQSzwn7YirRM436fADUn0EEbl2wqkSOPnkZO+RMPuVfw7ODFrNVdRJrhEx7hAVbo
        4NX7UTUgW9C8KihED2TGQ28IZ7h0CQBS44vkj/fYABFnNClzQ9TmafRPiV0sUiOK
        dQM3MytNNuGvZmP8Fk5ntjAQ/UPUK5E=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 985A4E0EBB;
        Tue, 14 Mar 2023 01:42:54 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:42:53 +0300
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
Subject: [PATCH net 10/13] net: stmmac: Make buf_sz module parameter useful
Date:   Tue, 14 Mar 2023 01:42:34 +0300
Message-ID: <20230313224237.28757-11-Sergey.Semin@baikalelectronics.ru>
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

Since the first day of the driver been added to the kernel the Rx
DMA-buffer size module parameter hasn't been utilized for something
more-or-less useful. The STMMAC main code used to initialize the actual Rx
DMA-buffer size (priv->dma_buf_sz) with it by default, but then overwrote
it anyway in accordance with Network device MTU or with default
DMA_BUFFER_SIZE/DEFAULT_BUFSIZE macro. Moreover in the both older and
modern versions of the STMMAC driver the buf_sz module parameter was
overwritten on each Net-dev open procedure with a value calculated in
accordance with MTU and allowed maximum buffer size. Needless to say that
even though it doesn't affect the driver functionality much, setting the
generic parameter with a value specific to a private device is wrong,
seeing each DW MAC may have different maximum buffer size on the same
platform.

In order to finally make the buf_sz (Rx DMA buffer size) parameter really
useful let's stop setting it up with a value specific to a particular
controller and use it to calculate the Rx DMA-buffer size instead of MTU
if one is greater than the later. Thus we'll be able to tune the buffer
size up when it's necessary.

Fixes: 47dd7a540b8a ("net: add support for STMicroelectronics Ethernet controllers.")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e5cb4edc4e23..12de84b7e90d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -100,10 +100,10 @@ static int tc = TC_DEFAULT;
 module_param(tc, int, 0644);
 MODULE_PARM_DESC(tc, "DMA threshold control value");
 
-#define	DEFAULT_BUFSIZE	1536
-static int buf_sz = DEFAULT_BUFSIZE;
-module_param(buf_sz, int, 0644);
-MODULE_PARM_DESC(buf_sz, "DMA buffer size");
+#define DEFAULT_BUFSIZE	1536U
+static unsigned int buf_sz = DEFAULT_BUFSIZE;
+module_param(buf_sz, uint, 0644);
+MODULE_PARM_DESC(buf_sz, "Rx DMA buffer size");
 
 #define	STMMAC_RX_COPYBREAK	256
 
@@ -3730,7 +3730,7 @@ stmmac_setup_dma_desc(struct stmmac_priv *priv, unsigned int mtu)
 		bfsize = 0;
 
 	if (bfsize < BUF_SIZE_16KiB)
-		bfsize = stmmac_set_bfsize(mtu, 0);
+		bfsize = stmmac_set_bfsize(max(buf_sz, mtu), 0);
 
 	dma_conf->dma_buf_sz = bfsize;
 	/* Chose the tx/rx size from the already defined one in the
@@ -3817,7 +3817,6 @@ static int __stmmac_open(struct net_device *dev,
 
 	priv->rx_copybreak = STMMAC_RX_COPYBREAK;
 
-	buf_sz = dma_conf->dma_buf_sz;
 	memcpy(&priv->dma_conf, dma_conf, sizeof(*dma_conf));
 
 	stmmac_reset_queues_param(priv);
-- 
2.39.2


