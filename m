Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795F2594CA
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfF1HZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 03:25:21 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:53324 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726574AbfF1HZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:25:21 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 06725C0ABB;
        Fri, 28 Jun 2019 07:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561706720; bh=T6VhbxQBn60YsJz3rj2qAY6BMbwV1q6YS9QLKjZns24=;
        h=From:To:Cc:Subject:Date:From;
        b=V+3oItKN7bvJJL6IK2kctD29BSa5RKNiDetNrvhsCcbzyLwcvdQ00LHRGT1MIDeTf
         Au3H5fgdNavHLoHCvXf6hKB8Q/Z4qb/CjjUrlnyZQNfC8oS6MXBSIBpGBAwkznEdup
         NHEhhy4D9AkJp062OERaED6iHLWzaemz1qLQWR2jrhbQ4pwH5t4PFOc26K/ibSXYNF
         6PSBVxc34l5cME0ansRX8S7HubxKjzkPiTHr6qgHvu6rEx79HrNBE5TgwUd0/QIYpj
         qv78zDwYa1lNR2UtSsrnD6M3rxp1vsYr7cc4bvUmIZBEwW1CaEnsJKlpDzNFgo2E+r
         mOD/kNtcLG6TQ==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 07A1BA0233;
        Fri, 28 Jun 2019 07:25:17 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 7FAC23E8CB;
        Fri, 28 Jun 2019 09:25:10 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH net-next v2] net: stmmac: Fix case when PHY handle is not present
Date:   Fri, 28 Jun 2019 09:25:07 +0200
Message-Id: <654cfe790807c6dfcc69c610c9692efb8c9a6179.1561706654.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some DT bindings do not have the PHY handle. Let's fallback to manually
discovery in case phylink_of_phy_connect() fails.

Changes from v1:
	- Fixup comment style (Sergei)

Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
Reported-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
Tested-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8f5ebd51859e..91f24b63ea16 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -953,9 +953,13 @@ static int stmmac_init_phy(struct net_device *dev)
 
 	node = priv->plat->phylink_node;
 
-	if (node) {
+	if (node)
 		ret = phylink_of_phy_connect(priv->phylink, node, 0);
-	} else {
+
+	/* Some DT bindings do not set-up the PHY handle. Let's try to
+	 * manually parse it
+	 */
+	if (!node || ret) {
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
-- 
2.7.4

