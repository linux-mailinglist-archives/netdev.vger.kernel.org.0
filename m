Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB16318CADE
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCTJxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:53:53 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:39080 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726767AbgCTJxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 05:53:52 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B1DD4405D7;
        Fri, 20 Mar 2020 09:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584698032; bh=Ymm/5LKRoh2QJTCsoRsq/h0o4nDI97/1ZTZoUMiBUGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=L5lSxo1qf54eFQj0gbT1v97ko9bhj59wKI9OzRE6uoZjOkgGJcugK6kjWinlO6TNd
         zppH2ValZErmNV9DbRwNep00pKp3Zt57HOFrs9yazIXbgR5DqKu6mqLood28I3Uiwz
         zAdCbC7vr6449lXV2YrAeAA00qCFCuuT1u673Nu5mAUtH2BPjOwzBJUvy9mRVqAlC6
         DtLEhFJoBENZUfzL9iKbN5wwfDmrrjnLKuTm57RxnGsWoDg6aZ0eJw79XFUmsfDhAs
         F2dLOJZJdK1ay00YPQudi/ivZAMMYIV1nnneJ2/f157Wm2JZe9qlS/J0+ruq+dgIn9
         j3Ls49gUhYBug==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 1CA6CA0069;
        Fri, 20 Mar 2020 09:53:49 +0000 (UTC)
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
Subject: [PATCH net-next 4/4] net: phy: xpcs: Restart AutoNeg if outcome was invalid
Date:   Fri, 20 Mar 2020 10:53:37 +0100
Message-Id: <a720d5d30787c38503e4f05dd8cbb225674a8a45.1584697754.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1584697754.git.Jose.Abreu@synopsys.com>
References: <cover.1584697754.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1584697754.git.Jose.Abreu@synopsys.com>
References: <cover.1584697754.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Restart AutoNeg if we didn't get a valid result from previous run.

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
index f10d86b85fbd..0d66a8ba7eb6 100644
--- a/drivers/net/phy/mdio-xpcs.c
+++ b/drivers/net/phy/mdio-xpcs.c
@@ -433,8 +433,10 @@ static int xpcs_aneg_done(struct mdio_xpcs_args *xpcs,
 			return ret;
 
 		/* Check if Aneg outcome is valid */
-		if (!(ret & DW_C73_AN_ADV_SF))
+		if (!(ret & DW_C73_AN_ADV_SF)) {
+			xpcs_config_aneg(xpcs);
 			return 0;
+		}
 
 		return 1;
 	}
-- 
2.7.4

