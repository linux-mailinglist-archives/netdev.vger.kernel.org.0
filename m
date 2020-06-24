Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0072070D1
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390250AbgFXKIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:08:25 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:63354 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388197AbgFXKIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 06:08:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592993304; x=1624529304;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=EAXOr3hlOs79DhO0LG4t6f90YgVucKjYFsY/876ySso=;
  b=zqAv7ZBGkFKgvOZUQxRJQVXLQHTmRI8hd1pjHWIkiHzvpVVjTRNKjM2I
   hqgiNKiPvzalUoysmGtG4cXcIzX79OVp0VOwSURKmwu6Ml2UXZU7uA4W8
   HVaYgFRhI4LCr/8Yy4Mc1sQHTlUgR5GkQvqQgxKj56Rvn2oCqwu+Nkz7I
   30a8UXf2S3CkAq0WLP6lkqaH41ltWxgkzq6PkvBusD6kjzCE8Gj4pjhG9
   T2vhm7Q/k8sIZTuMgWvP9RNIMUhFsC5M5GfNUbSnH+X1lD9PdC/Xhuafo
   ChPEEJtMfc+4FGhmfEBbSX2alWRhTxZkLqOfZQiLQ87EsNQq8IaIf92n1
   Q==;
IronPort-SDR: at+8gFFZR8EL0kg9YjGlyCXd/Rxnv9dhMLzPKAH/IucPJQ11u3Yyjb354UM/IFeUVvu30G41i5
 yuQPv7HrclnxmM3MY6lcMSjTA7OcfhRg3XUB9Etpu38uaRfiP5iv6C/PbbUXAfd4ULar+uGiv0
 49AB01xKig17adyc40dfhdwLuGOJ559xfdJ/nxFJLGcSVxTJSrA+HOfMtoBcDwBkY+sFjxhtX6
 33YNjoWA+AcKRYlappjNWI992jou1upfbF0BNKi3bXK76uUsXOzYbwWlN07UB2CGw8lRQ2UgPb
 hBA=
X-IronPort-AV: E=Sophos;i="5.75,274,1589266800"; 
   d="scan'208";a="84887829"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2020 03:08:24 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Jun 2020 03:08:11 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 24 Jun 2020 03:08:08 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <alexandre.belloni@bootlin.com>, <antoine.tenart@bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 1/2] net: macb: call pm_runtime_put_sync on failure path
Date:   Wed, 24 Jun 2020 13:08:17 +0300
Message-ID: <1592993298-26533-1-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call pm_runtime_put_sync() on failure path of at91ether_open.

Fixes: e6a41c23df0d ("net: macb: ensure interface is not suspended on at91rm9200")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---

Changes in v2:
- this patch is new in v2
- patch 2/2 in this series is based on this one

 drivers/net/ethernet/cadence/macb_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 67933079aeea..96d62d73b933 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3835,7 +3835,7 @@ static int at91ether_open(struct net_device *dev)
 
 	ret = at91ether_start(dev);
 	if (ret)
-		return ret;
+		goto pm_exit;
 
 	/* Enable MAC interrupts */
 	macb_writel(lp, IER, MACB_BIT(RCOMP)	|
@@ -3848,11 +3848,15 @@ static int at91ether_open(struct net_device *dev)
 
 	ret = macb_phylink_connect(lp);
 	if (ret)
-		return ret;
+		goto pm_exit;
 
 	netif_start_queue(dev);
 
 	return 0;
+
+pm_exit:
+	pm_runtime_put_sync(&lp->pdev->dev);
+	return ret;
 }
 
 /* Close the interface */
-- 
2.7.4

