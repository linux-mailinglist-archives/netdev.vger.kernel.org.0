Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5306FDDDA
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfD2IfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:03 -0400
Received: from first.geanix.com ([116.203.34.67]:49940 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727808AbfD2IfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:01 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 46B4B308E8B;
        Mon, 29 Apr 2019 08:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556526815; bh=v39yx9S9Cvx/ntF44Z3O71Ibq2JTq4YbQtTVpVGBKDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Q4MxUK1AEjGPeTsu8Gi4wjWH/O5d7MTahFDw76LiuPQq2OP+VuN0vKyLiIvNFI/ik
         aQl0q6pqCAYA+VakP6jsBuD88D59eIK+/jrVfN+337hJjP+FndULQkkh7mJR1DHA8W
         jK/IRUgsouTdL2PclJZfu5OOCCkThk6riXoyVsxxf0B1rKC4PT5hRx8a5fgZC4lo5S
         OrEf3zz9mDOg8f3fVq0wuWHTDzMwThAMkhghbX4bYie0cZDW55iTeQwJp3ybBuEMcM
         sHZ+72xpp13z7g7UiWEqMBlQ0IkX7eyCz4HFgVZYPz+3GzDJbGXBgUatImmoFLEocU
         ECKthVHWJH01g==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] net: ll_temac: Support indirect_mutex share within TEMAC IP
Date:   Mon, 29 Apr 2019 10:34:17 +0200
Message-Id: <20190429083422.4356-8-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429083422.4356-1-esben@geanix.com>
References: <20190426073231.4008-1-esben@geanix.com>
 <20190429083422.4356-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 3e0c63300934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indirect register access goes through a DCR bus bridge, which
allows only one outstanding transaction.  And to make matters
worse, each TEMAC IP block contains two Ethernet interfaces, and
although they seem to have separate registers for indirect access,
they actually share the registers.  Or to be more specific, MSW, LSW
and CTL registers are physically shared between Ethernet interfaces
in same TEMAC IP, with RDY register being (almost) specificic to
the Ethernet interface.  The 0x10000 bit in RDY reflects combined
bus ready state though.

So we need to take care to synchronize not only within a single
device, but also between devices in same TEMAC IP.

This commit allows to do that with legacy platform devices.

