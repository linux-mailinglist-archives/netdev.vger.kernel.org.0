Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F177C112071
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 00:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfLCXvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 18:51:35 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57142 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfLCXve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 18:51:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gJWYrYIkfYnDnhed5YeyLDrnvL+/+vmNTQlpwWNYO5M=; b=vsa+LDV2z12HVDnA6YGtJC95v9
        Mgqs8QkufO+wav1kDLtpBOFUlTu7q0oSsMomaAU7yfFXdhx5BtqKROrL8YbhZb3fZ4G0hBvHs/kK3
        6p+u/vYby5gORrhqjkVOSRmY+A/NQGMUn2vzom63KtEQx4RHdLpiEvQLEYxZrW9fvOxph3rbunFqt
        r1Tc6VhvZkfsv4i8da5yPOfnnG0r9H6Xs42KBFMON9NSjy5DgP2R5auE/qmH97wXXjrkupZGKAISR
        DqXSN2WTfGQZAQF/Z9gHoy8xyOMo7rsK6hckjVa4MF9vcrpc5Q84H80XeVXWl9evxlQnKHkAhC8Gy
        7hTv6lPw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:40996 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1icHwx-00011m-Nv; Tue, 03 Dec 2019 23:51:23 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1icHww-00043d-U9; Tue, 03 Dec 2019 23:51:23 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] net: sfp: fix unbind
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1icHww-00043d-U9@rmk-PC.armlinux.org.uk>
Date:   Tue, 03 Dec 2019 23:51:22 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When unbinding, we don't correctly tear down the module state, leaving
(for example) the hwmon registration behind. Ensure everything is
properly removed by sending a remove event at unbind.

Fixes: 6b0da5c9c1a3 ("net: sfp: track upstream's attachment state in state machine")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 8d05e888d3f8..78f53da1e34e 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2294,6 +2294,10 @@ static int sfp_remove(struct platform_device *pdev)
 
 	sfp_unregister_socket(sfp->sfp_bus);
 
+	rtnl_lock();
+	sfp_sm_event(sfp, SFP_E_REMOVE);
+	rtnl_unlock();
+
 	return 0;
 }
 
-- 
2.20.1

