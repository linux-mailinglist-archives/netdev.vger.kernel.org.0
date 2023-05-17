Return-Path: <netdev+bounces-3278-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E009D706570
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94F6B280AB7
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03E4168B4;
	Wed, 17 May 2023 10:38:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E45B171B3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:38:26 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE2F49C9
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Uyk6ofcvJqtpYh7dHqrw+K/mVou+tQmyFXGQsJYVD9s=; b=cC1ggUkDKB+1n2qPE3AqlslaCA
	nWk5vOtDhalXTJdN6UPVCiRcYf1yh7nbPZjRfJtMWAZEaK0cVHoyfzXdovqbxUV3j7tis+w7p/3A9
	pEBBWL51TM8tAfrCOG8MyFH4JjgznqO4nZ++JXkAKPvAKh5U75ajEJbZV2ySKizcD1ThioykpSs6T
	u2sWKPJiBBydgTXehljNXoqMP2FxAg9O+lUf4PM3A181EKPsd/B8mK+jjzQdqCXFykm3/wVT0WOjO
	4wSv8Qd1OVbBiu4qeljMTkiSPxK7TyqNuKchmtYoGCszjnOdVXLBKyswa7xJx6IFfk2Rmx2Dip+i7
	flvzh6WQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40680 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pzEXy-0007ZP-K8; Wed, 17 May 2023 11:38:18 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pzEXx-005jUu-W2; Wed, 17 May 2023 11:38:18 +0100
