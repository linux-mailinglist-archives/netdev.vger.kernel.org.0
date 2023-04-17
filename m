Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CE56E4E3A
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 18:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjDQQWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 12:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjDQQWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 12:22:39 -0400
Received: from synguard (unknown [212.29.212.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F15C5261;
        Mon, 17 Apr 2023 09:22:28 -0700 (PDT)
Received: from T14.siklu.local (unknown [192.168.42.162])
        by synguard (Postfix) with ESMTP id 110594DE5E;
        Mon, 17 Apr 2023 19:03:28 +0300 (IDT)
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     Russell King <linux@armlinux.org.uk>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shmuel Hazan <shmuel.h@siklu.com>
Subject: [PATCH 2/3] net: mvpp2: tai: add extts support
Date:   Mon, 17 Apr 2023 19:01:50 +0300
Message-Id: <20230417160151.1617256-3-shmuel.h@siklu.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230417160151.1617256-1-shmuel.h@siklu.com>
References: <20230417160151.1617256-1-shmuel.h@siklu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,RDNS_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit add support for capturing a timestamp in which the PTP_PULSE
pin, received a signal.

This feature is needed in order to synchronize multiple clocks in the
same board, using tools like ts2phc from the linuxptp project.

On the Armada 8040, this is the only way to do so as a result of
multiple erattas with the PTP_PULSE_IN interface that was designed to
synchronize the TAI on an external PPS signal (the errattas are
FE-6856276, FE-7382160 from document MV-S501388-00).

This patch introduces a pinctrl configuration "extts" that will be
selected once the user had enabled extts, and then will be returned back
to the "default" pinctrl config once it has been disabled. Additionally
these configurations will be also used in any case that the user asks us
to perform any action that involves "triggerering" the TAI subsystem, in
order to avoid a case where the external trigger would trigger with the
wrong action.

This pinctrl mess is needed due to the fact that there is no way for us
to distinguish betwee an external trigger (e.g. from the PTP_PULSE_IN
pin) or an internal one, triggered by the registers.

This feature has been tested on an Aramda
8040 based board, with linuxptp 3.1.1's ts2phc.

Signed-off-by: Shmuel Hazan <shmuel.h@siklu.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_tai.c    | 305 ++++++++++++++++--
 1 file changed, 274 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
index 9c0d50a924d9..5379d6ec81a2 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
@@ -3,8 +3,11 @@
  * Marvell PP2.2 TAI support
  *
  * Note:
- *   Do NOT use the event capture support.
- *   Do Not even set the MPP muxes to allow PTP_EVENT_REQ to be used.
+ *   In order to use the event capture support, please see the example
+ *   in marvell,pp2.yaml.
+ *   Do not manually (e.g. without pinctrl-1, as described in
+ *   marvell,pp2.yaml) set the MPP muxes to allow PTP_EVENT_REQ to be
+ *   used.
  *   It will disrupt the operation of this driver, and there is nothing
  *   that this driver can do to prevent that.  Even using PTP_EVENT_REQ
  *   as an output will be seen as a trigger input, which can't be masked.
@@ -33,6 +36,8 @@
  * Consequently, we support none of these.
  */
 #include <linux/io.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/ptp_clock.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/slab.h>
 
@@ -53,6 +58,10 @@
 #define TCSR_CAPTURE_1_VALID		BIT(1)
 #define TCSR_CAPTURE_0_VALID		BIT(0)
 
+#define MVPP2_PINCTRL_EXTTS_STATE		"extts"
+#define MAX_PINS 1
+#define EXTTS_PERIOD_MS 95
+
 struct mvpp2_tai {
 	struct ptp_clock_info caps;
 	struct ptp_clock *ptp_clock;
@@ -61,7 +70,12 @@ struct mvpp2_tai {
 	u64 period;		// nanosecond period in 32.32 fixed point
 	/* This timestamp is updated every two seconds */
 	struct timespec64 stamp;
+	struct pinctrl *extts_pinctrl;
+	struct pinctrl_state *default_pinctrl_state;
+	struct pinctrl_state *extts_pinctrl_state;
+	struct ptp_pin_desc pin_config[MAX_PINS];
 	u16 poll_worker_refcount;
+	bool extts_enabled:1;
 };
 
 static void mvpp2_tai_modify(void __iomem *reg, u32 mask, u32 set)
@@ -73,6 +87,39 @@ static void mvpp2_tai_modify(void __iomem *reg, u32 mask, u32 set)
 	writel(val, reg);
 }
 
+/* mvpp2_tai_{pause,resume}_external_trigger are used as guards
+ * to mask external triggers where it is undesirable. For example,
+ * in case that the action is "increment", we may want to perform it
+ * once; however, we may trigger it once internally and once from
+ * an external pulse, which will cause an issue.
+ * In order to work around this issue, we need perform the following sequence:
+ *	1. call mvpp2_tai_pause_external_trigger
+ *	2. save the current trigger operation.
+ *  3. update the trigger operation.
+ *	4. perform an internal trigger.
+ *	5. restore the previous trigger operation.
+ *  6. call mvpp2_tai_restore_external_trigger
+ * perform the internal trigger and revert, and then resume the external
+ */
+static int mvpp2_tai_pause_external_trigger(struct mvpp2_tai *tai)
+{
+	if (tai->extts_enabled && tai->extts_pinctrl &&
+	    tai->extts_pinctrl_state)
+		return pinctrl_select_state(tai->extts_pinctrl,
+					    tai->default_pinctrl_state);
+
+	return 0;
+}
+
+static int mvpp2_tai_resume_external_trigger(struct mvpp2_tai *tai)
+{
+	if (tai->extts_enabled && tai->extts_pinctrl &&
+	    tai->extts_pinctrl_state)
+		return pinctrl_select_state(tai->extts_pinctrl,
+					    tai->extts_pinctrl_state);
+	return 0;
+}
+
 static void mvpp2_tai_write(u32 val, void __iomem *reg)
 {
 	writel_relaxed(val & 0xffff, reg);
@@ -102,6 +149,28 @@ static void mvpp22_tai_read_ts(struct timespec64 *ts, void __iomem *base)
 	readl_relaxed(base + 24);
 }
 
+static int mvpp22_tai_try_read_ts(struct timespec64 *ts, void __iomem *base)
+{
+	long tcsr = readl(base + MVPP22_TAI_TCSR);
+	/* If both captures are not valid, return EBUSY */
+	int ret = -EBUSY;
+
+	if (tcsr & TCSR_CAPTURE_1_VALID) {
+		mvpp22_tai_read_ts(ts, base + MVPP22_TAI_TCV1_SEC_HIGH);
+		ret = 0;
+	}
+
+	/* If both capture 1 and capture 0 are valid, use capture 0
+	 * but also read and clear capture 1.
+	 */
+	if (tcsr & TCSR_CAPTURE_0_VALID) {
+		mvpp22_tai_read_ts(ts, base + MVPP22_TAI_TCV0_SEC_HIGH);
+		ret = 0;
+	}
+
+	return ret;
+}
+
 static void mvpp2_tai_write_tlv(const struct timespec64 *ts, u32 frac,
 			        void __iomem *base)
 {
@@ -114,16 +183,30 @@ static void mvpp2_tai_write_tlv(const struct timespec64 *ts, u32 frac,
 	mvpp2_tai_write(frac, base + MVPP22_TAI_TLV_FRAC_LOW);
 }
 
-static void mvpp2_tai_op(u32 op, void __iomem *base)
+static int mvpp2_tai_op(u32 op, void __iomem *base, struct mvpp2_tai *tai)
 {
+	u32 reg_val;
+	int ret;
+
+	reg_val = mvpp2_tai_read(base + MVPP22_TAI_TCFCR0);
 	/* Trigger the operation. Note that an external unmaskable
 	 * event on PTP_EVENT_REQ will also trigger this action.
+	 * therefore, pause possible (known) external triggers.
 	 */
+	ret = mvpp2_tai_pause_external_trigger(tai);
+	if (ret)
+		goto out;
+
 	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
 			 TCFCR0_TCF_MASK | TCFCR0_TCF_TRIGGER,
 			 op | TCFCR0_TCF_TRIGGER);
-	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0, TCFCR0_TCF_MASK,
-			 TCFCR0_TCF_NOP);
+	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
+			 TCFCR0_TCF_MASK | TCFCR0_TCF_TRIGGER, reg_val);
+
+	mvpp2_tai_resume_external_trigger(tai);
+
+out:
+	return ret;
 }
 
 /* The adjustment has a range of +0.5ns to -0.5ns in 2^32 steps, so has units
@@ -170,6 +253,7 @@ static int mvpp22_tai_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	bool neg_adj;
 	s32 frac;
 	u64 val;
+	int ret;
 
 	neg_adj = scaled_ppm < 0;
 	if (neg_adj)
@@ -197,10 +281,10 @@ static int mvpp22_tai_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	spin_lock_irqsave(&tai->lock, flags);
 	mvpp2_tai_write(frac >> 16, base + MVPP22_TAI_TLV_FRAC_HIGH);
 	mvpp2_tai_write(frac, base + MVPP22_TAI_TLV_FRAC_LOW);
-	mvpp2_tai_op(TCFCR0_TCF_FREQUPDATE, base);
+	ret = mvpp2_tai_op(TCFCR0_TCF_FREQUPDATE, base, tai);
 	spin_unlock_irqrestore(&tai->lock, flags);
 
-	return 0;
+	return ret;
 }
 
 static int mvpp22_tai_adjtime(struct ptp_clock_info *ptp, s64 delta)
@@ -210,6 +294,7 @@ static int mvpp22_tai_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	unsigned long flags;
 	void __iomem *base;
 	u32 tcf;
+	int ret;
 
 	/* We can't deal with S64_MIN */
 	if (delta == S64_MIN)
