Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24206F3626
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389874AbfKGRsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:48:10 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:53812 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730713AbfKGRsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:48:09 -0500
X-Greylist: delayed 2313 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Nov 2019 12:48:04 EST
Received: from cpc145834-warw19-2-0-cust22.3-2.cable.virginm.net ([82.13.8.23]:53328 helo=pbcl-dsk8.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1iSlHk-0004uI-1t; Thu, 07 Nov 2019 17:09:28 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next] Support LAN743x PTP periodic output on any GPIO
Date:   Thu,  7 Nov 2019 17:08:33 +0000
Message-Id: <20191107170833.16239-1-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.17.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ares.krystal.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - pebblebay.com
X-Get-Message-Sender-Via: ares.krystal.co.uk: authenticated_id: john.efstathiades@pebblebay.com
X-Authenticated-Sender: ares.krystal.co.uk: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LAN743x Ethernet controller provides two independent PTP event
channels. Each one can be used to generate a periodic output from
the PTP clock. The output can be routed to any one of the available
GPIO pins on the device.

The PTP clock API can now be used to:
- select any LAN743x GPIO pin to function as a periodic output
- select either LAN743x PTP event channel to generate the output

The LAN7430 has 4 GPIO pins that are multiplexed with its internal
PHY LED control signals. A pin assigned to the LED control function
will be assigned to the GPIO function if selected for PTP periodic
output.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/ethernet/microchip/lan743x_ptp.c | 299 +++++++++++++------
 drivers/net/ethernet/microchip/lan743x_ptp.h |  27 +-
 2 files changed, 230 insertions(+), 96 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 57b26c2acf87..e177b1ae03f1 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -11,7 +11,9 @@
 
 #include "lan743x_ptp.h"
 
-#define LAN743X_NUMBER_OF_GPIO			(12)
+#define LAN743X_LED0_ENABLE		20	/* LED0 offset in HW_CFG */
+#define LAN743X_LED_ENABLE(pin)		BIT(LAN743X_LED0_ENABLE + (pin))
+
 #define LAN743X_PTP_MAX_FREQ_ADJ_IN_PPB		(31249999)
 #define LAN743X_PTP_MAX_FINE_ADJ_IN_SCALED_PPM	(2047999934)
 
@@ -139,19 +141,20 @@ static void lan743x_ptp_tx_ts_complete(struct lan743x_adapter *adapter)
 	spin_unlock_bh(&ptp->tx_ts_lock);
 }
 
