Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38A925D260
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 09:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbgIDH3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 03:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729723AbgIDH3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 03:29:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C8CC061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 00:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ONFz0rjEqaWAVTA6vKVqfqvf3kgaMcT+bjAUReIEFlE=; b=XMRG9AMSacG+2hjqegeZtvWyON
        F7XBiCc8hFzCPGtpAu3W/OM4v+HPQzvo/Fw0LKgve+JLG6cCkcMN/e4wirVT+x3+w+nsj2SYcbBcI
        zUylNRtdEDWEciSf6h7Wsb+PI9cEkpU/DeNuvF5X9943FqkGcwql3y9eeWt47Z9ogWVANbwL/xIxb
        WbWszr8enukkABLMVcCSOsIFgrTDkwXzl+SnC+QuI/rGXUf1mYwabw4xaydgOdbGj+Tp7n8UhsIfS
        T3pJMY1JIwyORTNKn7f/XwIvnjFgfp8EKKn2GMM6aaocTpLNEVwKwCbH+HANhZ8WdJKsyLsGBzGe9
        /ZF6pMhQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57912 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kE6A8-0007PS-K4; Fri, 04 Sep 2020 08:29:32 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kE6A8-00057x-Cu; Fri, 04 Sep 2020 08:29:32 +0100
In-Reply-To: <20200904072828.GQ1551@shell.armlinux.org.uk>
References: <20200904072828.GQ1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 5/6] net: mvpp2: ptp: add support for receive
 timestamping
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kE6A8-00057x-Cu@rmk-PC.armlinux.org.uk>
Date:   Fri, 04 Sep 2020 08:29:32 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for receive timestamping. When enabled, the hardware adds
a timestamp into the receive queue descriptor for all received packets
with no filtering. Hence, we can only support NONE or ALL receive
filter modes.

The timestamp in the receive queue contains two bit sof seconds and
the full nanosecond timestamp. This has to be merged with the remainder
of the seconds from the TAI clock to arrive at a full timestamp before
we can convert it to a ktime for the skb hardware timestamp field.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  31 ++++-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 108 +++++++++++++++++-
 .../net/ethernet/marvell/mvpp2/mvpp2_tai.c    |  53 ++++++++-
 3 files changed, 189 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index b9fae3870393..75467411900e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -600,6 +600,9 @@
 #define MVPP22_PTP_INT_CAUSE			0x00
 #define MVPP22_PTP_INT_MASK			0x04
 #define MVPP22_PTP_GCR				0x08
+#define     MVPP22_PTP_GCR_RX_RESET		BIT(13)
+#define     MVPP22_PTP_GCR_TX_RESET		BIT(1)
+#define     MVPP22_PTP_GCR_TSU_ENABLE		BIT(0)
 #define MVPP22_PTP_TX_Q0_R0			0x0c
 #define MVPP22_PTP_TX_Q0_R1			0x10
 #define MVPP22_PTP_TX_Q0_R2			0x14
