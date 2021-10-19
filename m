Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C2843397D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhJSPCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233046AbhJSPCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FAED61175;
        Tue, 19 Oct 2021 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634655618;
        bh=4rfkTexNqA3QcHsJYu/4uKzSLEHA8UvTplZVI9VxCVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7iSR/kbMH8Ycee4zCqPy9qmQAbLlb2+fxG0laerL/HT+4QKw1nGwawuXd3E8ojWQ
         hTBadMZk7fAx06rIulAnZuxteHzIqdNIPkl40gt1eyXF9U0ZcL29dEIiMLge4lkoaV
         jyiTq8umrvlxWdqREFFLqalyIf7DMCI9fVZb3VHX4PyWVSyTWmIfS++M64CknWiS2O
         VCe4AH25m+qkG8hJTbNBPtW3muFVwaBew7Iq/x0DQsrtntRi5n8kfDvN2zDrVfjwOJ
         tx5M8EIpuWCQpAgNSSH3srpKCMSuz4jIs9NDfggz6OXNBvhfB/WcaO+LeIh6KUcUJv
         JvYIdiH/KcA0g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 2/6] ethernet: stmmac: use eth_hw_addr_set()
Date:   Tue, 19 Oct 2021 08:00:07 -0700
Message-Id: <20211019150011.1355755-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019150011.1355755-1-kuba@kernel.org>
References: <20211019150011.1355755-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Read the address into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: peppe.cavallaro@st.com
CC: alexandre.torgue@foss.st.com
CC: joabreu@synopsys.com
CC: mcoquelin.stm32@gmail.com
CC: linux-stm32@st-md-mailman.stormreply.com
CC: linux-arm-kernel@lists.infradead.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b720539ccb0a..88d3053d2f87 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2818,9 +2818,13 @@ static int stmmac_get_hw_features(struct stmmac_priv *priv)
  */
 static void stmmac_check_ether_addr(struct stmmac_priv *priv)
 {
+	u8 addr[ETH_ALEN];
+
 	if (!is_valid_ether_addr(priv->dev->dev_addr)) {
-		stmmac_get_umac_addr(priv, priv->hw, priv->dev->dev_addr, 0);
-		if (!is_valid_ether_addr(priv->dev->dev_addr))
+		stmmac_get_umac_addr(priv, priv->hw, addr, 0);
+		if (is_valid_ether_addr(addr))
+			eth_hw_addr_set(priv->dev, addr);
+		else
 			eth_hw_addr_random(priv->dev);
 		dev_info(priv->device, "device MAC address %pM\n",
 			 priv->dev->dev_addr);
-- 
2.31.1

