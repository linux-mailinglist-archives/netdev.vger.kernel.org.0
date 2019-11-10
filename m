Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA35F6950
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKJOHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:07:39 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45738 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:07:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rQrX17/ggzZaFccnRPETxXa6FnrpC9GRGpPG7gEAXSI=; b=Z7kXqe/8qR41I+OfVX55xL76A+
        NQEUObcfA+yKAZZd9gBlP3Z3hbuRc9f4W0FS3uPUb4DQN5/SfnedsSDZPYfT8yBmjFto3ZH/r6O45
        3vuMc4BWzdBU1TN6hU60FDn9sKwGsE/5ltXK0Wu1HcOC+SoWqiFmMo+nl7iIqOgVu8ai08kVwb1ws
        PxAQ+kfKTYIhe0JnC10yGgExtZhIkrD+3LwP580M2lNLu5dsSojRUtnh2Crx5jqCp952PIAXZYn4l
        BCcv+WiWSTrTYfQIUUFlYlJnjUX3LbDDa88+DkXx3R9ua7pzMbsjiuD95YxsMzOkA4VhnUGixaKPg
        jxzuCc4Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54054 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTns5-0007ek-Ru; Sun, 10 Nov 2019 14:07:18 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTns2-0005BY-TE; Sun, 10 Nov 2019 14:07:14 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 13/17] net: sfp: track upstream's attachment state in
 state machine
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTns2-0005BY-TE@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:07:14 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track the upstream's attachment state in the state machine rather than
maintaining a boolean, which ensures that we have a strict order of
ATTACH followed by an UP event - we can never believe that a newly
attached upstream will be anything but down.

Rearrange the order of state machines so we run the module state
machine after the upstream device's state machine, so the module state
machine can check the current state of the device and take action to
e.g. reset back to empty state when the upstream is detached.

This is to allow the module detection to run independently of the
network device becoming available.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 91fd218ba6b6..95e0dd4a52df 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -36,6 +36,8 @@ enum {
 
 	SFP_E_INSERT = 0,
 	SFP_E_REMOVE,
+	SFP_E_DEV_ATTACH,
+	SFP_E_DEV_DETACH,
 	SFP_E_DEV_DOWN,
 	SFP_E_DEV_UP,
 	SFP_E_TX_FAULT,
@@ -50,7 +52,8 @@ enum {
 	SFP_MOD_PRESENT,
 	SFP_MOD_ERROR,
 
-	SFP_DEV_DOWN = 0,
+	SFP_DEV_DETACHED = 0,
+	SFP_DEV_DOWN,
 	SFP_DEV_UP,
 
 	SFP_S_DOWN = 0,
@@ -80,6 +83,7 @@ static const char *mod_state_to_str(unsigned short mod_state)
 }
 
 static const char * const dev_state_strings[] = {
+	[SFP_DEV_DETACHED] = "detached",
 	[SFP_DEV_DOWN] = "down",
 	[SFP_DEV_UP] = "up",
 };
@@ -94,6 +98,8 @@ static const char *dev_state_to_str(unsigned short dev_state)
 static const char * const event_strings[] = {
 	[SFP_E_INSERT] = "insert",
 	[SFP_E_REMOVE] = "remove",
+	[SFP_E_DEV_ATTACH] = "dev_attach",
+	[SFP_E_DEV_DETACH] = "dev_detach",
 	[SFP_E_DEV_DOWN] = "dev_down",
 	[SFP_E_DEV_UP] = "dev_up",
 	[SFP_E_TX_FAULT] = "tx_fault",
@@ -188,7 +194,6 @@ struct sfp {
 	struct gpio_desc *gpio[GPIO_MAX];
 	int gpio_irq[GPIO_MAX];
 
-	bool attached;
 	struct mutex st_mutex;			/* Protects state */
 	unsigned int state;
 	struct delayed_work poll;
@@ -1496,17 +1501,26 @@ static void sfp_sm_mod_remove(struct sfp *sfp)
 	dev_info(sfp->dev, "module removed\n");
 }
 
-/* This state machine tracks the netdev up/down state */
+/* This state machine tracks the upstream's state */
 static void sfp_sm_device(struct sfp *sfp, unsigned int event)
 {
 	switch (sfp->sm_dev_state) {
 	default:
-		if (event == SFP_E_DEV_UP)
+		if (event == SFP_E_DEV_ATTACH)
+			sfp->sm_dev_state = SFP_DEV_DOWN;
+		break;
+
+	case SFP_DEV_DOWN:
+		if (event == SFP_E_DEV_DETACH)
+			sfp->sm_dev_state = SFP_DEV_DETACHED;
+		else if (event == SFP_E_DEV_UP)
 			sfp->sm_dev_state = SFP_DEV_UP;
 		break;
 
 	case SFP_DEV_UP:
-		if (event == SFP_E_DEV_DOWN)
+		if (event == SFP_E_DEV_DETACH)
+			sfp->sm_dev_state = SFP_DEV_DETACHED;
+		else if (event == SFP_E_DEV_DOWN)
 			sfp->sm_dev_state = SFP_DEV_DOWN;
 		break;
 	}
@@ -1517,17 +1531,20 @@ static void sfp_sm_device(struct sfp *sfp, unsigned int event)
  */
 static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 {
-	/* Handle remove event globally, it resets this state machine */
-	if (event == SFP_E_REMOVE) {
+	/* Handle remove event globally, it resets this state machine.
+	 * Also deal with upstream detachment.
+	 */
+	if (event == SFP_E_REMOVE || sfp->sm_dev_state < SFP_DEV_DOWN) {
 		if (sfp->sm_mod_state > SFP_MOD_PROBE)
 			sfp_sm_mod_remove(sfp);
-		sfp_sm_mod_next(sfp, SFP_MOD_EMPTY, 0);
+		if (sfp->sm_mod_state != SFP_MOD_EMPTY)
+			sfp_sm_mod_next(sfp, SFP_MOD_EMPTY, 0);
 		return;
 	}
 
 	switch (sfp->sm_mod_state) {
 	default:
-		if (event == SFP_E_INSERT && sfp->attached)
+		if (event == SFP_E_INSERT)
 			sfp_sm_mod_next(sfp, SFP_MOD_PROBE, T_SERIAL);
 		break;
 
@@ -1693,8 +1710,8 @@ static void sfp_sm_event(struct sfp *sfp, unsigned int event)
 		sm_state_to_str(sfp->sm_state),
 		event_to_str(event));
 
-	sfp_sm_module(sfp, event);
 	sfp_sm_device(sfp, event);
+	sfp_sm_module(sfp, event);
 	sfp_sm_main(sfp, event);
 
 	dev_dbg(sfp->dev, "SM: exit %s:%s:%s\n",
@@ -1707,15 +1724,14 @@ static void sfp_sm_event(struct sfp *sfp, unsigned int event)
 
 static void sfp_attach(struct sfp *sfp)
 {
-	sfp->attached = true;
+	sfp_sm_event(sfp, SFP_E_DEV_ATTACH);
 	if (sfp->state & SFP_F_PRESENT)
 		sfp_sm_event(sfp, SFP_E_INSERT);
 }
 
 static void sfp_detach(struct sfp *sfp)
 {
-	sfp->attached = false;
-	sfp_sm_event(sfp, SFP_E_REMOVE);
+	sfp_sm_event(sfp, SFP_E_DEV_DETACH);
 }
 
 static void sfp_start(struct sfp *sfp)
-- 
2.20.1

