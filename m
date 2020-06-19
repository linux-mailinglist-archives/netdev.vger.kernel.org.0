Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053AF20089C
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 14:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733072AbgFSM0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 08:26:00 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:43457 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733032AbgFSMZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 08:25:24 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id D4418240012;
        Fri, 19 Jun 2020 12:25:18 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net, antoine.tenart@bootlin.com
Subject: [PATCH net-next v3 6/8] net: phy: mscc: timestamping and PHC support
Date:   Fri, 19 Jun 2020 14:22:58 +0200
Message-Id: <20200619122300.2510533-7-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for PHC and timestamping operations for the MSCC
PHY. PTP 1-step and 2-step modes are supported, over Ethernet and UDP.

To get and set the PHC time, a GPIO has to be used and changes are only
retrieved or committed when on a rising edge. The same GPIO is shared by
all PHYs, so the granularity of the lock protecting it has to be
different from the ones protecting the 1588 registers (the VSC8584 PHY
has 2 1588 blocks, and a single load/save pin).

Co-developed-by: Quentin Schulz <quentin.schulz@bootlin.com>
Signed-off-by: Quentin Schulz <quentin.schulz@bootlin.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc.h      |  29 ++
 drivers/net/phy/mscc/mscc_main.c |  21 +-
 drivers/net/phy/mscc/mscc_ptp.c  | 580 +++++++++++++++++++++++++++++++
 3 files changed, 627 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 0881b22dbdac..af3dc82f170a 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -375,8 +375,13 @@ struct vsc8531_private {
 	unsigned long egr_flows;
 #endif
 
+	struct mii_timestamper mii_ts;
+
 	bool input_clk_init;
 	struct vsc85xx_ptp *ptp;
+	/* LOAD/SAVE GPIO pin, used for retrieving or setting time to the PHC.
+	 */
+	struct gpio_desc *load_save;
 
 	/* For multiple port PHYs; the MDIO address of the base PHY in the
 	 * pair of two PHYs that share a 1588 engine. PHY0 and PHY2 are coupled.
@@ -387,8 +392,18 @@ struct vsc8531_private {
 	u8 ts_base_phy;
 
 	/* ts_lock: used for per-PHY timestamping operations.
+	 * phc_lock: used for per-PHY PHC opertations.
 	 */
 	struct mutex ts_lock;
+	struct mutex phc_lock;
+};
+
+/* Shared structure between the PHYs of the same package.
+ * gpio_lock: used for PHC operations. Common for all PHYs as the load/save GPIO
+ * is shared.
+ */
+struct vsc85xx_shared_private {
+	struct mutex gpio_lock;
 };
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
@@ -417,20 +432,34 @@ static inline void vsc8584_config_macsec_intr(struct phy_device *phydev)
 
 #if IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING)
 void vsc85xx_link_change_notify(struct phy_device *phydev);
+void vsc8584_config_ts_intr(struct phy_device *phydev);
 int vsc8584_ptp_init(struct phy_device *phydev);
+int vsc8584_ptp_probe_once(struct phy_device *phydev);
 int vsc8584_ptp_probe(struct phy_device *phydev);
+irqreturn_t vsc8584_handle_ts_interrupt(struct phy_device *phydev);
 #else
 static inline void vsc85xx_link_change_notify(struct phy_device *phydev)
 {
 }
+static inline void vsc8584_config_ts_intr(struct phy_device *phydev)
+{
+}
 static inline int vsc8584_ptp_init(struct phy_device *phydev)
 {
 	return 0;
 }
+static inline int vsc8584_ptp_probe_once(struct phy_device *phydev)
+{
+	return 0;
+}
 static inline int vsc8584_ptp_probe(struct phy_device *phydev)
 {
 	return 0;
 }
