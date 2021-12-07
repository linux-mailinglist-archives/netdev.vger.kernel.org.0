Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD3146BFF5
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbhLGP5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239205AbhLGP5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:57:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C600CC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 07:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sfApUIqhKc48crqN5d18eMH/aSEK8ckqe+ebo3ZZu+E=; b=LRH8An+cYDRGAI5ZCAYUb8WD1Y
        doWAtLt3KsNovoBA+2Wm/QnBzAfJq54NfQJ5HZYPJxDWRU7XRNB7MRzjDg9H7b2oaU3cgdSimwF3Q
        32FX2jBAm6JeLyXu/BahE931N5TSW5Brxl1FYBxmaPdoEvgXchDwHoW/JhHsodoxB27bPvlG9QMAV
        XlYuYZ609veWf7YowEsNV2LYGDXlhIE2VYi+iw35O5Q6OYJWr3er6uAjmbPz3//qGe0LQKurJVrc6
        FcBbaV4aQdUjLbO/LynCcgjGUKX7oCNKBJrdQisPO/V/PIxi0hkYe/Lfz5KODbSBf3LX909bz7w1D
        bVveQ1dw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:56782 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mucml-0006P9-71; Tue, 07 Dec 2021 15:53:43 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mucmk-00EyCr-Oq; Tue, 07 Dec 2021 15:53:42 +0000
In-Reply-To: <DGaGmGgWrlVkW@shell.armlinux.org.uk>
References: <DGaGmGgWrlVkW@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/5] net: dsa: mark DSA phylink as
 legacy_pre_march2020
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mucmk-00EyCr-Oq@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 07 Dec 2021 15:53:42 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The majority of DSA drivers do not make use of the PCS support, and
thus operate in legacy mode. In order to preserve this behaviour in
future, we need to set the legacy_pre_march2020 flag so phylink knows
this may require the legacy calls.

There are some DSA drivers that do make use of PCS support, and these
will continue operating as before - legacy_pre_march2020 will not
prevent split-PCS support enabling the newer phylink behaviour.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 net/dsa/port.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 6d5ebe61280b..3b8d18e5b72c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1094,6 +1094,13 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	if (err)
 		mode = PHY_INTERFACE_MODE_NA;
 
+	/* Presence of phylink_mac_link_state or phylink_mac_an_restart is
+	 * an indicator of a legacy phylink driver.
+	 */
+	if (ds->ops->phylink_mac_link_state ||
+	    ds->ops->phylink_mac_an_restart)
+		dp->pl_config.legacy_pre_march2020 = true;
+
 	if (ds->ops->phylink_get_caps)
 		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
 
-- 
2.30.2

