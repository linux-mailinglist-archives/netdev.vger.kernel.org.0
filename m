Return-Path: <netdev+bounces-7043-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31A1D719682
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:12:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB6591C20FD7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 09:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3370913AFF;
	Thu,  1 Jun 2023 09:12:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257ED79DF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:12:17 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B67E124
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 02:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=df3Zg+DUt4aYBxEQyi3tkB+Mdbp+rAOO3V+QabvS0YQ=; b=uoVhp5AWDGFlnwAtHs9t68vfu6
	b6ydLW4D0Eu/u7BuPXUnG3GI3Opy7tG2A1RSdfL7/GEPOLQKbHp4+zqRXZAa4Myi4dR5DJWe8fFeo
	KBn9bS3iHji7MwJOqRORlUc5wGUOJVYXoWBsZsbhbCR+IJ4hlvHNT/L1pc6OOySgBCZgJUqODfoej
	SB/A5SvXAeo5XymqkV/tgrqyCtJ7/dv2YlVb7rXVwFY1CgrIqOs0ACFdaHpnYHnio2uXXKpLokJge
	Tmfdp5FN573qyKNtd9PRksCnT+WlYLw64EYYwhCZXLXFjp1CoSWJYXKOEj+oJrFNTTnC4cHR5DIzu
	HUFUo6pQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:59752 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q4eLn-000644-3v; Thu, 01 Jun 2023 10:12:07 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q4eLm-00Ayxk-GZ; Thu, 01 Jun 2023 10:12:06 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Raju.Lakkaraju@microchip.com
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net] net: phylink: actually fix ksettings_set() ethtool call
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q4eLm-00Ayxk-GZ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Thu, 01 Jun 2023 10:12:06 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Raju Lakkaraju reported that the below commit caused a regression
with Lan743x drivers and a 2.5G SFP. Sadly, this is because the commit
was utterly wrong. Let's fix this properly by not moving the
linkmode_and(), but instead copying the link ksettings and then
modifying the advertising mask before passing the modified link
ksettings to phylib.

Fixes: df0acdc59b09 ("net: phylink: fix ksettings_set() ethtool call")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
Raju,

Given the number of cockups I've made with this so far, it would be a
really good idea if you can explicitly test this patch and provide a
tested-by. Also it would be good to have a reported-by as well.

Thanks.

 drivers/net/phy/phylink.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e237949deee6..b4831110003c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2225,11 +2225,13 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 
 	ASSERT_RTNL();
 
-	/* Mask out unsupported advertisements */
-	linkmode_and(config.advertising, kset->link_modes.advertising,
-		     pl->supported);
-
 	if (pl->phydev) {
+		struct ethtool_link_ksettings phy_kset = *kset;
+
+		linkmode_and(phy_kset.link_modes.advertising,
+			     phy_kset.link_modes.advertising,
+			     pl->supported);
+
 		/* We can rely on phylib for this update; we also do not need
 		 * to update the pl->link_config settings:
 		 * - the configuration returned via ksettings_get() will come
@@ -2248,10 +2250,13 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		 *   the presence of a PHY, this should not be changed as that
 		 *   should be determined from the media side advertisement.
 		 */
-		return phy_ethtool_ksettings_set(pl->phydev, kset);
+		return phy_ethtool_ksettings_set(pl->phydev, &phy_kset);
 	}
 
 	config = pl->link_config;
+	/* Mask out unsupported advertisements */
+	linkmode_and(config.advertising, kset->link_modes.advertising,
+		     pl->supported);
 
 	/* FIXME: should we reject autoneg if phy/mac does not support it? */
 	switch (kset->base.autoneg) {
-- 
2.30.2


