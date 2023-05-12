Return-Path: <netdev+bounces-2241-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D90A700DD3
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:27:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9099F1C212EC
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6EF200D6;
	Fri, 12 May 2023 17:27:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906CA200CB
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:27:20 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07304E74
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=8LRhAPo9SSCsiH38AZfBZD5UmE2Pt6YXs5vpOgMyUT0=; b=wxa4nxi7xTgoy195XnQXop6jZF
	sVl/CPZBMxOwt9nQB2GJ/HjjDw/hyCmYF+Tkx6BhkjlxwI9N9nmessFE13xCpmK1YEyyWZLsdYp+a
	1GzFR7lmfYpa3UkFi/ATYL/HRtGCXoaPIy08ZsaB1Siy1b6+vN166Wzg/APASq7cD1j4tuDkST29H
	TkDHSEQuD8x1crmfqkepzTmFby40xPr9QyX5ys0bJIH0r2D+iC5CReIuFL0ZRwviQ0NI+7RtoOMg8
	zzVEfILsMNR70s2CqfO/bUGt0YvVAM46xgK8IQ3EEXcAgPRP5W84WM9sdNUgBR2rPK0yrg/6n7x7U
	7+fD6jPw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58850 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pxWXz-0000DS-MD; Fri, 12 May 2023 18:27:15 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pxWXz-002Qs5-0N; Fri, 12 May 2023 18:27:15 +0100
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
Subject: [PATCH RFC net-next 3/9] net: phylink: add function to resolve clause
 73 negotiation
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pxWXz-002Qs5-0N@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 12 May 2023 18:27:15 +0100
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SORTED_RECIPS,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add a function to resolve clause 73 negotiation according to the
priority resolution function described in clause 73.3.6.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  2 ++
 2 files changed, 41 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 783ab4a66111..268e0c3dfb1d 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -3276,6 +3276,45 @@ static const struct sfp_upstream_ops sfp_phylink_ops = {
 
 /* Helpers for MAC drivers */
 
+static struct {
+	int bit;
+	int speed;
+} phylink_c73_priority_resolution[] = {
+	{ ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT, SPEED_100000 },
+	{ ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT, SPEED_100000 },
+	/* 100GBASE-KP4 and 100GBASE-CR10 not supported */
+	{ ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT, SPEED_40000 },
+	{ ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT, SPEED_40000 },
+	{ ETHTOOL_LINK_MODE_10000baseKR_Full_BIT, SPEED_10000 },
+	{ ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT, SPEED_10000 },
+	/* 5GBASE-KR not supported */
+	{ ETHTOOL_LINK_MODE_2500baseX_Full_BIT, SPEED_2500 },
+	{ ETHTOOL_LINK_MODE_1000baseKX_Full_BIT, SPEED_1000 },
+};
+
+void phylink_resolve_c73(struct phylink_link_state *state)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(phylink_c73_priority_resolution); i++) {
+		int bit = phylink_c73_priority_resolution[i].bit;
+		if (linkmode_test_bit(bit, state->advertising) &&
+		    linkmode_test_bit(bit, state->lp_advertising))
+			break;
+	}
+
+	if (i < ARRAY_SIZE(phylink_c73_priority_resolution)) {
+		state->speed = phylink_c73_priority_resolution[i].speed;
+		state->duplex = DUPLEX_FULL;
+	} else {
+		/* negotiation failure */
+		state->link = false;
+	}
+
+	phylink_resolve_an_pause(state);
+}
+EXPORT_SYMBOL_GPL(phylink_resolve_c73);
+
 static void phylink_decode_c37_word(struct phylink_link_state *state,
 				    uint16_t config_reg, int speed)
 {
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 2375ccf75403..86a9249ae5b2 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -657,6 +657,8 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 			       const unsigned long *advertising);
 void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs);
 
+void phylink_resolve_c73(struct phylink_link_state *state);
+
 void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
 				   struct phylink_link_state *state);
 
-- 
2.30.2


