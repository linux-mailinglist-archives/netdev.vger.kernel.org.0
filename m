Return-Path: <netdev+bounces-3365-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C8C2706AB2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 338DE1C20FA4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC6331EE5;
	Wed, 17 May 2023 14:12:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5137718B16
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:12:25 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F6C1BCA
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JlCnn+9CjtVw4F7O913iPQBHktp/ow9voYyZeyX4pSQ=; b=bH5lIv8aWPBM1c09Z5gmjpR1mF
	lbFGRKc5oJWiq7ubB8nczHw/bYgzCU+W27129EAuGEsVxqkzrNnBr0Ww9f6vhkX5+8b92eRZ9xR2M
	xVaymduMkBnmoJU751wN5CJriyuWHhl54v6rvvFxYyWIuhSXdUj1bKQ/AGXpdHwAXtZ1YrZOnT+xQ
	1QOP/B1WYEIfaYm5FICn/MTYk5Nihr9P3+DbaQhFNSecGLSa0WQdMwJq4ngkN7NB/TI9J2kZpgKZG
	hybg8jzA8kQ32AH/APq8ECNQgYGRCkvCw9vVXgOFAVjyiqwsaiINN0LXiV7yx9XxFTIPQIYFyZqKB
	m/0DJjFg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45976 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pzHsv-00080P-Ur; Wed, 17 May 2023 15:12:09 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pzHsv-005sgF-Bm; Wed, 17 May 2023 15:12:09 +0100
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
Subject: [PATCH RFC net-next 5/9] net: pcs: xpcs: use mii_c73_to_linkmode()
 helper
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pzHsv-005sgF-Bm@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 17 May 2023 15:12:09 +0100
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
index b8d69a78f484..16fcc7891f92 100644
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