@@ -227,10 +312,10 @@ static int mvpp22_tai_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	base = tai->base;
 	spin_lock_irqsave(&tai->lock, flags);
 	mvpp2_tai_write_tlv(&ts, 0, base);
-	mvpp2_tai_op(tcf, base);
+	ret = mvpp2_tai_op(tcf, base, tai);
 	spin_unlock_irqrestore(&tai->lock, flags);
 
-	return 0;
+	return ret;
 }
 
 static int mvpp22_tai_gettimex64(struct ptp_clock_info *ptp,
@@ -240,35 +325,34 @@ static int mvpp22_tai_gettimex64(struct ptp_clock_info *ptp,
 	struct mvpp2_tai *tai = ptp_to_tai(ptp);
 	unsigned long flags;
 	void __iomem *base;
-	u32 tcsr;
+	u32 reg_val;
 	int ret;
 
 	base = tai->base;
 	spin_lock_irqsave(&tai->lock, flags);
 	/* XXX: the only way to read the PTP time is for the CPU to trigger
 	 * an event. However, there is no way to distinguish between the CPU
-	 * triggered event, and an external event on PTP_EVENT_REQ. So this
-	 * is incompatible with external use of PTP_EVENT_REQ.
+	 * triggered event, and an external event on PTP_EVENT_REQ. As a result
+	 * we are pausing here external triggers by switching the pinctrl state
+	 * to the default state (if applicable).
 	 */
+	ret = mvpp2_tai_pause_external_trigger(tai);
+	if (ret)
+		goto unlock_out;
+
+	reg_val = mvpp2_tai_read(base + MVPP22_TAI_TCFCR0);
 	ptp_read_system_prets(sts);
 	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
 			 TCFCR0_TCF_MASK | TCFCR0_TCF_TRIGGER,
 			 TCFCR0_TCF_CAPTURE | TCFCR0_TCF_TRIGGER);
 	ptp_read_system_postts(sts);
-	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0, TCFCR0_TCF_MASK,
-			 TCFCR0_TCF_NOP);
+	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
+			 TCFCR0_TCF_MASK | TCFCR0_TCF_TRIGGER, reg_val);
 