-static int lan743x_ptp_reserve_event_ch(struct lan743x_adapter *adapter)
+static int lan743x_ptp_reserve_event_ch(struct lan743x_adapter *adapter,
+					int event_channel)
 {
 	struct lan743x_ptp *ptp = &adapter->ptp;
 	int result = -ENODEV;
-	int index = 0;
 
 	mutex_lock(&ptp->command_lock);
-	for (index = 0; index < LAN743X_PTP_NUMBER_OF_EVENT_CHANNELS; index++) {
-		if (!(test_bit(index, &ptp->used_event_ch))) {
-			ptp->used_event_ch |= BIT(index);
-			result = index;
-			break;
-		}
+	if (!(test_bit(event_channel, &ptp->used_event_ch))) {
+		ptp->used_event_ch |= BIT(event_channel);
+		result = event_channel;
+	} else {
+		netif_warn(adapter, drv, adapter->netdev,
+			   "attempted to reserved a used event_channel = %d\n",
+			   event_channel);
 	}
 	mutex_unlock(&ptp->command_lock);
 	return result;
@@ -179,12 +182,62 @@ static void lan743x_ptp_clock_get(struct lan743x_adapter *adapter,
 static void lan743x_ptp_clock_step(struct lan743x_adapter *adapter,
 				   s64 time_step_ns);
 
+static void lan743x_led_mux_enable(struct lan743x_adapter *adapter,
+				   int pin, bool enable)
+{
+	struct lan743x_ptp *ptp = &adapter->ptp;
+
+	if (ptp->leds_multiplexed &&
+	    ptp->led_enabled[pin]) {
+		u32 val = lan743x_csr_read(adapter, HW_CFG);
+
+		if (enable)
+			val |= LAN743X_LED_ENABLE(pin);
+		else
+			val &= ~LAN743X_LED_ENABLE(pin);
+
+		lan743x_csr_write(adapter, HW_CFG, val);
+	}
+}
+
+static void lan743x_led_mux_save(struct lan743x_adapter *adapter)
+{
+	struct lan743x_ptp *ptp = &adapter->ptp;
+	u32 id_rev = adapter->csr.id_rev & ID_REV_ID_MASK_;
+
+	if (id_rev == ID_REV_ID_LAN7430_) {
+		int i;
+		u32 val = lan743x_csr_read(adapter, HW_CFG);
+
+		for (i = 0; i < LAN7430_N_LED; i++) {
+			bool led_enabled = (val & LAN743X_LED_ENABLE(i)) != 0;
+
+			ptp->led_enabled[i] = led_enabled;
+		}
+		ptp->leds_multiplexed = true;
+	} else {
+		ptp->leds_multiplexed = false;
+	}
+}
+
+static void lan743x_led_mux_restore(struct lan743x_adapter *adapter)
+{
+	u32 id_rev = adapter->csr.id_rev & ID_REV_ID_MASK_;
+
+	if (id_rev == ID_REV_ID_LAN7430_) {
+		int i;
+
+		for (i = 0; i < LAN7430_N_LED; i++)
+			lan743x_led_mux_enable(adapter, i, true);
+	}
+}
+
 static int lan743x_gpio_rsrv_ptp_out(struct lan743x_adapter *adapter,
-				     int bit, int ptp_channel)
+				     int pin, int event_channel)
 {
 	struct lan743x_gpio *gpio = &adapter->gpio;
 	unsigned long irq_flags = 0;
-	int bit_mask = BIT(bit);
+	int bit_mask = BIT(pin);
 	int ret = -EBUSY;
 
 	spin_lock_irqsave(&gpio->gpio_lock, irq_flags);
@@ -194,41 +247,44 @@ static int lan743x_gpio_rsrv_ptp_out(struct lan743x_adapter *adapter,
 		gpio->output_bits |= bit_mask;
 		gpio->ptp_bits |= bit_mask;
 
+		/* assign pin to GPIO function */
+		lan743x_led_mux_enable(adapter, pin, false);
+
 		/* set as output, and zero initial value */
-		gpio->gpio_cfg0 |= GPIO_CFG0_GPIO_DIR_BIT_(bit);
-		gpio->gpio_cfg0 &= ~GPIO_CFG0_GPIO_DATA_BIT_(bit);
+		gpio->gpio_cfg0 |= GPIO_CFG0_GPIO_DIR_BIT_(pin);
+		gpio->gpio_cfg0 &= ~GPIO_CFG0_GPIO_DATA_BIT_(pin);
 		lan743x_csr_write(adapter, GPIO_CFG0, gpio->gpio_cfg0);
 
 		/* enable gpio, and set buffer type to push pull */
-		gpio->gpio_cfg1 &= ~GPIO_CFG1_GPIOEN_BIT_(bit);
-		gpio->gpio_cfg1 |= GPIO_CFG1_GPIOBUF_BIT_(bit);
+		gpio->gpio_cfg1 &= ~GPIO_CFG1_GPIOEN_BIT_(pin);
+		gpio->gpio_cfg1 |= GPIO_CFG1_GPIOBUF_BIT_(pin);
 		lan743x_csr_write(adapter, GPIO_CFG1, gpio->gpio_cfg1);
 
 		/* set 1588 polarity to high */
-		gpio->gpio_cfg2 |= GPIO_CFG2_1588_POL_BIT_(bit);
+		gpio->gpio_cfg2 |= GPIO_CFG2_1588_POL_BIT_(pin);
 		lan743x_csr_write(adapter, GPIO_CFG2, gpio->gpio_cfg2);
 
-		if (!ptp_channel) {
+		if (event_channel == 0) {
 			/* use channel A */
-			gpio->gpio_cfg3 &= ~GPIO_CFG3_1588_CH_SEL_BIT_(bit);
+			gpio->gpio_cfg3 &= ~GPIO_CFG3_1588_CH_SEL_BIT_(pin);
 		} else {
 			/* use channel B */
-			gpio->gpio_cfg3 |= GPIO_CFG3_1588_CH_SEL_BIT_(bit);
+			gpio->gpio_cfg3 |= GPIO_CFG3_1588_CH_SEL_BIT_(pin);
 		}
-		gpio->gpio_cfg3 |= GPIO_CFG3_1588_OE_BIT_(bit);
+		gpio->gpio_cfg3 |= GPIO_CFG3_1588_OE_BIT_(pin);
 		lan743x_csr_write(adapter, GPIO_CFG3, gpio->gpio_cfg3);
 
-		ret = bit;
+		ret = pin;
 	}
 	spin_unlock_irqrestore(&gpio->gpio_lock, irq_flags);
 	return ret;
 }
 
-static void lan743x_gpio_release(struct lan743x_adapter *adapter, int bit)
+static void lan743x_gpio_release(struct lan743x_adapter *adapter, int pin)
 {
 	struct lan743x_gpio *gpio = &adapter->gpio;
 	unsigned long irq_flags = 0;
-	int bit_mask = BIT(bit);
+	int bit_mask = BIT(pin);
 
 	spin_lock_irqsave(&gpio->gpio_lock, irq_flags);
 	if (gpio->used_bits & bit_mask) {
@@ -239,21 +295,24 @@ static void lan743x_gpio_release(struct lan743x_adapter *adapter, int bit)
 			if (gpio->ptp_bits & bit_mask) {
 				gpio->ptp_bits &= ~bit_mask;
 				/* disable ptp output */
-				gpio->gpio_cfg3 &= ~GPIO_CFG3_1588_OE_BIT_(bit);
+				gpio->gpio_cfg3 &= ~GPIO_CFG3_1588_OE_BIT_(pin);
 				lan743x_csr_write(adapter, GPIO_CFG3,
 						  gpio->gpio_cfg3);
 			}
 			/* release gpio output */
 
 			/* disable gpio */
-			gpio->gpio_cfg1 |= GPIO_CFG1_GPIOEN_BIT_(bit);
-			gpio->gpio_cfg1 &= ~GPIO_CFG1_GPIOBUF_BIT_(bit);
+			gpio->gpio_cfg1 |= GPIO_CFG1_GPIOEN_BIT_(pin);
+			gpio->gpio_cfg1 &= ~GPIO_CFG1_GPIOBUF_BIT_(pin);
 			lan743x_csr_write(adapter, GPIO_CFG1, gpio->gpio_cfg1);
 
 			/* reset back to input */
-			gpio->gpio_cfg0 &= ~GPIO_CFG0_GPIO_DIR_BIT_(bit);
-			gpio->gpio_cfg0 &= ~GPIO_CFG0_GPIO_DATA_BIT_(bit);
+			gpio->gpio_cfg0 &= ~GPIO_CFG0_GPIO_DIR_BIT_(pin);
+			gpio->gpio_cfg0 &= ~GPIO_CFG0_GPIO_DATA_BIT_(pin);
 			lan743x_csr_write(adapter, GPIO_CFG0, gpio->gpio_cfg0);
+
+			/* assign pin to original function */
+			lan743x_led_mux_enable(adapter, pin, true);
 		}
 	}
 	spin_unlock_irqrestore(&gpio->gpio_lock, irq_flags);
@@ -391,89 +450,91 @@ static int lan743x_ptpci_settime64(struct ptp_clock_info *ptpci,
 	return 0;
 }
 
-static void lan743x_ptp_perout_off(struct lan743x_adapter *adapter)
+static void lan743x_ptp_perout_off(struct lan743x_adapter *adapter,
+				   unsigned int index)
 {
 	struct lan743x_ptp *ptp = &adapter->ptp;
 	u32 general_config = 0;
+	struct lan743x_ptp_perout *perout = &ptp->perout[index];
 
-	if (ptp->perout_gpio_bit >= 0) {
-		lan743x_gpio_release(adapter, ptp->perout_gpio_bit);
-		ptp->perout_gpio_bit = -1;
+	if (perout->gpio_pin >= 0) {
+		lan743x_gpio_release(adapter, perout->gpio_pin);
+		perout->gpio_pin = -1;
 	}
 
-	if (ptp->perout_event_ch >= 0) {
+	if (perout->event_ch >= 0) {
 		/* set target to far in the future, effectively disabling it */
 		lan743x_csr_write(adapter,
-				  PTP_CLOCK_TARGET_SEC_X(ptp->perout_event_ch),
+				  PTP_CLOCK_TARGET_SEC_X(perout->event_ch),
 				  0xFFFF0000);
 		lan743x_csr_write(adapter,
-				  PTP_CLOCK_TARGET_NS_X(ptp->perout_event_ch),
+				  PTP_CLOCK_TARGET_NS_X(perout->event_ch),
 				  0);
 
 		general_config = lan743x_csr_read(adapter, PTP_GENERAL_CONFIG);
 		general_config |= PTP_GENERAL_CONFIG_RELOAD_ADD_X_
-				  (ptp->perout_event_ch);
+				  (perout->event_ch);
 		lan743x_csr_write(adapter, PTP_GENERAL_CONFIG, general_config);
-		lan743x_ptp_release_event_ch(adapter, ptp->perout_event_ch);
-		ptp->perout_event_ch = -1;
+		lan743x_ptp_release_event_ch(adapter, perout->event_ch);
+		perout->event_ch = -1;
 	}
 }
 
 static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
-			      struct ptp_perout_request *perout)
+			      struct ptp_perout_request *perout_request)
 {
 	struct lan743x_ptp *ptp = &adapter->ptp;
 	u32 period_sec = 0, period_nsec = 0;
 	u32 start_sec = 0, start_nsec = 0;
 	u32 general_config = 0;
 	int pulse_width = 0;
-	int perout_bit = 0;
-
-	if (!on) {
-		lan743x_ptp_perout_off(adapter);
+	int perout_pin = 0;
+	unsigned int index = perout_request->index;
+	struct lan743x_ptp_perout *perout = &ptp->perout[index];
+
+	if (on) {
+		perout_pin = ptp_find_pin(ptp->ptp_clock, PTP_PF_PEROUT,
+					  perout_request->index);
+		if (perout_pin < 0)
+			return -EBUSY;
+	} else {
+		lan743x_ptp_perout_off(adapter, index);
 		return 0;
 	}
 
-	if (ptp->perout_event_ch >= 0 ||
-	    ptp->perout_gpio_bit >= 0) {
+	if (perout->event_ch >= 0 ||
+	    perout->gpio_pin >= 0) {
 		/* already on, turn off first */
-		lan743x_ptp_perout_off(adapter);
+		lan743x_ptp_perout_off(adapter, index);
 	}
 
-	ptp->perout_event_ch = lan743x_ptp_reserve_event_ch(adapter);
-	if (ptp->perout_event_ch < 0) {
+	perout->event_ch = lan743x_ptp_reserve_event_ch(adapter, index);
+
+	if (perout->event_ch < 0) {
 		netif_warn(adapter, drv, adapter->netdev,
-			   "Failed to reserve event channel for PEROUT\n");
+			   "Failed to reserve event channel %d for PEROUT\n",
+			   index);
 		goto failed;
 	}
 
-	switch (adapter->csr.id_rev & ID_REV_ID_MASK_) {
-	case ID_REV_ID_LAN7430_:
-		perout_bit = 2;/* GPIO 2 is preferred on EVB LAN7430 */
-		break;
-	case ID_REV_ID_LAN7431_:
-		perout_bit = 4;/* GPIO 4 is preferred on EVB LAN7431 */
-		break;
-	}
+	perout->gpio_pin = lan743x_gpio_rsrv_ptp_out(adapter,
+						     perout_pin,
+						     perout->event_ch);
 
-	ptp->perout_gpio_bit = lan743x_gpio_rsrv_ptp_out(adapter,
-							 perout_bit,
-							 ptp->perout_event_ch);
-
-	if (ptp->perout_gpio_bit < 0) {
+	if (perout->gpio_pin < 0) {
 		netif_warn(adapter, drv, adapter->netdev,
 			   "Failed to reserve gpio %d for PEROUT\n",
-			   perout_bit);
+			   perout_pin);
 		goto failed;
 	}
 
-	start_sec = perout->start.sec;
-	start_sec += perout->start.nsec / 1000000000;
-	start_nsec = perout->start.nsec % 1000000000;
+	start_sec = perout_request->start.sec;
+	start_sec += perout_request->start.nsec / 1000000000;
+	start_nsec = perout_request->start.nsec % 1000000000;
 
-	period_sec = perout->period.sec;
-	period_sec += perout->period.nsec / 1000000000;
-	period_nsec = perout->period.nsec % 1000000000;
+	period_sec = perout_request->period.sec;
+	period_sec += perout_request->period.nsec / 1000000000;
+	period_nsec = perout_request->period.nsec % 1000000000;
 
 	if (period_sec == 0) {
 		if (period_nsec >= 400000000) {
@@ -499,41 +560,41 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
 
 	/* turn off by setting target far in future */
 	lan743x_csr_write(adapter,
-			  PTP_CLOCK_TARGET_SEC_X(ptp->perout_event_ch),
+			  PTP_CLOCK_TARGET_SEC_X(perout->event_ch),
 			  0xFFFF0000);
 	lan743x_csr_write(adapter,
-			  PTP_CLOCK_TARGET_NS_X(ptp->perout_event_ch), 0);
+			  PTP_CLOCK_TARGET_NS_X(perout->event_ch), 0);
 
 	/* Configure to pulse every period */
 	general_config = lan743x_csr_read(adapter, PTP_GENERAL_CONFIG);
 	general_config &= ~(PTP_GENERAL_CONFIG_CLOCK_EVENT_X_MASK_
-			  (ptp->perout_event_ch));
+			  (perout->event_ch));
 	general_config |= PTP_GENERAL_CONFIG_CLOCK_EVENT_X_SET_
-			  (ptp->perout_event_ch, pulse_width);
+			  (perout->event_ch, pulse_width);
 	general_config &= ~PTP_GENERAL_CONFIG_RELOAD_ADD_X_
-			  (ptp->perout_event_ch);
+			  (perout->event_ch);
 	lan743x_csr_write(adapter, PTP_GENERAL_CONFIG, general_config);
 
 	/* set the reload to one toggle cycle */
 	lan743x_csr_write(adapter,
-			  PTP_CLOCK_TARGET_RELOAD_SEC_X(ptp->perout_event_ch),
+			  PTP_CLOCK_TARGET_RELOAD_SEC_X(perout->event_ch),
 			  period_sec);
 	lan743x_csr_write(adapter,
-			  PTP_CLOCK_TARGET_RELOAD_NS_X(ptp->perout_event_ch),
+			  PTP_CLOCK_TARGET_RELOAD_NS_X(perout->event_ch),
 			  period_nsec);
 
 	/* set the start time */
 	lan743x_csr_write(adapter,
-			  PTP_CLOCK_TARGET_SEC_X(ptp->perout_event_ch),
+			  PTP_CLOCK_TARGET_SEC_X(perout->event_ch),
 			  start_sec);
 	lan743x_csr_write(adapter,
-			  PTP_CLOCK_TARGET_NS_X(ptp->perout_event_ch),
+			  PTP_CLOCK_TARGET_NS_X(perout->event_ch),
 			  start_nsec);
 
 	return 0;
 
 failed:
-	lan743x_ptp_perout_off(adapter);
+	lan743x_ptp_perout_off(adapter, index);
 	return -ENODEV;
 }
 
@@ -550,7 +611,7 @@ static int lan743x_ptpci_enable(struct ptp_clock_info *ptpci,
 		case PTP_CLK_REQ_EXTTS:
 			return -EINVAL;
 		case PTP_CLK_REQ_PEROUT:
-			if (request->perout.index == 0)
+			if (request->perout.index < ptpci->n_per_out)
 				return lan743x_ptp_perout(adapter, on,
 							  &request->perout);
 			return -EINVAL;
@@ -568,6 +629,29 @@ static int lan743x_ptpci_enable(struct ptp_clock_info *ptpci,
 	return 0;
 }
 
+static int lan743x_ptpci_verify_pin_config(struct ptp_clock_info *ptp,
+					   unsigned int pin,
+					   enum ptp_pin_function func,
+					   unsigned int chan)
+{
+	int result = 0;
+
+	/* Confirm the requested function is supported. Parameter
+	 * validation is done by the caller.
+	 */
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_PEROUT:
+		break;
+	case PTP_PF_EXTTS:
+	case PTP_PF_PHYSYNC:
+	default:
+		result = -1;
+		break;
+	}
+	return result;
+}
+
 static long lan743x_ptpci_do_aux_work(struct ptp_clock_info *ptpci)
 {
 	struct lan743x_ptp *ptp =
@@ -861,12 +945,19 @@ void lan743x_ptp_update_latency(struct lan743x_adapter *adapter,
 int lan743x_ptp_init(struct lan743x_adapter *adapter)
 {
 	struct lan743x_ptp *ptp = &adapter->ptp;
+	int i;
 
 	mutex_init(&ptp->command_lock);
 	spin_lock_init(&ptp->tx_ts_lock);
 	ptp->used_event_ch = 0;
-	ptp->perout_event_ch = -1;
-	ptp->perout_gpio_bit = -1;
+
+	for (i = 0; i < LAN743X_PTP_N_EVENT_CHAN; i++) {
+		ptp->perout[i].event_ch = -1;
+		ptp->perout[i].gpio_pin = -1;
+	}
+
+	lan743x_led_mux_save(adapter);
+
 	return 0;
 }
 
@@ -875,6 +966,8 @@ int lan743x_ptp_open(struct lan743x_adapter *adapter)
 	struct lan743x_ptp *ptp = &adapter->ptp;
 	int ret = -ENODEV;
 	u32 temp;
+	int i;
+	int n_pins;
 
 	lan743x_ptp_reset(adapter);
 	lan743x_ptp_sync_to_system_clock(adapter);
@@ -890,10 +983,32 @@ int lan743x_ptp_open(struct lan743x_adapter *adapter)
 	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK))
 		return 0;
 
-	snprintf(ptp->pin_config[0].name, 32, "lan743x_ptp_pin_0");
-	ptp->pin_config[0].index = 0;
-	ptp->pin_config[0].func = PTP_PF_PEROUT;
-	ptp->pin_config[0].chan = 0;
+	switch (adapter->csr.id_rev & ID_REV_ID_MASK_) {
+	case ID_REV_ID_LAN7430_:
+		n_pins = LAN7430_N_GPIO;
+		break;
+	case ID_REV_ID_LAN7431_:
+		n_pins = LAN7431_N_GPIO;
+		break;
+	default:
+		netif_warn(adapter, drv, adapter->netdev,
+			   "Unknown LAN743x (%08x). Assuming no GPIO\n",
+			   adapter->csr.id_rev);
+		n_pins = 0;
+		break;
+	}
+
+	if (n_pins > LAN743X_PTP_N_GPIO)
+		n_pins = LAN743X_PTP_N_GPIO;
+
+	for (i = 0; i < n_pins; i++) {
+		struct ptp_pin_desc *ptp_pin = &ptp->pin_config[i];
+
+		snprintf(ptp_pin->name,
+			 sizeof(ptp_pin->name), "lan743x_ptp_pin_%02d", i);
+		ptp_pin->index = i;
+		ptp_pin->func = PTP_PF_NONE;
+	}
 
 	ptp->ptp_clock_info.owner = THIS_MODULE;
 	snprintf(ptp->ptp_clock_info.name, 16, "%pm",
@@ -901,10 +1016,10 @@ int lan743x_ptp_open(struct lan743x_adapter *adapter)
 	ptp->ptp_clock_info.max_adj = LAN743X_PTP_MAX_FREQ_ADJ_IN_PPB;
 	ptp->ptp_clock_info.n_alarm = 0;
 	ptp->ptp_clock_info.n_ext_ts = 0;
-	ptp->ptp_clock_info.n_per_out = 1;
-	ptp->ptp_clock_info.n_pins = 0;
+	ptp->ptp_clock_info.n_per_out = LAN743X_PTP_N_EVENT_CHAN;
+	ptp->ptp_clock_info.n_pins = n_pins;
 	ptp->ptp_clock_info.pps = 0;
-	ptp->ptp_clock_info.pin_config = NULL;
+	ptp->ptp_clock_info.pin_config = ptp->pin_config;
 	ptp->ptp_clock_info.adjfine = lan743x_ptpci_adjfine;
 	ptp->ptp_clock_info.adjfreq = lan743x_ptpci_adjfreq;
 	ptp->ptp_clock_info.adjtime = lan743x_ptpci_adjtime;
@@ -913,7 +1028,7 @@ int lan743x_ptp_open(struct lan743x_adapter *adapter)
 	ptp->ptp_clock_info.settime64 = lan743x_ptpci_settime64;
 	ptp->ptp_clock_info.enable = lan743x_ptpci_enable;
 	ptp->ptp_clock_info.do_aux_work = lan743x_ptpci_do_aux_work;
-	ptp->ptp_clock_info.verify = NULL;
+	ptp->ptp_clock_info.verify = lan743x_ptpci_verify_pin_config;
 
 	ptp->ptp_clock = ptp_clock_register(&ptp->ptp_clock_info,
 					    &adapter->pdev->dev);
@@ -939,7 +1054,7 @@ void lan743x_ptp_close(struct lan743x_adapter *adapter)
 	int index;
 
 	if (IS_ENABLED(CONFIG_PTP_1588_CLOCK) &&
-	    ptp->flags & PTP_FLAG_PTP_CLOCK_REGISTERED) {
+	    (ptp->flags & PTP_FLAG_PTP_CLOCK_REGISTERED)) {
 		ptp_clock_unregister(ptp->ptp_clock);
 		ptp->ptp_clock = NULL;
 		ptp->flags &= ~PTP_FLAG_PTP_CLOCK_REGISTERED;
@@ -973,6 +1088,8 @@ void lan743x_ptp_close(struct lan743x_adapter *adapter)
 	ptp->pending_tx_timestamps = 0;
 	spin_unlock_bh(&ptp->tx_ts_lock);
 
+	lan743x_led_mux_restore(adapter);
+
 	lan743x_ptp_disable(adapter);
 }
 
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.h b/drivers/net/ethernet/microchip/lan743x_ptp.h
index 5fc1b3cd5e33..7663bf5d2e33 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.h
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.h
@@ -7,6 +7,18 @@
 #include "linux/ptp_clock_kernel.h"
 #include "linux/netdevice.h"
 
+#define LAN7430_N_LED			4
+#define LAN7430_N_GPIO			4	/* multiplexed with PHY LEDs */
+#define LAN7431_N_GPIO			12
+
+#define LAN743X_PTP_N_GPIO		LAN7431_N_GPIO
+
+/* the number of periodic outputs is limited by number of
+ * PTP clock event channels
+ */
+#define LAN743X_PTP_N_EVENT_CHAN	2
+#define LAN743X_PTP_N_PEROUT		LAN743X_PTP_N_EVENT_CHAN
+
 struct lan743x_adapter;
 
 /* GPIO */
@@ -40,9 +52,14 @@ int lan743x_ptp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd);
 
 #define LAN743X_PTP_NUMBER_OF_TX_TIMESTAMPS (4)
 
-#define PTP_FLAG_PTP_CLOCK_REGISTERED	BIT(1)
+#define PTP_FLAG_PTP_CLOCK_REGISTERED		BIT(1)
 #define PTP_FLAG_ISR_ENABLED			BIT(2)
 
+struct lan743x_ptp_perout {
+	int  event_ch;	/* PTP event channel (0=channel A, 1=channel B) */
+	int  gpio_pin;	/* GPIO pin where output appears */
+};
+
 struct lan743x_ptp {
 	int flags;
 
@@ -51,13 +68,13 @@ struct lan743x_ptp {
 
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_clock_info;
-	struct ptp_pin_desc pin_config[1];
+	struct ptp_pin_desc pin_config[LAN743X_PTP_N_GPIO];
 
-#define LAN743X_PTP_NUMBER_OF_EVENT_CHANNELS (2)
 	unsigned long used_event_ch;
+	struct lan743x_ptp_perout perout[LAN743X_PTP_N_PEROUT];
 
-	int perout_event_ch;
-	int perout_gpio_bit;
+	bool leds_multiplexed;
+	bool led_enabled[LAN7430_N_LED];
 
 	/* tx_ts_lock: used to prevent concurrent access to timestamp arrays */
 	spinlock_t	tx_ts_lock;
-- 
2.17.1

