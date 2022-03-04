Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2F04CD312
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 12:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbiCDLJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 06:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239477AbiCDLIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 06:08:05 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1941B0C6E;
        Fri,  4 Mar 2022 03:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646392033; x=1677928033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jM7yRSu/ZiNit62yz6tggOf1igCILXgyCsS7vCEnUuo=;
  b=NR/DKsCNIQckV04EIIOneMtC69dMiuZFPQOQFmMTy3RsUAz0BwwOOXHE
   WxOBnS7/XeUukSQJMe0xHblY+0IuJyb8TY0VdqeGdWPY7DR3lQu0b5ZLS
   s6DwAtHiEhJFn93zc+tZ9ZbDGzKKzn5DINGwn/BaxdaZ1OcUb2FUGcduY
   ZAxFtXzu9emhLnFubtkdAwhwV5suFjSDl/ANOET+F05dt0Mc0ENxEc4WJ
   eoAnuE37sPT9UzKF1h83tSmF7IrszJFPAXT8L1kqcm7X2jeMQvpH9Sjap
   TnsgzBg6R/vT2v3xwj3VICWy5rtDBULrSnpgOYAuWDkCIMkLFjUtRiUU2
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,155,1643698800"; 
   d="scan'208";a="150853681"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 04:06:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 04:06:54 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 04:06:51 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <casper.casan@gmail.com>,
        <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 8/9] net: sparx5: Add support for ptp interrupts
Date:   Fri, 4 Mar 2022 12:08:59 +0100
Message-ID: <20220304110900.3199904-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
References: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing 2-step timestamping the HW will generate an interrupt when it
managed to timestamp a frame. It is the SW responsibility to read it
from the FIFO.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_main.c   |  13 ++
 .../ethernet/microchip/sparx5/sparx5_main.h   |   2 +
 .../ethernet/microchip/sparx5/sparx5_ptp.c    | 119 ++++++++++++++++++
 3 files changed, 134 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index f72da757d0fa..5f7c7030ce03 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -693,6 +693,18 @@ static int sparx5_start(struct sparx5 *sparx5)
 	} else {
 		sparx5->xtr_irq = -ENXIO;
 	}
+
+	if (sparx5->ptp_irq >= 0) {
+		err = devm_request_threaded_irq(sparx5->dev, sparx5->ptp_irq,
+						NULL, sparx5_ptp_irq_handler,
+						IRQF_ONESHOT, "sparx5-ptp",
+						sparx5);
+		if (err)
+			sparx5->ptp_irq = -ENXIO;
+
+		sparx5->ptp = 1;
+	}
+
 	return err;
 }
 
@@ -809,6 +821,7 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 
 	sparx5->fdma_irq = platform_get_irq_byname(sparx5->pdev, "fdma");
 	sparx5->xtr_irq = platform_get_irq_byname(sparx5->pdev, "xtr");
+	sparx5->ptp_irq = platform_get_irq_byname(sparx5->pdev, "ptp");
 
 	/* Read chip ID to check CPU interface */
 	sparx5->chip_id = spx5_rd(sparx5, GCB_CHIP_ID);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 16d691fdee65..33892dfc3b2f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -270,6 +270,7 @@ struct sparx5 {
 	spinlock_t ptp_ts_id_lock; /* lock for ts_id */
 	struct mutex ptp_lock; /* lock for ptp interface state */
 	u16 ptp_skbs;
+	int ptp_irq;
 };
 
 /* sparx5_switchdev.c */
@@ -355,6 +356,7 @@ int sparx5_ptp_txtstamp_request(struct sparx5_port *port,
 				struct sk_buff *skb);
 void sparx5_ptp_txtstamp_release(struct sparx5_port *port,
 				 struct sk_buff *skb);
+irqreturn_t sparx5_ptp_irq_handler(int irq, void *args);
 
 /* Clock period in picoseconds */
 static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index 976817d826ac..fa377f6e7e08 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -271,6 +271,125 @@ void sparx5_ptp_txtstamp_release(struct sparx5_port *port,
 	spin_unlock_irqrestore(&sparx5->ptp_ts_id_lock, flags);
 }
 
