Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DE54C4B92
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243437AbiBYRA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243432AbiBYRA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:00:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740A01D529C
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=roqPELGfGFk9ykWFCxkqb0ABFWvCGtIiw/K8nbm308U=; b=DxnBsrnMrRUBRP/QijcHDOqv4E
        SJi57Jg+a7BrskiG9DXLfKVZbQOzpQigQpu3zzwNzsznXrx+KXNjPIzcsHOEIsUBjnTC5NssBsPfd
        UBhsFpy8myQ1gep4aRFr9Dc8GFqNPgz3GiswDmIt7yPQHVCseoosketYbUStpJ4J9XT6vRrI9D86B
        GWby47vsTomb+zXIbkajbuCmXKt64rAofBLGE/RXU7P4vc4MaxIbN9QQqXD8F3QnspYV392OeIrV9
        XFdFnOzguunuPjpEZ96UtXi3hJXuA+X7h44xsZCUP1UEFcGjugwqUmxwh6tEpypYfdzVeHhBWlXXO
        0Uamt0eg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47854 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNdx6-0005nN-UB; Fri, 25 Feb 2022 17:00:20 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNdx6-00Asv3-C7; Fri, 25 Feb 2022 17:00:20 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH RFC net-next] net: phylink: remove phylink_set_pcs()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNdx6-00Asv3-C7@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 25 Feb 2022 17:00:20 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As all users of phylink_set_pcs() have now been updated to use the
mac_select_pcs() method, it can be removed from the phylink kernel
API and its functionality moved into phylink_major_config().

Removing phylink_set_pcs() gives us a single approach for attaching
a PCS  within phylink.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
As mentioned in a reply to the ocelot patch series, once that series
is merged, we can then get rid of phylink_set_pcs() - and this patch
takes the simple approach of merely moving the code to the one
remaining callsite in phylink_major_config().

I am intending to send this once the Ocelot series has been merged,
which may be over the weekend, which I don't believe will be an
issue for this patch.

 drivers/net/phy/phylink.c | 44 +++++++++++----------------------------
 include/linux/phylink.h   |  1 -
 2 files changed, 12 insertions(+), 33 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 28aa23533107..8d1cd2b9ba5f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -815,8 +815,18 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 	/* If we have a new PCS, switch to the new PCS after preparing the MAC
 	 * for the change.
 	 */
-	if (pcs)
-		phylink_set_pcs(pl, pcs);
+	if (pcs) {
+		pl->pcs = pcs;
+		pl->pcs_ops = pcs->ops;
+
+		if (!pl->phylink_disable_state &&
+		    pl->cfg_link_an_mode == MLO_AN_INBAND) {
+			if (pcs->poll)
+				mod_timer(&pl->link_poll, jiffies + HZ);
+			else
+				del_timer(&pl->link_poll);
+		}
+	}
 
 	phylink_mac_config(pl, state);
 
@@ -1286,36 +1296,6 @@ struct phylink *phylink_create(struct phylink_config *config,
 }
 EXPORT_SYMBOL_GPL(phylink_create);
 
-/**
- * phylink_set_pcs() - set the current PCS for phylink to use
- * @pl: a pointer to a &struct phylink returned from phylink_create()
- * @pcs: a pointer to the &struct phylink_pcs
- *
- * Bind the MAC PCS to phylink.  This may be called after phylink_create().
- * If it is desired to dynamically change the PCS, then the preferred method
- * is to use mac_select_pcs(), but it may also be called in mac_prepare()
- * or mac_config().
- *
- * Please note that there are behavioural changes with the mac_config()
- * callback if a PCS is present (denoting a newer setup) so removing a PCS
- * is not supported, and if a PCS is going to be used, it must be registered
- * by calling phylink_set_pcs() at the latest in the first mac_config() call.
- */
-void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
-{
-	pl->pcs = pcs;
-	pl->pcs_ops = pcs->ops;
-
-	if (!pl->phylink_disable_state &&
-	    pl->cfg_link_an_mode == MLO_AN_INBAND) {
-		if (pcs->poll)
-			mod_timer(&pl->link_poll, jiffies + HZ);
-		else
-			del_timer(&pl->link_poll);
-	}
-}
-EXPORT_SYMBOL_GPL(phylink_set_pcs);
-
 /**
  * phylink_destroy() - cleanup and destroy the phylink instance
  * @pl: a pointer to a &struct phylink returned from phylink_create()
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 9ef9b7047f19..223781622b33 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -532,7 +532,6 @@ void phylink_generic_validate(struct phylink_config *config,
 struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
 			       phy_interface_t iface,
 			       const struct phylink_mac_ops *mac_ops);
-void phylink_set_pcs(struct phylink *, struct phylink_pcs *pcs);
 void phylink_destroy(struct phylink *);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
-- 
2.30.2

