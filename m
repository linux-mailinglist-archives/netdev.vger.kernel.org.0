Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E08B1B1F
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 11:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbfIMJuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 05:50:44 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:46496 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728767AbfIMJuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 05:50:44 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E309AC585C;
        Fri, 13 Sep 2019 09:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568368243; bh=VNT0CfKOWFVh9wUN9OsP/Ath/shvOWvuL7ZRZxtlnJs=;
        h=From:To:Cc:Subject:Date:From;
        b=Un9DyyRCSzZ+BtJTyFzXfYHYaMhQnX66hyzPJ7tJyO3pd2xg9j1D/PHFXEhvO5f5W
         B5XPmrkD7JgkRHonCx64A4E1kCItZjdmDai34ozetB9McFOfv/UOHJCRe5wxiCJ1fz
         PpKeWuXqH+z60IL+LxzK8zsh1VvfxPhWFJZZ5D5Iui9abpAXS5zgiXnusKjyiF4Sjg
         84Fp5+BGF900G5y+WhZPOLS7OkHRfZWZgerfgu+4P/d1Cd/KhrLRIos4rjmgb0Rqtk
         8WbcA9LfVEII3XRdjhhZZk3wy5rBsx/OqBoLVdwR+68KZTHBV25dUfBKd1f8P+tKRg
         1V5VWw+vXVoMQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id C1E27A0057;
        Fri, 13 Sep 2019 09:50:40 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Christophe ROULLIER <christophe.roullier@st.com>
Subject: [PATCH net] net: stmmac: Hold rtnl lock in suspend/resume callbacks
Date:   Fri, 13 Sep 2019 11:50:32 +0200
Message-Id: <66b6c1395e4bbc836e80083b89b2189ce7382d7b.1568360548.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to hold rnl lock in suspend and resume callbacks because phylink
requires it. Otherwise we will get a WARN() in suspend and resume.

Also, move phylink start and stop callbacks to inside device's internal
lock so that we prevent concurrent HW accesses.

Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
Reported-by: Christophe ROULLIER <christophe.roullier@st.com>
Tested-by: Christophe ROULLIER <christophe.roullier@st.com>
Signed-off-by: Jose Abreu <joabreu@synopsys.com>

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
Cc: Christophe ROULLIER <christophe.roullier@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index fd54c7c87485..b19ab09cb18f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4451,10 +4451,12 @@ int stmmac_suspend(struct device *dev)
 	if (!ndev || !netif_running(ndev))
 		return 0;
 
-	phylink_stop(priv->phylink);
-
 	mutex_lock(&priv->lock);
 
+	rtnl_lock();
+	phylink_stop(priv->phylink);
+	rtnl_unlock();
+
 	netif_device_detach(ndev);
 	stmmac_stop_all_queues(priv);
 
@@ -4558,9 +4560,11 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_start_all_queues(priv);
 
-	mutex_unlock(&priv->lock);
-
+	rtnl_lock();
 	phylink_start(priv->phylink);
+	rtnl_unlock();
+
+	mutex_unlock(&priv->lock);
 
 	return 0;
 }
-- 
2.7.4

