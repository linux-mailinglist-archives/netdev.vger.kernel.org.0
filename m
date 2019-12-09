Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62718116ED2
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfLIOQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:16:26 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34538 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbfLIOQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:16:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iiKgxlTTliHBxzUanzga5XV+Xo9eO8wMjnEDOQCT6Yo=; b=BOj42F1kBKnRQagp6nJTQLTl9t
        3nRkzlvPQQIfH74eorr7hdDdpaQEMJOsqBKUCOZC8Ae4SgrXw+h1wpa1LVpyOqBTfMVl566XnbXU1
        s1FeC2OYygds4sU3FXFZmih3Y2d8EdXMRRdEtLpUl60BWxylPjHtUBiSK1MKFUd84jpAmynY7kCfc
        5y955WqCo3KLb+75ceY+jftm5THzg+EaqwhT2jJ5MJnbOeE2Y6f5siLgxxwFbC7ehrzj65DPB+ODd
        OJi89R9ofx5rlrbNQPp4MK8JisjGxZmitnOxlM5/JGUY3ClRTY+4kWcH2MHdaspm0vVzT/7QKmar9
        pWStSTjQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:38024 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJpd-0003VJ-N6; Mon, 09 Dec 2019 14:16:13 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJpb-0004Uo-73; Mon, 09 Dec 2019 14:16:11 +0000
In-Reply-To: <20191209141525.GK25745@shell.armlinux.org.uk>
References: <20191209141525.GK25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] net: sfp: re-attempt probing for phy
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieJpb-0004Uo-73@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 14:16:11 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some 1000BASE-T PHY modules take a while for the PHY to wake up.
Retry the probe a number of times before deciding that the module has
no PHY.

Tested with:
 Sourcephotonics SPGBTXCNFC - PHY takes less than 50ms to respond.
 Champion One 1000SFPT - PHY takes about 200ms to respond.
 Mikrotik S-RJ01 - no PHY

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 59 ++++++++++++++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 76fa95e54542..e54aef921038 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -62,6 +62,7 @@ enum {
 	SFP_S_FAIL,
 	SFP_S_WAIT,
 	SFP_S_INIT,
+	SFP_S_INIT_PHY,
 	SFP_S_INIT_TX_FAULT,
 	SFP_S_WAIT_LOS,
 	SFP_S_LINK_UP,
@@ -126,6 +127,7 @@ static const char * const sm_state_strings[] = {
 	[SFP_S_FAIL] = "fail",
 	[SFP_S_WAIT] = "wait",
 	[SFP_S_INIT] = "init",
+	[SFP_S_INIT_PHY] = "init_phy",
 	[SFP_S_INIT_TX_FAULT] = "init_tx_fault",
 	[SFP_S_WAIT_LOS] = "wait_los",
 	[SFP_S_LINK_UP] = "link_up",
@@ -180,6 +182,12 @@ static const enum gpiod_flags gpio_flags[] = {
 #define N_FAULT_INIT		5
 #define N_FAULT			5
 
+/* T_PHY_RETRY is the time interval between attempts to probe the PHY.
+ * R_PHY_RETRY is the number of attempts.
+ */
+#define T_PHY_RETRY		msecs_to_jiffies(50)
+#define R_PHY_RETRY		12
+
 /* SFP module presence detection is poor: the three MOD DEF signals are
  * the same length on the PCB, which means it's possible for MOD DEF 0 to
  * connect before the I2C bus on MOD DEF 1/2.
@@ -235,6 +243,7 @@ struct sfp {
 	unsigned char sm_dev_state;
 	unsigned short sm_state;
 	unsigned char sm_fault_retries;
+	unsigned char sm_phy_retries;
 
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
@@ -1416,10 +1425,8 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	int err;
 
 	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
-	if (phy == ERR_PTR(-ENODEV)) {
-		dev_info(sfp->dev, "no PHY detected\n");
-		return 0;
-	}
+	if (phy == ERR_PTR(-ENODEV))
+		return PTR_ERR(phy);
 	if (IS_ERR(phy)) {
 		dev_err(sfp->dev, "mdiobus scan returned %ld\n", PTR_ERR(phy));
 		return PTR_ERR(phy);
@@ -1867,6 +1874,7 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 {
 	unsigned long timeout;
+	int ret;
 
 	/* Some events are global */
 	if (sfp->sm_state != SFP_S_DOWN &&
@@ -1940,22 +1948,39 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			sfp_sm_fault(sfp, SFP_S_INIT_TX_FAULT,
 				     sfp->sm_fault_retries == N_FAULT_INIT);
 		} else if (event == SFP_E_TIMEOUT || event == SFP_E_TX_CLEAR) {
-	init_done:	/* TX_FAULT deasserted or we timed out with TX_FAULT
-			 * clear.  Probe for the PHY and check the LOS state.
-			 */
-			if (sfp_sm_probe_for_phy(sfp)) {
-				sfp_sm_next(sfp, SFP_S_FAIL, 0);
-				break;
-			}
-			if (sfp_module_start(sfp->sfp_bus)) {
-				sfp_sm_next(sfp, SFP_S_FAIL, 0);
+	init_done:
+			sfp->sm_phy_retries = R_PHY_RETRY;
+			goto phy_probe;
+		}
+		break;
+
+	case SFP_S_INIT_PHY:
+		if (event != SFP_E_TIMEOUT)
+			break;
+	phy_probe:
+		/* TX_FAULT deasserted or we timed out with TX_FAULT
+		 * clear.  Probe for the PHY and check the LOS state.
+		 */
+		ret = sfp_sm_probe_for_phy(sfp);
+		if (ret == -ENODEV) {
+			if (--sfp->sm_phy_retries) {
+				sfp_sm_next(sfp, SFP_S_INIT_PHY, T_PHY_RETRY);
 				break;
+			} else {
+				dev_info(sfp->dev, "no PHY detected\n");
 			}
-			sfp_sm_link_check_los(sfp);
-
-			/* Reset the fault retry count */
-			sfp->sm_fault_retries = N_FAULT;
+		} else if (ret) {
+			sfp_sm_next(sfp, SFP_S_FAIL, 0);
+			break;
 		}
+		if (sfp_module_start(sfp->sfp_bus)) {
+			sfp_sm_next(sfp, SFP_S_FAIL, 0);
+			break;
+		}
+		sfp_sm_link_check_los(sfp);
+
+		/* Reset the fault retry count */
+		sfp->sm_fault_retries = N_FAULT;
 		break;
 
 	case SFP_S_INIT_TX_FAULT:
-- 
2.20.1