@@ -1094,6 +1097,9 @@ struct mvpp2_port {
 	 * them from 0
 	 */
 	int rss_ctx[MVPP22_N_RSS_TABLES];
+
+	bool hwtstamp;
+	bool rx_hwtstamp;
 };
 
 /* The mvpp2_tx_desc and mvpp2_rx_desc structures describe the
@@ -1173,7 +1179,7 @@ struct mvpp22_rx_desc {
 	__le16 reserved1;
 	__le16 data_size;
 	__le32 reserved2;
-	__le32 reserved3;
+	__le32 timestamp;
 	__le64 buf_dma_addr_key_hash;
 	__le64 buf_cookie_misc;
 };
@@ -1355,11 +1361,34 @@ void mvpp2_dbgfs_cleanup(struct mvpp2 *priv);
 
 #ifdef CONFIG_MVPP2_PTP
 int mvpp22_tai_probe(struct device *dev, struct mvpp2 *priv);
+void mvpp22_tai_tstamp(struct mvpp2_tai *tai, u32 tstamp,
+		       struct skb_shared_hwtstamps *hwtstamp);
+void mvpp22_tai_start(struct mvpp2_tai *tai);
+void mvpp22_tai_stop(struct mvpp2_tai *tai);
+int mvpp22_tai_ptp_clock_index(struct mvpp2_tai *tai);
 #else
 static inline int mvpp22_tai_probe(struct device *dev, struct mvpp2 *priv)
 {
 	return 0;
 }
+static inline void mvpp22_tai_tstamp(struct mvpp2_tai *tai, u32 tstamp,
+				     struct skb_shared_hwtstamps *hwtstamp)
+{
+}
+static inline void mvpp22_tai_start(struct mvpp2_tai *tai)
+{
+}
+static inline void mvpp22_tai_stop(struct mvpp2_tai *tai)
+{
+}
+static inline int mvpp22_tai_ptp_clock_index(struct mvpp2_tai *tai)
+{
+	return -1;
+}
 #endif
 
+static inline bool mvpp22_rx_hwtstamping(struct mvpp2_port *port)
+{
+	return IS_ENABLED(CONFIG_MVPP2_PTP) && port->rx_hwtstamp;
+}
 #endif
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d064e4b20df0..c20fde0fc73c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3449,7 +3449,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		unsigned int frag_size;
 		dma_addr_t dma_addr;
 		phys_addr_t phys_addr;
-		u32 rx_status;
+		u32 rx_status, timestamp;
 		int pool, rx_bytes, err, ret;
 		void *data;
 
@@ -3527,6 +3527,15 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			goto err_drop_frame;
 		}
 
+		/* If we have RX hardware timestamping enabled, grab the
+		 * timestamp from the queue and convert.
+		 */
+		if (mvpp22_rx_hwtstamping(port)) {
+			timestamp = le32_to_cpu(rx_desc->pp22.timestamp);
+			mvpp22_tai_tstamp(port->priv->tai, timestamp,
+					 skb_hwtstamps(skb));
+		}
+
 		err = mvpp2_rx_refill(port, bm_pool, pp, pool);
 		if (err) {
 			netdev_err(port->dev, "failed to refill BM pools\n");
@@ -4561,10 +4570,100 @@ mvpp2_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->tx_dropped	= dev->stats.tx_dropped;
 }
 
+static int mvpp2_set_ts_config(struct mvpp2_port *port, struct ifreq *ifr)
+{
+	struct hwtstamp_config config;
+	void __iomem *ptp;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	if (config.flags)
+		return -EINVAL;
+
+	if (config.tx_type != HWTSTAMP_TX_OFF)
+		return -ERANGE;
+
+	ptp = port->priv->iface_base + MVPP22_PTP_BASE(port->gop_id);
+	if (config.rx_filter != HWTSTAMP_FILTER_NONE) {
+		config.rx_filter = HWTSTAMP_FILTER_ALL;
+		mvpp22_tai_start(port->priv->tai);
+		mvpp2_modify(ptp + MVPP22_PTP_GCR,
+			     MVPP22_PTP_GCR_RX_RESET |
+			     MVPP22_PTP_GCR_TX_RESET |
+			     MVPP22_PTP_GCR_TSU_ENABLE,
+			     MVPP22_PTP_GCR_RX_RESET |
+			     MVPP22_PTP_GCR_TX_RESET |
+			     MVPP22_PTP_GCR_TSU_ENABLE);
+		port->rx_hwtstamp = true;
+	} else {
+		port->rx_hwtstamp = false;
+		mvpp2_modify(ptp + MVPP22_PTP_GCR,
+			     MVPP22_PTP_GCR_RX_RESET |
+			     MVPP22_PTP_GCR_TX_RESET |
+			     MVPP22_PTP_GCR_TSU_ENABLE, 0);
+		mvpp22_tai_stop(port->priv->tai);
+	}
+
+	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int mvpp2_get_ts_config(struct mvpp2_port *port, struct ifreq *ifr)
+{
+	struct hwtstamp_config config;
+
+	memset(&config, 0, sizeof(config));
+
+	config.tx_type = HWTSTAMP_TX_OFF;
+	config.rx_filter = port->rx_hwtstamp ?
+		HWTSTAMP_FILTER_ALL : HWTSTAMP_FILTER_NONE;
+
+	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int mvpp2_ethtool_get_ts_info(struct net_device *dev,
+				     struct ethtool_ts_info *info)
+{
+	struct mvpp2_port *port = netdev_priv(dev);
+
+	if (!port->hwtstamp)
+		return -EOPNOTSUPP;
+
+	info->phc_index = mvpp22_tai_ptp_clock_index(port->priv->tai);
+	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
+				SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->tx_types = BIT(HWTSTAMP_TX_OFF);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_ALL);
+
+	return 0;
+}
+
 static int mvpp2_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
 
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		if (port->hwtstamp)
+			return mvpp2_set_ts_config(port, ifr);
+		break;
+
+	case SIOCGHWTSTAMP:
+		if (port->hwtstamp)
+			return mvpp2_get_ts_config(port, ifr);
+		break;
+	}
+
 	if (!port->phylink)
 		return -ENOTSUPP;
 
