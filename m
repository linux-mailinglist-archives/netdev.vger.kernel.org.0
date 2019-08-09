Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1750A882B0
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436838AbfHISgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:36:51 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:38432 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407113AbfHISgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:36:31 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8B469C0AC5
        for <netdev@vger.kernel.org>; Fri,  9 Aug 2019 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565375790; bh=fLeV8TJwppF4ZFeahoFrFlbTuhe7GWYIdB+X0bxLXSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=VoHecGme0tmp48QvFgdyE1wujppDK4Q0PJ8H92pxEA8PNqJueTQQSXM98Pc267NDR
         9KqS8qg9lSZ+o9aggFSWc7HyIkJSy14X5HdHthkcQcr7aRipRq7RYqT8UYissBAEn1
         ugQ2fm+prFV3ZcY8bW5g+UyVIrNveOT0y+uM3rZpRMnmFu/oDDQ1CfBlhdfoSJKsmU
         dpHUsreLTZ9KDIfBPIwFTzJ4QtYGsvTrxHFcnMfNZAdDWnFFcTsIbguV1UfqytbDwy
         +OY9DTF7IKMsZUjiwsBLh6el4fC9P5pafdCuIbeDFN7ZENTUv9KWTCqKMwjL5ax4z8
         hfWJSOcsv4GyQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 53A3AA006A;
        Fri,  9 Aug 2019 18:36:29 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH net-next 05/12] net: stmmac: Add a counter for Split Header packets
Date:   Fri,  9 Aug 2019 20:36:13 +0200
Message-Id: <6ba771d08ed41f09340edbfac734a35f1536356d.1565375521.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565375521.git.joabreu@synopsys.com>
References: <cover.1565375521.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565375521.git.joabreu@synopsys.com>
References: <cover.1565375521.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a counter that increments each time a packet with split header is
received.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h         | 1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 527f961579f4..1303ec81fd3d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -75,6 +75,7 @@ struct stmmac_extra_stats {
 	unsigned long rx_missed_cntr;
 	unsigned long rx_overflow_cntr;
 	unsigned long rx_vlan;
+	unsigned long rx_split_hdr_pkt_n;
 	/* Tx/Rx IRQ error info */
 	unsigned long tx_undeflow_irq;
 	unsigned long tx_process_stopped_irq;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 2423160ab582..eb784fdb6d32 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -65,6 +65,7 @@ static const struct stmmac_stats stmmac_gstrings_stats[] = {
 	STMMAC_STAT(rx_missed_cntr),
 	STMMAC_STAT(rx_overflow_cntr),
 	STMMAC_STAT(rx_vlan),
+	STMMAC_STAT(rx_split_hdr_pkt_n),
 	/* Tx/Rx IRQ error info */
 	STMMAC_STAT(tx_undeflow_irq),
 	STMMAC_STAT(tx_process_stopped_irq),
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 61f67cd34f21..e74c1d822aaa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3498,6 +3498,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 				if (!(status & rx_not_ls))
 					sec_len = sec_len - hlen;
 				len = hlen;
+
+				priv->xstats.rx_split_hdr_pkt_n++;
 			}
 
 			skb = netdev_alloc_skb_ip_align(priv->dev, len);
-- 
2.7.4

