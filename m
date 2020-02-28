Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F37D173F10
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 19:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgB1SDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 13:03:00 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:50825 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1SCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 13:02:50 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 171FE23E2E;
        Fri, 28 Feb 2020 19:02:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1582912967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w+6lbG+1O2w/ugznihg24tGLgyVuEtebCD2fE6MyHnk=;
        b=G1lkYHtmS7CmQxYuDJ1vY5do1V2KX433vz+2gGl3GJ8xJuWnMSezrfBkvdmdfU7NNE2Qp/
        vcfY5QWmiBo565BBKMK3sBYthoQub9s+Odi8gVR/l78+MOYm2yzieLojfaNx23srb0SC58
        hEyxRXtTx7Oc7GC3QdRLcD/e9fVeDfk=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [RFC PATCH v2 2/2] net: phy: at803x: add PTP support for AR8031
Date:   Fri, 28 Feb 2020 19:02:26 +0100
Message-Id: <20200228180226.22986-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228180226.22986-1-michael@walle.cc>
References: <20200228180226.22986-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 171FE23E2E
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[9];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PHY timestamping to the Atheros AR8031 PHY.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/Kconfig  |  17 +
 drivers/net/phy/at803x.c | 855 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 847 insertions(+), 25 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 9dabe03a668c..f3d4655af436 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -462,6 +462,23 @@ config AT803X_PHY
 	help
 	  Currently supports the AR8030, AR8031, AR8033 and AR8035 model
 
+if AT803X_PHY
+config AT8031_PHY_TIMESTAMPING
+	bool "Enable PHY timestamping support"
+	depends on NETWORK_PHY_TIMESTAMPING
+	depends on PTP_1588_CLOCK
+	help
+	  Enable the IEEE1588 features for the AR8031 PHY.
+
+	  This driver adds support for using the AR8031 as a PTP
+	  clock. This clock is only useful if your PTP programs are
+	  getting hardware time stamps on the PTP Ethernet packets
+	  using the SO_TIMESTAMPING API.
+
+	  In order for this to work, your MAC driver must also
+	  implement the skb_tx_timestamp() function.
+endif
+
 config QSEMI_PHY
 	tristate "Quality Semiconductor PHYs"
 	---help---
diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 481cf48c9b9e..1ec1ad70de21 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -11,10 +11,14 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/netdevice.h>
+#include <linux/net_tstamp.h>
 #include <linux/etherdevice.h>
 #include <linux/of_gpio.h>
 #include <linux/bitfield.h>
 #include <linux/gpio/consumer.h>
+#include <linux/if_vlan.h>
+#include <linux/ptp_classify.h>
+#include <linux/ptp_clock_kernel.h>
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/consumer.h>
@@ -30,17 +34,25 @@
 #define AT803X_SS_MDIX				BIT(6)
 
 #define AT803X_INTR_ENABLE			0x12
-#define AT803X_INTR_ENABLE_AUTONEG_ERR		BIT(15)
-#define AT803X_INTR_ENABLE_SPEED_CHANGED	BIT(14)
-#define AT803X_INTR_ENABLE_DUPLEX_CHANGED	BIT(13)
-#define AT803X_INTR_ENABLE_PAGE_RECEIVED	BIT(12)
-#define AT803X_INTR_ENABLE_LINK_FAIL		BIT(11)
-#define AT803X_INTR_ENABLE_LINK_SUCCESS		BIT(10)
-#define AT803X_INTR_ENABLE_WIRESPEED_DOWNGRADE	BIT(5)
-#define AT803X_INTR_ENABLE_POLARITY_CHANGED	BIT(1)
-#define AT803X_INTR_ENABLE_WOL			BIT(0)
-
 #define AT803X_INTR_STATUS			0x13
+#define AT803X_INTR_AUTONEG_ERR			BIT(15)
+#define AT803X_INTR_SPEED_CHANGED		BIT(14)
+#define AT803X_INTR_DUPLEX_CHANGED		BIT(13)
+#define AT803X_INTR_PAGE_RECEIVED		BIT(12)
+#define AT803X_INTR_LINK_FAIL			BIT(11)
+#define AT803X_INTR_LINK_SUCCESS		BIT(10)
+#define AT803X_INTR_WIRESPEED_DOWNGRADE		BIT(5)
+#define AT8031_INTR_10MS_PTP			BIT(4)
+#define AT8031_INTR_RX_PTP			BIT(3)
+#define AT8031_INTR_TX_PTP			BIT(2)
+#define AT803X_INTR_POLARITY_CHANGED		BIT(1)
+#define AT803X_INTR_WOL				BIT(0)
+
+#define AT803X_INTR_LINK_CHANGE_MASK (AT803X_INTR_AUTONEG_ERR \
+				      | AT803X_INTR_SPEED_CHANGED \
+				      | AT803X_INTR_DUPLEX_CHANGED \
+				      | AT803X_INTR_LINK_FAIL \
+				      | AT803X_INTR_LINK_SUCCESS)
 
 #define AT803X_SMART_SPEED			0x14
 #define AT803X_LED_CONTROL			0x18