@@ -5034,6 +5133,7 @@ static const struct ethtool_ops mvpp2_eth_tool_ops = {
 				     ETHTOOL_COALESCE_MAX_FRAMES,
 	.nway_reset		= mvpp2_ethtool_nway_reset,
 	.get_link		= ethtool_op_get_link,
+	.get_ts_info		= mvpp2_ethtool_get_ts_info,
 	.set_coalesce		= mvpp2_ethtool_set_coalesce,
 	.get_coalesce		= mvpp2_ethtool_get_coalesce,
 	.get_drvinfo		= mvpp2_ethtool_get_drvinfo,
@@ -6112,6 +6212,12 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		port->stats_base = port->priv->iface_base +
 				   MVPP22_MIB_COUNTERS_OFFSET +
 				   port->gop_id * MVPP22_MIB_COUNTERS_PORT_SZ;
+
+		/* We may want a property to describe whether we should use
+		 * MAC hardware timestamping.
+		 */
+		if (priv->tai)
+			port->hwtstamp = true;
 	}
 
 	/* Alloc per-cpu and ethtool stats */
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
index d6bc5d3f6110..1b88aad21377 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
@@ -59,6 +59,8 @@ struct mvpp2_tai {
 	void __iomem *base;
 	spinlock_t lock;
 	u64 period;		// nanosecond period in 32.32 fixed point
+	/* This timestamp is updated every two seconds */
+	struct timespec64 stamp;
 };
 
 static void mvpp2_tai_modify(void __iomem *reg, u32 mask, u32 set)
@@ -299,7 +301,11 @@ static int mvpp22_tai_settime64(struct ptp_clock_info *ptp,
 
 static long mvpp22_tai_aux_work(struct ptp_clock_info *ptp)
 {
-	return 0;
+	struct mvpp2_tai *tai = ptp_to_tai(ptp);
+
+	mvpp22_tai_gettimex64(ptp, &tai->stamp, NULL);
+
+	return msecs_to_jiffies(2000);
 }
 
 static void mvpp22_tai_set_step(struct mvpp2_tai *tai)
@@ -341,6 +347,51 @@ static void mvpp22_tai_init(struct mvpp2_tai *tai)
 	mvpp22_tai_set_tod(tai);
 }
 
+int mvpp22_tai_ptp_clock_index(struct mvpp2_tai *tai)
+{
+	return ptp_clock_index(tai->ptp_clock);
+}
+
+void mvpp22_tai_tstamp(struct mvpp2_tai *tai, u32 tstamp,
+		       struct skb_shared_hwtstamps *hwtstamp)
+{
+	struct timespec64 ts;
+	int delta;
+
+	/* The tstamp consists of 2 bits of seconds and 30 bits of nanoseconds.
+	 * We use our stored timestamp (tai->stamp) to form a full timestamp,
+	 * and we must read the seconds exactly once.
+	 */
+	ts.tv_sec = READ_ONCE(tai->stamp.tv_sec);
+	ts.tv_nsec = tstamp & 0x3fffffff;
+
+	/* Calculate the delta in seconds between our stored timestamp and
+	 * the value read from the queue. Allow timestamps one second in the
+	 * past, otherwise consider them to be in the future.
+	 */
+	delta = ((tstamp >> 30) - (ts.tv_sec & 3)) & 3;
+	if (delta == 3)
+		delta -= 4;
+	ts.tv_sec += delta;
+
+	memset(hwtstamp, 0, sizeof(*hwtstamp));
+	hwtstamp->hwtstamp = timespec64_to_ktime(ts);
+}
+
+void mvpp22_tai_start(struct mvpp2_tai *tai)
+{
+	long delay;
+
+	delay = mvpp22_tai_aux_work(&tai->caps);
+
+	ptp_schedule_worker(tai->ptp_clock, delay);
+}
+
+void mvpp22_tai_stop(struct mvpp2_tai *tai)
+{
+	ptp_cancel_worker_sync(tai->ptp_clock);
+}
+
 static void mvpp22_tai_remove(void *priv)
 {
 	struct mvpp2_tai *tai = priv;
-- 
2.20.1

