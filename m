Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDB43DD3AB
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 12:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhHBK14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 06:27:56 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:24468 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233220AbhHBK1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 06:27:55 -0400
X-IronPort-AV: E=Sophos;i="5.84,288,1620658800"; 
   d="scan'208";a="89548984"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 02 Aug 2021 19:27:45 +0900
Received: from localhost.localdomain (unknown [10.226.92.138])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 6006B4006DF1;
        Mon,  2 Aug 2021 19:27:39 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature to struct ravb_hw_info
Date:   Mon,  2 Aug 2021 11:26:53 +0100
Message-Id: <20210802102654.5996-8-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car Gen3 supports TX and RX clock internal delay modes, whereas R-Car
Gen2 and RZ/G2L do not support it.
Add an internal_delay hw feature bit to struct ravb_hw_info to enable this
only for R-Car Gen3.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
v2:
 * Incorporated Andrew and Sergei's review comments for making it smaller patch
   and provided detailed description.
---
 drivers/net/ethernet/renesas/ravb.h      | 3 +++
 drivers/net/ethernet/renesas/ravb_main.c | 6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 3df813b2e253..0d640dbe1eed 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -998,6 +998,9 @@ struct ravb_hw_info {
 	int num_tx_desc;
 	int stats_len;
 	size_t skb_sz;
+
+	/* hardware features */
+	unsigned internal_delay:1;	/* RAVB has internal delays */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 2ac962b5b8fb..02acae4d51c1 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1939,6 +1939,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.num_tx_desc = NUM_TX_DESC_GEN3,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.skb_sz = RX_BUF_SZ + RAVB_ALIGN - 1,
+	.internal_delay = 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
@@ -2189,7 +2190,7 @@ static int ravb_probe(struct platform_device *pdev)
 	/* Request GTI loading */
 	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
 
-	if (priv->chip_id != RCAR_GEN2) {
+	if (info->internal_delay) {
 		ravb_parse_delay_mode(np, ndev);
 		ravb_set_delay_mode(ndev);
 	}
@@ -2362,6 +2363,7 @@ static int __maybe_unused ravb_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	int ret = 0;
 
 	/* If WoL is enabled set reset mode to rearm the WoL logic */
@@ -2384,7 +2386,7 @@ static int __maybe_unused ravb_resume(struct device *dev)
 	/* Request GTI loading */
 	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
 
-	if (priv->chip_id != RCAR_GEN2)
+	if (info->internal_delay)
 		ravb_set_delay_mode(ndev);
 
 	/* Restore descriptor base address table */
-- 
2.17.1

