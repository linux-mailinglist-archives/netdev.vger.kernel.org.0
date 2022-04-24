Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B1B50D27F
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 16:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238035AbiDXO7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 10:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239568AbiDXO7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 10:59:00 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C51A3C72A;
        Sun, 24 Apr 2022 07:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650812160; x=1682348160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UR1RA3SQR1fWtMD6vwZ8M4oQ8dNXkQuzmJFWoN6oIdI=;
  b=SUKZwwEuMEg8ayaPJQoDXTnSKLXCLaOP5ANciuMvXizCENjtxMOIX2Aj
   +b+IqJ6HE7kNflyywJP3HTgkVvEslYE6sx7np8YJZHF0HQbeWRrocspvH
   qqFB/rAocK+AeG1FiSlxyhOz+UH1xtnwoEK9toWHgsHDXezDpb9Kbk8O3
   /MesDfhbCiq+52XKI9TgsreNhjfNNA+hslDGOKrPT9NE16pugYSXauGPx
   5FOcW/vUU054plLdKq0B5MIOucBd+i51FxwuK+TwHBAblkVXKq0Nc6VKu
   /KXPf/1MKDNVcPxMLhl/UxzyikbWZ1TzB25SuvFO+orlOnCBjl21xFTob
   A==;
X-IronPort-AV: E=Sophos;i="5.90,286,1643698800"; 
   d="scan'208";a="153623575"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Apr 2022 07:56:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 24 Apr 2022 07:55:59 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sun, 24 Apr 2022 07:55:57 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>, <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 4/5] net: lan966x: Add support for PTP_PF_PEROUT
Date:   Sun, 24 Apr 2022 16:58:23 +0200
Message-ID: <20220424145824.2931449-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220424145824.2931449-1-horatiu.vultur@microchip.com>
References: <20220424145824.2931449-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lan966x has 8 PTP programmable pins, where the last pins is hardcoded to
be used by PHC0, which does the frame timestamping. All the rest of the
PTP pins can be shared between the PHCs and can have different functions
like perout or extts. For now add support for PTP_FS_PEROUT.
The HW is not able to support absolute start time but can use the nsec
for phase adjustment when generating PPS.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.h |   2 +
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 167 ++++++++++++++++++
 2 files changed, 169 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 5213263c4e87..76255e2a86f3 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -56,6 +56,7 @@
 
 #define LAN966X_PHC_COUNT		3
 #define LAN966X_PHC_PORT		0
+#define LAN966X_PHC_PINS_NUM		7
 
 #define IFH_REW_OP_NOOP			0x0
 #define IFH_REW_OP_ONE_STEP_PTP		0x3
