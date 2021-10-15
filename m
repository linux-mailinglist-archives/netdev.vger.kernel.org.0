Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C21342FC4A
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 21:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242746AbhJOTlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 15:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242755AbhJOTlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 15:41:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61E23611CE;
        Fri, 15 Oct 2021 19:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634326738;
        bh=6uFO95BN/xrQKbOn4Vvtf8HObXa+wJ7r9KR4eAFX2r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UlOcikDPQK5qOHLPoXnMhure6248BRumpYf0PLp8bMfsoEhY6E2rsJIkXpsSXGk3l
         qFs04zTRQL9CD8PFmz2jewJDVxZNEsZ4nB2xt7eI6a3CgXSo0F88TWaFg+xfKp3V+f
         rIzf1SwoFL7OZEI5qGmnK+W//KUejsRpk4D3cRwyQaMwjRaGNHA+3QJ/EUGtrmsIHz
         /4SfCDfx4v5LUn5HceJ/18KZtujDEYkeasSAJSlSPjEIblcZECRLgIIgeKGR8iJKED
         NHWMlYtLjb4sWetcRfwuNv5lIZxa6XwCKI/YCPFf9Rwn3qIYpw9iRLhsA5Z2Hqq9ay
         wFgssf2X8Z7Tg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, bjarni.jonasson@microchip.com,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC net-next 6/6] ethernet: sparx5: use eth_hw_addr_set_port()
Date:   Fri, 15 Oct 2021 12:38:48 -0700
Message-Id: <20211015193848.779420-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015193848.779420-1-kuba@kernel.org>
References: <20211015193848.779420-1-kuba@kernel.org>
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
CC: lars.povlsen@microchip.com
CC: Steen.Hegelund@microchip.com
CC: UNGLinuxDriver@microchip.com
CC: bjarni.jonasson@microchip.com
CC: linux-arm-kernel@lists.infradead.org
---
 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index b21ebaa32d7e..d56822f6d09e 100644
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
+	eth_hw_addr_set_port(ndev, sparx5->base_mac, portno + 1);
 
 	return ndev;
 }
-- 
2.31.1

