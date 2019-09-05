Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4BFAA1E8
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 13:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731942AbfIELnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 07:43:22 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:52952 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731584AbfIELnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 07:43:22 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 92F59C2A1C;
        Thu,  5 Sep 2019 11:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567683802; bh=Qjz7X2UzGUnHTi/Vxd8hfhSuMVDRCM9oZteF3iucUAU=;
        h=From:To:Cc:Subject:Date:From;
        b=D9ku2U0j2gUu3CQPQ1LegWt0SFGVSTOOriWxGP7M4M68mJORHkM2Gb9P08uVD/pRw
         gyCHyZTALg6NpglcstFKMPnI6uYW7K496aYK8Z6gr7+H/ZnqR/m8mnYtcbWeE2NlKA
         et6hmXk3Fc3OXE+RurA6ZuM+MXoicC064lETuIdnMc+d0JWvAJ0V9HnF8hsedwrrkX
         8kkFhf5yWJfaMfnVodZozevS+07Hu+NRa3xymEz0QRXjVETZz8pF6Hl3fnp5MLp4rj
         NYSvgTfcyL0TO7jxIaR/LVsEQwfO6SYVRKqaM+hFGN2mttFoexwHdY9+GHrLY4R6Lq
         NEA7z74W2g3IQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 87AE1A005C;
        Thu,  5 Sep 2019 11:43:17 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: phy: Do not check Link status when loopback is enabled
Date:   Thu,  5 Sep 2019 13:43:10 +0200
Message-Id: <7db46f6b1318ec22d45f7e6f6f907eda015a9df6.1567683751.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running stmmac selftests I found that in my 1G setup some tests
were failling when running with PHY loopback enabled.

It looks like when loopback is enabled the PHY will report that Link is
down even though there is a valid connection.

As in loopback mode the data will not be sent anywhere we can bypass the
logic of checking if Link is valid thus saving unecessary reads.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/phy/phy.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 35d29a823af8..7c92afd36bbe 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -525,6 +525,12 @@ static int phy_check_link_status(struct phy_device *phydev)
 
 	WARN_ON(!mutex_is_locked(&phydev->lock));
 
+	/* Keep previous state if loopback is enabled because some PHYs
+	 * report that Link is Down when loopback is enabled.
+	 */
+	if (phydev->loopback_enabled)
+		return 0;
+
 	err = phy_read_status(phydev);
 	if (err)
 		return err;
-- 
2.7.4

