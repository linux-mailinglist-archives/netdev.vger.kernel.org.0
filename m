Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7504D452EAC
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbhKPKJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbhKPKJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:09:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4066FC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 02:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1UffHZf+PQn8gcJrkq9n0w/iIiec6NH9F4LRAB/vcKk=; b=joQnlDOCr3NRdzEfijqKIFferF
        KX+/szz/wmNbp/f1JiRKY0Bm+Bi3YEmoLezrYMZft5QIV/PV0YlnU9ji3+fjJ9yckhZztT3uuk/Pe
        PpAOGDe8tBENujcg7vKKtdOvN2SS2f3UqIscl6UO0Jek7QoXbz/JqU4wkffxU61pp8+vKLuelE5gC
        kifNjqjphLxKn0IYv5on1CQMqsQExau2noDU79PfiWlWXCT+JVRXbKD9aX8lrTtYBbF0iLbM8SNSF
        MY+6FrwpBOuey2uTVtbYR8iw/Z9xKQmnn4tbvPOvC6DmMtq70J9gJfGSYxa5icfMBygwk2Sub30x4
        K6Hat7eA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39842 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvMc-0000MF-7g; Tue, 16 Nov 2021 10:06:54 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvMb-0078bU-Oe; Tue, 16 Nov 2021 10:06:53 +0000
In-Reply-To: <YZOCn1vMUAbhq3j0@shell.armlinux.org.uk>
References: <YZOCn1vMUAbhq3j0@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 3/4] net: mtk_eth_soc: drop use of
 phylink_helper_basex_speed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvMb-0078bU-Oe@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 10:06:53 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a better method to select SFP interface modes, we
no longer need to use phylink_helper_basex_speed() in a driver's
validation function, and we can also get rid of our hack to indicate
both 1000base-X and 2500base-X if the comphy is present to make that
work. Remove this hack and use of phylink_helper_basex_speed().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 31872594c790..98f9a6ed9584 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -477,8 +477,9 @@ static void mtk_validate(struct phylink_config *config,
 		phylink_set(mask, 1000baseT_Full);
 		break;
 	case PHY_INTERFACE_MODE_1000BASEX:
-	case PHY_INTERFACE_MODE_2500BASEX:
 		phylink_set(mask, 1000baseX_Full);
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
 		phylink_set(mask, 2500baseX_Full);
 		break;
 	case PHY_INTERFACE_MODE_GMII:
@@ -508,11 +509,6 @@ static void mtk_validate(struct phylink_config *config,
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
-
-	/* We can only operate at 2500BaseX or 1000BaseX. If requested
-	 * to advertise both, only report advertising at 2500BaseX.
-	 */
-	phylink_helper_basex_speed(state);
 }
 
 static const struct phylink_mac_ops mtk_phylink_ops = {
-- 
2.30.2

