Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55DC3F4BEB
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 15:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhHWNy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 09:54:26 -0400
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:46049 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230141AbhHWNyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 09:54:22 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id A794B23729;
        Mon, 23 Aug 2021 13:53:34 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-17-244.trex.outbound.svc.cluster.local [100.96.17.244])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 1427B235CA;
        Mon, 23 Aug 2021 13:53:32 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.17.244 (trex/6.3.3);
        Mon, 23 Aug 2021 13:53:34 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Drop-Gusty: 33087500200a6677_1629726814517_1556341935
X-MC-Loop-Signature: 1629726814517:2615738516
X-MC-Ingress-Time: 1629726814517
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=91Ky+mTvFTTcRvNjKXZy3yyNWtX96N02xDpLUUOeLF4=; b=SHMqImL4/ub22degJzyVwwGYZm
        bYvl92gy+Ct71ZzHKbASxqC2sV0WIgCAxI/7JB/1hn/HMqbllf+Ik/bvayFhER52O0hucTFjlMCSm
        rDBK5k0w3CutxpKozskt9LWn0RBDYKujhLsu7AzgaBoE2RDSMV1r4d1f3UOhZkgvRBjtd/2zkgBTZ
        Afim52jlg/TwzuM0beOhgeZ7UGMfcZcK+J8flngDMme16Z5qZ29KkBD9sOewOKYCHDG7peItKLvhB
        UnSUthTjOwYb7VQAyRsfcBzhMeOLKIeFc1PRMX9ut7TFk18ndrcR7nQN5qyObzm5+pBPaEjmUKmwn
        OOLqP/Dw==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51812 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIAOJ-003PzY-Cx; Mon, 23 Aug 2021 14:53:31 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 07/10] lan78xx: Fix partial packet errors on suspend/resume
Date:   Mon, 23 Aug 2021 14:52:26 +0100
Message-Id: <20210823135229.36581-8-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
References: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC can get out of step with the internal packet FIFOs if the
system goes to sleep when the link is active, especially at high
data rates. This can result in partial frames in the packet FIFOs
that in result in malformed frames being delivered to the host.
This occurs because the driver does not enable/disable the internal
packet FIFOs in step with the corresponding MAC data path. The
following changes fix this problem.

Update code that enables/disables the MAC receiver and transmitter
to the more general Rx and Tx data path, where the data path in each
direction consists of both the MAC function (Tx or Rx) and the
corresponding packet FIFO.

In the receive path the packet FIFO must be enabled before the MAC
receiver but disabled after the MAC receiver.

In the transmit path the opposite is true: the packet FIFO must be
enabled after the MAC transmitter but disabled before the MAC
transmitter.

The packet FIFOs can be flushed safely once the corresponding data
path is stopped.

This patch also adds checks for errors during data path enable and
disable. There is an immediate return from the calling function if
an error is detected. This prevents a cascade of errors that would
otherwise occur.

To maintain consistency with the data path error check and early
exit policy, each register access in lan78xx_suspend() and
lan78xx_resume() is checked for errors. If an error is detected
there is an immediate exit from the calling function.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 546 ++++++++++++++++++++++++++++++--------
 1 file changed, 442 insertions(+), 104 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 9be823616dd7..096304c1b5f4 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -100,6 +100,12 @@
 /* statistic update interval (mSec) */
 #define STAT_UPDATE_TIMER		(1 * 1000)
 
+/* time to wait for MAC or FCT to stop (jiffies) */
+#define HW_DISABLE_TIMEOUT		(HZ / 10)
+
+/* time to wait between polling MAC or FCT state (ms) */
+#define HW_DISABLE_DELAY_MS		1
+
 /* defines interrupts from interrupt EP */
 #define MAX_INT_EP			(32)
 #define INT_EP_INTEP			(31)
@@ -493,6 +499,26 @@ static int lan78xx_write_reg(struct lan78xx_net *dev, u32 index, u32 data)
 	return ret;
 }
 
