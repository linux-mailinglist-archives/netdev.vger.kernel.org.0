Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9488A3379C9
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhCKQoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:44:32 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59164 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229578AbhCKQoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:44:01 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BGVL09023546;
        Thu, 11 Mar 2021 08:43:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=iNlNbt9t+uVMaHyszqVGIIe3kZ30F9liZSDTX+5q2+Y=;
 b=VSmMEieZd6TPqaBP2aTE5qdc/cewQnqWTUjaVHBPQlEMtHlPGq+BAlG5B/5XrIyfjrsW
 eO6a1tEG78ZBpp+/7p9C6tl0B8LWJjfwG3GfmxIqvnpmRgHkcP60jkcD+dBF7cl2/s4u
 oqmHTUoSQB4cZj1vbMXhPY2VV6icVk2eBUEI+cF4n0AsHy6i8R0DSBjSCNmIFWgXeI+f
 g0ODyq0PYv5sOTF4cUSRiaCoe8GGZE+NWE2qtzfAIMVr5aznjdGz7NUCesMZUZAodqmd
 jiJB/wpXTmyJ740MKW4NZE3+DMBHAxwJrkxNfmYYAYRFRtpaZcNGItYbEG9ZwbCfJcgO IA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 377gn9h902-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 08:43:44 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 08:43:43 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Mar 2021 08:43:43 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id DE4133F703F;
        Thu, 11 Mar 2021 08:43:39 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, <rabeeh@solid-run.com>
Subject: [V2 net-next] net: mvpp2: Add reserved port private flag configuration
Date:   Thu, 11 Mar 2021 18:43:27 +0200
Message-ID: <1615481007-16735-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_06:2021-03-10,2021-03-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

According to Armada SoC architecture and design, all the PPv2 ports
which are populated on the same communication processor silicon die
(CP11x) share the same Classifier and Parser engines.

Armada is an embedded platform and therefore there is a need to reserve
some of the PPv2 ports for different use cases.

For example, a port can be reserved for a CM3 CPU running FreeRTOS for
management purposes or by user-space data plane application.

During port reservation all common configurations are preserved and
only RXQ, TXQ, and interrupt vectors are disabled.
Since TXQ's are disabled, the Kernel won't transmit any packet
from this port, and to due the closed RXQ interrupts, the Kernel won't
receive any packet.
The port MAC address and administrative UP/DOWN state can still
be changed.
The only permitted configuration in this mode is MTU change.
The driver's .ndo_change_mtu callback has logic that switches between
percpu_pools and shared pools buffer mode, since the buffer management
not done by Kernel this should be permitted.

v1 --> v2
- Rename existing mvpp2_ethtool_get_strings and helper _priv function
- Add more info to commit message

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |   4 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 248 ++++++++++++++++++--
 2 files changed, 228 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 8edba5e..e2f8eec 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -865,6 +865,7 @@
 /* Port flags */
 #define MVPP2_F_LOOPBACK		BIT(0)
 #define MVPP2_F_DT_COMPAT		BIT(1)
+#define MVPP22_F_IF_RESERVED		BIT(2)
 
 /* Marvell tag types */
 enum mvpp2_tag_type {
@@ -1251,6 +1252,9 @@ struct mvpp2_port {
 
 	/* Firmware TX flow control */
 	bool tx_fc;
+
+	/* private storage, allocated/used by Reserved/Normal mode toggling */
+	void *res_cfg;
 };
 
 /* The mvpp2_tx_desc and mvpp2_rx_desc structures describe the
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d415447..7406724 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -55,6 +55,14 @@ enum mvpp2_bm_pool_log_num {
 	int buf_num;
 } mvpp2_pools[MVPP2_BM_POOLS_NUM];
 
+struct mvpp2_port_port_cfg {
+	unsigned int nqvecs;
+	unsigned int nrxqs;
+	unsigned int ntxqs;
+	int mtu;
+	bool rxhash_en;
+};
+
 /* The prototype is added here to be used in start_dev when using ACPI. This
  * will be removed once phylink is used for all modes (dt+ACPI).
  */
@@ -1431,6 +1439,9 @@ static void mvpp2_interrupts_unmask(void *arg)
 	if (cpu >= port->priv->nthreads)
 		return;
 
+	if (port->flags & MVPP22_F_IF_RESERVED)
+		return;
+
 	thread = mvpp2_cpu_to_thread(port->priv, cpu);
 
 	val = MVPP2_CAUSE_MISC_SUM_MASK |
@@ -1942,15 +1953,23 @@ static u32 mvpp2_read_index(struct mvpp2 *priv, u32 index, u32 reg)
 						 (ARRAY_SIZE(mvpp2_ethtool_rxq_regs) * (nrxqs)) + \
 						 ARRAY_SIZE(mvpp2_ethtool_xdp))
 
