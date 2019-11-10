Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 135DFF6946
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKJOGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:06:52 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45654 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:06:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7dEaHp/rgE9QRrNou7PlsW6UKtDmn+2D9ZwS4wWXrZI=; b=OnTB2LPVP9JVIDoIBSYnhHw+42
        t+61rDZTCjNmxFQ6JcLtn8FACwBtNUCT7hWj1m4YbK571SrPLNpUf/iwHm2s9C/H4Ga1XcR4BbWYt
        ZxFwg9qd8J6RNEPIa+LAGgHI8N9G6TrSYck9IDGtIEDNhLlcdPeU+u9ZWKTPFDB7Sjt/dCyMCbY/E
        jimaaH9jRPsAP7b+002H+x56MvLaVFwXb/ruW3FvNlUiujbfz5my3nOpL11tBqfjevrXZMjncHeG5
        gou8Ws+wclm2AyGzpO3ufIAbGoESB3yaLlMYPGQYEmaNzniKoe2OYC26AaULLF1XWr8ndSkh8iGkv
        Ni8kb3Bg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:53636 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrU-0007dl-AB; Sun, 10 Nov 2019 14:06:40 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrT-0005AH-1u; Sun, 10 Nov 2019 14:06:39 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 06/17] net: sfp: parse SFP power requirement earlier
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnrT-0005AH-1u@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:06:39 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parse the SFP power requirement earlier, in preparation for moving the
power level setup code.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 955ada116ec9..b105bbe7720a 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -198,6 +198,8 @@ struct sfp {
 	unsigned int sm_retries;
 
 	struct sfp_eeprom_id id;
+	unsigned int module_power_mW;
+
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
 	struct device *hwmon_dev;
@@ -1311,17 +1313,14 @@ static void sfp_sm_mod_init(struct sfp *sfp)
 		sfp_sm_probe_phy(sfp);
 }
 
-static int sfp_sm_mod_hpower(struct sfp *sfp)
+static int sfp_module_parse_power(struct sfp *sfp)
 {
-	u32 power;
-	u8 val;
-	int err;
+	u32 power_mW = 1000;
 
-	power = 1000;
 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
-		power = 1500;
+		power_mW = 1500;
 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
-		power = 2000;
+		power_mW = 2000;
 
 	if (sfp->id.ext.sff8472_compliance == SFP_SFF8472_COMPLIANCE_NONE &&
 	    (sfp->id.ext.diagmon & (SFP_DIAGMON_DDM | SFP_DIAGMON_ADDRMODE)) !=
@@ -1330,23 +1329,33 @@ static int sfp_sm_mod_hpower(struct sfp *sfp)
 		 * or requires an address change sequence, so assume that
 		 * the module powers up in the indicated power mode.
 		 */
-		if (power > sfp->max_power_mW) {
+		if (power_mW > sfp->max_power_mW) {
 			dev_err(sfp->dev,
 				"Host does not support %u.%uW modules\n",
-				power / 1000, (power / 100) % 10);
+				power_mW / 1000, (power_mW / 100) % 10);
 			return -EINVAL;
 		}
 		return 0;
 	}
 
-	if (power > sfp->max_power_mW) {
+	if (power_mW > sfp->max_power_mW) {
 		dev_warn(sfp->dev,
 			 "Host does not support %u.%uW modules, module left in power mode 1\n",
-			 power / 1000, (power / 100) % 10);
+			 power_mW / 1000, (power_mW / 100) % 10);
 		return 0;
 	}
 
-	if (power <= 1000)
+	sfp->module_power_mW = power_mW;
+
+	return 0;
+}
+
+static int sfp_sm_mod_hpower(struct sfp *sfp)
+{
+	u8 val;
+	int err;
+
+	if (sfp->module_power_mW <= 1000)
 		return 0;
 
 	err = sfp_read(sfp, true, SFP_EXT_STATUS, &val, sizeof(val));
@@ -1366,7 +1375,8 @@ static int sfp_sm_mod_hpower(struct sfp *sfp)
 	}
 
 	dev_info(sfp->dev, "Module switched to %u.%uW power level\n",
-		 power / 1000, (power / 100) % 10);
+		 sfp->module_power_mW / 1000,
+		 (sfp->module_power_mW / 100) % 10);
 	return T_HPOWER_LEVEL;
 
 err:
@@ -1453,6 +1463,11 @@ static int sfp_sm_mod_probe(struct sfp *sfp)
 		dev_warn(sfp->dev,
 			 "module address swap to access page 0xA2 is not supported.\n");
 
+	/* Parse the module power requirement */
+	ret = sfp_module_parse_power(sfp);
+	if (ret < 0)
+		return ret;
+
 	ret = sfp_hwmon_insert(sfp);
 	if (ret < 0)
 		return ret;
@@ -1476,6 +1491,7 @@ static void sfp_sm_mod_remove(struct sfp *sfp)
 	sfp_module_tx_disable(sfp);
 
 	memset(&sfp->id, 0, sizeof(sfp->id));
+	sfp->module_power_mW = 0;
 
 	dev_info(sfp->dev, "module removed\n");
 }
-- 
2.20.1

