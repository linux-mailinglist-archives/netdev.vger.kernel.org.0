Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4864AF4BB
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbiBIPFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235504AbiBIPFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:05:11 -0500
X-Greylist: delayed 597 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 07:05:14 PST
Received: from unicorn.mansr.com (unicorn.mansr.com [81.2.72.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEF0C0612BE
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 07:05:14 -0800 (PST)
Received: from raven.mansr.com (raven.mansr.com [81.2.72.235])
        by unicorn.mansr.com (Postfix) with ESMTPS id C9EFC15360;
        Wed,  9 Feb 2022 14:55:12 +0000 (GMT)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 9D22421588D; Wed,  9 Feb 2022 14:55:12 +0000 (GMT)
From:   Mans Rullgard <mans@mansr.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: lan9303: fix reset on probe
Date:   Wed,  9 Feb 2022 14:54:54 +0000
Message-Id: <20220209145454.19749-1-mans@mansr.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reset input to the LAN9303 chip is active low, and devicetree
gpio handles reflect this.  Therefore, the gpio should be requested
with an initial state of high in order for the reset signal to be
asserted.  Other uses of the gpio already use the correct polarity.

Signed-off-by: Mans Rullgard <mans@mansr.com>
---
 drivers/net/dsa/lan9303-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index aa1142d6a9f5..2de67708bbd2 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1301,7 +1301,7 @@ static int lan9303_probe_reset_gpio(struct lan9303 *chip,
 				     struct device_node *np)
 {
 	chip->reset_gpio = devm_gpiod_get_optional(chip->dev, "reset",
-						   GPIOD_OUT_LOW);
+						   GPIOD_OUT_HIGH);
 	if (IS_ERR(chip->reset_gpio))
 		return PTR_ERR(chip->reset_gpio);
 
-- 
2.35.1

