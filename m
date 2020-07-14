Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E6D21F748
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgGNQ0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgGNQ0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 12:26:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC7DC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 09:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UuTm19FmfZNNrD4nHgOSBl4fJ1FVhfHAqiXm1mKcyto=; b=jImQK73DBc/zqiep+dKx7bwuln
        OEOIp5uE7GF1UPGv7YvFuYhZDocCGVS6lYlhpbAREAdWOp2kIAZfx2CSpbOXmRYApHSBluxJRpVHE
        x211QwgY/OiJfjT52zZzEKEoq/WifDndP1ziISx6G3OQcf0IKHSRTNl6mM8fveNnpL0VvEOrSMl35
        WapNUcsE0vEtdRuKmkQ3/rhIzn92HzdQwxMO1PKICk3b/a+CUy0Nvaj/BbtU/vIofqAr2wofr3QkD
        hD6vdZH+swbXr2CZLfvX9H+w4P42qLJYPtdhMNLmls28tDnMz0PlfzhU8v3CmeQPPL2eaxJTsCOa3
        J0k0i94g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46164 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jvNlE-0005WJ-Dp; Tue, 14 Jul 2020 17:26:28 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jvNlE-0001Y0-47; Tue, 14 Jul 2020 17:26:28 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
Date:   Tue, 14 Jul 2020 17:26:28 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PTP basic support for Marvell 88E151x PHYs.  These PHYs support
timestamping the egress and ingress of packets, but does not support
any packet modification, nor do we support any filtering beyond
selecting packets that the hardware recognises as PTP/802.1AS.

The PHYs support hardware pins for providing an external clock for the
TAI counter, and a separate pin that can be used for event capture or
generation of a trigger (either a pulse or periodic).  This code does
not support either of these modes.

We currently use a delayed work to poll for the timestamps which is
far from ideal, but we also provide a function that can be called from
an interrupt handler - which would be good to tie into the main Marvell
PHY driver.

The driver takes inspiration from the Marvell 88E6xxx DSA and DP83640
drivers.  The hardware is very similar to the implementation found in
the 88E6xxx DSA driver, but the access methods are very different,
although it may be possible to create a library that both can use
along with accessor functions.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---

This does not wire up IRQ support yet - I don't think I have a system
I can test that with, but I need to check.

Tested with linuxptp; using phc2sys to synchronise the clock on the PHY
with system time, and that seems to work reasonably well - but every so
often (randomly) there seems to be a large delay in reading the time,
which results in a large shift in the frequency setting, and then it
takes a while to re-settle.  I'm not sure where that is coming from.

I also haven't checked for other Marvell PHYs supporting this; I know
the 88E1111 does not, and the 154x family also seem not to support it.
However, the 151x family for x=0,2,4,8 do.  The door is partly left
open in the code to support a common TAI with multiple ports, but that
would require further work - but as the 151x PHYs are only single port
PHYs, it seemed pointless to add support immediately.

The 151x family does have two pins that are related to the PTP/TAI
support:
- a pin which can be used for event capture, generating a pulse on
  TAI counter match, or generating a 50% duty cycle clock.  In the
  latter case, defining when the first edge occurs does not seem to
  be possible.
- a pin which can be supplied an external clock instead of using the
  internal 125MHz clock to increment the TAI counter.

Getting the Kconfig for this correct has been a struggle - particularly
the combination where PTP support is modular.  It's rather odd to have
the Marvell PTP support asked before the Marvell PHY support.  I
couldn't work out any other reasonable way to ensure that we always
have a valid configuration, without leading to stupidities such as
having the PTP and Marvell PTP support modular, but non-functional
because Marvell PHY is built-in.

With this driver, there appears to be three instances of a ptp_header()
like function in the kernel - I think that ought to become a helper in
generic code.

It seems that the Marvell PHY PTP is very similar to that found in
their DSA chips, which suggests maybe we should share the code, but
different access methods would be required.

There's a hack in here to implement the gettimex64() support, as
gettime64() is marked as deprecated - this is the best solution I could
come up with to support the new function while still using the
timecounter/cyclecounter support.

 drivers/net/phy/Kconfig       |  12 +
 drivers/net/phy/Makefile      |   2 +
 drivers/net/phy/marvell.c     |  28 +-
 drivers/net/phy/marvell_ptp.c | 691 ++++++++++++++++++++++++++++++++++
 drivers/net/phy/marvell_ptp.h |  20 +
 drivers/net/phy/marvell_tai.c | 279 ++++++++++++++
 drivers/net/phy/marvell_tai.h |  36 ++
 7 files changed, 1066 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/phy/marvell_ptp.c
 create mode 100644 drivers/net/phy/marvell_ptp.h
 create mode 100644 drivers/net/phy/marvell_tai.c
 create mode 100644 drivers/net/phy/marvell_tai.h

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index dd20c2c27c2f..e5bd5b779a0d 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -451,8 +451,20 @@ config LXT_PHY
 	help
 	  Currently supports the lxt970, lxt971
 
+config MARVELL_PHY_PTP
+	tristate "Marvell PHY PTP support"
+	depends on NETWORK_PHY_TIMESTAMPING && PTP_1588_CLOCK
+	help
+	  Support PHY timestamping on Marvell 88E1510, 88E1512, 88E1514
+	  and 88E1518 PHYs.
+
+	  N.B. In order for this to be fully functional, your MAC driver
+	  must call the skb_tx_timestamp() function.
+
 config MARVELL_PHY
 	tristate "Marvell PHYs"