+static inline irqreturn_t vsc8584_handle_ts_interrupt(struct phy_device *phydev)
+{
+	return IRQ_NONE;
+}
 #endif
 
 #endif /* _MSCC_PHY_H_ */
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 87ddae514627..5535901b9433 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1477,12 +1477,20 @@ static int vsc8584_config_init(struct phy_device *phydev)
 
 static irqreturn_t vsc8584_handle_interrupt(struct phy_device *phydev)
 {
+	irqreturn_t ret;
 	int irq_status;
 
 	irq_status = phy_read(phydev, MII_VSC85XX_INT_STATUS);
-	if (irq_status < 0 || !(irq_status & MII_VSC85XX_INT_MASK_MASK))
+	if (irq_status < 0)
 		return IRQ_NONE;
 
+	/* Timestamping IRQ does not set a bit in the global INT_STATUS, so
+	 * irq_status would be 0.
+	 */
+	ret = vsc8584_handle_ts_interrupt(phydev);
+	if (!(irq_status & MII_VSC85XX_INT_MASK_MASK))
+		return ret;
+
 	if (irq_status & MII_VSC85XX_INT_MASK_EXT)
 		vsc8584_handle_macsec_interrupt(phydev);
 
@@ -1922,6 +1930,7 @@ static int vsc85xx_config_intr(struct phy_device *phydev)
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
 		vsc8584_config_macsec_intr(phydev);
+		vsc8584_config_ts_intr(phydev);
 
 		rc = phy_write(phydev, MII_VSC85XX_INT_MASK,
 			       MII_VSC85XX_INT_MASK_MASK);
@@ -2035,8 +2044,8 @@ static int vsc8584_probe(struct phy_device *phydev)
 	phydev->priv = vsc8531;
 
 	vsc8584_get_base_addr(phydev);
-	devm_phy_package_join(&phydev->mdio.dev, phydev,
-			      vsc8531->base_addr, 0);
+	devm_phy_package_join(&phydev->mdio.dev, phydev, vsc8531->base_addr,
+			      sizeof(struct vsc85xx_shared_private));
 
 	vsc8531->nleds = 4;
 	vsc8531->supp_led_modes = VSC8584_SUPP_LED_MODES;
@@ -2047,6 +2056,12 @@ static int vsc8584_probe(struct phy_device *phydev)
 	if (!vsc8531->stats)
 		return -ENOMEM;
 
+	if (phy_package_probe_once(phydev)) {
+		ret = vsc8584_ptp_probe_once(phydev);
+		if (ret)
+			return ret;
+	}
+
 	ret = vsc8584_ptp_probe(phydev);
 	if (ret)
 		return ret;
diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index f964567fe662..194cc9a97e87 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -349,6 +349,148 @@ static int vsc85xx_ts_eth_cmp1_sig(struct phy_device *phydev)
 	return 0;
 }
 
