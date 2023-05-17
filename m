Return-Path: <netdev+bounces-3362-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C1C706AA9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:12:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0D501C20F2D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C8731102;
	Wed, 17 May 2023 14:12:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6688118B16
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:12:06 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3566476AC
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SRhU8XxVYKDym1HmcUgdlrXT4yv+TCCXArbh8Hkv/NM=; b=EM/OU0coejTKD9eQPJ0DZ6A3wU
	4pQ2PvGD2iTQ7JrFuoTbnuBA5LynpKPcOmRGcT6DKER3f8rGS1X1mi0i6wEflFtBMA0C8vvkeOV+t
	qZRRgVsZdDoI+dh0wG7kznkYyRAIleYAIfSp4ZXeN4TiO5oxx5UGH6m5UqJCUKpeq6HIz12IYhWE5
	0bI3KYlvEWDRuU3Bw6zoVpSmTzkQ5noXTrLU/4/CMPcByEHn/N8skqtiUHGV9v9ADLEEaj2gjN819
	FJLSmBc5fCHaU/vj03Usna5LFvJWB2QyniuhLwHVm1i9+M2rx5B9tF57FzodXMx50mSExPf6DDvHR
	1v4rTdyw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44810 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pzHsg-0007zl-L2; Wed, 17 May 2023 15:11:54 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pzHsg-005sfx-2F; Wed, 17 May 2023 15:11:54 +0100
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
Message-Id: <E1pzHsg-005sfx-2F@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 17 May 2023 15:11:54 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Phylink had two chunks of code virtually the same for resolving the
negotiated pause modes. Factor this down to one function.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7db67ff2812c..9cc152f3506a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -980,11 +980,10 @@ static void phylink_apply_manual_flow(struct phylink *pl,
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
@@ -1196,7 +1195,8 @@ static void phylink_get_fixed_state(struct phylink *pl,
 	else if (pl->link_gpio)
 		state->link = !!gpiod_get_value_cansleep(pl->link_gpio);
 
-	phylink_resolve_flow(state);
+	state->pause = MLO_PAUSE_NONE;
+	phylink_resolve_an_pause(state);
 }
 
 static void phylink_mac_initial_config(struct phylink *pl, bool force_restart)
@@ -3219,7 +3219,6 @@ static const struct sfp_upstream_ops sfp_phylink_ops = {
 static void phylink_decode_c37_word(struct phylink_link_state *state,
 				    uint16_t config_reg, int speed)
 {
-	bool tx_pause, rx_pause;
 	int fd_bit;
 
 	if (speed == SPEED_2500)
@@ -3238,13 +3237,7 @@ static void phylink_decode_c37_word(struct phylink_link_state *state,
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


