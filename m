Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46DA40F96C
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240605AbhIQNkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241482AbhIQNiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:38:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7503CC0613E3
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 06:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Q9t9e/O6lGUc0B+cqXOeE1+5ThFIXp0isDYugvr3akY=; b=k8ucadt8USGu2JDdTY27JlIqQi
        y1mppYV/WIXp21BahEhuMwabqMkdqcG14bP7Du/5doHrfTwYc/diScH6+JOD7XvYeEzlcDgVtrqCp
        sy1rPb+uPGplOZECvni+PTWJaZLA88KPe/BndSgvc0N0gWoH0j6EMEitaPgTFY/1AwF4Khu0ShfkE
        vZz8GLNAHJSB2B66LLeJg2ZPuFCnNOlcJOFHSyb3loLIp201fcfI5vkyYkAUDTlrdYa8M6v1im1LF
        opMRYIhL0n5vSpnIn1IrBCpxLVH/L2+ZIhIpRvjlRaT0kvnn7+L4bh0/gJ2Gtxocaj9h8pOYjb6f+
        xUAxJOEQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48964 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mRE2b-0007kU-2U; Fri, 17 Sep 2021 14:36:31 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mRE2Z-001xhc-CB; Fri, 17 Sep 2021 14:36:31 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH net-next] net: phylink: don't call netif_carrier_off() with
 NULL netdev
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mRE2Z-001xhc-CB@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 17 Sep 2021 14:36:31 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter points out that we have a code path that permits a NULL
netdev pointer to be passed to netif_carrier_off(), which will cause
a kernel oops. In any case, we need to set pl->old_link_state to false
to have the desired effect when there is no netdev present.

Fixes: f97493657c63 ("net: phylink: add suspend/resume support")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
This does not need to be queued for -rc as there is only one user of
phylink_suspend(), which will always have a non-NULL netdev pointer.
Hence, submitting for net-next is appropriate.

 drivers/net/phy/phylink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 0a0abe8e4be0..5a58c77d0002 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1333,7 +1333,10 @@ void phylink_suspend(struct phylink *pl, bool mac_wol)
 		 * but one would hope all packets have been sent. This
 		 * also means phylink_resolve() will do nothing.
 		 */
-		netif_carrier_off(pl->netdev);
+		if (pl->netdev)
+			netif_carrier_off(pl->netdev);
+		else
+			pl->old_link_state = false;
 
 		/* We do not call mac_link_down() here as we want the
 		 * link to remain up to receive the WoL packets.
-- 
2.30.2

