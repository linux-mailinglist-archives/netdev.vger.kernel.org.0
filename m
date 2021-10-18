Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E10A431FAF
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbhJROcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232091AbhJROcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:32:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5D4A6103D;
        Mon, 18 Oct 2021 14:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634567389;
        bh=rxYtqshRFC/rSplWmHqaWKR8gFnDOHB5OS/vJvQB7hU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTyDt7v1tJEtOc/cACuhOy7q9YBErgB8EcRMkppt78/GDQVRaouCjunzlMIpDmmS6
         uJp6+oViMnLIVc1P8H6yZwDCLarqizOzjxB3LUGdXVuen0A6dYNOrROGT3Qi84iKDb
         0ZCWjinJZWoPywtJj2IyeLvbBTQHIFn3+Gv1aQzFVzqWqo9DuIUve2Mb+kmn8l/vil
         eURn4bIipMTGMTxbtyopzVSTwt0KD/rEZgZUhkhCJN22nVDV6nWr3pLkWf6GdQ1ZOH
         Ny7PGGPtTQuE6GuDn2ncOMAyArKhflrxKmYORz60At1nyuLgtQPgSD+csBxvqqEvcT
         Q/1uvEYT/dOJA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        vz@mleia.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 03/12] ethernet: lpc: use eth_hw_addr_set()
Date:   Mon, 18 Oct 2021 07:29:23 -0700
Message-Id: <20211018142932.1000613-4-kuba@kernel.org>
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
CC: vz@mleia.com
CC: linux-arm-kernel@lists.infradead.org
---
 drivers/net/ethernet/nxp/lpc_eth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index fbfbf94e0377..a63cc295b979 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1232,6 +1232,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	struct net_device *ndev;
 	dma_addr_t dma_handle;
 	struct resource *res;
+	u8 addr[ETH_ALEN];
 	int irq, ret;
 
 	/* Setup network interface for RMII or MII mode */
@@ -1347,7 +1348,8 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	pldat->phy_node = of_parse_phandle(np, "phy-handle", 0);
 
 	/* Get MAC address from current HW setting (POR state is all zeros) */
-	__lpc_get_mac(pldat, ndev->dev_addr);
+	__lpc_get_mac(pldat, addr);
+	eth_hw_addr_set(ndev, addr);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		of_get_ethdev_address(np, ndev);
-- 
2.31.1