For OF devices, the xlnx,compound parent of the temac node should be
used to find siblings, and setup a shared indirect_mutex between them.
I will leave this work to somebody else, as I don't have hardware to
test that.  No regression is introduced by that, as before this commit
using two Ethernet interfaces in same TEMAC block is simply broken.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac.h        |  5 ++++-
 drivers/net/ethernet/xilinx/ll_temac_main.c   | 31 +++++++++++++++++----------
 drivers/net/ethernet/xilinx/ll_temac_mdio.c   | 16 +++++++-------
 include/linux/platform_data/xilinx-ll-temac.h |  6 ++++++
 4 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 23d8dd5..990f9ed 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -358,7 +358,10 @@ struct temac_local {
 
 	struct sk_buff **rx_skb;
 	spinlock_t rx_lock;
-	struct mutex indirect_mutex;
+	/* For synchronization of indirect register access.  Must be
+	 * shared mutex between interfaces in same TEMAC block.
+	 */
+	struct mutex *indirect_mutex;
 	u32 options;			/* Current options word */
 	int last_link;
 	unsigned int temac_features;
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 25d9a35..1c5d126 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -346,7 +346,7 @@ static void temac_do_set_mac_address(struct net_device *ndev)
 	struct temac_local *lp = netdev_priv(ndev);
 
 	/* set up unicast MAC address filter set its mac address */
-	mutex_lock(&lp->indirect_mutex);
+	mutex_lock(lp->indirect_mutex);
 	temac_indirect_out32(lp, XTE_UAW0_OFFSET,
 			     (ndev->dev_addr[0]) |
 			     (ndev->dev_addr[1] << 8) |
@@ -357,7 +357,7 @@ static void temac_do_set_mac_address(struct net_device *ndev)
 	temac_indirect_out32(lp, XTE_UAW1_OFFSET,
 			     (ndev->dev_addr[4] & 0x000000ff) |
 			     (ndev->dev_addr[5] << 8));
-	mutex_unlock(&lp->indirect_mutex);
+	mutex_unlock(lp->indirect_mutex);
 }
 
 static int temac_init_mac_address(struct net_device *ndev, const void *address)
@@ -386,7 +386,7 @@ static void temac_set_multicast_list(struct net_device *ndev)
 	u32 multi_addr_msw, multi_addr_lsw, val;
 	int i;
 
-	mutex_lock(&lp->indirect_mutex);
+	mutex_lock(lp->indirect_mutex);
 	if (ndev->flags & (IFF_ALLMULTI | IFF_PROMISC) ||
 	    netdev_mc_count(ndev) > MULTICAST_CAM_TABLE_NUM) {
 		/*
@@ -425,7 +425,7 @@ static void temac_set_multicast_list(struct net_device *ndev)
 		temac_indirect_out32(lp, XTE_MAW1_OFFSET, 0);
 		dev_info(&ndev->dev, "Promiscuous mode disabled.\n");
 	}
-	mutex_unlock(&lp->indirect_mutex);
+	mutex_unlock(lp->indirect_mutex);
 }
 
 static struct temac_option {
@@ -517,7 +517,7 @@ static u32 temac_setoptions(struct net_device *ndev, u32 options)
 	struct temac_option *tp = &temac_options[0];
 	int reg;
 
-	mutex_lock(&lp->indirect_mutex);
+	mutex_lock(lp->indirect_mutex);
 	while (tp->opt) {
 		reg = temac_indirect_in32(lp, tp->reg) & ~tp->m_or;
 		if (options & tp->opt)
@@ -526,7 +526,7 @@ static u32 temac_setoptions(struct net_device *ndev, u32 options)
 		tp++;
 	}
 	lp->options |= options;
-	mutex_unlock(&lp->indirect_mutex);
+	mutex_unlock(lp->indirect_mutex);
 
 	return 0;
 }
@@ -545,7 +545,7 @@ static void temac_device_reset(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "%s()\n", __func__);
 
-	mutex_lock(&lp->indirect_mutex);
+	mutex_lock(lp->indirect_mutex);
 	/* Reset the receiver and wait for it to finish reset */
 	temac_indirect_out32(lp, XTE_RXC1_OFFSET, XTE_RXC1_RXRST_MASK);
 	timeout = 1000;
@@ -597,7 +597,7 @@ static void temac_device_reset(struct net_device *ndev)
 	temac_indirect_out32(lp, XTE_TXC_OFFSET, 0);
 	temac_indirect_out32(lp, XTE_FCC_OFFSET, XTE_FCC_RXFLO_MASK);
 
-	mutex_unlock(&lp->indirect_mutex);
+	mutex_unlock(lp->indirect_mutex);
 
 	/* Sync default options with HW
 	 * but leave receiver and transmitter disabled.  */
@@ -625,7 +625,7 @@ static void temac_adjust_link(struct net_device *ndev)
 	/* hash together the state values to decide if something has changed */
 	link_state = phy->speed | (phy->duplex << 1) | phy->link;
 
-	mutex_lock(&lp->indirect_mutex);
+	mutex_lock(lp->indirect_mutex);
 	if (lp->last_link != link_state) {
 		mii_speed = temac_indirect_in32(lp, XTE_EMCFG_OFFSET);
 		mii_speed &= ~XTE_EMCFG_LINKSPD_MASK;
@@ -641,7 +641,7 @@ static void temac_adjust_link(struct net_device *ndev)
 		lp->last_link = link_state;
 		phy_print_status(phy);
 	}
-	mutex_unlock(&lp->indirect_mutex);
+	mutex_unlock(lp->indirect_mutex);
 }
 
 #ifdef CONFIG_64BIT
@@ -1092,7 +1092,16 @@ static int temac_probe(struct platform_device *pdev)
 	lp->dev = &pdev->dev;
 	lp->options = XTE_OPTION_DEFAULTS;
 	spin_lock_init(&lp->rx_lock);
-	mutex_init(&lp->indirect_mutex);
+
+	/* Setup mutex for synchronization of indirect register access */
+	if (pdata) {
+		if (!pdata->indirect_mutex) {
+			dev_err(&pdev->dev,
+				"indirect_mutex missing in platform_data\n");
+			return -EINVAL;
+		}
+		lp->indirect_mutex = pdata->indirect_mutex;
+	}
 
 	/* map device registers */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/drivers/net/ethernet/xilinx/ll_temac_mdio.c b/drivers/net/ethernet/xilinx/ll_temac_mdio.c
index c5307e5..c2a1170 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_mdio.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_mdio.c
@@ -29,10 +29,10 @@ static int temac_mdio_read(struct mii_bus *bus, int phy_id, int reg)
 	/* Write the PHY address to the MIIM Access Initiator register.
 	 * When the transfer completes, the PHY register value will appear
 	 * in the LSW0 register */
-	mutex_lock(&lp->indirect_mutex);
+	mutex_lock(lp->indirect_mutex);
 	temac_iow(lp, XTE_LSW0_OFFSET, (phy_id << 5) | reg);
 	rc = temac_indirect_in32(lp, XTE_MIIMAI_OFFSET);
-	mutex_unlock(&lp->indirect_mutex);
+	mutex_unlock(lp->indirect_mutex);
 
 	dev_dbg(lp->dev, "temac_mdio_read(phy_id=%i, reg=%x) == %x\n",
 		phy_id, reg, rc);
@@ -50,10 +50,10 @@ static int temac_mdio_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
 	/* First write the desired value into the write data register
 	 * and then write the address into the access initiator register
 	 */
-	mutex_lock(&lp->indirect_mutex);
+	mutex_lock(lp->indirect_mutex);
 	temac_indirect_out32(lp, XTE_MGTDR_OFFSET, val);
 	temac_indirect_out32(lp, XTE_MIIMAI_OFFSET, (phy_id << 5) | reg);
-	mutex_unlock(&lp->indirect_mutex);
+	mutex_unlock(lp->indirect_mutex);
 
 	return 0;
 }
