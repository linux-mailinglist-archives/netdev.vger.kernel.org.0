Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3C65FC0A6
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 08:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiJLG1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 02:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJLG1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 02:27:08 -0400
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA32A99F7;
        Tue, 11 Oct 2022 23:27:04 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc4a.ko.seznam.cz (email-smtpc4a.ko.seznam.cz [10.53.10.105])
        id 7c01835098ad506e7ddc223e;
        Wed, 12 Oct 2022 08:26:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1665555984; bh=98DBbaUD2tbu2p0jdOeUnTXHiyslyKp7JHTgfwzhykw=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding;
        b=X/5JSB5KsizdKDpcZn5yJnFHK6CB4oKAb4Cfsnn3jf8mSgQtdEsPkNuwNQ9xCN93M
         I8dRpP7YPZ6xEks34106+C2N93skBGjyCt8F5s5N+VHT5/JGkKOLBXUjaBFKIku4k2
         66P+pgVBu2sVkBBznQRqXqr9mswF+YlbGlhKSwbQ=
Received: from localhost.localdomain (2a02:8308:900d:2400:bba2:4592:a1de:fd80 [2a02:8308:900d:2400:bba2:4592:a1de:fd80])
        by email-relay16.ko.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Wed, 12 Oct 2022 08:26:20 +0200 (CEST)  
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Matej Vasilevski <matej.vasilevski@seznam.cz>
Subject: [PATCH v5 2/4] can: ctucanfd: add HW timestamps to RX and error CAN frames
Date:   Wed, 12 Oct 2022 08:25:56 +0200
Message-Id: <20221012062558.732930-3-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221012062558.732930-1-matej.vasilevski@seznam.cz>
References: <20221012062558.732930-1-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for retrieving hardware timestamps to RX and
error CAN frames. It uses timecounter and cyclecounter structures,
because the timestamping counter width depends on the IP core integration
(it might not always be 64-bit).
For platform devices, you should specify "ts" clock in device tree.
For PCI devices, the timestamping frequency is assumed to be the same
as bus frequency.

Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
---
 drivers/net/can/ctucanfd/Kconfig              |   2 +-
 drivers/net/can/ctucanfd/Makefile             |   2 +-
 drivers/net/can/ctucanfd/ctucanfd.h           |  21 ++
 drivers/net/can/ctucanfd/ctucanfd_base.c      | 229 +++++++++++++++++-
 drivers/net/can/ctucanfd/ctucanfd_pci.c       |   7 +-
 drivers/net/can/ctucanfd/ctucanfd_platform.c  |   7 +-
 drivers/net/can/ctucanfd/ctucanfd_timestamp.c |  77 ++++++
 7 files changed, 333 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c

diff --git a/drivers/net/can/ctucanfd/Kconfig b/drivers/net/can/ctucanfd/Kconfig
index 6e2073351a8f..acd38e07146a 100644
--- a/drivers/net/can/ctucanfd/Kconfig
+++ b/drivers/net/can/ctucanfd/Kconfig
@@ -23,7 +23,7 @@ config CAN_CTUCANFD_PCI
 
 config CAN_CTUCANFD_PLATFORM
 	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
-	depends on HAS_IOMEM && (OF || COMPILE_TEST)
+	depends on HAS_IOMEM && (OF || COMPILE_TEST) && PM
 	select CAN_CTUCANFD
 	help
 	  The core has been tested together with OpenCores SJA1000
diff --git a/drivers/net/can/ctucanfd/Makefile b/drivers/net/can/ctucanfd/Makefile
index 8078f1f2c30f..a36e66f2cea7 100644
--- a/drivers/net/can/ctucanfd/Makefile
+++ b/drivers/net/can/ctucanfd/Makefile
@@ -4,7 +4,7 @@
 #
 
 obj-$(CONFIG_CAN_CTUCANFD) := ctucanfd.o
-ctucanfd-y := ctucanfd_base.o
+ctucanfd-y := ctucanfd_base.o ctucanfd_timestamp.o
 
 obj-$(CONFIG_CAN_CTUCANFD_PCI) += ctucanfd_pci.o
 obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) += ctucanfd_platform.o
