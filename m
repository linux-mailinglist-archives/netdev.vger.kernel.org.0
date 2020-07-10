Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAC721B561
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgGJMra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:47:30 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:50532 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgGJMr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:47:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594385247; x=1625921247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LAboS01sDMUr2hIzOB5JCAVYKTW4PFCO3EQWiwSvIXo=;
  b=oOL4ijxBTJhQlEKPLTWOgO7kq1bveOL4z7F6vivAVJtFgSjMPDn5qsRg
   oYj4VDIsag5Zr7tBVjZseCind3Sw976C2BZwlOoWE53AoD5sVXM3oq6wQ
   MAXTsAtIYOGugbWdnxyV6qsQp2R0+TZXCrObyWxmmI44GG8oDcSOfThUc
   KqAGp0LlA4kFwIyHSSnUwN3Q0TY5P4kh+3bk8nnS2omVNReTB+HIvyM2p
   /mFNOR2YhIM/JcnWvuG6m6se/7rmQGQH4+wI4y4h7wpFOVcaDmf22ce0n
   nrXsI/ls/r6+f9tT79vUFbnIG99qKZD3DN/RqvVLAT3vA84rgEC206bJ3
   g==;
IronPort-SDR: hFcQnaWCLTr6DrUAL8L0pmv0mceNMbvloToGxr3RyABt2fhLzL3AF2V8KSwJfGizBhQH34NSuL
 61kQRIMTvSYpdMbYTaqxW9C6/vCv7nKH+gkxb8BdarIlqbd0s77LVCspodpasMfvC1hUVn3nLj
 ekhoT+zHcmZLy+ROCDbX+8DsNEovmZq3VsjSF9r0kRiwAXbqk+xXsWbIolcHNNenEHww9TOxUj
 2haHk5R4udQ3vuLKYb/YkdJbKLg5s4G+sS9JFcFxfsmqGmETBn8G4O0MNgr9LBEm3BrR+mijE2
 Y4A=
X-IronPort-AV: E=Sophos;i="5.75,335,1589266800"; 
   d="scan'208";a="83305778"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jul 2020 05:47:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 10 Jul 2020 05:46:58 -0700
Received: from ness.mchp-main.com (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 10 Jul 2020 05:47:22 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux@armlinux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <netdev@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>, <f.fainelli@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v5 1/5] net: macb: fix wakeup test in runtime suspend/resume routines
Date:   Fri, 10 Jul 2020 14:46:41 +0200
Message-ID: <ca0f11de3b574c293fa79e01e4eb31514b6c7233.1594384335.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1594384335.git.nicolas.ferre@microchip.com>
References: <cover.1594384335.git.nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

Use the proper struct device pointer to check if the wakeup flag
and wakeup source are positioned.
Use the one passed by function call which is equivalent to
&bp->dev->dev.parent.

It's preventing the trigger of a spurious interrupt in case the
Wake-on-Lan feature is used.

Fixes: d54f89af6cc4 ("net: macb: Add pm runtime support")
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 52582e8ed90e..55e680f35022 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4654,7 +4654,7 @@ static int __maybe_unused macb_runtime_suspend(struct device *dev)
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
 
-	if (!(device_may_wakeup(&bp->dev->dev))) {
+	if (!(device_may_wakeup(dev))) {
 		clk_disable_unprepare(bp->tx_clk);
 		clk_disable_unprepare(bp->hclk);
 		clk_disable_unprepare(bp->pclk);
@@ -4670,7 +4670,7 @@ static int __maybe_unused macb_runtime_resume(struct device *dev)
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
 
-	if (!(device_may_wakeup(&bp->dev->dev))) {
+	if (!(device_may_wakeup(dev))) {
 		clk_prepare_enable(bp->pclk);
 		clk_prepare_enable(bp->hclk);
 		clk_prepare_enable(bp->tx_clk);
-- 
2.27.0