+static int lan78xx_update_reg(struct lan78xx_net *dev, u32 reg, u32 mask,
+			      u32 data)
+{
+	int ret;
+	u32 buf;
+
+	ret = lan78xx_read_reg(dev, reg, &buf);
+	if (ret < 0)
+		return ret;
+
+	buf &= ~mask;
+	buf |= (mask & data);
+
+	ret = lan78xx_write_reg(dev, reg, buf);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static int lan78xx_read_stats(struct lan78xx_net *dev,
 			      struct lan78xx_statstage *data)
 {
@@ -2533,26 +2559,186 @@ static void lan78xx_init_ltm(struct lan78xx_net *dev)
 	lan78xx_write_reg(dev, LTM_INACTIVE1, regs[5]);
 }
 
+static int lan78xx_start_hw(struct lan78xx_net *dev, u32 reg, u32 hw_enable)
+{
+	return lan78xx_update_reg(dev, reg, hw_enable, hw_enable);
+}
+
+static int lan78xx_stop_hw(struct lan78xx_net *dev, u32 reg, u32 hw_enabled,
+			   u32 hw_disabled)
+{
+	unsigned long timeout;
+	bool stopped = true;
+	int ret;
+	u32 buf;
+
+	/* Stop the h/w block (if not already stopped) */
+
+	ret = lan78xx_read_reg(dev, reg, &buf);
+	if (ret < 0)
+		return ret;
+
+	if (buf & hw_enabled) {
+		buf &= ~hw_enabled;
+
+		ret = lan78xx_write_reg(dev, reg, buf);
+		if (ret < 0)
+			return ret;
+
+		stopped = false;
+		timeout = jiffies + HW_DISABLE_TIMEOUT;
+		do  {
+			ret = lan78xx_read_reg(dev, reg, &buf);
+			if (ret < 0)
+				return ret;
+
+			if (buf & hw_disabled)
+				stopped = true;
+			else
+				msleep(HW_DISABLE_DELAY_MS);
+		} while (!stopped && !time_after(jiffies, timeout));
+	}
+
+	ret = stopped ? 0 : -ETIME;
+
+	return ret;
+}
+
+static int lan78xx_flush_fifo(struct lan78xx_net *dev, u32 reg, u32 fifo_flush)
+{
+	return lan78xx_update_reg(dev, reg, fifo_flush, fifo_flush);
+}
+
+static int lan78xx_start_tx_path(struct lan78xx_net *dev)
+{
+	int ret;
+
+	netif_dbg(dev, drv, dev->net, "start tx path");
+
+	/* Start the MAC transmitter */
+
+	ret = lan78xx_start_hw(dev, MAC_TX, MAC_TX_TXEN_);
+	if (ret < 0)
+		return ret;
+
+	/* Start the Tx FIFO */
+
+	ret = lan78xx_start_hw(dev, FCT_TX_CTL, FCT_TX_CTL_EN_);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int lan78xx_stop_tx_path(struct lan78xx_net *dev)
+{
+	int ret;
+
+	netif_dbg(dev, drv, dev->net, "stop tx path");
+
+	/* Stop the Tx FIFO */
+
+	ret = lan78xx_stop_hw(dev, FCT_TX_CTL, FCT_TX_CTL_EN_, FCT_TX_CTL_DIS_);
+	if (ret < 0)
+		return ret;
+
+	/* Stop the MAC transmitter */
+
+	ret = lan78xx_stop_hw(dev, MAC_TX, MAC_TX_TXEN_, MAC_TX_TXD_);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/* The caller must ensure the Tx path is stopped before calling
+ * lan78xx_flush_tx_fifo().
+ */
+static int lan78xx_flush_tx_fifo(struct lan78xx_net *dev)
+{
+	return lan78xx_flush_fifo(dev, FCT_TX_CTL, FCT_TX_CTL_RST_);
+}
+
+static int lan78xx_start_rx_path(struct lan78xx_net *dev)
+{
+	int ret;
+
+	netif_dbg(dev, drv, dev->net, "start rx path");
+
+	/* Start the Rx FIFO */
+
+	ret = lan78xx_start_hw(dev, FCT_RX_CTL, FCT_RX_CTL_EN_);
+	if (ret < 0)
+		return ret;
+
+	/* Start the MAC receiver*/
+
+	ret = lan78xx_start_hw(dev, MAC_RX, MAC_RX_RXEN_);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int lan78xx_stop_rx_path(struct lan78xx_net *dev)
+{
+	int ret;
+
+	netif_dbg(dev, drv, dev->net, "stop rx path");
+
+	/* Stop the MAC receiver */
+
+	ret = lan78xx_stop_hw(dev, MAC_RX, MAC_RX_RXEN_, MAC_RX_RXD_);
+	if (ret < 0)
+		return ret;
+
+	/* Stop the Rx FIFO */
+
+	ret = lan78xx_stop_hw(dev, FCT_RX_CTL, FCT_RX_CTL_EN_, FCT_RX_CTL_DIS_);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/* The caller must ensure the Rx path is stopped before calling
+ * lan78xx_flush_rx_fifo().
+ */
+static int lan78xx_flush_rx_fifo(struct lan78xx_net *dev)
+{
+	return lan78xx_flush_fifo(dev, FCT_RX_CTL, FCT_RX_CTL_RST_);
+}
+
 static int lan78xx_reset(struct lan78xx_net *dev)
 {
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
-	u32 buf;
-	int ret = 0;
 	unsigned long timeout;
+	int ret;
+	u32 buf;
 	u8 sig;
 
 	ret = lan78xx_read_reg(dev, HW_CFG, &buf);
+	if (ret < 0)
+		return ret;
+
 	buf |= HW_CFG_LRST_;
+
 	ret = lan78xx_write_reg(dev, HW_CFG, buf);
+	if (ret < 0)
+		return ret;
 
 	timeout = jiffies + HZ;
 	do {
 		mdelay(1);
 		ret = lan78xx_read_reg(dev, HW_CFG, &buf);
+		if (ret < 0)
+			return ret;
+
 		if (time_after(jiffies, timeout)) {
 			netdev_warn(dev->net,
 				    "timeout on completion of LiteReset");
-			return -EIO;
+			ret = -ETIME;
+			return ret;
 		}
 	} while (buf & HW_CFG_LRST_);
 
@@ -2560,13 +2746,22 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 
 	/* save DEVID for later usage */
 	ret = lan78xx_read_reg(dev, ID_REV, &buf);
+	if (ret < 0)
+		return ret;
+
 	dev->chipid = (buf & ID_REV_CHIP_ID_MASK_) >> 16;
 	dev->chiprev = buf & ID_REV_CHIP_REV_MASK_;
 
 	/* Respond to the IN token with a NAK */
 	ret = lan78xx_read_reg(dev, USB_CFG0, &buf);
+	if (ret < 0)
+		return ret;
+
 	buf |= USB_CFG_BIR_;
+
 	ret = lan78xx_write_reg(dev, USB_CFG0, buf);
+	if (ret < 0)
+		return ret;
 
 	/* Init LTM */
 	lan78xx_init_ltm(dev);
@@ -2589,53 +2784,99 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 	}
 
 	ret = lan78xx_write_reg(dev, BURST_CAP, buf);
+	if (ret < 0)
+		return ret;
 	ret = lan78xx_write_reg(dev, BULK_IN_DLY, DEFAULT_BULK_IN_DELAY);
+	if (ret < 0)
+		return ret;
 
 	ret = lan78xx_read_reg(dev, HW_CFG, &buf);
+	if (ret < 0)
+		return ret;
+
 	buf |= HW_CFG_MEF_;
+
 	ret = lan78xx_write_reg(dev, HW_CFG, buf);
+	if (ret < 0)
+		return ret;
 
 	ret = lan78xx_read_reg(dev, USB_CFG0, &buf);
+	if (ret < 0)
+		return ret;
 	buf |= USB_CFG_BCE_;
+
 	ret = lan78xx_write_reg(dev, USB_CFG0, buf);
+	if (ret < 0)
+		return ret;
 
 	/* set FIFO sizes */
 	buf = (MAX_RX_FIFO_SIZE - 512) / 512;
 	ret = lan78xx_write_reg(dev, FCT_RX_FIFO_END, buf);
+	if (ret < 0)
+		return ret;
 
 	buf = (MAX_TX_FIFO_SIZE - 512) / 512;
 	ret = lan78xx_write_reg(dev, FCT_TX_FIFO_END, buf);
+	if (ret < 0)
+		return ret;
 
 	ret = lan78xx_write_reg(dev, INT_STS, INT_STS_CLEAR_ALL_);
+	if (ret < 0)
+		return ret;
 	ret = lan78xx_write_reg(dev, FLOW, 0);
+	if (ret < 0)
+		return ret;
 	ret = lan78xx_write_reg(dev, FCT_FLOW, 0);
+	if (ret < 0)
+		return ret;
 
 	/* Don't need rfe_ctl_lock during initialisation */
 	ret = lan78xx_read_reg(dev, RFE_CTL, &pdata->rfe_ctl);
+	if (ret < 0)
+		return ret;
+
 	pdata->rfe_ctl |= RFE_CTL_BCAST_EN_ | RFE_CTL_DA_PERFECT_;
+
 	ret = lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
+	if (ret < 0)
+		return ret;
 
 	/* Enable or disable checksum offload engines */
-	lan78xx_set_features(dev->net, dev->net->features);
+	ret = lan78xx_set_features(dev->net, dev->net->features);
+	if (ret < 0)
+		return ret;
 
 	lan78xx_set_multicast(dev->net);
 
 	/* reset PHY */
 	ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+	if (ret < 0)
+		return ret;
+
 	buf |= PMT_CTL_PHY_RST_;
+
 	ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+	if (ret < 0)
+		return ret;
 
 	timeout = jiffies + HZ;
 	do {
 		mdelay(1);
 		ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+		if (ret < 0)
+			return ret;
+
 		if (time_after(jiffies, timeout)) {
 			netdev_warn(dev->net, "timeout waiting for PHY Reset");
-			return -EIO;
+			ret = -ETIME;
+			return ret;
 		}
 	} while ((buf & PMT_CTL_PHY_RST_) || !(buf & PMT_CTL_READY_));
 
 	ret = lan78xx_read_reg(dev, MAC_CR, &buf);
+	if (ret < 0)
+		return ret;
+
 	/* LAN7801 only has RGMII mode */
 	if (dev->chipid == ID_REV_CHIP_ID_7801_)
 		buf &= ~MAC_CR_GMII_EN_;
@@ -2649,27 +2890,21 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 		}
 	}
 	ret = lan78xx_write_reg(dev, MAC_CR, buf);
+	if (ret < 0)
+		return ret;
 
-	ret = lan78xx_read_reg(dev, MAC_TX, &buf);
-	buf |= MAC_TX_TXEN_;
-	ret = lan78xx_write_reg(dev, MAC_TX, buf);
-
-	ret = lan78xx_read_reg(dev, FCT_TX_CTL, &buf);
-	buf |= FCT_TX_CTL_EN_;
-	ret = lan78xx_write_reg(dev, FCT_TX_CTL, buf);
+	ret = lan78xx_start_tx_path(dev);
+	if (ret < 0)
+		return ret;
 
 	ret = lan78xx_set_rx_max_frame_length(dev,
 					      dev->net->mtu + VLAN_ETH_HLEN);
+	if (ret < 0)
+		return ret;
 
-	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
-	buf |= MAC_RX_RXEN_;
-	ret = lan78xx_write_reg(dev, MAC_RX, buf);
-
-	ret = lan78xx_read_reg(dev, FCT_RX_CTL, &buf);
-	buf |= FCT_RX_CTL_EN_;
-	ret = lan78xx_write_reg(dev, FCT_RX_CTL, buf);
+	ret = lan78xx_start_rx_path(dev);
 
-	return 0;
+	return ret;
 }
 
 static void lan78xx_init_stats(struct lan78xx_net *dev)
@@ -2705,7 +2940,7 @@ static int lan78xx_open(struct net_device *net)
 
 	ret = usb_autopm_get_interface(dev->intf);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	phy_start(net->phydev);
 
@@ -2733,7 +2968,6 @@ static int lan78xx_open(struct net_device *net)
 done:
 	usb_autopm_put_interface(dev->intf);
 
-out:
 	return ret;
 }
 
@@ -3882,35 +4116,49 @@ static u16 lan78xx_wakeframe_crc16(const u8 *buf, int len)
 
 static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 {
-	u32 buf;
-	int mask_index;
-	u16 crc;
-	u32 temp_wucsr;
-	u32 temp_pmt_ctl;
 	const u8 ipv4_multicast[3] = { 0x01, 0x00, 0x5E };
 	const u8 ipv6_multicast[3] = { 0x33, 0x33 };
 	const u8 arp_type[2] = { 0x08, 0x06 };
+	u32 temp_pmt_ctl;
+	int mask_index;
+	u32 temp_wucsr;
+	u32 buf;
+	u16 crc;
+	int ret;
 
-	lan78xx_read_reg(dev, MAC_TX, &buf);
-	buf &= ~MAC_TX_TXEN_;
-	lan78xx_write_reg(dev, MAC_TX, buf);
-	lan78xx_read_reg(dev, MAC_RX, &buf);
-	buf &= ~MAC_RX_RXEN_;
-	lan78xx_write_reg(dev, MAC_RX, buf);
+	ret = lan78xx_stop_tx_path(dev);
+	if (ret < 0)
+		return ret;
+	ret = lan78xx_stop_rx_path(dev);
+	if (ret < 0)
+		return ret;
 
-	lan78xx_write_reg(dev, WUCSR, 0);
-	lan78xx_write_reg(dev, WUCSR2, 0);
-	lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
+	ret = lan78xx_write_reg(dev, WUCSR, 0);
+	if (ret < 0)
+		return ret;
+	ret = lan78xx_write_reg(dev, WUCSR2, 0);
+	if (ret < 0)
+		return ret;
+	ret = lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
+	if (ret < 0)
+		return ret;
 
 	temp_wucsr = 0;
 
 	temp_pmt_ctl = 0;
-	lan78xx_read_reg(dev, PMT_CTL, &temp_pmt_ctl);
+
+	ret = lan78xx_read_reg(dev, PMT_CTL, &temp_pmt_ctl);
+	if (ret < 0)
+		return ret;
+
 	temp_pmt_ctl &= ~PMT_CTL_RES_CLR_WKP_EN_;
 	temp_pmt_ctl |= PMT_CTL_RES_CLR_WKP_STS_;
 
-	for (mask_index = 0; mask_index < NUM_OF_WUF_CFG; mask_index++)
-		lan78xx_write_reg(dev, WUF_CFG(mask_index), 0);
+	for (mask_index = 0; mask_index < NUM_OF_WUF_CFG; mask_index++) {
+		ret = lan78xx_write_reg(dev, WUF_CFG(mask_index), 0);
+		if (ret < 0)
+			return ret;
+	}
 
 	mask_index = 0;
 	if (wol & WAKE_PHY) {
@@ -3939,30 +4187,52 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 
 		/* set WUF_CFG & WUF_MASK for IPv4 Multicast */
 		crc = lan78xx_wakeframe_crc16(ipv4_multicast, 3);
-		lan78xx_write_reg(dev, WUF_CFG(mask_index),
-				  WUF_CFGX_EN_ |
-				  WUF_CFGX_TYPE_MCAST_ |
-				  (0 << WUF_CFGX_OFFSET_SHIFT_) |
-				  (crc & WUF_CFGX_CRC16_MASK_));
-
-		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 7);
-		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
-		lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
-		lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
+		ret = lan78xx_write_reg(dev, WUF_CFG(mask_index),
+					WUF_CFGX_EN_ |
+					WUF_CFGX_TYPE_MCAST_ |
+					(0 << WUF_CFGX_OFFSET_SHIFT_) |
+					(crc & WUF_CFGX_CRC16_MASK_));
+		if (ret < 0)
+			return ret;
+
+		ret = lan78xx_write_reg(dev, WUF_MASK0(mask_index), 7);
+		if (ret < 0)
+			return ret;
+		ret = lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
+		if (ret < 0)
+			return ret;
+		ret = lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
+		if (ret < 0)
+			return ret;
+		ret = lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
+		if (ret < 0)
+			return ret;
+
 		mask_index++;
 
 		/* for IPv6 Multicast */
 		crc = lan78xx_wakeframe_crc16(ipv6_multicast, 2);
-		lan78xx_write_reg(dev, WUF_CFG(mask_index),
-				  WUF_CFGX_EN_ |
-				  WUF_CFGX_TYPE_MCAST_ |
-				  (0 << WUF_CFGX_OFFSET_SHIFT_) |
-				  (crc & WUF_CFGX_CRC16_MASK_));
-
-		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 3);
-		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
-		lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
-		lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
+		ret = lan78xx_write_reg(dev, WUF_CFG(mask_index),
+					WUF_CFGX_EN_ |
+					WUF_CFGX_TYPE_MCAST_ |
+					(0 << WUF_CFGX_OFFSET_SHIFT_) |
+					(crc & WUF_CFGX_CRC16_MASK_));
+		if (ret < 0)
+			return ret;
+
+		ret = lan78xx_write_reg(dev, WUF_MASK0(mask_index), 3);
+		if (ret < 0)
+			return ret;
+		ret = lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
+		if (ret < 0)
+			return ret;
+		ret = lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
+		if (ret < 0)
+			return ret;
+		ret = lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
+		if (ret < 0)
+			return ret;
+
 		mask_index++;
 
 		temp_pmt_ctl |= PMT_CTL_WOL_EN_;
@@ -3983,16 +4253,27 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		 * for packettype (offset 12,13) = ARP (0x0806)
 		 */
 		crc = lan78xx_wakeframe_crc16(arp_type, 2);
-		lan78xx_write_reg(dev, WUF_CFG(mask_index),
-				  WUF_CFGX_EN_ |
-				  WUF_CFGX_TYPE_ALL_ |
-				  (0 << WUF_CFGX_OFFSET_SHIFT_) |
-				  (crc & WUF_CFGX_CRC16_MASK_));
-
-		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 0x3000);
-		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
-		lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
-		lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
+		ret = lan78xx_write_reg(dev, WUF_CFG(mask_index),
+					WUF_CFGX_EN_ |
+					WUF_CFGX_TYPE_ALL_ |
+					(0 << WUF_CFGX_OFFSET_SHIFT_) |
+					(crc & WUF_CFGX_CRC16_MASK_));
+		if (ret < 0)
+			return ret;
+
+		ret = lan78xx_write_reg(dev, WUF_MASK0(mask_index), 0x3000);
+		if (ret < 0)
+			return ret;
+		ret = lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
+		if (ret < 0)
+			return ret;
+		ret = lan78xx_write_reg(dev, WUF_MASK2(mask_index), 0);
+		if (ret < 0)
+			return ret;
+		ret = lan78xx_write_reg(dev, WUF_MASK3(mask_index), 0);
+		if (ret < 0)
+			return ret;
+
 		mask_index++;
 
 		temp_pmt_ctl |= PMT_CTL_WOL_EN_;
