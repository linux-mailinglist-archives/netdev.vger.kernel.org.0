Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA3343C6CF
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbhJ0Jv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241281AbhJ0Jv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 05:51:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B24C061745
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 02:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JvaH2SVw77ASHoVfBVxhPffjmweA4whlBL9/zPBmh+k=; b=AyIK9ki3pQQ34CtjzAbW5+Avqq
        MeNYTQgGvja+43PhvsQsthNwhKEADXQ2waok8+JqHeed6dbq+sNmCRnyEbP5VB4tYnfEbOYocgCkq
        8q14QqOZ38wZlltj+Czq/6IuVclujLnwXxA78KmZJnHjWH9xh76ks2/kJoJjUv/SWDccih5RcRhuY
        J4/olxEzdCF5DWn0LdPbJd3JBMun6ox5MGN6kgMiyO3om2l8DkkzDt/mwGr03eqAHGah/7OaC7C3w
        nKsmQIr5VEp2AF5Uu3U+zg3eH4K8ojtvOqzPWOOe6RLQ+zhslRP4pdlnlK3DVGPRvnD2Bk9ldexKh
        FubhAimQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34478 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mffYo-0006Ft-D1; Wed, 27 Oct 2021 10:49:30 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mffYn-001vqm-VV; Wed, 27 Oct 2021 10:49:30 +0100
In-Reply-To: <YXkgdrSCEhvY2jLK@shell.armlinux.org.uk>
References: <YXkgdrSCEhvY2jLK@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] net: mvpp2: clean up mvpp2_phylink_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mffYn-001vqm-VV@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 27 Oct 2021 10:49:29 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mvpp2_phylink_validate() no longer needs to check for
PHY_INTERFACE_MODE_NA as phylink will walk the supported interface
types to discover the link mode capabilities. Remove these checks.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d5904408e3a5..587def69a6f7 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6280,14 +6280,12 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_XAUI:
-	case PHY_INTERFACE_MODE_NA:
 		if (mvpp2_port_supports_xlg(port)) {
 			phylink_set_10g_modes(mask);
 			phylink_set(mask, 10000baseKR_Full);
 		}
-		if (state->interface != PHY_INTERFACE_MODE_NA)
-			break;
-		fallthrough;
+		break;
+
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
@@ -6299,19 +6297,18 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 		phylink_set(mask, 100baseT_Full);
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseX_Full);
-		if (state->interface != PHY_INTERFACE_MODE_NA)
-			break;
-		fallthrough;
+		break;
+
 	case PHY_INTERFACE_MODE_1000BASEX:
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseX_Full);
-		if (state->interface != PHY_INTERFACE_MODE_NA)
-			break;
-		fallthrough;
+		break;
+
 	case PHY_INTERFACE_MODE_2500BASEX:
 		phylink_set(mask, 2500baseT_Full);
 		phylink_set(mask, 2500baseX_Full);
 		break;
+
 	default:
 		goto empty_set;
 	}
-- 
2.30.2

