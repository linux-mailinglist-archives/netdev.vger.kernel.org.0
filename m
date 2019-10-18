Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5822FDBFE4
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 10:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632817AbfJRI2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 04:28:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:49124 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2632790AbfJRI2n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 04:28:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2E01EAD87;
        Fri, 18 Oct 2019 08:28:39 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Stefan Wahren <wahrenst@gmx.net>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] net: usb: lan78xx: Use phy_mac_interrupt() for interrupt handling
Date:   Fri, 18 Oct 2019 10:28:17 +0200
Message-Id: <20191018082817.111480-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

handle_simple_irq() expect interrupts to be disabled. The USB
framework is using threaded interrupts, which implies that interrupts
are re-enabled as soon as it has run.

This reverts the changes from cc89c323a30e ("lan78xx: Use irq_domain
for phy interrupt from USB Int. EP").

[    4.886203] 000: irq 79 handler irq_default_primary_handler+0x0/0x8 enabled interrupts
[    4.886243] 000: WARNING: CPU: 0 PID: 0 at kernel/irq/handle.c:152 __handle_irq_event_percpu+0x154/0x168
[    4.896294] 000: Modules linked in:
[    4.896301] 000: CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.6 #39
[    4.896310] 000: Hardware name: Raspberry Pi 3 Model B+ (DT)
[    4.896315] 000: pstate: 60000005 (nZCv daif -PAN -UAO)
[    4.896321] 000: pc : __handle_irq_event_percpu+0x154/0x168
[    4.896331] 000: lr : __handle_irq_event_percpu+0x154/0x168
[    4.896339] 000: sp : ffff000010003cc0
[    4.896346] 000: x29: ffff000010003cc0 x28: 0000000000000060
[    4.896355] 000: x27: ffff000011021980 x26: ffff00001189c72b
[    4.896364] 000: x25: ffff000011702bc0 x24: ffff800036d6e400
[    4.896373] 000: x23: 000000000000004f x22: ffff000010003d64
[    4.896381] 000: x21: 0000000000000000 x20: 0000000000000002
[    4.896390] 000: x19: ffff8000371c8480 x18: 0000000000000060
[    4.896398] 000: x17: 0000000000000000 x16: 00000000000000eb
[    4.896406] 000: x15: ffff000011712d18 x14: 7265746e69206465
[    4.896414] 000: x13: ffff000010003ba0 x12: ffff000011712df0
[    4.896422] 000: x11: 0000000000000001 x10: ffff000011712e08
[    4.896430] 000: x9 : 0000000000000001 x8 : 000000000003c920
[    4.896437] 000: x7 : ffff0000118cc410 x6 : ffff0000118c7f00
[    4.896445] 000: x5 : 000000000003c920 x4 : 0000000000004510
[    4.896453] 000: x3 : ffff000011712dc8 x2 : 0000000000000000
[    4.896461] 000: x1 : 73a3f67df94c1500 x0 : 0000000000000000
[    4.896466] 000: Call trace:
[    4.896471] 000:  __handle_irq_event_percpu+0x154/0x168
[    4.896481] 000:  handle_irq_event_percpu+0x50/0xb0
[    4.896489] 000:  handle_irq_event+0x40/0x98
[    4.896497] 000:  handle_simple_irq+0xa4/0xf0
[    4.896505] 000:  generic_handle_irq+0x24/0x38
[    4.896513] 000:  intr_complete+0xb0/0xe0
[    4.896525] 000:  __usb_hcd_giveback_urb+0x58/0xd8
[    4.896533] 000:  usb_giveback_urb_bh+0xd0/0x170
[    4.896539] 000:  tasklet_action_common.isra.0+0x9c/0x128
[    4.896549] 000:  tasklet_hi_action+0x24/0x30
[    4.896556] 000:  __do_softirq+0x120/0x23c
[    4.896564] 000:  irq_exit+0xb8/0xd8
[    4.896571] 000:  __handle_domain_irq+0x64/0xb8
[    4.896579] 000:  bcm2836_arm_irqchip_handle_irq+0x60/0xc0
[    4.896586] 000:  el1_irq+0xb8/0x140
[    4.896592] 000:  arch_cpu_idle+0x10/0x18
[    4.896601] 000:  do_idle+0x200/0x280
[    4.896608] 000:  cpu_startup_entry+0x20/0x28
[    4.896615] 000:  rest_init+0xb4/0xc0
[    4.896623] 000:  arch_call_rest_init+0xc/0x14
[    4.896632] 000:  start_kernel+0x454/0x480

[dwagner: Updated Jisheng's initial patch]

Fixes: cc89c323a30e ("lan78xx: Use irq_domain for phy interrupt from USB Int. EP")
Cc: Woojung Huh <woojung.huh@microchip.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Stefan Wahren <wahrenst@gmx.net>
Cc: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
Hi,

With Andrew's "net: usb: lan78xx: Connect PHY before registering MAC"
and this patch I am able to boot and use the RPi3 with -rt.

There was already a lot of dicussion on this topic but no fixes so
far. So I just suggest to revert the original commit since it is not
clear to me what it fixes:

https://www.spinics.net/lists/netdev/msg542290.html
https://marc.info/?l=linux-netdev&m=154604180927252&w=2
https://patchwork.kernel.org/patch/10888797/

Without this revert RPi3 is not usable for -rt at this point.

Thanks,
Daniel

 drivers/net/usb/lan78xx.c | 208 +++-----------------------------------
 1 file changed, 16 insertions(+), 192 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 58f5a219fb65..f96c7ff3edd4 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -20,10 +20,6 @@
 #include <linux/mdio.h>
 #include <linux/phy.h>
 #include <net/ip6_checksum.h>
-#include <linux/interrupt.h>
-#include <linux/irqdomain.h>
-#include <linux/irq.h>
-#include <linux/irqchip/chained_irq.h>
 #include <linux/microchipphy.h>
 #include <linux/phy_fixed.h>
 #include <linux/of_mdio.h>
@@ -87,38 +83,6 @@
 /* statistic update interval (mSec) */
 #define STAT_UPDATE_TIMER		(1 * 1000)
 
-/* defines interrupts from interrupt EP */
-#define MAX_INT_EP			(32)
-#define INT_EP_INTEP			(31)
-#define INT_EP_OTP_WR_DONE		(28)
-#define INT_EP_EEE_TX_LPI_START		(26)
-#define INT_EP_EEE_TX_LPI_STOP		(25)
-#define INT_EP_EEE_RX_LPI		(24)
-#define INT_EP_MAC_RESET_TIMEOUT	(23)
-#define INT_EP_RDFO			(22)
-#define INT_EP_TXE			(21)
-#define INT_EP_USB_STATUS		(20)
-#define INT_EP_TX_DIS			(19)
-#define INT_EP_RX_DIS			(18)
-#define INT_EP_PHY			(17)
-#define INT_EP_DP			(16)
-#define INT_EP_MAC_ERR			(15)
-#define INT_EP_TDFU			(14)
-#define INT_EP_TDFO			(13)
-#define INT_EP_UTX			(12)
-#define INT_EP_GPIO_11			(11)
-#define INT_EP_GPIO_10			(10)
-#define INT_EP_GPIO_9			(9)
-#define INT_EP_GPIO_8			(8)
-#define INT_EP_GPIO_7			(7)
-#define INT_EP_GPIO_6			(6)
-#define INT_EP_GPIO_5			(5)
-#define INT_EP_GPIO_4			(4)
-#define INT_EP_GPIO_3			(3)
-#define INT_EP_GPIO_2			(2)
-#define INT_EP_GPIO_1			(1)
-#define INT_EP_GPIO_0			(0)
-
 static const char lan78xx_gstrings[][ETH_GSTRING_LEN] = {
 	"RX FCS Errors",
 	"RX Alignment Errors",
@@ -350,15 +314,6 @@ struct statstage {
 	struct lan78xx_statstage64	curr_stat;
 };
 
-struct irq_domain_data {
-	struct irq_domain	*irqdomain;
-	unsigned int		phyirq;
-	struct irq_chip		*irqchip;
-	irq_flow_handler_t	irq_handler;
-	u32			irqenable;
-	struct mutex		irq_lock;		/* for irq bus access */
-};
-
 struct lan78xx_net {
 	struct net_device	*net;
 	struct usb_device	*udev;
@@ -415,8 +370,6 @@ struct lan78xx_net {
 
 	int			delta;
 	struct statstage	stats;
-
-	struct irq_domain_data	domain_data;
 };
 
 /* define external phy id */
@@ -1251,6 +1204,7 @@ static void lan78xx_defer_kevent(struct lan78xx_net *dev, int work)
 static void lan78xx_status(struct lan78xx_net *dev, struct urb *urb)
 {
 	u32 intdata;
+	struct phy_device *phydev = dev->net->phydev;
 
 	if (urb->actual_length != 4) {
 		netdev_warn(dev->net,
@@ -1264,8 +1218,7 @@ static void lan78xx_status(struct lan78xx_net *dev, struct urb *urb)
 		netif_dbg(dev, link, dev->net, "PHY INTR: 0x%08x\n", intdata);
 		lan78xx_defer_kevent(dev, EVENT_LINK_RESET);
 
-		if (dev->domain_data.phyirq > 0)
-			generic_handle_irq(dev->domain_data.phyirq);
+		phy_mac_interrupt(phydev);
 	} else
 		netdev_warn(dev->net,
 			    "unexpected interrupt: 0x%08x\n", intdata);
@@ -1874,127 +1827,6 @@ static void lan78xx_link_status_change(struct net_device *net)
 	}
 }
 
-static int irq_map(struct irq_domain *d, unsigned int irq,
-		   irq_hw_number_t hwirq)
-{
-	struct irq_domain_data *data = d->host_data;
-
-	irq_set_chip_data(irq, data);
-	irq_set_chip_and_handler(irq, data->irqchip, data->irq_handler);
-	irq_set_noprobe(irq);
-
-	return 0;
-}
-
-static void irq_unmap(struct irq_domain *d, unsigned int irq)
-{
-	irq_set_chip_and_handler(irq, NULL, NULL);
-	irq_set_chip_data(irq, NULL);
-}
-
-static const struct irq_domain_ops chip_domain_ops = {
-	.map	= irq_map,
-	.unmap	= irq_unmap,
-};
-
-static void lan78xx_irq_mask(struct irq_data *irqd)
-{
-	struct irq_domain_data *data = irq_data_get_irq_chip_data(irqd);
-
-	data->irqenable &= ~BIT(irqd_to_hwirq(irqd));
-}
-
-static void lan78xx_irq_unmask(struct irq_data *irqd)
-{
-	struct irq_domain_data *data = irq_data_get_irq_chip_data(irqd);
-
-	data->irqenable |= BIT(irqd_to_hwirq(irqd));
-}
-
-static void lan78xx_irq_bus_lock(struct irq_data *irqd)
-{
-	struct irq_domain_data *data = irq_data_get_irq_chip_data(irqd);
-
-	mutex_lock(&data->irq_lock);
-}
-
-static void lan78xx_irq_bus_sync_unlock(struct irq_data *irqd)
-{
-	struct irq_domain_data *data = irq_data_get_irq_chip_data(irqd);
-	struct lan78xx_net *dev =
-			container_of(data, struct lan78xx_net, domain_data);
-	u32 buf;
-	int ret;
-
-	/* call register access here because irq_bus_lock & irq_bus_sync_unlock
-	 * are only two callbacks executed in non-atomic contex.
-	 */
-	ret = lan78xx_read_reg(dev, INT_EP_CTL, &buf);
-	if (buf != data->irqenable)
-		ret = lan78xx_write_reg(dev, INT_EP_CTL, data->irqenable);
-
-	mutex_unlock(&data->irq_lock);
-}
-
-static struct irq_chip lan78xx_irqchip = {
-	.name			= "lan78xx-irqs",
-	.irq_mask		= lan78xx_irq_mask,
-	.irq_unmask		= lan78xx_irq_unmask,
-	.irq_bus_lock		= lan78xx_irq_bus_lock,
-	.irq_bus_sync_unlock	= lan78xx_irq_bus_sync_unlock,
-};
-
-static int lan78xx_setup_irq_domain(struct lan78xx_net *dev)
-{
-	struct device_node *of_node;
-	struct irq_domain *irqdomain;
-	unsigned int irqmap = 0;
-	u32 buf;
-	int ret = 0;
-
-	of_node = dev->udev->dev.parent->of_node;
-
-	mutex_init(&dev->domain_data.irq_lock);
-
-	lan78xx_read_reg(dev, INT_EP_CTL, &buf);
-	dev->domain_data.irqenable = buf;
-
-	dev->domain_data.irqchip = &lan78xx_irqchip;
-	dev->domain_data.irq_handler = handle_simple_irq;
-
-	irqdomain = irq_domain_add_simple(of_node, MAX_INT_EP, 0,
-					  &chip_domain_ops, &dev->domain_data);
-	if (irqdomain) {
-		/* create mapping for PHY interrupt */
-		irqmap = irq_create_mapping(irqdomain, INT_EP_PHY);
-		if (!irqmap) {
-			irq_domain_remove(irqdomain);
-
-			irqdomain = NULL;
-			ret = -EINVAL;
-		}
-	} else {
-		ret = -EINVAL;
-	}
-
-	dev->domain_data.irqdomain = irqdomain;
-	dev->domain_data.phyirq = irqmap;
-
-	return ret;
-}
-
-static void lan78xx_remove_irq_domain(struct lan78xx_net *dev)
-{
-	if (dev->domain_data.phyirq > 0) {
-		irq_dispose_mapping(dev->domain_data.phyirq);
-
-		if (dev->domain_data.irqdomain)
-			irq_domain_remove(dev->domain_data.irqdomain);
-	}
-	dev->domain_data.phyirq = 0;
-	dev->domain_data.irqdomain = NULL;
-}
-
 static int lan8835_fixup(struct phy_device *phydev)
 {
 	int buf;
@@ -2123,16 +1955,15 @@ static int lan78xx_phy_init(struct lan78xx_net *dev)
 		return -EIO;
 	}
 
-	/* if phyirq is not set, use polling mode in phylib */
-	if (dev->domain_data.phyirq > 0)
-		phydev->irq = dev->domain_data.phyirq;
-	else
-		phydev->irq = 0;
-	netdev_dbg(dev->net, "phydev->irq = %d\n", phydev->irq);
-
 	/* set to AUTOMDIX */
 	phydev->mdix = ETH_TP_MDI_AUTO;
 
+	ret = phy_read(phydev, LAN88XX_INT_STS);
+	ret = phy_write(phydev, LAN88XX_INT_MASK,
+			LAN88XX_INT_MASK_MDINTPIN_EN_ |
+			LAN88XX_INT_MASK_LINK_CHANGE_);
+	phydev->irq = PHY_IGNORE_INTERRUPT;
+
 	ret = phy_connect_direct(dev->net, phydev,
 				 lan78xx_link_status_change,
 				 dev->interface);
@@ -2570,6 +2401,11 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 	}
 	ret = lan78xx_write_reg(dev, MAC_CR, buf);
 
+	/* enable PHY interrupts */
+	ret = lan78xx_read_reg(dev, INT_EP_CTL, &buf);
+	buf |= INT_ENP_PHY_INT;
+	ret = lan78xx_write_reg(dev, INT_EP_CTL, buf);
+
 	ret = lan78xx_read_reg(dev, MAC_TX, &buf);
 	buf |= MAC_TX_TXEN_;
 	ret = lan78xx_write_reg(dev, MAC_TX, buf);
@@ -2977,13 +2813,6 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 
 	dev->net->hw_features = dev->net->features;
 
-	ret = lan78xx_setup_irq_domain(dev);
-	if (ret < 0) {
-		netdev_warn(dev->net,
-			    "lan78xx_setup_irq_domain() failed : %d", ret);
-		goto out1;
-	}
-
 	dev->net->hard_header_len += TX_OVERHEAD;
 	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
 
@@ -2991,13 +2820,13 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 	ret = lan78xx_reset(dev);
 	if (ret) {
 		netdev_warn(dev->net, "Registers INIT FAILED....");
-		goto out2;
+		goto out;
 	}
 
 	ret = lan78xx_mdio_init(dev);
 	if (ret) {
 		netdev_warn(dev->net, "MDIO INIT FAILED.....");
-		goto out2;
+		goto out;
 	}
 
 	dev->net->flags |= IFF_MULTICAST;
@@ -3006,10 +2835,7 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 
 	return ret;
 
-out2:
-	lan78xx_remove_irq_domain(dev);
-
-out1:
+out:
 	netdev_warn(dev->net, "Bind routine FAILED");
 	cancel_work_sync(&pdata->set_multicast);
 	cancel_work_sync(&pdata->set_vlan);
@@ -3021,8 +2847,6 @@ static void lan78xx_unbind(struct lan78xx_net *dev, struct usb_interface *intf)
 {
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
 
-	lan78xx_remove_irq_domain(dev);
-
 	lan78xx_remove_mdio(dev);
 
 	if (pdata) {
-- 
2.21.0

