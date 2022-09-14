Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5515B8108
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 07:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiINFgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 01:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiINFgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 01:36:46 -0400
Received: from mail.tkos.co.il (hours.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AE16C76D
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 22:36:41 -0700 (PDT)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id 6AC39440655;
        Wed, 14 Sep 2022 08:35:13 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1663133713;
        bh=dbR6QP8ac8bpfP4hurTGyyjxIDMsVe+oLS84vrbMezU=;
        h=From:To:Cc:Subject:Date:From;
        b=miirhvCIjTEmEMdoWl6fJiauDGrQKMbWtQ0Pp9cD04zAQouB119lNFafXyi0ZcW4K
         GB0eaDh9/XYMj7y1akCPTpXKVJUFbDh+lnj1XIG9tVnW1lxpPD8qpdq4i6LzVp+aPQ
         KmFW+ReaV5eg+BU8nZO6iXb5IQ8QOj0I/P6ZNqIVWNBdsWq5WWTNDMUiC/iocEkxfh
         VXtSo8Wnk9EzeFAZ4borQuB55/6AVoZxIJBdPejE7mH29IqBq0MWLNiMiDDdxs9iGL
         lpKUQ8BGvGpLBBCGMvFMmneSWi0gAfG7BAgwxNF9MxTQTBsGSHnih4t/dztZ5bnNEZ
         RZlo6/UY4Bqsg==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Baruch Siach <baruch.siach@siklu.com>
Subject: [PATCH v2] net: sfp: workaround GPIO input signals bounce
Date:   Wed, 14 Sep 2022 08:36:35 +0300
Message-Id: <931ac53e9d6421f71f776190b2039abaa69f7d43.1663133795.git.baruch@tkos.co.il>
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
v2:
  Skip delay in the polling case (RMK)
---
 drivers/net/phy/sfp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 63f90fe9a4d2..b0ba144c9633 100644
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
@@ -323,6 +325,16 @@ static unsigned int sfp_gpio_get_state(struct sfp *sfp)
 			state |= BIT(i);
 	}
 
+	/* Trivial debounce for the interrupt case. When no state change is
+	 * detected, wait for up to a limited bound time interval for the
+	 * signal state to settle.
+	 */
+	if (state == sfp->state && !sfp->need_poll && repeat > 0) {
+		udelay(10);
+		repeat--;
+		goto again;
+	}
+
 	return state;
 }
 
-- 
2.35.1

