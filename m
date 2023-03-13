Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157516B8508
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCMWnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjCMWnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:43:25 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4021D90B67;
        Mon, 13 Mar 2023 15:42:55 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 6A3CEE0EBC;
        Tue, 14 Mar 2023 01:42:53 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=+PN9j8i8CUqBkqlPL3X/wgal1M61lqlFSZNS8372LJI=; b=pVphkfQwoDW1
        BfHfEzbCFY7bOtI0biMdcll4erACdeUdXN54+1wgnsA2DOnsCx1np44Sj7t3uxgE
        j+j9bWgjlJxtV5cNagVGdwJgQbdpp3Uw1pMPgnog/Woa9hbquURO4d0C0qDmUhNF
        UgjVPoQpQgn8GAvaMb0LFB8IT6rrhW4=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 565E3E0EBB;
        Tue, 14 Mar 2023 01:42:53 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:42:52 +0300
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
Subject: [PATCH net 09/13] net: stmmac: Remove default maxmtu DT-platform setting
Date:   Tue, 14 Mar 2023 01:42:33 +0300
Message-ID: <20230313224237.28757-10-Sergey.Semin@baikalelectronics.ru>
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

Initializing maxmtu platform parameter in the stmmac_probe_config_dt()
method by default makes being pointless the DW MAC-specific maximum MTU
selection algorithm implemented in the stmmac_dvr_probe() method. At least
for xGMAC we'll always have a frame MTU limited with 9000 while it
supports units up to 16KB. Let's remove the default initialization of
the maxmtu platform setting then. We don't replace it with setting the
maxmtu with some greater value because a default maximum MTU is
calculated later in the stmmac_dvr_probe() anyway. That would have been a
pointless limitation too. Instead from now the main STMMAC driver code
will consider the out of bounds maxmtu value as invalid and will silently
replace it with a maximum MTU value specific to the corresponding DW MAC.

Note this alteration will only affect the xGMAC IP-cores due to the way
the MTU autodetecion algorithm is implemented. So from now the driver will
permit DW xGMACs to handle frames up to 16KB length (XGMAC_JUMBO_LEN). As
before DW GMAC IP-cores of v4.0 and higher and IP-cores with enhanced
descriptor support will be able to work with frames up to 8KB (JUMBO_LEN).
The rest of the NICs will support frames of SKB_MAX_HEAD(NET_SKB_PAD +
NET_IP_ALIGN) size.

Fixes: 7d9e6c5afab6 ("net: stmmac: Integrate XGMAC into main driver flow")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 4 ----
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 5 -----
 2 files changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 32aa7953d296..e5cb4edc4e23 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7252,10 +7252,6 @@ int stmmac_dvr_probe(struct device *device,
 	if ((priv->plat->maxmtu < ndev->max_mtu) &&
 	    (priv->plat->maxmtu >= ndev->min_mtu))
 		ndev->max_mtu = priv->plat->maxmtu;
-	else if (priv->plat->maxmtu < ndev->min_mtu)
-		dev_warn(priv->device,
-			 "%s: warning: maxmtu having invalid value (%d)\n",
-			 __func__, priv->plat->maxmtu);
 
 	if (flow_ctrl)
 		priv->flow_ctrl = FLOW_AUTO;	/* RX/TX pause on */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 067a40fe0a23..857411105a0a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -468,11 +468,6 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	plat->en_tx_lpi_clockgating =
 		of_property_read_bool(np, "snps,en-tx-lpi-clockgating");
 
-	/* Set the maxmtu to a default of JUMBO_LEN in case the
-	 * parameter is not present in the device tree.
-	 */
-	plat->maxmtu = JUMBO_LEN;
-
 	/* Set default value for multicast hash bins */
 	plat->multicast_filter_bins = HASH_TABLE_SIZE;
 
-- 
2.39.2


