Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3901D5111A7
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358398AbiD0Gvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358391AbiD0Gvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:51:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCB21586D5;
        Tue, 26 Apr 2022 23:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651042103; x=1682578103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wfOJAtNcrd0iN2mu34wvIVvCLBFl/5F4eWm3opSe/Lw=;
  b=NzSS36KIlPnM4MMSvP9dPs7Pav9rzj+dK/AF4vnZF4tW16aMrHcFMTw+
   W9PRTpbc+HheC03r74aMQ/J3mnq8dL6RObqB0gU5Euc70LLUAY1y8RlOI
   /w6+NP6FcR0sFAnVHOBZjmlGeKr+CA0K0ykuUMuYnP7twuhHslhmxgHBe
   All4ujdQqD2vNBSzUUwEv+/uQJfB3+HuVuExrrzDYjBSSj2mUDkYnau93
   WPU1KtOAQzYGpcgoEfKvKwP7zPgc7FpOqImU3f8S0WSBvwCU0/1QwM0Zo
   Xq1uATXpvkk9/S9HY96Rsu+vG+dwEC8kHiwZ8iyJLf6DnHQRnkSGMDvYT
   A==;
X-IronPort-AV: E=Sophos;i="5.90,292,1643698800"; 
   d="scan'208";a="156933149"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2022 23:48:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 26 Apr 2022 23:48:22 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 26 Apr 2022 23:48:20 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>, <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 5/5] net: lan966x: Add support for PTP_PF_EXTTS
Date:   Wed, 27 Apr 2022 08:51:27 +0200
Message-ID: <20220427065127.3765659-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220427065127.3765659-1-horatiu.vultur@microchip.com>
References: <20220427065127.3765659-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the PTP programmable pins to implement also PTP_PF_EXTTS
function. The PTP pin can be configured to capture only on the rising
edge of the PPS signal. And once an event is seen then an interrupt is
generated and the local time counter is saved.
The interrupt is shared between all the pins.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c |  17 +++
 .../ethernet/microchip/lan966x/lan966x_main.h |   2 +
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 109 +++++++++++++++++-
 3 files changed, 127 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index f072ae674740..5a503f3991d9 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -692,6 +692,9 @@ static void lan966x_cleanup_ports(struct lan966x *lan966x)
 
 	if (lan966x->ptp_irq)
 		devm_free_irq(lan966x->dev, lan966x->ptp_irq, lan966x);
+
+	if (lan966x->ptp_ext_irq)
+		devm_free_irq(lan966x->dev, lan966x->ptp_ext_irq, lan966x);
 }
 
 static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
@@ -1058,6 +1061,20 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x->fdma = true;
 	}
 
