Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD26642CB4C
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhJMUrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhJMUqu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:46:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96E88611AE;
        Wed, 13 Oct 2021 20:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157886;
        bh=0nsH5JzpS+cDxXSdXa1drDcQKUBZOZabEIHq9PAOIrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nixRvxHgSf72z7+945QX0+MtWRKFrGwp6GaHPdn0GFr8GICtW06KNKT0x87LhS5Cv
         r/3Rvxrp/BBP7ouhMzGbiPa/6oB1X6fJxXywB6+nQVWWH8rowXBhWRE7+i1jGbcG9k
         WXk9RrsdpfHDr+WYCClwVZKqm0l+EKwr06VwEtq19bZcOnVlunSSZEDcVs4IEIQj90
         ufUUXZu130+/2v+2v3LlCthXe3R4/QF1z3z8L/GRWwXoIL7TheKnmKFJO0SpPYuZtO
         Rcdu7+y8hlkBOcJYoV2o6ZvkpAThUSaMEpsiwsCleBd+0lLXEOwfmhfjZCn7vJ8Ig3
         82iQZEJcB+T1Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        sammy@sammy.net, christopher.lee@cspi.com,
        grygorii.strashko@ti.com, linux@dominikbrodowski.net,
        linux-omap@vger.kernel.org
Subject: [PATCH net-next 6/7] ethernet: replace netdev->dev_addr assignment loops
Date:   Wed, 13 Oct 2021 13:44:34 -0700
Message-Id: <20211013204435.322561-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013204435.322561-1-kuba@kernel.org>
References: <20211013204435.322561-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A handful of drivers contains loops assigning the mac
addr byte by byte. Convert those to eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: sammy@sammy.net
CC: christopher.lee@cspi.com
CC: grygorii.strashko@ti.com
CC: linux@dominikbrodowski.net
CC: linux-omap@vger.kernel.org
---
 drivers/net/ethernet/amd/sun3lance.c             | 4 +---
 drivers/net/ethernet/amd/sunlance.c              | 4 +---
 drivers/net/ethernet/apple/bmac.c                | 7 ++-----
 drivers/net/ethernet/dlink/dl2k.c                | 3 +--
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c        | 7 ++-----
 drivers/net/ethernet/i825xx/sun3_82586.c         | 5 ++---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 4 +---
 drivers/net/ethernet/smsc/smc91c92_cs.c          | 5 ++---
 drivers/net/ethernet/sun/sunbmac.c               | 4 +---
 drivers/net/ethernet/ti/davinci_emac.c           | 4 +---
 drivers/pcmcia/pcmcia_cis.c                      | 5 ++---
 net/atm/lec.c                                    | 3 +--
 12 files changed, 17 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/amd/sun3lance.c b/drivers/net/ethernet/amd/sun3lance.c
index 4a845bc071b2..007bd7787291 100644
--- a/drivers/net/ethernet/amd/sun3lance.c
+++ b/drivers/net/ethernet/amd/sun3lance.c
@@ -305,7 +305,6 @@ static int __init lance_probe( struct net_device *dev)
 	unsigned long ioaddr;
 
 	struct lance_private	*lp;
-	int 			i;
 	static int 		did_version;
 	volatile unsigned short *ioaddr_probe;
 	unsigned short tmp1, tmp2;
@@ -373,8 +372,7 @@ static int __init lance_probe( struct net_device *dev)
 		   dev->irq);
 
 	/* copy in the ethernet address from the prom */
-	for(i = 0; i < 6 ; i++)
-	     dev->dev_addr[i] = idprom->id_ethaddr[i];
+	eth_hw_addr_set(dev, idprom->id_ethaddr);
 
 	/* tell the card it's ether address, bytes swapped */
 	MEM->init.hwaddr[0] = dev->dev_addr[1];
