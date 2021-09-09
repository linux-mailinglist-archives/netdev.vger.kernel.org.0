Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B77405C28
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 19:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241675AbhIIRe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 13:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237196AbhIIRew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 13:34:52 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961F5C061574;
        Thu,  9 Sep 2021 10:33:40 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id f129so2518678pgc.1;
        Thu, 09 Sep 2021 10:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iFJUrF+o1XXL4glT0hL5CZo3Pjc81H3YzpbY4+Q3TFE=;
        b=UxIXX7L24Kq0BjpNxIAu0kJwogGLSNFeTpk7x9iiJxyaN20F8B2DVDqWZhyCM5feRB
         RTh6XdNIQILIVUKZKvx9+0CUdahCgk6lcXVE03bCDssqimbZn4dEKTKTsZS0YpT6n+JJ
         5AeO9EmZRICuTO7Yqj7+0/n5ChpiIXQFu94qaXEFeNfQijMyfl9qxuz3XKFX4SZO7fpC
         16FkRcTbzC3BpGBCHhg/YwugcQV31CyLYSw7LVRuWTirYOznaWDfkg0PJbZiDkEANm/6
         RsXL90UXmgRRLdeQvm9NSoQ4DCgbHVyTlCHTC0ZfK5zOyUumfR2WUQ5/YTrhbdUR4E1u
         Ac+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iFJUrF+o1XXL4glT0hL5CZo3Pjc81H3YzpbY4+Q3TFE=;
        b=y8XmTS9okV2g+aNMeaF+9x9PxKZqZ+ILMi96eQspdjV4MkElEjqVdfo+ZNEl5gutaS
         nP3WWp73M6kP0MuyLB44Q7WxJD3SndR0W/39fxsu+iJ1e6+9VVCF7+SOGJkHacJrS76t
         isO3bPUSFwwcTHnBzOVjX4dLLN4mhUcG0Lt73vpeYC+84oLmJbVJ+o7hicdezToUluYc
         rngFSWk5APOsD6a1lusZprkpUxAgffKKSG/8LApY3NQ5Ih6iKBMyVIkvwxctDsJhGEyJ
         ukW8lJ5+N4CtbPticlh0Uy1JpQFWW+BmEP0CR+oznHvtlxG4uR1bRm+I4LslZB+/1xnt
         97Ng==
X-Gm-Message-State: AOAM5306egm/W9tnhMdefRXYiYhPixQy7Q63tA4rQ/pQ0aaYw/WVarDN
        3uzS0ObmISX3G//wfYuWAk+AjEwkHrA=
X-Google-Smtp-Source: ABdhPJweSuFFoed3DDhrphPJO08kSi4Jxd4Ih7Jqv+yH8vGeRG151wDESf6XDOBzd7MX9qgRXN0nOQ==
X-Received: by 2002:a63:77cc:: with SMTP id s195mr3641928pgc.147.1631208819680;
        Thu, 09 Sep 2021 10:33:39 -0700 (PDT)
Received: from 7YHHR73.igp.broadcom.net (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id t13sm748153pfe.199.2021.09.09.10.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 10:33:39 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrius V <vezhlys@gmail.com>,
        Darek Strugacz <darek.strugacz@op.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] r6040: Restore MDIO clock frequency after MAC reset
Date:   Thu,  9 Sep 2021 10:33:28 -0700
Message-Id: <20210909173328.5293-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of users have reported that they were not able to get the PHY
to successfully link up, especially after commit c36757eb9dee ("net:
phy: consider AN_RESTART status when reading link status") where we
stopped reading just BMSR, but we also read BMCR to determine the link
status.

Andrius at NetBSD did a wonderful job at debugging the problem
and found out that the MDIO bus clock frequency would be incorrectly set
back to its default value which would prevent the MDIO bus controller
from reading PHY registers properly. Back when we only read BMSR, if we
read all 1s, we could falsely indicate a link status, though in general
there is a cable plugged in, so this went unnoticed. After a second read
of BMCR was added, a wrong read will lead to the inability to determine
a link UP condition which is when it started to be visibly broken, even
if it was long before that.

The fix consists in restoring the value of the MD_CSR register that was
set prior to the MAC reset.

Link: http://gnats.netbsd.org/cgi-bin/query-pr-single.pl?number=53494
Fixes: 90f750a81a29 ("r6040: consolidate MAC reset to its own function")
Reported-by: Andrius V <vezhlys@gmail.com>
Reported-by: Darek Strugacz <darek.strugacz@op.pl>
Tested-by: Darek Strugacz <darek.strugacz@op.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/rdc/r6040.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index 4b2eca5e08e2..01ef5efd7bc2 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -119,6 +119,8 @@
 #define PHY_ST		0x8A	/* PHY status register */
 #define MAC_SM		0xAC	/* MAC status machine */
 #define  MAC_SM_RST	0x0002	/* MAC status machine reset */
+#define MD_CSC		0xb6	/* MDC speed control register */
+#define  MD_CSC_DEFAULT	0x0030
 #define MAC_ID		0xBE	/* Identifier register */
 
 #define TX_DCNT		0x80	/* TX descriptor count */
@@ -355,8 +357,9 @@ static void r6040_reset_mac(struct r6040_private *lp)
 {
 	void __iomem *ioaddr = lp->base;
 	int limit = MAC_DEF_TIMEOUT;
-	u16 cmd;
+	u16 cmd, md_csc;
 
+	md_csc = ioread16(ioaddr + MD_CSC);
 	iowrite16(MAC_RST, ioaddr + MCR1);
 	while (limit--) {
 		cmd = ioread16(ioaddr + MCR1);
@@ -368,6 +371,10 @@ static void r6040_reset_mac(struct r6040_private *lp)
 	iowrite16(MAC_SM_RST, ioaddr + MAC_SM);
 	iowrite16(0, ioaddr + MAC_SM);
 	mdelay(5);
+
+	/* Restore MDIO clock frequency */
+	if (md_csc != MD_CSC_DEFAULT)
+		iowrite16(md_csc, ioaddr + MD_CSC);
 }
 
 static void r6040_init_mac_regs(struct net_device *dev)
-- 
2.25.1

