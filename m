Return-Path: <netdev+bounces-2244-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3BB700DD9
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:28:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF24A280ED0
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897381426C;
	Fri, 12 May 2023 17:27:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D05C200D4
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:27:35 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002BB3ABF
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Hcn4ssL1vavb5Xy7IWmZSaOf7RZbzBk0IsbBh4Jm4d8=; b=CyT5d/vrfkfI/f/1xgx1tLLiWM
	/8kImkQleJKQFMr0kGnK/T4phDs1a0vAzg5MqH1N91HJjzXbOkjlTVaxfnt3XzQQhM14BYnM4k8Zf
	2shqMEXZLBjQsp/durN3e/OX8hDaNorGCOnC1vx46n60L/1vev2GNVfSvz+doJx+Yepmiz4/BO7vV
	4a084/x70lXytFai7Sz9HIGMzcLXYyR79nXh5BgcJjL6Y78L24lxiyxSUHlo9slZpBM4mo5zD0Pgo
	HycjsDr96ZpYxKRt4ShtpnBi63vgJ7TnzJ8thLDHdGQ0GIK9CHA/Bj2OBv179wslcqBwdQ2C0S1MK
	E7bAbm5w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49372 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pxWYF-0000EC-2U; Fri, 12 May 2023 18:27:31 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pxWYE-002QsN-Dk; Fri, 12 May 2023 18:27:30 +0100
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
Subject: [PATCH RFC net-next 6/9] net: pcs: xpcs: correct lp_advertising
 contents
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pxWYE-002QsN-Dk@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 12 May 2023 18:27:30 +0100
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SORTED_RECIPS,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

lp_advertising is supposed to reflect the link partner's advertisement
unmodified by the local advertisement, but xpcs bitwise ands it with
the local advertisement prior to calculating the resolution of the
negotiation.

Fix this by moving the bitwise and to xpcs_resolve_lpa_c73() so it can
place the results in a temporary bitmap before passing that to
ixpcs_get_max_usxgmii_speed().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 16fcc7891f92..43115d04c01a 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -531,18 +531,19 @@ static int xpcs_read_lpa_c73(struct dw_xpcs *xpcs,
 
 	mii_c73_mod_linkmode(state->lp_advertising, lpa);
 
-	linkmode_and(state->lp_advertising, state->lp_advertising,
-		     state->advertising);
 	return 0;
 }
 
 static void xpcs_resolve_lpa_c73(struct dw_xpcs *xpcs,
 				 struct phylink_link_state *state)
 {
-	int max_speed = xpcs_get_max_usxgmii_speed(state->lp_advertising);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(res);
+
+	/* Calculate the union of the advertising masks */
+	linkmode_and(res, state->lp_advertising, state->advertising);
 
 	state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
-	state->speed = max_speed;
+	state->speed = xpcs_get_max_usxgmii_speed(res);
 	state->duplex = DUPLEX_FULL;
 }
 
-- 
2.30.2


