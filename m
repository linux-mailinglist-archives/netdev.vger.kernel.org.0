Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2014227E02
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgGULDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgGULDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 07:03:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F6EC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 04:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nczSUE74lf+1ap8pQxZetQhW9QZgPVi1uJ8T5Zjuu+o=; b=a8j5YSLCo9A6wPZlUXxXrBl3ih
        u4HvobSAKZaGGliz4FksVssH+ky4HMyiqPKVCrnTRSgOEc76l9AOCED4ShflO5VZyCLxvU0NoUvum
        u9XGUJYQr/2LTACTbTzZong58aEiNep9Sny/u2h/sXDA12t+bOSs8OOFGzgLC8gqLZti8uP1xv8KO
        z0FPT6M0yxG1YelrVn4OK7fUZrDwHZoPOzON5hNIEt6I3nLaEbMOy8FKy/SHs6hVNYxqN2XJdg5Lm
        kYNNsiqdqp7riiEnPrMRnhuMPxT4hrV2+/Bkda5Q5haaCEjvqFZsxQMW5B8X5xOqaZlqm502cKoex
        sbyDQwng==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41756 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq3q-0004EH-M5; Tue, 21 Jul 2020 12:03:50 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq3q-0004R2-FK; Tue, 21 Jul 2020 12:03:50 +0100
In-Reply-To: <20200721110152.GY1551@shell.armlinux.org.uk>
References: <20200721110152.GY1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/14] net: phylink: rejig link state tracking
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jxq3q-0004R2-FK@rmk-PC.armlinux.org.uk>
Date:   Tue, 21 Jul 2020 12:03:50 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rejig the link state tracking, so that we can use the current state
in a future patch.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 0fd5a11966aa..b36e0315f0b1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -578,9 +578,14 @@ static void phylink_resolve(struct work_struct *w)
 	struct phylink *pl = container_of(w, struct phylink, resolve);
 	struct phylink_link_state link_state;
 	struct net_device *ndev = pl->netdev;
-	int link_changed;
+	bool cur_link_state;
 
 	mutex_lock(&pl->state_mutex);
+	if (pl->netdev)
+		cur_link_state = netif_carrier_ok(ndev);
+	else
+		cur_link_state = pl->old_link_state;
+
 	if (pl->phylink_disable_state) {
 		pl->mac_link_dropped = false;
 		link_state.link = false;
@@ -623,12 +628,7 @@ static void phylink_resolve(struct work_struct *w)
 		}
 	}
 
-	if (pl->netdev)
-		link_changed = (link_state.link != netif_carrier_ok(ndev));
-	else
-		link_changed = (link_state.link != pl->old_link_state);
-
-	if (link_changed) {
+	if (link_state.link != cur_link_state) {
 		pl->old_link_state = link_state.link;
 		if (!link_state.link)
 			phylink_link_down(pl);
-- 
2.20.1