-static void mvpp2_ethtool_get_strings(struct net_device *netdev, u32 sset,
-				      u8 *data)
+static const char mvpp22_priv_flags_strings[][ETH_GSTRING_LEN] = {
+	"reserved",
+};
+
+#define MVPP22_F_IF_RESERVED_PRIV	BIT(0)
+
+static void mvpp2_ethtool_get_strings_priv(u8 *data)
+{
+	memcpy(data, mvpp22_priv_flags_strings,
+	       ARRAY_SIZE(mvpp22_priv_flags_strings) * ETH_GSTRING_LEN);
+}
+
+static void mvpp2_ethtool_get_strings_stats(struct net_device *netdev, u8 *data)
 {
 	struct mvpp2_port *port = netdev_priv(netdev);
 	int i, q;
 
-	if (sset != ETH_SS_STATS)
-		return;
-
 	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_mib_regs); i++) {
 		strscpy(data, mvpp2_ethtool_mib_regs[i].string,
 			ETH_GSTRING_LEN);
@@ -1987,6 +2006,18 @@ static void mvpp2_ethtool_get_strings(struct net_device *netdev, u32 sset,
 	}
 }
 
+static void mvpp2_ethtool_get_strings(struct net_device *netdev, u32 sset,
+				      u8 *data)
+{
+	switch (sset) {
+	case ETH_SS_STATS:
+		mvpp2_ethtool_get_strings_stats(netdev, data);
+		break;
+	case ETH_SS_PRIV_FLAGS:
+		mvpp2_ethtool_get_strings_priv(data);
+	}
+}
+
 static void
 mvpp2_get_xdp_stats(struct mvpp2_port *port, struct mvpp2_pcpu_stats *xdp_stats)
 {
@@ -2130,8 +2161,13 @@ static int mvpp2_ethtool_get_sset_count(struct net_device *dev, int sset)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
 
-	if (sset == ETH_SS_STATS)
+	switch (sset) {
+	case ETH_SS_STATS:
 		return MVPP2_N_ETHTOOL_STATS(port->ntxqs, port->nrxqs);
+	case ETH_SS_PRIV_FLAGS:
+		return (port->priv->hw_version == MVPP21) ?
+			0 : ARRAY_SIZE(mvpp22_priv_flags_strings);
+	}
 
 	return -EOPNOTSUPP;
 }
