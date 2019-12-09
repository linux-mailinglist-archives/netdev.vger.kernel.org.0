Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB3F8116ED0
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfLIOQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:16:15 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34514 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727680AbfLIOQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:16:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=V7Z0c6kSWnXGmE+x3wBSh1UManXSw+3NcOk+2Ba62n8=; b=RKg16a7ZYnRgBFUblHUiXQmpTp
        a1O3EfllfNttuFn1lwJBio/CxGnDKUfw01Z5EONgr/4r9LR+tRrrIETUvSAQJsJoFCH27WEHQwvi3
        rprBABvV5GWS+S4JtIrMfkMISKnYpv8WRkyEbPKvS4KgwfynAamXsNG8BFhcxIoWYCKSVujBJuSEA
        mNQ9i7paT1CmCBBxaBDfwBQANE3bIqIg/FWvp3JonPoA7dBMQ2YfS/H37XFNqvQEek+HmPHfPu8bD
        2sAxe+UNl2eX7A5DwFq15+eQFp6RKBN2feUwKpIURljZFgChmKrEYWYQaMg0i4/kIg9xEiFNo+yEH
        eZiLuNLw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:50208 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJpS-0003Uy-O6; Mon, 09 Dec 2019 14:16:02 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJpQ-0004UX-OH; Mon, 09 Dec 2019 14:16:00 +0000
In-Reply-To: <20191209141525.GK25745@shell.armlinux.org.uk>
References: <20191209141525.GK25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: sfp: rename sm_retries
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieJpQ-0004UX-OH@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 14:16:00 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename sm_retries as sm_fault_retries, as this is what this member is
tracking.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index b1c564b79e3e..a67f089f2106 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -234,7 +234,7 @@ struct sfp {
 	unsigned char sm_mod_tries;
 	unsigned char sm_dev_state;
 	unsigned short sm_state;
-	unsigned int sm_retries;
+	unsigned char sm_fault_retries;
 
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
@@ -1490,7 +1490,7 @@ static bool sfp_los_event_inactive(struct sfp *sfp, unsigned int event)
 
 static void sfp_sm_fault(struct sfp *sfp, unsigned int next_state, bool warn)
 {
-	if (sfp->sm_retries && !--sfp->sm_retries) {
+	if (sfp->sm_fault_retries && !--sfp->sm_fault_retries) {
 		dev_err(sfp->dev,
 			"module persistently indicates fault, disabling\n");
 		sfp_sm_next(sfp, SFP_S_TX_DISABLE, 0);
@@ -1893,7 +1893,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 		sfp_module_tx_enable(sfp);
 
 		/* Initialise the fault clearance retries */
-		sfp->sm_retries = N_FAULT_INIT;
+		sfp->sm_fault_retries = N_FAULT_INIT;
 
 		/* We need to check the TX_FAULT state, which is not defined
 		 * while TX_DISABLE is asserted. The earliest we want to do
@@ -1933,7 +1933,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			 * or t_start_up, so assume there is a fault.
 			 */
 			sfp_sm_fault(sfp, SFP_S_INIT_TX_FAULT,
-				     sfp->sm_retries == N_FAULT_INIT);
+				     sfp->sm_fault_retries == N_FAULT_INIT);
 		} else if (event == SFP_E_TIMEOUT || event == SFP_E_TX_CLEAR) {
 	init_done:	/* TX_FAULT deasserted or we timed out with TX_FAULT
 			 * clear.  Probe for the PHY and check the LOS state.
@@ -1946,7 +1946,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			sfp_sm_link_check_los(sfp);
 
 			/* Reset the fault retry count */
-			sfp->sm_retries = N_FAULT;
+			sfp->sm_fault_retries = N_FAULT;
 		}
 		break;
 
-- 
2.20.1

