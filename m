Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C004328CB
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhJRVMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232099AbhJRVMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:12:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 728D96112D;
        Mon, 18 Oct 2021 21:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634591418;
        bh=c2JsIaRCdmvyFUaVYhHMWG7nl+AdeV8MxmbCWwFtQMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqtaK9lYIdzTZrJshxlfit/WoezGDM4PBz3mG9o8c7ZCR1mKEdLUUlOMHepQc290e
         eUGJar/Ug2EUUJvUWZYY1FJmxnvNWU/p1D21LuwZKMc8J3IloqQbPOgNE5T0Gci8Rh
         8hoRPs4y2d5MENITmzFNOS1qEUm/KtiYaku78j5BHbsPV4qOwLnARnq8JkmE8YtVHM
         Se+zSJl5d3L8q0lHzbJ4CMl1DGaakMjgpSneXxDnqhzwrdQaxL9tL8Am2s7lNdx4Ew
         PfpMy7opDqtPrF2h0xeTbnwlHcV9QEliFeRiDMiRoc+YKxb/v01pSOVTkh8dxKg8Sp
         ZC5ENPa6cEeDQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/6] ethernet: ocelot: use eth_hw_addr_gen()
Date:   Mon, 18 Oct 2021 14:10:03 -0700
Message-Id: <20211018211007.1185777-3-kuba@kernel.org>
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
 drivers/net/ethernet/mscc/ocelot_net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 9992bf06311d..affa9649f490 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1705,8 +1705,7 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		NETIF_F_HW_TC;
 	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
 
-	eth_hw_addr_set(dev, ocelot->base_mac);
-	dev->dev_addr[ETH_ALEN - 1] += port;
+	eth_hw_addr_gen(dev, ocelot->base_mac, port);
 	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr,
 			  ocelot_port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
 
-- 
2.31.1

