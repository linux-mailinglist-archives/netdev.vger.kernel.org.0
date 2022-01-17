Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1D7490AC3
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 15:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237204AbiAQOwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 09:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237192AbiAQOwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 09:52:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D00C061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 06:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NXxgQ1um308Mb4XjGp+w/eroauT4pOVuMvzOLNRaUoA=; b=E9FIzWop30hU+4WvYioE6Gmspg
        d9ZW4l/rZhh9gBGVtelW5kxCIBMm0IXMjkxPfOiNZIr5HL4UbMqOo5x3mh+pPaxcniwA+tF8zGP9B
        2zFNQYBDOYJu25GgYUSaUVw3XFYp6jinEzz9wVjH+nK8wM6piFj9KYhiJTuA//jd+YpGc7Y6huIE5
        vHMFIAmM1l9SbmsPGDu34ZxFFxiWpYmy5q5H2jom49gNtRisN1u19arP/09vf7klCZPWjLQ4byVOp
        +HFe5XKD7gOhDJmaFBeJg8lf7tzdm0Bp0J1dC+yaKIuFGd6XAnDggER7B/bf9BaOzs8oTHIvYFxvu
        6VR2zkIw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48162 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1n9TN4-0002io-FK; Mon, 17 Jan 2022 14:52:34 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1n9TN3-004CzC-TI; Mon, 17 Jan 2022 14:52:33 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Christian Lamparter <chunkeey@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?utf-8?B?54Wn5bGx5ZGo5LiA?= =?utf-8?B?6YOO?= 
        <teruyama@springboard-inc.jp>, netdev@vger.kernel.org
Subject: [PATCH net] net: sfp: fix high power modules without diagnostic
 monitoring
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1n9TN3-004CzC-TI@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 17 Jan 2022 14:52:33 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change
modules") unintetionally changed the semantics for high power modules
without the digital diagnostics monitoring. We repeatedly attempt to
read the power status from the non-existing 0xa2 address in a futile
hope this failure is temporary:

[    8.856051] sfp sfp-eth3: module NTT              0000000000000000 rev 0000  sn 0000000000000000 dc 160408
[    8.865843] mvpp2 f4000000.ethernet eth3: switched to inband/1000base-x link mode
[    8.873469] sfp sfp-eth3: Failed to read EEPROM: -5
[    8.983251] sfp sfp-eth3: Failed to read EEPROM: -5
[    9.103250] sfp sfp-eth3: Failed to read EEPROM: -5

We previosuly assumed such modules were powered up in the correct mode,
continuing without further configuration as long as the required power
class was supported by the host.

Restore this behaviour, while preserving the intent of subsequent
patches to avoid the "Address Change Sequence not supported" warning
if we are not going to be accessing the DDM address.

Fixes: 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change modules")
Reported-by: 照山周一郎 <teruyama@springboard-inc.jp>
Tested-by: 照山周一郎 <teruyama@springboard-inc.jp>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index ab77a9f439ef..4720b24ca51b 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1641,17 +1641,20 @@ static int sfp_sm_probe_for_phy(struct sfp *sfp)
 static int sfp_module_parse_power(struct sfp *sfp)
 {
 	u32 power_mW = 1000;
+	bool supports_a2;
 
 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
 		power_mW = 1500;
 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
 		power_mW = 2000;
 
+	supports_a2 = sfp->id.ext.sff8472_compliance !=
+				SFP_SFF8472_COMPLIANCE_NONE ||
+		      sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
+
 	if (power_mW > sfp->max_power_mW) {
 		/* Module power specification exceeds the allowed maximum. */
-		if (sfp->id.ext.sff8472_compliance ==
-			SFP_SFF8472_COMPLIANCE_NONE &&
-		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
+		if (!supports_a2) {
 			/* The module appears not to implement bus address
 			 * 0xa2, so assume that the module powers up in the
 			 * indicated mode.
@@ -1668,11 +1671,25 @@ static int sfp_module_parse_power(struct sfp *sfp)
 		}
 	}
 
+	if (power_mW <= 1000) {
+		/* Modules below 1W do not require a power change sequence */
+		sfp->module_power_mW = power_mW;
+		return 0;
+	}
+
+	if (!supports_a2) {
+		/* The module power level is below the host maximum and the
+		 * module appears not to implement bus address 0xa2, so assume
+		 * that the module powers up in the indicated mode.
+		 */
+		return 0;
+	}
+
 	/* If the module requires a higher power mode, but also requires
 	 * an address change sequence, warn the user that the module may
 	 * not be functional.
 	 */
-	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE && power_mW > 1000) {
+	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE) {
 		dev_warn(sfp->dev,
 			 "Address Change Sequence not supported but module requires %u.%uW, module may not be functional\n",
 			 power_mW / 1000, (power_mW / 100) % 10);
-- 
2.30.2

