Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A0856B1C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfFZNs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:48:27 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:51140 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727870AbfFZNry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:47:54 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B8980C0C47;
        Wed, 26 Jun 2019 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561556874; bh=BHZi9tlrtLzVjp82tFDoiezzz8W/tFd5CHoGlftdzuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=WQ9e4SONVoWDIF5qsCwGuH6eNP9Y3N1YVmTcFhEVNr1iDYYYigv0WOtcbIUZEuMjR
         r8Aec50VMdl6MbPvqNB4poaY2ZFPmTuqUvfkLmMb+d+6DPF6Cjt10evH6zbWQFD6Kq
         e9UcGtcdvBRsLBVvDZ48wlrC6EI0XNtrh7AcfiTiqqdXPMlnSM6+sHnAfB21d6nwaI
         rCZ4NdC/SJ4/Mg9WKg4su+slvwYruiVpPsYbolfBtjz2ZXV9b7m7sZHC+rx0gmzXTc
         OiXgEP0ydefIU/dPHj/ToVwjdflwiPzhw1CYNZ/igeSIKyhnnZ9hImsBD0rhFbLB2K
         HVfKSQYOCB7gQ==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 63A35A0075;
        Wed, 26 Jun 2019 13:47:52 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 53CBE3B57C;
        Wed, 26 Jun 2019 15:47:52 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 10/10] net: stmmac: Try to get C45 PHY if everything else fails
Date:   Wed, 26 Jun 2019 15:47:44 +0200
Message-Id: <c7d1dbac1940853c22db8215ed60181b2abe3050.1561556556.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561556555.git.joabreu@synopsys.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
In-Reply-To: <cover.1561556555.git.joabreu@synopsys.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On PCI based setups that are connected to C45 PHY we won't have DT
bindings specifying what's the correct PHY type.

Fallback to C45 if everything else fails when trying to acquire PHY.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index bc949665c529..e790ab79e819 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1014,6 +1014,20 @@ static int stmmac_init_phy(struct net_device *dev)
 
 		phydev = mdiobus_get_phy(priv->mii, addr);
 		if (!phydev) {
+			/* Try C45 */
+			phydev = get_phy_device(priv->mii, addr, true);
+			if (phydev && !IS_ERR(phydev)) {
+				ret = phy_device_register(phydev);
+				if (ret) {
+					phy_device_free(phydev);
+					phydev = NULL;
+				}
+			} else {
+				phydev = NULL;
+			}
+		}
+
+		if (!phydev) {
 			netdev_err(priv->dev, "no phy at addr %d\n", addr);
 			return -ENODEV;
 		}
-- 
2.7.4

