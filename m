Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AEB4A3FB1
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 10:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242234AbiAaJ7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 04:59:40 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62644 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357995AbiAaJ7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 04:59:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643623163; x=1675159163;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T4B68TJhL8gXy3ICsgN+xS2vyahVFiNs0MmnjHEeLgI=;
  b=rnC0ofLDbAqumienSVnYGXMnFI6qBpGv77a6AT5yMlUgvKm0nPEEiTiR
   n2xHJlA0hTdQe9B3LVoTtlugbPVOyat5Q7156cS+VjBIkFRXrLVWdGSKL
   ZTVnvnMWyvriWTpkVV1EtoEUjz4wv+AI96sPyYHdy2XaQUPZWzLEUNvG1
   C5kvhyMDgk/LX6MATPDzyioEc5zXLXkC6FYsxXffPds2DQYQyE8uKb/oC
   v2YKx9aVaeThLCEse+rT9OElADGjQmlHCEqi/jQlDMZmmGr8E/AJYCMeb
   HQNi6QKD2loyO/ThzB2VSnvXIcuQ9cbh8ncnIT2X2Meqgh1naHCQfTsY6
   A==;
IronPort-SDR: Z5Ts/Xs78v8FVA/3KRMdsoCK+R6qbVu+tIQmptxAuamj0YCbads3Eo1xkakUxa11o2XQQw+fha
 oePFNl7lSt0Chirf13VWZ2dKyod1mIJDvm/pIlVKkHTvo+3hRTP/6ZCN0Ui7A9oiuAHjUT5v3S
 dzi8KBTKFFPLTUT5Gaq6x39/eEqt5Uzb3/D0OrGwceryicO6AN88OvyrwydnK67N1tujUm0IYd
 MKGyCyxJUXtzowKsgvn3jWj/2nBK1kXb+E8qmDMSfDTgzFxL2v0MTKZPerqrsytfyTpDGsTfsL
 kyj62sgrFx+93yffYHQRFtED
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="151958774"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jan 2022 02:59:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 31 Jan 2022 02:59:22 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 31 Jan 2022 02:59:19 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <richardcochran@gmail.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 6/7] net: lan966x: Add support for ptp interrupts
Date:   Mon, 31 Jan 2022 11:01:21 +0100
Message-ID: <20220131100122.423164-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131100122.423164-1-horatiu.vultur@microchip.com>
References: <20220131100122.423164-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing 2-step timestamping the HW will generate an interrupt when it
managed to timestamp a frame. It is the SW responsibility to read it
from the FIFO.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c |  11 ++
 .../ethernet/microchip/lan966x/lan966x_main.h |   2 +
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 117 ++++++++++++++++++
 3 files changed, 130 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 3c19763118ea..e62758bcb998 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -957,6 +957,17 @@ static int lan966x_probe(struct platform_device *pdev)
 			return dev_err_probe(&pdev->dev, err, "Unable to use ana irq");
 	}
 
