Return-Path: <netdev+bounces-2245-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B8B0700DDA
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:29:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33F071C21336
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D4EA200D9;
	Fri, 12 May 2023 17:27:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423FE200B7
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:27:41 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895E9E74
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=njm/b6dzIXZ5xwwfB6Pi3HnPSG6DUwDY7GYHP3FeDbA=; b=g+UihkdYbTprM/z0SySMN5aAXn
	9Su5ihGWmT+x7brujp8foFHmuC/74/gvpOyD1hq2zeiQ1SHPXvU9+68oJFhbMI7FlhRYBuJBvRSSF
	YRBDoUXAGh0ScSgbcicfht9JQxrvyuTOcUuEbtJ5dsztcRfGuVYA4jluk5hgryP5P7yIKJRKCtDuY
	SVUsP1WhJO9Y0s1cM7yyTdYpoXBGPa9uXc/HkmkRWAywE7JlH8hKolNGXzvuhj3UOZyrDHeRo1yzJ
	LCW694htgEwRmcv9emdrCPFwXUS0XXfMX3/MbqR/NOHMaxSxGT4J1dLxY2kLexla7EEeZkA7A8S9Z
	C+Q+WHOA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58990 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pxWYK-0000ER-7Y; Fri, 12 May 2023 18:27:36 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pxWYJ-002QsU-IT; Fri, 12 May 2023 18:27:35 +0100
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
Message-Id: <E1pxWYJ-002QsU-IT@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 12 May 2023 18:27:35 +0100
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SORTED_RECIPS,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

xpcs was indicating symmetric pause should be enabled regardless of
the advertisements by either party. Fix this to use
linkmode_resolve_pause() now that we're no longer obliterating the
link partner's advertisement by logically anding it with our own.

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


