Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2B9632EBF
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiKUVZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiKUVY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:24:56 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A5CB9614;
        Mon, 21 Nov 2022 13:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669065889; x=1700601889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hp29edLp8a8OEBxkPTP/BqxOmLMA7en3zD0HWlGqapo=;
  b=Zoo45D5A+MyMUQYePz6R1z0eh/iC4zAt+Tcj59p70gWJpuQPO5dgi7RR
   wQBAjmi1K+ec9kr+HwHU6uOVRJLkrTjrMzcNNsQq1tctuyvABjrHPmgL0
   SrJOq6bKDGS7gXmO5WrcCHjmSjOox9opgVsNNmeDDq7WRcBhg7hACd2vj
   eZEDIoG8J2r7ToCfPwvwy71VlKXGF5jMJZ69pzgKxfX1Wu6FwIYHWkyiy
   Oh65mDvabM3wcXmAhrcmLlGJT95+rknHLE0E4D4sViH2QOswZ0+aD2aIQ
   7ClX5oRxy4eQxj1ztlyZpCBoQVs7rvOiXk9ZPptb9ClsloeCyIypu5Z26
   w==;
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="124468641"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Nov 2022 14:24:45 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 21 Nov 2022 14:24:44 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 21 Nov 2022 14:24:41 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 4/7] net: lan966x: Update rxq memory model
Date:   Mon, 21 Nov 2022 22:28:47 +0100
Message-ID: <20221121212850.3212649-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221121212850.3212649-1-horatiu.vultur@microchip.com>
References: <20221121212850.3212649-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
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
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 384ed34197d58..483d1470c8362 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -78,8 +78,22 @@ static int lan966x_fdma_rx_alloc_page_pool(struct lan966x_rx *rx)
 		.max_len = rx->max_mtu -
 			   SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
 	};
+	struct lan966x_port *port;
+	int i;
 
 	rx->page_pool = page_pool_create(&pp_params);
+
+	for (i = 0; i < lan966x->num_phys_ports; ++i) {
+		if (!lan966x->ports[i])
+			continue;
+
+		port = lan966x->ports[i];
+
+		xdp_rxq_info_unreg_mem_model(&port->xdp_rxq);
+		xdp_rxq_info_reg_mem_model(&port->xdp_rxq, MEM_TYPE_PAGE_POOL,
+					   rx->page_pool);
+	}
+
 	return PTR_ERR_OR_ZERO(rx->page_pool);
 }
 
-- 
2.38.0

