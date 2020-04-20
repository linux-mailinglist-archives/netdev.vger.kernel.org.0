Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E041AFFF9
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgDTCvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:51:25 -0400
Received: from inva021.nxp.com ([92.121.34.21]:50384 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbgDTCvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:51:22 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 986002006A5;
        Mon, 20 Apr 2020 04:51:18 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2755D20069E;
        Mon, 20 Apr 2020 04:51:13 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 2905C402D9;
        Mon, 20 Apr 2020 10:51:06 +0800 (SGT)
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
Subject: [v3, 5/7] net: mscc: ocelot: support 4 PTP programmable pins
Date:   Mon, 20 Apr 2020 10:46:49 +0800
Message-Id: <20200420024651.47353-6-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420024651.47353-1-yangbo.lu@nxp.com>
References: <20200420024651.47353-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support 4 PTP programmable pins with only PTP_PF_PEROUT function
for now. The PTP_PF_EXTTS function will be supported in the
future, and it should be implemented separately for Felix and
Ocelot, because of different hardware interrupt implementation
in them.

Since the hardware is not able to support absolute start time,
the periodic clock request only allows start time 0 0. But nsec
could be accepted for PPS case for phase adjustment.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Supported PPS case in programmable pin.
	- Supported disabling pin function since deadlock is fixed by Richard.
	- Returned -EBUSY if not finding pin available.
Changes for v3:
	- None.
---
 drivers/net/ethernet/mscc/ocelot_ptp.c | 121 +++++++++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              |   3 +
 include/soc/mscc/ocelot_ptp.h          |   4 ++
 3 files changed, 128 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
index 69d4e56..a3088a1 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -165,11 +165,132 @@ int ocelot_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 }
 EXPORT_SYMBOL(ocelot_ptp_adjfine);
 
+int ocelot_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
+		      enum ptp_pin_function func, unsigned int chan)
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
+EXPORT_SYMBOL(ocelot_ptp_verify);
+
+int ocelot_ptp_enable(struct ptp_clock_info *ptp,
+		      struct ptp_clock_request *rq, int on)
+{
+	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
+	struct timespec64 ts_start, ts_period;
+	enum ocelot_ptp_pins ptp_pin;
+	unsigned long flags;
+	bool pps = false;
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
+			return -EBUSY;
+
+		ts_start.tv_sec = rq->perout.start.sec;
+		ts_start.tv_nsec = rq->perout.start.nsec;
+		ts_period.tv_sec = rq->perout.period.sec;
+		ts_period.tv_nsec = rq->perout.period.nsec;
+
+		if (ts_period.tv_sec == 1 && ts_period.tv_nsec == 0)
+			pps = true;
+
+		if (ts_start.tv_sec || (ts_start.tv_nsec && !pps)) {
+			dev_warn(ocelot->dev,
+				 "Absolute start time not supported!\n");
+			dev_warn(ocelot->dev,
+				 "Accept nsec for PPS phase adjustment, otherwise start time should be 0 0.\n");
+			return -EINVAL;
+		}
+
+		/* Handle turning off */
+		if (!on) {
+			spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+			val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_IDLE);
+			ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ptp_pin);
+			spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+			break;
+		}
+
+		/* Handle PPS request */
+		if (pps) {
+			spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+			/* Pulse generated perout.start.nsec after TOD has
+			 * increased seconds.
+			 * Pulse width is set to 1us.
+			 */
+			ocelot_write_rix(ocelot, ts_start.tv_nsec,
+					 PTP_PIN_WF_LOW_PERIOD, ptp_pin);
+			ocelot_write_rix(ocelot, 1000,
+					 PTP_PIN_WF_HIGH_PERIOD, ptp_pin);
+			val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK);
+			val |= PTP_PIN_CFG_SYNC;
+			ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ptp_pin);
+			spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+			break;
+		}
+
+		/* Handle periodic clock */
+		ns = timespec64_to_ns(&ts_period);
+		ns = ns >> 1;
+		if (ns > 0x3fffffff || ns <= 0x6)
+			return -EINVAL;
+
+		spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+		ocelot_write_rix(ocelot, ns, PTP_PIN_WF_LOW_PERIOD, ptp_pin);
+		ocelot_write_rix(ocelot, ns, PTP_PIN_WF_HIGH_PERIOD, ptp_pin);
+		val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK);
+		ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ptp_pin);
+		spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_ptp_enable);
+
 int ocelot_init_timestamp(struct ocelot *ocelot, struct ptp_clock_info *info)
 {
 	struct ptp_clock *ptp_clock;
+	int i;
 
 	ocelot->ptp_info = *info;
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
index c7ba83b..ca49f7a 100644
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
@@ -550,6 +552,7 @@ struct ocelot {
 	struct mutex			ptp_lock;
 	/* Protects the PTP clock */
 	spinlock_t			ptp_clock_lock;
+	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
 };
 
 struct ocelot_policer {
diff --git a/include/soc/mscc/ocelot_ptp.h b/include/soc/mscc/ocelot_ptp.h
index aae1570..4a6b2f7 100644
--- a/include/soc/mscc/ocelot_ptp.h
+++ b/include/soc/mscc/ocelot_ptp.h
@@ -49,6 +49,10 @@ int ocelot_ptp_settime64(struct ptp_clock_info *ptp,
 			 const struct timespec64 *ts);
 int ocelot_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta);
 int ocelot_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm);
+int ocelot_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
+		      enum ptp_pin_function func, unsigned int chan);
+int ocelot_ptp_enable(struct ptp_clock_info *ptp,
+		      struct ptp_clock_request *rq, int on);
 int ocelot_init_timestamp(struct ocelot *ocelot, struct ptp_clock_info *info);
 int ocelot_deinit_timestamp(struct ocelot *ocelot);
 #endif
-- 
2.7.4

