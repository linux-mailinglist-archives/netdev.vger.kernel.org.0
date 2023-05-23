Return-Path: <netdev+bounces-4642-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9557A70DA86
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:29:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50E9B28117F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A8B1F17C;
	Tue, 23 May 2023 10:28:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1CB1E53D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:28:35 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378A1126
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Ka3OC0oXr7qbPy0b/wv0h7dV/3WxndIwOzTFD0+qoyM=; b=yCH3ESJLNJ9TkEYdFcGwdQyFey
	oT+BpaPwvyBjbvE9PcCw2Sih8AkUxesRzoN7a3nNtzXReUf82+n2WneJcP8EciZwnkPLrv3GGhmlZ
	mbrHYPMq/NLmEgtsL4cmUwPYEJCpwh5XrYO9YM8CnG2S85e9ui1MkZ/JGclay+jWFDopaT06QW4KY
	SFbbKla1EJQiYNb8PsjbQE/ZskFqljKU814FkfMOE+kfMea57rNPAbnHov81wMk1xPJfVNE0jF7Uv
	W+1MswOP5dyFONdH3oc3yoAbzM/3u36Exs//2qyenJQoeChVfKNDCVA231u9YZS0YWVDNszkqg/1Q
	wGuIEACA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38794 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q1P3u-000078-Dv; Tue, 23 May 2023 11:16:14 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q1P3t-007E8z-Qn; Tue, 23 May 2023 11:16:13 +0100
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
Subject: [PATCH net-next 6/9] net: pcs: xpcs: correct lp_advertising contents
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q1P3t-007E8z-Qn@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 23 May 2023 11:16:13 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

lp_advertising is supposed to reflect the link partner's advertisement
unmodified by the local advertisement, but xpcs bitwise ands it with
the local advertisement prior to calculating the resolution of the
negotiation.

Fix this by moving the bitwise and to xpcs_resolve_lpa_c73() so it can
place the results in a temporary bitmap before passing that to
ixpcs_get_max_usxgmii_speed().

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 2165859a063c..90920a7ba136 100644
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


