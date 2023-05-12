Return-Path: <netdev+bounces-2242-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7E33700DD4
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:28:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE3361C20B3C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E55A920;
	Fri, 12 May 2023 17:27:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577C4200BF
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:27:25 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0E53ABF
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5ujuVsaQw8yBozbWkICVx4Qub66mZ1ea12tBkI7j96Q=; b=F3Ys+I5HUi/rOqkPIyjInvUII2
	Szrel5QKIybHULW15woy+kauUN8tbbSMUhI7qEax1rYTwZlGnwGaa20fFtJN/QmZNFHvdXWQgjD1B
	XXXqzwl9H8EZNhNc7Yg9t3ac2qe6ruTAB9J5VCqBH5BphPKPpNj20G6Sbcib7tJbQs0sNDrPyUnn2
	bnuqhpM30dmwiH4zaesLahdf3nfzE/+f2QxDBCvYnHbC3QIrSM4NkMwQHBi+fOGzYnff81GavIwqy
	LP7j3oZe56EQkdyr7B+KCujB1IathmDF5xQ1vSzN5CGcYHNSg75AC2ZcG/O7BcNDTDDXqkPxFdxpo
	hXgKcYTw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58866 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pxWY4-0000Dk-SD; Fri, 12 May 2023 18:27:20 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pxWY4-002QsB-55; Fri, 12 May 2023 18:27:20 +0100
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
Subject: [PATCH RFC net-next 4/9] net: pcs: xpcs: clean up reading clause 73
 link partner advertisement
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pxWY4-002QsB-55@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 12 May 2023 18:27:20 +0100
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SORTED_RECIPS,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Read the clause 73 link partner advertisement in a loop and then
translate to the ethtool modes.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c | 39 +++++++++++++++++---------------------
 drivers/net/pcs/pcs-xpcs.h |  3 ---
 2 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index f19d48c94fe0..b8d69a78f484 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -487,7 +487,7 @@ static int xpcs_aneg_done_c73(struct dw_xpcs *xpcs,
 		return ret;
 
 	if (ret & MDIO_AN_STAT1_COMPLETE) {
-		ret = xpcs_read(xpcs, MDIO_MMD_AN, DW_SR_AN_LP_ABL1);
+		ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_AN_LPA);
 		if (ret < 0)
 			return ret;
 
@@ -506,7 +506,8 @@ static int xpcs_aneg_done_c73(struct dw_xpcs *xpcs,
 static int xpcs_read_lpa_c73(struct dw_xpcs *xpcs,
 			     struct phylink_link_state *state)
 {
-	int ret;
+	u16 lpa[3];
+	int i, ret;
 
 	ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_STAT1);
 	if (ret < 0)
@@ -519,32 +520,26 @@ static int xpcs_read_lpa_c73(struct dw_xpcs *xpcs,
 
 	phylink_set(state->lp_advertising, Autoneg);
 
-	/* Clause 73 outcome */
-	ret = xpcs_read(xpcs, MDIO_MMD_AN, DW_SR_AN_LP_ABL3);
-	if (ret < 0)
-		return ret;
-
-	if (ret & DW_C73_2500KX)
-		phylink_set(state->lp_advertising, 2500baseX_Full);
+	/* Read Clause 73 link partner advertisement */
+	for (i = ARRAY_SIZE(lpa); --i >= 0; ) {
+		ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_AN_LPA + i);
+		if (ret < 0)
+			return ret;
 
-	ret = xpcs_read(xpcs, MDIO_MMD_AN, DW_SR_AN_LP_ABL2);
-	if (ret < 0)
-		return ret;
+		lpa[i] = ret;
+	}
 
-	if (ret & DW_C73_1000KX)
+	if (lpa[2] & DW_C73_2500KX)
+		phylink_set(state->lp_advertising, 2500baseX_Full);
+	if (lpa[1] & DW_C73_1000KX)
 		phylink_set(state->lp_advertising, 1000baseKX_Full);
-	if (ret & DW_C73_10000KX4)
+	if (lpa[1] & DW_C73_10000KX4)
 		phylink_set(state->lp_advertising, 10000baseKX4_Full);
-	if (ret & DW_C73_10000KR)
+	if (lpa[1] & DW_C73_10000KR)
 		phylink_set(state->lp_advertising, 10000baseKR_Full);
-
-	ret = xpcs_read(xpcs, MDIO_MMD_AN, DW_SR_AN_LP_ABL1);
-	if (ret < 0)
-		return ret;
-
-	if (ret & DW_C73_PAUSE)
+	if (lpa[0] & DW_C73_PAUSE)
 		phylink_set(state->lp_advertising, Pause);
-	if (ret & DW_C73_ASYM_PAUSE)
+	if (lpa[0] & DW_C73_ASYM_PAUSE)
 		phylink_set(state->lp_advertising, Asym_Pause);
 
 	linkmode_and(state->lp_advertising, state->lp_advertising,
diff --git a/drivers/net/pcs/pcs-xpcs.h b/drivers/net/pcs/pcs-xpcs.h
index 770df50323a0..68c6b5a62088 100644
--- a/drivers/net/pcs/pcs-xpcs.h
+++ b/drivers/net/pcs/pcs-xpcs.h
@@ -32,9 +32,6 @@
 #define DW_SR_AN_ADV1			0x10
 #define DW_SR_AN_ADV2			0x11
 #define DW_SR_AN_ADV3			0x12
-#define DW_SR_AN_LP_ABL1		0x13
-#define DW_SR_AN_LP_ABL2		0x14
-#define DW_SR_AN_LP_ABL3		0x15
 
 /* Clause 73 Defines */
 /* AN_LP_ABL1 */
-- 
2.30.2