-	tcsr = readl(base + MVPP22_TAI_TCSR);
-	if (tcsr & TCSR_CAPTURE_1_VALID) {
-		mvpp22_tai_read_ts(ts, base + MVPP22_TAI_TCV1_SEC_HIGH);
-		ret = 0;
-	} else if (tcsr & TCSR_CAPTURE_0_VALID) {
-		mvpp22_tai_read_ts(ts, base + MVPP22_TAI_TCV0_SEC_HIGH);
-		ret = 0;
-	} else {
-		/* We don't seem to have a reading... */
-		ret = -EBUSY;
-	}
+	ret = mvpp22_tai_try_read_ts(ts, base);
+	mvpp2_tai_resume_external_trigger(tai);
+
+unlock_out:
 	spin_unlock_irqrestore(&tai->lock, flags);
 
 	return ret;
@@ -280,32 +364,71 @@ static int mvpp22_tai_settime64(struct ptp_clock_info *ptp,
 	struct mvpp2_tai *tai = ptp_to_tai(ptp);
 	unsigned long flags;
 	void __iomem *base;
+	u32 reg_val;
+	int ret;
 
 	base = tai->base;
 	spin_lock_irqsave(&tai->lock, flags);
 	mvpp2_tai_write_tlv(ts, 0, base);
 
+	ret = mvpp2_tai_pause_external_trigger(tai);
+	if (ret)
+		goto unlock_out;
+
 	/* Trigger an update to load the value from the TLV registers
 	 * into the TOD counter. Note that an external unmaskable event on
 	 * PTP_EVENT_REQ will also trigger this action.
 	 */
+	reg_val = mvpp2_tai_read(base + MVPP22_TAI_TCFCR0);
 	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
-			 TCFCR0_PHASE_UPDATE_ENABLE |
-			 TCFCR0_TCF_MASK | TCFCR0_TCF_TRIGGER,
+			 TCFCR0_PHASE_UPDATE_ENABLE | TCFCR0_TCF_MASK |
+				 TCFCR0_TCF_TRIGGER,
 			 TCFCR0_TCF_UPDATE | TCFCR0_TCF_TRIGGER);
