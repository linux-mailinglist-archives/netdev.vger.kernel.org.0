Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62603F6947
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfKJOHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:07:00 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45670 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TSr+xcyzT8RbayEqjrR50hvaRA+ZOHFIcCE59RSNlqg=; b=IojmtcvkqGaX5Ulg8x05lbW3LD
        khBRTDkP65Af99RIaJ+u6yfYW6Bk/OpsDo355EmgY1mYbShR3QJiel87Y8WdctRl0Dum8t0PnoREQ
        7bWk1dttdqwil6FFT9ujnQsV0YMNFQNJ4JbKndCcUhASj+ENE3/+mEvTv6DQtwRFRQNwIMtBi36Ja
        cFwSyHAOurEAPHn/ctZ4YHyYs+BY557NLuym1m0WhxXqGqIlC0wHSNYA54+FT2DFeHa6OFNy1lfxq
        z74PlPM3VisAA1KNpZUO7b4FgFoKI18Mk7HcwbSR5o4bX3wD6NsVM2Em505NaUiCNSzSsSdysTS8Y
        vPmTlDgA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:47392 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrb-0007dt-50; Sun, 10 Nov 2019 14:06:47 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrY-0005AQ-5o; Sun, 10 Nov 2019 14:06:44 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 07/17] net: sfp: avoid power switch on address-change
 modules
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnrY-0005AQ-5o@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:06:44 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the module indicates that it requires an address change sequence to
switch between address 0x50 and 0x51, which we don't support, we can't
write to the register that controls the power mode to switch to high
power mode.  Warn the user that the module may not be functional in
this case, and don't try to change the power mode.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index b105bbe7720a..7accd24a6875 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1322,25 +1322,34 @@ static int sfp_module_parse_power(struct sfp *sfp)
 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
 		power_mW = 2000;
 
-	if (sfp->id.ext.sff8472_compliance == SFP_SFF8472_COMPLIANCE_NONE &&
-	    (sfp->id.ext.diagmon & (SFP_DIAGMON_DDM | SFP_DIAGMON_ADDRMODE)) !=
-	    SFP_DIAGMON_DDM) {
-		/* The module appears not to implement bus address 0xa2,
-		 * or requires an address change sequence, so assume that
-		 * the module powers up in the indicated power mode.
-		 */
-		if (power_mW > sfp->max_power_mW) {
+	if (power_mW > sfp->max_power_mW) {
+		/* Module power specification exceeds the allowed maximum. */
+		if (sfp->id.ext.sff8472_compliance ==
+			SFP_SFF8472_COMPLIANCE_NONE &&
+		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
+			/* The module appears not to implement bus address
+			 * 0xa2, so assume that the module powers up in the
+			 * indicated mode.
+			 */
 			dev_err(sfp->dev,
 				"Host does not support %u.%uW modules\n",
 				power_mW / 1000, (power_mW / 100) % 10);
 			return -EINVAL;
+		} else {
+			dev_warn(sfp->dev,
+				 "Host does not support %u.%uW modules, module left in power mode 1\n",
+				 power_mW / 1000, (power_mW / 100) % 10);
+			return 0;
 		}
-		return 0;
 	}
 
-	if (power_mW > sfp->max_power_mW) {
+	/* If the module requires a higher power mode, but also requires
+	 * an address change sequence, warn the user that the module may
+	 * not be functional.
+	 */
+	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE && power_mW > 1000) {
 		dev_warn(sfp->dev,
-			 "Host does not support %u.%uW modules, module left in power mode 1\n",
+			 "Address Change Sequence not supported but module requies %u.%uW, module may not be functional\n",
 			 power_mW / 1000, (power_mW / 100) % 10);
 		return 0;
 	}
-- 
2.20.1

