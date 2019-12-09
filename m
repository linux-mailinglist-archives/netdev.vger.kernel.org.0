Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B58A0116ECF
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfLIOQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:16:04 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34500 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727513AbfLIOQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:16:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=k75eVxRkH9hK0US4CJHl3gA2kV6IWi3YPXYPfOA9oy0=; b=ta0Rhd7idpE4hm5gjLhhVnwN/Q
        rpmBS5rS0b7+1/MCbUNuVKHTdpjLKD9KHrWeiISO6xbZ1OCsjwmQ4JtgUZVlfWKPZm463kGoFhgIs
        J2H2kalJleWDmuoKnj0Gti4AZVy0k4zSzTs93cD7kmaMs9Br8S4t7B32o2QbRr0yCYU6uNyw/zVR6
        L+sYoaSx9UirjlefbK6GhYOQovKu7e6Vf+akladmQ6G/HDC3lyJ82T/w+xuYtOvllfRDL2IZ3wVUy
        HG8OIYzNaBYMft8LX9Cc4ERYVvhN5JDzyFi4PWhi4gc6YgNgAsI0BmunikrxOWo566Bh/cD5NFFCt
        NfUFoT6w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:50206 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJpM-0003Uo-5H; Mon, 09 Dec 2019 14:15:56 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJpL-0004UQ-L7; Mon, 09 Dec 2019 14:15:55 +0000
In-Reply-To: <20191209141525.GK25745@shell.armlinux.org.uk>
References: <20191209141525.GK25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] net: sfp: use a definition for the fault
 recovery attempts
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieJpL-0004UQ-L7@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 14:15:55 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index bfe268028154..b1c564b79e3e 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -172,6 +172,14 @@ static const enum gpiod_flags gpio_flags[] = {
 #define T_RESET_US		10
 #define T_FAULT_RECOVER		msecs_to_jiffies(1000)
 
+/* N_FAULT_INIT is the number of recovery attempts at module initialisation
+ * time. If the TX_FAULT signal is not deasserted after this number of
+ * attempts at clearing it, we decide that the module is faulty.
+ * N_FAULT is the same but after the module has initialised.
+ */
+#define N_FAULT_INIT		5
+#define N_FAULT			5
+
 /* SFP module presence detection is poor: the three MOD DEF signals are
  * the same length on the PCB, which means it's possible for MOD DEF 0 to
  * connect before the I2C bus on MOD DEF 1/2.
@@ -1885,7 +1893,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 		sfp_module_tx_enable(sfp);
 
 		/* Initialise the fault clearance retries */
-		sfp->sm_retries = 5;
+		sfp->sm_retries = N_FAULT_INIT;
 
 		/* We need to check the TX_FAULT state, which is not defined
 		 * while TX_DISABLE is asserted. The earliest we want to do
@@ -1925,7 +1933,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			 * or t_start_up, so assume there is a fault.
 			 */
 			sfp_sm_fault(sfp, SFP_S_INIT_TX_FAULT,
-				     sfp->sm_retries == 5);
+				     sfp->sm_retries == N_FAULT_INIT);
 		} else if (event == SFP_E_TIMEOUT || event == SFP_E_TX_CLEAR) {
 	init_done:	/* TX_FAULT deasserted or we timed out with TX_FAULT
 			 * clear.  Probe for the PHY and check the LOS state.
@@ -1938,7 +1946,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			sfp_sm_link_check_los(sfp);
 
 			/* Reset the fault retry count */
-			sfp->sm_retries = 5;
+			sfp->sm_retries = N_FAULT;
 		}
 		break;
 
-- 
2.20.1

