Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F8CDB944
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 23:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503700AbfJQVpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 17:45:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34531 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503658AbfJQVpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 17:45:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id j11so4014707wrp.1;
        Thu, 17 Oct 2019 14:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MNsgKAtQ0KgFFbU5Na6usgHwsfWWAKmWNlB+nOhJPPQ=;
        b=Bohytz9+rVt+Py6fgIDeKYU+ldsJMSdr0oiCRblSb2vbZzXAY4gC1TQyx771r6tLYb
         Ks8+BB0T8FeODOtB2gKrQg59LX/eT490ucTgjv8X89fGp7HwzC+aiPNXNqGS9bXD9fBd
         rn4H/KAXfLU0p62uhm2SQ0vyRBvQeCHILY1QfO7/ne8PBlpZjILe5x277TZKOTbyqog3
         ryS1u2zoLCzG2ZEjUFJb5VhwevpbK3DsFqsUzfTEnIPnBGz6MiACgzQfNGYqCMTcU1d9
         5hP4D9/UIXjEwzcw+4PGxsT1kkZwC8rywqpx2qnUOKWYJY6wLZT7MjLOhPwW6le9aGe7
         xQrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MNsgKAtQ0KgFFbU5Na6usgHwsfWWAKmWNlB+nOhJPPQ=;
        b=TIJN1pJ7KwF++2UAQKpsDUNVp68SXGSu+wiBGyANro5Wi4883yDWfo0Wd/OaeoOOJN
         36C8FGJRYpevfesYEJBTggS1OaSCoAT5K47qyiFnC0su/qQjSzFOntfzdaCW89LahQI0
         462l7HOtwW+RmVvXBF63G9nLEqbW4htsm14uYuXCr3gYZoFBppwZlz/4ZWCKwC2gWBNW
         JLSzqIohvGx6R759YSuatVs+Jz6Dhob9Gzii50A3tYfVgxK8sN6HkELxVjceDNnRxwt+
         IX4eXCSGUrLCzFYeJybjQ9e2ppjBuCh+YOhQK+Jibxun7vr8usmHHytfqq6VXXHNiosJ
         kxyw==
X-Gm-Message-State: APjAAAWBYzUbXpEk8huyumnSNkWCOx3gPHg9M8HFmCJyNVYM4eR9b5GW
        hOpO36StvzdP3ykd4LSCgUpymjGe
X-Google-Smtp-Source: APXvYqziUOp+A5z/T2NY2WqmUO8wSGierJFS14Pl6QrNlXvrL9P2oJTf+mOnCiXs1sXwXNlnz+cLkg==
X-Received: by 2002:adf:db81:: with SMTP id u1mr4736158wri.347.1571348711901;
        Thu, 17 Oct 2019 14:45:11 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t203sm3977294wmf.42.2019.10.17.14.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 14:45:10 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list), hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, olteanv@gmail.com,
        rmk+kernel@armlinux.org.uk, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Subject: [PATCH net-next v2 2/2] net: phy: Add ability to debug RGMII connections
Date:   Thu, 17 Oct 2019 14:44:53 -0700
Message-Id: <20191017214453.18934-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191017214453.18934-1-f.fainelli@gmail.com>
References: <20191017214453.18934-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGMII connections are always troublesome because of the need to add
delays between the RX or TX clocks and data lines. This can lead to a
fair amount of breakage that upsets users.

Introduce a new sysfs write only attribute which can be set to 1 to
instruct the PHY library to attempt to probe what the correct RGMII
phy_interface_t value should be. When such debugging is requested, the
PHY library will do a number of checks whether this debugging is even
necessary (RGMII used, Gigabit, not a Generic PHY driver etc.) and if
successfull will proceed with:

- putting the PHY in loopback mode
- register a packet handler with an unused Ethernet type value in the
  kernel (ETH_P_EDSA is a well known unused value)
- re-configure the PHY and MAC with the phy_interface_t value to be
  tried, which is one of the 4 possible interfaces, starting with the
  currently defined one
- craft a MTU sized packet with the Ethernet interface's MAC SA and DA
  set to itself and send that in a process context
- wait for that packet to be received through the registered packet_type
  handler

If the packet is not received, we have a problem with the RGMII
interface, if we do receive something, we check the FCS we calculated on
transmit matches the FCS of the packet received, if we have a mismatch
it most likely will not.

If all is well, we stop iterating over all possible RGMII combinations
and offer the one that is deemed suitable which is what an user should
be trying by configuring the platform appropriately.

