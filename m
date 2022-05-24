Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688D8532A83
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237150AbiEXMkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235062AbiEXMj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:39:57 -0400
Received: from m12-16.163.com (m12-16.163.com [220.181.12.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8BF19729F;
        Tue, 24 May 2022 05:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=7IU+mYBZQwqAyHoS6Z
        dS30E7fZJHgeS8fPKH5ZR8Ums=; b=UAPmF5RJ/P+oVyqJLjAl/l3INFGHfV2r7R
        h6zibPMOCqjdA1u6ONtCJjTyfzynt8GgbvNamerIbAy0O2eDNmZLhOK4Zl9X/XeE
        RkWNVVxXyF6qPuNQbzMWcT9jgRNGX/xDfEKoKZ+8NA6F90x5ooc+LDEMe4v5l7sm
        xZQWc6k00=
Received: from localhost.localdomain (unknown [112.21.23.253])
        by smtp12 (Coremail) with SMTP id EMCowAB3v6P30YxilgQWBQ--.22936S4;
        Tue, 24 May 2022 20:39:21 +0800 (CST)
From:   Qiang Yang <line_walker2016@163.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qiang Yang <line_walker2016@163.com>,
        Weiqiang Su <David.suwq@outlook.com>
Subject: [PATCH] net: stmicro: implement basic Wake-On-LAN support
Date:   Tue, 24 May 2022 20:39:03 +0800
Message-Id: <20220524123903.13210-1-line_walker2016@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: EMCowAB3v6P30YxilgQWBQ--.22936S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxAw4rGF43tr4xJw13ur47twb_yoWrWw1rpw
        43Aa4F9rZ7XF1fJa1DAw18ZFy5G3y0yFyUWr4xA3yfuay2kr90q3sIqFW5Jw1UGrZ8ZFW3
        tF4UCw17C3WDCw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEnNVrUUUUU=
X-Originating-IP: [112.21.23.253]
X-CM-SenderInfo: 5olqvs5zdoyvjusqili6rwjhhfrp/1tbiMhkLXVWBzkmHdwAAse
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements basic Wake-On-LAN support in stmicro driver,
including adding wakeup filter configuration and implementation of
stmmac suspend/resume/wakeup callbacks. Currently only magic packet can
trigger the Wake-On-LAN function.

Signed-off-by: Qiang Yang <line_walker2016@163.com>
Signed-off-by: Weiqiang Su <David.suwq@outlook.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac1000.h   | 26 +++++++++++++++++++
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  |  9 ++++++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 ++
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  |  1 +
 4 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
index 1a84cf459e40..b84765831715 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -66,6 +66,32 @@ enum power_event {
 	power_down = 0x00000001,
 };
 
+#define WAKEUP_REG_LENGTH 8
+static u32 stmmac_wakeup_filter_config[] = {
+	/* For Filter0 CRC is not computed may be it is 0x0000 */
+	0x00000000,
+	/* For Filter1 CRC is computed on 0,1,2,3,4,5,6,7 bytes from offset */
+	0x000000FF,
+	/* For Filter2 CRC is not computed may be it is 0x0000 */
+	0x00000000,
+	/* For Filter3 CRC is not computed may be it is 0x0000 */
+	0x00000000,
+	/**
+	 * Filter 0,2,3 are disabled, Filter 1 is enabled and
+	 * filtering applies to only unicast packets
+	 */
+	0x00000100,
+	/**
+	 * Filter 0,2,3 (no significance), filter 1 offset is
+	 * 50 bytes from start of Destination MAC address
+	 */
+	0x00003200,
+	/* No significance of CRC for Filter0, Filter1 CRC is 0x7EED */
+	0x7eED0000,
+	/* No significance of CRC for Filter2 and Filter3 */
+	0x00000000,
+};
+
 /* Energy Efficient Ethernet (EEE)
  *
  * LPI status, timer and control register offset
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 4d617ba11ecb..adea2346102e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -267,7 +267,14 @@ static void dwmac1000_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
 static void dwmac1000_pmt(struct mac_device_info *hw, unsigned long mode)
 {
 	void __iomem *ioaddr = hw->pcsr;
-	unsigned int pmt = 0;
+	unsigned int pmt = 0, i = 0;
+
+	writel(pointer_reset, ioaddr + GMAC_PMT);
+	mdelay(100);
+
+	for (i = 0; i < WAKEUP_REG_LENGTH; i++)
+		writel(*(stmmac_wakeup_filter_config + i),
+		       ioaddr + GMAC_WAKEUP_FILTER);
 
 	if (mode & WAKE_MAGIC) {
 		pr_debug("GMAC: WOL Magic frame\n");
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0a4d093adfc9..7866f3ec5ef6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4513,6 +4513,7 @@ int stmmac_suspend(struct device *dev)
 
 	/* Enable Power down mode by programming the PMT regs */
 	if (device_may_wakeup(priv->device)) {
+		priv->wolopts |= WAKE_MAGIC;
 		stmmac_pmt(priv, priv->hw, priv->wolopts);
 		priv->irq_wake = 1;
 	} else {
@@ -4598,6 +4599,7 @@ int stmmac_resume(struct device *dev)
 			stmmac_mdio_reset(priv->mii);
 	}
 
+	device_set_wakeup_enable(dev, 0);
 	netif_device_attach(ndev);
 
 	mutex_lock(&priv->lock);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index cc1e887e47b5..ec69521f061c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -322,6 +322,7 @@ static int __maybe_unused stmmac_pci_suspend(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 	int ret;
 
+	device_set_wakeup_enable(dev, 1);
 	ret = stmmac_suspend(dev);
 	if (ret)
 		return ret;
-- 
2.17.1

