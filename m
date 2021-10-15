Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC5E42FC45
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 21:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242757AbhJOTlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 15:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242735AbhJOTlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 15:41:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92AE261184;
        Fri, 15 Oct 2021 19:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634326737;
        bh=NQPZO3xlK/8DUc/tkag5xIfXRZQVDAFc5TpDK14iX24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJokc9DF99UQH6YfKI91J+On8GEOxyMFBtpQFrDaRutEeFXYNCQFv/zrM2ayLNAPk
         hz6Vw7dtIo3ZcL/SXP0w/CBSnt933i3gZG7w/Q5SAyqvM2YnlpneSTlSCdnst6/6fk
         CrkBEpwJuzs6cpYtVZ03L4jyKQ71FrZdYWDuAQZORBPfzDDbb2mk4bxGEflPbd7GhC
         2BQywT5Y9l2x7wTBQzI8QrX/RsORBCuk2JOqIlN6/ygMogESNyh9BZwS8CX2kH1ugx
         TwRzFbjFOmQaRRRhdUkpDM99kGY8nyb6jtVmCMMUCK1UWDbGXxFL5cmwTrY4bCnm2R
         iICPm6WkmtcTg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Subject: [RFC net-next 2/6] ethernet: ocelot: use eth_hw_addr_set_port()
Date:   Fri, 15 Oct 2021 12:38:44 -0700
Message-Id: <20211015193848.779420-3-kuba@kernel.org>
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
CC: vladimir.oltean@nxp.com
CC: claudiu.manoil@nxp.com
CC: alexandre.belloni@bootlin.com
CC: UNGLinuxDriver@microchip.com
---
 drivers/net/ethernet/mscc/ocelot_net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 9992bf06311d..1e4459dfe016 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1705,8 +1705,7 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		NETIF_F_HW_TC;
 	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
 
-	eth_hw_addr_set(dev, ocelot->base_mac);
-	dev->dev_addr[ETH_ALEN - 1] += port;
+	eth_hw_addr_set_port(dev, ocelot->base_mac, port);
 	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr,
 			  ocelot_port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
 
-- 
2.31.1

