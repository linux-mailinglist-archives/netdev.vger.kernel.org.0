Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22389112072
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 00:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfLCXvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 18:51:38 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57152 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfLCXvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 18:51:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7j3v/qOsaFtczPEcOfUUnzOpbtR0xCAhKXP1UV5tBSE=; b=UY25uIfO0DA4hYm5lyQI9bb2fl
        lINC0LUvhEvKtb4NtnQ/7ycOSvTEuhTX19OY8LfOwhCNUYymzHk+xtE8qj8nDLUIOiLG63qoD9AtY
        Q9xiZ1V81nDD1UpqAoSOldy7rRYqjjCqJLSbnjwNANMG9eklo2camuzIfnhRmSMGSo+NVWoF3AEY6
        ebU/6mLpWtuse+WVJ+Oe9Q1KErjQRtpGr9ncrn1v7DyEtRKxp0WJkOxklX3qkv5wwD6ULQDVuXED8
        GI5UwNYZjcGSx3Ys/iBd6ARyyoYXkVBeh3HomXuruOG9xtjjJ/OKV2/tOJENZ6CT+YL2Z3Eo7cTFO
        af3MfH2Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:53186 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1icHx3-00011q-8t; Tue, 03 Dec 2019 23:51:29 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1icHx2-00043k-4d; Tue, 03 Dec 2019 23:51:28 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] net: sfp: fix hwmon
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1icHx2-00043k-4d@rmk-PC.armlinux.org.uk>
Date:   Tue, 03 Dec 2019 23:51:28 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The referenced commit below allowed more than one hwmon device to be
created per SFP, which is definitely not what we want. Avoid this by
only creating the hwmon device just as we transition to WAITDEV state.

Fixes: 139d3a212a1f ("net: sfp: allow modules with slow diagnostics to probe")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 78f53da1e34e..5876d34d8dd0 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1754,6 +1754,10 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 			break;
 		}
 
+		err = sfp_hwmon_insert(sfp);
+		if (err)
+			dev_warn(sfp->dev, "hwmon probe failed: %d\n", err);
+
 		sfp_sm_mod_next(sfp, SFP_MOD_WAITDEV, 0);
 		/* fall through */
 	case SFP_MOD_WAITDEV:
@@ -1803,15 +1807,6 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 	case SFP_MOD_ERROR:
 		break;
 	}
-
-#if IS_ENABLED(CONFIG_HWMON)
-	if (sfp->sm_mod_state >= SFP_MOD_WAITDEV &&
-	    IS_ERR_OR_NULL(sfp->hwmon_dev)) {
-		err = sfp_hwmon_insert(sfp);
-		if (err)
-			dev_warn(sfp->dev, "hwmon probe failed: %d\n", err);
-	}
-#endif
 }
 
 static void sfp_sm_main(struct sfp *sfp, unsigned int event)
-- 
2.20.1