@@ -4000,7 +4281,9 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		temp_pmt_ctl |= PMT_CTL_SUS_MODE_0_;
 	}
 
-	lan78xx_write_reg(dev, WUCSR, temp_wucsr);
+	ret = lan78xx_write_reg(dev, WUCSR, temp_wucsr);
+	if (ret < 0)
+		return ret;
 
 	/* when multiple WOL bits are set */
 	if (hweight_long((unsigned long)wol) > 1) {
@@ -4008,24 +4291,29 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		temp_pmt_ctl &= ~PMT_CTL_SUS_MODE_MASK_;
 		temp_pmt_ctl |= PMT_CTL_SUS_MODE_0_;
 	}
-	lan78xx_write_reg(dev, PMT_CTL, temp_pmt_ctl);
+	ret = lan78xx_write_reg(dev, PMT_CTL, temp_pmt_ctl);
+	if (ret < 0)
+		return ret;
 
 	/* clear WUPS */
-	lan78xx_read_reg(dev, PMT_CTL, &buf);
+	ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+	if (ret < 0)
+		return ret;
+
 	buf |= PMT_CTL_WUPS_MASK_;
-	lan78xx_write_reg(dev, PMT_CTL, buf);
 
-	lan78xx_read_reg(dev, MAC_RX, &buf);
-	buf |= MAC_RX_RXEN_;
-	lan78xx_write_reg(dev, MAC_RX, buf);
+	ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+	if (ret < 0)
+		return ret;
 
