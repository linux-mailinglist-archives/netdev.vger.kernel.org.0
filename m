Return-Path: <netdev+bounces-2246-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEA3A700DDB
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:29:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09C06281D0C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D662E7479;
	Fri, 12 May 2023 17:27:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6C8200D4
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:27:45 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F8CE5D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=PgpHydjGsUwFH5/ft3+aP4Yq68krxZeGGRycyVoK/bA=; b=y+J0h0wpCJ/fSIH9DQTLWlOqkm
	DgzvUIMFWMU7K0uayMXLw8XtfLn/85vZ9oFxTsP1ssj8kLpHP76WHjSjOg6KKp/ze9YGY3Gp25+In
	51X8Sr6X6pO7PE760pqugE0pbOmv1t1tCoyhUaqVMs6/+A91INV+m8AmC2uxUTfWMk/P9CUColDZF
	CgSxNonNo7DI0FtY/LyKjBE8efVmCH9OLY4tEbCMlq+hWkqgD6SkQLQxYllXHdfNyM5lHV6eNpy5C
	+jwjL9PyoetD77aeB37ZxaUGNUmiIU/PZq3z4m7xmwcunsxL1VXrTu5vz4xh+lkwnzofXvBTXaKWe
	4+H34gag==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58992 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pxWYP-0000Ef-CH; Fri, 12 May 2023 18:27:41 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pxWYO-002Qsa-My; Fri, 12 May 2023 18:27:40 +0100
In-Reply-To: <ZF52z7PqH2HLrWEU@shell.armlinux.org.uk>
References: <ZF52z7PqH2HLrWEU@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH RFC net-next 8/9] net: pcs: xpcs: use phylink_resolve_c73()
 helper
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pxWYO-002Qsa-My@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 12 May 2023 18:27:40 +0100
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SORTED_RECIPS,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use phylink_resolve_c73() to resolve the clause 73 autonegotation
result.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c | 40 +-------------------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index beed799a69a7..c5fe944f48dd 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -336,22 +336,6 @@ static int xpcs_read_link_c73(struct dw_xpcs *xpcs)
 	return link;
 }
 
-static int xpcs_get_max_usxgmii_speed(const unsigned long *supported)
-{
-	int max = SPEED_UNKNOWN;
-
-	if (phylink_test(supported, 1000baseKX_Full))
-		max = SPEED_1000;
-	if (phylink_test(supported, 2500baseX_Full))
-		max = SPEED_2500;
-	if (phylink_test(supported, 10000baseKX4_Full))
-		max = SPEED_10000;
-	if (phylink_test(supported, 10000baseKR_Full))
-		max = SPEED_10000;
-
-	return max;
-}
-
 static void xpcs_config_usxgmii(struct dw_xpcs *xpcs, int speed)
 {
 	int ret, speed_sel;
@@ -534,28 +518,6 @@ static int xpcs_read_lpa_c73(struct dw_xpcs *xpcs,
 	return 0;
 }
 
-static void xpcs_resolve_lpa_c73(struct dw_xpcs *xpcs,
-				 struct phylink_link_state *state)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(res);
-	bool tx_pause, rx_pause;
-
-	/* Calculate the union of the advertising masks */
-	linkmode_and(res, state->lp_advertising, state->advertising);
-
-	/* Resolve pause modes */
-	linkmode_resolve_pause(state->advertising, state->lp_advertising,
-			       &tx_pause, &rx_pause);
-
-	if (tx_pause)
-		state->pause |= MLO_PAUSE_TX;
-	if (rx_pause)
-		state->pause |= MLO_PAUSE_RX;
-
-	state->speed = xpcs_get_max_usxgmii_speed(res);
-	state->duplex = DUPLEX_FULL;
-}
-
 static int xpcs_get_max_xlgmii_speed(struct dw_xpcs *xpcs,
 				     struct phylink_link_state *state)
 {
@@ -940,7 +902,7 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
 	if (an_enabled && xpcs_aneg_done_c73(xpcs, state, compat)) {
 		state->an_complete = true;
 		xpcs_read_lpa_c73(xpcs, state);
-		xpcs_resolve_lpa_c73(xpcs, state);
+		phylink_resolve_c73(state);
 	} else if (an_enabled) {
 		state->link = 0;
 	} else if (state->link) {
-- 
2.30.2


