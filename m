Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7919F046D
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 18:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390467AbfKERxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 12:53:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389356AbfKERxh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 12:53:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6dNtMo1vaLaunEW7cYxbRjpPyUrpvHBeM4Lc9DqA1mU=; b=mOkqa+oZQwzuW5gObhsI2pgKVT
        Pir+uXdQzWTDc/eaC7lUZGUEDg1oqFisLfPZrhRGpd+kAPjvlyh86Vcd+s1IvgVrrKVqrXgngGPc/
        zllmAAFpHhGJxLAQ69tyJ2OmP6Ouc8LShgG/ti8voFQSe8wwC4zlxkX1qeIaPRDL5/R4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iS31I-0003HJ-EF; Tue, 05 Nov 2019 18:53:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        kbuild test robot <lkp@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next] net: ethernet: emac: Fix phy mode type
Date:   Tue,  5 Nov 2019 18:53:23 +0100
Message-Id: <20191105175323.12560-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass a phy_interface_t to of_get_phy_mode(), by changing the type of
phy_mode in the device structure. This then requires that
zmii_attach() is also changes, since it takes a pointer to phy_mode.

Fixes: 0c65b2b90d13 ("net: of_get_phy_mode: Change API to solve int/unit warnings")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/ibm/emac/core.h | 2 +-
 drivers/net/ethernet/ibm/emac/zmii.c | 3 ++-
 drivers/net/ethernet/ibm/emac/zmii.h | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.h b/drivers/net/ethernet/ibm/emac/core.h
index e9cda024cbf6..89a1b0fea158 100644
--- a/drivers/net/ethernet/ibm/emac/core.h
+++ b/drivers/net/ethernet/ibm/emac/core.h
@@ -171,7 +171,7 @@ struct emac_instance {
 	struct mal_commac		commac;
 
 	/* PHY infos */
-	int				phy_mode;
+	phy_interface_t			phy_mode;
 	u32				phy_map;
 	u32				phy_address;
 	u32				phy_feat_exc;
diff --git a/drivers/net/ethernet/ibm/emac/zmii.c b/drivers/net/ethernet/ibm/emac/zmii.c
index b9e821de2ac6..57a25c7a9e70 100644
--- a/drivers/net/ethernet/ibm/emac/zmii.c
+++ b/drivers/net/ethernet/ibm/emac/zmii.c
@@ -78,7 +78,8 @@ static inline u32 zmii_mode_mask(int mode, int input)
 	}
 }
 
-int zmii_attach(struct platform_device *ofdev, int input, int *mode)
+int zmii_attach(struct platform_device *ofdev, int input,
+		phy_interface_t *mode)
 {
 	struct zmii_instance *dev = platform_get_drvdata(ofdev);
 	struct zmii_regs __iomem *p = dev->base;
diff --git a/drivers/net/ethernet/ibm/emac/zmii.h b/drivers/net/ethernet/ibm/emac/zmii.h
index 41d46e9b87ba..65daedc78594 100644
--- a/drivers/net/ethernet/ibm/emac/zmii.h
+++ b/drivers/net/ethernet/ibm/emac/zmii.h
@@ -50,7 +50,8 @@ struct zmii_instance {
 
 int zmii_init(void);
 void zmii_exit(void);
-int zmii_attach(struct platform_device *ofdev, int input, int *mode);
+int zmii_attach(struct platform_device *ofdev, int input,
+		phy_interface_t *mode);
 void zmii_detach(struct platform_device *ofdev, int input);
 void zmii_get_mdio(struct platform_device *ofdev, int input);
 void zmii_put_mdio(struct platform_device *ofdev, int input);
-- 
2.24.0.rc0