-	return 0;
+	ret = lan78xx_start_rx_path(dev);
+
+	return ret;
 }
 
 static int lan78xx_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct lan78xx_net *dev = usb_get_intfdata(intf);
-	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
 	u32 buf;
 	int ret;
 
@@ -4043,13 +4331,19 @@ static int lan78xx_suspend(struct usb_interface *intf, pm_message_t message)
 			spin_unlock_irq(&dev->txq.lock);
 		}
 
-		/* stop TX & RX */
-		ret = lan78xx_read_reg(dev, MAC_TX, &buf);
-		buf &= ~MAC_TX_TXEN_;
-		ret = lan78xx_write_reg(dev, MAC_TX, buf);
-		ret = lan78xx_read_reg(dev, MAC_RX, &buf);
-		buf &= ~MAC_RX_RXEN_;
-		ret = lan78xx_write_reg(dev, MAC_RX, buf);
+		/* stop RX */
+		ret = lan78xx_stop_rx_path(dev);
+		if (ret < 0)
+			return ret;
+
+		ret = lan78xx_flush_rx_fifo(dev);
+		if (ret < 0)
+			return ret;
+
+		/* stop Tx */
+		ret = lan78xx_stop_tx_path(dev);
+		if (ret < 0)
+			return ret;
 
 		/* empty out the rx and queues */
 		netif_device_detach(dev->net);