In-Reply-To: <ZGSuTY8GqjM+sqta@shell.armlinux.org.uk>
References: <ZGSuTY8GqjM+sqta@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 7/7] net: sfp: add support for rate selection
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pzEXx-005jUu-W2@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 17 May 2023 11:38:17 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for parsing the rate select thresholds and switching of the
RS0 and RS1 signals to the transceiver. This is complicated by various
revisions of SFF-8472 and interaction of SFF-8431, SFF-8079 and
INF-8074.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 212 +++++++++++++++++++++++++++++++++++++-----
 include/linux/sfp.h   |   8 ++
 2 files changed, 196 insertions(+), 24 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 34bf724c00c7..4799976a1609 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -24,14 +24,18 @@ enum {
 	GPIO_LOS,
 	GPIO_TX_FAULT,
 	GPIO_TX_DISABLE,
-	GPIO_RATE_SELECT,
+	GPIO_RS0,
+	GPIO_RS1,
 	GPIO_MAX,
 
 	SFP_F_PRESENT = BIT(GPIO_MODDEF0),
 	SFP_F_LOS = BIT(GPIO_LOS),
 	SFP_F_TX_FAULT = BIT(GPIO_TX_FAULT),
 	SFP_F_TX_DISABLE = BIT(GPIO_TX_DISABLE),
-	SFP_F_RATE_SELECT = BIT(GPIO_RATE_SELECT),
+	SFP_F_RS0 = BIT(GPIO_RS0),
+	SFP_F_RS1 = BIT(GPIO_RS1),
+
+	SFP_F_OUTPUTS = SFP_F_TX_DISABLE | SFP_F_RS0 | SFP_F_RS1,
 
 	SFP_E_INSERT = 0,
 	SFP_E_REMOVE,
@@ -148,6 +152,7 @@ static const char *gpio_names[] = {
 	"tx-fault",
 	"tx-disable",
 	"rate-select0",
+	"rate-select1",
 };
 
 static const enum gpiod_flags gpio_flags[] = {
@@ -156,6 +161,7 @@ static const enum gpiod_flags gpio_flags[] = {
 	GPIOD_IN,
 	GPIOD_ASIS,
 	GPIOD_ASIS,
+	GPIOD_ASIS,
 };
 
 /* t_start_up (SFF-8431) or t_init (SFF-8472) is the time required for a
@@ -249,6 +255,7 @@ struct sfp {
 	 * state: st_mutex held unless reading input bits
 	 */
 	struct mutex st_mutex;			/* Protects state */
+	unsigned int state_hw_drive;
 	unsigned int state_hw_mask;
 	unsigned int state_soft_mask;
 	unsigned int state;
@@ -269,6 +276,10 @@ struct sfp {
 	unsigned int module_t_start_up;
 	unsigned int module_t_wait;
 
+	unsigned int rate_kbd;
+	unsigned int rs_threshold_kbd;
+	unsigned int rs_state_mask;
+
 	bool have_a2;
 	bool tx_fault_ignore;
 
@@ -319,7 +330,7 @@ static bool sfp_module_supported(const struct sfp_eeprom_id *id)
 
 static const struct sff_data sfp_data = {
 	.gpios = SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT |
-		 SFP_F_TX_DISABLE | SFP_F_RATE_SELECT,
+		 SFP_F_TX_DISABLE | SFP_F_RS0 | SFP_F_RS1,
 	.module_supported = sfp_module_supported,
 };
 
@@ -507,20 +518,37 @@ static unsigned int sff_gpio_get_state(struct sfp *sfp)
 
 static void sfp_gpio_set_state(struct sfp *sfp, unsigned int state)
 {
-	if (state & SFP_F_PRESENT) {
-		/* If the module is present, drive the signals */
-		if (sfp->gpio[GPIO_TX_DISABLE])
+	unsigned int drive;
+
+	if (state & SFP_F_PRESENT)
+		/* If the module is present, drive the requested signals */
+		drive = sfp->state_hw_drive;
+	else
+		/* Otherwise, let them float to the pull-ups */
+		drive = 0;
+
+	if (sfp->gpio[GPIO_TX_DISABLE]) {
+		if (drive & SFP_F_TX_DISABLE)
 			gpiod_direction_output(sfp->gpio[GPIO_TX_DISABLE],
 					       state & SFP_F_TX_DISABLE);
-		if (state & SFP_F_RATE_SELECT)
-			gpiod_direction_output(sfp->gpio[GPIO_RATE_SELECT],
-					       state & SFP_F_RATE_SELECT);
-	} else {
-		/* Otherwise, let them float to the pull-ups */
-		if (sfp->gpio[GPIO_TX_DISABLE])
+		else
 			gpiod_direction_input(sfp->gpio[GPIO_TX_DISABLE]);
-		if (state & SFP_F_RATE_SELECT)
-			gpiod_direction_input(sfp->gpio[GPIO_RATE_SELECT]);
+	}
+
+	if (sfp->gpio[GPIO_RS0]) {
+		if (drive & SFP_F_RS0)
+			gpiod_direction_output(sfp->gpio[GPIO_RS0],
+					       state & SFP_F_RS0);
+		else
+			gpiod_direction_input(sfp->gpio[GPIO_RS0]);
+	}
+
+	if (sfp->gpio[GPIO_RS1]) {
+		if (drive & SFP_F_RS1)
+			gpiod_direction_output(sfp->gpio[GPIO_RS1],
+					       state & SFP_F_RS1);
+		else
+			gpiod_direction_input(sfp->gpio[GPIO_RS1]);
 	}
 }
 
@@ -682,16 +710,33 @@ static unsigned int sfp_soft_get_state(struct sfp *sfp)
 	return state & sfp->state_soft_mask;
 }
 
-static void sfp_soft_set_state(struct sfp *sfp, unsigned int state)
+static void sfp_soft_set_state(struct sfp *sfp, unsigned int state,
+			       unsigned int soft)
 {
-	u8 mask = SFP_STATUS_TX_DISABLE_FORCE;
+	u8 mask = 0;
 	u8 val = 0;
 
+	if (soft & SFP_F_TX_DISABLE)
+		mask |= SFP_STATUS_TX_DISABLE_FORCE;
 	if (state & SFP_F_TX_DISABLE)
 		val |= SFP_STATUS_TX_DISABLE_FORCE;
 
+	if (soft & SFP_F_RS0)
+		mask |= SFP_STATUS_RS0_SELECT;
+	if (state & SFP_F_RS0)
+		val |= SFP_STATUS_RS0_SELECT;
+
+	if (mask)
+		sfp_modify_u8(sfp, true, SFP_STATUS, mask, val);
 
-	sfp_modify_u8(sfp, true, SFP_STATUS, mask, val);
+	val = mask = 0;
+	if (soft & SFP_F_RS1)
+		mask |= SFP_EXT_STATUS_RS1_SELECT;
+	if (state & SFP_F_RS1)
+		val |= SFP_EXT_STATUS_RS1_SELECT;
+
+	if (mask)
+		sfp_modify_u8(sfp, true, SFP_EXT_STATUS, mask, val);
 }
 
 static void sfp_soft_start_poll(struct sfp *sfp)
@@ -705,6 +750,8 @@ static void sfp_soft_start_poll(struct sfp *sfp)
 		mask |= SFP_F_TX_FAULT;
 	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_RX_LOS)
 		mask |= SFP_F_LOS;
+	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_RATE_SELECT)
+		mask |= sfp->rs_state_mask;
 
 	mutex_lock(&sfp->st_mutex);
 	// Poll the soft state for hardware pins we want to ignore
@@ -743,11 +790,13 @@ static unsigned int sfp_get_state(struct sfp *sfp)
  */
 static void sfp_set_state(struct sfp *sfp, unsigned int state)
 {
+	unsigned int soft;
+
 	sfp->set_state(sfp, state);
 
-	if (state & SFP_F_PRESENT &&
-	    sfp->state_soft_mask & SFP_F_TX_DISABLE)
-		sfp_soft_set_state(sfp, state);
+	soft = sfp->state_soft_mask & SFP_F_OUTPUTS;
+	if (state & SFP_F_PRESENT && soft)
+		sfp_soft_set_state(sfp, state, soft);
 }
 
 static void sfp_mod_state(struct sfp *sfp, unsigned int mask, unsigned int set)
@@ -1589,10 +1638,15 @@ static int sfp_debug_state_show(struct seq_file *s, void *data)
 		   sfp->sm_fault_retries);
 	seq_printf(s, "PHY probe remaining retries: %d\n",
 		   sfp->sm_phy_retries);
