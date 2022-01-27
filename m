Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F3B49DF35
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239382AbiA0KWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:22:07 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:23791 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239284AbiA0KV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:21:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643278916; x=1674814916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MifV0x68INkfUEkgKVqo7kKCk3R5OaD9DqABIvNDqGk=;
  b=mZaOqpEdrVvvt8KTQ+SOmfOUHWQLCDh6KJ5CnBEbloNk2QuoDZejXjin
   0xuY/V+reHWif+W/tBwJkSviC7q9Z7TK0WlSKQpAQZwexWKwlowvM1z1H
   3uJzIvS0xl9buNyONyEELfmcBMOimAqKCm/1u2dytyG9KuIjkorQn5m5u
   Q/9oFJ7Q5b6JpdTULT7HcS4zx9xp2GKVLVt7L8nvLp/gJms3KBJuFEt5T
   bjtW11ZmmiMZG6HGrsIelWVNUvnP9cznUk9Vf6pSh/PyiBXFSVMXopUnn
   QBqwTq24PUuKPJpeRgEhc1dxgzHj5cDhxKmjM+uEz4xgyZ2lNNEeBUESI
   A==;
IronPort-SDR: UR04fbFaZchsBFBg+59eNGfk2HTGICwsyMdVo5fiuOXTpwvg6QB9lRuUakDO2Y2d29EtcKJvDW
 iRCQSjl/8dpYl6S6IWsVMVOkgS5ku36hCX+deIiQYaaV8vfEyCtZ0sVfP8bSkigeSD6MCYB3fV
 pcRRIpqOQaEtPt1rjkDwq9kZcaPjf4SaALqR9/6I2UxxvWA3hCxanBFgyzxFClZ/JD1b72aQUt
 bb2Xt6G9dE9+vtOmcjVRHeNVt4B9mA8356Cql9BLd2HQAep7JQrp2LBifMz5nsbxVDoIMXhLy6
 mPRxOgiu8SVzKwy+Esr5jEqM
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="160173897"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 03:21:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 03:21:54 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 03:21:52 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <richardcochran@gmail.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 6/7] net: lan966x: Add support for ptp interrupts
Date:   Thu, 27 Jan 2022 11:23:32 +0100
Message-ID: <20220127102333.987195-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220127102333.987195-1-horatiu.vultur@microchip.com>
References: <20220127102333.987195-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing 2-step timestamping the HW will generate a interrupt when it
managed to timestamp a frame. It is the SW responsibility to read it
from the FIFO. This patch adds support for this.

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
index ba65604aef48..4d1f9e476634 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -216,6 +216,123 @@ void lan966x_ptp_txtstamp_release(struct lan966x_port *port,
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