diff --git a/drivers/net/can/ctucanfd/ctucanfd.h b/drivers/net/can/ctucanfd/ctucanfd.h
index 0e9904f6a05d..cf4d8cc5349e 100644
--- a/drivers/net/can/ctucanfd/ctucanfd.h
+++ b/drivers/net/can/ctucanfd/ctucanfd.h
@@ -23,6 +23,10 @@
 #include <linux/netdevice.h>
 #include <linux/can/dev.h>
 #include <linux/list.h>
+#include <linux/timecounter.h>
+#include <linux/workqueue.h>
+
+#define CTUCANFD_MAX_WORK_DELAY_SEC 3600U
 
 enum ctu_can_fd_can_registers;
 
@@ -51,6 +55,15 @@ struct ctucan_priv {
 	u32 rxfrm_first_word;
 
 	struct list_head peers_on_pdev;
+
+	struct cyclecounter cc;
+	struct timecounter tc;
+	spinlock_t tc_lock; /* spinlock to guard access to tc->cycle_last */
+	struct delayed_work timestamp;
+	struct clk *timestamp_clk;
+	unsigned long work_delay_jiffies;
+	bool timestamp_enabled;
+	bool timestamp_possible;
 };
 
 /**
@@ -75,8 +88,16 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr,
 			int pm_enable_call,
 			void (*set_drvdata_fnc)(struct device *dev,
 						struct net_device *ndev));
+void ctucan_remove_common(struct ctucan_priv *priv);
 
 int ctucan_suspend(struct device *dev) __maybe_unused;
 int ctucan_resume(struct device *dev) __maybe_unused;
+int ctucan_runtime_resume(struct device *dev);
+int ctucan_runtime_suspend(struct device *dev);
 
+u64 ctucan_read_timestamp_cc_wrapper(const struct cyclecounter *cc);
+u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv);
+void ctucan_skb_set_timestamp(struct ctucan_priv *priv, struct sk_buff *skb, u64 timestamp);
+void ctucan_timestamp_init(struct ctucan_priv *priv);
+void ctucan_timestamp_stop(struct ctucan_priv *priv);
 #endif /*__CTUCANFD__*/
diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
index b8da15ea6ad9..079819d53e23 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -18,6 +18,7 @@
  ******************************************************************************/
 
 #include <linux/clk.h>
+#include <linux/clocksource.h>
 #include <linux/errno.h>
 #include <linux/ethtool.h>
 #include <linux/init.h>
@@ -25,6 +26,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/string.h>
@@ -148,6 +150,27 @@ static void ctucan_write_txt_buf(struct ctucan_priv *priv, enum ctu_can_fd_can_r
 	priv->write_reg(priv, buf_base + offset, val);
 }
 
+static inline u64 ctucan_concat_tstamp(u32 high, u32 low)
+{
+	return ((u64)high << 32) | ((u64)low);
+}
+
+u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv)
+{
+	u32 ts_low;
+	u32 ts_high;
+	u32 ts_high2;
+
+	ts_high = ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
+	ts_low = ctucan_read32(priv, CTUCANFD_TIMESTAMP_LOW);
+	ts_high2 = ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
+
+	if (ts_high2 != ts_high)
+		ts_low = priv->read_reg(priv, CTUCANFD_TIMESTAMP_LOW);
+
+	return ctucan_concat_tstamp(ts_high2, ts_low);
+}
+
 #define CTU_CAN_FD_TXTNF(priv) (!!FIELD_GET(REG_STATUS_TXNF, ctucan_read32(priv, CTUCANFD_STATUS)))
 #define CTU_CAN_FD_ENABLED(priv) (!!FIELD_GET(REG_MODE_ENA, ctucan_read32(priv, CTUCANFD_MODE)))
 
