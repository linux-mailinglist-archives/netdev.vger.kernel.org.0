Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C6A463520
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 14:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238137AbhK3NNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 08:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238372AbhK3NNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 08:13:25 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FDCC061746
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 05:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=swD6Xi5AgYACIhH4fqQcjp92d0sg6DQbT06PvnTZU98=; b=T8rTtLkZV9GA81gVIAdAxLqv2Q
        iwJVg0eN4pwgnSGusmro2Nh0QFQN/RUgYK6wr/9FxNC/6z4fuBY6guJN3PcmtCRRIsxR4sqIDe8xP
        fK4rld0QkQaIVgc5dinBV9byhIMsEuCJxA+XS4qUwNfycGPs17eT8ohW8t0+2F5W4cUbd7HPGy8z6
        S14J77s406Wx4Qk5FmDG9KjOz17sTi8NUPUinslkptcrqzZyWgsksAxJhurqhiTVB/en3I0bhKXu0
        W4d3UW2OTt/liW62nIB+6Vvnr2qiqFpVdIM9/zenn5+sOJuWy9nx83w3mqv6OeDYahph4E1MeTANz
        r+QXEhSg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39438 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ms2tV-0006vK-Hf; Tue, 30 Nov 2021 13:10:01 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ms2tV-00ECJA-2v; Tue, 30 Nov 2021 13:10:01 +0000
In-Reply-To: <YaYiiU9nvmVugqnJ@shell.armlinux.org.uk>
References: <YaYiiU9nvmVugqnJ@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/5] net: dsa: replace phylink_get_interfaces() with
 phylink_get_caps()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ms2tV-00ECJA-2v@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 30 Nov 2021 13:10:01 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phylink needs slightly more information than phylink_get_interfaces()
allows us to get from the DSA drivers - we need the MAC capabilities.
Replace the phylink_get_interfaces() method with phylink_get_caps() to
allow DSA drivers to fill in the phylink_config MAC capabilities field
as well.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/net/dsa.h | 4 ++--
 net/dsa/port.c    | 5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index eff5c44ba377..8ca9d50cbbc2 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -645,8 +645,8 @@ struct dsa_switch_ops {
 	/*
 	 * PHYLINK integration
 	 */
-	void	(*phylink_get_interfaces)(struct dsa_switch *ds, int port,
-					  unsigned long *supported_interfaces);
+	void	(*phylink_get_caps)(struct dsa_switch *ds, int port,
+				    struct phylink_config *config);
 	void	(*phylink_validate)(struct dsa_switch *ds, int port,
 				    unsigned long *supported,
 				    struct phylink_link_state *state);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index eaa66114924b..ef0acf005f8f 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1091,9 +1091,8 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	if (err)
 		mode = PHY_INTERFACE_MODE_NA;
 
-	if (ds->ops->phylink_get_interfaces)
-		ds->ops->phylink_get_interfaces(ds, dp->index,
-					dp->pl_config.supported_interfaces);
+	if (ds->ops->phylink_get_caps)
+		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
 
 	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
 				mode, &dsa_port_phylink_mac_ops);
-- 
2.30.2