This is not deemed to be 100% fool proof, but given how much support
getting RGMII seems to involved, this seemed like a good tool to have
users self-diagnose their connection issues.

Future improvements could be made in order to extrapolate from a
specific frame patter the type of skewing between RXC/TXC that is going
on so as to refine the search process, and even possibly suggest delays.

The function phy_rgmii_debug_probe() could also be used by an Ethernet
controller during its selftests routines instead of open-coding that
part.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../ABI/testing/sysfs-class-net-phydev        |  11 +
 drivers/net/phy/Kconfig                       |   9 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/phy-rgmii-debug.c             | 284 ++++++++++++++++++
 drivers/net/phy/phy_device.c                  |  31 ++
 include/linux/phy.h                           |   9 +
 6 files changed, 345 insertions(+)
 create mode 100644 drivers/net/phy/phy-rgmii-debug.c

diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documentation/ABI/testing/sysfs-class-net-phydev
index 206cbf538b59..989fc128ec94 100644
--- a/Documentation/ABI/testing/sysfs-class-net-phydev
+++ b/Documentation/ABI/testing/sysfs-class-net-phydev
@@ -49,3 +49,14 @@ Description:
 		Boolean value indicating whether the PHY device is used in
 		standalone mode, without a net_device associated, by PHYLINK.
 		Attribute created only when this is the case.
+
+What:		/sys/class/mdio_bus/<bus>/<device>/phy_rgmii_debug
+Date:		October 2019
+KernelVersion:	5.5
+Contact:	netdev@vger.kernel.org
+Description:
+		Write only attribute used to trigger the debugging of RGMII
+		connections. Upon writing, this will either return success
+		and print to kernel console the correct phy_interface value
+		or an error will be returned. See CONFIG_PHY_RGMII_DEBUG for
+		details.
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index fe602648b99f..e5b54627d426 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -248,6 +248,15 @@ config LED_TRIGGER_PHY
 		<Speed in megabits>Mbps OR <Speed in gigabits>Gbps OR link
 		for any speed known to the PHY.
 
+config PHY_RGMII_DEBUG
+	bool "Support debugging of RGMII connections"
+	---help---
+	   This enables support for troubleshooting RGMII connections by
+	   making use of the PHY devices standard loopback feature in order to
+	   probe the correct RGMII connection.
+
+	   If unsure, say N here.
+
 
 comment "MII PHY device drivers"
 
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index a03437e091f3..1d9fddf83f6c 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_MDIO_DEVICE)	+= mdio-bus.o
 endif
 libphy-$(CONFIG_SWPHY)		+= swphy.o
 libphy-$(CONFIG_LED_TRIGGER_PHY)	+= phy_led_triggers.o
+libphy-$(CONFIG_PHY_RGMII_DEBUG)	+= phy-rgmii-debug.o
 
 obj-$(CONFIG_PHYLINK)		+= phylink.o
 obj-$(CONFIG_PHYLIB)		+= libphy.o