@@ -640,12 +663,16 @@ static netdev_tx_t ctucan_start_xmit(struct sk_buff *skb, struct net_device *nde
  * @priv:	Pointer to CTU CAN FD's private data
  * @cf:		Pointer to CAN frame struct
  * @ffw:	Previously read frame format word
+ * @skb:	Pointer to buffer to store timestamp
  *
  * Note: Frame format word must be read separately and provided in 'ffw'.
  */
-static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_frame *cf, u32 ffw)
+static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_frame *cf,
+				 u32 ffw, u64 *timestamp)
 {
 	u32 idw;
+	u32 tstamp_high;
+	u32 tstamp_low;
 	unsigned int i;
 	unsigned int wc;
 	unsigned int len;
@@ -681,9 +708,10 @@ static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_frame *c
 	if (unlikely(len > wc * 4))
 		len = wc * 4;
 
-	/* Timestamp - Read and throw away */
-	ctucan_read32(priv, CTUCANFD_RX_DATA);
-	ctucan_read32(priv, CTUCANFD_RX_DATA);
+	/* Timestamp */
+	tstamp_low = ctucan_read32(priv, CTUCANFD_RX_DATA);
+	tstamp_high = ctucan_read32(priv, CTUCANFD_RX_DATA);
+	*timestamp = ctucan_concat_tstamp(tstamp_high, tstamp_low);
 
 	/* Data */
 	for (i = 0; i < len; i += 4) {
@@ -712,6 +740,7 @@ static int ctucan_rx(struct net_device *ndev)
 	struct net_device_stats *stats = &ndev->stats;
 	struct canfd_frame *cf;
 	struct sk_buff *skb;
+	u64 timestamp;
 	u32 ffw;
 
 	if (test_bit(CTUCANFD_FLAG_RX_FFW_BUFFERED, &priv->drv_flags)) {
@@ -735,7 +764,9 @@ static int ctucan_rx(struct net_device *ndev)
 		return 0;
 	}
 
-	ctucan_read_rx_frame(priv, cf, ffw);
+	ctucan_read_rx_frame(priv, cf, ffw, &timestamp);
+	if (priv->timestamp_enabled)
+		ctucan_skb_set_timestamp(priv, skb, timestamp);
 
 	stats->rx_bytes += cf->len;
 	stats->rx_packets++;
@@ -905,6 +936,11 @@ static void ctucan_err_interrupt(struct net_device *ndev, u32 isr)
 	if (skb) {
 		stats->rx_packets++;
 		stats->rx_bytes += cf->can_dlc;
+		if (priv->timestamp_enabled) {
+			u64 tstamp = ctucan_read_timestamp_counter(priv);
+
+			ctucan_skb_set_timestamp(priv, skb, tstamp);
+		}
 		netif_rx(skb);
 	}
 }
@@ -950,6 +986,11 @@ static int ctucan_rx_poll(struct napi_struct *napi, int quota)
 			cf->data[1] |= CAN_ERR_CRTL_RX_OVERFLOW;
 			stats->rx_packets++;
 			stats->rx_bytes += cf->can_dlc;
+			if (priv->timestamp_enabled) {
+				u64 tstamp = ctucan_read_timestamp_counter(priv);
+
+				ctucan_skb_set_timestamp(priv, skb, tstamp);
+			}
 			netif_rx(skb);
 		}
 
@@ -1230,6 +1271,9 @@ static int ctucan_open(struct net_device *ndev)
 		goto err_chip_start;
 	}
 
+	if (priv->timestamp_possible)
+		ctucan_timestamp_init(priv);
+
 	netdev_info(ndev, "ctu_can_fd device registered\n");
 	napi_enable(&priv->napi);
 	netif_start_queue(ndev);
@@ -1262,6 +1306,8 @@ static int ctucan_close(struct net_device *ndev)
 	ctucan_chip_stop(ndev);
 	free_irq(ndev->irq, ndev);
 	close_candev(ndev);
+	if (priv->timestamp_possible)
+		ctucan_timestamp_stop(priv);
 
 	pm_runtime_put(priv->dev);
 
@@ -1294,15 +1340,88 @@ static int ctucan_get_berr_counter(const struct net_device *ndev, struct can_ber
 	return 0;
 }
 
