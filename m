Return-Path: <netdev+bounces-4641-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B75C70DA84
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDCF5281373
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AB471F171;
	Tue, 23 May 2023 10:28:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402F71E53D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:28:34 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC9E132
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=pMtyv0fCbcoUzstLVmR1XhpgGf7qDeb7+Yf6ZipcFoU=; b=VBXQvZEsFonChX5xFlbrGkMLgV
	YGeOGZRzdvApl6Iv8FRaxlEml9MwSzVdtfYnoR9CQUcI1T29b2yXthE5BrJc03cixSmk/v12xQoa9
	sDWeGr3EbkfC9Jkem9zWa4e4Ri6W/P6A6Eh/5qxjMX5FDgf3kmnFg8InWv8oMha1clufGDsi00XF5
	gUbA7BtesGnPAGzZE0Nt2DimrGIzLCCqeQMPR5BAPv6TIfgGUAeU91/AdbZv33a4s1fD1hT5SaM7+
	K9CveW6UMN7zjZj/i2eeCWQ26Sy9DJNRgNEjbvCPL5hWnzOynifhuKdhVkQH+PfJHsMjHfNqS/90C
	K6O83daw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38782 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q1P3p-00006t-AD; Tue, 23 May 2023 11:16:09 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q1P3o-007E8t-NC; Tue, 23 May 2023 11:16:08 +0100
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
Subject: [PATCH net-next 5/9] net: pcs: xpcs: use mii_c73_to_linkmode() helper
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q1P3o-007E8t-NC@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 23 May 2023 11:16:08 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Convert xpcs clause 73 reading to use the newly introduced
mii_c73_to_linkmode() helper to translate the link partner
advertisement to an ethtool bitmap.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 5723abfc6fc8..2165859a063c 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -529,18 +529,7 @@ static int xpcs_read_lpa_c73(struct dw_xpcs *xpcs,
 		lpa[i] = ret;
 	}
 
-	if (lpa[2] & DW_C73_2500KX)
-		phylink_set(state->lp_advertising, 2500baseX_Full);
-	if (lpa[1] & DW_C73_1000KX)
-		phylink_set(state->lp_advertising, 1000baseKX_Full);
-	if (lpa[1] & DW_C73_10000KX4)
-		phylink_set(state->lp_advertising, 10000baseKX4_Full);
-	if (lpa[1] & DW_C73_10000KR)
-		phylink_set(state->lp_advertising, 10000baseKR_Full);
-	if (lpa[0] & DW_C73_PAUSE)
-		phylink_set(state->lp_advertising, Pause);
-	if (lpa[0] & DW_C73_ASYM_PAUSE)
-		phylink_set(state->lp_advertising, Asym_Pause);
+	mii_c73_mod_linkmode(state->lp_advertising, lpa);
 
 	linkmode_and(state->lp_advertising, state->lp_advertising,
 		     state->advertising);
-- 
2.30.2


