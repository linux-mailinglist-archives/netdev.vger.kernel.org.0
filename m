Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B64D6BACAB
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjCOJww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbjCOJw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:52:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9D960AA4;
        Wed, 15 Mar 2023 02:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678873878; x=1710409878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nfbCz9FTpMLY06ZI7/EfisAD7xlhHf8Ry0R/DcJAXtY=;
  b=xvHEiAmqcN8LY5/iNDLuEYovGcW6PKAbsGcku+1mN6V09f7kFscYqp6w
   yZBMqvNHXll+H6oRbVzsOBVmv0PHTdVmVWTCuLTtFvZQ4p2uGpb7X8/49
   i3P080MVoqpfEPd+soc7x+HaUMAfOD8mQijsReEOaR2vZQ4c4ft5eRRug
   VRqZBlJu0NyuAvLuksCUZQ7YzjBLgNUynyLn8qiEhQx2tm+8nk/apgIr0
   9JAcmCag5J5BPVz8IjCYP74/neukSi/p570hgpkv56OOX/N3wkhSWHEe+
   xy3iQgWhk69KMqGgyoOjH6bsS4a7AsO2U7F0kL39374LgdWovqRBA+WoV
   A==;
X-IronPort-AV: E=Sophos;i="5.98,262,1673938800"; 
   d="scan'208";a="204854133"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Mar 2023 02:51:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 02:51:17 -0700
Received: from che-lt-i66125lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 02:51:10 -0700
From:   Durai Manickam KR <durai.manickamkr@microchip.com>
To:     <Hari.PrasathGE@microchip.com>,
        <balamanikandan.gunasundar@microchip.com>,
        <manikandan.m@microchip.com>, <varshini.rajendran@microchip.com>,
        <dharma.b@microchip.com>, <nayabbasha.sayed@microchip.com>,
        <balakrishnan.s@microchip.com>, <claudiu.beznea@microchip.com>,
        <cristian.birsan@microchip.com>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <linux@armlinux.org.uk>,
        <palmer@dabbelt.com>, <paul.walmsley@sifive.com>,
        <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <pabeni@redhat.com>
CC:     Durai Manickam KR <durai.manickamkr@microchip.com>
Subject: [PATCH 1/2] net: macb: Add PTP support to GEM for sama7g5
Date:   Wed, 15 Mar 2023 15:20:52 +0530
Message-ID: <20230315095053.53969-2-durai.manickamkr@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230315095053.53969-1-durai.manickamkr@microchip.com>
References: <20230315095053.53969-1-durai.manickamkr@microchip.com>
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

Add PTP capability to the Gigabit Ethernet MAC.

Signed-off-by: Durai Manickam KR <durai.manickamkr@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 6e141a8bbf43..27fc6c903d25 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4844,7 +4844,7 @@ static const struct macb_config mpfs_config = {
 
 static const struct macb_config sama7g5_gem_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_CLK_HW_CHG |
-		MACB_CAPS_MIIONRGMII,
+		MACB_CAPS_MIIONRGMII | MACB_CAPS_GEM_HAS_PTP,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
-- 
2.25.1

