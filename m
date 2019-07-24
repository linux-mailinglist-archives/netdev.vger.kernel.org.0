Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4BE729C8
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 10:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfGXITW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 04:19:22 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56515 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfGXITV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 04:19:21 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 0F0E0E000A;
        Wed, 24 Jul 2019 08:19:17 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: [PATCH net-next v3 8/8] net: mscc: PTP Hardware Clock (PHC) support
Date:   Wed, 24 Jul 2019 10:17:15 +0200
Message-Id: <20190724081715.29159-9-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190724081715.29159-1-antoine.tenart@bootlin.com>
References: <20190724081715.29159-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for PTP Hardware Clock (PHC) to the Ocelot
switch for both PTP 1-step and 2-step modes.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot.c       | 394 ++++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot.h       |  39 +++
 drivers/net/ethernet/mscc/ocelot_board.c | 111 ++++++-
 3 files changed, 536 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b71e4ecbe469..4f287202bf03 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/phy.h>
+#include <linux/ptp_clock_kernel.h>
 #include <linux/skbuff.h>
 #include <linux/iopoll.h>
 #include <net/arp.h>
@@ -538,7 +539,7 @@ static int ocelot_port_stop(struct net_device *dev)
  */
 static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
 {
-	ifh[0] = IFH_INJ_BYPASS;
+	ifh[0] = IFH_INJ_BYPASS | ((0x1ff & info->rew_op) << 21);
 	ifh[1] = (0xf00 & info->port) >> 8;
 	ifh[2] = (0xff & info->port) << 24;
 	ifh[3] = (info->tag_type << 16) | info->vid;
@@ -548,6 +549,7 @@ static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
 
 static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	struct ocelot_port *port = netdev_priv(dev);
 	struct ocelot *ocelot = port->ocelot;
 	u32 val, ifh[IFH_LEN];
@@ -566,6 +568,14 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	info.port = BIT(port->chip_port);
 	info.tag_type = IFH_TAG_TYPE_C;
 	info.vid = skb_vlan_tag_get(skb);
+
+	/* Check if timestamping is needed */
+	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
+		info.rew_op = port->ptp_cmd;
+		if (port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
+			info.rew_op |= (port->ts_id  % 4) << 3;
+	}
+
 	ocelot_gen_ifh(ifh, &info);
 
 	for (i = 0; i < IFH_LEN; i++)
@@ -596,11 +606,51 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += skb->len;
-	dev_kfree_skb_any(skb);
+
+	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
+	    port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+		struct ocelot_skb *oskb =
+			kzalloc(sizeof(struct ocelot_skb), GFP_ATOMIC);
+
+		oskb->skb = skb;
+		oskb->id = port->ts_id % 4;
+		port->ts_id++;
+
+		list_add_tail(&oskb->head, &port->skbs);
+	} else {
+		dev_kfree_skb_any(skb);
+	}
 
 	return NETDEV_TX_OK;
 }
 
