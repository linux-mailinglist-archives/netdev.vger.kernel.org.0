Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1AB252654
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfFYITU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:19:20 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:52974 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727887AbfFYITT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:19:19 -0400
Received: from mailhost.synopsys.com (unknown [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F3B2EC0A95;
        Tue, 25 Jun 2019 08:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561450759; bh=aiaPDl4vQuKro8j2vf1Kqy0H4j+cOhqNeVOWB+OGgCU=;
        h=From:To:Cc:Subject:Date:From;
        b=dL1lfL4rXACyWZtSu5IC6WSXdFjDZwXWGfnyOWzuuwJ8I+kZco6gwg4a7n7SW/XG4
         NUiUBbW7l0l9COAzeakcDwEshZvyO9fsxjuMtyaG8T9S+GRiYxIZzr32OXaZPsXjiW
         cWZ3YZ3d9Oe7F4FhOrVtFJ1Yb51f+n+QMoYI1INZyKQGw4JAx9yUaj8j/EqRySkj/x
         4PDhzyd+xwjBlY/iFOdBc+Qm0lhkc7YaoEFi8qL/39m6KVnvuk7vkw0zmpkXkOAfs9
         Oh1N4TJepLH17X0TU02mnSkai55czIglBRXR716OjXzSTnjjh1hOolKKgpymR7r26t
         0rUX4PUgoRjKQ==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 0BA10A022F;
        Tue, 25 Jun 2019 08:19:16 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id AC8CC3DD5A;
        Tue, 25 Jun 2019 10:19:16 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next] net: stmmac: Fix the case when PHY handle is not present
Date:   Tue, 25 Jun 2019 10:19:08 +0200
Message-Id: <351cce38d1c572d8b171044f2856c7fae9f89cbc.1561450696.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some DT bindings do not have the PHY handle. Let's fallback to manually
discovery in case phylink_of_phy_connect() fails.

Reported-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
Hello Katsuhiro,

Can you please test this patch ?
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a48751989fa6..f4593d2d9d20 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -950,9 +950,12 @@ static int stmmac_init_phy(struct net_device *dev)
 
 	node = priv->plat->phylink_node;
 
-	if (node) {
+	if (node)
 		ret = phylink_of_phy_connect(priv->phylink, node, 0);
-	} else {
+
+	/* Some DT bindings do not set-up the PHY handle. Let's try to
+	 * manually parse it */
+	if (!node || ret) {
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
-- 
2.7.4

