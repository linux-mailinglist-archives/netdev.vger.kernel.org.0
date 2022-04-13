Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDEE04FFFA2
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 21:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237186AbiDMT4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 15:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237447AbiDMT4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 15:56:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCF35D64D;
        Wed, 13 Apr 2022 12:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649879650; x=1681415650;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ywh3+h3uP3qVZckj1zw7OyZyfOYOqj/A4ypO6SPBREQ=;
  b=Z69EQVfjKplCq4/2agQdcyZP2raNi3Mc04kBnf+n7OcGMQ8awFRKKlE1
   3fgBr33IxG3Cf4aAyFfcV6jxdaXIHIP+acbvBv654LhaWKmsnrsXexomc
   wOU1bgZ9JmLQVCiXFWchaG2Iac6sfFygQqhZZtn8EOPCeHmLiS7S/VkTz
   Sv6WQMeH9OqT/ZMEcQHTtW+Yb2eXBm4Y8K7MNUJdRh389QEbXp5w5Lqpb
   GyG6midTzUzrXJ36ijuMDg7uUR/RAi5lHoIhzXySVN4/VKms9II/zr65b
   V9fM4376+1qLwfy6kO9z6WQJ0vGwEAdrlr5OwMdAQvDZH/5MCTDEFJH4X
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,257,1643698800"; 
   d="scan'208";a="152570440"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Apr 2022 12:54:09 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 13 Apr 2022 12:54:08 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 13 Apr 2022 12:54:06 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] net: lan966x: Make sure to release ptp interrupt
Date:   Wed, 13 Apr 2022 21:57:16 +0200
Message-ID: <20220413195716.3796467-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the lan966x driver is removed make sure to remove also the ptp_irq
IRQ.

Fixes: e85a96e48e3309 ("net: lan966x: Add support for ptp interrupts")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 958e55596b82..95830e3e2b1f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -671,6 +671,9 @@ static void lan966x_cleanup_ports(struct lan966x *lan966x)
 		disable_irq(lan966x->ana_irq);
 		lan966x->ana_irq = -ENXIO;
 	}
+
+	if (lan966x->ptp_irq)
+		devm_free_irq(lan966x->dev, lan966x->ptp_irq, lan966x);
 }
 
 static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
-- 
2.33.0

