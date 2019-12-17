Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74403122D16
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfLQNjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:39:47 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56792 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQNjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:39:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tRqVDgtBQ8G8nLmRtfaKqWAp54nlqmZPL96UtRM6VI4=; b=FUc85ilIGLdUYxGfpXJUrF6zmm
        ASVfLYT+DW1xUWQZCoH2KTEtUGU8HkG4KgDxsNBD1yVOLUTl00bgTK9Rt2RbaQcEUMGXmmquZtxz2
        3ONCGYgKmNcLavag1udYCaT8qXOiD/d8MZnmRP04KXESD6QHO5DXvVDT11csKV8Iuf72wsedEX/xo
        1Gsk7EJiic3d6MOgsnDIej2T1ip3HpxCURerix/n1d+kHcVmBLbEHmB722e/HNRLNIHhthwG46dyR
        j+4orsbdY6v8FPcq/v1DYYBglqCpOGDxWhjtXPE2m42QFoThzb92pP45M0iadRqoC//Fa5lXBTHBJ
        FuYMKfgA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39832 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4X-0006FS-Qb; Tue, 17 Dec 2019 13:39:33 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4V-0001z2-O5; Tue, 17 Dec 2019 13:39:31 +0000
In-Reply-To: <20191217133827.GQ25745@shell.armlinux.org.uk>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 07/11] net: phy: marvell: use positive logic for link
 state
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihD4V-0001z2-O5@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 13:39:31 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than using negative logic:

	if (there is no link)
		set link = 0
	else
		set link = 1

use the more natural positive logic:

	if (there is link)
		set link = 1
	else
		set link = 0

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index d57df48b3568..4eabb6a26c33 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -168,7 +168,6 @@
 #define ADVERTISE_PAUSE_FIBER		0x180
 #define ADVERTISE_PAUSE_ASYM_FIBER	0x100
 
-#define REGISTER_LINK_STATUS	0x400
 #define NB_FIBER_STATS	1
 
 MODULE_DESCRIPTION("Marvell PHY driver");
@@ -1203,10 +1202,10 @@ static int marvell_update_link(struct phy_device *phydev, int fiber)
 		if (status < 0)
 			return status;
 
-		if ((status & REGISTER_LINK_STATUS) == 0)
-			phydev->link = 0;
-		else
+		if (status & MII_M1011_PHY_STATUS_LINK)
 			phydev->link = 1;
+		else
+			phydev->link = 0;
 	} else {
 		return genphy_update_link(phydev);
 	}
-- 
2.20.1

