Return-Path: <netdev+bounces-3276-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F9170656E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EB9C1C20B63
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7E2168A0;
	Wed, 17 May 2023 10:38:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71674156FC
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:38:14 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AFE97
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xvCWbsCC5HNJR8cm5sOxvv8BcBvEWCs6ek1i9bhY1Nw=; b=sL8FGG/ZjeK7QhepeyEBkJTN8z
	jvB7dVv7L50IS4JV2VwnDDhOSsstwLVoe4UCFD9hAHEMxnwUvcwxTFdE5yhMLLF6jeGjJHqP7cG7K
	29+f0hKSJmbp3i7eDSk8TpaGUi5EY5EB+SEy+aMBiL13NbcGG1RQS/ZxezXAX7FYP9Mr2FqAWkiZA
	WNkKsGObBBTDS9no+0XOtTMyBQcjpCmC7vtzgJQPY0ecbMmNNxxd6bSFrjinSh1d5x9fi98bpBSjm
	APwV781LpfhC5q6gVLu63fsteQzrlXpEvF5Newl4eqkUh9wD4r1WZqmk029JiR2DYZb4o1NbfQql2
	RaD2oLDQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:35126 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pzEXo-0007Yz-C9; Wed, 17 May 2023 11:38:08 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pzEXn-005jUi-Ok; Wed, 17 May 2023 11:38:07 +0100
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
Subject: [PATCH net-next 5/7] net: sfp: change st_mutex locking
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pzEXn-005jUi-Ok@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 17 May 2023 11:38:07 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Change st_mutex's use within SFP such that it only protects the various
state members, as it was originally supposed to, and isn't held while
making various calls outside the driver.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 56 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index e5cd36e3a421..bf7dac9977e1 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -242,10 +242,17 @@ struct sfp {
 
 	bool need_poll;
 
+	/* Access rules:
+	 * state_hw_drive: st_mutex held
+	 * state_hw_mask: st_mutex held
+	 * state_soft_mask: st_mutex held
+	 * state: st_mutex held unless reading input bits
+	 */
 	struct mutex st_mutex;			/* Protects state */
 	unsigned int state_hw_mask;
 	unsigned int state_soft_mask;
 	unsigned int state;
+
 	struct delayed_work poll;
 	struct delayed_work timeout;
 	struct mutex sm_mutex;			/* Protects state machine */
@@ -692,7 +699,6 @@ static void sfp_soft_start_poll(struct sfp *sfp)
 	const struct sfp_eeprom_id *id = &sfp->id;
 	unsigned int mask = 0;
 
-	sfp->state_soft_mask = 0;
 	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_TX_DISABLE)
 		mask |= SFP_F_TX_DISABLE;
 	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_TX_FAULT)
@@ -700,19 +706,26 @@ static void sfp_soft_start_poll(struct sfp *sfp)
 	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_RX_LOS)
 		mask |= SFP_F_LOS;
 
+	mutex_lock(&sfp->st_mutex);
 	// Poll the soft state for hardware pins we want to ignore
 	sfp->state_soft_mask = ~sfp->state_hw_mask & mask;
 
 	if (sfp->state_soft_mask & (SFP_F_LOS | SFP_F_TX_FAULT) &&
 	    !sfp->need_poll)
 		mod_delayed_work(system_wq, &sfp->poll, poll_jiffies);
+	mutex_unlock(&sfp->st_mutex);
 }
 
 static void sfp_soft_stop_poll(struct sfp *sfp)
 {
+	mutex_lock(&sfp->st_mutex);
 	sfp->state_soft_mask = 0;
+	mutex_unlock(&sfp->st_mutex);
 }
 
+/* sfp_get_state() - must be called with st_mutex held, or in the
+ * initialisation path.
+ */
 static unsigned int sfp_get_state(struct sfp *sfp)
 {
 	unsigned int soft = sfp->state_soft_mask & (SFP_F_LOS | SFP_F_TX_FAULT);
@@ -725,6 +738,9 @@ static unsigned int sfp_get_state(struct sfp *sfp)
 	return state;
 }
 
