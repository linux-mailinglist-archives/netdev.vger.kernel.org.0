Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4C219B4A9
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 19:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732574AbgDAR3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 13:29:13 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:50888 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726445AbgDAR3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 13:29:12 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 25C1AC0F86;
        Wed,  1 Apr 2020 17:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1585762152; bh=+pqAfs8F1mKnWz24eqJJvntFD5qLhFA4j1I4ISeo3no=;
        h=From:To:Cc:Subject:Date:From;
        b=WP2Q/T7QDZZHQRwz/FuDbCuQSfJEVV8GGGvk0kh7md2q8+/9d9SpEacYx437dA/sk
         /w3+9b3Vne+JK5pfCNqTRkw0VSvuh56AHo2i1RKmzbVq6UPHQJSCot/wKVOHzrvWoI
         JlXk+BNWwtcakKTYGSVtCICQO/XFV3FlU/4jM/YaPGhzwdcaW0Yh2RhhEbXvq6mhU2
         nqHNLytTbefWDmEYanhjkf3jbsnYgXAJsZBLW6Ikaqosxyqd/FGJgsb9k/EMP+TNUh
         18po7usSHHm681N8Nc/W3szl6L7vq2SHcybioRKX01xD98Kb8xTHTcwiPvNoa/Qt3l
         5FKNA25Wtl2qw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id E0543A005B;
        Wed,  1 Apr 2020 17:29:08 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: stmmac: Fix VLAN filtering when HW does not support it
Date:   Wed,  1 Apr 2020 19:29:03 +0200
Message-Id: <42e493820f707c5a5d3375676ef6b6a96988f846.1585762111.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we don't have any filters available we can't rely upon the return
code of stmmac_add_hw_vlan_rx_fltr() / stmmac_del_hw_vlan_rx_fltr(). Add
a check for this.

Fixes: ed64639bc1e0 ("net: stmmac: Add support for VLAN Rx filtering")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b77d2faa580f..bd35a3df871d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4570,9 +4570,13 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 		return ret;
 	}
 
-	ret = stmmac_add_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
+	if (priv->hw->num_vlan) {
+		ret = stmmac_add_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
+		if (ret)
+			return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vid)
@@ -4585,9 +4589,12 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 		is_double = true;
 
 	clear_bit(vid, priv->active_vlans);
-	ret = stmmac_del_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
-	if (ret)
-		return ret;
+
+	if (priv->hw->num_vlan) {
+		ret = stmmac_del_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
+		if (ret)
+			return ret;
+	}
 
 	return stmmac_vlan_update(priv, is_double);
 }
-- 
2.7.4

