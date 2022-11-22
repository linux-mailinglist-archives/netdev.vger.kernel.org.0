Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3336A634979
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiKVVkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235141AbiKVVkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:40:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE45C6620;
        Tue, 22 Nov 2022 13:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669153213; x=1700689213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hp29edLp8a8OEBxkPTP/BqxOmLMA7en3zD0HWlGqapo=;
  b=l+ORBpuVVSEyxRrgozTDrDL/P4axGNx5iPZLO+yVYCcWPPqC83k7hpFL
   tL9fA1d55V0121EDEXgafgjLyKd0fMbkRMdghgYhcFnqBpVMAM1D3sWpN
   o/uPkaGU3jAYfWySe8AJjwdq+wjHySvcwxWTRwD35EFmggPItOLExVbN2
   EylNzVmXK05zL/iidAwnWN87zRZv/W8JQqkeeq7CkSjoZnPJ9MtksOMuF
   DKQkiqS7n9KmIllLbt6yu0CqSVpqOTFkmsF2AKfLsSstX+3MUfSCKkMSk
   CLbkEf9YBXaHYa3MGiwSuU9k11YP/Rx7Rf59LBuz5Nf0zasadeDtmeo4R
   g==;
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="201008100"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 14:40:13 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 14:40:05 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 22 Nov 2022 14:40:03 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <alexandr.lobakin@intel.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 4/7] net: lan966x: Update rxq memory model
Date:   Tue, 22 Nov 2022 22:44:10 +0100
Message-ID: <20221122214413.3446006-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221122214413.3446006-1-horatiu.vultur@microchip.com>
References: <20221122214413.3446006-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
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

