Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340251C6F7B
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgEFLl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:41:57 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:2166 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgEFLl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:41:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588765316; x=1620301316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cg4BPRaGxfrS+/zj5AePP2N7TWIwyo2J9Tr/Whwu38k=;
  b=esXWWGUoYXKMhvWlD6oJSVv1dqgxj56qnjLhGPPXIUEWDEIOStLAwlSx
   Ryq/uWSASXfBBwByVbTbzsx5SasbJ0+MvN3loguImF6bPVqBKXGhEi87l
   6q0unMlMlOxkYkWl7dhs9pqvp6a12kQSaZTwW43XU+AYMjoEKpwxtbRoz
   oH6PRkvpbbamyTftIK04CIqiHkIZbgqUPbdqFvDXdL/qy5smPRoqah2/y
   wcV9LKRvpeV3xocGxHw8Gyhu/Xvy7ihwum43LLFf/nzz27hZig8/vGulm
   wkhHh8EHuLKqEFTl3mZIpkBX0D030rh68lDeF0sk6AAv/u6HjjNvqmQPB
   Q==;
IronPort-SDR: knYoS5+AmJ0w/4fuKWSH/HCpZ9HI9CXeWtZXpjH4z1cXRlc9VIIGG9MlTYO84n1IKNQtIwbFSe
 g2gPQVNq5lBkCVVvN/4AwplWkSpO5jaUbFlGZovKwm/wksU8RiP3GQcsBmMGAuY9pc8W0Q+Rpg
 SKJ61T0VB6ntzXnLFUQHlrmGOr74elIPn7r7UQEIfsDLxi7MoIZ78YaLo3Ek1UofO0qnz1dwlY
 7OQpAOQ4wLrinSc4+5jwTdRIguY5Ez/JMqh+BqZ4x7jgUkY9A20CILE/nIpNnyHAnurfH+O2Uz
 wHU=
X-IronPort-AV: E=Sophos;i="5.73,358,1583218800"; 
   d="scan'208";a="74979852"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 May 2020 04:41:56 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 May 2020 04:41:55 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 6 May 2020 04:41:51 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v4 1/5] net: macb: fix wakeup test in runtime suspend/resume routines
Date:   Wed, 6 May 2020 13:37:37 +0200
Message-ID: <dc30ff1d17cb5a75ddd10966eab001f67ac744ef.1588763703.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1588763703.git.nicolas.ferre@microchip.com>
References: <cover.1588763703.git.nicolas.ferre@microchip.com>
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
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 36290a8e2a84..d11fae37d46b 100644
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
2.26.2