+static int ctucan_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
+{
+	struct ctucan_priv *priv = netdev_priv(dev);
+	struct hwtstamp_config cfg;
+
+	if (!priv->timestamp_possible)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	if (cfg.rx_filter == HWTSTAMP_FILTER_NONE && cfg.tx_type == HWTSTAMP_TX_OFF) {
+		priv->timestamp_enabled = false;
+		return 0;
+	}
+	if (cfg.rx_filter == HWTSTAMP_FILTER_ALL && cfg.tx_type == HWTSTAMP_TX_ON) {
+		priv->timestamp_enabled = true;
+		return 0;
+	}
+	return -ERANGE;
+}
+
+static int ctucan_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
+{
+	struct ctucan_priv *priv = netdev_priv(dev);
+	struct hwtstamp_config cfg;
+
+	if (!priv->timestamp_possible)
+		return -EOPNOTSUPP;
+
+	cfg.flags = 0;
+
+	if (priv->timestamp_enabled) {
+		cfg.tx_type = HWTSTAMP_TX_ON;
+		cfg.rx_filter = HWTSTAMP_FILTER_ALL;
+	} else {
+		cfg.tx_type = HWTSTAMP_TX_OFF;
+		cfg.rx_filter = HWTSTAMP_FILTER_NONE;
+	}
+
+	if (copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)))
+		return -EFAULT;
+	return 0;
+}
+
+static int ctucan_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return ctucan_hwtstamp_set(dev, ifr);
+	case SIOCGHWTSTAMP:
+		return ctucan_hwtstamp_get(dev, ifr);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int ctucan_ethtool_get_ts_info(struct net_device *ndev,
+				      struct ethtool_ts_info *info)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+
+	if (!priv->timestamp_possible)
+		return ethtool_op_get_ts_info(ndev, info);
+
+	can_ethtool_op_get_ts_info_hwts(ndev, info);
+	info->rx_filters |= BIT(HWTSTAMP_FILTER_NONE);
+	info->tx_types |= BIT(HWTSTAMP_TX_OFF);
+
+	return 0;
+}
+
 static const struct net_device_ops ctucan_netdev_ops = {
 	.ndo_open	= ctucan_open,
 	.ndo_stop	= ctucan_close,
 	.ndo_start_xmit	= ctucan_start_xmit,
 	.ndo_change_mtu	= can_change_mtu,
+	.ndo_eth_ioctl	= ctucan_ioctl,
 };
 
 static const struct ethtool_ops ctucan_ethtool_ops = {
-	.get_ts_info = ethtool_op_get_ts_info,
+	.get_ts_info = ctucan_ethtool_get_ts_info,
 };
 
 int ctucan_suspend(struct device *dev)
@@ -1337,12 +1456,41 @@ int ctucan_resume(struct device *dev)
 }
 EXPORT_SYMBOL(ctucan_resume);
 