+static void sparx5_get_hwtimestamp(struct sparx5 *sparx5,
+				   struct timespec64 *ts,
+				   u32 nsec)
+{
+	/* Read current PTP time to get seconds */
+	unsigned long flags;
+	u32 curr_nsec;
+
+	spin_lock_irqsave(&sparx5->ptp_clock_lock, flags);
+
+	spx5_rmw(PTP_PTP_PIN_CFG_PTP_PIN_ACTION_SET(PTP_PIN_ACTION_SAVE) |
+		 PTP_PTP_PIN_CFG_PTP_PIN_DOM_SET(SPARX5_PHC_PORT) |
+		 PTP_PTP_PIN_CFG_PTP_PIN_SYNC_SET(0),
+		 PTP_PTP_PIN_CFG_PTP_PIN_ACTION |
+		 PTP_PTP_PIN_CFG_PTP_PIN_DOM |
+		 PTP_PTP_PIN_CFG_PTP_PIN_SYNC,
+		 sparx5, PTP_PTP_PIN_CFG(TOD_ACC_PIN));
+
+	ts->tv_sec = spx5_rd(sparx5, PTP_PTP_TOD_SEC_LSB(TOD_ACC_PIN));
+	curr_nsec = spx5_rd(sparx5, PTP_PTP_TOD_NSEC(TOD_ACC_PIN));
+
+	ts->tv_nsec = nsec;
+
+	/* Sec has incremented since the ts was registered */
+	if (curr_nsec < nsec)
+		ts->tv_sec--;
+
+	spin_unlock_irqrestore(&sparx5->ptp_clock_lock, flags);
+}
+
+irqreturn_t sparx5_ptp_irq_handler(int irq, void *args)
+{
+	int budget = SPARX5_MAX_PTP_ID;
+	struct sparx5 *sparx5 = args;
+
+	while (budget--) {
+		struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
+		struct skb_shared_hwtstamps shhwtstamps;
+		struct sparx5_port *port;
+		struct timespec64 ts;
+		unsigned long flags;
+		u32 val, id, txport;
+		u32 delay;
+
+		val = spx5_rd(sparx5, REW_PTP_TWOSTEP_CTRL);
+
+		/* Check if a timestamp can be retrieved */
+		if (!(val & REW_PTP_TWOSTEP_CTRL_PTP_VLD))
+			break;
+
+		WARN_ON(val & REW_PTP_TWOSTEP_CTRL_PTP_OVFL);
+
+		if (!(val & REW_PTP_TWOSTEP_CTRL_STAMP_TX))
+			continue;
+
+		/* Retrieve the ts Tx port */
+		txport = REW_PTP_TWOSTEP_CTRL_STAMP_PORT_GET(val);
+
+		/* Retrieve its associated skb */
+		port = sparx5->ports[txport];
+
+		/* Retrieve the delay */
+		delay = spx5_rd(sparx5, REW_PTP_TWOSTEP_STAMP);
+		delay = REW_PTP_TWOSTEP_STAMP_STAMP_NSEC_GET(delay);
+
+		/* Get next timestamp from fifo, which needs to be the
+		 * rx timestamp which represents the id of the frame
+		 */
+		spx5_rmw(REW_PTP_TWOSTEP_CTRL_PTP_NXT_SET(1),
+			 REW_PTP_TWOSTEP_CTRL_PTP_NXT,
+			 sparx5, REW_PTP_TWOSTEP_CTRL);
+
+		val = spx5_rd(sparx5, REW_PTP_TWOSTEP_CTRL);
+
+		/* Check if a timestamp can be retried */
+		if (!(val & REW_PTP_TWOSTEP_CTRL_PTP_VLD))
+			break;
+
+		/* Read RX timestamping to get the ID */
+		id = spx5_rd(sparx5, REW_PTP_TWOSTEP_STAMP);
+		id <<= 8;
+		id |= spx5_rd(sparx5, REW_PTP_TWOSTEP_STAMP_SUBNS);
+
+		spin_lock_irqsave(&port->tx_skbs.lock, flags);
+		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
+			if (SPARX5_SKB_CB(skb)->ts_id != id)
+				continue;
+
+			__skb_unlink(skb, &port->tx_skbs);
+			skb_match = skb;
+			break;
+		}
+		spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
+
+		/* Next ts */
+		spx5_rmw(REW_PTP_TWOSTEP_CTRL_PTP_NXT_SET(1),
+			 REW_PTP_TWOSTEP_CTRL_PTP_NXT,
+			 sparx5, REW_PTP_TWOSTEP_CTRL);
+
+		if (WARN_ON(!skb_match))
+			continue;
+
+		spin_lock(&sparx5->ptp_ts_id_lock);
+		sparx5->ptp_skbs--;
+		spin_unlock(&sparx5->ptp_ts_id_lock);
+
+		/* Get the h/w timestamp */
+		sparx5_get_hwtimestamp(sparx5, &ts, delay);
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
 static int sparx5_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct sparx5_phc *phc = container_of(ptp, struct sparx5_phc, info);
-- 
2.33.0