+void ocelot_get_hwtimestamp(struct ocelot *ocelot, struct timespec64 *ts)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+
+	/* Read current PTP time to get seconds */
+	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
+
+	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
+	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_SAVE);
+	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
+	ts->tv_sec = ocelot_read_rix(ocelot, PTP_PIN_TOD_SEC_LSB, TOD_ACC_PIN);
+
+	/* Read packet HW timestamp from FIFO */
+	val = ocelot_read(ocelot, SYS_PTP_TXSTAMP);
+	ts->tv_nsec = SYS_PTP_TXSTAMP_PTP_TXSTAMP(val);
+
+	/* Sec has incremented since the ts was registered */
+	if ((ts->tv_sec & 0x1) != !!(val & SYS_PTP_TXSTAMP_PTP_TXSTAMP_SEC))
+		ts->tv_sec--;
+
+	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+}
+EXPORT_SYMBOL(ocelot_get_hwtimestamp);
+
 static int ocelot_mc_unsync(struct net_device *dev, const unsigned char *addr)
 {
 	struct ocelot_port *port = netdev_priv(dev);
@@ -917,6 +967,97 @@ static int ocelot_get_port_parent_id(struct net_device *dev,
 	return 0;
 }
 
+static int ocelot_hwstamp_get(struct ocelot_port *port, struct ifreq *ifr)
+{
+	struct ocelot *ocelot = port->ocelot;
+
+	return copy_to_user(ifr->ifr_data, &ocelot->hwtstamp_config,
+			    sizeof(ocelot->hwtstamp_config)) ? -EFAULT : 0;
+}
+
+static int ocelot_hwstamp_set(struct ocelot_port *port, struct ifreq *ifr)
+{
+	struct ocelot *ocelot = port->ocelot;
+	struct hwtstamp_config cfg;
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	/* reserved for future extensions */
+	if (cfg.flags)
+		return -EINVAL;
+
+	/* Tx type sanity check */
+	switch (cfg.tx_type) {
+	case HWTSTAMP_TX_ON:
+		port->ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
+		break;
+	case HWTSTAMP_TX_ONESTEP_SYNC:
+		/* IFH_REW_OP_ONE_STEP_PTP updates the correctional field, we
+		 * need to update the origin time.
+		 */
+		port->ptp_cmd = IFH_REW_OP_ORIGIN_PTP;
+		break;
+	case HWTSTAMP_TX_OFF:
+		port->ptp_cmd = 0;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	mutex_lock(&ocelot->ptp_lock);
+
+	switch (cfg.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		break;
+	case HWTSTAMP_FILTER_ALL:
+	case HWTSTAMP_FILTER_SOME:
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_NTP_ALL:
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		break;
+	default:
+		mutex_unlock(&ocelot->ptp_lock);
+		return -ERANGE;
+	}
+
+	/* Commit back the result & save it */
+	memcpy(&ocelot->hwtstamp_config, &cfg, sizeof(cfg));
+	mutex_unlock(&ocelot->ptp_lock);
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	struct ocelot_port *port = netdev_priv(dev);
+	struct ocelot *ocelot = port->ocelot;
+
+	/* The function is only used for PTP operations for now */
+	if (!ocelot->ptp)
+		return -EOPNOTSUPP;
+
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return ocelot_hwstamp_set(port, ifr);
+	case SIOCGHWTSTAMP:
+		return ocelot_hwstamp_get(port, ifr);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_open			= ocelot_port_open,
 	.ndo_stop			= ocelot_port_stop,
@@ -933,6 +1074,7 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_set_features		= ocelot_set_features,
 	.ndo_get_port_parent_id		= ocelot_get_port_parent_id,
 	.ndo_setup_tc			= ocelot_setup_tc,
+	.ndo_do_ioctl			= ocelot_ioctl,
 };
 
 static void ocelot_get_strings(struct net_device *netdev, u32 sset, u8 *data)
@@ -1014,12 +1156,37 @@ static int ocelot_get_sset_count(struct net_device *dev, int sset)
 	return ocelot->num_stats;
 }
 
+static int ocelot_get_ts_info(struct net_device *dev,
+			      struct ethtool_ts_info *info)
+{
+	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot *ocelot = ocelot_port->ocelot;
+
+	if (!ocelot->ptp)
+		return ethtool_op_get_ts_info(dev, info);
+
+	info->phc_index = ocelot->ptp_clock ?
+			  ptp_clock_index(ocelot->ptp_clock) : -1;
+	info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
+				 SOF_TIMESTAMPING_RX_SOFTWARE |
+				 SOF_TIMESTAMPING_SOFTWARE |
+				 SOF_TIMESTAMPING_TX_HARDWARE |
+				 SOF_TIMESTAMPING_RX_HARDWARE |
+				 SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON) |
+			 BIT(HWTSTAMP_TX_ONESTEP_SYNC);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) | BIT(HWTSTAMP_FILTER_ALL);
+
+	return 0;
+}
+
 static const struct ethtool_ops ocelot_ethtool_ops = {
 	.get_strings		= ocelot_get_strings,
 	.get_ethtool_stats	= ocelot_get_ethtool_stats,
 	.get_sset_count		= ocelot_get_sset_count,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
+	.get_ts_info		= ocelot_get_ts_info,
 };
 
 static int ocelot_port_attr_stp_state_set(struct ocelot_port *ocelot_port,
@@ -1629,6 +1796,196 @@ struct notifier_block ocelot_switchdev_blocking_nb __read_mostly = {
 };
 EXPORT_SYMBOL(ocelot_switchdev_blocking_nb);
 
+int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts)
+{
+	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
+	unsigned long flags;
+	time64_t s;
+	u32 val;
+	s64 ns;
+
+	spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+
+	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
+	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
+	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_SAVE);
+	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
+
+	s = ocelot_read_rix(ocelot, PTP_PIN_TOD_SEC_MSB, TOD_ACC_PIN) & 0xffff;
+	s <<= 32;
+	s += ocelot_read_rix(ocelot, PTP_PIN_TOD_SEC_LSB, TOD_ACC_PIN);
+	ns = ocelot_read_rix(ocelot, PTP_PIN_TOD_NSEC, TOD_ACC_PIN);
+
+	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+
+	/* Deal with negative values */
+	if (ns >= 0x3ffffff0 && ns <= 0x3fffffff) {
+		s--;
+		ns &= 0xf;
+		ns += 999999984;
+	}
+
+	set_normalized_timespec64(ts, s, ns);
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_ptp_gettime64);
+
+static int ocelot_ptp_settime64(struct ptp_clock_info *ptp,
+				const struct timespec64 *ts)
+{
+	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+
+	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
+	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
+	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_IDLE);
+
+	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
+
+	ocelot_write_rix(ocelot, lower_32_bits(ts->tv_sec), PTP_PIN_TOD_SEC_LSB,
+			 TOD_ACC_PIN);
+	ocelot_write_rix(ocelot, upper_32_bits(ts->tv_sec), PTP_PIN_TOD_SEC_MSB,
+			 TOD_ACC_PIN);
+	ocelot_write_rix(ocelot, ts->tv_nsec, PTP_PIN_TOD_NSEC, TOD_ACC_PIN);
+
+	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
+	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
+	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_LOAD);
+
+	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
+
+	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+	return 0;
+}
+
+static int ocelot_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	if (delta > -(NSEC_PER_SEC / 2) && delta < (NSEC_PER_SEC / 2)) {
+		struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
+		unsigned long flags;
+		u32 val;
+
+		spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+
+		val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
+		val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
+		val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_IDLE);
+
+		ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
+
+		ocelot_write_rix(ocelot, 0, PTP_PIN_TOD_SEC_LSB, TOD_ACC_PIN);
+		ocelot_write_rix(ocelot, 0, PTP_PIN_TOD_SEC_MSB, TOD_ACC_PIN);
+		ocelot_write_rix(ocelot, delta, PTP_PIN_TOD_NSEC, TOD_ACC_PIN);
+
+		val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
+		val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
+		val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_DELTA);
+
+		ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
+
+		spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+	} else {
+		/* Fall back using ocelot_ptp_settime64 which is not exact. */
+		struct timespec64 ts;
+		u64 now;
+
+		ocelot_ptp_gettime64(ptp, &ts);
+
+		now = ktime_to_ns(timespec64_to_ktime(ts));
+		ts = ns_to_timespec64(now + delta);
+
+		ocelot_ptp_settime64(ptp, &ts);
+	}
+	return 0;
+}
+
+static int ocelot_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
+	u32 unit = 0, direction = 0;
+	unsigned long flags;
+	u64 adj = 0;
+
+	if (!scaled_ppm)
+		goto disable_adj;
+
+	if (scaled_ppm < 0) {
+		direction = PTP_CFG_CLK_ADJ_CFG_DIR;
+		scaled_ppm = -scaled_ppm;
+	}
+
+	adj = PSEC_PER_SEC << 16;
+	do_div(adj, scaled_ppm);
+	do_div(adj, 1000);
+
+	/* If the adjustment value is too large, use ns instead */
+	if (adj >= (1L << 30)) {
+		unit = PTP_CFG_CLK_ADJ_FREQ_NS;
+		do_div(adj, 1000);
+	}
+
+	spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+
+	/* Still too big */
+	if (adj >= (1L << 30))
+		goto disable_adj;
+
+	ocelot_write(ocelot, unit | adj, PTP_CLK_CFG_ADJ_FREQ);
+	ocelot_write(ocelot, PTP_CFG_CLK_ADJ_CFG_ENA | direction,
+		     PTP_CLK_CFG_ADJ_CFG);
+
+	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+	return 0;
+
+disable_adj:
+	ocelot_write(ocelot, 0, PTP_CLK_CFG_ADJ_CFG);
+
+	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+	return 0;
+}
+
+static struct ptp_clock_info ocelot_ptp_clock_info = {
+	.owner		= THIS_MODULE,
+	.name		= "ocelot ptp",
+	.max_adj	= 0x7fffffff,
+	.n_alarm	= 0,
+	.n_ext_ts	= 0,
+	.n_per_out	= 0,
+	.n_pins		= 0,
+	.pps		= 0,
+	.gettime64	= ocelot_ptp_gettime64,
+	.settime64	= ocelot_ptp_settime64,
+	.adjtime	= ocelot_ptp_adjtime,
+	.adjfine	= ocelot_ptp_adjfine,
+};
+
+static int ocelot_init_timestamp(struct ocelot *ocelot)
+{
+	ocelot->ptp_info = ocelot_ptp_clock_info;
+	ocelot->ptp_clock = ptp_clock_register(&ocelot->ptp_info, ocelot->dev);
+	if (IS_ERR(ocelot->ptp_clock))
+		return PTR_ERR(ocelot->ptp_clock);
+	/* Check if PHC support is missing at the configuration level */
+	if (!ocelot->ptp_clock)
+		return 0;
+
+	ocelot_write(ocelot, SYS_PTP_CFG_PTP_STAMP_WID(30), SYS_PTP_CFG);
+	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_LOW);
+	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_HIGH);
+
+	ocelot_write(ocelot, PTP_CFG_MISC_PTP_EN, PTP_CFG_MISC);
+
+	/* There is no device reconfiguration, PTP Rx stamping is always
+	 * enabled.
+	 */
+	ocelot->hwtstamp_config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+
+	return 0;
+}
+
 int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 		      void __iomem *regs,
 		      struct phy_device *phy)
