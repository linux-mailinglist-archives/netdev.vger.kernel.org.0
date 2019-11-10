Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D447F6945
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKJOGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:06:49 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45648 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:06:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QUJJsKPigRneGWY4KkZws/KIWlRGFymyD4/NegV6zrA=; b=P8Q4nS6sfH8dkjsRjDWNVluoeg
        16tLgHitaQS1Q6JDG0qAGZvAPE1lpKetbdR7SC5/MA6ngPdPKriUBvpFLU2Zs4ufeanRM9xMSOXWg
        I0lgED485M+Q9GYlk44fXhzZRYcgAVlZnYoLxmBfIhDzFDNx9iUoSh6MfS+fLYAloyJWD9d6CFb7a
        ro0NMJ0/KeV4fWNLY8QqHhgAyVmsxNMZNSDwXtNj7JpQkFwf9gZ5f7FMj4uZcgq4Xbm5/NA5Qf+3k
        5u0eEoIjcx82AKOIxKvuypwK97DeHAqeMm5eT4vsqaFTYclt85lweZrzo+vyPFxXnJeXpIJm732iQ
        ffrS9gEQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54030 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrR-0007dg-Fx; Sun, 10 Nov 2019 14:06:37 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrN-0005A5-U9; Sun, 10 Nov 2019 14:06:33 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 05/17] net: sfp: rename T_PROBE_WAIT to T_SERIAL
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnrN-0005A5-U9@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:06:33 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SFF-8472 rev 12.2 defines the time for the serial bus to become ready
using t_serial.  Use this as our identifier for this timeout to make
it clear what we are referring to.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index e34370c4a6c5..955ada116ec9 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -149,11 +149,10 @@ static const enum gpiod_flags gpio_flags[] = {
  * the same length on the PCB, which means it's possible for MOD DEF 0 to
  * connect before the I2C bus on MOD DEF 1/2.
  *
- * The SFP MSA specifies 300ms as t_init (the time taken for TX_FAULT to
- * be deasserted) but makes no mention of the earliest time before we can
- * access the I2C EEPROM.  However, Avago modules require 300ms.
+ * The SFF-8472 specifies t_serial ("Time from power on until module is
+ * ready for data transmission over the two wire serial bus.") as 300ms.
  */
-#define T_PROBE_INIT	msecs_to_jiffies(300)
+#define T_SERIAL	msecs_to_jiffies(300)
 #define T_HPOWER_LEVEL	msecs_to_jiffies(300)
 #define T_PROBE_RETRY	msecs_to_jiffies(100)
 
@@ -1497,8 +1496,8 @@ static void sfp_sm_device(struct sfp *sfp, unsigned int event)
 	}
 }
 
-/* This state machine tracks the insert/remove state of
- * the module, and handles probing the on-board EEPROM.
+/* This state machine tracks the insert/remove state of the module, probes
+ * the on-board EEPROM, and sets up the power level.
  */
 static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 {
@@ -1514,7 +1513,7 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 	default:
 		if (event == SFP_E_INSERT && sfp->attached) {
 			sfp_module_tx_disable(sfp);
-			sfp_sm_mod_next(sfp, SFP_MOD_PROBE, T_PROBE_INIT);
+			sfp_sm_mod_next(sfp, SFP_MOD_PROBE, T_SERIAL);
 		}
 		break;
 
-- 
2.20.1