+static struct vsc85xx_ptphdr *get_ptp_header_l4(struct sk_buff *skb,
+						struct iphdr *iphdr,
+						struct udphdr *udphdr)
+{
+	if (iphdr->version != 4 || iphdr->protocol != IPPROTO_UDP)
+		return NULL;
+
+	return (struct vsc85xx_ptphdr *)(((unsigned char *)udphdr) + UDP_HLEN);
+}
+
+static struct vsc85xx_ptphdr *get_ptp_header_tx(struct sk_buff *skb)
+{
+	struct ethhdr *ethhdr = eth_hdr(skb);
+	struct udphdr *udphdr;
+	struct iphdr *iphdr;
+
+	if (ethhdr->h_proto == htons(ETH_P_1588))
+		return (struct vsc85xx_ptphdr *)(((unsigned char *)ethhdr) +
+						 skb_mac_header_len(skb));
+
+	if (ethhdr->h_proto != htons(ETH_P_IP))
+		return NULL;
+
+	iphdr = ip_hdr(skb);
+	udphdr = udp_hdr(skb);
+
+	return get_ptp_header_l4(skb, iphdr, udphdr);
+}
+
+static struct vsc85xx_ptphdr *get_ptp_header_rx(struct sk_buff *skb,
+						enum hwtstamp_rx_filters rx_filter)
+{
+	struct udphdr *udphdr;
+	struct iphdr *iphdr;
+
+	if (rx_filter == HWTSTAMP_FILTER_PTP_V2_L2_EVENT)
+		return (struct vsc85xx_ptphdr *)skb->data;
+
+	iphdr = (struct iphdr *)skb->data;
+	udphdr = (struct udphdr *)(skb->data + iphdr->ihl * 4);
+
+	return get_ptp_header_l4(skb, iphdr, udphdr);
+}
+
+static int get_sig(struct sk_buff *skb, u8 *sig)
+{
+	struct vsc85xx_ptphdr *ptphdr = get_ptp_header_tx(skb);
+	struct ethhdr *ethhdr = eth_hdr(skb);
+	unsigned int i;
+
+	if (!ptphdr)
+		return -EOPNOTSUPP;
+
+	sig[0] = (__force u16)ptphdr->seq_id >> 8;
+	sig[1] = (__force u16)ptphdr->seq_id & GENMASK(7, 0);
+	sig[2] = ptphdr->domain;
+	sig[3] = ptphdr->tsmt & GENMASK(3, 0);
+
+	memcpy(&sig[4], ethhdr->h_dest, ETH_ALEN);
+
+	/* Fill the last bytes of the signature to reach a 16B signature */
+	for (i = 10; i < 16; i++)
+		sig[i] = ptphdr->tsmt & GENMASK(3, 0);
+
+	return 0;
+}
+
+static void vsc85xx_dequeue_skb(struct vsc85xx_ptp *ptp)
+{
+	struct skb_shared_hwtstamps shhwtstamps;
+	struct vsc85xx_ts_fifo fifo;
+	struct sk_buff *skb;
+	u8 skb_sig[16], *p;
+	int i, len;
+	u32 reg;
+
+	memset(&fifo, 0, sizeof(fifo));
+	p = (u8 *)&fifo;
+
+	reg = vsc85xx_ts_read_csr(ptp->phydev, PROCESSOR,
+				  MSCC_PHY_PTP_EGR_TS_FIFO(0));
+	if (reg & PTP_EGR_TS_FIFO_EMPTY)
+		return;
+
+	*p++ = reg & 0xff;
+	*p++ = (reg >> 8) & 0xff;
+
+	/* Read the current FIFO item. Reading FIFO6 pops the next one. */
+	for (i = 1; i < 7; i++) {
+		reg = vsc85xx_ts_read_csr(ptp->phydev, PROCESSOR,
+					  MSCC_PHY_PTP_EGR_TS_FIFO(i));
+		*p++ = reg & 0xff;
+		*p++ = (reg >> 8) & 0xff;
+		*p++ = (reg >> 16) & 0xff;
+		*p++ = (reg >> 24) & 0xff;
+	}
+
+	len = skb_queue_len(&ptp->tx_queue);
+	if (len < 1)
+		return;
+
+	while (len--) {
+		skb = __skb_dequeue(&ptp->tx_queue);
+		if (!skb)
+			return;
+
+		/* Can't get the signature of the packet, won't ever
+		 * be able to have one so let's dequeue the packet.
+		 */
+		if (get_sig(skb, skb_sig) < 0)
+			continue;
+
+		/* Check if we found the signature we were looking for. */
+		if (!memcmp(skb_sig, fifo.sig, sizeof(fifo.sig))) {
+			memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+			shhwtstamps.hwtstamp = ktime_set(fifo.secs, fifo.ns);
+			skb_complete_tx_timestamp(skb, &shhwtstamps);
+
+			return;
+		}
+
+		/* Valid signature but does not match the one of the
+		 * packet in the FIFO right now, reschedule it for later
+		 * packets.
+		 */
+		__skb_queue_tail(&ptp->tx_queue, skb);
+	}
+}
+
+static void vsc85xx_get_tx_ts(struct vsc85xx_ptp *ptp)
+{
+	u32 reg;
+
+	do {
+		vsc85xx_dequeue_skb(ptp);
+
+		/* If other timestamps are available in the FIFO, process them. */
+		reg = vsc85xx_ts_read_csr(ptp->phydev, PROCESSOR,
+					  MSCC_PHY_PTP_EGR_TS_FIFO_CTRL);
+	} while (PTP_EGR_FIFO_LEVEL_LAST_READ(reg) > 1);
+}
+
 static int vsc85xx_ptp_cmp_init(struct phy_device *phydev, enum ts_blk blk)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
@@ -454,6 +596,176 @@ static int vsc85xx_ip_cmp1_init(struct phy_device *phydev, enum ts_blk blk)
 	return 0;
 }
 
