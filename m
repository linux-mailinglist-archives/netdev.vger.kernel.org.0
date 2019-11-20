Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A57103A0E
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbfKTMaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:30:10 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39774 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729732AbfKTMaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:30:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=M8v4W8doiLZIftJn9nVhqdFmfF/mFUpz1pxcf204r4c=; b=GP/bTfOl3l9MUUTL8d/p27fuyX
        aQP5hK4gSnXeFSx3oROTMikj0A+vsbvTapXA8YlB1d6hD3Huh5WdWqoRXzCv1Q7plLe1zBt5QxubM
        cVIvxipZYO49qqr+QiRSNDNU6j3t6SY1G1zsi9pIsg7a6gF3zqFbmznXv1jL7pCrUdDBC9YBLQXoC
        z+AP7wKTWuzxT50cSCfnW5QpcCBdg9h4TfhnMF4x6mw9OOFiUFELDoQ63+HLwXBXgzjoVskqWZkYk
        bcv++z1gHA0ZsVOz2EObjRPFM/zpWHW62xCTIM5YS+gpARXkuMGRkCywN6VQIww5R/hTLrI6lOmTi
        xYCPIyuw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46546 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iXP7Q-0008Io-0N; Wed, 20 Nov 2019 12:30:00 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iXP7P-0006DS-47; Wed, 20 Nov 2019 12:29:59 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2] net: sfp: soft status and control support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iXP7P-0006DS-47@rmk-PC.armlinux.org.uk>
Date:   Wed, 20 Nov 2019 12:29:59 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the soft status and control register, which allows
TX_FAULT and RX_LOS to be monitored and TX_DISABLE to be set.  We
make use of this when the board does not support GPIOs for these
signals.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 110 ++++++++++++++++++++++++++++++++++--------
 include/linux/sfp.h   |   4 ++
 2 files changed, 94 insertions(+), 20 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 69bedef96ca7..da9e7dd50b95 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -201,7 +201,10 @@ struct sfp {
 	struct gpio_desc *gpio[GPIO_MAX];
 	int gpio_irq[GPIO_MAX];
 
+	bool need_poll;
+
 	struct mutex st_mutex;			/* Protects state */
+	unsigned int state_soft_mask;
 	unsigned int state;
 	struct delayed_work poll;
 	struct delayed_work timeout;
@@ -395,24 +398,90 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 }
 
 /* Interface */
-static unsigned int sfp_get_state(struct sfp *sfp)
+static int sfp_read(struct sfp *sfp, bool a2, u8 addr, void *buf, size_t len)
 {
-	return sfp->get_state(sfp);
+	return sfp->read(sfp, a2, addr, buf, len);
 }
 
-static void sfp_set_state(struct sfp *sfp, unsigned int state)
+static int sfp_write(struct sfp *sfp, bool a2, u8 addr, void *buf, size_t len)
 {
-	sfp->set_state(sfp, state);
+	return sfp->write(sfp, a2, addr, buf, len);
 }
 
-static int sfp_read(struct sfp *sfp, bool a2, u8 addr, void *buf, size_t len)
+static unsigned int sfp_soft_get_state(struct sfp *sfp)
 {
-	return sfp->read(sfp, a2, addr, buf, len);
+	unsigned int state = 0;
+	u8 status;
+
+	if (sfp_read(sfp, true, SFP_STATUS, &status, sizeof(status)) ==
+		     sizeof(status)) {
+		if (status & SFP_STATUS_RX_LOS)
+			state |= SFP_F_LOS;
+		if (status & SFP_STATUS_TX_FAULT)
+			state |= SFP_F_TX_FAULT;
+	}
+
+	return state & sfp->state_soft_mask;
 }
 
-static int sfp_write(struct sfp *sfp, bool a2, u8 addr, void *buf, size_t len)
+static void sfp_soft_set_state(struct sfp *sfp, unsigned int state)
 {
-	return sfp->write(sfp, a2, addr, buf, len);
+	u8 status;
+
+	if (sfp_read(sfp, true, SFP_STATUS, &status, sizeof(status)) ==
+		     sizeof(status)) {
+		if (state & SFP_F_TX_DISABLE)
+			status |= SFP_STATUS_TX_DISABLE_FORCE;
+		else
+			status &= ~SFP_STATUS_TX_DISABLE_FORCE;
+
+		sfp_write(sfp, true, SFP_STATUS, &status, sizeof(status));
+	}
+}
+
+static void sfp_soft_start_poll(struct sfp *sfp)
+{
+	const struct sfp_eeprom_id *id = &sfp->id;
+
+	sfp->state_soft_mask = 0;
+	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_TX_DISABLE &&
+	    !sfp->gpio[GPIO_TX_DISABLE])
+		sfp->state_soft_mask |= SFP_F_TX_DISABLE;
+	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_TX_FAULT &&
+	    !sfp->gpio[GPIO_TX_FAULT])
+		sfp->state_soft_mask |= SFP_F_TX_FAULT;
+	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_RX_LOS &&
+	    !sfp->gpio[GPIO_LOS])
+		sfp->state_soft_mask |= SFP_F_LOS;
+
+	if (sfp->state_soft_mask & (SFP_F_LOS | SFP_F_TX_FAULT) &&
+	    !sfp->need_poll)
+		mod_delayed_work(system_wq, &sfp->poll, poll_jiffies);
+}
+
+static void sfp_soft_stop_poll(struct sfp *sfp)
+{
+	sfp->state_soft_mask = 0;
+}
+
+static unsigned int sfp_get_state(struct sfp *sfp)
+{
+	unsigned int state = sfp->get_state(sfp);
+
+	if (state & SFP_F_PRESENT &&
+	    sfp->state_soft_mask & (SFP_F_LOS | SFP_F_TX_FAULT))
+		state |= sfp_soft_get_state(sfp);
+
+	return state;
+}
+
+static void sfp_set_state(struct sfp *sfp, unsigned int state)
+{
+	sfp->set_state(sfp, state);
+
+	if (state & SFP_F_PRESENT &&
+	    sfp->state_soft_mask & SFP_F_TX_DISABLE)
+		sfp_soft_set_state(sfp, state);
 }
 
 static unsigned int sfp_check(void *buf, size_t len)
