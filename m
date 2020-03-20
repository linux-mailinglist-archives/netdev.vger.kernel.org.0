Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF4E18CADA
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgCTJx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:53:56 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42788 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727269AbgCTJxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 05:53:54 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B23BFC0F92;
        Fri, 20 Mar 2020 09:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584698033; bh=h74U0U4jIw0j/jk8lJHNLf+lBUIcauvonuzvfUGas8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=lUenk/xz/141nZyZiKx8Ie9gQlaKmHDN6jfoyqh5i/KgSzRwMTCWu1i2uFdLHjeBU
         oihto0K/FflmCDwyZJqR3K+ZH8D0pvmGopO42o8SWoit3GA09+HlIyTmiKT/hSqUBG
         IBybm1xVpZhXdvEU3rDVrrTYejX8stZVaKhpN2U0CpvIKASTqO4lVRU6sjALzYwRNT
         TEFqqqjbtqU9ibCsWcArCXnk8w1U2lfW2d05nGfO9PtdQ6B7VjvltQuUDv7rDxT4m0
         oGcCmCeM57/ftWQbxmYJ5OXkfBgFhR7RpILehyJ2uG/37vlMVcARaGzViB7wy+g2Qi
         +B/s2ad81N+mg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id DFF16A0060;
        Fri, 20 Mar 2020 09:53:48 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] net: phy: xpcs: Return error when 10GKR link errors are found
Date:   Fri, 20 Mar 2020 10:53:34 +0100
Message-Id: <e924c6c2b02239d76dd5f8962f6efee51de5093d.1584697754.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1584697754.git.Jose.Abreu@synopsys.com>
References: <cover.1584697754.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1584697754.git.Jose.Abreu@synopsys.com>
References: <cover.1584697754.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For 10GKR rate, when link errors are found we need to return fault
status so that XPCS is correctly resumed.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/phy/mdio-xpcs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio-xpcs.c b/drivers/net/phy/mdio-xpcs.c
index 2f4cdf807160..c04e9bf40180 100644
--- a/drivers/net/phy/mdio-xpcs.c
+++ b/drivers/net/phy/mdio-xpcs.c
@@ -255,8 +255,10 @@ static int xpcs_read_fault(struct mdio_xpcs_args *xpcs,
 	if (ret < 0)
 		return ret;
 
-	if (ret & MDIO_PCS_10GBRT_STAT2_ERR)
+	if (ret & MDIO_PCS_10GBRT_STAT2_ERR) {
 		xpcs_warn(xpcs, state, "Link has errors!\n");
+		return -EFAULT;
+	}
 
 	return 0;
 }
-- 
2.7.4