+static int vsc85xx_adjfine(struct ptp_clock_info *info, long scaled_ppm)
+{
+	struct vsc85xx_ptp *ptp = container_of(info, struct vsc85xx_ptp, caps);
+	struct phy_device *phydev = ptp->phydev;
+	struct vsc8531_private *priv = phydev->priv;
+	u64 adj = 0;
+	u32 val;
+
+	if (abs(scaled_ppm) < 66 || abs(scaled_ppm) > 65536UL * 1000000UL)
+		return 0;
+
+	adj = div64_u64(1000000ULL * 65536ULL, abs(scaled_ppm));
+	if (adj > 1000000000L)
+		adj = 1000000000L;
+
+	val = PTP_AUTO_ADJ_NS_ROLLOVER(adj);
+	val |= scaled_ppm > 0 ? PTP_AUTO_ADJ_ADD_1NS : PTP_AUTO_ADJ_SUB_1NS;
+
+	mutex_lock(&priv->phc_lock);
+
+	/* Update the ppb val in nano seconds to the auto adjust reg. */
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_AUTO_ADJ,
+			     val);
+
+	/* The auto adjust update val is set to 0 after write operation. */
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_CTRL);
+	val |= PTP_LTC_CTRL_AUTO_ADJ_UPDATE;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_CTRL, val);
+
+	mutex_unlock(&priv->phc_lock);
+
+	return 0;
+}
+
+static int __vsc85xx_gettime(struct ptp_clock_info *info, struct timespec64 *ts)
+{
+	struct vsc85xx_ptp *ptp = container_of(info, struct vsc85xx_ptp, caps);
+	struct phy_device *phydev = ptp->phydev;
+	struct vsc85xx_shared_private *shared =
+		(struct vsc85xx_shared_private *)phydev->shared->priv;
+	struct vsc8531_private *priv = phydev->priv;
+	u32 val;
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_CTRL);
+	val |= PTP_LTC_CTRL_SAVE_ENA;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_CTRL, val);
+
+	/* Local Time Counter (LTC) is put in SAVE* regs on rising edge of
+	 * LOAD_SAVE pin.
+	 */
+	mutex_lock(&shared->gpio_lock);
+	gpiod_set_value(priv->load_save, 1);
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_LTC_SAVED_SEC_MSB);
+
+	ts->tv_sec = ((time64_t)val) << 32;
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_LTC_SAVED_SEC_LSB);
+	ts->tv_sec += val;
+
+	ts->tv_nsec = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+					  MSCC_PHY_PTP_LTC_SAVED_NS);
+
+	gpiod_set_value(priv->load_save, 0);
+	mutex_unlock(&shared->gpio_lock);
+
+	return 0;
+}
+
+static int vsc85xx_gettime(struct ptp_clock_info *info, struct timespec64 *ts)
+{
+	struct vsc85xx_ptp *ptp = container_of(info, struct vsc85xx_ptp, caps);
+	struct phy_device *phydev = ptp->phydev;
+	struct vsc8531_private *priv = phydev->priv;
+
+	mutex_lock(&priv->phc_lock);
+	__vsc85xx_gettime(info, ts);
+	mutex_unlock(&priv->phc_lock);
+
+	return 0;
+}
+
+static int __vsc85xx_settime(struct ptp_clock_info *info,
+			     const struct timespec64 *ts)
+{
+	struct vsc85xx_ptp *ptp = container_of(info, struct vsc85xx_ptp, caps);
+	struct phy_device *phydev = ptp->phydev;
+	struct vsc85xx_shared_private *shared =
+		(struct vsc85xx_shared_private *)phydev->shared->priv;
+	struct vsc8531_private *priv = phydev->priv;
+	u32 val;
+
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_LOAD_SEC_MSB,
+			     PTP_LTC_LOAD_SEC_MSB(ts->tv_sec));
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_LOAD_SEC_LSB,
+			     PTP_LTC_LOAD_SEC_LSB(ts->tv_sec));
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_LOAD_NS,
+			     PTP_LTC_LOAD_NS(ts->tv_nsec));
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_CTRL);
+	val |= PTP_LTC_CTRL_LOAD_ENA;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_CTRL, val);
+
+	/* Local Time Counter (LTC) is set from LOAD* regs on rising edge of
+	 * LOAD_SAVE pin.
+	 */
+	mutex_lock(&shared->gpio_lock);
+	gpiod_set_value(priv->load_save, 1);
+
+	val &= ~PTP_LTC_CTRL_LOAD_ENA;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_CTRL, val);
+
+	gpiod_set_value(priv->load_save, 0);
+	mutex_unlock(&shared->gpio_lock);
+
+	return 0;
+}
+
+static int vsc85xx_settime(struct ptp_clock_info *info,
+			   const struct timespec64 *ts)
+{
+	struct vsc85xx_ptp *ptp = container_of(info, struct vsc85xx_ptp, caps);
+	struct phy_device *phydev = ptp->phydev;
+	struct vsc8531_private *priv = phydev->priv;
+
+	mutex_lock(&priv->phc_lock);
+	__vsc85xx_settime(info, ts);
+	mutex_unlock(&priv->phc_lock);
+
+	return 0;
+}
+
+static int vsc85xx_adjtime(struct ptp_clock_info *info, s64 delta)
+{
+	struct vsc85xx_ptp *ptp = container_of(info, struct vsc85xx_ptp, caps);
+	struct phy_device *phydev = ptp->phydev;
+	struct vsc8531_private *priv = phydev->priv;
+	u32 val;
+
+	/* Can't recover that big of an offset. Let's set the time directly. */
+	if (abs(delta) >= NSEC_PER_SEC) {
+		struct timespec64 ts;
+		u64 now;
+
+		mutex_lock(&priv->phc_lock);
+
+		__vsc85xx_gettime(info, &ts);
+		now = ktime_to_ns(timespec64_to_ktime(ts));
+		ts = ns_to_timespec64(now + delta);
+		__vsc85xx_settime(info, &ts);
+
+		mutex_unlock(&priv->phc_lock);
+
+		return 0;
+	}
+
+	mutex_lock(&priv->phc_lock);
+
+	val = PTP_LTC_OFFSET_VAL(abs(delta)) | PTP_LTC_OFFSET_ADJ;
+	if (delta > 0)
+		val |= PTP_LTC_OFFSET_ADD;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_OFFSET, val);
+
+	mutex_unlock(&priv->phc_lock);
+
+	return 0;
+}
+
 static int vsc85xx_eth1_next_comp(struct phy_device *phydev, enum ts_blk blk,
 				  u32 next_comp, u32 etype)
 {
@@ -722,6 +1034,196 @@ static void vsc85xx_ts_reset_fifo(struct phy_device *phydev)
 			     val);
 }
 