@@ -1344,11 +1413,6 @@ static void sfp_sm_fault(struct sfp *sfp, unsigned int next_state, bool warn)
 	}
 }
 
-static void sfp_sm_mod_init(struct sfp *sfp)
-{
-	sfp_module_tx_enable(sfp);
-}
-
 static void sfp_sm_probe_for_phy(struct sfp *sfp)
 {
 	/* Setting the serdes link mode is guesswork: there's no
@@ -1511,7 +1575,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		 (int)sizeof(id.ext.datecode), id.ext.datecode);
 
 	/* Check whether we support this module */
-	if (!sfp->type->module_supported(&sfp->id)) {
+	if (!sfp->type->module_supported(&id)) {
 		dev_err(sfp->dev,
 			"module is not supported - phys id 0x%02x 0x%02x\n",
 			sfp->id.base.phys_id, sfp->id.base.phys_ext_id);
@@ -1701,6 +1765,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 		if (sfp->mod_phy)
 			sfp_sm_phy_detach(sfp);
 		sfp_module_tx_disable(sfp);
+		sfp_soft_stop_poll(sfp);
 		sfp_sm_next(sfp, SFP_S_DOWN, 0);
 		return;
 	}
@@ -1712,7 +1777,10 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 		    sfp->sm_dev_state != SFP_DEV_UP)
 			break;
 
-		sfp_sm_mod_init(sfp);
+		if (!(sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE))
+			sfp_soft_start_poll(sfp);
+
+		sfp_module_tx_enable(sfp);
 
 		/* Initialise the fault clearance retries */
 		sfp->sm_retries = 5;
@@ -1968,7 +2036,10 @@ static void sfp_poll(struct work_struct *work)
 	struct sfp *sfp = container_of(work, struct sfp, poll.work);
 
 	sfp_check_state(sfp);
-	mod_delayed_work(system_wq, &sfp->poll, poll_jiffies);
+
+	if (sfp->state_soft_mask & (SFP_F_LOS | SFP_F_TX_FAULT) ||
+	    sfp->need_poll)
+		mod_delayed_work(system_wq, &sfp->poll, poll_jiffies);
 }
 
 static struct sfp *sfp_alloc(struct device *dev)
@@ -2013,7 +2084,6 @@ static int sfp_probe(struct platform_device *pdev)
 	const struct sff_data *sff;
 	struct i2c_adapter *i2c;
 	struct sfp *sfp;
-	bool poll = false;
 	int err, i;
 
 	sfp = sfp_alloc(&pdev->dev);
@@ -2120,7 +2190,7 @@ static int sfp_probe(struct platform_device *pdev)
 
 		sfp->gpio_irq[i] = gpiod_to_irq(sfp->gpio[i]);
 		if (!sfp->gpio_irq[i]) {
-			poll = true;
+			sfp->need_poll = true;
 			continue;
 		}
 
@@ -2132,11 +2202,11 @@ static int sfp_probe(struct platform_device *pdev)
 						dev_name(sfp->dev), sfp);
 		if (err) {
 			sfp->gpio_irq[i] = 0;
-			poll = true;
+			sfp->need_poll = true;
 		}
 	}
 
-	if (poll)
+	if (sfp->need_poll)
 		mod_delayed_work(system_wq, &sfp->poll, poll_jiffies);
 
 	/* We could have an issue in cases no Tx disable pin is available or
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 3b35efd85bb1..487fd9412d10 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -428,6 +428,10 @@ enum {
 	SFP_TEC_CUR			= 0x6c,
 
 	SFP_STATUS			= 0x6e,
+	SFP_STATUS_TX_DISABLE		= BIT(7),
+	SFP_STATUS_TX_DISABLE_FORCE	= BIT(6),
+	SFP_STATUS_TX_FAULT		= BIT(2),
+	SFP_STATUS_RX_LOS		= BIT(1),
 	SFP_ALARM0			= 0x70,
 	SFP_ALARM0_TEMP_HIGH		= BIT(7),
 	SFP_ALARM0_TEMP_LOW		= BIT(6),
-- 
2.20.1

