Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0F96952D
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390446AbfGOOUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:20:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390425AbfGOOUg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:20:36 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F132F20651;
        Mon, 15 Jul 2019 14:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200436;
        bh=IOmDlLepviZW4rAKsfzpz7zPEleBGCfoVkcoq01k7hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtIsXaPrrx5L0sQ2tr2j7L6I33ZFsOOApMU1YL2xRt5J4q1A0z1nb0KIfNi1nLiKb
         LUrlIfQZe0a9xtZ+63dzoKcLY8cqJo8M9/OZau43MymDcPCFnGibIswqtLQbX9lX6U
         a373wbv2n1QzQkjxjdceuW8eFm/sTIlOe5k3VNCk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Hancock <hancock@sedsystems.ca>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 050/158] net: sfp: add mutex to prevent concurrent state checks
Date:   Mon, 15 Jul 2019 10:16:21 -0400
Message-Id: <20190715141809.8445-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
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
index 8807a806cc47..418522aa2f71 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -185,10 +185,11 @@ struct sfp {
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
@@ -1718,6 +1719,7 @@ static void sfp_check_state(struct sfp *sfp)
 {
 	unsigned int state, i, changed;
 
+	mutex_lock(&sfp->st_mutex);
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
 	changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
@@ -1743,6 +1745,7 @@ static void sfp_check_state(struct sfp *sfp)
 		sfp_sm_event(sfp, state & SFP_F_LOS ?
 				SFP_E_LOS_HIGH : SFP_E_LOS_LOW);
 	rtnl_unlock();
+	mutex_unlock(&sfp->st_mutex);
 }
 
 static irqreturn_t sfp_irq(int irq, void *data)
@@ -1773,6 +1776,7 @@ static struct sfp *sfp_alloc(struct device *dev)
 	sfp->dev = dev;
 
 	mutex_init(&sfp->sm_mutex);
+	mutex_init(&sfp->st_mutex);
 	INIT_DELAYED_WORK(&sfp->poll, sfp_poll);
 	INIT_DELAYED_WORK(&sfp->timeout, sfp_timeout);
 
-- 
2.20.1

