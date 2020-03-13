Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655AA184858
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 14:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgCMNkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 09:40:12 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:59794 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726683AbgCMNkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 09:40:11 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 13428C0FAB;
        Fri, 13 Mar 2020 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584106810; bh=E54LODA3Nkm7g3IJUjmzcbT3oFt34YuZSG/e5frmYec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=cLQ/soscwtaub51bpfwizsfAwO7XVSBCHOXGVXUI/8JiqkP5X7tNa8VZg7E+b1LB8
         PF4nkEsBBO4yQzq3pchbymYiEi36wB23HiQkk/IvRty1a2j6hCDVSIkyWsRcsudE72
         Q9RtX9qzkd02px/ehn+BEm+07sUevi0sBHbEnfNg0i1DyVX08Zbf6ZNu+uV+CGwb/E
         GKdw240JQ7ro4pKv+26yFBu5VaPG7+r3b+PjV36qs+7mMEKa8+EzcfgjmBcdFRh5xy
         H+ktP/tQT8cZUZiheZeklfjLwtvmm3CyRxJVjE5w++ILaLEvJNzRZjDfkfn1bB6mrY
         GtulGVW0RodRg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 6DA05A005D;
        Fri, 13 Mar 2020 13:40:08 +0000 (UTC)
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
Subject: [PATCH net-next 1/4] net: phy: xpcs: Clear latched value of RX/TX fault
Date:   Fri, 13 Mar 2020 14:39:40 +0100
Message-Id: <50f3dd2ab58fecfea1156aaf8dbfa99d0c7b36be.1584106347.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1584106347.git.Jose.Abreu@synopsys.com>
References: <cover.1584106347.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1584106347.git.Jose.Abreu@synopsys.com>
References: <cover.1584106347.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When reading RX/TX fault register we may have latched values from Link
down. Clear the latched value first and then read it again to make sure
no old errors are flagged and that new errors are caught.

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
 drivers/net/phy/mdio-xpcs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/mdio-xpcs.c b/drivers/net/phy/mdio-xpcs.c
index 973f588146f7..a4cbeecc6d42 100644
--- a/drivers/net/phy/mdio-xpcs.c
+++ b/drivers/net/phy/mdio-xpcs.c
@@ -185,6 +185,7 @@ static int xpcs_read_fault(struct mdio_xpcs_args *xpcs,
 		return -EFAULT;
 	}
 
+	xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT2);
 	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT2);
 	if (ret < 0)
 		return ret;
-- 
2.7.4

