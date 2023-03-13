Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78926B850D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjCMWnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjCMWnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:43:25 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4108090B68;
        Mon, 13 Mar 2023 15:42:55 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 0F365E0EBA;
        Tue, 14 Mar 2023 01:42:52 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=Dpl6MaxqP5WEy7Vh+oFSb0logDrpNZX6Oxq0pbGHndo=; b=j/VKpA/0OYyW
        ITllD/sgEyyJK3bhHohE8LZrDLjdh6jn/vhc+xSN595HWpgUaWghtGMd9G+PrEGW
        oX9Gk4Cj1zY8o2KfuD6Vlmv1c7wCr6IHdyw2gUEv4mfXQw4jOHnAm5YuuGqF8F7w
        CEJflcO/In1kXsWIDFU+Pwrd6MWqu+E=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id F351DE0E6A;
        Tue, 14 Mar 2023 01:42:51 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:42:51 +0300
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
        <linux-kernel@vger.kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH net 08/13] net: stmmac: Fix Rx IC bit setting procedure for Rx-mitigation
Date:   Tue, 14 Mar 2023 01:42:32 +0300
Message-ID: <20230313224237.28757-9-Sergey.Semin@baikalelectronics.ru>
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

The WDT-less Rx-traffic mitigation is simple: enable the Rx-descriptor
Completion interrupt only when a particular number of descriptors handled
by the NIC. Alas it's broken now because the data variable rx_count_frames
is always set to zero due to commit 6fa9d691b91a ("net: stmmac: Prevent
divide-by-zero") (++rx_count_frames + rx_coal_frames > rx_coal_frames
always if no overflow happens). So Rx IC will be enabled for each
descriptor as soon as rx_coal_frames is non-zero or there is no Rx WDT
available, which basically disables the Rx-mitigation in the framework of
the number of received frames part. Fix that by discarding the statement:
rx_q->rx_count_frames += priv->rx_coal_frames.

Fixes: 6fa9d691b91a ("net: stmmac: Prevent divide-by-zero")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 229f827d7572..32aa7953d296 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4627,7 +4627,6 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 		stmmac_refill_desc3(priv, rx_q, p);
 
 		rx_q->rx_count_frames++;
-		rx_q->rx_count_frames += priv->rx_coal_frames[queue];
 		if (rx_q->rx_count_frames > priv->rx_coal_frames[queue])
 			rx_q->rx_count_frames = 0;
 
@@ -4967,7 +4966,6 @@ static bool stmmac_rx_refill_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		stmmac_refill_desc3(priv, rx_q, rx_desc);
 
 		rx_q->rx_count_frames++;
-		rx_q->rx_count_frames += priv->rx_coal_frames[queue];
 		if (rx_q->rx_count_frames > priv->rx_coal_frames[queue])
 			rx_q->rx_count_frames = 0;
 
-- 
2.39.2


