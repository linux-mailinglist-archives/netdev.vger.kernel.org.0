Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20ABAB365
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392574AbfIFHla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:41:30 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:33322 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391062AbfIFHl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 03:41:29 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 542E7C0E3F;
        Fri,  6 Sep 2019 07:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567755688; bh=PPN655geEk93zxgKDoKCmCCtqNmGhdnuRq0oF4It5O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=d99qkytPcmwlzrst7u/DLYo0N5+MwF8KX1avousmvwlQAN5bjxJ51z1CpgXU/y+p5
         6BqozjwF2QL7LIq5wOBVDiLlNoyWBiHrTdSpaF7biaL5LIbxwFsDzm4OO1iuW6G9ya
         QbhxGoGCtNLVqPNcH4oRfvAwV8kbuf8AX4tF3NnWBaOuAsMPszxgvWzJluhFMMbUM4
         LCWBT53ryDF5RN6bp2ecfBL35ha8InUa0yxv2xU+POY7l/400joHVhMHpwRmklPpJf
         6ystkU7/f7dimbkYjYmuq2fJ8UkUVQ7LvrGOoUuhCcyZiqOxW6LXkHEhgzuPkmgQA0
         /h/XGOp0BZnWg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 03710A006D;
        Fri,  6 Sep 2019 07:41:27 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: stmmac: Limit max speeds of XGMAC if asked to
Date:   Fri,  6 Sep 2019 09:41:17 +0200
Message-Id: <151c0529f0c698e94b81bee44d4f1d0a3379cab2.1567755423.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567755423.git.joabreu@synopsys.com>
References: <cover.1567755423.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567755423.git.joabreu@synopsys.com>
References: <cover.1567755423.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We may have some SoCs that can't achieve XGMAC max speed. Limit it if
asked to.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 25 +++++++++++++++--------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c3baca9f587b..686b82068142 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -831,15 +831,22 @@ static void stmmac_validate(struct phylink_config *config,
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseX_Full);
 	} else if (priv->plat->has_xgmac) {
-		phylink_set(mac_supported, 2500baseT_Full);
-		phylink_set(mac_supported, 5000baseT_Full);
-		phylink_set(mac_supported, 10000baseSR_Full);
-		phylink_set(mac_supported, 10000baseLR_Full);
-		phylink_set(mac_supported, 10000baseER_Full);
-		phylink_set(mac_supported, 10000baseLRM_Full);
-		phylink_set(mac_supported, 10000baseT_Full);
-		phylink_set(mac_supported, 10000baseKX4_Full);
-		phylink_set(mac_supported, 10000baseKR_Full);
+		if (!max_speed || (max_speed >= 2500)) {
+			phylink_set(mac_supported, 2500baseT_Full);
+			phylink_set(mac_supported, 2500baseX_Full);
+		}
+		if (!max_speed || (max_speed >= 5000)) {
+			phylink_set(mac_supported, 5000baseT_Full);
+		}
+		if (!max_speed || (max_speed >= 10000)) {
+			phylink_set(mac_supported, 10000baseSR_Full);
+			phylink_set(mac_supported, 10000baseLR_Full);
+			phylink_set(mac_supported, 10000baseER_Full);
+			phylink_set(mac_supported, 10000baseLRM_Full);
+			phylink_set(mac_supported, 10000baseT_Full);
+			phylink_set(mac_supported, 10000baseKX4_Full);
+			phylink_set(mac_supported, 10000baseKR_Full);
+		}
 	}
 
 	/* Half-Duplex can only work with single queue */
-- 
2.7.4

