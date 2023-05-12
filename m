Return-Path: <netdev+bounces-2240-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6AF4700DD2
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:27:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7D331C21352
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 305E9200D5;
	Fri, 12 May 2023 17:27:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25962200C7
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:27:15 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EC0E5D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=6/TFH25Gq8taPzCzK3Z6CoAuGifP+2U9Nw0w77iLusw=; b=EvDAOGyxok8adPeRQz51A3Qvk7
	gNuMXaWHM8al5kT7KvyiNuyJISm+VcVFxV+uEgDg5EVX6CRArrIm4RGofoXH+a/tcVqU7pZ8jlmas
	mPytapoQ97hMPC/j2B+haZnWvYFUfz3XbacSS+lnHrFI509fePlQj2Pq0Y5VPdpDsUXNZOUz98Ix8
	KdZAs9BoXbcumrkHwQ4YBp4R2UT7sIT02SQHXzVAlOAoVf5bP/iNA+Frn4IJJlF9v37L8NkyvdVlT
	8WFng/9jY/z5yvpB/yf/yw9VSK03rt2LS7kQ7+xBxHdYoWIeAx6nE6xr4lA0IcgArDs8wrZmtcF2j
	vL6HMqHA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55012 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pxWXu-0000DD-H7; Fri, 12 May 2023 18:27:10 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pxWXt-002Qrz-Rw; Fri, 12 May 2023 18:27:09 +0100
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
Subject: [PATCH RFC net-next 2/9] net: phylink: remove duplicated linkmode
 pause resolution
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pxWXt-002Qrz-Rw@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 12 May 2023 18:27:09 +0100
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SORTED_RECIPS,
	SPF_HELO_NONE,SPF_NONE,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Phylink had two chunks of code virtually the same for resolving the
negotiated pause modes. Factor this down to one function.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index cc4d5b51a82f..783ab4a66111 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1012,11 +1012,10 @@ static void phylink_apply_manual_flow(struct phylink *pl,
 		state->pause = pl->link_config.pause;
 }
 
-static void phylink_resolve_flow(struct phylink_link_state *state)
+static void phylink_resolve_an_pause(struct phylink_link_state *state)
 {
 	bool tx_pause, rx_pause;
 
-	state->pause = MLO_PAUSE_NONE;
 	if (state->duplex == DUPLEX_FULL) {
 		linkmode_resolve_pause(state->advertising,
 				       state->lp_advertising,
@@ -1228,7 +1227,8 @@ static void phylink_get_fixed_state(struct phylink *pl,
 	else if (pl->link_gpio)
 		state->link = !!gpiod_get_value_cansleep(pl->link_gpio);
 
-	phylink_resolve_flow(state);
+	state->pause = MLO_PAUSE_NONE;
+	phylink_resolve_an_pause(state);
 }
 
 static void phylink_mac_initial_config(struct phylink *pl, bool force_restart)
@@ -3279,7 +3279,6 @@ static const struct sfp_upstream_ops sfp_phylink_ops = {
 static void phylink_decode_c37_word(struct phylink_link_state *state,
 				    uint16_t config_reg, int speed)
 {
-	bool tx_pause, rx_pause;
 	int fd_bit;
 
 	if (speed == SPEED_2500)
@@ -3298,13 +3297,7 @@ static void phylink_decode_c37_word(struct phylink_link_state *state,
 		state->link = false;
 	}
 
-	linkmode_resolve_pause(state->advertising, state->lp_advertising,
-			       &tx_pause, &rx_pause);
-
-	if (tx_pause)
-		state->pause |= MLO_PAUSE_TX;
-	if (rx_pause)
-		state->pause |= MLO_PAUSE_RX;
+	phylink_resolve_an_pause(state);
 }
 
 static void phylink_decode_sgmii_word(struct phylink_link_state *state,
-- 
2.30.2