@@ -113,7 +125,19 @@ MODULE_DESCRIPTION("Qualcomm Atheros AR803x PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
 
+#define MAX_RXTS	32
+#define SKB_TIMESTAMP_TIMEOUT	5 /* jiffies */
+
+struct rxts {
+	struct list_head list;
+	unsigned long tmo;
+	struct timespec64 ts;
+	u16 seqid;
+};
+
 struct at803x_priv {
+	struct phy_device *phydev;
+	struct mii_timestamper mii_ts;
 	int flags;
 #define AT803X_KEEP_PLL_ENABLED	BIT(0)	/* don't turn off internal PLL */
 	u16 clk_25m_reg;
@@ -121,6 +145,21 @@ struct at803x_priv {
 	struct regulator_dev *vddio_rdev;
 	struct regulator_dev *vddh_rdev;
 	struct regulator *vddio;
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info ptp_info;
+	struct delayed_work ts_work;
+	int hwts_tx_en;
+	int hwts_rx_en;
+	struct timespec64 last_txts;
+	struct timespec64 last_rxts;
+	/* list of rx timestamps */
+	struct list_head rxts;
+	struct list_head rxpool;
+	struct rxts rx_pool_data[MAX_RXTS];
+	/* protects above three fields from concurrent access */
+	spinlock_t rx_lock;
+	struct sk_buff_head rx_queue;
+	struct sk_buff_head tx_queue;
 };
 
 struct at803x_context {
@@ -235,14 +274,14 @@ static int at803x_set_wol(struct phy_device *phydev,
 				      mac[(i * 2) + 1] | (mac[(i * 2)] << 8));
 
 		value = phy_read(phydev, AT803X_INTR_ENABLE);
-		value |= AT803X_INTR_ENABLE_WOL;
+		value |= AT803X_INTR_WOL;
 		ret = phy_write(phydev, AT803X_INTR_ENABLE, value);
 		if (ret)
 			return ret;
 		value = phy_read(phydev, AT803X_INTR_STATUS);
 	} else {
 		value = phy_read(phydev, AT803X_INTR_ENABLE);
-		value &= (~AT803X_INTR_ENABLE_WOL);
+		value &= (~AT803X_INTR_WOL);
 		ret = phy_write(phydev, AT803X_INTR_ENABLE, value);
 		if (ret)
 			return ret;
@@ -261,7 +300,7 @@ static void at803x_get_wol(struct phy_device *phydev,
 	wol->wolopts = 0;
 
 	value = phy_read(phydev, AT803X_INTR_ENABLE);
-	if (value & AT803X_INTR_ENABLE_WOL)
+	if (value & AT803X_INTR_WOL)
 		wol->wolopts |= WAKE_MAGIC;
 }
 
@@ -271,7 +310,7 @@ static int at803x_suspend(struct phy_device *phydev)
 	int wol_enabled;
 
 	value = phy_read(phydev, AT803X_INTR_ENABLE);
-	wol_enabled = value & AT803X_INTR_ENABLE_WOL;
+	wol_enabled = value & AT803X_INTR_WOL;
 
 	if (wol_enabled)
 		value = BMCR_ISOLATE;
@@ -475,6 +514,694 @@ static int at803x_parse_dt(struct phy_device *phydev)
 	return 0;
 }
 
+static int at8031_ptp_enable(struct ptp_clock_info *ptp,
+			     struct ptp_clock_request *rq, int on)
+{
+	return -EOPNOTSUPP;
+}
+
+#define AT8031_MMD3_PTP_CTRL		0x8012
+#define AT8031_WOL_EN			BIT(5)
+#define AT8031_PTP_TS_ATTACH_EN		BIT(4)
+#define AT8031_PTP_BYPASS		BIT(3)
+#define AT8031_PTP_CLK_MODE_MASK	GENMASK(2, 1)
+#define AT8031_PTP_CLK_MODE_BC_1STEP	0
+#define AT8031_PTP_CLK_MODE_BC_2STEP	1
+#define AT8031_PTP_CLK_MODE_TC_1STEP	2
+#define AT8031_PTP_CLK_MODE_TC_2STEP	3
+#define AT8031_MMD3_RX_SEQID		0x8013
+#define AT8031_MMD3_RX_TS		0x8019
+#define AT8031_MMD3_RX_MSG_TYPE		0x801e
+#define AT8031_MMD3_TX_SEQID		0x8020
+#define AT8031_MMD3_TX_TS		0x8026
+#define AT8031_MMD3_TX_MSG_TYPE		0x802b
+#define AT8031_MSG_TYPE_MASK		GENMASK(15, 12)
+
+struct at8031_skb_info {
+	int ptp_type;
+	unsigned long tmo;
+};
+
+/* INC_VALUE[25:20] is the nanoseconds part,
+ * INC_VALUE[19:0] is the sub-nanoseconds fractional part
+ */
+#define AT8031_MMD3_RTC_INC_1		0x8036 /* INC_VALUE[25:10] */
+#define AT8031_MMD3_RTC_INC_0		0x8037 /* INC_VALUE[9:0] */
+
+/* Internal PLL has a nomial clock frequency of 125MHz */
+#define NOMINAL_INC_VALUE		((1000000000 / 125000000) << 20)
+
+#define AT8031_MMD3_RTC_OFFSET_NSEC_1	0x8038 /* NANO_OFFSET[31:16] */
+#define AT8031_MMD3_RTC_OFFSET_NSEC_0	0x8039 /* NANO_OFFSET[15:0] */
+
+#define AT8031_MMD3_RTC_OFFSET_SEC_2	0x803a /* SEC_OFFSET[47:32] */
+#define AT8031_MMD3_RTC_OFFSET_SEC_1	0x803b /* SEC_OFFSET[31:16] */
+#define AT8031_MMD3_RTC_OFFSET_SEC_0	0x803c /* SEC_OFFSET[15:0] */
+
+#define AT8031_MMD3_RTC			0x803d
+
+#define AT8031_TS_SEC_2			0 /* TS_SEC[47:32] */
+#define AT8031_TS_SEC_1			1 /* TS_SEC[31:16] */
+#define AT8031_TS_SEC_0			2 /* TS_SEC[15:0] */
+#define AT8031_TS_NSEC_1		3 /* TS_NSEC[31:16] */
+#define AT8031_TS_NSEC_0		4 /* TS_NSEC[15:0] */
+#define AT8031_TS_FRAC_1		5 /* TS_FRAC_NANO[19:4] */
+#define AT8031_TS_FRAC_0		6 /* TS_FRAC_NANO[3:0] */
+
+#define AT8031_MMD3_RTC_ADJUST		0x8044
+#define AT8031_RTC_ADJUST		BIT(0)
+
+static int at8031_read_ts(struct phy_device *phydev, int off,
+			  struct timespec64 *ts)
+{
+	time64_t sec, tmp;
+	long nsec;
+
+	tmp = phy_read_mmd(phydev, MDIO_MMD_PCS, off + AT8031_TS_SEC_2);
+	if (tmp < 0)
+		return tmp;
+	sec = tmp << 32;
+
+	tmp = phy_read_mmd(phydev, MDIO_MMD_PCS, off + AT8031_TS_SEC_1);
+	if (tmp < 0)
+		return tmp;
+	sec |= tmp << 16;
+
+	tmp = phy_read_mmd(phydev, MDIO_MMD_PCS, off + AT8031_TS_SEC_0);
+	if (tmp < 0)
+		return tmp;
+	sec |= tmp;
+
+	tmp = phy_read_mmd(phydev, MDIO_MMD_PCS, off + AT8031_TS_NSEC_1);
+	if (tmp < 0)
+		return tmp;
+	nsec = tmp << 16;
+
+	tmp = phy_read_mmd(phydev, MDIO_MMD_PCS, off + AT8031_TS_NSEC_0);
+	if (tmp < 0)
+		return tmp;
+	nsec |= tmp;
+
+	ts->tv_sec = sec;
+	ts->tv_nsec = nsec;
+
+	return 0;
+}
+
+static int at8031_rtc_read(struct phy_device *phydev, struct timespec64 *ts)
+{
+	return at8031_read_ts(phydev, AT8031_MMD3_RTC, ts);
+}
+
+static void prune_rx_ts(struct at803x_priv *priv)
+{
+	struct list_head *this, *next;
+	struct rxts *rxts;
+
+	list_for_each_safe(this, next, &priv->rxts) {
+		rxts = list_entry(this, struct rxts, list);
+		if (time_after(jiffies, rxts->tmo)) {
+			list_del_init(&rxts->list);
+			list_add(&rxts->list, &priv->rxpool);
+		}
+	}
+}
+
+static int match(struct sk_buff *skb, unsigned int type, u16 seqid)
+{
+	u16 *pseqid;
+	unsigned int offset = 0;
+	u8 *data = skb_mac_header(skb);
+
+	if (type & PTP_CLASS_VLAN)
+		offset += VLAN_HLEN;
+
+	switch (type & PTP_CLASS_PMASK) {
+	case PTP_CLASS_IPV4:
+		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
+		break;
+	case PTP_CLASS_IPV6:
+		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
+		break;
+	case PTP_CLASS_L2:
+		offset += ETH_HLEN;
+		break;
+	default:
+		return 0;
+	}
+
+	/* check sequence id */
+	if (skb->len + ETH_HLEN < offset + OFF_PTP_SEQUENCE_ID + sizeof(*pseqid))
+		return 0;
+
+	pseqid = (u16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
+	if (seqid != ntohs(*pseqid))
+		return 0;
+
+	return 1;
+}
+
+static int at8031_get_rxts(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+	struct skb_shared_hwtstamps *shhwtstamps = NULL;
+	struct timespec64 ts, saved_ts;
+	struct sk_buff *skb;
+	unsigned long flags;
+	struct rxts *rxts;
+	int msg_type;
+	int seqid;
+	int ret;
+
+	ret = at8031_read_ts(phydev, AT8031_MMD3_RX_TS, &ts);
+	if (ret < 0)
+		return ret;
+
+	/* AR8031 generates an interrupt on any PTP packet. No timestamp,
+	 * messageType and sequenceId fields will change. Thus check if we already
+	 * received that timestamp. If so, ignore it.
+	 */
+	if (timespec64_equal(&priv->last_rxts, &ts))
+		return 0;
+	priv->last_rxts = ts;
+
+again:
+	saved_ts = ts;
+
+	seqid = phy_read_mmd(phydev, MDIO_MMD_PCS, AT8031_MMD3_RX_SEQID);
+	if (seqid < 0)
+		return seqid;
+
+	msg_type = phy_read_mmd(phydev, MDIO_MMD_PCS, AT8031_MMD3_RX_MSG_TYPE);
+	if (msg_type < 0)
+		return msg_type;
+	msg_type = FIELD_GET(AT8031_MSG_TYPE_MASK, msg_type);
+
+	/* Unfortunately, there is no way to atomically read the timestamps.
+	 * Read the timestamp again and compare to saved value.
+	 */
+	ret = at8031_read_ts(phydev, AT8031_MMD3_RX_TS, &ts);
+	if (ret < 0)
+		return ret;
+	if (!timespec64_equal(&saved_ts, &ts))
+		goto again;
+
+	spin_lock_irqsave(&priv->rx_lock, flags);
+
+	prune_rx_ts(priv);
+
+	if (list_empty(&priv->rxpool)) {
+		phydev_dbg(phydev, "rx timestamp pool is empty\n");
+		goto out;
+	}
+	rxts = list_first_entry(&priv->rxpool, struct rxts, list);
+	list_del_init(&rxts->list);
+
+	rxts->seqid = seqid;
+	rxts->ts = ts;
+	rxts->tmo = jiffies + SKB_TIMESTAMP_TIMEOUT;
+
+	spin_lock(&priv->rx_queue.lock);
+	skb_queue_walk(&priv->rx_queue, skb) {
+		struct at8031_skb_info *skb_info;
+
+		skb_info = (struct at8031_skb_info *)skb->cb;
+		if (match(skb, skb_info->ptp_type, rxts->seqid)) {
+			__skb_unlink(skb, &priv->rx_queue);
+			shhwtstamps = skb_hwtstamps(skb);
+			memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+			shhwtstamps->hwtstamp = timespec64_to_ktime(rxts->ts);
+			list_add(&rxts->list, &priv->rxpool);
+			break;
+		}
+	}
+	spin_unlock(&priv->rx_queue.lock);
+
+	if (!shhwtstamps)
+		list_add_tail(&rxts->list, &priv->rxts);
+out:
+	spin_unlock_irqrestore(&priv->rx_lock, flags);
+
+	if (shhwtstamps)
+		netif_rx_ni(skb);
+
+	return 0;
+}
+
+static int at8031_get_txts(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+	struct skb_shared_hwtstamps shhwtstamps;
+	struct at8031_skb_info *skb_info;
+	struct timespec64 ts, saved_ts;
+	struct sk_buff *skb;
+	int msg_type;
+	int seqid;
+	int ret;
+
+	ret = at8031_read_ts(phydev, AT8031_MMD3_TX_TS, &ts);
+	if (ret < 0)
+		return ret;
+
+	/* AR8031 generates an interrupt on any PTP packet. No timestamp,
+	 * messageType and sequenceId fields will change. Thus check if we already
+	 * received that timestamp. If so, ignore it.
+	 */
+	if (timespec64_equal(&priv->last_txts, &ts))
+		return 0;
+	priv->last_txts = ts;
+
+again_ts:
+	saved_ts = ts;
+
+	seqid = phy_read_mmd(phydev, MDIO_MMD_PCS, AT8031_MMD3_TX_SEQID);
+	if (seqid < 0)
+		return seqid;
+
+	msg_type = phy_read_mmd(phydev, MDIO_MMD_PCS, AT8031_MMD3_TX_MSG_TYPE);
+	if (msg_type < 0)
+		return msg_type;
+	msg_type = FIELD_GET(AT8031_MSG_TYPE_MASK, msg_type);
+
+	/* Unfortunately, there is no way to atomically read the timestamps.
+	 * Read the timestamp again and compare to saved value.
+	 */
+	ret = at8031_read_ts(phydev, AT8031_MMD3_TX_TS, &ts);
+	if (ret < 0)
+		return ret;
+	if (!timespec64_equal(&saved_ts, &ts))
+		goto again_ts;
+
+	/* We must already have the skb that triggered this. */
+again:
+	skb = skb_dequeue(&priv->tx_queue);
+	if (!skb) {
+		phydev_dbg(phydev, "have timestamp but tx_queue empty\n");
+		return 0;
+	}
+
+	skb_info = (struct at8031_skb_info *)skb->cb;
+	if (time_after(jiffies, skb_info->tmo)) {
+		kfree_skb(skb);
+		goto again;
+	}
+
+	if (!match(skb, skb_info->ptp_type, seqid)) {
+		kfree_skb(skb);
+		goto again;
+	}
+
+	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+	shhwtstamps.hwtstamp = timespec64_to_ktime(ts);
+	skb_complete_tx_timestamp(skb, &shhwtstamps);
+
+	return 0;
+}
+
+static int at8031_rtc_adjust(struct phy_device *phydev, s64 delta)
+{
+	struct timespec64 ts = ns_to_timespec64(delta);
+	int ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_PCS,
+			    AT8031_MMD3_RTC_OFFSET_SEC_2,
+			    (ts.tv_sec >> 32) & 0xffff);
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_PCS,
+			    AT8031_MMD3_RTC_OFFSET_SEC_1,
+			    (ts.tv_sec >> 16) & 0xffff);
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_PCS,
+			    AT8031_MMD3_RTC_OFFSET_SEC_0,
+			    ts.tv_sec & 0xffff);
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_PCS,
+			    AT8031_MMD3_RTC_OFFSET_NSEC_1,
+			    (ts.tv_nsec >> 16) & 0xffff);
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_PCS,
+			    AT8031_MMD3_RTC_OFFSET_NSEC_0,
+			    ts.tv_nsec & 0xffff);
+	if (ret)
+		return ret;
+
+	return phy_write_mmd(phydev, MDIO_MMD_PCS, AT8031_MMD3_RTC_ADJUST,
+			     AT8031_RTC_ADJUST);
+}
+
+static int at8031_ptp_gettimex64(struct ptp_clock_info *ptp,
+				 struct timespec64 *ts,
+				 struct ptp_system_timestamp *sts)
+{
+	struct at803x_priv *priv =
+		container_of(ptp, struct at803x_priv, ptp_info);
+	struct phy_device *phydev = priv->phydev;
+	int ret;
+
+	/* AR8031 doesn't provide a method to read the time atomically. So just
+	 * do our best here. Make sure we start with MSB so we cannot read a
+	 * future time accidentially.
+	 */
+
+	ptp_read_system_prets(sts);
+	ret = at8031_rtc_read(phydev, ts);
+	ptp_read_system_postts(sts);
+
+	return ret;
+}
+
+static s32 at8031_rtc_get_inc(struct phy_device *phydev)
+{
+	s32 v1, v0;
+
+	v1 = phy_read_mmd(phydev, MDIO_MMD_PCS, AT8031_MMD3_RTC_INC_1);
+	if (v1 < 0)
+		return v1;
+
+	v0 = phy_read_mmd(phydev, MDIO_MMD_PCS, AT8031_MMD3_RTC_INC_0);
+	if (v0 < 0)
+		return v0;
+
+	return (v1 & 0xffff) << 10 | (v0 & 0x3ff);
+}
+
+static int at8031_rtc_set_inc(struct phy_device *phydev, u32 inc)
+{
+	int ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_PCS, AT8031_MMD3_RTC_INC_1,
+			    (inc >> 10) & 0xffff);
+	if (ret)
+		return ret;
+
+	return phy_write_mmd(phydev, MDIO_MMD_PCS, AT8031_MMD3_RTC_INC_0,
+			     inc & 0x3ff);
+}
+
+static int at8031_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct at803x_priv *priv =
+		container_of(ptp, struct at803x_priv, ptp_info);
+	struct phy_device *phydev = priv->phydev;
+	bool neg_adj = false;
+	u32 inc_val;
+	u64 adj;
+
+	if (scaled_ppm < 0) {
+		neg_adj = true;
+		scaled_ppm = -scaled_ppm;
+	}
+
+	inc_val = NOMINAL_INC_VALUE;
+	adj = scaled_ppm << 4;
+	adj = div_u64(adj, 125000);
+	inc_val = neg_adj ? inc_val - adj : inc_val + adj;
+
+	return at8031_rtc_set_inc(phydev, inc_val);
+}
+
+static int at8031_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct at803x_priv *priv =
+		container_of(ptp, struct at803x_priv, ptp_info);
+	struct phy_device *phydev = priv->phydev;
+
+	return at8031_rtc_adjust(phydev, delta);
+}
+
+static int at8031_ptp_settime64(struct ptp_clock_info *ptp,
+				const struct timespec64 *ts)
+{
+	struct at803x_priv *priv =
+		container_of(ptp, struct at803x_priv, ptp_info);
+	struct phy_device *phydev = priv->phydev;
+	struct timespec64 tts;
+	s32 saved_inc;
+	s64 delta;
+	int ret;
+
+	/* This is how we set the clock:
+	 * (1) save the inc_value
+	 * (2) stop the clock by setting inc_value to zero
+	 * (3) get the clock
+	 * (4) set the difference
+	 * (5) restore the previous inc_value
+	 */
+
+	saved_inc = at8031_rtc_get_inc(phydev);
+	if (saved_inc < 0)
+		return saved_inc;
+
+	ret = at8031_rtc_set_inc(phydev, 0);
+	if (ret)
+		return ret;
+
+	ret = at8031_rtc_read(phydev, &tts);
+	if (ret)
+		return ret;
+
+	tts = timespec64_sub(*ts, tts);
+	delta = timespec64_to_ns(&tts);
+
+	ret = at8031_rtc_adjust(phydev, delta);
+	if (ret)
+		return ret;
+
+	return at8031_rtc_set_inc(phydev, saved_inc);
+}
+
+static struct ptp_clock_info at8031_ptp_info = {
+	.owner		= THIS_MODULE,
+	.name		= "ar8031 ptp clock",
+	.enable		= at8031_ptp_enable,
+	.adjtime	= at8031_ptp_adjtime,
+	.adjfine	= at8031_ptp_adjfine,
+	.gettimex64	= at8031_ptp_gettimex64,
+	.settime64	= at8031_ptp_settime64,
+	.max_adj	= 1000000000,
+};
+
+static int at8031_ptp_configure(struct phy_device *phydev, bool on)
+{
+	int val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, AT8031_MMD3_PTP_CTRL);
+	if (val < 0)
+		return val;
+
+	/* Disable attaching of any RX timestamp to the packet. We'd have to
+	 * fixup every PTP event packet in this driver.
+	 *
+	 * Also it seems that it will only works with RGMII and not SGMII.
+	 */
+	val &= ~AT8031_PTP_TS_ATTACH_EN;
+
+	if (on)
+		val &= ~AT8031_PTP_BYPASS;
+	else
+		val |= AT8031_PTP_BYPASS;
+
+	val &= ~AT8031_PTP_CLK_MODE_MASK;
+	val |= FIELD_PREP(AT8031_PTP_CLK_MODE_MASK,
+			  AT8031_PTP_CLK_MODE_BC_1STEP);
+
+	return phy_write_mmd(phydev, MDIO_MMD_PCS, AT8031_MMD3_PTP_CTRL, val);
+}
+
+static void rx_timestamp_work(struct work_struct *work)
+{
+	struct at803x_priv *priv =
+		container_of(work, struct at803x_priv, ts_work.work);
+	struct sk_buff *skb;
+
+	/* Deliver expired packets. */
+	while ((skb = skb_dequeue(&priv->rx_queue))) {
+		struct at8031_skb_info *skb_info;
+
+		skb_info = (struct at8031_skb_info *)skb->cb;
+		if (!time_after(jiffies, skb_info->tmo)) {
+			skb_queue_head(&priv->rx_queue, skb);
+			break;
+		}
+
+		netif_rx_ni(skb);
+	}
+
+	if (!skb_queue_empty(&priv->rx_queue))
+		schedule_delayed_work(&priv->ts_work, SKB_TIMESTAMP_TIMEOUT);
+}
+
+static int at8031_ts_info(struct mii_timestamper *mii_ts,
+			  struct ethtool_ts_info *info)
+{
+	struct at803x_priv *priv =
+		container_of(mii_ts, struct at803x_priv, mii_ts);
+
+	info->so_timestamping =
+		SOF_TIMESTAMPING_TX_HARDWARE |
+		SOF_TIMESTAMPING_RX_HARDWARE |
+		SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->phc_index = ptp_clock_index(priv->ptp_clock);
+	info->tx_types =
+		(1 << HWTSTAMP_TX_OFF) |
+		(1 << HWTSTAMP_TX_ON);
+	info->rx_filters =
+		(1 << HWTSTAMP_FILTER_NONE) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT);
+	return 0;
+}
+
+static bool at8031_rxtstamp(struct mii_timestamper *mii_ts,
+			    struct sk_buff *skb, int type)
+{
+	struct at803x_priv *priv =
+		container_of(mii_ts, struct at803x_priv, mii_ts);
+	struct at8031_skb_info *skb_info = (struct at8031_skb_info *)skb->cb;
+	struct list_head *this, *next;
+	struct rxts *rxts;
+	struct skb_shared_hwtstamps *shhwtstamps = NULL;
+	unsigned long flags;
+
+	if (!priv->hwts_rx_en)
+		return false;
+
+	if (!(type & PTP_CLASS_V2))
+		return false;
+
+	spin_lock_irqsave(&priv->rx_lock, flags);
+	prune_rx_ts(priv);
+	list_for_each_safe(this, next, &priv->rxts) {
+		rxts = list_entry(this, struct rxts, list);
+		if (match(skb, type, rxts->seqid)) {
+			shhwtstamps = skb_hwtstamps(skb);
+			memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+			shhwtstamps->hwtstamp = timespec64_to_ktime(rxts->ts);
+			list_del_init(&rxts->list);
+			list_add(&rxts->list, &priv->rxpool);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&priv->rx_lock, flags);
+
+	if (!shhwtstamps) {
+		skb_info->ptp_type = type;
+		skb_info->tmo = jiffies + SKB_TIMESTAMP_TIMEOUT;
+		skb_queue_tail(&priv->rx_queue, skb);
+		schedule_delayed_work(&priv->ts_work, SKB_TIMESTAMP_TIMEOUT);
+	} else {
+		netif_rx_ni(skb);
+	}
+
+	return true;
+}
+
+static void at8031_txtstamp(struct mii_timestamper *mii_ts,
+			    struct sk_buff *skb, int type)
+{
+	struct at803x_priv *priv =
+		container_of(mii_ts, struct at803x_priv, mii_ts);
+	struct at8031_skb_info *skb_info = (struct at8031_skb_info *)skb->cb;
+
+	switch (priv->hwts_tx_en) {
+	case HWTSTAMP_TX_ON:
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+		skb_info->tmo = jiffies + SKB_TIMESTAMP_TIMEOUT;
+		skb_info->ptp_type = type;
+		skb_queue_tail(&priv->tx_queue, skb);
+		break;
+
+	case HWTSTAMP_TX_OFF:
+	default:
+		kfree_skb(skb);
+		break;
+	}
+}
+
+static int at8031_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
+{
+	struct at803x_priv *priv =
+		container_of(mii_ts, struct at803x_priv, mii_ts);
+	struct hwtstamp_config cfg;
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	if (cfg.flags) /* reserved for future extensions */
+		return -EINVAL;
+
+	if (cfg.tx_type < 0 || cfg.tx_type > HWTSTAMP_TX_ON)
+		return -ERANGE;
+
+	priv->hwts_tx_en = cfg.tx_type;
+
+	switch (cfg.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		priv->hwts_rx_en = 0;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		priv->hwts_rx_en = 1;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	if (priv->hwts_tx_en || priv->hwts_rx_en)
+		at8031_ptp_configure(priv->phydev, true);
+	else
+		at8031_ptp_configure(priv->phydev, false);
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+static int at8031_ptp_probe(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	int i;
+
+	if (!IS_ENABLED(CONFIG_AT8031_PHY_TIMESTAMPING))
+		return 0;
+
+	priv->mii_ts.rxtstamp = at8031_rxtstamp,
+	priv->mii_ts.txtstamp = at8031_txtstamp,
+	priv->mii_ts.hwtstamp = at8031_hwtstamp,
+	priv->mii_ts.ts_info  = at8031_ts_info,
+
+	phydev->mii_ts = &priv->mii_ts;
+
+	/* We have to keep the PLL running otherwise the RTC won't count. */
+	priv->flags |= AT803X_KEEP_PLL_ENABLED;
+	at8031_rtc_set_inc(priv->phydev, NOMINAL_INC_VALUE);
+
+	priv->ptp_info = at8031_ptp_info;
+	priv->ptp_clock = ptp_clock_register(&priv->ptp_info, dev);
+	if (IS_ERR(priv->ptp_clock))
+		return PTR_ERR(priv->ptp_clock);
+
+	INIT_DELAYED_WORK(&priv->ts_work, rx_timestamp_work);
+
+	INIT_LIST_HEAD(&priv->rxts);
+	INIT_LIST_HEAD(&priv->rxpool);
+	for (i = 0; i < MAX_RXTS; i++)
+		list_add(&priv->rx_pool_data[i].list, &priv->rxpool);
+
+	spin_lock_init(&priv->rx_lock);
+	skb_queue_head_init(&priv->rx_queue);
+	skb_queue_head_init(&priv->tx_queue);
+
+	return 0;
+}
+
 static int at803x_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -485,6 +1212,7 @@ static int at803x_probe(struct phy_device *phydev)
 		return -ENOMEM;
 
 	phydev->priv = priv;
+	priv->phydev = phydev;
 
 	return at803x_parse_dt(phydev);
 }
@@ -497,6 +1225,88 @@ static void at803x_remove(struct phy_device *phydev)
 		regulator_disable(priv->vddio);
 }
 
+static irqreturn_t at8031_interrupt(int irq, void *data)
+{
+	struct phy_device *phydev = data;
+	int mask;
+
+	mask = phy_read(phydev, AT803X_INTR_STATUS);
+	if (mask < 0)
+		return IRQ_NONE;
+
+	if (mask & AT803X_INTR_LINK_CHANGE_MASK)
+		phy_mac_interrupt(phydev);
+
+	if (IS_ENABLED(CONFIG_AT8031_PHY_TIMESTAMPING)) {
+		if (mask & AT8031_INTR_RX_PTP)
+			at8031_get_rxts(phydev);
+		if (mask & AT8031_INTR_TX_PTP)
+			at8031_get_txts(phydev);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int at8031_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct at803x_priv *priv;
+	u16 mask;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+	priv->phydev = phydev;
+
+	ret = at8031_ptp_probe(phydev);
+	if (ret)
+		return ret;
+
+	if (!phy_polling_mode(phydev)) {
+		ret = request_threaded_irq(phydev->irq, NULL, at8031_interrupt,
+					   IRQF_ONESHOT | IRQF_SHARED,
+					   phydev_name(phydev), phydev);
+		if (ret)
+			return ret;
+
+		mask = AT803X_INTR_LINK_CHANGE_MASK;
+		if (IS_ENABLED(CONFIG_AT8031_PHY_TIMESTAMPING))
+			mask |= AT8031_INTR_RX_PTP | AT8031_INTR_TX_PTP;
+
+		/* clear pending interrupts */
+		ret = phy_read(phydev, AT803X_INTR_STATUS);
+		if (ret < 0)
+			return ret;
+
+		ret = phy_write(phydev, AT803X_INTR_ENABLE, mask);
+		if (ret)
+			return ret;
+	}
+
+	return at803x_parse_dt(phydev);
+}
+
+static void at8031_remove(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+
+	phydev->mii_ts = NULL;
+
+	cancel_delayed_work_sync(&priv->ts_work);
+
+	skb_queue_purge(&priv->rx_queue);
+	skb_queue_purge(&priv->tx_queue);
+
+	if (priv->ptp_clock)
+		ptp_clock_unregister(priv->ptp_clock);
+
+	if (priv->vddio)
+		regulator_disable(priv->vddio);
+}
+
 static int at803x_clk_out_config(struct phy_device *phydev)
 {
 	struct at803x_priv *priv = phydev->priv;
@@ -585,13 +1395,9 @@ static int at803x_config_intr(struct phy_device *phydev)
 	value = phy_read(phydev, AT803X_INTR_ENABLE);
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
-		value |= AT803X_INTR_ENABLE_AUTONEG_ERR;
-		value |= AT803X_INTR_ENABLE_SPEED_CHANGED;
-		value |= AT803X_INTR_ENABLE_DUPLEX_CHANGED;
-		value |= AT803X_INTR_ENABLE_LINK_FAIL;
-		value |= AT803X_INTR_ENABLE_LINK_SUCCESS;
-
-		err = phy_write(phydev, AT803X_INTR_ENABLE, value);
+		value |= AT803X_INTR_LINK_CHANGE_MASK;
+		err = phy_write(phydev, AT803X_INTR_ENABLE,
+				AT803X_INTR_LINK_CHANGE_MASK);
 	}
 	else
 		err = phy_write(phydev, AT803X_INTR_ENABLE, 0);
@@ -750,8 +1556,9 @@ static struct phy_driver at803x_driver[] = {
 	.phy_id			= ATH8031_PHY_ID,
 	.name			= "Qualcomm Atheros AR8031/AR8033",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
-	.probe			= at803x_probe,
-	.remove			= at803x_remove,
+	.flags			= PHY_HAS_OWN_IRQ_HANDLER,
+	.probe			= at8031_probe,
+	.remove			= at8031_remove,
 	.config_init		= at803x_config_init,
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
@@ -760,8 +1567,6 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.read_status		= at803x_read_status,
 	.aneg_done		= at803x_aneg_done,
-	.ack_interrupt		= &at803x_ack_interrupt,
-	.config_intr		= &at803x_config_intr,
 }, {
 	/* ATHEROS AR9331 */
 	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
-- 
2.20.1

