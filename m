Return-Path: <netdev+bounces-2381-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C1EA7019F7
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 23:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3493F1C20A4B
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 21:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219B52262F;
	Sat, 13 May 2023 21:03:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1647022622
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 21:03:55 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C0A1FDE
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 14:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=01bFNaK2dD2QNagE7M4NLx/jFOI5IgNFHTwerspm28E=; b=xBoYDCfG2oX1ES0vEnEK8Zsy9s
	D5vqCDJt/+viyqbUAabF+0eBU1VVy+WkO9y65do3B5s7/qOGCZvBaahAsYUxz9s99EdE2CsewILrA
	qsjMLAtu1B+HdDdeLgJjtHYE0d0pKUdRHDiwmAAdo7xbC+kWJ+ltwUW1CmTMSfOY+Ykkuwu6Q/TZW
	RtMplU4gGQYef87uoISRmaobbJxyH9xy/P/5ZhK1AFOTJGAaeLQorfjiKY2Leh2aGzSTv4Ezt64bC
	x3TZd/6DE3fAXAOTPAVorg0qNESmz0aNtG3UHYaBhHwtTnm+onCz1M66w1TnLstRdwCl/NFrzpgk4
	WeKD+fNQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:35554 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pxwP3-0001nF-MM; Sat, 13 May 2023 22:03:45 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pxwP3-003e2k-2P; Sat, 13 May 2023 22:03:45 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	netdev@vger.kernel.org
Subject: [PATCH net] net: phylink: fix ksettings_set() ethtool call
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pxwP3-003e2k-2P@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Sat, 13 May 2023 22:03:45 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

While testing a Fiberstore SFP-10G-T module (which uses 10GBASE-R with
rate adaption) in a Clearfog platform (which can't do that) it was
found that the PHYs advertisement was not limited according to the
hosts capabilities when using ethtool to change it.

Fix this by ensuring that we mask the advertisement with the computed
support mask as the very first thing we do.

Fixes: cbc1bb1e4689 ("net: phylink: simplify phy case for ksettings_set method")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a4111f1be375..e237949deee6 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2225,6 +2225,10 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 
 	ASSERT_RTNL();
 
+	/* Mask out unsupported advertisements */
+	linkmode_and(config.advertising, kset->link_modes.advertising,
+		     pl->supported);
+
 	if (pl->phydev) {
 		/* We can rely on phylib for this update; we also do not need
 		 * to update the pl->link_config settings:
@@ -2249,10 +2253,6 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 
 	config = pl->link_config;
 
-	/* Mask out unsupported advertisements */
-	linkmode_and(config.advertising, kset->link_modes.advertising,
-		     pl->supported);
-
 	/* FIXME: should we reject autoneg if phy/mac does not support it? */
 	switch (kset->base.autoneg) {
 	case AUTONEG_DISABLE:
-- 
2.30.2


