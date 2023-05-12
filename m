Return-Path: <netdev+bounces-2133-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8366B700709
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FABB281B0C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAE62D527;
	Fri, 12 May 2023 11:42:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00ACD526
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:42:24 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ABA40E4
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 04:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683891742; x=1715427742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XDXqssspDlx1CZKD7QoPkrDzGhQjXfS3iAazDpslRt8=;
  b=NJlDL2MX8/86sdgKBDH3WeYks8RmmCi2cdoXfLlyyuTeQX4kgnqf6Yd+
   UxEfZg8Bvuaxldh0M99aTzkeGoA38281noujJEgFnfWU2lFAVoci8lLVk
   y4o55jx6Np/Jbd9mEAdYSq4kcw+GrNo4Q/4fd6EhCctvQHcZ5ch68SJmU
   pqE2J9HoMZ8f4SSidXAmUstUF5SD3wknpwUtrDR2m60eTJFYxH23zNPeX
   96aGM/DG1yjcorfTHkPA0v3SuF+JA8MuezBejbKNc9PogCKCsKDVdQ0/w
   gHAw/7dcjilLyHnB/ePkwkmMkKUdPAHIvWQtNDI5ve5HBpqRrKRN9DOQt
   w==;
X-IronPort-AV: E=Sophos;i="5.99,269,1677567600"; 
   d="scan'208";a="151722084"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 May 2023 04:42:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 12 May 2023 04:42:16 -0700
Received: from daire-X570.emdalo.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 12 May 2023 04:42:14 -0700
From: <daire.mcnamara@microchip.com>
To: <nicholas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <conor.dooley@microchip.com>
CC: Daire McNamara <daire.mcnamara@microchip.com>
Subject: [PATCH v3 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
Date: Fri, 12 May 2023 12:42:09 +0100
Message-ID: <20230512114209.2894459-2-daire.mcnamara@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230512114209.2894459-1-daire.mcnamara@microchip.com>
References: <20230512114209.2894459-1-daire.mcnamara@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Daire McNamara <daire.mcnamara@microchip.com>

On mpfs, with SRAM configured for 4 queues, setting max_tx_len
to GEM_TX_MAX_LEN=0x3f0 results multiple AMBA errors.
Setting max_tx_len to (4KiB - 56) removes those errors.

The details are described in erratum 1686 by Cadence

The max jumbo frame size is also reduced for mpfs to (4KiB - 56).

Signed-off-by: Daire McNamara <daire.mcnamara@microchip.com>
---
 drivers/net/ethernet/cadence/macb.h      |  1 +
 drivers/net/ethernet/cadence/macb_main.c | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

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
index 66e30561569e..4cabbcf28b7e 100644
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
@@ -4989,6 +4988,16 @@ static int macb_probe(struct platform_device *pdev)
 	if (macb_config)
 		bp->jumbo_max_len = macb_config->jumbo_max_len;
 
+	if (!hw_is_gem(bp->regs, bp->native_io)) {
+		bp->max_tx_length = MACB_MAX_TX_LEN;
+	}
+	else {
+		if (macb_config->max_tx_length)
+			bp->max_tx_length = macb_config->max_tx_length;
+		else
+			bp->max_tx_length = GEM_MAX_TX_LEN;
+	}
+
 	bp->wol = 0;
 	if (of_property_read_bool(np, "magic-packet"))
 		bp->wol |= MACB_WOL_HAS_MAGIC_PACKET;
-- 
2.25.1


