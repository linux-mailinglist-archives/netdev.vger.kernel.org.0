Return-Path: <netdev+bounces-3367-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A60BC706AB6
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:14:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D10F1C20B04
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D343111B;
	Wed, 17 May 2023 14:12:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C918518B16
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:12:37 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A389B3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2LA8NnbpT8N/2KsdRk3iMEttuj2d+CwBnFEoI5LGHbQ=; b=OGee0j0fUsmfgjwSEAgEPsYaez
	/+sH2arYWhkvnPJoSLdNHFuIdVf+1dzUbvqyFrUMaY/EINtTmAKGlxq70ikFd9uhUznQgnEAHTii1
	IqdHC+MjagnffOViyvwoHbLoPAK4cYfC8MrTofKIRQGG/g+t9C2zKxdiGyxfc1On33IrNAFYmPshM
	SxXMLCRzpB0cv3zSKOuPI5RaT8j0liJIonqf9YcrkA7EUBIq3/I9kB8Tbg2M4RpMNr4JjFgAiMsGl
	8lCsO7XudlSvLH7rjdY40plg5GBhL9U5BH0ijdyyQNmaOxbu8cR6BC+9nqDepFuaIX23hTJwP3fuu
	VZTdjVNg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41286 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pzHt6-00080p-51; Wed, 17 May 2023 15:12:20 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pzHt5-005sgR-Ih; Wed, 17 May 2023 15:12:19 +0100
In-Reply-To: <ZGTglYakbbnWEIkw@shell.armlinux.org.uk>
References: <ZGTglYakbbnWEIkw@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH RFC net-next 7/9] net: pcs: xpcs: correct pause resolution
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pzHt5-005sgR-Ih@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 17 May 2023 15:12:19 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

xpcs was indicating symmetric pause should be enabled regardless of
the advertisements by either party. Fix this to use
linkmode_resolve_pause() now that we're no longer obliterating the
link partner's advertisement by logically anding it with our own.

This is transitional, the function will be entirely replaced with
phylink_resolve_c73() in the following patch.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 43115d04c01a..beed799a69a7 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -538,11 +538,20 @@ static void xpcs_resolve_lpa_c73(struct dw_xpcs *xpcs,
 				 struct phylink_link_state *state)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(res);
+	bool tx_pause, rx_pause;
 
 	/* Calculate the union of the advertising masks */
 	linkmode_and(res, state->lp_advertising, state->advertising);
 
-	state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
+	/* Resolve pause modes */
+	linkmode_resolve_pause(state->advertising, state->lp_advertising,
+			       &tx_pause, &rx_pause);
+
+	if (tx_pause)
+		state->pause |= MLO_PAUSE_TX;
+	if (rx_pause)
+		state->pause |= MLO_PAUSE_RX;
+
 	state->speed = xpcs_get_max_usxgmii_speed(res);
 	state->duplex = DUPLEX_FULL;
 }
-- 
2.30.2