+/* sfp_set_state() - must be called with st_mutex held, or in the
+ * initialisation path.
+ */
 static void sfp_set_state(struct sfp *sfp, unsigned int state)
 {
 	sfp->set_state(sfp, state);
@@ -736,8 +752,10 @@ static void sfp_set_state(struct sfp *sfp, unsigned int state)
 
 static void sfp_mod_state(struct sfp *sfp, unsigned int mask, unsigned int set)
 {
+	mutex_lock(&sfp->st_mutex);
 	sfp->state = (sfp->state & ~mask) | set;
 	sfp_set_state(sfp, sfp->state);
+	mutex_unlock(&sfp->st_mutex);
 }
 
 static unsigned int sfp_check(void *buf, size_t len)
@@ -1603,16 +1621,18 @@ static void sfp_debugfs_exit(struct sfp *sfp)
 
 static void sfp_module_tx_fault_reset(struct sfp *sfp)
 {
-	unsigned int state = sfp->state;
-
-	if (state & SFP_F_TX_DISABLE)
-		return;
+	unsigned int state;
 
-	sfp_set_state(sfp, state | SFP_F_TX_DISABLE);
+	mutex_lock(&sfp->st_mutex);
+	state = sfp->state;
+	if (!(state & SFP_F_TX_DISABLE)) {
+		sfp_set_state(sfp, state | SFP_F_TX_DISABLE);
 
-	udelay(T_RESET_US);
+		udelay(T_RESET_US);
 
-	sfp_set_state(sfp, state);
+		sfp_set_state(sfp, state);
+	}
+	mutex_unlock(&sfp->st_mutex);
 }
 
 /* SFP state machine */
@@ -1957,6 +1977,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	/* SFP module inserted - read I2C data */
 	struct sfp_eeprom_id id;
 	bool cotsworks_sfbg;
+	unsigned int mask;
 	bool cotsworks;
 	u8 check;
 	int ret;
@@ -2096,14 +2117,13 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	if (ret < 0)
 		return ret;
 
-	/* Initialise state bits to use from hardware */
-	sfp->state_hw_mask = SFP_F_PRESENT;
+	mask = SFP_F_PRESENT;
 	if (sfp->gpio[GPIO_TX_DISABLE])
-		sfp->state_hw_mask |= SFP_F_TX_DISABLE;
+		mask |= SFP_F_TX_DISABLE;
 	if (sfp->gpio[GPIO_TX_FAULT])
-		sfp->state_hw_mask |= SFP_F_TX_FAULT;
+		mask |= SFP_F_TX_FAULT;
 	if (sfp->gpio[GPIO_LOS])
-		sfp->state_hw_mask |= SFP_F_LOS;
+		mask |= SFP_F_LOS;
 
 	sfp->module_t_start_up = T_START_UP;
 	sfp->module_t_wait = T_WAIT;
@@ -2121,8 +2141,14 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		sfp->mdio_protocol = MDIO_I2C_NONE;
 
 	sfp->quirk = sfp_lookup_quirk(&id);
+
+	mutex_lock(&sfp->st_mutex);
+	/* Initialise state bits to use from hardware */
+	sfp->state_hw_mask = mask;
+
 	if (sfp->quirk && sfp->quirk->fixup)
 		sfp->quirk->fixup(sfp);
+	mutex_unlock(&sfp->st_mutex);
 
 	return 0;
 }
@@ -2619,6 +2645,7 @@ static void sfp_check_state(struct sfp *sfp)
 
 	state |= sfp->state & (SFP_F_TX_DISABLE | SFP_F_RATE_SELECT);
 	sfp->state = state;
+	mutex_unlock(&sfp->st_mutex);
 
 	mutex_lock(&sfp->sm_mutex);
 	if (changed & SFP_F_PRESENT)
@@ -2633,7 +2660,6 @@ static void sfp_check_state(struct sfp *sfp)
 		__sfp_sm_event(sfp, state & SFP_F_LOS ?
 				    SFP_E_LOS_HIGH : SFP_E_LOS_LOW);
 	mutex_unlock(&sfp->sm_mutex);
-	mutex_unlock(&sfp->st_mutex);
 	rtnl_unlock();
 }
 
@@ -2652,6 +2678,8 @@ static void sfp_poll(struct work_struct *work)
 
 	sfp_check_state(sfp);
 
+	// st_mutex doesn't need to be held here for state_soft_mask,
+	// it's unimportant if we race while reading this.
 	if (sfp->state_soft_mask & (SFP_F_LOS | SFP_F_TX_FAULT) ||
 	    sfp->need_poll)
 		mod_delayed_work(system_wq, &sfp->poll, poll_jiffies);
-- 
2.30.2


