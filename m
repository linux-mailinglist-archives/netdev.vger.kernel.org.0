Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1849431FB5
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhJROcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232249AbhJROcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B91F6128A;
        Mon, 18 Oct 2021 14:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634567390;
        bh=2Y1pwAEyftLFONwOZjgT223Is6PNUMkUR1M7O+5W7K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQN3DT6k5/JBDlITJFOgWqkqmpUvm0T2KQqtRxQ9wihzUHI1U++3Z1FJZ5okSl/DE
         IE0WpKK78ccW+nUyHQ1A6CdyBgZLLtyQYlVpK1LFnn4sFZQebdaJAmq476CAJYIJUF
         Pk3jz7DIKicPIYK22REX1xvA1oAs3gJQsdUMG7XHblAFqSkeTrZJuLnRVMAU4Adh03
         bKtCUp67On1eIad1fII4sZ5/ke3vGuASilM4CDEYRGc8NNnv2wCOM2z6Iki2SkZMDw
         ZouOS/PbthPnmhO6ZbfX8xd/EGToGhCpVSgIkmfS9pa4jGUhnWFxlZomPvy2/RAoVj
         a4IT+BrC+tjWA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        bh74.an@samsung.com
Subject: [PATCH net-next 08/12] ethernet: sxgbe: use eth_hw_addr_set()
Date:   Mon, 18 Oct 2021 07:29:28 -0700
Message-Id: <20211018142932.1000613-9-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018142932.1000613-1-kuba@kernel.org>
References: <20211018142932.1000613-1-kuba@kernel.org>
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
CC: bh74.an@samsung.com
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 6781aa636d58..32161a56726c 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -931,10 +931,13 @@ static int sxgbe_get_hw_features(struct sxgbe_priv_data * const priv)
 static void sxgbe_check_ether_addr(struct sxgbe_priv_data *priv)
 {
 	if (!is_valid_ether_addr(priv->dev->dev_addr)) {
+		u8 addr[ETH_ALEN];
+
 		priv->hw->mac->get_umac_addr((void __iomem *)
-					     priv->ioaddr,
-					     priv->dev->dev_addr, 0);
-		if (!is_valid_ether_addr(priv->dev->dev_addr))
+					     priv->ioaddr, addr, 0);
+		if (is_valid_ether_addr(addr))
+			eth_hw_addr_set(priv->dev, addr);
+		else
 			eth_hw_addr_random(priv->dev);
 	}
 	dev_info(priv->device, "device MAC address %pM\n",
-- 
2.31.1

