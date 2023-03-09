Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F45D6B2931
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjCIP5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCIP5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:57:21 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806A5F4010
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 07:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZkLQ1xyU/Xhxn3J0EmvFEmjUuj62tWObazx8x4dvOZc=; b=p9Ie4HmMzioVhFiGCxBrqBZ54b
        6lw+IeKcUHZv9xqjKg6H4G486nCqVsrVr5h+GTHYrspJ3DzLjgLmPm/LHvCF1rRrE8UB7fq6YEatJ
        0dJG7Y/7L3pK9yx/nEY1jlE7Ubd87qaDomnG0G0Xo11M/PBqUVb1O+jDrj3UzPjKUHMCF6LBeP5TD
        JnF5YVduNFZBSzYkSdBGtmb0qiZCe2gnc2iem0GPdj3wetih1ZQtbRympdK2nyf/JlsmEsWp9d06/
        wiveH/ndFk24G4AQ8cSPzov0cHN6mjjdUmwsKGYzG52Y5IZFFYRPTJ6hkO3W/3DNoiGVwx29Otgba
        l9M/7bcg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43816 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1paIdo-0004zN-Sn; Thu, 09 Mar 2023 15:57:16 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1paIdo-00DUP7-92; Thu, 09 Mar 2023 15:57:16 +0000
In-Reply-To: <ZAoBnqGBnIZzLwpV@shell.armlinux.org.uk>
References: <ZAoBnqGBnIZzLwpV@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: sfp: only use soft polling if we have A2h
 access
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1paIdo-00DUP7-92@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 09 Mar 2023 15:57:16 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The soft state bits are stored in the A2h memory space, and require
SFF-8472 compliance. This is what our have_a2 flag tells us, so use
this to indicate whether we should attempt to use the soft signals.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 4ff07b5a5590..39e3095796d0 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2284,7 +2284,11 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 		    sfp->sm_dev_state != SFP_DEV_UP)
 			break;
 
-		if (!(sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE))
+		/* Only use the soft state bits if we have access to the A2h
+		 * memory, which implies that we have some level of SFF-8472
+		 * compliance.
+		 */
+		if (sfp->have_a2)
 			sfp_soft_start_poll(sfp);
 
 		sfp_module_tx_enable(sfp);
-- 
2.30.2

