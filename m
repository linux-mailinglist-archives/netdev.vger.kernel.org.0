Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CF543C6CE
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241280AbhJ0Jvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241276AbhJ0Jvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 05:51:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55557C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 02:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pNW4FB9cKk2wgzSTiSfW49YUnAy2H1Ag1BcfVk0EOos=; b=H7bEMbal3603YFmL41MBbioyP3
        doWUDOdHTxanRLgd86wMTHBX8uNUjWUBnAe6NZz3IWS3Xr1y6a8aDWwkYyPwEzg4jAYf/lRrhpRQT
        jjToqj6cTU3FXgTEHOkvcKdUuLY26LcJdBFB2ZKHtpeJOMLSdNFw09JBAXrIAWNDo17/KC9G5D55T
        E/xGnZLEQpsA7ykuOAOIFiEVZZ1vnlb1oxvBehvfpbqwge7YMfr/usHbgHP4WOSsG8CeS4q0+bIP7
        4KnAkyS87tAzzMva4PTuPjswY/4yAWpfrNTLARftN+6/La65FRcelpqt9BldqVStK+QhBMxes4kk3
        kmItBJPw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34476 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mffYj-0006Fk-9Y; Wed, 27 Oct 2021 10:49:25 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mffYi-001vqg-Rr; Wed, 27 Oct 2021 10:49:24 +0100
In-Reply-To: <YXkgdrSCEhvY2jLK@shell.armlinux.org.uk>
References: <YXkgdrSCEhvY2jLK@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] net: mvpp2: drop use of
 phylink_helper_basex_speed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mffYi-001vqg-Rr@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 27 Oct 2021 10:49:24 +0100
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
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 48703b6dff1e..d5904408e3a5 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6303,17 +6303,14 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 			break;
 		fallthrough;
 	case PHY_INTERFACE_MODE_1000BASEX:
+		phylink_set(mask, 1000baseT_Full);
+		phylink_set(mask, 1000baseX_Full);
+		if (state->interface != PHY_INTERFACE_MODE_NA)
+			break;
+		fallthrough;
 	case PHY_INTERFACE_MODE_2500BASEX:
-		if (port->comphy ||
-		    state->interface != PHY_INTERFACE_MODE_2500BASEX) {
-			phylink_set(mask, 1000baseT_Full);
-			phylink_set(mask, 1000baseX_Full);
-		}
-		if (port->comphy ||
-		    state->interface == PHY_INTERFACE_MODE_2500BASEX) {
-			phylink_set(mask, 2500baseT_Full);
-			phylink_set(mask, 2500baseX_Full);
-		}
+		phylink_set(mask, 2500baseT_Full);
+		phylink_set(mask, 2500baseX_Full);
 		break;
 	default:
 		goto empty_set;
@@ -6321,8 +6318,6 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
-
-	phylink_helper_basex_speed(state);
 	return;
 
 empty_set:
-- 
2.30.2