+static int vsc85xx_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
+{
+	struct vsc8531_private *vsc8531 =
+		container_of(mii_ts, struct vsc8531_private, mii_ts);
+	struct phy_device *phydev = vsc8531->ptp->phydev;
+	struct hwtstamp_config cfg;
+	bool one_step = false;
+	u32 val;
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	if (cfg.flags)
+		return -EINVAL;
+
+	switch (cfg.tx_type) {
+	case HWTSTAMP_TX_ONESTEP_SYNC:
+		one_step = true;
+		break;
+	case HWTSTAMP_TX_ON:
+		break;
+	case HWTSTAMP_TX_OFF:
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	vsc8531->ptp->tx_type = cfg.tx_type;
+
+	switch (cfg.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+		/* ETH->IP->UDP->PTP */
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+		/* ETH->PTP */
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	vsc8531->ptp->rx_filter = cfg.rx_filter;
+
+	mutex_lock(&vsc8531->ts_lock);
+
+	__skb_queue_purge(&vsc8531->ptp->tx_queue);
+	__skb_queue_head_init(&vsc8531->ptp->tx_queue);
+
+	/* Disable predictor while configuring the 1588 block */
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_INGR_PREDICTOR);
+	val &= ~PTP_INGR_PREDICTOR_EN;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_INGR_PREDICTOR,
+			     val);
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_EGR_PREDICTOR);
+	val &= ~PTP_EGR_PREDICTOR_EN;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_PREDICTOR,
+			     val);
+
+	/* Bypass egress or ingress blocks if timestamping isn't used */
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR, MSCC_PHY_PTP_IFACE_CTRL);
+	val &= ~(PTP_IFACE_CTRL_EGR_BYPASS | PTP_IFACE_CTRL_INGR_BYPASS);
+	if (vsc8531->ptp->tx_type == HWTSTAMP_TX_OFF)
+		val |= PTP_IFACE_CTRL_EGR_BYPASS;
+	if (vsc8531->ptp->rx_filter == HWTSTAMP_FILTER_NONE)
+		val |= PTP_IFACE_CTRL_INGR_BYPASS;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_IFACE_CTRL, val);
+
+	/* Resetting FIFO so that it's empty after reconfiguration */
+	vsc85xx_ts_reset_fifo(phydev);
+
+	vsc85xx_ts_engine_init(phydev, one_step);
+
+	/* Re-enable predictors now */
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_INGR_PREDICTOR);
+	val |= PTP_INGR_PREDICTOR_EN;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_INGR_PREDICTOR,
+			     val);
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_EGR_PREDICTOR);
+	val |= PTP_EGR_PREDICTOR_EN;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_PREDICTOR,
+			     val);
+
+	vsc8531->ptp->configured = 1;
+	mutex_unlock(&vsc8531->ts_lock);
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+static int vsc85xx_ts_info(struct mii_timestamper *mii_ts,
+			   struct ethtool_ts_info *info)
+{
+	struct vsc8531_private *vsc8531 =
+		container_of(mii_ts, struct vsc8531_private, mii_ts);
+
+	info->phc_index = ptp_clock_index(vsc8531->ptp->ptp_clock);
+	info->so_timestamping =
+		SOF_TIMESTAMPING_TX_HARDWARE |
+		SOF_TIMESTAMPING_RX_HARDWARE |
+		SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->tx_types =
+		(1 << HWTSTAMP_TX_OFF) |
+		(1 << HWTSTAMP_TX_ON) |
+		(1 << HWTSTAMP_TX_ONESTEP_SYNC);
+	info->rx_filters =
+		(1 << HWTSTAMP_FILTER_NONE) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L4_EVENT);
+
+	return 0;
+}
+
+static void vsc85xx_txtstamp(struct mii_timestamper *mii_ts,
+			     struct sk_buff *skb, int type)
+{
+	struct vsc8531_private *vsc8531 =
+		container_of(mii_ts, struct vsc8531_private, mii_ts);
+
+	if (!vsc8531->ptp->configured)
+		return;
+
+	if (vsc8531->ptp->tx_type == HWTSTAMP_TX_OFF) {
+		kfree_skb(skb);
+		return;
+	}
+
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
+	mutex_lock(&vsc8531->ts_lock);
+	__skb_queue_tail(&vsc8531->ptp->tx_queue, skb);
+	mutex_unlock(&vsc8531->ts_lock);
+}
+
+static bool vsc85xx_rxtstamp(struct mii_timestamper *mii_ts,
+			     struct sk_buff *skb, int type)
+{
+	struct vsc8531_private *vsc8531 =
+		container_of(mii_ts, struct vsc8531_private, mii_ts);
+	struct skb_shared_hwtstamps *shhwtstamps = NULL;
+	struct vsc85xx_ptphdr *ptphdr;
+	struct timespec64 ts;
+	unsigned long ns;
+
+	if (!vsc8531->ptp->configured)
+		return false;
+
+	if (vsc8531->ptp->rx_filter == HWTSTAMP_FILTER_NONE ||
+	    type == PTP_CLASS_NONE)
+		return false;
+
+	vsc85xx_gettime(&vsc8531->ptp->caps, &ts);
+
+	ptphdr = get_ptp_header_rx(skb, vsc8531->ptp->rx_filter);
+	if (!ptphdr)
+		return false;
+
+	shhwtstamps = skb_hwtstamps(skb);
+	memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
+
+	ns = ntohl(ptphdr->rsrvd2);
+
+	/* nsec is in reserved field */
+	if (ts.tv_nsec < ns)
+		ts.tv_sec--;
+
+	shhwtstamps->hwtstamp = ktime_set(ts.tv_sec, ns);
+	netif_rx_ni(skb);
+
+	return true;
+}
+
+static const struct ptp_clock_info vsc85xx_clk_caps = {
+	.owner		= THIS_MODULE,
+	.name		= "VSC85xx timer",
+	.max_adj	= S32_MAX,
+	.n_alarm	= 0,
+	.n_pins		= 0,
+	.n_ext_ts	= 0,
+	.n_per_out	= 0,
+	.pps		= 0,
+	.adjtime        = &vsc85xx_adjtime,
+	.adjfine	= &vsc85xx_adjfine,
+	.gettime64	= &vsc85xx_gettime,
+	.settime64	= &vsc85xx_settime,
+};
+
 static bool vsc8584_is_1588_input_clk_configured(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
@@ -754,6 +1256,7 @@ static void vsc8584_set_input_clk_configured(struct phy_device *phydev)
 
 static int __vsc8584_init_ptp(struct phy_device *phydev)
 {
+	struct vsc8531_private *vsc8531 = phydev->priv;
 	u32 ltc_seq_e[] = { 0, 400000, 0, 0, 0 };
 	u8  ltc_seq_a[] = { 8, 6, 5, 4, 2 };
 	u32 val;
@@ -970,9 +1473,32 @@ static int __vsc8584_init_ptp(struct phy_device *phydev)
 
 	vsc85xx_ts_eth_cmp1_sig(phydev);
 
+	vsc8531->mii_ts.rxtstamp = vsc85xx_rxtstamp;
+	vsc8531->mii_ts.txtstamp = vsc85xx_txtstamp;
+	vsc8531->mii_ts.hwtstamp = vsc85xx_hwtstamp;
+	vsc8531->mii_ts.ts_info  = vsc85xx_ts_info;
+	phydev->mii_ts = &vsc8531->mii_ts;
+
+	memcpy(&vsc8531->ptp->caps, &vsc85xx_clk_caps, sizeof(vsc85xx_clk_caps));
+
+	vsc8531->ptp->ptp_clock = ptp_clock_register(&vsc8531->ptp->caps,
+						     &phydev->mdio.dev);
+	if (IS_ERR(vsc8531->ptp->ptp_clock))
+		return PTR_ERR(vsc8531->ptp->ptp_clock);
+
 	return 0;
 }
 
+void vsc8584_config_ts_intr(struct phy_device *phydev)
+{
+	struct vsc8531_private *priv = phydev->priv;
+
+	mutex_lock(&priv->ts_lock);
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_1588_VSC85XX_INT_MASK,
+			     VSC85XX_1588_INT_MASK_MASK);
+	mutex_unlock(&priv->ts_lock);
+}
+
 int vsc8584_ptp_init(struct phy_device *phydev)
 {
 	struct vsc8531_private *priv = phydev->priv;
@@ -990,6 +1516,34 @@ int vsc8584_ptp_init(struct phy_device *phydev)
 	return ret;
 }
 
