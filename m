Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAE5594F9
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfF1HaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 03:30:25 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:48008 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726487AbfF1H3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:29:25 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0E648C0BE7;
        Fri, 28 Jun 2019 07:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561706965; bh=T/v9qNg4Ea5YnUG0pF/CIGM3MDN8hJrd0wVcTI+mB0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=NM/aGwyDx5NN05K01id1c/FHjC5UUiHkcJ7ZCVlL7N4NP4mTXSeoYiiW2CKfxcUDn
         RFJ8ytdFnIYTkA8uGlXFGav9Nbce4ub+PmceRwv3W/W0AF5c/aa5jKdqYpyQkestgE
         wF7jGbcUoppocni2zsjzwb7ShHRjm5v5HOnP1p0fQ0qpr6mLykfSZ/vWQ4gpt0YCwc
         0JgGVK4mwGEcFXl6Pxz+dyNVUNPzSRpu8KOdrFHVIZ/XweTSD8gg1I+KdzKoGDvUWx
         a3MSgAolrKaQA4slTGyUn7pB81H+rJ3Vyw0CV28ptiaQvQH1eI9A06BG3Y25lQAZHS
         ALCxde8gZ4kbg==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 7A4BDA022F;
        Fri, 28 Jun 2019 07:29:23 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 6473C3E949;
        Fri, 28 Jun 2019 09:29:23 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 02/10] net: stmmac: Do not try to enable PHY EEE if MAC does not support it
Date:   Fri, 28 Jun 2019 09:29:13 +0200
Message-Id: <11ce47fad073cb45254d779e7338446f03edb2c0.1561706801.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not enable EEE feature in the PHY if MAC does not support it.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 91f24b63ea16..0b1900bf4e9e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -896,7 +896,7 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 
 	stmmac_mac_set(priv, priv->ioaddr, true);
-	if (phy) {
+	if (phy && priv->dma_cap.eee) {
 		priv->eee_active = phy_init_eee(phy, 1) >= 0;
 		priv->eee_enabled = stmmac_eee_init(priv);
 		stmmac_set_eee_pls(priv, priv->hw, true);
-- 
2.7.4

