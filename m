Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BE64328CD
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhJRVMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232545AbhJRVMc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:12:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AF7D60FC3;
        Mon, 18 Oct 2021 21:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634591420;
        bh=j6kDwZb9t7Mb2ggxAZzllHjr38pFKLpEfd25hHxYlBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQw5Ciljfiko+c7/7bWO84+f/S0mcsvc1QqpOc6en6ceXcBRbQ7s2NSXa+bRzzMxy
         BKR6JkVV78e2j/iCCKihu8taGA2+KY8Grl1OO8RUXqRBv7Xwxb4s7g/7SuLPm6covo
         lZBBQEwUm+sQaIPjeSakAjlF4QIe6QvC8gFCj1OnCSGCpGxQEYLP7CW38TaJtesaCw
         LZim/Va1Gc9LM2tjlTGIMTFS6wjrIwehJU6aheTi99A+830bVoAkk9q7i0R6Nc6/cG
         n/YjRrOW+IilC9KiJhueXlTfLAy3PHICKEaszUJXaruikIBmbXEUf8O69/CCsx4K0Q
         I2fluAvGaPyjQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/6] ethernet: sparx5: use eth_hw_addr_gen()
Date:   Mon, 18 Oct 2021 14:10:07 -0700
Message-Id: <20211018211007.1185777-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018211007.1185777-1-kuba@kernel.org>
References: <20211018211007.1185777-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index b21ebaa32d7e..e042f117dc7a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -200,7 +200,6 @@ struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
 {
 	struct sparx5_port *spx5_port;
 	struct net_device *ndev;
-	u64 val;
 
 	ndev = devm_alloc_etherdev(sparx5->dev, sizeof(struct sparx5_port));
 	if (!ndev)
@@ -216,8 +215,7 @@ struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
 	ndev->netdev_ops = &sparx5_port_netdev_ops;
 	ndev->ethtool_ops = &sparx5_ethtool_ops;
 
-	val = ether_addr_to_u64(sparx5->base_mac) + portno + 1;
-	u64_to_ether_addr(val, ndev->dev_addr);
+	eth_hw_addr_gen(ndev, sparx5->base_mac, portno + 1);
 
 	return ndev;
 }
-- 
2.31.1

