Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6FC56966C
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388107AbfGOOH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387959AbfGOOHy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:07:54 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5882B2086C;
        Mon, 15 Jul 2019 14:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199673;
        bh=oRqbOAySbboqMZbkmrXo2KQeXzm8NK/i+iZVt347v4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rprHbZP9QpyRvTtFAksw/VA7KoIUyt1+K/Zqp8i9gSwjowDWBZdmbeO5tmixuIZsK
         1SvMGKdcmc9JFi4VnD1bFeLpXOQTEs5JXwOAJTVqn8IcaVUVHo4N2qbjGhnKTmdn0x
         lhthma1e6L3qSctZ2wRant1mr38vDLF2rQHLowVw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Hancock <hancock@sedsystems.ca>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 069/219] net: sfp: add mutex to prevent concurrent state checks
Date:   Mon, 15 Jul 2019 10:01:10 -0400
Message-Id: <20190715140341.6443-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>

[ Upstream commit 2158e856f56bb762ef90f3ec244d41a519826f75 ]

sfp_check_state can potentially be called by both a threaded IRQ handler
and delayed work. If it is concurrently called, it could result in
incorrect state management. Add a st_mutex to protect the state - this
lock gets taken outside of code that checks and handle state changes, and
the existing sm_mutex nests inside of it.

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 71812be0ac64..b6efd2d41dce 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -186,10 +186,11 @@ struct sfp {
 	struct gpio_desc *gpio[GPIO_MAX];
 
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
@@ -1719,6 +1720,7 @@ static void sfp_check_state(struct sfp *sfp)
 {
 	unsigned int state, i, changed;
 
+	mutex_lock(&sfp->st_mutex);
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
 	changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
@@ -1744,6 +1746,7 @@ static void sfp_check_state(struct sfp *sfp)
 		sfp_sm_event(sfp, state & SFP_F_LOS ?
 				SFP_E_LOS_HIGH : SFP_E_LOS_LOW);
 	rtnl_unlock();
+	mutex_unlock(&sfp->st_mutex);
 }
 
 static irqreturn_t sfp_irq(int irq, void *data)
@@ -1774,6 +1777,7 @@ static struct sfp *sfp_alloc(struct device *dev)
 	sfp->dev = dev;
 
 	mutex_init(&sfp->sm_mutex);
+	mutex_init(&sfp->st_mutex);
 	INIT_DELAYED_WORK(&sfp->poll, sfp_poll);
 	INIT_DELAYED_WORK(&sfp->timeout, sfp_timeout);
 
-- 
2.20.1

