Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672742558F0
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 12:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbgH1K4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 06:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729171AbgH1Kyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 06:54:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C496C061233
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 03:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=F04cWwXc94IppBKzH0hFXeNAZ4nkLY4qTbIhgS2I0mQ=; b=yt8VqOzvEdOTuZQewr8/we1zTC
        lZ57+2j+2FlSgkRDuo03SoZoa/tzRY9a/2dtWCH/VOOFEKcCX+4VBLmXcqPZRtZp6QphgrI6inEaI
        /nqhLKcq4CdUVxov+O/kw87po5xNqi3JeQ1XkfaZoN27nPcg0gr2rGB1stseyRDI4iGbmfTghHnCB
        oqBvCPAwxzFSSKYusZ+0XGbt6HUcARSNGYe+/gin4SgQ4cQbEJDHJHFgm8ss/bLdKCg9KAMMUyTft
        kFUJT3ig9bzY31yK858EnwKzCtDiqnsH0rs/OVio+dOXg4a7oKKC5aBPNOXFHRiCh9H/ovE5GRG+3
        aPJ/gcag==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34388 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kBc13-0005u4-Vt; Fri, 28 Aug 2020 11:53:54 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kBc13-00032k-N3; Fri, 28 Aug 2020 11:53:53 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phylink: avoid oops during initialisation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kBc13-00032k-N3@rmk-PC.armlinux.org.uk>
Date:   Fri, 28 Aug 2020 11:53:53 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we intend to use PCS operations, mac_pcs_get_state() will not be
implemented, so will be NULL. If we also intend to register the PCS
operations in mac_prepare() or mac_config(), then this leads to an
attempt to call NULL function pointer during phylink_start(). Avoid
this, but we must report the link is down.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
There are no users of the new split PCS support currently, so this
does not require backporting, but if people think it should have a
fixes tag, that would be:
     Fixes: 7137e18f6f88 ("net: phylink: add struct phylink_pcs")

 drivers/net/phy/phylink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 32b4bd6a5b55..5e4cb12972eb 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -535,8 +535,10 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 
 	if (pl->pcs_ops)
 		pl->pcs_ops->pcs_get_state(pl->pcs, state);
-	else
+	else if (pl->mac_ops->mac_pcs_get_state)
 		pl->mac_ops->mac_pcs_get_state(pl->config, state);
+	else
+		state->link = 0;
 }
 
 /* The fixed state is... fixed except for the link state,
-- 
2.20.1