+	seq_printf(s, "Signalling rate: %u kBd\n", sfp->rate_kbd);
+	seq_printf(s, "Rate select threshold: %u kBd\n",
+		   sfp->rs_threshold_kbd);
 	seq_printf(s, "moddef0: %d\n", !!(sfp->state & SFP_F_PRESENT));
 	seq_printf(s, "rx_los: %d\n", !!(sfp->state & SFP_F_LOS));
 	seq_printf(s, "tx_fault: %d\n", !!(sfp->state & SFP_F_TX_FAULT));
 	seq_printf(s, "tx_disable: %d\n", !!(sfp->state & SFP_F_TX_DISABLE));
+	seq_printf(s, "rs0: %d\n", !!(sfp->state & SFP_F_RS0));
+	seq_printf(s, "rs1: %d\n", !!(sfp->state & SFP_F_RS1));
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(sfp_debug_state);
@@ -1898,6 +1952,95 @@ static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
 	return 0;
 }
 
+static void sfp_module_parse_rate_select(struct sfp *sfp)
+{
+	u8 rate_id;
+
+	sfp->rs_threshold_kbd = 0;
+	sfp->rs_state_mask = 0;
+
+	if (!(sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_RATE_SELECT)))
+		/* No support for RateSelect */
+		return;
+
+	/* Default to INF-8074 RateSelect operation. The signalling threshold
+	 * rate is not well specified, so always select "Full Bandwidth", but
+	 * SFF-8079 reveals that it is understood that RS0 will be low for
+	 * 1.0625Gb/s and high for 2.125Gb/s. Choose a value half-way between.
+	 * This method exists prior to SFF-8472.
+	 */
+	sfp->rs_state_mask = SFP_F_RS0;
+	sfp->rs_threshold_kbd = 1594;
+
+	/* Parse the rate identifier, which is complicated due to history:
+	 * SFF-8472 rev 9.5 marks this field as reserved.
+	 * SFF-8079 references SFF-8472 rev 9.5 and defines bit 0. SFF-8472
+	 *  compliance is not required.
+	 * SFF-8472 rev 10.2 defines this field using values 0..4
+	 * SFF-8472 rev 11.0 redefines this field with bit 0 for SFF-8079
+	 * and even values.
+	 */
+	rate_id = sfp->id.base.rate_id;
+	if (rate_id == 0)
+		/* Unspecified */
+		return;
+
+	/* SFF-8472 rev 10.0..10.4 did not account for SFF-8079 using bit 0,
+	 * and allocated value 3 to SFF-8431 independent tx/rx rate select.
+	 * Convert this to a SFF-8472 rev 11.0 rate identifier.
+	 */
+	if (sfp->id.ext.sff8472_compliance >= SFP_SFF8472_COMPLIANCE_REV10_2 &&
+	    sfp->id.ext.sff8472_compliance < SFP_SFF8472_COMPLIANCE_REV11_0 &&
+	    rate_id == 3)
+		rate_id = SFF_RID_8431;
+
+	if (rate_id & SFF_RID_8079) {
+		/* SFF-8079 RateSelect / Application Select in conjunction with
+		 * SFF-8472 rev 9.5. SFF-8079 defines rate_id as a bitfield
+		 * with only bit 0 used, which takes precedence over SFF-8472.
+		 */
+		if (!(sfp->id.ext.enhopts & SFP_ENHOPTS_APP_SELECT_SFF8079)) {
+			/* SFF-8079 Part 1 - rate selection between Fibre
+			 * Channel 1.0625/2.125/4.25 Gbd modes. Note that RS0
+			 * is high for 2125, so we have to subtract 1 to
+			 * include it.
+			 */
+			sfp->rs_threshold_kbd = 2125 - 1;
+			sfp->rs_state_mask = SFP_F_RS0;
+		}
+		return;
+	}
+
+	/* SFF-8472 rev 9.5 does not define the rate identifier */
+	if (sfp->id.ext.sff8472_compliance <= SFP_SFF8472_COMPLIANCE_REV9_5)
+		return;
+
+	/* SFF-8472 rev 11.0 defines rate_id as a numerical value which will
+	 * always have bit 0 clear due to SFF-8079's bitfield usage of rate_id.
+	 */
+	switch (rate_id) {
+	case SFF_RID_8431_RX_ONLY:
+		sfp->rs_threshold_kbd = 4250;
+		sfp->rs_state_mask = SFP_F_RS0;
+		break;
+
+	case SFF_RID_8431_TX_ONLY:
+		sfp->rs_threshold_kbd = 4250;
+		sfp->rs_state_mask = SFP_F_RS1;
+		break;
+
+	case SFF_RID_8431:
+		sfp->rs_threshold_kbd = 4250;
+		sfp->rs_state_mask = SFP_F_RS0 | SFP_F_RS1;
+		break;
+
+	case SFF_RID_10G8G:
+		sfp->rs_threshold_kbd = 9000;
+		sfp->rs_state_mask = SFP_F_RS0 | SFP_F_RS1;
+		break;
+	}
+}
+
 /* GPON modules based on Realtek RTL8672 and RTL9601C chips (e.g. V-SOL
  * V2801F, CarlitoxxPro CPGOS03-0490, Ubiquiti U-Fiber Instant, ...) do
  * not support multibyte reads from the EEPROM. Each multi-byte read
@@ -2117,6 +2260,8 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	if (ret < 0)
 		return ret;
 
+	sfp_module_parse_rate_select(sfp);
+
 	mask = SFP_F_PRESENT;
 	if (sfp->gpio[GPIO_TX_DISABLE])
 		mask |= SFP_F_TX_DISABLE;
@@ -2124,6 +2269,10 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		mask |= SFP_F_TX_FAULT;
 	if (sfp->gpio[GPIO_LOS])
 		mask |= SFP_F_LOS;
+	if (sfp->gpio[GPIO_RS0])
+		mask |= SFP_F_RS0;
+	if (sfp->gpio[GPIO_RS1])
+		mask |= SFP_F_RS1;
 
 	sfp->module_t_start_up = T_START_UP;
 	sfp->module_t_wait = T_WAIT;
@@ -2146,6 +2295,9 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	/* Initialise state bits to use from hardware */
 	sfp->state_hw_mask = mask;
 