diff --git a/drivers/net/phy/phy-rgmii-debug.c b/drivers/net/phy/phy-rgmii-debug.c
new file mode 100644
index 000000000000..1c98796d007d
--- /dev/null
+++ b/drivers/net/phy/phy-rgmii-debug.c
@@ -0,0 +1,284 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * PHY library RGMII debugging tool.
+ *
+ * Author: Florian Fainelli <f.fainelli@gmail.com>
+ */
+#include <linux/completion.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/phy.h>
+#include <linux/workqueue.h>
+#include <linux/etherdevice.h>
+#include <linux/crc32.h>
+
+#include <uapi/linux/if_ether.h>
+
+struct phy_rgmii_debug_priv {
+	struct work_struct work;
+	struct phy_device *phydev;
+	struct completion compl;
+	struct sk_buff *skb;
+	u32 fcs;
+	unsigned int rcv_ok;
+};
+
+static u32 phy_rgmii_probe_skb_fcs(struct sk_buff *skb)
+{
+	u32 fcs;
+
+	fcs = crc32_le(~0, skb->data, skb->len);
+	fcs = ~fcs;
+
+	return fcs;
+}
+
+static int phy_rgmii_debug_rcv(struct sk_buff *skb, struct net_device *dev,
+			       struct packet_type *pt, struct net_device *unused)
+{
+	struct phy_rgmii_debug_priv *priv = pt->af_packet_priv;
+	u32 fcs;
+
+	/* If we receive something, the Ethernet header was valid and so was
+	 * the Ethernet type, so to re-calculate the FCS we need to undo what
+	 * eth_type_trans() just did.
+	 */
+	if (!__skb_push(skb, ETH_HLEN))
+		return 0;
+
+	fcs = phy_rgmii_probe_skb_fcs(skb);
+	if (skb->len != priv->skb->len || fcs != priv->fcs) {
+		print_hex_dump(KERN_INFO, "RX probe skb: ",
+			       DUMP_PREFIX_OFFSET, 16, 1, skb->data, 32,
+			       false);
+		netdev_warn(dev, "FCS: 0x%08x expected: 0x%08x\n",
+			    fcs, priv->fcs);
+		netdev_warn(dev, "length: %d expected %d\n",
+			    skb->len, priv->skb->len);
+	} else {
+		priv->rcv_ok = 1;
+	}
+
+	complete(&priv->compl);
+
+	return 0;
+}
+
+static int phy_rgmii_trigger_config(struct phy_device *phydev,
+				    phy_interface_t interface)
+{
+	int ret = 0;
+
+	/* Configure the interface mode to be tested */
+	phydev->interface = interface;
+
+	/* Forcibly run the fixups and config_init() */
+	ret = phy_init_hw(phydev);
+	if (ret) {
+		phydev_err(phydev, "phy_init_hw failed: %d\n", ret);
+		return ret;
+	}
+
+	/* Some PHY drivers configure RGMII delays in their config_aneg()
+	 * callback, so make sure we run through those as well.
+	 */
+	ret = phy_start_aneg(phydev);
+	if (ret) {
+		phydev_err(phydev, "phy_start_aneg failed: %d\n", ret);
+		return ret;
+	}
+
+	/* Put back in loopback mode since phy_init_hw() may have issued
+	 * a software reset.
+	 */
+	ret = phy_loopback(phydev, true);
+	if (ret)
+		phydev_err(phydev, "phy_loopback failed: %d\n", ret);
+
+	return ret;
+}
+
+static void phy_rgmii_probe_xmit_work(struct work_struct *work)
+{
+	struct phy_rgmii_debug_priv *priv;
+
+	priv = container_of(work, struct phy_rgmii_debug_priv, work);
+
+	dev_queue_xmit(priv->skb);
+}
+
+static int phy_rgmii_prepare_probe(struct phy_rgmii_debug_priv *priv)
+{
+	struct phy_device *phydev = priv->phydev;
+	struct net_device *ndev = phydev->attached_dev;
+	struct sk_buff *skb;
+	int ret;
+
+	skb = netdev_alloc_skb(ndev, ndev->mtu);
+	if (!skb)
+		return -ENOMEM;
+
+	priv->skb = skb;
+	skb->dev = ndev;
+	skb_put(skb, ndev->mtu);
+	memset(skb->data, 0xaa, skb->len);
+
+	/* Build the header */
+	ret = eth_header(skb, ndev, ETH_P_EDSA, ndev->dev_addr,
+			 NULL, ndev->mtu);
+	if (ret != ETH_HLEN) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	priv->fcs = phy_rgmii_probe_skb_fcs(skb);
+
+	return 0;
+}
+
+static int phy_rgmii_probe_interface(struct phy_rgmii_debug_priv *priv,
+				     phy_interface_t iface)
+{
+	struct phy_device *phydev = priv->phydev;
+	struct net_device *ndev = phydev->attached_dev;
+	unsigned long timeout = 250;
+	int ret;
+
+	do {
+		ret = phy_read_status(phydev);
+		if (phydev->link)
+			break;
+
+		msleep(20);
+	} while (!ret && --timeout);
+
+	if (!timeout) {
+		netdev_err(ndev, "timeout waiting for link to be up\n");
+		return -ETIMEDOUT;
+	}
+
+	ret = phy_rgmii_trigger_config(phydev, iface);
+	if (ret) {
+		netdev_err(ndev, "%s rejected by driver(s)\n",
+			   phy_modes(iface));
+		return ret;
+	}
+
+	netdev_info(ndev, "Trying \"%s\" PHY interface\n", phy_modes(iface));
+
+	/* Prepare probe frames now */
+	ret = phy_rgmii_prepare_probe(priv);
+	if (ret)
+		return ret;
+
+	priv->rcv_ok = 0;
+	reinit_completion(&priv->compl);
+
+	cancel_work_sync(&priv->work);
+	schedule_work(&priv->work);
+
+	timeout = wait_for_completion_timeout(&priv->compl,
+					      msecs_to_jiffies(3000));
+	if (!timeout) {
+		netdev_err(ndev, "transmit timeout!\n");
+		ret = -ETIMEDOUT;
+		goto out;
+	}
+
+	ret = priv->rcv_ok == 1 ? 0 : -EINVAL;
+out:
+	phy_loopback(phydev, false);
+	dev_consume_skb_any(priv->skb);
+	return ret;
+}
+
+static struct packet_type phy_rgmii_probes_type __read_mostly = {
+	.type	= cpu_to_be16(ETH_P_EDSA),
+	.func	= phy_rgmii_debug_rcv,
+};
+
+static int phy_rgmii_can_debug(struct phy_device *phydev)
+{
+	struct net_device *ndev = phydev->attached_dev;
+
+	if (!ndev) {
+		netdev_err(ndev, "No network device attached\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (!phy_interface_is_rgmii(phydev)) {
+		netdev_info(ndev, "Not RGMII configured, nothing to do\n");
+		return 0;
+	}
+
+	if (!phydev->is_gigabit_capable) {
+		netdev_err(ndev, "not relevant in non-Gigabit mode\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (!phydev->drv) {
+		netdev_err(ndev, "no driver bound\n");
+		return -ENODEV;
+	}
+
+	if (phy_driver_is_genphy(phydev) || phy_driver_is_genphy_10g(phydev)) {
+		netdev_err(ndev, "only relevant with non-generic drivers\n");
+		return -EOPNOTSUPP;
+	}
+
+	return 1;
+}
+
+static phy_interface_t rgmii_modes[] = {
+	PHY_INTERFACE_MODE_RGMII,
+	PHY_INTERFACE_MODE_RGMII_ID,
+	PHY_INTERFACE_MODE_RGMII_RXID,
+	PHY_INTERFACE_MODE_RGMII_TXID
+};
+
+int phy_rgmii_debug_probe(struct phy_device *phydev)
+{
+	struct net_device *ndev = phydev->attached_dev;
+	struct phy_rgmii_debug_priv *priv;
+	unsigned char operstate;
+	unsigned int i;
+	int ret;
+
+	ret = phy_rgmii_can_debug(phydev);
+	if (ret <= 0)
+		return ret;
+
+	if (phy_rgmii_probes_type.af_packet_priv)
+		return -EBUSY;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phy_rgmii_probes_type.af_packet_priv = priv;
+	priv->phydev = phydev;
+	INIT_WORK(&priv->work, phy_rgmii_probe_xmit_work);
+	init_completion(&priv->compl);
+
+	/* We are now testing this network device */
+	operstate = ndev->operstate;
+	ndev->operstate = IF_OPER_TESTING;
+
+	dev_add_pack(&phy_rgmii_probes_type);
+
+	/* Now probe all modes */
+	for (i = 0; i < ARRAY_SIZE(rgmii_modes); i++) {
+		ret = phy_rgmii_probe_interface(priv, rgmii_modes[i]);
+		if (ret == 0)
+			netdev_info(ndev, "Determined \"%s\" to be correct\n",
+				    phy_modes(rgmii_modes[i]));
+	}
+
+	dev_remove_pack(&phy_rgmii_probes_type);
+	phy_rgmii_probes_type.af_packet_priv = NULL;
+	kfree(priv);
+	ndev->operstate = operstate;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_rgmii_debug_probe);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 7fa728c44632..b7a9b2266a0d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -537,10 +537,41 @@ phy_has_fixups_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(phy_has_fixups);
 
+static ssize_t
+phy_rgmii_debug_enable_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+	unsigned int val;
+	int ret = -EPERM;
+
+	if (!capable(CAP_NET_ADMIN))
+		goto out;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		goto out;
+
+	if (val != 1) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = phy_rgmii_debug_probe(phydev);
+	if (ret)
+		return ret;
+
+	ret = count;
+out:
+	return ret;
+}
+static DEVICE_ATTR_WO(phy_rgmii_debug_enable);
+
 static struct attribute *phy_dev_attrs[] = {
 	&dev_attr_phy_id.attr,
 	&dev_attr_phy_interface.attr,
 	&dev_attr_phy_has_fixups.attr,
+	&dev_attr_phy_rgmii_debug_enable.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(phy_dev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9a0e981df502..83a25430596e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1287,4 +1287,13 @@ module_exit(phy_module_exit)
 bool phy_driver_is_genphy(struct phy_device *phydev);
 bool phy_driver_is_genphy_10g(struct phy_device *phydev);
 
+#ifdef CONFIG_PHY_RGMII_DEBUG
+int phy_rgmii_debug_probe(struct phy_device *phydev);
+#else
+static inline int phy_rgmii_debug_probe(struct phy_device *phydev)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #endif /* __PHY_H */
-- 
2.17.1