@@ -1661,6 +2018,8 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr, ocelot_port->pvid,
 			  ENTRYTYPE_LOCKED);
 
+	INIT_LIST_HEAD(&ocelot_port->skbs);
+
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(ocelot->dev, "register_netdev failed\n");
@@ -1684,7 +2043,7 @@ EXPORT_SYMBOL(ocelot_probe_port);
 int ocelot_init(struct ocelot *ocelot)
 {
 	u32 port;
-	int i, cpu = ocelot->num_phys_ports;
+	int i, ret, cpu = ocelot->num_phys_ports;
 	char queue_name[32];
 
 	ocelot->lags = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
@@ -1699,6 +2058,8 @@ int ocelot_init(struct ocelot *ocelot)
 		return -ENOMEM;
 
 	mutex_init(&ocelot->stats_lock);
+	mutex_init(&ocelot->ptp_lock);
+	spin_lock_init(&ocelot->ptp_clock_lock);
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
 		 dev_name(ocelot->dev));
 	ocelot->stats_queue = create_singlethread_workqueue(queue_name);
@@ -1812,15 +2173,42 @@ int ocelot_init(struct ocelot *ocelot)
 	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
+
+	if (ocelot->ptp) {
+		ret = ocelot_init_timestamp(ocelot);
+		if (ret) {
+			dev_err(ocelot->dev,
+				"Timestamp initialization failed\n");
+			return ret;
+		}
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(ocelot_init);
 
 void ocelot_deinit(struct ocelot *ocelot)
 {
+	struct list_head *pos, *tmp;
+	struct ocelot_port *port;
+	struct ocelot_skb *entry;
+	int i;
+
 	destroy_workqueue(ocelot->stats_queue);
 	mutex_destroy(&ocelot->stats_lock);
 	ocelot_ace_deinit();
+
+	for (i = 0; i < ocelot->num_phys_ports; i++) {
+		port = ocelot->ports[i];
+
+		list_for_each_safe(pos, tmp, &port->skbs) {
+			entry = list_entry(pos, struct ocelot_skb, head);
+
+			list_del(pos);
+			dev_kfree_skb_any(entry->skb);
+			kfree(entry);
+		}
+	}
 }
 EXPORT_SYMBOL(ocelot_deinit);
 
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 515dee6fa8a6..e40773c01a44 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -11,9 +11,11 @@
 #include <linux/bitops.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
+#include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/ptp_clock_kernel.h>
 #include <linux/regmap.h>
 
 #include "ocelot_ana.h"
@@ -39,6 +41,8 @@
 
 #define OCELOT_STATS_CHECK_DELAY (2 * HZ)
 
+#define OCELOT_PTP_QUEUE_SZ	128
+
 #define IFH_LEN 4
 
 struct frame_info {
@@ -46,6 +50,8 @@ struct frame_info {
 	u16 port;
 	u16 vid;
 	u8 tag_type;
+	u16 rew_op;
+	u32 timestamp;	/* rew_val */
 };
 
 #define IFH_INJ_BYPASS	BIT(31)
@@ -54,6 +60,12 @@ struct frame_info {
 #define IFH_TAG_TYPE_C 0
 #define IFH_TAG_TYPE_S 1
 
+#define IFH_REW_OP_NOOP			0x0
+#define IFH_REW_OP_DSCP			0x1
+#define IFH_REW_OP_ONE_STEP_PTP		0x2
+#define IFH_REW_OP_TWO_STEP_PTP		0x3
+#define IFH_REW_OP_ORIGIN_PTP		0x5
+
 #define OCELOT_SPEED_2500 0
 #define OCELOT_SPEED_1000 1
 #define OCELOT_SPEED_100  2
@@ -401,6 +413,13 @@ enum ocelot_regfield {
 	REGFIELD_MAX
 };
 
+enum ocelot_clk_pins {
+	ALT_PPS_PIN	= 1,
+	EXT_CLK_PIN,
+	ALT_LDST_PIN,
+	TOD_ACC_PIN
+};
+
 struct ocelot_multicast {
 	struct list_head list;
 	unsigned char addr[ETH_ALEN];
@@ -450,6 +469,13 @@ struct ocelot {
 	u64 *stats;
 	struct delayed_work stats_work;
 	struct workqueue_struct *stats_queue;
+
+	u8 ptp:1;
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info ptp_info;
+	struct hwtstamp_config hwtstamp_config;
+	struct mutex ptp_lock; /* Protects the PTP interface state */
+	spinlock_t ptp_clock_lock; /* Protects the PTP clock */
 };
 
 struct ocelot_port {
@@ -473,6 +499,16 @@ struct ocelot_port {
 	struct phy *serdes;
 
 	struct ocelot_port_tc tc;
+
+	u8 ptp_cmd;
+	struct list_head skbs;
+	u8 ts_id;
+};
+
+struct ocelot_skb {
+	struct list_head head;
+	struct sk_buff *skb;
+	u8 id;
 };
 
 u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
@@ -517,4 +553,7 @@ extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
 extern struct notifier_block ocelot_switchdev_blocking_nb;
 
+int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
+void ocelot_get_hwtimestamp(struct ocelot *ocelot, struct timespec64 *ts);
+
 #endif
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index df8d15994a89..0b14e7110e7f 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -31,6 +31,8 @@ static int ocelot_parse_ifh(u32 *_ifh, struct frame_info *info)
 
 	info->len = OCELOT_BUFFER_CELL_SZ * wlen + llen - 80;
 
+	info->timestamp = IFH_EXTRACT_BITFIELD64(ifh[0], 21, 32);
+
 	info->port = IFH_EXTRACT_BITFIELD64(ifh[1], 43, 4);
 
 	info->tag_type = IFH_EXTRACT_BITFIELD64(ifh[1], 16,  1);
@@ -98,7 +100,11 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		int sz, len, buf_len;
 		u32 ifh[4];
 		u32 val;
-		struct frame_info info;
+		struct frame_info info = {};
+		struct timespec64 ts;
+		struct skb_shared_hwtstamps *shhwtstamps;
+		u64 tod_in_ns;
+		u64 full_ts_in_ns;
 
 		for (i = 0; i < IFH_LEN; i++) {
 			err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
@@ -145,6 +151,22 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 			break;
 		}
 
+		if (ocelot->ptp) {
+			ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
+
+			tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
+			if ((tod_in_ns & 0xffffffff) < info.timestamp)
+				full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
+						info.timestamp;
+			else
+				full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
+						info.timestamp;
+
+			shhwtstamps = skb_hwtstamps(skb);
+			memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
+			shhwtstamps->hwtstamp = full_ts_in_ns;
+		}
+
 		/* Everything we see on an interface that is in the HW bridge
 		 * has already been forwarded.
 		 */
@@ -164,6 +186,70 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t ocelot_ptp_rdy_irq_handler(int irq, void *arg)
+{
+	int budget = OCELOT_PTP_QUEUE_SZ;
+	struct ocelot *ocelot = arg;
+
+	do {
+		struct skb_shared_hwtstamps shhwtstamps;
+		struct list_head *pos, *tmp;
+		struct sk_buff *skb = NULL;
+		struct ocelot_skb *entry;
+		struct ocelot_port *port;
+		struct timespec64 ts;
+		u32 val, id, txport;
+
+		/* Prevent from infinite loop */
+		if (unlikely(!--budget))
+			break;
+
+		val = ocelot_read(ocelot, SYS_PTP_STATUS);
+
+		/* Check if a timestamp can be retrieved */
+		if (!(val & SYS_PTP_STATUS_PTP_MESS_VLD))
+			break;
+
+		WARN_ON(val & SYS_PTP_STATUS_PTP_OVFL);
+
+		/* Retrieve the ts ID and Tx port */
+		id = SYS_PTP_STATUS_PTP_MESS_ID_X(val);
+		txport = SYS_PTP_STATUS_PTP_MESS_TXPORT_X(val);
+
+		/* Retrieve its associated skb */
+		port = ocelot->ports[txport];
+
+		list_for_each_safe(pos, tmp, &port->skbs) {
+			entry = list_entry(pos, struct ocelot_skb, head);
+			if (entry->id != id)
+				continue;
+
+			skb = entry->skb;
+
+			list_del(pos);
+			kfree(entry);
+		}
+
+		/* Next ts */
+		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
+
+		if (unlikely(!skb))
+			continue;
+
+		/* Get the h/w timestamp */
+		ocelot_get_hwtimestamp(ocelot, &ts);
+
+		/* Set the timestamp into the skb */
+		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
+		skb_tstamp_tx(skb, &shhwtstamps);
+
+		dev_kfree_skb_any(skb);
+	} while (true);
+
+	return IRQ_HANDLED;
+}
+
 static const struct of_device_id mscc_ocelot_match[] = {
 	{ .compatible = "mscc,vsc7514-switch" },
 	{ }
@@ -172,8 +258,8 @@ MODULE_DEVICE_TABLE(of, mscc_ocelot_match);
 
 static int mscc_ocelot_probe(struct platform_device *pdev)
 {
-	int err, irq;
 	unsigned int i;
+	int err, irq_xtr, irq_ptp_rdy;
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *ports, *portnp;
 	struct ocelot *ocelot;
@@ -232,16 +318,31 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	irq = platform_get_irq_byname(pdev, "xtr");
-	if (irq < 0)
+	irq_xtr = platform_get_irq_byname(pdev, "xtr");
+	if (irq_xtr < 0)
 		return -ENODEV;
 
-	err = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+	err = devm_request_threaded_irq(&pdev->dev, irq_xtr, NULL,
 					ocelot_xtr_irq_handler, IRQF_ONESHOT,
 					"frame extraction", ocelot);
 	if (err)
 		return err;
 
+
+	irq_ptp_rdy = platform_get_irq_byname(pdev, "ptp_rdy");
+	if (irq_ptp_rdy > 0) {
+		err = devm_request_threaded_irq(&pdev->dev, irq_ptp_rdy, NULL,
+						ocelot_ptp_rdy_irq_handler,
+						IRQF_ONESHOT, "ptp ready",
+						ocelot);
+		if (err)
+			return err;
+
+		/* Check if we can support PTP */
+		if (ocelot->targets[PTP])
+			ocelot->ptp = 1;
+	}
+
 	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
 	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
 
-- 
2.21.0

