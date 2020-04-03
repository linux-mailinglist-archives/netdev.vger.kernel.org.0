Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 439C219D75F
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403912AbgDCNPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:15:09 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:61887 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgDCNPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 09:15:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1585919708; x=1617455708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o8jWIah1+DuDz5Akq920QK23cXPGfG/D/AEkjbdjTfY=;
  b=12MBo+zLPoadFj69qcsCuqx4LXk4Lg8158JE+8LFnQ/V713VmRPG3/Aa
   VtTIt7JmpkUUUkoVCwF7eFb1mjqYt3tp+NwMz4NkRqaTlfNpfO5gqgBvW
   NEoiJGBgfGv7hI1C2qBlR09eEk9/4JDxPEkk10oBBlVqAzGCjw2Kn1kWI
   B2lJbSYJO/jY47Wi2mnReXXYjFYL0qmg34WO/RX6XUUyKeqs1GB7CuUAf
   xoda9KQyvgZZpwzzvgTQpt/Zs+PaM4+gGCikFn1U+Zf1sAKdms7m5+5u1
   wpJkzkeopSjiWRrlNhfziYqH8s+P9TySXCgfQ5VRNvyJHrRtZPJNSzral
   Q==;
IronPort-SDR: Y8mHCdf1WejyJmCFJxCn38Ggz+QBexElCJdKulyjFOe7vNU5u6rf9+oKtA4b5NSdmvojH+nB0U
 WZlTC6S3Nqvcbdjq4U5pF6KW1lm/l662AJdbeUvThOBbJw3PFKvUn5F+aZvxms/pRY/BzZPu50
 zjdTfyuHPjFhYBQbwz8H9TLNhhLDufE0YM+MN7R93XbAD+uhVd96XimozlMjPEnGe0oU78CBFN
 jh3OYaxA9HdlDI5aFi2hmj+LlIabdxTjAbA2htH3c3enGh0yFck1pvejuHCDn+mZkJkuOad7HS
 OVU=
X-IronPort-AV: E=Sophos;i="5.72,339,1580799600"; 
   d="scan'208";a="72230550"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Apr 2020 06:15:07 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 3 Apr 2020 06:15:07 -0700
Received: from mchp-main.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 3 Apr 2020 06:15:03 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <rafalo@cadence.com>, <sergio.prado@e-labworks.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [RFC PATCH 1/3] net: macb: fix wakeup test in runtime suspend/resume routines
Date:   Fri, 3 Apr 2020 15:14:42 +0200
Message-ID: <04a0daab049737a929fd4a144f0c79008c543c7d.1585917191.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1585917191.git.nicolas.ferre@microchip.com>
References: <cover.1585917191.git.nicolas.ferre@microchip.com>
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

Fixes: bc1109d04c39 ("net: macb: Add pm runtime support")
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Rafal Ozieblo <rafalo@cadence.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a0e8c5bbabc0..d1b4d6b6d7c8 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4616,7 +4616,7 @@ static int __maybe_unused macb_runtime_suspend(struct device *dev)
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
 
-	if (!(device_may_wakeup(&bp->dev->dev))) {
+	if (!(device_may_wakeup(dev))) {
 		clk_disable_unprepare(bp->tx_clk);
 		clk_disable_unprepare(bp->hclk);
 		clk_disable_unprepare(bp->pclk);
@@ -4632,7 +4632,7 @@ static int __maybe_unused macb_runtime_resume(struct device *dev)
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
 
-	if (!(device_may_wakeup(&bp->dev->dev))) {
+	if (!(device_may_wakeup(dev))) {
 		clk_prepare_enable(bp->pclk);
 		clk_prepare_enable(bp->hclk);
 		clk_prepare_enable(bp->tx_clk);
-- 
2.20.1

