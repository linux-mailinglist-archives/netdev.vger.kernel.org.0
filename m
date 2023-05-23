Return-Path: <netdev+bounces-4647-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D060C70DA94
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:31:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BF5C281364
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B911F161;
	Tue, 23 May 2023 10:28:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2F31F931
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:28:43 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6FF133
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=QkimT1mn4ZMgLVvK3tsGKpJeZS+Wkeos5bwBD8+y7lk=; b=B3kJzIr0i5HKNSh44+BrKhs176
	PPcUJ9fS00zwAIXRty0HNaO4Px2pWl/qbV6gckGuRsKuANqqiHzYAyOzvBMtD7b5RAwSa1WL+PSNi
	pnazWy4jnWyWUUwXJKrSKRqu8WJtSKZ+fsKyn6vVZsso1YxLX2hHR6X4/JWrpTLo1Q+8g717INaRO
	4bXpmAIK6r0N+tmdb0AuBC33QRwn2E8GdcdYV64SF68wSoiRMDOZMt64hRwal4GBhojSPTuEuYt2x
	5bdARyqcPQhn1IPMeyNX25sourRFtwcFpKkg9yZJ0m+zsvuwsvTq8B26eGryDIhO08gLZjCi+KjrX
	UwPUfTxg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38930 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q1P44-00007Y-L1; Tue, 23 May 2023 11:16:24 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q1P44-007E9B-1q; Tue, 23 May 2023 11:16:24 +0100
In-Reply-To: <ZGyR/jDyYTYzRklg@shell.armlinux.org.uk>
References: <ZGyR/jDyYTYzRklg@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 8/9] net: pcs: xpcs: use phylink_resolve_c73() helper
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q1P44-007E9B-1q@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 23 May 2023 11:16:24 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use phylink_resolve_c73() to resolve the clause 73 autonegotiation
result.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c | 40 +-------------------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index eec10392e584..7c45887da4ed 100644
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


