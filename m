Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E1F43E453
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhJ1O6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhJ1O6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:58:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A43C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5fxrQ6tDB6LqYBTXnVO6a4CxXqNuGpkj6Wjb/jcoLOM=; b=BHK4+pVMYtvrVZHJpmYHORvb2a
        K/0Kx7XgXrJOfY0XluDhMljOo16KrWY57yUD9tqIDbo9aFxlg6jAw6yRnkhfw8rK6w2jdOfkR24F3
        z6ZvmpEMbms3BedHAx8sbMtYOs7ZkRQCFNi040CB/knEkAb6YSkW63FYqyd5smsOOez78kNjX+ehk
        IVgHJmK9F6quX4100jBxbiti6/BNY0DsM13c5hjWEx9TGMPpLOmgrE16hRnfs0LW3vYGCPUxnjGkF
        bN/rv0OT733fES6gZ05V2PawzgFOceeAEhINzPUcCb/nH5u9M5PutUVgNi73I/MbvGieKhQEt7s2H
        DPoLcj0g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45968 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mg6oZ-0007gF-CV; Thu, 28 Oct 2021 15:55:35 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mg6oY-0020Bg-Td; Thu, 28 Oct 2021 15:55:34 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: phylink: avoid mvneta warning when setting pause
 parameters
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mg6oY-0020Bg-Td@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 28 Oct 2021 15:55:34 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mvneta does not support asymetric pause modes, and it flags this by the
lack of AsymPause in the supported field. When setting pause modes, we
check that pause->rx_pause == pause->tx_pause, but only when pause
autoneg is enabled. When pause autoneg is disabled, we still allow
pause->rx_pause != pause->tx_pause, which is incorrect when the MAC
does not support asymetric pause, and causes mvneta to issue a warning.

Fix this by removing the test for pause->autoneg, so we always check
that pause->rx_pause == pause->tx_pause for network devices that do not
support AsymPause.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 0a0abe8e4be0..5defc721dd05 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1724,7 +1724,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 		return -EOPNOTSUPP;
 
 	if (!phylink_test(pl->supported, Asym_Pause) &&
-	    !pause->autoneg && pause->rx_pause != pause->tx_pause)
+	    pause->rx_pause != pause->tx_pause)
 		return -EINVAL;
 
 	pause_state = 0;
-- 
2.30.2

