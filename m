Return-Path: <netdev+bounces-2247-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC76700DDC
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:29:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 535AA1C2135E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C248114275;
	Fri, 12 May 2023 17:27:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B055F200D4
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:27:51 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3194FE74
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gh8yuvP8iK/++CCWnWt7S0iOPD3SFhv7vdlYLjhj7UA=; b=Hl0Ru3v9XzVrNmOIzPn4FH+c2/
	OpLV+vIsReZIZ2FnDvco0B5LQWC/UgSJbQWjrk/ifxyt0Rky0N0zRe3Ir650dciQJWrtfFYXN3fLG
	pB/wO+IGXudEbpxgzlZZaBtHAefINFZ57Rr0GE9JJy7+yXY66+EF80nngP3H7nax2PoWNQ5XebiyA
	r6X01LspZauEGHPEcPMfuXNZpzzzxvvs8+yGtY1EhrCVGyDLylscoUbS9JsbDu7AUJEJMbYN6LvKH
	kilVU9RsUdhvhzAKvAeQT44sXLmQN8JE7VBRsTOK+8GvlFr8k6sDVN+lz6ZaFZ13WU/Vg1wKNleBg
	cl9KpR2w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55316 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pxWYU-0000Es-GP; Fri, 12 May 2023 18:27:46 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pxWYT-002Qsg-Rg; Fri, 12 May 2023 18:27:45 +0100
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
Subject: [PATCH RFC net-next 9/9] net: pcs: xpcs: avoid reading STAT1 more
 than once
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pxWYT-002Qsg-Rg@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 12 May 2023 18:27:45 +0100
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SORTED_RECIPS,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Avoid reading the STAT1 registers more than once while getting the PCS
state, as this register contains latching-low bits that are lost after
the first read.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c | 91 +++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 41 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index c5fe944f48dd..a58d9d079eca 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -271,15 +271,12 @@ static int xpcs_soft_reset(struct dw_xpcs *xpcs,
 })
 
 static int xpcs_read_fault_c73(struct dw_xpcs *xpcs,
-			       struct phylink_link_state *state)
+			       struct phylink_link_state *state,
+			       u16 pcs_stat1)
 {
 	int ret;
 
-	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT1);
-	if (ret < 0)
-		return ret;
-
-	if (ret & MDIO_STAT1_FAULT) {
+	if (pcs_stat1 & MDIO_STAT1_FAULT) {
 		xpcs_warn(xpcs, state, "Link fault condition detected!\n");
 		return -EFAULT;
 	}
@@ -321,21 +318,6 @@ static int xpcs_read_fault_c73(struct dw_xpcs *xpcs,
 	return 0;
 }
 
-static int xpcs_read_link_c73(struct dw_xpcs *xpcs)
-{
-	bool link = true;
-	int ret;
-
-	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT1);
-	if (ret < 0)
-		return ret;
-
-	if (!(ret & MDIO_STAT1_LSTATUS))
-		link = false;
-
-	return link;
-}
-
 static void xpcs_config_usxgmii(struct dw_xpcs *xpcs, int speed)
 {
 	int ret, speed_sel;
@@ -462,15 +444,11 @@ static int xpcs_config_aneg_c73(struct dw_xpcs *xpcs,
 
 static int xpcs_aneg_done_c73(struct dw_xpcs *xpcs,
 			      struct phylink_link_state *state,
-			      const struct xpcs_compat *compat)
+			      const struct xpcs_compat *compat, u16 an_stat1)
 {
 	int ret;
 
-	ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_STAT1);
-	if (ret < 0)
-		return ret;
-
-	if (ret & MDIO_AN_STAT1_COMPLETE) {
+	if (an_stat1 & MDIO_AN_STAT1_COMPLETE) {
 		ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_AN_LPA);
 		if (ret < 0)
 			return ret;
@@ -488,16 +466,12 @@ static int xpcs_aneg_done_c73(struct dw_xpcs *xpcs,
 }
 
 static int xpcs_read_lpa_c73(struct dw_xpcs *xpcs,
-			     struct phylink_link_state *state)
+			     struct phylink_link_state *state, u16 an_stat1)
 {
 	u16 lpa[3];
 	int i, ret;
 
-	ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_STAT1);
-	if (ret < 0)
-		return ret;
-
-	if (!(ret & MDIO_AN_STAT1_LPABLE)) {
+	if (!(an_stat1 & MDIO_AN_STAT1_LPABLE)) {
 		phylink_clear(state->lp_advertising, Autoneg);
 		return 0;
 	}
@@ -880,13 +854,25 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
 			      const struct xpcs_compat *compat)
 {
 	bool an_enabled;
+	int pcs_stat1;
+	int an_stat1;
 	int ret;
 
+	/* The link status bit is latching-low, so it is important to
+	 * avoid unnecessary re-reads of this register to avoid missing
+	 * a link-down event.
+	 */
+	pcs_stat1 = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT1);
+	if (pcs_stat1 < 0) {
+		state->link = false;
+		return stat1;
+	}
+
 	/* Link needs to be read first ... */
-	state->link = xpcs_read_link_c73(xpcs) > 0 ? 1 : 0;
+	state->link = !!(stat1 & MDIO_STAT1_LSTATUS);
 
 	/* ... and then we check the faults. */
-	ret = xpcs_read_fault_c73(xpcs, state);
+	ret = xpcs_read_fault_c73(xpcs, state, pcs_stat1);
 	if (ret) {
 		ret = xpcs_soft_reset(xpcs, compat);
 		if (ret)
@@ -897,15 +883,38 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
 		return xpcs_do_config(xpcs, state->interface, MLO_AN_INBAND, NULL);
 	}
 
+	/* There is no point doing anything else if the link is down. */
+	if (!state->link)
+		return 0;
+
 	an_enabled = linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
 				       state->advertising);
-	if (an_enabled && xpcs_aneg_done_c73(xpcs, state, compat)) {
-		state->an_complete = true;
-		xpcs_read_lpa_c73(xpcs, state);
+	if (an_enabled) {
+		/* The link status bit is latching-low, so it is important to
+		 * avoid unnecessary re-reads of this register to avoid missing
+		 * a link-down event.
+		 */
+		an_stat1 = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_STAT1);
+		if (an_stat1 < 0) {
+			state->link = false;
+			return an_stat1;
+		}
+
+		state->an_complete = xpcs_aneg_done_c73(xpcs, state, compat,
+							an_stat1);
+		if (!state->an_complete) {
+			state->link = false;
+			return 0;
+		}
+
+		ret = xpcs_read_lpa_c73(xpcs, state, an_stat1);
+		if (ret < 0) {
+			state->link = false;
+			return ret;
+		}
+
 		phylink_resolve_c73(state);
-	} else if (an_enabled) {
-		state->link = 0;
-	} else if (state->link) {
+	} else {
 		xpcs_resolve_pma(xpcs, state);
 	}
 
-- 
2.30.2


