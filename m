Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B22969DCC6
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbjBUJWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbjBUJWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:22:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DA1241E5;
        Tue, 21 Feb 2023 01:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676971316; x=1708507316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0u+UdGgrstqHyAt6lfy9Z9fjXjmo2PxFj4o6q3qUG/k=;
  b=fX4QSyVS1AtQD8FtRrmV3XDOGiQ6SUn5vcMAxCSGd8LxlxO1zi9s5+CT
   axqMt60mQJsLfAPg9PvksrWsyG6f+uAuznaet/+2U6USxupnF7eROycQF
   12s8uvuSmIB4Rxf25fsONclHfeLjGHas4ejFxVfX5rSGRdJ8pWZF660dP
   KyIsiW4QsxAMzO2LbHIfKDpauR+ggULc8vFI6TTb6Gk/PAL3LOyaGhde9
   eSaLGmItP7bYH1wbFRcLUHAjxUGTzlmEf1B/Je2NzdPCNo5F+WmzsUio4
   LnZs+JWITN5UTt8N3b0MbDmvFVzrveOduTLJdw0Pl49d1D1cmf/6kIKCI
   g==;
X-IronPort-AV: E=Sophos;i="5.97,315,1669100400"; 
   d="scan'208";a="201594623"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Feb 2023 02:21:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 02:21:53 -0700
Received: from che-lt-i66125lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 02:21:43 -0700
From:   Durai Manickam KR <durai.manickamkr@microchip.com>
To:     <Hari.PrasathGE@microchip.com>,
        <balamanikandan.gunasundar@microchip.com>,
        <manikandan.m@microchip.com>, <varshini.rajendran@microchip.com>,
        <dharma.b@microchip.com>, <nayabbasha.sayed@microchip.com>,
        <balakrishnan.s@microchip.com>, <claudiu.beznea@microchip.com>,
        <cristian.birsan@microchip.com>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <linux@armlinux.org.uk>, <palmer@dabbelt.com>,
        <paul.walmsley@sifive.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>
CC:     Durai Manickam KR <durai.manickamkr@microchip.com>
Subject: [PATCH 2/2] net: macb: Add PTP support to EMAC for sama7g5
Date:   Tue, 21 Feb 2023 14:51:04 +0530
Message-ID: <20230221092104.730504-3-durai.manickamkr@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230221092104.730504-1-durai.manickamkr@microchip.com>
References: <20230221092104.730504-1-durai.manickamkr@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PTP capability to the Ethernet MAC.

Signed-off-by: Durai Manickam KR <durai.manickamkr@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 27fc6c903d25..1dbee16fe90a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4853,7 +4853,8 @@ static const struct macb_config sama7g5_gem_config = {
 
 static const struct macb_config sama7g5_emac_config = {
 	.caps = MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII |
-		MACB_CAPS_USRIO_HAS_CLKEN | MACB_CAPS_MIIONRGMII,
+		MACB_CAPS_USRIO_HAS_CLKEN | MACB_CAPS_MIIONRGMII |
+		MACB_CAPS_GEM_HAS_PTP,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
-- 
2.25.1

