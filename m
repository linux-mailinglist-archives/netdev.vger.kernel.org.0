Return-Path: <netdev+bounces-4645-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A999D70DA8E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 659382811AD
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57BCA1F19B;
	Tue, 23 May 2023 10:28:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEB91E53D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:28:40 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DB918D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ygCnNPxMSQDdLF5x4PYF2OuYECT+m9BrW+hTWiu0FrY=; b=l+hIgF39g1gGSgQE7OMyWBDw1n
	ECdMT6r5ULuKkVJyiY4Np+TCm8Uy4Pkzwlhjn2CzzcP9+QeYCokLttnEK/4Z8Aemml3KBzuSsNNkK
	VBAKRNnsTUb4SroZ9nwZMIZMhSPjtN8TKnNJnRB72+C1SphUSAgjP3H4rQvMU9+bZi/doZ4bzaVrB
	xTK4twA8RYK6OLZQKdsADoXV6nAYLYz6Z7xoeSTvowGLA8FxUDxxsSxA7SVc1uJEtjMmDTnG4wCGk
	vahF1tTLY9ZTuE5KTt3pVEGt/8AIxwia8/g+kajr1N7cQtzu3bWP3Ns+LTG3zWB67bObJovSPI4ZW
	aeMWsycw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55118 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q1P3k-00006i-5Z; Tue, 23 May 2023 11:16:04 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q1P3j-007E8n-II; Tue, 23 May 2023 11:16:03 +0100
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
Subject: [PATCH net-next 4/9] net: pcs: xpcs: clean up reading clause 73 link
 partner advertisement
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q1P3j-007E8n-II@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 23 May 2023 11:16:03 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Read the clause 73 link partner advertisement in a loop and then
translate to the ethtool modes.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c | 39 +++++++++++++++++---------------------
 drivers/net/pcs/pcs-xpcs.h |  3 ---
 2 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 72f25e778840..5723abfc6fc8 100644
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