-	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0, TCFCR0_TCF_MASK,
-			 TCFCR0_TCF_NOP);
+	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
+			 TCFCR0_PHASE_UPDATE_ENABLE | TCFCR0_TCF_MASK |
+				 TCFCR0_TCF_TRIGGER,
+			 reg_val);
+
+	mvpp2_tai_resume_external_trigger(tai);
+
+unlock_out:
 	spin_unlock_irqrestore(&tai->lock, flags);
 
-	return 0;
+	return ret;
+}
+
+static void do_aux_work_extts(struct mvpp2_tai *tai)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&tai->lock, flags);
+
+	ret = mvpp22_tai_try_read_ts(&tai->stamp, tai->base);
+	/* We are not managed to read a TS, try again later */
+	if (!ret) {
+		struct ptp_clock_event event;
+
+		/* Triggered - save timestamp */
+		event.type = PTP_CLOCK_EXTTS;
+		event.index = 0; /* We only have one channel */
+		event.timestamp = timespec64_to_ns(&tai->stamp);
+		ptp_clock_event(tai->ptp_clock, &event);
+	}
+
+	spin_unlock_irqrestore(&tai->lock, flags);
 }
 
 static long mvpp22_tai_aux_work(struct ptp_clock_info *ptp)
 {
 	struct mvpp2_tai *tai = ptp_to_tai(ptp);
 
-	mvpp22_tai_gettimex64(ptp, &tai->stamp, NULL);
+	if (tai->extts_enabled) {
+		do_aux_work_extts(tai);
+		return msecs_to_jiffies(EXTTS_PERIOD_MS);
+	}
 
+	mvpp22_tai_gettimex64(ptp, &tai->stamp, NULL);
 	return msecs_to_jiffies(2000);
 }
 
@@ -408,6 +531,94 @@ void mvpp22_tai_stop(struct mvpp2_tai *tai)
 	spin_unlock_irqrestore(&tai->lock, flags);
 }
 
