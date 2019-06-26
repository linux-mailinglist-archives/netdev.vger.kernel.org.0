Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16BA656B27
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfFZNsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:48:24 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:51158 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727874AbfFZNry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:47:54 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BF812C0C4A;
        Wed, 26 Jun 2019 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561556874; bh=4l6pBzfPGy6jNgo8xtyf0X61O+IJMXBzqsk/z/+IUew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Zj1J+AJKWfWOI+1LRv2EQEHbEshppTRlKdOZ89eHBdYxhmgNckV7h9H10LH2ZQezf
         4nse/NG9Ez0DgGGdOvPoYFeXWTm5bTPGxbYzdY1AkOjMEvlry14OwVla1WLnRc+Jf1
         U6uKybGwR44MRHLAnRi2oXdZCgLLWpb8Xc+n0qMBTD6g/uSQ8AFyZUE/FdtNSm6/ZB
         Rwoh4h55v4BWSGHfpVLNalfiJAWabOUaFAyom/WpLbh1fMdp2Nqzl6Bi+rtcAk0aqQ
         u2+RSj6//lmKBxAkqBMWWD2a/AlvPT0AmHeo3dWzY2A1h9+CnnNfv51QY7jWRWnzZ0
         IAHZv0oaPeSRA==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id E8449A0065;
        Wed, 26 Jun 2019 13:47:51 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id B893E3B55D;
        Wed, 26 Jun 2019 15:47:51 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 02/10] net: stmmac: Do not try to enable PHY EEE if MAC does not support it
Date:   Wed, 26 Jun 2019 15:47:36 +0200
Message-Id: <bbcb80e32a9d3d78581b47b5835ed7df095ac6fb.1561556555.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561556555.git.joabreu@synopsys.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
In-Reply-To: <cover.1561556555.git.joabreu@synopsys.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
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
index f4593d2d9d20..fab65f129207 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -893,7 +893,7 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 
 	stmmac_mac_set(priv, priv->ioaddr, true);
-	if (phy) {
+	if (phy && priv->dma_cap.eee) {
 		priv->eee_active = phy_init_eee(phy, 1) >= 0;
 		priv->eee_enabled = stmmac_eee_init(priv);
 		stmmac_set_eee_pls(priv, priv->hw, true);
-- 
2.7.4

