Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E08BC13B7
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 09:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfI2HBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 03:01:01 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:39110 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725379AbfI2HBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 03:01:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07486;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Tdh2xix_1569740448;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0Tdh2xix_1569740448)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 29 Sep 2019 15:00:58 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     xlpang@linux.alibaba.com, zhiche.yy@alibaba-inc.com,
        Wen Yang <wenyang@linux.alibaba.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: rtl8366rb: add missing of_node_put after calling of_get_child_by_name
Date:   Sun, 29 Sep 2019 15:00:47 +0800
Message-Id: <20190929070047.2515-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_node_put needs to be called when the device node which is got
from of_get_child_by_name finished using.
irq_domain_add_linear() also calls of_node_get() to increase refcount,
so irq_domain will not be affected when it is released.

fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/dsa/rtl8366rb.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index a268085..f5cc8b0 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -507,7 +507,8 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 	irq = of_irq_get(intc, 0);
 	if (irq <= 0) {
 		dev_err(smi->dev, "failed to get parent IRQ\n");
-		return irq ? irq : -EINVAL;
+		ret = irq ? irq : -EINVAL;
+		goto out_put_node;
 	}
 
 	/* This clears the IRQ status register */
@@ -515,7 +516,7 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 			  &val);
 	if (ret) {
 		dev_err(smi->dev, "can't read interrupt status\n");
-		return ret;
+		goto out_put_node;
 	}
 
 	/* Fetch IRQ edge information from the descriptor */
@@ -537,7 +538,7 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 				 val);
 	if (ret) {
 		dev_err(smi->dev, "could not configure IRQ polarity\n");
-		return ret;
+		goto out_put_node;
 	}
 
 	ret = devm_request_threaded_irq(smi->dev, irq, NULL,
@@ -545,7 +546,7 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 					"RTL8366RB", smi);
 	if (ret) {
 		dev_err(smi->dev, "unable to request irq: %d\n", ret);
-		return ret;
+		goto out_put_node;
 	}
 	smi->irqdomain = irq_domain_add_linear(intc,
 					       RTL8366RB_NUM_INTERRUPT,
@@ -553,12 +554,15 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 					       smi);
 	if (!smi->irqdomain) {
 		dev_err(smi->dev, "failed to create IRQ domain\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_put_node;
 	}
 	for (i = 0; i < smi->num_ports; i++)
 		irq_set_parent(irq_create_mapping(smi->irqdomain, i), irq);
 
-	return 0;
+out_put_node:
+	of_node_put(intc);
+	return ret;
 }
 
 static int rtl8366rb_set_addr(struct realtek_smi *smi)
-- 
1.8.3.1

