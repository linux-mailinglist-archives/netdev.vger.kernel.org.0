Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C523313710F
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgAJPX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:23:58 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:56110 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728184AbgAJPX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:23:58 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 746F140614;
        Fri, 10 Jan 2020 15:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578669837; bh=J4+ntHbWrqFDN3ykef1qvG1EDza6rRkVc0EblLQVWPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=KY5gMXxQulNzPxL5YMgmY4Ty5ZaSYheKGArANQX/m7+c9/OGiOCumvYhJQRJohMz8
         J8F08kGd5NqX5HPACSH++pbwo0VQrcSWPdIENRIQa7NS37Z6DznunJ3e+UZ857aU+e
         z5dKfRc5HEXkwndRe7GyEDMj7ZyQKlr9b1QgfkKZiN9PjpCSSG/3M9nyz1qAeVMTwH
         QgdFVuJjiI18hGnDaAXRZuTacIUB7ujkAfMD4O9r+873d9Nbmu5IShyWxkYRaymEO7
         Dx2yJT96ymwNWZ3M9MQwHLrMJNkOUMs93UEGiEdJngiGaueNPMkDZwXKfIKf2NH06g
         JGr10rTdRqZrw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 450BFA0066;
        Fri, 10 Jan 2020 15:23:56 +0000 (UTC)
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
Subject: [PATCH net 1/2] net: stmmac: selftests: Update status when disabling RSS
Date:   Fri, 10 Jan 2020 16:23:52 +0100
Message-Id: <42050d75f00900b715a277bbc1d9abf437f6ea68.1578669661.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578669661.git.Jose.Abreu@synopsys.com>
References: <cover.1578669661.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578669661.git.Jose.Abreu@synopsys.com>
References: <cover.1578669661.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are disabling RSS on HW but not updating the internal private status
to the 'disabled' state. This is needed for next tc commit that will
check if RSS is disabled before trying to apply filters.

Fixes: 4647e021193d ("net: stmmac: selftests: Add selftest for L3/L4 Filters")
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
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c   | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 13227909287c..36a4c43a799a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1323,16 +1323,19 @@ static int __stmmac_test_l3filt(struct stmmac_priv *priv, u32 dst, u32 src,
 	struct stmmac_packet_attrs attr = { };
 	struct flow_dissector *dissector;
 	struct flow_cls_offload *cls;
+	int ret, old_enable = 0;
 	struct flow_rule *rule;
-	int ret;
 
 	if (!tc_can_offload(priv->dev))
 		return -EOPNOTSUPP;
 	if (!priv->dma_cap.l3l4fnum)
 		return -EOPNOTSUPP;
-	if (priv->rss.enable)
+	if (priv->rss.enable) {
+		old_enable = priv->rss.enable;
+		priv->rss.enable = false;
 		stmmac_rss_configure(priv, priv->hw, NULL,
 				     priv->plat->rx_queues_to_use);
+	}
 
 	dissector = kzalloc(sizeof(*dissector), GFP_KERNEL);
 	if (!dissector) {
@@ -1399,7 +1402,8 @@ static int __stmmac_test_l3filt(struct stmmac_priv *priv, u32 dst, u32 src,
 cleanup_dissector:
 	kfree(dissector);
 cleanup_rss:
-	if (priv->rss.enable) {
+	if (old_enable) {
+		priv->rss.enable = old_enable;
 		stmmac_rss_configure(priv, priv->hw, &priv->rss,
 				     priv->plat->rx_queues_to_use);
 	}
@@ -1444,16 +1448,19 @@ static int __stmmac_test_l4filt(struct stmmac_priv *priv, u32 dst, u32 src,
 	struct stmmac_packet_attrs attr = { };
 	struct flow_dissector *dissector;
 	struct flow_cls_offload *cls;
+	int ret, old_enable = 0;
 	struct flow_rule *rule;
-	int ret;
 
 	if (!tc_can_offload(priv->dev))
 		return -EOPNOTSUPP;
 	if (!priv->dma_cap.l3l4fnum)
 		return -EOPNOTSUPP;
-	if (priv->rss.enable)
+	if (priv->rss.enable) {
+		old_enable = priv->rss.enable;
+		priv->rss.enable = false;
 		stmmac_rss_configure(priv, priv->hw, NULL,
 				     priv->plat->rx_queues_to_use);
+	}
 
 	dissector = kzalloc(sizeof(*dissector), GFP_KERNEL);
 	if (!dissector) {
@@ -1525,7 +1532,8 @@ static int __stmmac_test_l4filt(struct stmmac_priv *priv, u32 dst, u32 src,
 cleanup_dissector:
 	kfree(dissector);
 cleanup_rss:
-	if (priv->rss.enable) {
+	if (old_enable) {
+		priv->rss.enable = old_enable;
 		stmmac_rss_configure(priv, priv->hw, &priv->rss,
 				     priv->plat->rx_queues_to_use);
 	}
-- 
2.7.4

