Return-Path: <netdev+bounces-7039-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD062719649
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:02:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43E3F2816D5
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 09:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7B5EEDE;
	Thu,  1 Jun 2023 09:02:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C5F79DF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:02:50 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A141BE5F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 02:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=A8rLbYU3YxNWqpjGlcbyS/VsIk/b4qyShm6+UJascQo=; b=A6574eCu2FitkAnIN3Wb9X4BoG
	xcIkSzHm/r8cxBLJhSeZBX5DO9tT8mc48J0cS4h6cmCHUNOGAC+x4Tv+uFFpUEFIIZN1CLoA77W0E
	BkLpJyUKpa4pqHApBor/pXQIRDg56MccvfFwj8jwaicg7gdmpRzMqwbacjBXWg2N8zjTWGCM1fL++
	464puE7KYAmjDLNTRyVrnl0SFbGsIliDTUNee9NPbEBBdppbVGmd6PuOUlFq7vr8DEnLJ7AjZTWf9
	ihApCcpYvC5jpkdt6LtR6RGOyMEwN+hxVlIKO852yAac9GLLyOg/PNMKVew3o/TCn9na/0+hgl2SL
	p6H9sCBA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52038 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q4eC7-00062y-Pv; Thu, 01 Jun 2023 10:02:07 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q4eC7-00AyAn-6d; Thu, 01 Jun 2023 10:02:07 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
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
Message-Id: <E1q4eC7-00AyAn-6d@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Thu, 01 Jun 2023 10:02:07 +0100
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
 drivers/net/phy/phylink.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e237949deee6..cf4e51e48cdd 100644
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
@@ -2252,6 +2254,9 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	}
 
 	config = pl->link_config;
+	/* Mask out unsupported advertisements */
+	linkmode_and(config.advertising, kset->link_modes.advertising,
+		     pl->supported);
 
 	/* FIXME: should we reject autoneg if phy/mac does not support it? */
 	switch (kset->base.autoneg) {
-- 
2.30.2


