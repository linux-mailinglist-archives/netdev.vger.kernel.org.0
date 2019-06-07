Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C78AD39261
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 18:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbfFGQmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 12:42:50 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:5375 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730958AbfFGQmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 12:42:49 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x57Gghij029774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 7 Jun 2019 10:42:43 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x57GgeOm030818
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 7 Jun 2019 10:42:43 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 2/2] net: sfp: add mutex to prevent concurrent state checks
Date:   Fri,  7 Jun 2019 10:42:36 -0600
Message-Id: <1559925756-29593-3-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559925756-29593-1-git-send-email-hancock@sedsystems.ca>
References: <1559925756-29593-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sfp_check_state can potentially be called by both a threaded IRQ handler
and delayed work. If it is concurrently called, it could result in
incorrect state management. Add a st_mutex to protect the state - this
lock gets taken outside of code that checks and handle state changes, and
the existing sm_mutex nests inside of it.

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/phy/sfp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 01af080..edd2de5 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -188,10 +188,11 @@ struct sfp {
 	int gpio_irq[GPIO_MAX];
 
 	bool attached;
+	struct mutex st_mutex;			/* Protects state */
 	unsigned int state;
 	struct delayed_work poll;
 	struct delayed_work timeout;
-	struct mutex sm_mutex;
+	struct mutex sm_mutex;			/* Protects state machine */
 	unsigned char sm_mod_state;
 	unsigned char sm_dev_state;
 	unsigned short sm_state;
@@ -1705,6 +1706,7 @@ static void sfp_check_state(struct sfp *sfp)
 {
 	unsigned int state, i, changed;
 
+	mutex_lock(&sfp->st_mutex);
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
 	changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
@@ -1730,6 +1732,7 @@ static void sfp_check_state(struct sfp *sfp)
 		sfp_sm_event(sfp, state & SFP_F_LOS ?
 				SFP_E_LOS_HIGH : SFP_E_LOS_LOW);
 	rtnl_unlock();
+	mutex_unlock(&sfp->st_mutex);
 }
 
 static irqreturn_t sfp_irq(int irq, void *data)
@@ -1760,6 +1763,7 @@ static struct sfp *sfp_alloc(struct device *dev)
 	sfp->dev = dev;
 
 	mutex_init(&sfp->sm_mutex);
+	mutex_init(&sfp->st_mutex);
 	INIT_DELAYED_WORK(&sfp->poll, sfp_poll);
 	INIT_DELAYED_WORK(&sfp->timeout, sfp_timeout);
 
-- 
1.8.3.1

