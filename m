Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4739C1CFD
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbfI3IUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:20:23 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:46044 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730016AbfI3IT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 04:19:27 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C5879C0376;
        Mon, 30 Sep 2019 08:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569831566; bh=DIrBlnTN+2e2Xshklv4tKK7eG84iI4t6E5yVB8RhCTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=jcbWQmhFxuQMxnU1sQk3n6K56I5PWCNjR5Uh4r7SwHdYHb8w1HpcaGowIPSzUADj9
         9IyWhgqLFK7nokgbW+7btXhxG7MBQ1FPvCc2lurXv+f1kT/a2iymj9KoE13qIEPVVD
         UYHKxLWpZoB4T2ejSt/k1BfyG6oGUvk++nsdjpJDnkx7W/+wdFwMhNES5kH9qghHBU
         GMa0mIB7qs5U/1MqTbp1dQppzGi68zC6gbfLb9vEeMmCjMtQ6AvR1vafUpGL1tLnO9
         WzNz9uKXrexZLZ/2OuRWxCztnHTfdeCyXgazx51iPnHMa4tOm8n8He/+t8gaEsBtdx
         Su4w2LFhWQ20A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 8366AA0084;
        Mon, 30 Sep 2019 08:19:23 +0000 (UTC)
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
Subject: [PATCH v2 net 6/9] net: stmmac: Do not stop PHY if WoL is enabled
Date:   Mon, 30 Sep 2019 10:19:10 +0200
Message-Id: <7f8094c677036ef0600002f683633d39d61242d9.1569831229.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1569831228.git.Jose.Abreu@synopsys.com>
References: <cover.1569831228.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1569831228.git.Jose.Abreu@synopsys.com>
References: <cover.1569831228.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If WoL is enabled we can't really stop the PHY, otherwise we will not
receive the WoL packet. Fix this by telling phylink that only the MAC is
down and only stop the PHY if WoL is not enabled.

Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 31a237ec73bc..843d53e084b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4718,9 +4718,7 @@ int stmmac_suspend(struct device *dev)
 
 	mutex_lock(&priv->lock);
 
-	rtnl_lock();
-	phylink_stop(priv->phylink);
-	rtnl_unlock();
+	phylink_mac_change(priv->phylink, false);
 
 	netif_device_detach(ndev);
 	stmmac_stop_all_queues(priv);
@@ -4735,6 +4733,10 @@ int stmmac_suspend(struct device *dev)
 		stmmac_pmt(priv, priv->hw, priv->wolopts);
 		priv->irq_wake = 1;
 	} else {
+		rtnl_lock();
+		phylink_stop(priv->phylink);
+		rtnl_unlock();
+
 		stmmac_mac_set(priv, priv->ioaddr, false);
 		pinctrl_pm_select_sleep_state(priv->device);
 		/* Disable clock in case of PWM is off */
@@ -4825,9 +4827,13 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_start_all_queues(priv);
 
-	rtnl_lock();
-	phylink_start(priv->phylink);
-	rtnl_unlock();
+	if (!device_may_wakeup(priv->device)) {
+		rtnl_lock();
+		phylink_start(priv->phylink);
+		rtnl_unlock();
+	}
+
+	phylink_mac_change(priv->phylink, true);
 
 	mutex_unlock(&priv->lock);
 
-- 
2.7.4