+static void mvpp22_tai_capture_enable(struct mvpp2_tai *tai, bool enable)
+{
+	mvpp2_tai_modify(tai->base + MVPP22_TAI_TCFCR0, TCFCR0_TCF_MASK,
+			 enable ? TCFCR0_TCF_CAPTURE : TCFCR0_TCF_NOP);
+}
+
+static int mvpp22_tai_req_extts_enable(struct mvpp2_tai *tai,
+				       struct ptp_clock_request *rq, int on)
+{
+	u8 index = rq->extts.index;
+	int ret = 0;
+
+	if (!tai->extts_pinctrl)
+		return -EINVAL;
+
+	/* Reject requests with unsupported flags */
+	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE | PTP_RISING_EDGE |
+				PTP_FALLING_EDGE | PTP_STRICT_FLAGS))
+		return -EOPNOTSUPP;
+
+	/* Reject requests to enable time stamping on falling edge */
+	if ((rq->extts.flags & PTP_ENABLE_FEATURE) &&
+	    (rq->extts.flags & PTP_FALLING_EDGE))
+		return -EOPNOTSUPP;
+
+	if (index >= MAX_PINS)
+		return -EINVAL;
+
+	if (on)
+		ret = pinctrl_select_state(tai->extts_pinctrl,
+					   tai->extts_pinctrl_state);
+	else
+		ret = pinctrl_select_state(tai->extts_pinctrl,
+					   tai->default_pinctrl_state);
+	if (ret)
+		goto out;
+
+	tai->extts_enabled = on != 0;
+	mvpp22_tai_capture_enable(tai, tai->extts_enabled);
+
+	/* We need to enable the poll worker in order for events to be polled */
+	if (on)
+		mvpp22_tai_start_unlocked(tai);
+	else
+		mvpp22_tai_stop_unlocked(tai);
+
+out:
+	return ret;
+}
+
+static int mvpp22_tai_enable(struct ptp_clock_info *ptp,
+			     struct ptp_clock_request *rq, int on)
+{
+	struct mvpp2_tai *tai = ptp_to_tai(ptp);
+	int err = -EOPNOTSUPP;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tai->lock, flags);
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_EXTTS:
+		err = mvpp22_tai_req_extts_enable(tai, rq, on);
+		break;
+	default:
+		break;
+	}
+
+	spin_unlock_irqrestore(&tai->lock, flags);
+	return err;
+}
+
+static int mvpp22_tai_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
+				 enum ptp_pin_function func, unsigned int chan)
+{
+	if (chan != 0)
+		return -1;
+
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_EXTTS:
+		break;
+	case PTP_PF_PEROUT:
+	case PTP_PF_PHYSYNC:
+		return -1;
+	}
+	return 0;
+}
+
 static void mvpp22_tai_remove(void *priv)
 {
 	struct mvpp2_tai *tai = priv;
@@ -427,6 +638,24 @@ int mvpp22_tai_probe(struct device *dev, struct mvpp2 *priv)
 
 	spin_lock_init(&tai->lock);
 
+	tai->extts_pinctrl = devm_pinctrl_get_select_default(dev);
+	if (!IS_ERR(tai->extts_pinctrl)) {
+		tai->default_pinctrl_state = pinctrl_lookup_state
+			(tai->extts_pinctrl, PINCTRL_STATE_DEFAULT);
+		tai->extts_pinctrl_state = pinctrl_lookup_state
+			(tai->extts_pinctrl, MVPP2_PINCTRL_EXTTS_STATE);
+
+		if (IS_ERR(tai->default_pinctrl_state) ||
+		    IS_ERR(tai->extts_pinctrl_state)) {
+			pinctrl_put(tai->extts_pinctrl);
+			tai->extts_pinctrl = NULL;
+			tai->default_pinctrl_state = NULL;
+			tai->extts_pinctrl_state = NULL;
+		}
+	} else {
+		tai->extts_pinctrl = NULL;
+	}
+
 	tai->base = priv->iface_base;
 
 	/* The step size consists of three registers - a 16-bit nanosecond step
@@ -462,12 +691,26 @@ int mvpp22_tai_probe(struct device *dev, struct mvpp2 *priv)
 
 	tai->caps.owner = THIS_MODULE;
 	strscpy(tai->caps.name, "Marvell PP2.2", sizeof(tai->caps.name));
+	tai->caps.n_ext_ts = MAX_PINS;
+	tai->caps.n_pins = MAX_PINS;
 	tai->caps.max_adj = mvpp22_calc_max_adj(tai);
 	tai->caps.adjfine = mvpp22_tai_adjfine;
 	tai->caps.adjtime = mvpp22_tai_adjtime;
 	tai->caps.gettimex64 = mvpp22_tai_gettimex64;
 	tai->caps.settime64 = mvpp22_tai_settime64;
 	tai->caps.do_aux_work = mvpp22_tai_aux_work;
+	tai->caps.enable = mvpp22_tai_enable;
+	tai->caps.verify = mvpp22_tai_verify_pin;
+	tai->caps.pin_config = tai->pin_config;
+
+	for (int i = 0; i < tai->caps.n_pins; ++i) {
+		struct ptp_pin_desc *ppd = &tai->caps.pin_config[i];
+
+		snprintf(ppd->name, sizeof(ppd->name), "PTP_PULSE_IN%d", i);
+		ppd->index = i;
+		ppd->func = PTP_PF_NONE;
+		ppd->chan = 0;
+	}
 
 	ret = devm_add_action(dev, mvpp22_tai_remove, tai);
 	if (ret)
-- 
2.40.0