@@ -87,9 +87,9 @@ int temac_mdio_setup(struct temac_local *lp, struct platform_device *pdev)
 
 	/* Enable the MDIO bus by asserting the enable bit and writing
 	 * in the clock config */
-	mutex_lock(&lp->indirect_mutex);
+	mutex_lock(lp->indirect_mutex);
 	temac_indirect_out32(lp, XTE_MC_OFFSET, 1 << 6 | clk_div);
-	mutex_unlock(&lp->indirect_mutex);
+	mutex_unlock(lp->indirect_mutex);
 
 	bus = devm_mdiobus_alloc(&pdev->dev);
 	if (!bus)
@@ -116,10 +116,10 @@ int temac_mdio_setup(struct temac_local *lp, struct platform_device *pdev)
 	if (rc)
 		return rc;
 
-	mutex_lock(&lp->indirect_mutex);
+	mutex_lock(lp->indirect_mutex);
 	dev_dbg(lp->dev, "MDIO bus registered;  MC:%x\n",
 		temac_indirect_in32(lp, XTE_MC_OFFSET));
-	mutex_unlock(&lp->indirect_mutex);
+	mutex_unlock(lp->indirect_mutex);
 	return 0;
 }
 
diff --git a/include/linux/platform_data/xilinx-ll-temac.h b/include/linux/platform_data/xilinx-ll-temac.h
index af87927..b0b8238 100644
--- a/include/linux/platform_data/xilinx-ll-temac.h
+++ b/include/linux/platform_data/xilinx-ll-temac.h
@@ -16,6 +16,12 @@ struct ll_temac_platform_data {
 	phy_interface_t phy_interface; /* PHY interface mode */
 	bool reg_little_endian;	/* Little endian TEMAC register access  */
 	bool dma_little_endian;	/* Little endian DMA register access  */
+	/* Pre-initialized mutex to use for synchronizing indirect
+	 * register access.  When using both interfaces of a single
+	 * TEMAC IP block, the same mutex should be passed here, as
+	 * they share the same DCR bus bridge.
+	 */
+	struct mutex *indirect_mutex;
 };
 
 #endif /* __LINUX_XILINX_LL_TEMAC_H */
-- 
2.4.11

