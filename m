Return-Path: <netdev+bounces-4729-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1FAB70E093
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:33:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CDB2281396
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4FA11F94E;
	Tue, 23 May 2023 15:32:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937B51F168
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:32:14 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4BFE78
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wNRr09pvca4CeBKUr77qqDFMn7QbOrjFjQ0b9FHQ7hw=; b=Jcwe5QWHTTox0aYlY7zEolVTer
	8bpaozH9bJeNFXr+gBmXacChefNODDR3x2wfDZlUqKyBkzOhrD6LsNaDO1tF1HDu6oaH3JVQE8ZNu
	Gx9j7318rNYm0Dfjdp8CssLtxbUF5vCUFXgM80VCHKDFos1WNQeHnW8/nz9HpurLbsQzrAceoFd3Q
	8amLtz7sDhrk2CxSI0yE87RyHmJ4Qf6mBEbWLWkfOaRTrxsPFw2ueXQfUejlSmsuZXKeam0bCGT7m
	EFu9fh1YsNLU274rz3o2WXvxNZgpwXINu/S1DR5TIO/by1alTwPOYScZXlTspVcps3Prj2Li3Xpj+
	6CP5ikNA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52456 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q1TzL-0000eL-IM; Tue, 23 May 2023 16:31:51 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q1TzK-007Exd-Rs; Tue, 23 May 2023 16:31:50 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next] net: phylink: provide phylink_pcs_config() and
 phylink_pcs_link_up()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q1TzK-007Exd-Rs@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 23 May 2023 16:31:50 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add two helper functions for calling PCS methods. phylink_pcs_config()
allows us to handle PCS configuration specifics in one location, rather
than the two call sites. phylink_pcs_link_up() gives us consistency.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 54 ++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 96b418f07f8a..530bfafd4f81 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -992,6 +992,26 @@ static void phylink_resolve_an_pause(struct phylink_link_state *state)
 	}
 }
 
+static int phylink_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+			      const struct phylink_link_state *state,
+			      bool permit_pause_to_mac)
+{
+	if (!pcs)
+		return 0;
+
+	return pcs->ops->pcs_config(pcs, mode, state->interface,
+				    state->advertising, permit_pause_to_mac);
+}
+
+static void phylink_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+				phy_interface_t interface, int speed,
+				int duplex)
+{
+	if (pcs && pcs->ops->pcs_link_up)
+		pcs->ops->pcs_link_up(pcs, mode, interface, speed, duplex);
+
+}
+
 static void phylink_pcs_poll_stop(struct phylink *pl)
 {
 	if (pl->cfg_link_an_mode == MLO_AN_INBAND)
@@ -1075,18 +1095,15 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 
 	phylink_mac_config(pl, state);
 
-	if (pl->pcs) {
-		err = pl->pcs->ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
-					       state->interface,
-					       state->advertising,
-					       !!(pl->link_config.pause &
-						  MLO_PAUSE_AN));
-		if (err < 0)
-			phylink_err(pl, "pcs_config failed: %pe\n",
-				    ERR_PTR(err));
-		if (err > 0)
-			restart = true;
-	}
+	err = phylink_pcs_config(pl->pcs, pl->cur_link_an_mode, state,
+				 !!(pl->link_config.pause &
+				    MLO_PAUSE_AN));
+	if (err < 0)
+		phylink_err(pl, "pcs_config failed: %pe\n",
+			    ERR_PTR(err));
+	else if (err > 0)
+		restart = true;
+
 	if (restart)
 		phylink_mac_pcs_an_restart(pl);
 
@@ -1137,11 +1154,9 @@ static int phylink_change_inband_advert(struct phylink *pl)
 	 * restart negotiation if the pcs_config() helper indicates that
 	 * the programmed advertisement has changed.
 	 */
-	ret = pl->pcs->ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
-				       pl->link_config.interface,
-				       pl->link_config.advertising,
-				       !!(pl->link_config.pause &
-					  MLO_PAUSE_AN));
+	ret = phylink_pcs_config(pl->pcs, pl->cur_link_an_mode,
+				 &pl->link_config,
+				 !!(pl->link_config.pause & MLO_PAUSE_AN));
 	if (ret < 0)
 		return ret;
 
@@ -1273,9 +1288,8 @@ static void phylink_link_up(struct phylink *pl,
 
 	pl->cur_interface = link_state.interface;
 
-	if (pl->pcs && pl->pcs->ops->pcs_link_up)
-		pl->pcs->ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
-					  pl->cur_interface, speed, duplex);
+	phylink_pcs_link_up(pl->pcs, pl->cur_link_an_mode, pl->cur_interface,
+			    speed, duplex);
 
 	pl->mac_ops->mac_link_up(pl->config, pl->phydev, pl->cur_link_an_mode,
 				 pl->cur_interface, speed, duplex,
-- 
2.30.2