@@ -4065,26 +4359,39 @@ static int lan78xx_suspend(struct usb_interface *intf, pm_message_t message)
 
 		if (PMSG_IS_AUTO(message)) {
 			/* auto suspend (selective suspend) */
-			ret = lan78xx_read_reg(dev, MAC_TX, &buf);
-			buf &= ~MAC_TX_TXEN_;
-			ret = lan78xx_write_reg(dev, MAC_TX, buf);
-			ret = lan78xx_read_reg(dev, MAC_RX, &buf);
-			buf &= ~MAC_RX_RXEN_;
-			ret = lan78xx_write_reg(dev, MAC_RX, buf);
+			ret = lan78xx_stop_tx_path(dev);
+			if (ret < 0)
+				return ret;
+
+			ret = lan78xx_stop_rx_path(dev);
+			if (ret < 0)
+				return ret;
 
 			ret = lan78xx_write_reg(dev, WUCSR, 0);
+			if (ret < 0)
+				return ret;
 			ret = lan78xx_write_reg(dev, WUCSR2, 0);
+			if (ret < 0)
+				return ret;
 			ret = lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
+			if (ret < 0)
+				return ret;
 
 			/* set goodframe wakeup */
 			ret = lan78xx_read_reg(dev, WUCSR, &buf);
+			if (ret < 0)
+				return ret;
 
 			buf |= WUCSR_RFE_WAKE_EN_;
 			buf |= WUCSR_STORE_WAKE_;
 
 			ret = lan78xx_write_reg(dev, WUCSR, buf);
+			if (ret < 0)
+				return ret;
 
 			ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+			if (ret < 0)
+				return ret;
 
 			buf &= ~PMT_CTL_RES_CLR_WKP_EN_;
 			buf |= PMT_CTL_RES_CLR_WKP_STS_;
@@ -4095,18 +4402,30 @@ static int lan78xx_suspend(struct usb_interface *intf, pm_message_t message)
 			buf |= PMT_CTL_SUS_MODE_3_;
 
 			ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+			if (ret < 0)
+				return ret;
 
 			ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+			if (ret < 0)
+				return ret;
 
 			buf |= PMT_CTL_WUPS_MASK_;
 
 			ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+			if (ret < 0)
+				return ret;
 
-			ret = lan78xx_read_reg(dev, MAC_RX, &buf);
-			buf |= MAC_RX_RXEN_;
-			ret = lan78xx_write_reg(dev, MAC_RX, buf);
+			ret = lan78xx_start_rx_path(dev);
+			if (ret < 0)
+				return ret;
 		} else {
-			lan78xx_set_suspend(dev, pdata->wol);
+			struct lan78xx_priv *pdata;
+
+			pdata = (struct lan78xx_priv *)(dev->data[0]);
+
+			ret = lan78xx_set_suspend(dev, pdata->wol);
+			if (ret < 0)
+				return ret;
 		}
 	}
 
