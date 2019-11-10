Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9028FF694B
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfKJOH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:07:28 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45710 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:07:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4pP8HE8lP8oeM/JToaGmEvPr71Ta+7G0/ooVcHLk9TM=; b=YJKGVSxynM9Um70WjC3AC/ECrm
        qlbM2A1PNkjMQqS4IJwz/+aw+wzSYvN2F4Fq3paO6HY/1TfUy/okSN7KI9mi+iYA4dljbMFUoS/EZ
        wcAqAh4TUY5u3LC4IWkQkQLF5lWpdPF1mKLRQe2aUqsAR8YKYp4mD+/aDN369y2pUki0c1UVFy1s3
        nip5D2d07wh+5c841KlyKKQX6H2MbP83ihaWzzNBIEMkJ0YFucaQzDyeQXXnYPvIa2ChN7XG7TbHS
        EA/SNXMj8MNVwfeM2c/aWD7zi+iw8P5C/xEw4MKLKpGP639myU+g7zJVqcPc5DjGJBhtQ2fiIkOJl
        dXPhZ7+g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:47404 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnru-0007eU-P0; Sun, 10 Nov 2019 14:07:06 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrs-0005BD-LE; Sun, 10 Nov 2019 14:07:04 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 11/17] net: sfp: allow fault processing to transition
 to other states
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnrs-0005BD-LE@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:07:04 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the next state to sfp_sm_fault() so that it can branch to other
states. This will be necessary to improve the initialisation path.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index db015e2cb616..bdc633cc7c30 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1271,7 +1271,7 @@ static bool sfp_los_event_inactive(struct sfp *sfp, unsigned int event)
 		event == SFP_E_LOS_LOW);
 }
 
-static void sfp_sm_fault(struct sfp *sfp, bool warn)
+static void sfp_sm_fault(struct sfp *sfp, unsigned int next_state, bool warn)
 {
 	if (sfp->sm_retries && !--sfp->sm_retries) {
 		dev_err(sfp->dev,
@@ -1281,7 +1281,7 @@ static void sfp_sm_fault(struct sfp *sfp, bool warn)
 		if (warn)
 			dev_err(sfp->dev, "module transmit fault indicated\n");
 
-		sfp_sm_next(sfp, SFP_S_TX_FAULT, T_FAULT_RECOVER);
+		sfp_sm_next(sfp, next_state, T_FAULT_RECOVER);
 	}
 }
 
@@ -1621,14 +1621,14 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 
 	case SFP_S_INIT:
 		if (event == SFP_E_TIMEOUT && sfp->state & SFP_F_TX_FAULT)
-			sfp_sm_fault(sfp, true);
+			sfp_sm_fault(sfp, SFP_S_TX_FAULT, true);
 		else if (event == SFP_E_TIMEOUT || event == SFP_E_TX_CLEAR)
 	init_done:	sfp_sm_link_check_los(sfp);
 		break;
 
 	case SFP_S_WAIT_LOS:
 		if (event == SFP_E_TX_FAULT)
-			sfp_sm_fault(sfp, true);
+			sfp_sm_fault(sfp, SFP_S_TX_FAULT, true);
 		else if (sfp_los_event_inactive(sfp, event))
 			sfp_sm_link_up(sfp);
 		break;
@@ -1636,7 +1636,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 	case SFP_S_LINK_UP:
 		if (event == SFP_E_TX_FAULT) {
 			sfp_sm_link_down(sfp);
-			sfp_sm_fault(sfp, true);
+			sfp_sm_fault(sfp, SFP_S_TX_FAULT, true);
 		} else if (sfp_los_event_active(sfp, event)) {
 			sfp_sm_link_down(sfp);
 			sfp_sm_next(sfp, SFP_S_WAIT_LOS, 0);
@@ -1652,7 +1652,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 
 	case SFP_S_REINIT:
 		if (event == SFP_E_TIMEOUT && sfp->state & SFP_F_TX_FAULT) {
-			sfp_sm_fault(sfp, false);
+			sfp_sm_fault(sfp, SFP_S_TX_FAULT, false);
 		} else if (event == SFP_E_TIMEOUT || event == SFP_E_TX_CLEAR) {
 			dev_info(sfp->dev, "module transmit fault recovered\n");
 			sfp_sm_link_check_los(sfp);
-- 
2.20.1

