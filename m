Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6408A8447
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 15:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730442AbfIDNRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:17:17 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:33520 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729968AbfIDNRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:17:15 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7A880C5739;
        Wed,  4 Sep 2019 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567603034; bh=KCQxzNKdPciLpCzMYFXS00/1ZDMQ64xO5mQOdoiRlGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=LrQLnL9TNVB0sEP0RLSqKIC7mMIs7rPaXWeroMbywkEtXelwxhVPTgX4Wab2iqUIk
         KZdprBXxNC3GrTv1XIV4iX0YUDZMgVZpGAxlHlQRSaplxKK0kU9/LNg6VjR2r7uVoD
         Hcd8BBSD0EwmXvtatGjG7zvZP6GRWF/D2gdVxc5BO9pGIt6bAEfDj8rGsLjvVmM63S
         ujfnhRBXBs08Zn7Jmaxw/h+RBZTqYW+4/MhGCb16NFACF+UMvCMXXY7l/bkF3dXK2q
         HLtA8H81o9zNnMfq2ck/b3325Fa0CTyehjA1uRMmrbAVhbI/0zsr+l0t0fqoLo6KT+
         2jIU9NlNWKjvw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 3B957A0069;
        Wed,  4 Sep 2019 13:17:12 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 03/13] net: stmmac: Do not return error code in TC Initialization
Date:   Wed,  4 Sep 2019 15:16:55 +0200
Message-Id: <acfa0062f7bd087e3b80eaa87ff8dc1f058b5e61.1567602867.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567602867.git.joabreu@synopsys.com>
References: <cover.1567602867.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567602867.git.joabreu@synopsys.com>
References: <cover.1567602867.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we can still use the remaining TC callbacks, e.g. CBS. We should not
fail in the initialization only because RX Parser is not available.

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
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 6c305b6ecad0..8dbbbf181ada 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -243,8 +243,9 @@ static int tc_init(struct stmmac_priv *priv)
 	struct dma_features *dma_cap = &priv->dma_cap;
 	unsigned int count;
 
+	/* Fail silently as we can still use remaining features, e.g. CBS */
 	if (!dma_cap->frpsel)
-		return -EINVAL;
+		return 0;
 
 	switch (dma_cap->frpbs) {
 	case 0x0:
-- 
2.7.4