@@ -177,6 +178,7 @@ struct lan966x_stat_layout {
 struct lan966x_phc {
 	struct ptp_clock *clock;
 	struct ptp_clock_info info;
+	struct ptp_pin_desc pins[LAN966X_PHC_PINS_NUM];
 	struct hwtstamp_config hwtstamp_config;
 	struct lan966x *lan966x;
 	u8 index;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index 3e455a3fad08..3199a266ed3d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -493,6 +493,158 @@ static int lan966x_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return 0;
 }
 
+static int lan966x_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
+			      enum ptp_pin_function func, unsigned int chan)
+{
+	struct lan966x_phc *phc = container_of(ptp, struct lan966x_phc, info);
+	struct lan966x *lan966x = phc->lan966x;
+	struct ptp_clock_info *info;
+	int i;
+
+	/* Currently support only 1 channel */
+	if (chan != 0)
+		return -1;
+
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_PEROUT:
+		break;
+	default:
+		return -1;
+	}
+
+	/* The PTP pins are shared by all the PHC. So it is required to see if
+	 * the pin is connected to another PHC. The pin is connected to another
+	 * PHC if that pin already has a function on that PHC.
+	 */
+	for (i = 0; i < LAN966X_PHC_COUNT; ++i) {
+		info = &lan966x->phc[i].info;
+
+		/* Ignore the check with ourself */
+		if (ptp == info)
+			continue;
+
+		if (info->pin_config[pin].func == PTP_PF_PEROUT)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int lan966x_ptp_perout(struct ptp_clock_info *ptp,
+			      struct ptp_clock_request *rq, int on)
+{
+	struct lan966x_phc *phc = container_of(ptp, struct lan966x_phc, info);
+	struct lan966x *lan966x = phc->lan966x;
+	struct timespec64 ts_phase, ts_period;
+	unsigned long flags;
+	s64 wf_high, wf_low;
+	bool pps = false;
+	int pin;
+
+	if (rq->perout.flags & ~(PTP_PEROUT_DUTY_CYCLE |
+				 PTP_PEROUT_PHASE))
+		return -EOPNOTSUPP;
+
+	pin = ptp_find_pin(phc->clock, PTP_PF_PEROUT, rq->perout.index);
+	if (pin == -1 || pin >= LAN966X_PHC_PINS_NUM)
+		return -EINVAL;
+
+	if (!on) {
+		spin_lock_irqsave(&lan966x->ptp_clock_lock, flags);
+		lan_rmw(PTP_PIN_CFG_PIN_ACTION_SET(PTP_PIN_ACTION_IDLE) |
+			PTP_PIN_CFG_PIN_DOM_SET(phc->index) |
+			PTP_PIN_CFG_PIN_SYNC_SET(0),
+			PTP_PIN_CFG_PIN_ACTION |
+			PTP_PIN_CFG_PIN_DOM |
+			PTP_PIN_CFG_PIN_SYNC,
+			lan966x, PTP_PIN_CFG(pin));
+		spin_unlock_irqrestore(&lan966x->ptp_clock_lock, flags);
+		return 0;
+	}
+
+	if (rq->perout.period.sec == 1 &&
+	    rq->perout.period.nsec == 0)
+		pps = true;
+
+	if (rq->perout.flags & PTP_PEROUT_PHASE) {
+		ts_phase.tv_sec = rq->perout.phase.sec;
+		ts_phase.tv_nsec = rq->perout.phase.nsec;
+	} else {
+		ts_phase.tv_sec = rq->perout.start.sec;
+		ts_phase.tv_nsec = rq->perout.start.nsec;
+	}
+
+	if (ts_phase.tv_sec || (ts_phase.tv_nsec && !pps)) {
+		dev_warn(lan966x->dev,
+			 "Absolute time not supported!\n");
+		return -EINVAL;
+	}
+
+	if (rq->perout.flags & PTP_PEROUT_DUTY_CYCLE) {
+		struct timespec64 ts_on;
+
+		ts_on.tv_sec = rq->perout.on.sec;
+		ts_on.tv_nsec = rq->perout.on.nsec;
+
+		wf_high = timespec64_to_ns(&ts_on);
+	} else {
+		wf_high = 5000;
+	}
+
+	if (pps) {
+		spin_lock_irqsave(&lan966x->ptp_clock_lock, flags);
+		lan_wr(PTP_WF_LOW_PERIOD_PIN_WFL(ts_phase.tv_nsec),
+		       lan966x, PTP_WF_LOW_PERIOD(pin));
+		lan_wr(PTP_WF_HIGH_PERIOD_PIN_WFH(wf_high),
+		       lan966x, PTP_WF_HIGH_PERIOD(pin));
+		lan_rmw(PTP_PIN_CFG_PIN_ACTION_SET(PTP_PIN_ACTION_CLOCK) |
+			PTP_PIN_CFG_PIN_DOM_SET(phc->index) |
+			PTP_PIN_CFG_PIN_SYNC_SET(3),
+			PTP_PIN_CFG_PIN_ACTION |
+			PTP_PIN_CFG_PIN_DOM |
+			PTP_PIN_CFG_PIN_SYNC,
+			lan966x, PTP_PIN_CFG(pin));
+		spin_unlock_irqrestore(&lan966x->ptp_clock_lock, flags);
+		return 0;
+	}
+
+	ts_period.tv_sec = rq->perout.period.sec;
+	ts_period.tv_nsec = rq->perout.period.nsec;
+
+	wf_low = timespec64_to_ns(&ts_period);
+	wf_low -= wf_high;
+
+	spin_lock_irqsave(&lan966x->ptp_clock_lock, flags);
+	lan_wr(PTP_WF_LOW_PERIOD_PIN_WFL(wf_low),
+	       lan966x, PTP_WF_LOW_PERIOD(pin));
+	lan_wr(PTP_WF_HIGH_PERIOD_PIN_WFH(wf_high),
+	       lan966x, PTP_WF_HIGH_PERIOD(pin));
+	lan_rmw(PTP_PIN_CFG_PIN_ACTION_SET(PTP_PIN_ACTION_CLOCK) |
+		PTP_PIN_CFG_PIN_DOM_SET(phc->index) |
+		PTP_PIN_CFG_PIN_SYNC_SET(0),
+		PTP_PIN_CFG_PIN_ACTION |
+		PTP_PIN_CFG_PIN_DOM |
+		PTP_PIN_CFG_PIN_SYNC,
+		lan966x, PTP_PIN_CFG(pin));
+	spin_unlock_irqrestore(&lan966x->ptp_clock_lock, flags);
+
+	return 0;
+}
+
+static int lan966x_ptp_enable(struct ptp_clock_info *ptp,
+			      struct ptp_clock_request *rq, int on)
+{
+	switch (rq->type) {
+	case PTP_CLK_REQ_PEROUT:
+		return lan966x_ptp_perout(ptp, rq, on);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct ptp_clock_info lan966x_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "lan966x ptp",
@@ -501,6 +653,10 @@ static struct ptp_clock_info lan966x_ptp_clock_info = {
 	.settime64	= lan966x_ptp_settime64,
 	.adjtime	= lan966x_ptp_adjtime,
 	.adjfine	= lan966x_ptp_adjfine,
+	.verify		= lan966x_ptp_verify,
+	.enable		= lan966x_ptp_enable,
+	.n_per_out	= LAN966X_PHC_PINS_NUM,
+	.n_pins		= LAN966X_PHC_PINS_NUM,
 };
 
 static int lan966x_ptp_phc_init(struct lan966x *lan966x,
@@ -508,8 +664,19 @@ static int lan966x_ptp_phc_init(struct lan966x *lan966x,
 				struct ptp_clock_info *clock_info)
 {
 	struct lan966x_phc *phc = &lan966x->phc[index];
+	struct ptp_pin_desc *p;
+	int i;
+
+	for (i = 0; i < LAN966X_PHC_PINS_NUM; i++) {
+		p = &phc->pins[i];
+
+		snprintf(p->name, sizeof(p->name), "pin%d", i);
+		p->index = i;
+		p->func = PTP_PF_NONE;
+	}
 
 	phc->info = *clock_info;
+	phc->info.pin_config = &phc->pins[0];
 	phc->clock = ptp_clock_register(&phc->info, lan966x->dev);
 	if (IS_ERR(phc->clock))
 		return PTR_ERR(phc->clock);
-- 
2.33.0

