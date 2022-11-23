Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7EB636B3B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbiKWUbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238741AbiKWUbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:31:07 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF1DB10F7;
        Wed, 23 Nov 2022 12:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669235241; x=1700771241;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pWVoZuA9xcBmenmRK/OP8iGGWQfHK7Ad96W2VsNa5VM=;
  b=fZekmFF8LGLxoBP1zD3mI0Iy3aZ8Njxa6WlsD6rqryp9L8/m+fjqqQo5
   Zo6pQqaegooELe/nYb46v45CZ88oGZGreeoAeMP9ZZJgbi6G5fzdspgpj
   cLWMOxQ++RYI3d52pW1BwQwUboICgKRGXHE9uYLk6Se28UpiFMOdLyVfU
   J3HkISU4drHrV5ENo2sYk6BHjXkhVCmNMK7oa32+vjqOMR7sT7MvqZEJY
   7PrpWJE0ISGrbDAl8kiYxe494D+ZZCjFjqvPW/Zk8r5r/PZIH4pIQKtH5
   h/vvhfCLwNeZqvnnCYz2SHKBv2SCF2iOzSecpWj9FaHPO0uK+ILzOIWnS
   A==;
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="124842468"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 13:27:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 13:27:18 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 23 Nov 2022 13:27:15 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <alexandr.lobakin@intel.com>,
        <maciej.fijalkowski@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 4/7] net: lan966x: Update rxq memory model
Date:   Wed, 23 Nov 2022 21:31:36 +0100
Message-ID: <20221123203139.3828548-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123203139.3828548-1-horatiu.vultur@microchip.com>
References: <20221123203139.3828548-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default the rxq memory model is MEM_TYPE_PAGE_SHARED but to be able
to reuse pages on the TX side, when the XDP action XDP_TX it is required
to update the memory model to PAGE_POOL.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c   | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 384ed34197d58..3df3b3d29b4ff 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -80,6 +80,19 @@ static int lan966x_fdma_rx_alloc_page_pool(struct lan966x_rx *rx)
 	};
 
 	rx->page_pool = page_pool_create(&pp_params);
+
+	for (int i = 0; i < lan966x->num_phys_ports; ++i) {
+		struct lan966x_port *port;
+
+		if (!lan966x->ports[i])
+			continue;
+
+		port = lan966x->ports[i];
+		xdp_rxq_info_unreg_mem_model(&port->xdp_rxq);
+		xdp_rxq_info_reg_mem_model(&port->xdp_rxq, MEM_TYPE_PAGE_POOL,
+					   rx->page_pool);
+	}
+
 	return PTR_ERR_OR_ZERO(rx->page_pool);
 }
 
-- 
2.38.0