+int ctucan_runtime_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct ctucan_priv *priv = netdev_priv(ndev);
+
+	clk_disable_unprepare(priv->timestamp_clk);
+
+	return 0;
+}
+EXPORT_SYMBOL(ctucan_runtime_suspend);
+
+int ctucan_runtime_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	int ret;
+
+	ret = clk_prepare_enable(priv->timestamp_clk);
+	if (ret) {
+		dev_err(dev, "Cannot enable timestamping clock: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ctucan_runtime_resume);
+
 int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigned int ntxbufs,
 			unsigned long can_clk_rate, int pm_enable_call,
 			void (*set_drvdata_fnc)(struct device *dev, struct net_device *ndev))
 {
 	struct ctucan_priv *priv;
 	struct net_device *ndev;
+	u32 timestamp_clk_rate = can_clk_rate;
+	u32 timestamp_bit_size = 0;
 	int ret;
 
 	/* Create a CAN device instance */
@@ -1372,6 +1520,7 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
 					| CAN_CTRLMODE_FD_NON_ISO
 					| CAN_CTRLMODE_ONE_SHOT;
 	priv->mem_base = addr;
+	priv->timestamp_possible = true;
 
 	/* Get IRQ for the device */
 	ndev->irq = irq;
@@ -1385,15 +1534,29 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
 
 	/* Getting the can_clk info */
 	if (!can_clk_rate) {
-		priv->can_clk = devm_clk_get(dev, NULL);
+		priv->can_clk = devm_clk_get_optional(dev, "core");
+		if (!priv->can_clk)
+			/* For compatibility with (older) device trees without clock-names */
+			priv->can_clk = devm_clk_get(dev, NULL);
 		if (IS_ERR(priv->can_clk)) {
-			dev_err(dev, "Device clock not found.\n");
+			dev_err(dev, "Device clock not found: %pe.\n", priv->can_clk);
 			ret = PTR_ERR(priv->can_clk);
 			goto err_free;
 		}
 		can_clk_rate = clk_get_rate(priv->can_clk);
 	}
 
+	if (!timestamp_clk_rate) {
+		priv->timestamp_clk = devm_clk_get(dev, "ts");
+		if (IS_ERR(priv->timestamp_clk)) {
+			/* Take the core clock instead */
+			dev_info(dev, "Failed to get ts clk\n");
+			priv->timestamp_clk = priv->can_clk;
+		}
+		clk_prepare_enable(priv->timestamp_clk);
+		timestamp_clk_rate = clk_get_rate(priv->timestamp_clk);
+	}
+
 	priv->write_reg = ctucan_write32_le;
 	priv->read_reg = ctucan_read32_le;
 
@@ -1424,6 +1587,50 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
 
 	priv->can.clock.freq = can_clk_rate;
 
+	/* Obtain timestamping counter bit size */
+	timestamp_bit_size = FIELD_GET(REG_ERR_CAPT_TS_BITS,
+				       ctucan_read32(priv, CTUCANFD_ERR_CAPT));
+
+	/* The register value is actually bit_size - 1 */
+	if (timestamp_bit_size) {
+		timestamp_bit_size += 1;
+	} else {
+		/* For 2.x versions of the IP core, we will assume 64-bit counter
+		 * if there was a 0 in the register.
+		 */
+		u32 version_reg = ctucan_read32(priv, CTUCANFD_DEVICE_ID);
+		u32 major = FIELD_GET(REG_DEVICE_ID_VER_MAJOR, version_reg);
+
+		if (major == 2)
+			timestamp_bit_size = 64;
+		else
+			priv->timestamp_possible = false;
+	}
+
+	/* Setup conversion constants and work delay */
+	if (priv->timestamp_possible) {
+		u64 max_cycles;
+		u64 work_delay_ns;
+		u32 maxsec;
+
+		priv->cc.read = ctucan_read_timestamp_cc_wrapper;
+		priv->cc.mask = CYCLECOUNTER_MASK(timestamp_bit_size);
+		maxsec = min_t(u32, CTUCANFD_MAX_WORK_DELAY_SEC,
+			       div_u64(priv->cc.mask, timestamp_clk_rate));
+		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift,
+				       timestamp_clk_rate, NSEC_PER_SEC, maxsec);
+
+		/* shortened copy of clocks_calc_max_nsecs() */
+		max_cycles = div_u64(ULLONG_MAX, priv->cc.mult);
+		max_cycles = min(max_cycles, priv->cc.mask);
+		work_delay_ns = clocksource_cyc2ns(max_cycles, priv->cc.mult,
+						   priv->cc.shift) >> 2;
+		priv->work_delay_jiffies = nsecs_to_jiffies(work_delay_ns);
+
+		if (priv->work_delay_jiffies == 0)
+			priv->timestamp_possible = false;
+	}
+
 	netif_napi_add(ndev, &priv->napi, ctucan_rx_poll);
 
 	ret = register_candev(ndev);
@@ -1451,6 +1658,12 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
 }
 EXPORT_SYMBOL(ctucan_probe_common);
 
+void ctucan_remove_common(struct ctucan_priv *priv)
+{
+	clk_disable_unprepare(priv->timestamp_clk);
+}
+EXPORT_SYMBOL(ctucan_remove_common);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Jerabek <martin.jerabek01@gmail.com>");
 MODULE_AUTHOR("Pavel Pisa <pisa@cmp.felk.cvut.cz>");
diff --git a/drivers/net/can/ctucanfd/ctucanfd_pci.c b/drivers/net/can/ctucanfd/ctucanfd_pci.c
index 8f2956a8ae43..d0c7ec0525d8 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_pci.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_pci.c
@@ -237,6 +237,8 @@ static void ctucan_pci_remove(struct pci_dev *pdev)
 		return;
 	}
 
+	ctucan_remove_common(priv);
+
 	/* disable interrupt in
 	 * Avalon-MM to PCI Express Interrupt Enable Register
 	 */
@@ -271,7 +273,10 @@ static void ctucan_pci_remove(struct pci_dev *pdev)
 	kfree(bdata);
 }
 