+irqreturn_t vsc8584_handle_ts_interrupt(struct phy_device *phydev)
+{
+	struct vsc8531_private *priv = phydev->priv;
+	int rc;
+
+	mutex_lock(&priv->ts_lock);
+	rc = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				 MSCC_PHY_1588_VSC85XX_INT_STATUS);
+	/* Ack the PTP interrupt */
+	vsc85xx_ts_write_csr(phydev, PROCESSOR,
+			     MSCC_PHY_1588_VSC85XX_INT_STATUS, rc);
+
+	if (!(rc & VSC85XX_1588_INT_MASK_MASK)) {
+		mutex_unlock(&priv->ts_lock);
+		return IRQ_NONE;
+	}
+
+	if (rc & VSC85XX_1588_INT_FIFO_ADD) {
+		vsc85xx_get_tx_ts(priv->ptp);
+	} else if (rc & VSC85XX_1588_INT_FIFO_OVERFLOW) {
+		__skb_queue_purge(&priv->ptp->tx_queue);
+		vsc85xx_ts_reset_fifo(phydev);
+	}
+
+	mutex_unlock(&priv->ts_lock);
+	return IRQ_HANDLED;
+}
+
 int vsc8584_ptp_probe(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
@@ -999,9 +1553,35 @@ int vsc8584_ptp_probe(struct phy_device *phydev)
 	if (!vsc8531->ptp)
 		return -ENOMEM;
 
+	mutex_init(&vsc8531->phc_lock);
 	mutex_init(&vsc8531->ts_lock);
 
+	/* Retrieve the shared load/save GPIO. Request it as non exclusive as
+	 * the same GPIO can be requested by all the PHYs of the same package.
+	 * Ths GPIO must be used with the phc_lock taken (the lock is shared
+	 * between all PHYs).
+	 */
+	vsc8531->load_save = devm_gpiod_get_optional(&phydev->mdio.dev, "load-save",
+						     GPIOD_FLAGS_BIT_NONEXCLUSIVE |
+						     GPIOD_OUT_LOW);
+	if (IS_ERR(vsc8531->load_save)) {
+		phydev_err(phydev, "Can't get load-save GPIO (%ld)\n",
+			   PTR_ERR(vsc8531->load_save));
+		return PTR_ERR(vsc8531->load_save);
+	}
+
 	vsc8531->ptp->phydev = phydev;
 
 	return 0;
 }
+
+int vsc8584_ptp_probe_once(struct phy_device *phydev)
+{
+	struct vsc85xx_shared_private *shared =
+		(struct vsc85xx_shared_private *)phydev->shared->priv;
+
+	/* Initialize shared GPIO lock */
+	mutex_init(&shared->gpio_lock);
+
+	return 0;
+}
-- 
2.26.2