@@ -4121,7 +4440,6 @@ static int lan78xx_resume(struct usb_interface *intf)
 	struct sk_buff *skb;
 	struct urb *res;
 	int ret;
-	u32 buf;
 
 	if (!timer_pending(&dev->stat_monitor)) {
 		dev->delta = 1;
@@ -4129,10 +4447,17 @@ static int lan78xx_resume(struct usb_interface *intf)
 			  jiffies + STAT_UPDATE_TIMER);
 	}
 
+	ret = lan78xx_flush_tx_fifo(dev);
+	if (ret < 0)
+		return ret;
+
 	if (!--dev->suspend_count) {
 		/* resume interrupt URBs */
-		if (dev->urb_intr && test_bit(EVENT_DEV_OPEN, &dev->flags))
-			usb_submit_urb(dev->urb_intr, GFP_NOIO);
+		if (dev->urb_intr && test_bit(EVENT_DEV_OPEN, &dev->flags)) {
+			ret = usb_submit_urb(dev->urb_intr, GFP_NOIO);
+			if (ret < 0)
+				return ret;
+		}
 
 		spin_lock_irq(&dev->txq.lock);
 		while ((res = usb_get_from_anchor(&dev->deferred))) {
@@ -4159,13 +4484,21 @@ static int lan78xx_resume(struct usb_interface *intf)
 	}
 
 	ret = lan78xx_write_reg(dev, WUCSR2, 0);
+	if (ret < 0)
+		return ret;
 	ret = lan78xx_write_reg(dev, WUCSR, 0);
+	if (ret < 0)
+		return ret;
 	ret = lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
+	if (ret < 0)
+		return ret;
 
 	ret = lan78xx_write_reg(dev, WUCSR2, WUCSR2_NS_RCD_ |
 					     WUCSR2_ARP_RCD_ |
 					     WUCSR2_IPV6_TCPSYN_RCD_ |
 					     WUCSR2_IPV4_TCPSYN_RCD_);
+	if (ret < 0)
+		return ret;
 
 	ret = lan78xx_write_reg(dev, WUCSR, WUCSR_EEE_TX_WAKE_ |
 					    WUCSR_EEE_RX_WAKE_ |
@@ -4174,23 +4507,28 @@ static int lan78xx_resume(struct usb_interface *intf)
 					    WUCSR_WUFR_ |
 					    WUCSR_MPR_ |
 					    WUCSR_BCST_FR_);
+	if (ret < 0)
+		return ret;
 
-	ret = lan78xx_read_reg(dev, MAC_TX, &buf);
-	buf |= MAC_TX_TXEN_;
-	ret = lan78xx_write_reg(dev, MAC_TX, buf);
+	ret = lan78xx_start_tx_path(dev);
 
-	return 0;
+	return ret;
 }
 
 static int lan78xx_reset_resume(struct usb_interface *intf)
 {
 	struct lan78xx_net *dev = usb_get_intfdata(intf);
+	int ret;
 
-	lan78xx_reset(dev);
+	ret = lan78xx_reset(dev);
+	if (ret < 0)
+		return ret;
 
 	phy_start(dev->net->phydev);
 
-	return lan78xx_resume(intf);
+	ret = lan78xx_resume(intf);
+
+	return ret;
 }
 
 static const struct usb_device_id products[] = {
-- 
2.25.1

