Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 832EEA50D5
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfIBIGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:06:09 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:60582 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfIBIGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:06:09 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id B6C9625B75F;
        Mon,  2 Sep 2019 18:06:07 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 6600C9405F1; Mon,  2 Sep 2019 10:06:05 +0200 (CEST)
From:   Simon Horman <horms+renesas@verge.net.au>
To:     David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [net-next 3/3] ravb: TROCR register is only present on R-Car Gen3
Date:   Mon,  2 Sep 2019 10:06:03 +0200
Message-Id: <20190902080603.5636-4-horms+renesas@verge.net.au>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190902080603.5636-1-horms+renesas@verge.net.au>
References: <20190902080603.5636-1-horms+renesas@verge.net.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only use the TROCR register on R-Car Gen3.
It is not present on other SoCs.

Offsets used for the undocumented registers are also considered reserved
and should not be written to.

After some internal investigation with Renesas it remains unclear why this
driver accesses these fields on R-Car Gen2 but regardless of what the
historical reasons are the current code is considered incorrect.

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/net/ethernet/renesas/ravb.h      | 2 +-
 drivers/net/ethernet/renesas/ravb_main.c | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index bdb051f04b0c..a9c89d5d8898 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -193,7 +193,7 @@ enum ravb_reg {
 	GECMR	= 0x05b0,
 	MAHR	= 0x05c0,
 	MALR	= 0x05c8,
-	TROCR	= 0x0700,	/* Undocumented? */
+	TROCR	= 0x0700,	/* R-Car Gen3 only */
 	CEFCR	= 0x0740,
 	FRECR	= 0x0748,
 	TSFRCR	= 0x0750,
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b538cc6fdbb7..de9aa8c47f1c 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1621,8 +1621,10 @@ static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
 	stats0 = &priv->stats[RAVB_BE];
 	stats1 = &priv->stats[RAVB_NC];
 
-	nstats->tx_dropped += ravb_read(ndev, TROCR);
-	ravb_write(ndev, 0, TROCR);	/* (write clear) */
+	if (priv->chip_id == RCAR_GEN3) {
+		nstats->tx_dropped += ravb_read(ndev, TROCR);
+		ravb_write(ndev, 0, TROCR);	/* (write clear) */
+	}
 
 	nstats->rx_packets = stats0->rx_packets + stats1->rx_packets;
 	nstats->tx_packets = stats0->tx_packets + stats1->tx_packets;
-- 
2.11.0