+	# This can't be builtin if the PTP support is modular
+	depends on MARVELL_PHY_PTP=n || MARVELL_PHY_PTP
 	help
 	  Currently has a driver for the 88E1011S
 
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index d84bab489a53..00ba7be63246 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -87,6 +87,8 @@ obj-$(CONFIG_INTEL_XWAY_PHY)	+= intel-xway.o
 obj-$(CONFIG_LSI_ET1011C_PHY)	+= et1011c.o
 obj-$(CONFIG_LXT_PHY)		+= lxt.o
 obj-$(CONFIG_MARVELL_PHY)	+= marvell.o
+obj-$(CONFIG_MARVELL_PHY_PTP)	+= marvell-ptp.o
+marvell-ptp-y			:= marvell_ptp.o marvell_tai.o
 obj-$(CONFIG_MARVELL_10G_PHY)	+= marvell10g.o
 obj-$(CONFIG_MESON_GXL_PHY)	+= meson-gxl.o
 obj-$(CONFIG_MICREL_KS8995MA)	+= spi_ks8995.o
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index bb86ac0bd092..ef1ac619db3c 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -37,6 +37,8 @@
 #include <asm/irq.h>
 #include <linux/uaccess.h>
 
+#include "marvell_ptp.h"
+
 #define MII_MARVELL_PHY_PAGE		22
 #define MII_MARVELL_COPPER_PAGE		0x00
 #define MII_MARVELL_FIBER_PAGE		0x01