+	/* We want to drive the rate select pins that the module is using */
+	sfp->state_hw_drive |= sfp->rs_state_mask;
+
 	if (sfp->quirk && sfp->quirk->fixup)
 		sfp->quirk->fixup(sfp);
 	mutex_unlock(&sfp->st_mutex);
@@ -2162,6 +2314,7 @@ static void sfp_sm_mod_remove(struct sfp *sfp)
 
 	memset(&sfp->id, 0, sizeof(sfp->id));
 	sfp->module_power_mW = 0;
+	sfp->state_hw_drive = SFP_F_TX_DISABLE;
 	sfp->have_a2 = false;
 
 	dev_info(sfp->dev, "module removed\n");
@@ -2529,6 +2682,16 @@ static void sfp_stop(struct sfp *sfp)
 
 static void sfp_set_signal_rate(struct sfp *sfp, unsigned int rate_kbd)
 {
+	unsigned int set;
+
+	sfp->rate_kbd = rate_kbd;
+
+	if (rate_kbd > sfp->rs_threshold_kbd)
+		set = sfp->rs_state_mask;
+	else
+		set = 0;
+
+	sfp_mod_state(sfp, SFP_F_RS0 | SFP_F_RS1, set);
 }
 
 static int sfp_module_info(struct sfp *sfp, struct ethtool_modinfo *modinfo)