diff --git a/drivers/net/ethernet/amd/sunlance.c b/drivers/net/ethernet/amd/sunlance.c
index ddece276ae23..22d609563af8 100644
--- a/drivers/net/ethernet/amd/sunlance.c
+++ b/drivers/net/ethernet/amd/sunlance.c
@@ -1301,7 +1301,6 @@ static int sparc_lance_probe_one(struct platform_device *op,
 	struct device_node *dp = op->dev.of_node;
 	struct lance_private *lp;
 	struct net_device *dev;
-	int    i;
 
 	dev = alloc_etherdev(sizeof(struct lance_private) + 8);
 	if (!dev)
@@ -1315,8 +1314,7 @@ static int sparc_lance_probe_one(struct platform_device *op,
 	 * will copy the address in the device structure to the lance
 	 * initialization block.
 	 */
-	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = idprom->id_ethaddr[i];
+	eth_hw_addr_set(dev, idprom->id_ethaddr);
 
 	/* Get the IO region */
 	lp->lregs = of_ioremap(&op->resource[0], 0,
diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index a63ec2005af3..9a650d1c1bdd 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -521,17 +521,14 @@ static int bmac_resume(struct macio_dev *mdev)
 static int bmac_set_address(struct net_device *dev, void *addr)
 {
 	struct bmac_data *bp = netdev_priv(dev);
-	unsigned char *p = addr;
 	const unsigned short *pWord16;
 	unsigned long flags;
-	int i;
 
 	XXDEBUG(("bmac: enter set_address\n"));
 	spin_lock_irqsave(&bp->lock, flags);
 
-	for (i = 0; i < 6; ++i) {
-		dev->dev_addr[i] = p[i];
-	}
+	eth_hw_addr_set(dev, addr);
+
 	/* load up the hardware address */
 	pWord16  = (const unsigned short *)dev->dev_addr;
 	bmwrite(dev, MADD0, *pWord16++);
diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index 993bba0ffb16..a301f7e6a440 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -349,8 +349,7 @@ parse_eeprom (struct net_device *dev)
 	}
 
 	/* Set MAC address */
-	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = psrom->mac_addr[i];
+	eth_hw_addr_set(dev, psrom->mac_addr);
 
 	if (np->chip_id == CHIP_IP1000A) {
 		np->led_mode = psrom->led_mode;
diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
index 62c0bed82ced..62600153b964 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -468,8 +468,7 @@ static int fmvj18x_config(struct pcmcia_device *link)
 		    goto failed;
 	    }
 	    /* Read MACID from CIS */
-	    for (i = 0; i < 6; i++)
-		    dev->dev_addr[i] = buf[i + 5];
+	    eth_hw_addr_set(dev, &buf[5]);
 	    kfree(buf);
 	} else {
 	    if (pcmcia_get_mac_from_cis(link, dev))
@@ -499,9 +498,7 @@ static int fmvj18x_config(struct pcmcia_device *link)
 	    pr_notice("unable to read hardware net address\n");
 	    goto failed;
 	}
-	for (i = 0 ; i < 6; i++) {
-	    dev->dev_addr[i] = buggybuf[i];
-	}
+	eth_hw_addr_set(dev, buggybuf);
 	card_name = "FMV-J182";
 	break;
     case MBH10302:
diff --git a/drivers/net/ethernet/i825xx/sun3_82586.c b/drivers/net/ethernet/i825xx/sun3_82586.c
index 18d32302c3c7..3909c6a0af89 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -339,14 +339,13 @@ static const struct net_device_ops sun3_82586_netdev_ops = {
 
 static int __init sun3_82586_probe1(struct net_device *dev,int ioaddr)
 {
-	int i, size, retval;
+	int size, retval;
 
 	if (!request_region(ioaddr, SUN3_82586_TOTAL_SIZE, DRV_NAME))
 		return -EBUSY;
 
 	/* copy in the ethernet address from the prom */
-	for(i = 0; i < 6 ; i++)
-	     dev->dev_addr[i] = idprom->id_ethaddr[i];
+	eth_hw_addr_set(dev, idprom->id_ethaddr);
 
 	printk("%s: SUN3 Intel 82586 found at %lx, ",dev->name,dev->base_addr);
 
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 5ae59b1e5b48..5736fcdafd7a 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3739,7 +3739,6 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct net_device *netdev;
 	struct myri10ge_priv *mgp;
 	struct device *dev = &pdev->dev;
-	int i;
 	int status = -ENXIO;
 	int dac_enabled;
 	unsigned hdr_offset, ss_offset;
@@ -3829,8 +3828,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (status)
 		goto abort_with_ioremap;
 
-	for (i = 0; i < ETH_ALEN; i++)
-		netdev->dev_addr[i] = mgp->mac_addr[i];
+	eth_hw_addr_set(netdev, mgp->mac_addr);
 
 	myri10ge_select_firmware(mgp);
 
diff --git a/drivers/net/ethernet/smsc/smc91c92_cs.c b/drivers/net/ethernet/smsc/smc91c92_cs.c
index 42fc37c7887a..e5658aa39765 100644
--- a/drivers/net/ethernet/smsc/smc91c92_cs.c
+++ b/drivers/net/ethernet/smsc/smc91c92_cs.c
@@ -666,14 +666,13 @@ static int pcmcia_osi_mac(struct pcmcia_device *p_dev,
 			  void *priv)
 {
 	struct net_device *dev = priv;
-	int i;
 
 	if (tuple->TupleDataLen < 8)
 		return -EINVAL;
 	if (tuple->TupleData[0] != 0x04)
 		return -EINVAL;
-	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = tuple->TupleData[i+2];
+
+	eth_hw_addr_set(dev, &tuple->TupleData[2]);
 	return 0;
 };
 
diff --git a/drivers/net/ethernet/sun/sunbmac.c b/drivers/net/ethernet/sun/sunbmac.c
index d70426670c37..531a6f449afa 100644
--- a/drivers/net/ethernet/sun/sunbmac.c
+++ b/drivers/net/ethernet/sun/sunbmac.c
@@ -1076,7 +1076,6 @@ static int bigmac_ether_init(struct platform_device *op,
 	struct net_device *dev;
 	u8 bsizes, bsizes_more;
 	struct bigmac *bp;
-	int i;
 
 	/* Get a new device struct for this interface. */
 	dev = alloc_etherdev(sizeof(struct bigmac));
@@ -1086,8 +1085,7 @@ static int bigmac_ether_init(struct platform_device *op,
 	if (version_printed++ == 0)
 		printk(KERN_INFO "%s", version);
 
-	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = idprom->id_ethaddr[i];
+	eth_hw_addr_set(dev, idprom->id_ethaddr);
 
 	/* Setup softc, with backpointers to QEC and BigMAC SBUS device structs. */
 	bp = netdev_priv(dev);
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 4538e597eefe..2d2dcf70563f 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1402,7 +1402,6 @@ static int match_first_device(struct device *dev, const void *data)
 static int emac_dev_open(struct net_device *ndev)
 {
 	struct device *emac_dev = &ndev->dev;
-	u32 cnt;
 	struct resource *res;
 	int q, m, ret;
 	int res_num = 0, irq_num = 0;
@@ -1420,8 +1419,7 @@ static int emac_dev_open(struct net_device *ndev)
 	}
 
 	netif_carrier_off(ndev);
-	for (cnt = 0; cnt < ETH_ALEN; cnt++)
-		ndev->dev_addr[cnt] = priv->mac_addr[cnt];
+	eth_hw_addr_set(ndev, priv->mac_addr);
 
 	/* Configuration items */
 	priv->rx_buf_size = EMAC_DEF_MAX_FRAME_SIZE + NET_IP_ALIGN;
diff --git a/drivers/pcmcia/pcmcia_cis.c b/drivers/pcmcia/pcmcia_cis.c
index d2d0ed4b27c8..f650e19a315c 100644
--- a/drivers/pcmcia/pcmcia_cis.c
+++ b/drivers/pcmcia/pcmcia_cis.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 
 #include <pcmcia/cisreg.h>
 #include <pcmcia/cistpl.h>
@@ -398,7 +399,6 @@ static int pcmcia_do_get_mac(struct pcmcia_device *p_dev, tuple_t *tuple,
 			     void *priv)
 {
 	struct net_device *dev = priv;
-	int i;
 
 	if (tuple->TupleData[0] != CISTPL_FUNCE_LAN_NODE_ID)
 		return -EINVAL;
@@ -412,8 +412,7 @@ static int pcmcia_do_get_mac(struct pcmcia_device *p_dev, tuple_t *tuple,
 		dev_warn(&p_dev->dev, "Invalid header for LAN_NODE_ID\n");
 		return -EINVAL;
 	}
-	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = tuple->TupleData[i+2];
+	eth_hw_addr_set(dev, &tuple->TupleData[2]);
 	return 0;
 }
 
diff --git a/net/atm/lec.c b/net/atm/lec.c
index 7226c784dbe0..8eaea4a4bbd6 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -355,8 +355,7 @@ static int lec_atm_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	pr_debug("%s: msg from zeppelin:%d\n", dev->name, mesg->type);
 	switch (mesg->type) {
 	case l_set_mac_addr:
-		for (i = 0; i < 6; i++)
-			dev->dev_addr[i] = mesg->content.normal.mac_addr[i];
+		eth_hw_addr_set(dev, mesg->content.normal.mac_addr);
 		break;
 	case l_del_mac_addr:
 		for (i = 0; i < 6; i++)
-- 
2.31.1

