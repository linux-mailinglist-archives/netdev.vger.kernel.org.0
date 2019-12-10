Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C171190B9
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfLJTee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:34:34 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:44128 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726689AbfLJTeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:34:08 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 46D8DC0BAE;
        Tue, 10 Dec 2019 19:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576006448; bh=h/CjT0nniLwD8021Mvebnoqg8LgNjSOmOhHnz7vKuzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=B10lF3eUJD81W2sL6qyW2Wen8W35x/EGOaa32JSlnXAF+7Zmaa2pmdgJN3hvdqemH
         f0uojvR3GTEaK6tRc+Uh5BoVv9lu6Po8Hx1QZS52NDF1jbb5NnCvf+0rHkkr1stzFu
         sxERtMR5yA2x3aMfjVGkhyqYf+ho518sWNlYHrVfDAXVZt8mQNulSIgH5HQqeqNGQY
         JH8YuM61WDViC0e8BNA0jH0zvGKOG0PCzxpH4ph3ShwtHhVecMe7V58M/yjIOTu8LQ
         vsVGx1917i9/YZYm8ny2DSXTu49xbgmtn4uG7Da5jWpVQt9V9zlF8b5v88CO5IAHQk
         Mr9CqZ8qEP/8g==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id C498FA0089;
        Tue, 10 Dec 2019 19:34:05 +0000 (UTC)
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
Subject: [PATCH net 1/8] net: stmmac: selftests: Needs to check the number of Multicast regs
Date:   Tue, 10 Dec 2019 20:33:53 +0100
Message-Id: <7e123ba7db1e4913c93dc0d8c9e3061fad27083d.1576005975.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576005975.git.Jose.Abreu@synopsys.com>
References: <cover.1576005975.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576005975.git.Jose.Abreu@synopsys.com>
References: <cover.1576005975.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running the MC and UC filter tests we setup a multicast address
that its expected to be blocked. If the number of available multicast
registers is zero, driver will always pass the multicast packets which
will fail the test.

Check if available multicast addresses is enough before running the
tests.

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index f3d8b9336b8e..13227909287c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -624,6 +624,8 @@ static int stmmac_test_mcfilt(struct stmmac_priv *priv)
 		return -EOPNOTSUPP;
 	if (netdev_uc_count(priv->dev) >= priv->hw->unicast_filter_entries)
 		return -EOPNOTSUPP;
+	if (netdev_mc_count(priv->dev) >= priv->hw->multicast_filter_bins)
+		return -EOPNOTSUPP;
 
 	while (--tries) {
 		/* We only need to check the mc_addr for collisions */
@@ -666,6 +668,8 @@ static int stmmac_test_ucfilt(struct stmmac_priv *priv)
 
 	if (stmmac_filter_check(priv))
 		return -EOPNOTSUPP;
+	if (netdev_uc_count(priv->dev) >= priv->hw->unicast_filter_entries)
+		return -EOPNOTSUPP;
 	if (netdev_mc_count(priv->dev) >= priv->hw->multicast_filter_bins)
 		return -EOPNOTSUPP;
 
-- 
2.7.4

