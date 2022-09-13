Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC5A5B68DC
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 09:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiIMHol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 03:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiIMHoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 03:44:39 -0400
Received: from mail.tkos.co.il (golan.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43ABE657E
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 00:44:36 -0700 (PDT)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id 30075440933;
        Tue, 13 Sep 2022 10:43:09 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1663054989;
        bh=9z/Tk+SHuy/9NFh4YFYJKpTTRJhDCgEB25KNMt1dBDA=;
        h=From:To:Cc:Subject:Date:From;
        b=Obhqsbr6WgEHfc3/kVlIVkl+tM7LgMKUOb0BQN6eVIrvwdOKdILIigXdm7MSe417n
         qjL4Dg4bWnL2EEbQyzd5cZgPcJMmqux4/RLymLIzUtIqbcmSV/c6RHJILgLKNQFU17
         M8pthiR0wbBww7dcbCzaB4XbzSTZ7ZEqxyNSVRmV3wINmSFqwJ/L5eNV1SkxeDGADA
         oA8nJj00qRS8ZpRbbbTL7PE5XW++yx5T1BfrKAc7cdS1oABAuAwnQeg3+4Gm2gLwId
         LHMC/Eci2pMeScYkGuiizf7wTqT8UB9BkieNOfOBHrMhnC1EKLdSE+Y4z8/fRCD0uc
         cpIa5p0+P0oVQ==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Baruch Siach <baruch.siach@siklu.com>
Subject: [PATCH] net: sfp: workaround GPIO input signals bounce
Date:   Tue, 13 Sep 2022 10:43:38 +0300
Message-Id: <5934427dadd3065b125b80c38a111320677fa723.1663055018.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch.siach@siklu.com>

Add a trivial debounce to avoid miss of state changes when there is no
proper hardware debounce on the input signals. Otherwise a GPIO might
randomly indicate high level when the signal is actually going down,
and vice versa.

This fixes observed miss of link up event when LOS signal goes down on
Armada 8040 based system with an optical SFP module.

Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
---
 drivers/net/phy/sfp.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 63f90fe9a4d2..ce6565872f54 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -313,7 +313,9 @@ static unsigned long poll_jiffies;
 static unsigned int sfp_gpio_get_state(struct sfp *sfp)
 {
 	unsigned int i, state, v;
+	int repeat = 10;
 
+again:
 	for (i = state = 0; i < GPIO_MAX; i++) {
 		if (gpio_flags[i] != GPIOD_IN || !sfp->gpio[i])
 			continue;
@@ -323,6 +325,15 @@ static unsigned int sfp_gpio_get_state(struct sfp *sfp)
 			state |= BIT(i);
 	}
 
+	/* Trivial debounce. When no state change is detected, wait for up to
+	 * a limited bound time interval for the signal state to settle.
+	 */
+	if (state == sfp->state && repeat > 0) {
+		udelay(10);
+		repeat--;
+		goto again;
+	}
+
 	return state;
 }
 
-- 
2.35.1

