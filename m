Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EBD687E1E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbjBBM7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbjBBM7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:59:03 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F67B8E484;
        Thu,  2 Feb 2023 04:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675342740; x=1706878740;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=09IBqS4LmrOKoAcjHwQjILLjOKkVRx2085Me/Fn628s=;
  b=xh/ILQrOOKZfZ737sSsXrL3SRW5et8xnY4qKGt1D3mVWqBeId3Hj8o2J
   RuukaqzZZWW9Nm3izAuI4DpUtgmfQdkmKEpKk0QWgZNBln1z5mMEfvFlh
   kvg5/x8j/djBZs1H0QrkWZeUnLUDXHvScHAY81Y4a35uv+90PFCsKN3pZ
   vJr/3bl6zsKdH4QdFD54GsVBesoK8lbtA0B3KTJsuC2FFMkvP7WgwKquB
   RRi5zLGyP2wpNGgrOe/DFWj6tanIB2gcmVJsbhUAeONpZW0eq7TmvfGEM
   tH6GIv1hU0yvn1+qcjtIG/KZNGnzONNUhvWGD7uRzaAFAX9y5mhqjloV7
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="198620642"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 05:58:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 05:58:54 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 05:58:50 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 05/11] net: dsa: microchip: lan937x: add shared global interrupt
Date:   Thu, 2 Feb 2023 18:29:24 +0530
Message-ID: <20230202125930.271740-6-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
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

In cascade mode interrupt line is shared among both switches.
Update global interrupt flag for shared interrupt, otherwise second
switch probe will fail with busy status.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 7062ce1749fb..adf8391dd29f 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2009,7 +2009,8 @@ static irqreturn_t ksz_irq_thread_fn(int irq, void *dev_id)
 	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
 }
 
-static int ksz_irq_common_setup(struct ksz_device *dev, struct ksz_irq *kirq)
+static int ksz_irq_common_setup(struct ksz_device *dev, struct ksz_irq *kirq,
+				unsigned long flag)
 {
 	int ret, n;
 
@@ -2025,7 +2026,7 @@ static int ksz_irq_common_setup(struct ksz_device *dev, struct ksz_irq *kirq)
 		irq_create_mapping(kirq->domain, n);
 
 	ret = request_threaded_irq(kirq->irq_num, NULL, ksz_irq_thread_fn,
-				   IRQF_ONESHOT, kirq->name, kirq);
+				   flag, kirq->name, kirq);
 	if (ret)
 		goto out;
 
@@ -2048,7 +2049,7 @@ static int ksz_girq_setup(struct ksz_device *dev)
 
 	girq->irq_num = dev->irq;
 
-	return ksz_irq_common_setup(dev, girq);
+	return ksz_irq_common_setup(dev, girq, (IRQF_ONESHOT | IRQF_SHARED));
 }
 
 static int ksz_pirq_setup(struct ksz_device *dev, u8 p)
@@ -2064,7 +2065,7 @@ static int ksz_pirq_setup(struct ksz_device *dev, u8 p)
 	if (pirq->irq_num < 0)
 		return pirq->irq_num;
 
-	return ksz_irq_common_setup(dev, pirq);
+	return ksz_irq_common_setup(dev, pirq, IRQF_ONESHOT);
 }
 
 static int ksz_setup(struct dsa_switch *ds)
-- 
2.34.1

