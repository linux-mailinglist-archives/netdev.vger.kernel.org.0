Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F85E4CF7FD
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 10:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbiCGJvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 04:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240130AbiCGJul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 04:50:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE83E580DC;
        Mon,  7 Mar 2022 01:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646646252; x=1678182252;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t1EMdVJwdiI+4gitl26rWQ8FnKctChc55HcSnXgXKJ0=;
  b=2WxYTZJcy7Ev8WibqC6htR6efbYcFiuZwIChZ2JU6+AqrNQhKSCB0+GL
   gtS3sg3Q+HzaB11e9tU8K/y2VomcvVj+eFa/FCqLSHFLGBm4yGOqcL05z
   dFTTuDteCDAi+bE+zqYNIfbYMTm3VdjnXWHvr+eUdouIDwsCaBoemXN/A
   qEcVZjIOcYfXRhJ79LI62oM/DJdOHCJDWuqO+xtOHDbALgX179fcdtJ5D
   w3dFeW4qVm8oifhpajQjtM1z5qZL8CrMY2rEoZuhSHvLurd8S3DbAVP6o
   lWQiGEeP216mPFFlxo30mrbBLsCAAlyXeA/VMDSDuybICUkUbyYWmFI/+
   g==;
X-IronPort-AV: E=Sophos;i="5.90,161,1643698800"; 
   d="scan'208";a="88043343"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2022 02:44:00 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 7 Mar 2022 02:44:00 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 7 Mar 2022 02:43:58 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: allow offloading timestamp operations to the PHY
Date:   Mon, 7 Mar 2022 10:46:32 +0100
Message-ID: <20220307094632.3764266-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case the MAC is using 'netif_rx()' to deliver the skb up the network
stack, it needs to check whether 'skb_defer_rx_timestmap()' is necessary
or not. In case is needed then don't call 'netif_rx()'

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index ad310c95bf5c..750f2cc2f695 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -600,7 +600,9 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
 				skb->offload_fwd_mark = 0;
 		}
 
-		netif_rx(skb);
+		if (!skb_defer_rx_timestamp(skb))
+			netif_rx(skb);
+
 		dev->stats.rx_bytes += len;
 		dev->stats.rx_packets++;
 
-- 
2.33.0