@@ -2207,6 +2243,9 @@ static inline void mvpp2_gmac_max_rx_size_set(struct mvpp2_port *port)
 {
 	u32 val;
 
+	if (port->flags & MVPP22_F_IF_RESERVED)
+		return;
+
 	val = readl(port->base + MVPP2_GMAC_CTRL_0_REG);
 	val &= ~MVPP2_GMAC_MAX_RX_SIZE_MASK;
 	val |= (((port->pkt_size - MVPP2_MH_SIZE) / 2) <<
@@ -2219,6 +2258,9 @@ static inline void mvpp2_xlg_max_rx_size_set(struct mvpp2_port *port)
 {
 	u32 val;
 
+	if (port->flags & MVPP22_F_IF_RESERVED)
+		return;
+
 	val =  readl(port->base + MVPP22_XLG_CTRL1_REG);
 	val &= ~MVPP22_XLG_CTRL1_FRAMESIZELIMIT_MASK;
 	val |= ((port->pkt_size - MVPP2_MH_SIZE) / 2) <<
@@ -2321,6 +2363,9 @@ static void mvpp2_egress_enable(struct mvpp2_port *port)
 	int queue;
 	int tx_port_num = mvpp2_egress_port(port);
 
+	if (port->flags & MVPP22_F_IF_RESERVED)
+		return;
+
 	/* Enable all initialized TXs. */
 	qmap = 0;
 	for (queue = 0; queue < port->ntxqs; queue++) {
@@ -2343,6 +2388,9 @@ static void mvpp2_egress_disable(struct mvpp2_port *port)
 	int delay;
 	int tx_port_num = mvpp2_egress_port(port);
 
+	if (port->flags & MVPP22_F_IF_RESERVED)
+		return;
+
 	/* Issue stop command for active channels only */
 	mvpp2_write(port->priv, MVPP2_TXP_SCHED_PORT_INDEX_REG, tx_port_num);
 	reg_data = (mvpp2_read(port->priv, MVPP2_TXP_SCHED_Q_CMD_REG)) &
@@ -3411,7 +3459,8 @@ static void mvpp2_isr_handle_link(struct mvpp2_port *port, bool link)
 		mvpp2_egress_enable(port);
 		mvpp2_ingress_enable(port);
 		netif_carrier_on(dev);
-		netif_tx_wake_all_queues(dev);
+		if (!(port->flags & MVPP22_F_IF_RESERVED))
+			netif_tx_wake_all_queues(dev);
 	} else {
 		netif_tx_stop_all_queues(dev);
 		netif_carrier_off(dev);
@@ -4556,7 +4605,8 @@ static void mvpp2_start_dev(struct mvpp2_port *port)
 		mvpp2_acpi_start(port);
 	}
 
-	netif_tx_start_all_queues(port->dev);
+	if (!(port->flags & MVPP22_F_IF_RESERVED))
+		netif_tx_start_all_queues(port->dev);
 
 	clear_bit(0, &port->state);
 }
@@ -4702,7 +4752,8 @@ static void mvpp2_irqs_deinit(struct mvpp2_port *port)
 static bool mvpp22_rss_is_supported(struct mvpp2_port *port)
 {
 	return (queue_mode == MVPP2_QDIST_MULTI_MODE) &&
-		!(port->flags & MVPP2_F_LOOPBACK);
+		!(port->flags & MVPP2_F_LOOPBACK) &&
+		!(port->flags & MVPP22_F_IF_RESERVED);
 }
 
 static int mvpp2_open(struct net_device *dev)
@@ -4719,20 +4770,23 @@ static int mvpp2_open(struct net_device *dev)
 		netdev_err(dev, "mvpp2_prs_mac_da_accept BC failed\n");
 		return err;
 	}
-	err = mvpp2_prs_mac_da_accept(port, dev->dev_addr, true);
-	if (err) {
-		netdev_err(dev, "mvpp2_prs_mac_da_accept own addr failed\n");
-		return err;
-	}
-	err = mvpp2_prs_tag_mode_set(port->priv, port->id, MVPP2_TAG_TYPE_MH);
-	if (err) {
-		netdev_err(dev, "mvpp2_prs_tag_mode_set failed\n");
-		return err;
-	}
-	err = mvpp2_prs_def_flow(port);
-	if (err) {
-		netdev_err(dev, "mvpp2_prs_def_flow failed\n");
-		return err;
+
+	if (!(port->flags & MVPP22_F_IF_RESERVED)) {
+		err = mvpp2_prs_mac_da_accept(port, dev->dev_addr, true);
+		if (err) {
+			netdev_err(dev, "mvpp2_prs_mac_da_accept own addr failed\n");
+			return err;
+		}
+		err = mvpp2_prs_tag_mode_set(port->priv, port->id, MVPP2_TAG_TYPE_MH);
+		if (err) {
+			netdev_err(dev, "mvpp2_prs_tag_mode_set failed\n");
+			return err;
+		}
+		err = mvpp2_prs_def_flow(port);
+		if (err) {
+			netdev_err(dev, "mvpp2_prs_def_flow failed\n");
+			return err;
+		}
 	}
 
 	/* Allocate the Rx/Tx queues */
@@ -4979,6 +5033,11 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
 	struct mvpp2 *priv = port->priv;
 	int err;
 
+	if (port->flags & MVPP22_F_IF_RESERVED) {
+		netdev_err(dev, "MTU can not be modified for port in reserved mode\n");
+		return -EPERM;
+	}
+
 	if (!IS_ALIGNED(MVPP2_RX_PKT_SIZE(mtu), 8)) {
 		netdev_info(dev, "illegal MTU value %d, round to %d\n", mtu,
 			    ALIGN(MVPP2_RX_PKT_SIZE(mtu), 8));
@@ -5385,12 +5444,16 @@ static int mvpp2_ethtool_get_coalesce(struct net_device *dev,
 static void mvpp2_ethtool_get_drvinfo(struct net_device *dev,
 				      struct ethtool_drvinfo *drvinfo)
 {
+	struct mvpp2_port *port = netdev_priv(dev);
+
 	strlcpy(drvinfo->driver, MVPP2_DRIVER_NAME,
 		sizeof(drvinfo->driver));
 	strlcpy(drvinfo->version, MVPP2_DRIVER_VERSION,
 		sizeof(drvinfo->version));
 	strlcpy(drvinfo->bus_info, dev_name(&dev->dev),
 		sizeof(drvinfo->bus_info));
+	drvinfo->n_priv_flags = (port->priv->hw_version == MVPP21) ?
+			0 : ARRAY_SIZE(mvpp22_priv_flags_strings);
 }
 
 static void mvpp2_ethtool_get_ringparam(struct net_device *dev,
@@ -5662,6 +5725,139 @@ static int mvpp2_ethtool_set_rxfh_context(struct net_device *dev,
 
 	return mvpp22_port_rss_ctx_indir_set(port, *rss_context, indir);
 }
+
+static u32 mvpp22_get_priv_flags(struct net_device *dev)
+{
+	struct mvpp2_port *port = netdev_priv(dev);
+	u32 priv_flags = 0;
+
+	if (port->flags & MVPP22_F_IF_RESERVED)
+		priv_flags |= MVPP22_F_IF_RESERVED_PRIV;
+	return priv_flags;
+}
+
+static int mvpp2_port_reserved_cfg(struct net_device *dev, bool ena)
+{
+	struct mvpp2_port *port = netdev_priv(dev);
+	struct mvpp2_port_port_cfg *cfg;
+
+	if (ena) {
+		/* Disable Queues and IntVec allocations for reserved ports,
+		 * but save original values.
+		 */
+		cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+		if (!cfg)
+			return -ENOMEM;
+		port->res_cfg = (void *)cfg;
+		cfg->nqvecs = port->nqvecs;
+		cfg->nrxqs  = port->nrxqs;
+		cfg->ntxqs = port->ntxqs;
+		cfg->mtu = dev->mtu;
+		cfg->rxhash_en = !!(dev->hw_features & NETIF_F_RXHASH);
+
+		port->nqvecs = 0;
+		port->nrxqs  = 0;
+		port->ntxqs  = 0;
+		if (cfg->rxhash_en) {
+			dev->hw_features &= ~NETIF_F_RXHASH;
+			netdev_update_features(dev);
+		}
+	} else {
+		struct mvpp2_bm_pool *pool;
+		int i;
+
+		/* Back to normal mode */
+		cfg = port->res_cfg;
+		port->nqvecs = cfg->nqvecs;
+		port->nrxqs  = cfg->nrxqs;
+		port->ntxqs  = cfg->ntxqs;
+		if (cfg->rxhash_en) {
+			dev->hw_features |= NETIF_F_RXHASH;
+			netdev_update_features(dev);
+		}
+		kfree(cfg);
+		port->res_cfg = NULL;
+
+		/* Restore RxQ/pool association */
+		for (i = 0; i < port->nrxqs; i++) {
+			if (port->priv->percpu_pools) {
+				pool = &port->priv->bm_pools[i];
+				mvpp2_rxq_short_pool_set(port, i, pool->id);
+				pool = &port->priv->bm_pools[i + port->nrxqs];
+				mvpp2_rxq_long_pool_set(port, i, pool->id);
+			} else {
+				mvpp2_rxq_short_pool_set(port, i, port->pool_short->id);
+				mvpp2_rxq_long_pool_set(port, i, port->pool_long->id);
+			}
+		}
+	}
+	return 0;
+}
+
+static int mvpp2_port_reserved_set(struct net_device *dev, bool ena)
+{
+	struct mvpp2_port *port = netdev_priv(dev);
+	bool running = netif_running(dev);
+	struct mvpp2 *priv = port->priv;
+	int err;
+
+	/* This procedure is called by ethtool change or by Module-remove.
+	 * For "remove" do anything only if we are in reserved-mode
+	 * and toggling back to Normal-mode is required.
+	 */
+	if (!ena && !port->res_cfg)
+		return 0;
+
+	if (ena) {
+		port->flags |= MVPP22_F_IF_RESERVED;
+		if (priv->percpu_pools)
+			mvpp2_bm_switch_buffers(priv, false);
+	} else {
+		bool reserved = false;
+		int i;
+
+		port->flags &= ~MVPP22_F_IF_RESERVED;
+		for (i = 0; i < priv->port_count; i++)
+			if (priv->port_list[i] != port &&
+			    priv->port_list[i]->flags & MVPP22_F_IF_RESERVED) {
+				reserved = true;
+				break;
+			}
+
+		if (!reserved) {
+			dev_info(port->dev->dev.parent,
+				 "No ports in reserved mode, switching to per-cpu buffers");
+			mvpp2_bm_switch_buffers(priv, true);
+		}
+	}
+
+	if (running)
+		mvpp2_stop(dev);
+
+	err = mvpp2_port_reserved_cfg(dev, ena);
+	if (err)
+		netdev_err(dev, "reserved set=%d: error=%d\n", ena, err);
+
+	if (running)
+		mvpp2_open(dev);
+
+	return 0;
+}
+
+static int mvpp22_set_priv_flags(struct net_device *dev, u32 priv_flags)
+{
+	struct mvpp2_port *port = netdev_priv(dev);
+	bool f_old, f_new;
+	int err = 0;
+
+	f_old = port->flags & MVPP22_F_IF_RESERVED;
+	f_new = priv_flags & MVPP22_F_IF_RESERVED_PRIV;
+	if (f_old != f_new)
+		err = mvpp2_port_reserved_set(dev, f_new);
+
+	return err;
+}
+
 /* Device ops */
 
 static const struct net_device_ops mvpp2_netdev_ops = {
@@ -5705,6 +5901,8 @@ static int mvpp2_ethtool_set_rxfh_context(struct net_device *dev,
 	.set_rxfh		= mvpp2_ethtool_set_rxfh,
 	.get_rxfh_context	= mvpp2_ethtool_get_rxfh_context,
 	.set_rxfh_context	= mvpp2_ethtool_set_rxfh_context,
+	.get_priv_flags		= mvpp22_get_priv_flags,
+	.set_priv_flags		= mvpp22_set_priv_flags,
 };
 
 /* Used for PPv2.1, or PPv2.2 with the old Device Tree binding that
@@ -6602,7 +6800,8 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 
 	mvpp2_egress_enable(port);
 	mvpp2_ingress_enable(port);
-	netif_tx_wake_all_queues(port->dev);
+	if (!(port->flags & MVPP22_F_IF_RESERVED))
+		netif_tx_wake_all_queues(port->dev);
 }
 
 static void mvpp2_mac_link_down(struct phylink_config *config,
@@ -6944,6 +7143,7 @@ static void mvpp2_port_remove(struct mvpp2_port *port)
 {
 	int i;
 
+	mvpp2_port_reserved_set(port->dev, false);
 	unregister_netdev(port->dev);
 	if (port->phylink)
 		phylink_destroy(port->phylink);
-- 
1.9.1