+	if (lan966x->ptp) {
+		lan966x->ptp_ext_irq = platform_get_irq_byname(pdev, "ptp-ext");
+		if (lan966x->ptp_ext_irq > 0) {
+			err = devm_request_threaded_irq(&pdev->dev,
+							lan966x->ptp_ext_irq, NULL,
+							lan966x_ptp_ext_irq_handler,
+							IRQF_ONESHOT,
+							"ptp-ext irq", lan966x);
+			if (err)
+				return dev_err_probe(&pdev->dev, err,
+						     "Unable to use ptp-ext irq");
+		}
+	}
+
 	/* init switch */
 	lan966x_init(lan966x);
 	lan966x_stats_init(lan966x);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 76255e2a86f3..3b86ddddc756 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -233,6 +233,7 @@ struct lan966x {
 	int ana_irq;
 	int ptp_irq;
 	int fdma_irq;
+	int ptp_ext_irq;
 
 	/* worqueue for fdb */
 	struct workqueue_struct *fdb_work;
@@ -394,6 +395,7 @@ int lan966x_ptp_txtstamp_request(struct lan966x_port *port,
 void lan966x_ptp_txtstamp_release(struct lan966x_port *port,
 				  struct sk_buff *skb);
 irqreturn_t lan966x_ptp_irq_handler(int irq, void *args);
+irqreturn_t lan966x_ptp_ext_irq_handler(int irq, void *args);
 
 int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
 int lan966x_fdma_change_mtu(struct lan966x *lan966x);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index 3199a266ed3d..3a621c5165bc 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -321,6 +321,63 @@ irqreturn_t lan966x_ptp_irq_handler(int irq, void *args)
 	return IRQ_HANDLED;
 }
 
+irqreturn_t lan966x_ptp_ext_irq_handler(int irq, void *args)
+{
+	struct lan966x *lan966x = args;
+	struct lan966x_phc *phc;
+	unsigned long flags;
+	u64 time = 0;
+	time64_t s;
+	int pin, i;
+	s64 ns;
+
+	if (!(lan_rd(lan966x, PTP_PIN_INTR)))
+		return IRQ_NONE;
+
+	/* Go through all domains and see which pin generated the interrupt */
+	for (i = 0; i < LAN966X_PHC_COUNT; ++i) {
+		struct ptp_clock_event ptp_event = {0};
+
+		phc = &lan966x->phc[i];
+		pin = ptp_find_pin_unlocked(phc->clock, PTP_PF_EXTTS, 0);
+		if (pin == -1)
+			continue;
+
+		if (!(lan_rd(lan966x, PTP_PIN_INTR) & BIT(pin)))
+			continue;
+
+		spin_lock_irqsave(&lan966x->ptp_clock_lock, flags);
+
+		/* Enable to get the new interrupt.
+		 * By writing 1 it clears the bit
+		 */
+		lan_wr(BIT(pin), lan966x, PTP_PIN_INTR);
+
+		/* Get current time */
+		s = lan_rd(lan966x, PTP_TOD_SEC_MSB(pin));
+		s <<= 32;
+		s |= lan_rd(lan966x, PTP_TOD_SEC_LSB(pin));
+		ns = lan_rd(lan966x, PTP_TOD_NSEC(pin));
+		ns &= PTP_TOD_NSEC_TOD_NSEC;
+
+		spin_unlock_irqrestore(&lan966x->ptp_clock_lock, flags);
+
+		if ((ns & 0xFFFFFFF0) == 0x3FFFFFF0) {
+			s--;
+			ns &= 0xf;
+			ns += 999999984;
+		}
+		time = ktime_set(s, ns);
+
+		ptp_event.index = pin;
+		ptp_event.timestamp = time;
+		ptp_event.type = PTP_CLOCK_EXTTS;
+		ptp_clock_event(phc->clock, &ptp_event);
+	}
+
+	return IRQ_HANDLED;
+}
+
 static int lan966x_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct lan966x_phc *phc = container_of(ptp, struct lan966x_phc, info);
@@ -508,6 +565,7 @@ static int lan966x_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 	switch (func) {
 	case PTP_PF_NONE:
 	case PTP_PF_PEROUT:
+	case PTP_PF_EXTTS:
 		break;
 	default:
 		return -1;
@@ -524,7 +582,8 @@ static int lan966x_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 		if (ptp == info)
 			continue;
 
-		if (info->pin_config[pin].func == PTP_PF_PEROUT)
+		if (info->pin_config[pin].func == PTP_PF_PEROUT ||
+		    info->pin_config[pin].func == PTP_PF_EXTTS)
 			return -1;
 	}
 
@@ -632,12 +691,59 @@ static int lan966x_ptp_perout(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static int lan966x_ptp_extts(struct ptp_clock_info *ptp,
+			     struct ptp_clock_request *rq, int on)
+{
+	struct lan966x_phc *phc = container_of(ptp, struct lan966x_phc, info);
+	struct lan966x *lan966x = phc->lan966x;
+	unsigned long flags;
+	int pin;
+	u32 val;
+
+	if (lan966x->ptp_ext_irq <= 0)
+		return -EOPNOTSUPP;
+
+	/* Reject requests with unsupported flags */
+	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+				PTP_RISING_EDGE |
+				PTP_STRICT_FLAGS))
+		return -EOPNOTSUPP;
+
+	pin = ptp_find_pin(phc->clock, PTP_PF_EXTTS, rq->extts.index);
+	if (pin == -1 || pin >= LAN966X_PHC_PINS_NUM)
+		return -EINVAL;
+
+	spin_lock_irqsave(&lan966x->ptp_clock_lock, flags);
+	lan_rmw(PTP_PIN_CFG_PIN_ACTION_SET(PTP_PIN_ACTION_SAVE) |
+		PTP_PIN_CFG_PIN_SYNC_SET(on ? 3 : 0) |
+		PTP_PIN_CFG_PIN_DOM_SET(phc->index) |
+		PTP_PIN_CFG_PIN_SELECT_SET(pin),
+		PTP_PIN_CFG_PIN_ACTION |
+		PTP_PIN_CFG_PIN_SYNC |
+		PTP_PIN_CFG_PIN_DOM |
+		PTP_PIN_CFG_PIN_SELECT,
+		lan966x, PTP_PIN_CFG(pin));
+
+	val = lan_rd(lan966x, PTP_PIN_INTR_ENA);
+	if (on)
+		val |= BIT(pin);
+	else
+		val &= ~BIT(pin);
+	lan_wr(val, lan966x, PTP_PIN_INTR_ENA);
+
+	spin_unlock_irqrestore(&lan966x->ptp_clock_lock, flags);
+
+	return 0;
+}
+
 static int lan966x_ptp_enable(struct ptp_clock_info *ptp,
 			      struct ptp_clock_request *rq, int on)
 {
 	switch (rq->type) {
 	case PTP_CLK_REQ_PEROUT:
 		return lan966x_ptp_perout(ptp, rq, on);
+	case PTP_CLK_REQ_EXTTS:
+		return lan966x_ptp_extts(ptp, rq, on);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -656,6 +762,7 @@ static struct ptp_clock_info lan966x_ptp_clock_info = {
 	.verify		= lan966x_ptp_verify,
 	.enable		= lan966x_ptp_enable,
 	.n_per_out	= LAN966X_PHC_PINS_NUM,
+	.n_ext_ts	= LAN966X_PHC_PINS_NUM,
 	.n_pins		= LAN966X_PHC_PINS_NUM,
 };
 
-- 
2.33.0