@@ -2648,7 +2811,7 @@ static void sfp_check_state(struct sfp *sfp)
 			dev_dbg(sfp->dev, "%s %u -> %u\n", gpio_names[i],
 				!!(sfp->state & BIT(i)), !!(state & BIT(i)));
 
-	state |= sfp->state & (SFP_F_TX_DISABLE | SFP_F_RATE_SELECT);
+	state |= sfp->state & SFP_F_OUTPUTS;
 	sfp->state = state;
 	mutex_unlock(&sfp->st_mutex);
 
@@ -2790,6 +2953,7 @@ static int sfp_probe(struct platform_device *pdev)
 		}
 
 	sfp->state_hw_mask = SFP_F_PRESENT;
+	sfp->state_hw_drive = SFP_F_TX_DISABLE;
 
 	sfp->get_state = sfp_gpio_get_state;
 	sfp->set_state = sfp_gpio_set_state;
@@ -2815,9 +2979,9 @@ static int sfp_probe(struct platform_device *pdev)
 	 */
 	sfp->state = sfp_get_state(sfp) | SFP_F_TX_DISABLE;
 
-	if (sfp->gpio[GPIO_RATE_SELECT] &&
-	    gpiod_get_value_cansleep(sfp->gpio[GPIO_RATE_SELECT]))
-		sfp->state |= SFP_F_RATE_SELECT;
+	if (sfp->gpio[GPIO_RS0] &&
+	    gpiod_get_value_cansleep(sfp->gpio[GPIO_RS0]))
+		sfp->state |= SFP_F_RS0;
 	sfp_set_state(sfp, sfp->state);
 	sfp_module_tx_disable(sfp);
 	if (sfp->state & SFP_F_PRESENT) {
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 2f66e03e9dbd..9346cd44814d 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -342,6 +342,12 @@ enum {
 	SFP_ENCODING			= 11,
 	SFP_BR_NOMINAL			= 12,
 	SFP_RATE_ID			= 13,
+	SFF_RID_8079			= 0x01,
+	SFF_RID_8431_RX_ONLY		= 0x02,
+	SFF_RID_8431_TX_ONLY		= 0x04,
+	SFF_RID_8431			= 0x06,
+	SFF_RID_10G8G			= 0x0e,
+
 	SFP_LINK_LEN_SM_KM		= 14,
 	SFP_LINK_LEN_SM_100M		= 15,
 	SFP_LINK_LEN_50UM_OM2_10M	= 16,
@@ -465,6 +471,7 @@ enum {
 	SFP_STATUS			= 110,
 	SFP_STATUS_TX_DISABLE		= BIT(7),
 	SFP_STATUS_TX_DISABLE_FORCE	= BIT(6),
+	SFP_STATUS_RS0_SELECT		= BIT(3),
 	SFP_STATUS_TX_FAULT		= BIT(2),
 	SFP_STATUS_RX_LOS		= BIT(1),
 	SFP_ALARM0			= 112,
@@ -496,6 +503,7 @@ enum {
 	SFP_WARN1_RXPWR_LOW		= BIT(6),
 
 	SFP_EXT_STATUS			= 118,
+	SFP_EXT_STATUS_RS1_SELECT	= BIT(3),
 	SFP_EXT_STATUS_PWRLVL_SELECT	= BIT(0),
 
 	SFP_VSL				= 120,
-- 
2.30.2


