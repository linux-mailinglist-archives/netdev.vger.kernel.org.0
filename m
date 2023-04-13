Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019A46E13DA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 20:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjDMSDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 14:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDMSDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 14:03:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA8B1735
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 11:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681409029; x=1712945029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VDnZuK6d+P6mlT1oz55prNIjH45Qyb7LqpLmmqViqDI=;
  b=sLHinv6TDzmoIo8/C7C533qwjwnvyBRKCKToukyb7lO/0kCIsskL3iMl
   CruimgOURXqLpsV2rZUfyJi2wcHN/WwvF7ZHSpXn5zvI0V+ir/JSwhtN9
   ckqLLRauam1UWbDWk/ZYf8CVeANPO6zqJ49qnjTfaH7ShGNC0XGZLqt4N
   uRnevBYOE6Z3GUJ3h2Bme5vENv4FraWWFFsMl6walS1F3X/IrwRjHl1Jm
   ihR298Np4ztKmiNWaY2gZlkZ1sIpbeaxbqdH3uG0lEPdXlLnfiZlhrWBX
   HVf7JQ4iS707s44tC6PrfWE1UjZvnaPf51FGt12w25ZcNHp1NM0qRv1Zw
   A==;
X-IronPort-AV: E=Sophos;i="5.99,194,1677567600"; 
   d="scan'208";a="210327677"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Apr 2023 11:03:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 13 Apr 2023 11:03:44 -0700
Received: from daire-X570.emdalo.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Thu, 13 Apr 2023 11:03:42 -0700
From:   <daire.mcnamara@microchip.com>
To:     <nicholas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <conor.dooley@microchip.com>
CC:     Daire McNamara <daire.mcnamara@microchip.com>
Subject: [PATCH v1 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
Date:   Thu, 13 Apr 2023 19:03:37 +0100
Message-ID: <20230413180337.1399614-2-daire.mcnamara@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230413180337.1399614-1-daire.mcnamara@microchip.com>
References: <20230413180337.1399614-1-daire.mcnamara@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daire McNamara <daire.mcnamara@microchip.com>

On mpfs, with SRAM configured for 4 queues, setting max_tx_len
to GEM_TX_MAX_LEN=0x3f0 results multiple AMBA errors.
Setting max_tx_len to (4KiB - 56) removes those errors.

The details are described in erratum 1686 by Cadence

The max jumbo frame size is also reduced for mpfs to (4KiB - 56).

Signed-off-by: Daire McNamara <daire.mcnamara@microchip.com>
---
 drivers/net/ethernet/cadence/macb.h      |  1 +
 drivers/net/ethernet/cadence/macb_main.c | 16 ++++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 14dfec4db8f9..989e7c5db9b9 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1175,6 +1175,7 @@ struct macb_config {
 			    struct clk **hclk, struct clk **tx_clk,
 			    struct clk **rx_clk, struct clk **tsu_clk);
 	int	(*init)(struct platform_device *pdev);
+	unsigned int		max_tx_length;
 	int	jumbo_max_len;
 	const struct macb_usrio_config *usrio;
 };
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 66e30561569e..1f362bbc360f 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4095,14 +4095,12 @@ static int macb_init(struct platform_device *pdev)
 
 	/* setup appropriated routines according to adapter type */
 	if (macb_is_gem(bp)) {
-		bp->max_tx_length = GEM_MAX_TX_LEN;
 		bp->macbgem_ops.mog_alloc_rx_buffers = gem_alloc_rx_buffers;
 		bp->macbgem_ops.mog_free_rx_buffers = gem_free_rx_buffers;
 		bp->macbgem_ops.mog_init_rings = gem_init_rings;
 		bp->macbgem_ops.mog_rx = gem_rx;
 		dev->ethtool_ops = &gem_ethtool_ops;
 	} else {
-		bp->max_tx_length = MACB_MAX_TX_LEN;
 		bp->macbgem_ops.mog_alloc_rx_buffers = macb_alloc_rx_buffers;
 		bp->macbgem_ops.mog_free_rx_buffers = macb_free_rx_buffers;
 		bp->macbgem_ops.mog_init_rings = macb_init_rings;
@@ -4839,7 +4837,8 @@ static const struct macb_config mpfs_config = {
 	.clk_init = macb_clk_init,
 	.init = init_reset_optional,
 	.usrio = &macb_default_usrio,
-	.jumbo_max_len = 10240,
+	.max_tx_length = 4040, /* Cadence Erratum 1686 */
+	.jumbo_max_len = 4040,
 };
 
 static const struct macb_config sama7g5_gem_config = {
@@ -4986,8 +4985,17 @@ static int macb_probe(struct platform_device *pdev)
 	bp->tx_clk = tx_clk;
 	bp->rx_clk = rx_clk;
 	bp->tsu_clk = tsu_clk;
-	if (macb_config)
+	if (macb_config) {
+		if (macb_is_gem(bp)) {
+			if (macb_config->max_tx_length)
+				bp->max_tx_length = macb_config->max_tx_length;
+			else
+				bp->max_tx_length = GEM_MAX_TX_LEN;
+		} else {
+			bp->max_tx_length = MACB_MAX_TX_LEN;
+		}
 		bp->jumbo_max_len = macb_config->jumbo_max_len;
+	}
 
 	bp->wol = 0;
 	if (of_property_read_bool(np, "magic-packet"))
-- 
2.25.1