+	lan966x->ptp_irq = platform_get_irq_byname(pdev, "ptp");
+	if (lan966x->ptp_irq > 0) {
+		err = devm_request_threaded_irq(&pdev->dev, lan966x->ptp_irq, NULL,
+						lan966x_ptp_irq_handler, IRQF_ONESHOT,
+						"ptp irq", lan966x);
+		if (err)
+			return dev_err_probe(&pdev->dev, err, "Unable to use ptp irq");
+
+		lan966x->ptp = 1;
+	}
+
 	/* init switch */
 	lan966x_init(lan966x);
 	lan966x_stats_init(lan966x);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 03c6a4f34ae2..026474c609ea 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -131,6 +131,7 @@ struct lan966x {
 	/* interrupts */
 	int xtr_irq;
 	int ana_irq;
+	int ptp_irq;
 
 	/* worqueue for fdb */
 	struct workqueue_struct *fdb_work;
@@ -276,6 +277,7 @@ int lan966x_ptp_txtstamp_request(struct lan966x_port *port,
 				 struct sk_buff *skb);
 void lan966x_ptp_txtstamp_release(struct lan966x_port *port,
 				  struct sk_buff *skb);
+irqreturn_t lan966x_ptp_irq_handler(int irq, void *args);
 
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index 11c9f9d3aa5b..ae782778d6dd 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -204,6 +204,123 @@ void lan966x_ptp_txtstamp_release(struct lan966x_port *port,
 	spin_unlock_irqrestore(&lan966x->ptp_ts_id_lock, flags);
 }
 
+static void lan966x_get_hwtimestamp(struct lan966x *lan966x,
+				    struct timespec64 *ts,
+				    u32 nsec)
+{
+	/* Read current PTP time to get seconds */
+	unsigned long flags;
+	u32 curr_nsec;
+
+	spin_lock_irqsave(&lan966x->ptp_clock_lock, flags);
+
+	lan_rmw(PTP_PIN_CFG_PIN_ACTION_SET(PTP_PIN_ACTION_SAVE) |
+		PTP_PIN_CFG_PIN_DOM_SET(LAN966X_PHC_PORT) |
+		PTP_PIN_CFG_PIN_SYNC_SET(0),
+		PTP_PIN_CFG_PIN_ACTION |
+		PTP_PIN_CFG_PIN_DOM |
+		PTP_PIN_CFG_PIN_SYNC,
+		lan966x, PTP_PIN_CFG(TOD_ACC_PIN));
+
+	ts->tv_sec = lan_rd(lan966x, PTP_TOD_SEC_LSB(TOD_ACC_PIN));
+	curr_nsec = lan_rd(lan966x, PTP_TOD_NSEC(TOD_ACC_PIN));
+
+	ts->tv_nsec = nsec;
+
+	/* Sec has incremented since the ts was registered */
+	if (curr_nsec < nsec)
+		ts->tv_sec--;
+
+	spin_unlock_irqrestore(&lan966x->ptp_clock_lock, flags);
+}
+
+irqreturn_t lan966x_ptp_irq_handler(int irq, void *args)
+{
+	int budget = LAN966X_MAX_PTP_ID;
+	struct lan966x *lan966x = args;
+
+	while (budget--) {
+		struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
+		struct skb_shared_hwtstamps shhwtstamps;
+		struct lan966x_port *port;
+		struct timespec64 ts;
+		unsigned long flags;
+		u32 val, id, txport;
+		u32 delay;
+
+		val = lan_rd(lan966x, PTP_TWOSTEP_CTRL);
+
+		/* Check if a timestamp can be retrieved */
+		if (!(val & PTP_TWOSTEP_CTRL_VLD))
+			break;
+
+		WARN_ON(val & PTP_TWOSTEP_CTRL_OVFL);
+
+		if (!(val & PTP_TWOSTEP_CTRL_STAMP_TX))
+			continue;
+
+		/* Retrieve the ts Tx port */
+		txport = PTP_TWOSTEP_CTRL_STAMP_PORT_GET(val);
+
+		/* Retrieve its associated skb */
+		port = lan966x->ports[txport];
+
+		/* Retrieve the delay */
+		delay = lan_rd(lan966x, PTP_TWOSTEP_STAMP);
+		delay = PTP_TWOSTEP_STAMP_STAMP_NSEC_GET(delay);
+
+		/* Get next timestamp from fifo, which needs to be the
+		 * rx timestamp which represents the id of the frame
+		 */
+		lan_rmw(PTP_TWOSTEP_CTRL_NXT_SET(1),
+			PTP_TWOSTEP_CTRL_NXT,
+			lan966x, PTP_TWOSTEP_CTRL);
+
+		val = lan_rd(lan966x, PTP_TWOSTEP_CTRL);
+
+		/* Check if a timestamp can be retried */
+		if (!(val & PTP_TWOSTEP_CTRL_VLD))
+			break;
+
+		/* Read RX timestamping to get the ID */
+		id = lan_rd(lan966x, PTP_TWOSTEP_STAMP);
+
+		spin_lock_irqsave(&port->tx_skbs.lock, flags);
+		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
+			if (LAN966X_SKB_CB(skb)->ts_id != id)
+				continue;
+
+			__skb_unlink(skb, &port->tx_skbs);
+			skb_match = skb;
+			break;
+		}
+		spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
+
+		/* Next ts */
+		lan_rmw(PTP_TWOSTEP_CTRL_NXT_SET(1),
+			PTP_TWOSTEP_CTRL_NXT,
+			lan966x, PTP_TWOSTEP_CTRL);
+
+		if (WARN_ON(!skb_match))
+			continue;
+
+		spin_lock(&lan966x->ptp_ts_id_lock);
+		lan966x->ptp_skbs--;
+		spin_unlock(&lan966x->ptp_ts_id_lock);
+
+		/* Get the h/w timestamp */
+		lan966x_get_hwtimestamp(lan966x, &ts, delay);
+
+		/* Set the timestamp into the skb */
+		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
+		skb_tstamp_tx(skb_match, &shhwtstamps);
+
+		dev_kfree_skb_any(skb_match);
+	}
+
+	return IRQ_HANDLED;
+}
+
 static int lan966x_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct lan966x_phc *phc = container_of(ptp, struct lan966x_phc, info);
-- 
2.33.0

