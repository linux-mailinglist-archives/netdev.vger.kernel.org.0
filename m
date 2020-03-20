Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A0E18CBDD
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 11:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgCTKlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 06:41:19 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51914 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbgCTKlJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 06:41:09 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 97F9A1A0543;
        Fri, 20 Mar 2020 11:41:06 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3B1351A055C;
        Fri, 20 Mar 2020 11:41:00 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 9633B4031C;
        Fri, 20 Mar 2020 18:40:52 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Date:   Fri, 20 Mar 2020 18:37:26 +0800
Message-Id: <20200320103726.32559-7-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320103726.32559-1-yangbo.lu@nxp.com>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support 4 programmable pins for only one function periodic
signal for now. Since the hardware is not able to support
absolute start time, driver starts periodic signal immediately.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/ptp/ptp_ocelot.c  | 97 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/soc/mscc/ocelot.h |  3 ++
 2 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocelot.c b/drivers/ptp/ptp_ocelot.c
index 59420a7..299928e 100644
--- a/drivers/ptp/ptp_ocelot.c
+++ b/drivers/ptp/ptp_ocelot.c
@@ -164,26 +164,119 @@ static int ocelot_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	return 0;
 }
 
+static int ocelot_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
+			     enum ptp_pin_function func, unsigned int chan)
+{
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_PEROUT:
+		break;
+	case PTP_PF_EXTTS:
+	case PTP_PF_PHYSYNC:
+		return -1;
+	}
+	return 0;
+}
+
+static int ocelot_ptp_enable(struct ptp_clock_info *ptp,
+			     struct ptp_clock_request *rq, int on)
+{
+	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
+	enum ocelot_ptp_pins ptp_pin;
+	struct timespec64 ts;
+	unsigned long flags;
+	int pin = -1;
+	u32 val;
+	s64 ns;
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_PEROUT:
+		/* Reject requests with unsupported flags */
+		if (rq->perout.flags)
+			return -EOPNOTSUPP;
+
+		/*
+		 * TODO: support disabling function
+		 * When ptp_disable_pinfunc() is to disable function,
+		 * it has already held pincfg_mux.
+		 * However ptp_find_pin() in .enable() called also needs
+		 * to hold pincfg_mux.
+		 * This causes dead lock. So, just return for function
+		 * disabling, and this needs fix-up.
+		 */
+		if (!on)
+			break;
+
+		pin = ptp_find_pin(ocelot->ptp_clock, PTP_PF_PEROUT,
+				   rq->perout.index);
+		if (pin == 0)
+			ptp_pin = PTP_PIN_0;
+		else if (pin == 1)
+			ptp_pin = PTP_PIN_1;
+		else if (pin == 2)
+			ptp_pin = PTP_PIN_2;
+		else if (pin == 3)
+			ptp_pin = PTP_PIN_3;
+		else
+			return -EINVAL;
+
+		ts.tv_sec = rq->perout.period.sec;
+		ts.tv_nsec = rq->perout.period.nsec;
+		ns = timespec64_to_ns(&ts);
+		ns = ns >> 1;
+		if (ns > 0x3fffffff || ns <= 0x6)
+			return -EINVAL;
+
+		spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+		ocelot_write_rix(ocelot, ns, PTP_PIN_WF_LOW_PERIOD, ptp_pin);
+		ocelot_write_rix(ocelot, ns, PTP_PIN_WF_HIGH_PERIOD, ptp_pin);
+
+		val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK);
+		ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ptp_pin);
+		spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+		dev_warn(ocelot->dev,
+			 "Starting periodic signal now! (absolute start time not supported)\n");
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
 static struct ptp_clock_info ocelot_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "ocelot ptp",
 	.max_adj	= 0x7fffffff,
 	.n_alarm	= 0,
 	.n_ext_ts	= 0,
-	.n_per_out	= 0,
-	.n_pins		= 0,
+	.n_per_out	= OCELOT_PTP_PINS_NUM,
+	.n_pins		= OCELOT_PTP_PINS_NUM,
 	.pps		= 0,
 	.gettime64	= ocelot_ptp_gettime64,
 	.settime64	= ocelot_ptp_settime64,
 	.adjtime	= ocelot_ptp_adjtime,
 	.adjfine	= ocelot_ptp_adjfine,
+	.verify		= ocelot_ptp_verify,
+	.enable		= ocelot_ptp_enable,
 };
 
 int ocelot_init_timestamp(struct ocelot *ocelot)
 {
 	struct ptp_clock *ptp_clock;
+	int i;
 
 	ocelot->ptp_info = ocelot_ptp_clock_info;
+
+	for (i = 0; i < OCELOT_PTP_PINS_NUM; i++) {
+		struct ptp_pin_desc *p = &ocelot->ptp_pins[i];
+
+		snprintf(p->name, sizeof(p->name), "switch_1588_dat%d", i);
+		p->index = i;
+		p->func = PTP_PF_NONE;
+	}
+
+	ocelot->ptp_info.pin_config = &ocelot->ptp_pins[0];
+
 	ptp_clock = ptp_clock_register(&ocelot->ptp_info, ocelot->dev);
 	if (IS_ERR(ptp_clock))
 		return PTR_ERR(ptp_clock);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index bcce278..db2fb14 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -92,6 +92,8 @@
 #define OCELOT_SPEED_100		2
 #define OCELOT_SPEED_10			3
 
+#define OCELOT_PTP_PINS_NUM		4
+
 #define TARGET_OFFSET			24
 #define REG_MASK			GENMASK(TARGET_OFFSET - 1, 0)
 #define REG(reg, offset)		[reg & REG_MASK] = offset
@@ -544,6 +546,7 @@ struct ocelot {
 	struct mutex			ptp_lock;
 	/* Protects the PTP clock */
 	spinlock_t			ptp_clock_lock;
+	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
 };
 
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
-- 
2.7.4