@@ -2589,6 +2591,27 @@ static int m88e1121_probe(struct phy_device *phydev)
 {
 	int err;
 
+	err = marvell_probe(phydev);
+	if (err)
+		return err;
+
+	err = marvell_ptp_probe(phydev);
+	if (err)
+		return err;
+
+	err = m88e1510_hwmon_probe(phydev);
+	if (err) {
+		marvell_ptp_remove(phydev);
+		return err;
+	}
+
+	return 0;
+}
+
+static int m88e154x_probe(struct phy_device *phydev)
+{
+	int err;
+
 	err = marvell_probe(phydev);
 	if (err)
 		return err;
@@ -2823,6 +2846,7 @@ static struct phy_driver marvell_drivers[] = {
 		.features = PHY_GBIT_FIBRE_FEATURES,
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = m88e1510_probe,
+		.remove = marvell_ptp_remove,
 		.config_init = m88e1510_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
@@ -2851,7 +2875,7 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1540",
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
-		.probe = m88e1510_probe,
+		.probe = m88e154x_probe,
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
@@ -2875,7 +2899,7 @@ static struct phy_driver marvell_drivers[] = {
 		.phy_id = MARVELL_PHY_ID_88E1545,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
 		.name = "Marvell 88E1545",
-		.probe = m88e1510_probe,
+		.probe = m88e154x_probe,
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
 		.config_init = marvell_config_init,
diff --git a/drivers/net/phy/marvell_ptp.c b/drivers/net/phy/marvell_ptp.c
new file mode 100644
index 000000000000..b61a9f975179
--- /dev/null
+++ b/drivers/net/phy/marvell_ptp.c
@@ -0,0 +1,691 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Marvell PTP driver for 88E1510, 88E1512, 88E1514 and 88E1518 PHYs
+ *
+ * Ideas taken from 88E6xxx DSA and DP83640 drivers. This file
+ * implements the packet timestamping support only (PTP).  TAI
+ * support is separate.
+ */
+#include <linux/if_vlan.h>
+#include <linux/list.h>
+#include <linux/netdevice.h>
+#include <linux/net_tstamp.h>
+#include <linux/phy.h>
+#include <linux/ptp_classify.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/uaccess.h>
+
+#include "marvell_ptp.h"
+#include "marvell_tai.h"
+
+#define TX_TIMEOUT_MS	40
+#define RX_TIMEOUT_MS	40
+
+#define MARVELL_PAGE_PTP_PORT_1			8
+#define PTP1_PORT_CONFIG_0			0
+#define PTP1_PORT_CONFIG_0_DISTSPECCHECK	BIT(11)
+#define PTP1_PORT_CONFIG_0_DISTSOVERWRITE	BIT(1)
+#define PTP1_PORT_CONFIG_0_DISPTP		BIT(0)
+#define PTP1_PORT_CONFIG_1			1
+#define PTP1_PORT_CONFIG_1_IPJUMP(x)		(((x) & 0x3f) << 8)
+#define PTP1_PORT_CONFIG_1_ETJUMP(x)		((x) & 0x1f)
+#define PTP1_PORT_CONFIG_2			2
+#define PTP1_PORT_CONFIG_2_DEPINTEN		BIT(1)
+#define PTP1_PORT_CONFIG_2_ARRINTEN		BIT(0)
+#define PTP1_ARR_STATUS0			8
+#define PTP1_ARR_STATUS1			12
+
+#define MARVELL_PAGE_PTP_PORT_2			9
+#define PTP2_DEP_STATUS				0
+
+struct marvell_ptp_cb {
+	unsigned long timeout;
+	u16 seq;
+};
+#define MARVELL_PTP_CB(skb)	((struct marvell_ptp_cb *)(skb)->cb)
+
+struct marvell_rxts {
+	struct list_head node;
+	u64 ns;
+	u16 seq;
+};
+
+struct marvell_ptp {
+	struct marvell_tai *tai;
+	struct list_head tai_node;
+	struct phy_device *phydev;
+	struct mii_timestamper mii_ts;
+
+	/* We only support one outstanding transmit skb */
+	struct sk_buff *tx_skb;
+	enum hwtstamp_tx_types tx_type;
+
+	struct mutex rx_mutex;
+	struct list_head rx_free;
+	struct list_head rx_pend;
+	struct sk_buff_head rx_queue;
+	enum hwtstamp_rx_filters rx_filter;
+	struct marvell_rxts rx_ts[64];
+
+	struct delayed_work ts_work;
+};
+
+struct marvell_ts {
+	u32 time;
+	u16 stat;
+#define MV_STATUS_INTSTATUS_MASK		0x0006
+#define MV_STATUS_INTSTATUS_NORMAL		0x0000
+#define MV_STATUS_VALID				BIT(0)
+	u16 seq;
+};
+
+/* Read the status, timestamp and PTP common header sequence from the PHY.
+ * Apparently, reading these are atomic, but there is no mention how the
+ * PHY treats this access as atomic. So, we set the DisTSOverwrite bit
+ * when configuring the PHY.
+ */
+static int marvell_read_tstamp(struct phy_device *phydev,
+			       struct marvell_ts *ts,
+			       uint8_t page, uint8_t reg)
+{
+	int oldpage;
+	int ret;
+
+	/* Read status register */
+	oldpage = phy_select_page(phydev, page);
+	if (oldpage >= 0) {
+		ret = __phy_read(phydev, reg);
+		if (ret < 0)
+			goto restore;
+
+		ts->stat = ret;
+		if (!(ts->stat & MV_STATUS_VALID)) {
+			ret = 0;
+			goto restore;
+		}
+
+		/* Read low timestamp */
+		ret = __phy_read(phydev, reg + 1);
+		if (ret < 0)
+			goto restore;
+
+		ts->time = ret;
+
+		/* Read high timestamp */
+		ret = __phy_read(phydev, reg + 2);
+		if (ret < 0)
+			goto restore;
+
+		ts->time |= ret << 16;
+
+		/* Read sequence */
+		ret = __phy_read(phydev, reg + 3);
+		if (ret < 0)
+			goto restore;
+
+		ts->seq = ret;
+
+		/* Clear valid */
+		__phy_write(phydev, reg, 0);
+	}
+restore:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
+/* Shouldn't the ptp/networking provide this? */
+static u8 *ptp_header(struct sk_buff *skb, int type)
+{
+	u8 *data = skb_mac_header(skb);
+	u8 *ptr = data;
+
+	if (type & PTP_CLASS_VLAN)
+		ptr += VLAN_HLEN;
+
+	switch (type & PTP_CLASS_PMASK) {
+	case PTP_CLASS_IPV4:
+		ptr += IPV4_HLEN(ptr) + UDP_HLEN;
+		break;
+
+	case PTP_CLASS_IPV6:
+		ptr += IP6_HLEN + UDP_HLEN;
+		break;
+
+	case PTP_CLASS_L2:
+		break;
+
+	default:
+		return NULL;
+	}
+
+	if (skb->len < ptr - data + 34)
+		return NULL;
+
+	return ptr + ETH_HLEN;
+}
+
+/* Extract the sequence ID */
+static u16 ptp_seqid(u8 *ptp_hdr)
+{
+	__be16 *seqp = (__be16 *)(ptp_hdr + OFF_PTP_SEQUENCE_ID);
+
+	return be16_to_cpup(seqp);
+}
+
+static struct marvell_ptp *mii_ts_to_ptp(struct mii_timestamper *mii_ts)
+{
+	return container_of(mii_ts, struct marvell_ptp, mii_ts);
+}
+
+/* Deliver a skb with its timestamp back to the networking core */
+static void marvell_ptp_rx(struct sk_buff *skb, u64 ns)
+{
+	struct skb_shared_hwtstamps *shhwtstamps = skb_hwtstamps(skb);
+
+	memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+	shhwtstamps->hwtstamp = ns_to_ktime(ns);
+	netif_rx_ni(skb);
+}
+
+/* Get a rx timestamp entry. Try the free list, and if that fails,
+ * steal the oldest off the pending list.
+ */
+static struct marvell_rxts *marvell_ptp_get_rxts(struct marvell_ptp *ptp)
+{
+	if (!list_empty(&ptp->rx_free))
+		return list_first_entry(&ptp->rx_free, struct marvell_rxts,
+					node);
+
+	return list_last_entry(&ptp->rx_pend, struct marvell_rxts, node);
+}
+
+/* Check for a rx timestamp entry, try to find the corresponding skb and
+ * deliver it, otherwise add the rx timestamp to the queue of pending
+ * timestamps.
+ */
+static int marvell_ptp_rx_ts(struct marvell_ptp *ptp)
+{
+	struct marvell_rxts *rxts;
+	struct marvell_ts ts;
+	struct sk_buff *skb;
+	bool found = false;
+	u64 ns;
+	int err;
+
+	err = marvell_read_tstamp(ptp->phydev, &ts, MARVELL_PAGE_PTP_PORT_1,
+				  PTP1_ARR_STATUS0);
+	if (err <= 0)
+		return 0;
+
+	if ((ts.stat & MV_STATUS_INTSTATUS_MASK) !=
+	    MV_STATUS_INTSTATUS_NORMAL) {
+		dev_warn(&ptp->phydev->mdio.dev,
+			 "rx timestamp overrun (%x)\n", ts.stat);
+		return -1;
+	}
+
+	ns = marvell_tai_cyc2time(ptp->tai, ts.time);
+
+	mutex_lock(&ptp->rx_mutex);
+
+	/* Search the rx queue for a matching skb */
+	skb_queue_walk(&ptp->rx_queue, skb) {
+		if (MARVELL_PTP_CB(skb)->seq == ts.seq) {
+			__skb_unlink(skb, &ptp->rx_queue);
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		rxts = marvell_ptp_get_rxts(ptp);
+		rxts->ns = ns;
+		rxts->seq = ts.seq;
+		list_move(&rxts->node, &ptp->rx_pend);
+	}
+
+	mutex_unlock(&ptp->rx_mutex);
+
+	if (found)
+		marvell_ptp_rx(skb, ns);
+
+	return 1;
+}
+
+/* Check whether the packet is suitable for timestamping, and if so,
+ * try to find a pending timestamp for it. If no timestamp is found,
+ * queue the packet with a timeout.
+ */
+static bool marvell_ptp_rxtstamp(struct mii_timestamper *mii_ts,
+				 struct sk_buff *skb, int type)
+{
+	struct marvell_ptp *ptp = mii_ts_to_ptp(mii_ts);
+	struct marvell_rxts *rxts;
+	bool found = false;
+	u8 *ptp_hdr;
+	u16 seqid;
+	u64 ns;
+
+	if (ptp->rx_filter == HWTSTAMP_FILTER_NONE)
+		return false;
+
+	ptp_hdr = ptp_header(skb, type);
+	if (!ptp_hdr)
+		return false;
+
+	seqid = ptp_seqid(ptp_hdr);
+
+	mutex_lock(&ptp->rx_mutex);
+
+	/* Search the pending receive timestamps for a matching seqid */
+	list_for_each_entry(rxts, &ptp->rx_pend, node) {
+		if (rxts->seq == seqid) {
+			found = true;
+			ns = rxts->ns;
+			/* Move this timestamp entry to the free list */
+			list_move_tail(&rxts->node, &ptp->rx_free);
+			break;
+		}
+	}
+
+	if (!found) {
+		/* Store the seqid and queue the skb. Do this under the lock
+		 * to ensure we don't miss any timestamps appended to the
+		 * rx_pend list.
+		 */
+		MARVELL_PTP_CB(skb)->seq = seqid;
+		MARVELL_PTP_CB(skb)->timeout = jiffies +
+			msecs_to_jiffies(RX_TIMEOUT_MS);
+		__skb_queue_tail(&ptp->rx_queue, skb);
+	}
+
+	mutex_unlock(&ptp->rx_mutex);
+
+	if (found) {
+		/* We found the corresponding timestamp. If we can add the
+		 * timestamp, do we need to go through the netif_rx_ni()
+		 * path, or would it be more efficient to add the timestamp
+		 * and return "false" here?
+		 */
+		marvell_ptp_rx(skb, ns);
+	} else {
+		schedule_delayed_work(&ptp->ts_work, 2);
+	}
+
+	return true;
+}
+
+/* Move any expired skbs on to our own list, and then hand the contents of
+ * our list to netif_rx_ni() - this avoids calling netif_rx_ni() with our
+ * mutex held.
+ */
+static void marvell_ptp_rx_expire(struct marvell_ptp *ptp)
+{
+	struct sk_buff_head list;
+	struct sk_buff *skb;
+
+	__skb_queue_head_init(&list);
+
+	mutex_lock(&ptp->rx_mutex);
+	while ((skb = skb_dequeue(&ptp->rx_queue)) != NULL) {
+		if (!time_is_before_jiffies(MARVELL_PTP_CB(skb)->timeout)) {
+			__skb_queue_head(&ptp->rx_queue, skb);
+			break;
+		}
+		__skb_queue_tail(&list, skb);
+	}
+	mutex_unlock(&ptp->rx_mutex);
+
+	while ((skb = __skb_dequeue(&list)) != NULL)
+		netif_rx_ni(skb);
+}
+
+/* Complete the transmit timestamping; this is called to read the transmit
+ * timestamp from the PHY, and report back the transmitted timestamp.
+ */
+static int marvell_ptp_txtstamp_complete(struct marvell_ptp *ptp)
+{
+	struct skb_shared_hwtstamps shhwtstamps;
+	struct sk_buff *skb = ptp->tx_skb;
+	struct marvell_ts ts;
+	int err;
+	u64 ns;
+
+	err = marvell_read_tstamp(ptp->phydev, &ts, MARVELL_PAGE_PTP_PORT_2,
+				  PTP2_DEP_STATUS);
+	if (err < 0)
+		goto fail;
+
+	if (err == 0) {
+		if (time_is_before_jiffies(MARVELL_PTP_CB(skb)->timeout)) {
+			dev_warn(&ptp->phydev->mdio.dev,
+				 "tx timestamp timeout\n");
+			goto free;
+		}
+		return 0;
+	}
+
+	/* Check the status */
+	if ((ts.stat & MV_STATUS_INTSTATUS_MASK) !=
+	    MV_STATUS_INTSTATUS_NORMAL) {
+		dev_warn(&ptp->phydev->mdio.dev,
+			 "tx timestamp overrun (%x)\n", ts.stat);
+		goto free;
+	}
+
+	/* Reject if the sequence number doesn't match */
+	if (ts.seq != MARVELL_PTP_CB(skb)->seq) {
+		dev_warn(&ptp->phydev->mdio.dev,
+			 "tx timestamp unexpected sequence id\n");
+		goto free;
+	}
+
+	ptp->tx_skb = NULL;
+
+	/* Set the timestamp */
+	ns = marvell_tai_cyc2time(ptp->tai, ts.time);
+	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+	shhwtstamps.hwtstamp = ns_to_ktime(ns);
+	skb_complete_tx_timestamp(skb, &shhwtstamps);
+	return 1;
+
+fail:
+	dev_err_ratelimited(&ptp->phydev->mdio.dev,
+			    "failed reading PTP: %pe\n", ERR_PTR(err));
+free:
+	dev_kfree_skb_any(skb);
+	ptp->tx_skb = NULL;
+	return -1;
+}
+
+/* Check whether the skb will be timestamped on transmit; we only support
+ * a single outstanding skb. Add it if the slot is available.
+ */
+static bool marvell_ptp_do_txtstamp(struct mii_timestamper *mii_ts,
+				    struct sk_buff *skb, int type)
+{
+	struct marvell_ptp *ptp = mii_ts_to_ptp(mii_ts);
+	u8 *ptp_hdr;
+
+	if (ptp->tx_type != HWTSTAMP_TX_ON)
+		return false;
+
+	if (!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
+		return false;
+
+	ptp_hdr = ptp_header(skb, type);
+	if (!ptp_hdr)
+		return false;
+
+	MARVELL_PTP_CB(skb)->seq = ptp_seqid(ptp_hdr);
+	MARVELL_PTP_CB(skb)->timeout = jiffies +
+		msecs_to_jiffies(TX_TIMEOUT_MS);
+
+	if (cmpxchg(&ptp->tx_skb, NULL, skb) != NULL)
+		return false;
+
+	/* DP83640 marks the skb for hw timestamping. Since the MAC driver
+	 * may call skb_tx_timestamp() but may not support timestamping
+	 * itself, it may not set this flag. So, we need to do this here.
+	 */
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+	schedule_delayed_work(&ptp->ts_work, 2);
+
+	return true;
+}
+
+static void marvell_ptp_txtstamp(struct mii_timestamper *mii_ts,
+				 struct sk_buff *skb, int type)
+{
+	if (!marvell_ptp_do_txtstamp(mii_ts, skb, type))
+		kfree_skb(skb);
+}
+
+static int marvell_ptp_hwtstamp(struct mii_timestamper *mii_ts,
+				struct ifreq *ifreq)
+{
+	struct marvell_ptp *ptp = mii_ts_to_ptp(mii_ts);
+	struct hwtstamp_config config;
+	u16 cfg0 = PTP1_PORT_CONFIG_0_DISPTP;
+	u16 cfg2 = 0;
+	int err;
+
+	if (copy_from_user(&config, ifreq->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	if (config.flags)
+		return -EINVAL;
+
+	switch (config.tx_type) {
+	case HWTSTAMP_TX_OFF:
+		break;
+
+	case HWTSTAMP_TX_ON:
+		cfg0 = 0;
+		cfg2 |= PTP1_PORT_CONFIG_2_DEPINTEN;
+		break;
+
+	default:
+		return -ERANGE;
+	}
+
+	switch (config.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		break;
+
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		/* We accept 802.1AS, IEEE 1588v1 and IEEE 1588v2. We could
+		 * filter on 802.1AS using the transportSpecific field, but
+		 * that affects the transmit path too.
+		 */
+		config.rx_filter = HWTSTAMP_FILTER_SOME;
+		cfg0 = 0;
+		cfg2 |= PTP1_PORT_CONFIG_2_ARRINTEN;
+		break;
+
+	default:
+		return -ERANGE;
+	}
+
+	err = phy_modify_paged(ptp->phydev, MARVELL_PAGE_PTP_PORT_1,
+			       PTP1_PORT_CONFIG_0,
+			       PTP1_PORT_CONFIG_0_DISPTP, cfg0);
+	if (err)
+		return err;
+
+	err = phy_write_paged(ptp->phydev, MARVELL_PAGE_PTP_PORT_1,
+			      PTP1_PORT_CONFIG_2, cfg2);
+	if (err)
+		return err;
+
+	ptp->tx_type = config.tx_type;
+	ptp->rx_filter = config.rx_filter;
+
+	return copy_to_user(ifreq->ifr_data, &config, sizeof(config)) ?
+		-EFAULT : 0;
+}
+
+static int marvell_ptp_ts_info(struct mii_timestamper *mii_ts,
+			       struct ethtool_ts_info *ts_info)
+{
+	struct marvell_ptp *ptp = mii_ts_to_ptp(mii_ts);
+
+	ts_info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+				   SOF_TIMESTAMPING_RX_HARDWARE |
+				   SOF_TIMESTAMPING_RAW_HARDWARE;
+	ts_info->phc_index = ptp_clock_index(ptp->tai->ptp_clock);
+	ts_info->tx_types = BIT(HWTSTAMP_TX_OFF) |
+			    BIT(HWTSTAMP_TX_ON);
+	ts_info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			      BIT(HWTSTAMP_FILTER_SOME);
+
+	return 0;
+}
+
+static int marvell_ptp_port_config(struct phy_device *phydev)
+{
+	int err;
+
+	/* Disable transport specific check (if the PTP common header)
+	 * Disable timestamp overwriting (so we can read a stable entry.)
+	 * Disable PTP
+	 */
+	err = phy_write_paged(phydev, MARVELL_PAGE_PTP_PORT_1,
+			      PTP1_PORT_CONFIG_0,
+			      PTP1_PORT_CONFIG_0_DISTSPECCHECK |
+			      PTP1_PORT_CONFIG_0_DISTSOVERWRITE |
+			      PTP1_PORT_CONFIG_0_DISPTP);
+	if (err < 0)
+		return err;
+
+	/* Set ether-type jump to 12 (to ether protocol)
+	 * Set IP jump to 2 (to skip over ether protocol)
+	 * Does this mean it won't pick up on VLAN packets?
+	 */
+	err = phy_write_paged(phydev, MARVELL_PAGE_PTP_PORT_1,
+			      PTP1_PORT_CONFIG_1,
+			      PTP1_PORT_CONFIG_1_ETJUMP(12) |
+			      PTP1_PORT_CONFIG_1_IPJUMP(2));
+	if (err < 0)
+		return err;
+
+	/* Disable all interrupts */
+	phy_write_paged(phydev, MARVELL_PAGE_PTP_PORT_1,
+			PTP1_PORT_CONFIG_2, 0);
+
+	return 0;
+}
+
+static void marvell_ptp_port_disable(struct phy_device *phydev)
+{
+	/* Disable PTP */
+	phy_write_paged(phydev, MARVELL_PAGE_PTP_PORT_1,
+			PTP1_PORT_CONFIG_0, PTP1_PORT_CONFIG_0_DISPTP);
+
+	/* Disable interrupts */
+	phy_write_paged(phydev, MARVELL_PAGE_PTP_PORT_1,
+			PTP1_PORT_CONFIG_2, 0);
+}
+
+/* This function should be called from the PHY threaded interrupt
+ * handler to process any stored timestamps in a timely manner.
+ * The presence of an interrupt has an effect on how quickly a
+ * timestamp requiring received packet will be processed.
+ */
+irqreturn_t marvell_ptp_irq(struct phy_device *phydev)
+{
+	struct marvell_ptp *ptp;
+	irqreturn_t ret = IRQ_NONE;
+
+	if (!phydev->mii_ts)
+		return ret;
+
+	ptp = mii_ts_to_ptp(phydev->mii_ts);
+	if (marvell_ptp_rx_ts(ptp))
+		ret = IRQ_HANDLED;
+
+	if (ptp->tx_skb && marvell_ptp_txtstamp_complete(ptp))
+		ret = IRQ_HANDLED;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marvell_ptp_irq);
+
+static void marvell_ptp_worker(struct work_struct *work)
+{
+	struct marvell_ptp *ptp = container_of(work, struct marvell_ptp,
+					       ts_work.work);
+
+	marvell_ptp_rx_ts(ptp);
+
+	if (ptp->tx_skb)
+		marvell_ptp_txtstamp_complete(ptp);
+
+	marvell_ptp_rx_expire(ptp);
+
+	if (!skb_queue_empty(&ptp->rx_queue) || ptp->tx_skb)
+		schedule_delayed_work(&ptp->ts_work, 2);
+}
+
+int marvell_ptp_probe(struct phy_device *phydev)
+{
+	struct marvell_ptp *ptp;
+	int err, i;
+
+	ptp = devm_kzalloc(&phydev->mdio.dev, sizeof(*ptp), GFP_KERNEL);
+	if (!ptp)
+		return -ENOMEM;
+
+	ptp->phydev = phydev;
+	ptp->mii_ts.rxtstamp = marvell_ptp_rxtstamp;
+	ptp->mii_ts.txtstamp = marvell_ptp_txtstamp;
+	ptp->mii_ts.hwtstamp = marvell_ptp_hwtstamp;
+	ptp->mii_ts.ts_info = marvell_ptp_ts_info;
+
+	INIT_DELAYED_WORK(&ptp->ts_work, marvell_ptp_worker);
+	mutex_init(&ptp->rx_mutex);
+	INIT_LIST_HEAD(&ptp->rx_free);
+	INIT_LIST_HEAD(&ptp->rx_pend);
+	skb_queue_head_init(&ptp->rx_queue);
+
+	for (i = 0; i < ARRAY_SIZE(ptp->rx_ts); i++)
+		list_add_tail(&ptp->rx_ts[i].node, &ptp->rx_free);
+
+	/* Get the TAI for this PHY. */
+	err = marvell_tai_get(&ptp->tai, phydev);
+	if (err)
+		return err;
+
+	/* Configure this PTP port */
+	err = marvell_ptp_port_config(phydev);
+	if (err) {
+		marvell_tai_put(ptp->tai);
+		return err;
+	}
+
+	phydev->mii_ts = &ptp->mii_ts;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(marvell_ptp_probe);
+
+void marvell_ptp_remove(struct phy_device *phydev)
+{
+	struct marvell_ptp *ptp;
+
+	if (!phydev->mii_ts)
+		return;
+
+	/* Disconnect from the net subsystem - we assume there is no
+	 * packet activity at this point.
+	 */
+	ptp = mii_ts_to_ptp(phydev->mii_ts);
+	phydev->mii_ts = NULL;
+
+	cancel_delayed_work_sync(&ptp->ts_work);
+
+	/* Free or dequeue all pending skbs */
+	if (ptp->tx_skb)
+		kfree_skb(ptp->tx_skb);
+
+	skb_queue_purge(&ptp->rx_queue);
+
+	/* Ensure that the port is disabled */
+	marvell_ptp_port_disable(phydev);
+	marvell_tai_put(ptp->tai);
+}
+EXPORT_SYMBOL_GPL(marvell_ptp_remove);
+
+MODULE_AUTHOR("Russell King");
+MODULE_DESCRIPTION("Marvell PHY PTP library");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/phy/marvell_ptp.h b/drivers/net/phy/marvell_ptp.h
new file mode 100644
index 000000000000..1ae65bb5c298
--- /dev/null
+++ b/drivers/net/phy/marvell_ptp.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef MARVELL_PTP_H
+#define MARVELL_PTP_H
+
+#if IS_ENABLED(CONFIG_MARVELL_PHY_PTP)
+void marvell_ptp_check(struct phy_device *phydev);
+int marvell_ptp_probe(struct phy_device *phydev);
+void marvell_ptp_remove(struct phy_device *phydev);
+#else
+static inline int marvell_ptp_probe(struct phy_device *phydev)
+{
+	return 0;
+}
+
+static inline void marvell_ptp_remove(struct phy_device *phydev)
+{
+}
+#endif
+
+#endif
diff --git a/drivers/net/phy/marvell_tai.c b/drivers/net/phy/marvell_tai.c
new file mode 100644
index 000000000000..f6608a0986ca
--- /dev/null
+++ b/drivers/net/phy/marvell_tai.c
@@ -0,0 +1,279 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Marvell PTP driver for 88E1510, 88E1512, 88E1514 and 88E1518 PHYs
+ *
+ * This file implements TAI support as a PTP clock. Timecounter/cyclecounter
+ * representation taken from Marvell 88E6xxx DSA driver. We may need to share
+ * the TAI between multiple PHYs in a multiport PHY.
+ */
+#include <linux/ktime.h>
+#include <linux/slab.h>
+#include <linux/phy.h>
+#include "marvell_tai.h"
+
+#define MARVELL_PAGE_MISC			6
+#define GCR					20
+#define GCR_PTP_POWER_DOWN			BIT(9)
+#define GCR_PTP_REF_CLOCK_SOURCE		BIT(8)
+#define GCR_PTP_INPUT_SOURCE			BIT(7)
+#define GCR_PTP_OUTPUT				BIT(6)
+
+#define MARVELL_PAGE_TAI_GLOBAL			12
+#define TAI_CONFIG_0				0
+#define TAI_CONFIG_0_EVENTCAPOV			BIT(15)
+#define TAI_CONFIG_0_TRIGGENINTEN		BIT(9)
+#define TAI_CONFIG_0_EVENTCAPINTEN		BIT(8)
+
+#define TAI_CONFIG_9				9
+#define TAI_CONFIG_9_EVENTERR			BIT(9)
+#define TAI_CONFIG_9_EVENTCAPVALID		BIT(8)
+
+#define TAI_EVENT_CAPTURE_TIME_LO		10
+#define TAI_EVENT_CAPTURE_TIME_HI		11
+
+#define MARVELL_PAGE_PTP_GLOBAL			14
+#define PTPG_CONFIG_0				0
+#define PTPG_CONFIG_1				1
+#define PTPG_CONFIG_2				2
+#define PTPG_CONFIG_3				3
+#define PTPG_CONFIG_3_TSATSFD			BIT(0)
+#define PTPG_STATUS				8
+#define PTPG_READPLUS_COMMAND			14
+#define PTPG_READPLUS_DATA			15
+
+static DEFINE_SPINLOCK(tai_list_lock);
+static LIST_HEAD(tai_list);
+
+static struct marvell_tai *cc_to_tai(const struct cyclecounter *cc)
+{
+	return container_of(cc, struct marvell_tai, cyclecounter);
+}
+
+/* Read the global time registers using the readplus command */
+static u64 marvell_tai_clock_read(const struct cyclecounter *cc)
+{
+	struct marvell_tai *tai = cc_to_tai(cc);
+	struct phy_device *phydev = tai->phydev;
+	int err, oldpage, lo, hi;
+
+	oldpage = phy_select_page(phydev, MARVELL_PAGE_PTP_GLOBAL);
+	if (oldpage >= 0) {
+		/* 88e151x says to write 0x8e0e */
+		ptp_read_system_prets(tai->sts);
+		err = __phy_write(phydev, PTPG_READPLUS_COMMAND, 0x8e0e);
+		ptp_read_system_postts(tai->sts);
+		lo = __phy_read(phydev, PTPG_READPLUS_DATA);
+		hi = __phy_read(phydev, PTPG_READPLUS_DATA);
+	}
+	err = phy_restore_page(phydev, oldpage, err);
+
+	if (err || lo < 0 || hi < 0)
+		return 0;
+
+	return lo | hi << 16;
+}
+
+u64 marvell_tai_cyc2time(struct marvell_tai *tai, u32 cyc)
+{
+	u64 ns;
+
+	mutex_lock(&tai->mutex);
+	ns = timecounter_cyc2time(&tai->timecounter, cyc);
+	mutex_unlock(&tai->mutex);
+
+	return ns;
+}
+
+static struct marvell_tai *ptp_to_tai(struct ptp_clock_info *ptp)
+{
+	return container_of(ptp, struct marvell_tai, caps);
+}
+
+static int marvell_tai_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct marvell_tai *tai = ptp_to_tai(ptp);
+	bool neg;
+	u32 diff;
+	u64 adj;
+
+	neg = scaled_ppm < 0;
+	if (neg)
+		scaled_ppm = -scaled_ppm;
+
+	adj = tai->cc_mult_num;
+	adj *= scaled_ppm;
+	diff = div_u64(adj, tai->cc_mult_den);
+
+	mutex_lock(&tai->mutex);
+	timecounter_read(&tai->timecounter);
+	tai->cyclecounter.mult = neg ? tai->cc_mult - diff :
+				       tai->cc_mult + diff;
+	mutex_unlock(&tai->mutex);
+
+	return 0;
+}
+
+static int marvell_tai_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct marvell_tai *tai = ptp_to_tai(ptp);
+
+	mutex_lock(&tai->mutex);
+	timecounter_adjtime(&tai->timecounter, delta);
+	mutex_unlock(&tai->mutex);
+
+	return 0;
+}
+
+static int marvell_tai_gettimex64(struct ptp_clock_info *ptp,
+				  struct timespec64 *ts,
+				  struct ptp_system_timestamp *sts)
+{
+	struct marvell_tai *tai = ptp_to_tai(ptp);
+	u64 ns;
+
+	mutex_lock(&tai->mutex);
+	tai->sts = sts;
+	ns = timecounter_read(&tai->timecounter);
+	tai->sts = NULL;
+	mutex_unlock(&tai->mutex);
+
+	*ts = ns_to_timespec64(ns);
+
+	return 0;
+}
+
+static int marvell_tai_settime64(struct ptp_clock_info *ptp,
+				 const struct timespec64 *ts)
+{
+	struct marvell_tai *tai = ptp_to_tai(ptp);
+	u64 ns = timespec64_to_ns(ts);
+
+	mutex_lock(&tai->mutex);
+	timecounter_init(&tai->timecounter, &tai->cyclecounter, ns);
+	mutex_unlock(&tai->mutex);
+
+	return 0;
+}
+
+/* Periodically read the timecounter to keep the time refreshed. */
+static long marvell_tai_aux_work(struct ptp_clock_info *ptp)
+{
+	struct marvell_tai *tai = ptp_to_tai(ptp);
+
+	mutex_lock(&tai->mutex);
+	timecounter_read(&tai->timecounter);
+	mutex_unlock(&tai->mutex);
+
+	return tai->half_overflow_period;
+}
+
+/* Configure the global (shared between ports) configuration for the PHY. */
+static int marvell_tai_global_config(struct phy_device *phydev)
+{
+	int err;
+
+	/* Power up PTP */
+	err = phy_modify_paged(phydev, MARVELL_PAGE_MISC, GCR,
+			       GCR_PTP_POWER_DOWN, 0);
+	if (err)
+		return err;
+
+	/* Set ether-type for IEEE1588 packets */
+	err = phy_write_paged(phydev, MARVELL_PAGE_PTP_GLOBAL,
+			      PTPG_CONFIG_0, ETH_P_1588);
+	if (err < 0)
+		return err;
+
+	/* MsdIDTSEn - Enable timestamping on all PTP MessageIDs */
+	err = phy_write_paged(phydev, MARVELL_PAGE_PTP_GLOBAL,
+			      PTPG_CONFIG_1, ~0);
+	if (err < 0)
+		return err;
+
+	/* TSArrPtr - Point to Arr0 registers */
+	err = phy_write_paged(phydev, MARVELL_PAGE_PTP_GLOBAL,
+			      PTPG_CONFIG_2, 0);
+	if (err < 0)
+		return err;
+
+	/* TSAtSFD - timestamp at SFD */
+	err = phy_write_paged(phydev, MARVELL_PAGE_PTP_GLOBAL,
+			      PTPG_CONFIG_3, PTPG_CONFIG_3_TSATSFD);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+int marvell_tai_get(struct marvell_tai **taip, struct phy_device *phydev)
+{
+	struct marvell_tai *tai;
+	unsigned long overflow_ms;
+	int err;
+
+	err = marvell_tai_global_config(phydev);
+	if (err < 0)
+		return err;
+
+	tai = kzalloc(sizeof(*tai), GFP_KERNEL);
+	if (!tai)
+		return -ENOMEM;
+
+	mutex_init(&tai->mutex);
+
+	tai->phydev = phydev;
+
+	/* This assumes a 125MHz clock */
+	tai->cc_mult = 8 << 28;
+	tai->cc_mult_num = 1 << 9;
+	tai->cc_mult_den = 15625U;
+
+	tai->cyclecounter.read = marvell_tai_clock_read;
+	tai->cyclecounter.mask = CYCLECOUNTER_MASK(32);
+	tai->cyclecounter.mult = tai->cc_mult;
+	tai->cyclecounter.shift = 28;
+
+	overflow_ms = (1ULL << 32 * tai->cc_mult * 1000) >>
+			tai->cyclecounter.shift;
+	tai->half_overflow_period = msecs_to_jiffies(overflow_ms / 2);
+
+	timecounter_init(&tai->timecounter, &tai->cyclecounter,
+			 ktime_to_ns(ktime_get_real()));
+
+	tai->caps.owner = THIS_MODULE;
+	snprintf(tai->caps.name, sizeof(tai->caps.name), "Marvell PHY");
+	/* max_adj of 1000000 is what MV88E6xxx DSA uses */
+	tai->caps.max_adj = 1000000;
+	tai->caps.adjfine = marvell_tai_adjfine;
+	tai->caps.adjtime = marvell_tai_adjtime;
+	tai->caps.gettimex64 = marvell_tai_gettimex64;
+	tai->caps.settime64 = marvell_tai_settime64;
+	tai->caps.do_aux_work = marvell_tai_aux_work;
+
+	tai->ptp_clock = ptp_clock_register(&tai->caps, &phydev->mdio.dev);
+	if (IS_ERR(tai->ptp_clock)) {
+		kfree(tai);
+		return PTR_ERR(tai->ptp_clock);
+	}
+
+	ptp_schedule_worker(tai->ptp_clock, tai->half_overflow_period);
+
+	spin_lock(&tai_list_lock);
+	list_add_tail(&tai->tai_node, &tai_list);
+	spin_unlock(&tai_list_lock);
+
+	*taip = tai;
+
+	return 0;
+}
+
+void marvell_tai_put(struct marvell_tai *tai)
+{
+	ptp_clock_unregister(tai->ptp_clock);
+
+	spin_lock(&tai_list_lock);
+	list_del(&tai->tai_node);
+	spin_unlock(&tai_list_lock);
+
+	kfree(tai);
+}
diff --git a/drivers/net/phy/marvell_tai.h b/drivers/net/phy/marvell_tai.h
new file mode 100644
index 000000000000..9752f6cd58da
--- /dev/null
+++ b/drivers/net/phy/marvell_tai.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef MARVELL_TAI_H
+#define MARVELL_TAI_H
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/timecounter.h>
+
+struct phy_device;
+
+struct marvell_tai {
+	struct list_head tai_node;
+	struct phy_device *phydev;
+
+	struct ptp_clock_info caps;
+	struct ptp_clock *ptp_clock;
+
+	u32 cc_mult_num;
+	u32 cc_mult_den;
+	u32 cc_mult;
+
+	struct mutex mutex;
+	struct timecounter timecounter;
+	struct cyclecounter cyclecounter;
+	long half_overflow_period;
+
+	/* Used while reading the TAI */
+	struct ptp_system_timestamp *sts;
+};
+
+u64 marvell_tai_cyc2time(struct marvell_tai *tai, u32 cyc);
+int marvell_tai_get(struct marvell_tai **taip, struct phy_device *phydev);
+void marvell_tai_put(struct marvell_tai *tai);
+
+#endif
-- 
2.20.1