-static SIMPLE_DEV_PM_OPS(ctucan_pci_pm_ops, ctucan_suspend, ctucan_resume);
+static const struct dev_pm_ops ctucan_pci_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ctucan_suspend, ctucan_resume)
+	SET_RUNTIME_PM_OPS(ctucan_runtime_suspend, ctucan_runtime_resume, NULL)
+};
 
 static const struct pci_device_id ctucan_pci_tbl[] = {
 	{PCI_DEVICE_DATA(TEDIA, CTUCAN_VER21,
diff --git a/drivers/net/can/ctucanfd/ctucanfd_platform.c b/drivers/net/can/ctucanfd/ctucanfd_platform.c
index f83684f006ea..0f1d58ec9850 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_platform.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
@@ -95,6 +95,8 @@ static int ctucan_platform_remove(struct platform_device *pdev)
 
 	netdev_dbg(ndev, "ctucan_remove");
 
+	ctucan_remove_common(priv);
+
 	unregister_candev(ndev);
 	pm_runtime_disable(&pdev->dev);
 	netif_napi_del(&priv->napi);
@@ -103,7 +105,10 @@ static int ctucan_platform_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(ctucan_platform_pm_ops, ctucan_suspend, ctucan_resume);
+static const struct dev_pm_ops ctucan_platform_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ctucan_suspend, ctucan_resume)
+	SET_RUNTIME_PM_OPS(ctucan_runtime_suspend, ctucan_runtime_resume, NULL)
+};
 
 /* Match table for OF platform binding */
 static const struct of_device_id ctucan_of_match[] = {
diff --git a/drivers/net/can/ctucanfd/ctucanfd_timestamp.c b/drivers/net/can/ctucanfd/ctucanfd_timestamp.c
new file mode 100644
index 000000000000..1fdfd8536f71
--- /dev/null
+++ b/drivers/net/can/ctucanfd/ctucanfd_timestamp.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*******************************************************************************
+ *
+ * CTU CAN FD IP Core
+ *
+ * Copyright (C) 2022 Matej Vasilevski <matej.vasilevski@seznam.cz> FEE CTU
+ *
+ * Project advisors:
+ *     Jiri Novak <jnovak@fel.cvut.cz>
+ *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
+ *
+ * Department of Measurement         (http://meas.fel.cvut.cz/)
+ * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
+ * Czech Technical University        (http://www.cvut.cz/)
+ ******************************************************************************/
+
+#include "linux/spinlock.h"
+#include <linux/bitops.h>
+#include <linux/clocksource.h>
+#include <linux/math64.h>
+#include <linux/timecounter.h>
+#include <linux/workqueue.h>
+
+#include "ctucanfd.h"
+#include "ctucanfd_kregs.h"
+
+u64 ctucan_read_timestamp_cc_wrapper(const struct cyclecounter *cc)
+{
+	struct ctucan_priv *priv = container_of(cc, struct ctucan_priv, cc);
+
+	lockdep_assert_held(&priv->tc_lock);
+
+	return ctucan_read_timestamp_counter(priv);
+}
+
+static void ctucan_timestamp_work(struct work_struct *work)
+{
+	struct delayed_work *delayed_work = to_delayed_work(work);
+	struct ctucan_priv *priv = container_of(delayed_work, struct ctucan_priv, timestamp);
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->tc_lock, flags);
+	timecounter_read(&priv->tc);
+	spin_unlock_irqrestore(&priv->tc_lock, flags);
+	schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies);
+}
+
+void ctucan_skb_set_timestamp(struct ctucan_priv *priv, struct sk_buff *skb, u64 timestamp)
+{
+	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
+	u64 ns;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->tc_lock, flags);
+	ns = timecounter_cyc2time(&priv->tc, timestamp);
+	spin_unlock_irqrestore(&priv->tc_lock, flags);
+	hwtstamps->hwtstamp = ns_to_ktime(ns);
+}
+
+void ctucan_timestamp_init(struct ctucan_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_init(&priv->tc_lock);
+
+	spin_lock_irqsave(&priv->tc_lock, flags);
+	timecounter_init(&priv->tc, &priv->cc, ktime_get_real_ns());
+	spin_unlock_irqrestore(&priv->tc_lock, flags);
+
+	INIT_DELAYED_WORK(&priv->timestamp, ctucan_timestamp_work);
+	schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies);
+}
+
+void ctucan_timestamp_stop(struct ctucan_priv *priv)
+{
+	cancel_delayed_work_sync(&priv->timestamp);
+}
-- 
2.25.1

